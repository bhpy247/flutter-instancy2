import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_instancy_2/backend/app/app_controller.dart';
import 'package:flutter_instancy_2/models/download/request_model/flutter_download_request_model.dart';
import 'package:flutter_instancy_2/models/download/response_model/flutter_download_response_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:xml/xml.dart';

typedef DownloadStartCallback = void Function({required String taskId});
typedef DownloadUpdateCallback = void Function({required String taskId, required FlutterDownloadResponseModel responseModel});

class FlutterDownloadController {
  static const String DOWNLOAD_ISOLATE_NAME = "downloader_isolate";
  static bool isInitializedPlugin = false;
  static bool isInitializedListeners = false;
  static ReceivePort? _port;
  static StreamSubscription? _downloadListeningSubscription;
  static StreamController<FlutterDownloadResponseModel>? downloadResponseStreamController;

  // region Initializations
  static Future<void> initializePlugin() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("FlutterDownloadController.initializePlugin() called", tag: tag);

    if (isInitializedPlugin) {
      MyPrint.printOnConsole("Returning from FlutterDownloadController.initializePlugin() because already initialized", tag: tag);
      return;
    }

    if (kIsWeb) {
      MyPrint.printOnConsole("Returning from FlutterDownloadController.initializePlugin() because it is web platform", tag: tag);
      return;
    }

    try {
      await FlutterDownloader.initialize(
        debug: true,
        ignoreSsl: true,
      );
      isInitializedPlugin = true;

      MyPrint.printOnConsole("FlutterDownload Plugin Initialized Successfully", tag: tag);
    } catch (e, s) {
      MyPrint.printOnConsole("Error in FlutterDownloadController.initializePlugin():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      isInitializedPlugin = false;
    }
  }

  static Future<void> initializeListeners() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("FlutterDownloadController.initializeListeners() called", tag: tag);

    if (isInitializedListeners) {
      MyPrint.printOnConsole("Returning from FlutterDownloadController.initializeListeners() because already initialized", tag: tag);
      return;
    }

    if (!isInitializedPlugin) {
      MyPrint.printOnConsole("Returning from FlutterDownloadController.initializeListeners() because plugin not initialized", tag: tag);
      return;
    }

    if (kIsWeb) {
      MyPrint.printOnConsole("Returning from FlutterDownloadController.initializeListeners() because it is web platform", tag: tag);
      return;
    }

    try {
      downloadResponseStreamController?.close();
      downloadResponseStreamController = StreamController<FlutterDownloadResponseModel>.broadcast();
      _downloadListeningSubscription?.cancel();
      _port?.close();
      ReceivePort receivePort = ReceivePort("FlutterDownloadController");

      bool isUnregisteredDownloadCoursePort = IsolateNameServer.removePortNameMapping(DOWNLOAD_ISOLATE_NAME);
      MyPrint.printOnConsole("isUnregisteredDownloadCoursePort:$isUnregisteredDownloadCoursePort", tag: tag);

      bool isRegistered = IsolateNameServer.registerPortWithName(receivePort.sendPort, DOWNLOAD_ISOLATE_NAME);
      MyPrint.printOnConsole("Is Download Port Registered:$isRegistered", tag: tag);

      _downloadListeningSubscription = receivePort.listen((dynamic data) {
        MyPrint.printOnConsole("download data:$data", tag: tag);

        if (data is! List || data.length != 3) return;

        String taskId = ParsingHelper.parseStringMethod(data.elementAtOrNull(0));
        DownloadTaskStatus status = DownloadTaskStatus.fromInt(ParsingHelper.parseIntMethod(data.elementAtOrNull(1)));
        int progress = ParsingHelper.parseIntMethod(data.elementAtOrNull(2));

        FlutterDownloadResponseModel responseModel = FlutterDownloadResponseModel(
          id: taskId,
          status: status,
          progress: progress,
        );
        downloadResponseStreamController?.add(responseModel);
      });

      _port = receivePort;

      await FlutterDownloader.registerCallback(_downloadCallback, step: 100);
      isInitializedListeners = true;

      MyPrint.printOnConsole("FlutterDownload Listeners Initialized Successfully", tag: tag);
    } catch (e, s) {
      MyPrint.printOnConsole("Error in FlutterDownloadController.initializeListeners():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      isInitializedListeners = false;
    }
  }

  @pragma('vm:entry-point')
  static void _downloadCallback(String taskId, int status, int progress) {
    MyPrint.printOnConsole("downloadCallback called for TaskId:$taskId, DownloadStatus:$status, Progress:$progress}");

    try {
      SendPort? downloadSendPort = IsolateNameServer.lookupPortByName(DOWNLOAD_ISOLATE_NAME);
      MyPrint.printOnConsole("DOWNLOAD_COURSE_ISOLATE_NAME SendPort:$downloadSendPort");
      downloadSendPort?.send([taskId, status, progress]);
    } catch (e, s) {
      MyPrint.printOnConsole("Error in Sending Data to DOWNLOAD_COURSE_ISOLATE_NAME Port in FlutterDownloader downloadCallback:$e");
      MyPrint.printOnConsole(s);
    }
  }

  // endregion

  Future<({String? taskId, Stream<FlutterDownloadResponseModel>? downloadStream})> downloadFileWithGetStream({required FlutterDownloadRequestModel requestModel, BuildContext? context}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("FlutterDownloadController.downloadFileWithGetStream() called with requestModel:$requestModel", tag: tag);

    ({String? taskId, Stream<FlutterDownloadResponseModel>? downloadStream}) response = (taskId: null, downloadStream: null);

    if (!isInitializedPlugin) {
      MyPrint.printOnConsole("Returning from FlutterDownloadController.downloadFileWithGetStream() because plugin not initialized", tag: tag);
      if (context != null && context.mounted) MyToast.showError(context: context, msg: "Plugin Not Initialized");
      return response;
    }

    if (!isInitializedListeners) {
      MyPrint.printOnConsole("Returning from FlutterDownloadController.downloadFileWithGetStream() because Listeners not initialized", tag: tag);
      if (context != null && context.mounted) MyToast.showError(context: context, msg: "Listeners Not Initialized");
      return response;
    }

    if (requestModel.downloadUrl.isEmpty) {
      MyPrint.printOnConsole("Returning from FlutterDownloadController.downloadFileWithGetStream() because downloadUrl is empty", tag: tag);
      if (context != null && context.mounted) MyToast.showError(context: context, msg: "Invalid Download Url");
      return response;
    }

    if (requestModel.destinationFolderPath.isEmpty) {
      MyPrint.printOnConsole("Returning from FlutterDownloadController.downloadFileWithGetStream() because destinationFolderPath is empty", tag: tag);
      if (context != null && context.mounted) MyToast.showError(context: context, msg: "Save Directory Not Defined");
      return response;
    }

    if (requestModel.fileName.isEmpty) {
      MyPrint.printOnConsole("Returning from FlutterDownloadController.downloadFileWithGetStream() because fileName is empty", tag: tag);
      if (context != null && context.mounted) MyToast.showError(context: context, msg: "File Name Not Defined");
      return response;
    }

    try {
      String destinationFilePath = "${requestModel.destinationFolderPath}${AppController.getPathSeparator() ?? "/"}${requestModel.fileName}";

      try {
        bool fileExist = await File(destinationFilePath).exists();
        MyPrint.printOnConsole("File Exist:$fileExist", tag: tag);
        if (fileExist) {
          await File(destinationFilePath).delete(recursive: true);
        }
      } catch (e, s) {
        MyPrint.printOnConsole("Error in Deleting File at path we are downloading:$e", tag: tag);
        MyPrint.printOnConsole(s, tag: tag);
      }

      try {
        Directory savedDir = Directory(requestModel.destinationFolderPath);

        bool directoryExist = await savedDir.exists();
        MyPrint.printOnConsole("Directory Exist:$directoryExist", tag: tag);

        if (directoryExist) {
          MyPrint.printOnConsole("Deleting Directory", tag: tag);
          await savedDir.delete(recursive: true);
        }

        savedDir = await savedDir.create(recursive: true);
      } catch (e, s) {
        MyPrint.printOnConsole("Error in Creating Directory at path we are downloading:$e", tag: tag);
        MyPrint.printOnConsole(s, tag: tag);
      }

      MyPrint.printOnConsole("Download Url:'${requestModel.downloadUrl}'", tag: tag);
      MyPrint.printOnConsole("destinationFilePath:'$destinationFilePath'", tag: tag);

      String? taskId = await FlutterDownloader.enqueue(
        url: requestModel.downloadUrl,
        savedDir: requestModel.destinationFolderPath,
        fileName: requestModel.fileName,
        requiresStorageNotLow: requestModel.requiresStorageNotLow,
        showNotification: requestModel.showNotification,
        openFileFromNotification: requestModel.openFileFromNotification,
      );
      MyPrint.printOnConsole("Task Id:$taskId", tag: tag);

      if (taskId.checkEmpty) {
        MyPrint.printOnConsole("Returning from FlutterDownloadController.downloadFileWithGetStream() because couldn't initialize download task", tag: tag);
        if (context != null && context.mounted) MyToast.showError(context: context, msg: "Download couldn't start");
        return response;
      }

      if (downloadResponseStreamController == null) {
        MyPrint.printOnConsole("Returning from FlutterDownloadController.downloadFileWithGetStream() because listeners not initialized", tag: tag);
        if (context != null && context.mounted) MyToast.showError(context: context, msg: "Listeners not initialized");
        FlutterDownloader.cancel(taskId: taskId!);
        return response;
      }

      response = (taskId: taskId, downloadStream: downloadResponseStreamController!.stream);

      return response;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in FlutterDownloadController.downloadFileWithGetStream():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return response;
    }
  }

  Future<bool> downloadFile({
    required FlutterDownloadRequestModel requestModel,
    BuildContext? context,
    DownloadStartCallback? downloadStartCallback,
    DownloadUpdateCallback? downloadUpdateCallback,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("FlutterDownloadController.downloadFile() called with requestModel:$requestModel", tag: tag);

    ({String? taskId, Stream<FlutterDownloadResponseModel>? downloadStream}) response = await downloadFileWithGetStream(requestModel: requestModel, context: context);
    MyPrint.printOnConsole("response:$response", tag: tag);

    if (response.taskId.checkEmpty || response.downloadStream == null) {
      MyPrint.printOnConsole("Returning from FlutterDownloadController.downloadFile() because download couldn't start", tag: tag);
      return false;
    }

    if (downloadStartCallback != null) {
      downloadStartCallback(taskId: response.taskId!);
    }

    try {
      Completer<bool> completer = Completer<bool>();

      StreamSubscription<FlutterDownloadResponseModel> subscription = response.downloadStream!.listen(
        (FlutterDownloadResponseModel responseModel) {
          if (responseModel.id != response.taskId) {
            return;
          }

          MyPrint.printOnConsole("downloadStream response:$responseModel", tag: tag);

          if (responseModel.status == DownloadTaskStatus.canceled) {
            completer.complete(false);
          } else if (responseModel.status == DownloadTaskStatus.complete) {
            completer.complete(true);
          } else if (responseModel.status == DownloadTaskStatus.failed) {
            completer.complete(false);
          } else if (responseModel.status == DownloadTaskStatus.paused) {
          } else if (responseModel.status == DownloadTaskStatus.running) {
          } else if (responseModel.status == DownloadTaskStatus.undefined) {
          } else if (responseModel.status == DownloadTaskStatus.enqueued) {}

          if (downloadUpdateCallback != null) {
            downloadUpdateCallback(taskId: response.taskId!, responseModel: responseModel);
          }
        },
      );

      bool isDownloaded = await completer.future;
      subscription.cancel();

      MyPrint.printOnConsole("isDownloaded:$isDownloaded", tag: tag);

      return isDownloaded;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in FlutterDownloadController.downloadFile():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);

      return false;
    }
  }

  Future<bool> cancelDownload({required String taskId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("FlutterDownloadController.cancelDownload() called with taskId:'$taskId'", tag: tag);

    try {
      await FlutterDownloader.cancel(taskId: taskId);

      MyPrint.printOnConsole("cancelDownload initiated taskId:'$taskId'", tag: tag);
      return true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in FlutterDownloadController.cancelDownload():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);

      return false;
    }
  }

  Future<bool> pauseDownload({required String taskId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("FlutterDownloadController.pauseDownload() called with taskId:'$taskId'", tag: tag);

    try {
      await FlutterDownloader.pause(taskId: taskId);

      MyPrint.printOnConsole("pauseDownload initiated taskId:'$taskId'", tag: tag);
      return true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in FlutterDownloadController.pauseDownload():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);

      return false;
    }
  }

  Future<String?> resumeDownload({required String taskId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("FlutterDownloadController.resumeDownload() called with taskId:'$taskId'", tag: tag);

    try {
      String? newTaskId = await FlutterDownloader.resume(taskId: taskId);

      MyPrint.printOnConsole("resumeDownload initiated for taskId '$taskId' with newTaskId:'$newTaskId'", tag: tag);
      return newTaskId;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in FlutterDownloadController.resumeDownload():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);

      return null;
    }
  }

  Future<bool> extractZipFile({required String destinationFolderPath, required String zipFilePath, Function(int totalOperationsCount)? onFileOperation}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("FlutterDownloadController().extractZipFile() Called For destinationFolderPath:'$destinationFolderPath', zipFilePath:'$zipFilePath'", tag: tag);

    if (zipFilePath.isEmpty) {
      MyPrint.printOnConsole("Returning from FlutterDownloadController().extractZipFile() because zipFilePath is empty", tag: tag);
      return false;
    }

    File zipFile = File(zipFilePath);

    if (!(await zipFile.exists())) {
      MyPrint.printOnConsole("Returning from FlutterDownloadController().extractZipFile() because zipFile not exist", tag: tag);
      return false;
    }

    String pathSeparator = AppController.getPathSeparator() ?? "/";

    final Directory destinationDir = Directory(destinationFolderPath);
    await destinationDir.create(recursive: true);
    try {
      List<String> jwFileUrls = <String>[];

      // Read the Zip newFile from disk.
      final Uint8List bytes = zipFile.readAsBytesSync();

      // Decode the Zip newFile
      final Archive archive = ZipDecoder().decodeBytes(bytes);

      //String lastFolderPath = "";

      int totalOperations = 1 + archive.length;

      // Extract the contents of the Zip archive to disk.
      for (final file in archive) {
        final filename = file.name;
        MyPrint.printOnConsole("IsFile:${file.isFile}, Path:${file.name}", tag: tag);
        if (file.isFile) {
          final data = file.content as List<int>;
          File newFile = File("$destinationFolderPath/$filename");
          try {
            newFile = await newFile.create(recursive: true);
          } catch (e, s) {
            MyPrint.printOnConsole("Error in Creating File in FlutterDownloadController().extractZipFile():$e", tag: tag);
            MyPrint.printOnConsole(s, tag: tag);
          }
          try {
            newFile = await newFile.writeAsBytes(data);
          } catch (e, s) {
            MyPrint.printOnConsole("Error in Writing in File in FlutterDownloadController().extractZipFile():$e", tag: tag);
            MyPrint.printOnConsole(s, tag: tag);
          }

          if (filename == 'jwvideoslist.xml') {
            MyPrint.printOnConsole("Having JW Videos To Download", tag: tag);
            String fileData = await newFile.readAsString();
            final document = XmlDocument.parse(fileData);
            List<XmlElement> elements = document.findAllElements('jwvideo').toList();
            for (final element in elements) {
              String jwFileUrl = element.innerText;
              Uri? uri = Uri.tryParse(jwFileUrl);
              if (uri != null) {
                jwFileUrls.add(jwFileUrl);
              }
            }
          }
        } else {
          //lastFolderPath = file.name;
          try {
            await Directory("$destinationFolderPath$pathSeparator$filename").create(recursive: true);
          } catch (e, s) {
            MyPrint.printOnConsole("Error in Creating Directory in FlutterDownloadController().extractZipFile():$e", tag: tag);
            MyPrint.printOnConsole(s, tag: tag);
          }
        }
        if (onFileOperation != null) {
          onFileOperation(totalOperations);
        }
      }

      /// If the course contains videos, start a new process to download those videos
      /// These videos are saved in the same destination folder path under a `jwvideos` sub-folder
      MyPrint.printOnConsole("Final jwFileUrls:$jwFileUrls", tag: tag);
      if (jwFileUrls.isNotEmpty) {
        MyPrint.printOnConsole("Downloading jwFiles", tag: tag);

        bool isJWFilesDownloaded = await _downloadJWFiles(
          jwFileUrls: jwFileUrls,
          destinationFolderPath: "$destinationFolderPath${pathSeparator}jwvideos",
        );
        MyPrint.printOnConsole("isJWFilesDownloaded:$isJWFilesDownloaded", tag: tag);
      }

      try {
        await zipFile.delete(recursive: true);
      } catch (e, s) {
        MyPrint.printOnConsole("Error in Deleting Zip File in FlutterDownloadController().extractZipFile():$e", tag: tag);
        MyPrint.printOnConsole(s, tag: tag);
      }
      if (onFileOperation != null) {
        onFileOperation(totalOperations);
      }

      return true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in Extracting File:$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return false;
    }
  }

  Future<bool> _downloadJWFiles({required List<String> jwFileUrls, required String destinationFolderPath}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("FlutterDownloadController._downloadJWFiles() called with jwFileUrls:'$jwFileUrls', destinationFolderPath:'$destinationFolderPath'", tag: tag);

    bool isDownloaded = false;

    String pathSeparator = AppController.getPathSeparator() ?? "/";

    try {
      Directory videoDirectory = await Directory(destinationFolderPath).create(recursive: true);

      List<Future> futures = <Future>[];
      int totalDownloads = 0;
      int completedDownloads = 0;

      for (String url in jwFileUrls) {
        List<String> splitUrl = url.split('/');
        if (splitUrl.isEmpty) {
          continue;
        }

        String fileName = splitUrl.last;
        String filePath = '${videoDirectory.path}$pathSeparator$fileName';

        MyPrint.printOnConsole("Downloading JW File From Url:'$url' On Path:'$filePath'", tag: tag);

        totalDownloads++;
        futures.add(
          downloadFile(
            requestModel: FlutterDownloadRequestModel(
              downloadUrl: url,
              destinationFolderPath: destinationFolderPath,
              fileName: fileName,
            ),
          ).then((bool isDownloaded) {
            MyPrint.printOnConsole("isDownloaded JW File From Url:'$url' On Path:'$filePath':$isDownloaded", tag: tag);

            completedDownloads++;
          }).catchError((e, s) {
            MyPrint.printOnConsole("Error in Downloading JW File From Url:'$url' On Path:'$filePath'", tag: tag);
            MyPrint.printOnConsole(s, tag: tag);
          }),
        );
      }

      if (futures.isNotEmpty) await Future.wait(futures);

      MyPrint.printOnConsole("totalDownloads:$totalDownloads, completedDownloads:$completedDownloads", tag: tag);

      isDownloaded = true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in Downloading JW Files in FlutterDownloadController().extractZipFile():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    return isDownloaded;
  }
}
