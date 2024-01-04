import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/api/api_url_configuration_provider.dart';
import 'package:flutter_instancy_2/backend/app/app_controller.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_provider.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_repository.dart';
import 'package:flutter_instancy_2/backend/download/flutter_download_controller.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation_controller.dart';
import 'package:flutter_instancy_2/backend/ui_actions/my_learning/my_learning_ui_action_configs.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/models/course_download/data_model/course_download_data_model.dart';
import 'package:flutter_instancy_2/models/download/request_model/flutter_download_request_model.dart';
import 'package:flutter_instancy_2/models/download/response_model/flutter_download_response_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:permission_handler/permission_handler.dart';

class CourseDownloadController {
  final AppProvider appProvider;
  late CourseDownloadProvider _courseDownloadProvider;
  late CourseDownloadRepository _courseDownloadRepository;

  static bool isDownloadModuleEnabled = false;

  CourseDownloadController({required this.appProvider, required CourseDownloadProvider? courseDownloadProvider, CourseDownloadRepository? courseDownloadRepository, ApiController? apiController}) {
    _courseDownloadProvider = courseDownloadProvider ?? CourseDownloadProvider();
    _courseDownloadRepository = courseDownloadRepository ?? CourseDownloadRepository(apiController: apiController ?? ApiController());
  }

  CourseDownloadProvider get courseDownloadProvider => _courseDownloadProvider;

  CourseDownloadRepository get courseDownloadRepository => _courseDownloadRepository;

  // region Course Download
  // https://instancylivesites.blob.core.windows.net/upgradedenterprise/content/publishfiles/f35af8f3-28a8-4fd7-8102-9da5f80fd86a/acting%20skills.pdf?fromNativeapp=true
  // /storage/emulated/0/Android/data/com.instancy.upgradedenterpriseapp/files/.Mydownloads/Contentdownloads/f35af8f3-28a8-4fd7-8102-9da5f80fd86a-389/acting skills.pdf

  Future<void> downloadCourse({required CourseDTOModel courseDTOModel, String parentEventTrackId = "", String parentEventTrackName = "", CourseDTOModel? trackModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadController().downloadCourse() called for ContentId:${courseDTOModel.ContentID}", tag: tag);

    CourseDownloadProvider downloadProvider = courseDownloadProvider;

    if (!MyLearningUIActionConfigs.isContentTypeDownloadable(objectTypeId: courseDTOModel.ContentTypeId, mediaTypeId: courseDTOModel.MediaTypeID)) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().getCourseDownloadUrl() because Content Not Downloadable", tag: tag);
      return;
    }

    if (kIsWeb) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().downloadCourse() because It is Web Platform", tag: tag);
      return;
    }

    if (!(await isDownloadPermissionGranted())) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().downloadCourse() because Download Permission Not Granted", tag: tag);
      return;
    }

    ({String downloadUrl, bool isZipFile}) courseDownloadUrlResponse = getCourseDownloadUrl(courseDTOModel: courseDTOModel);
    MyPrint.printOnConsole("courseDownloadUrl:'${courseDownloadUrlResponse.downloadUrl}'", tag: tag);
    MyPrint.printOnConsole("isZipFile:${courseDownloadUrlResponse.isZipFile}", tag: tag);

    if (courseDownloadUrlResponse.downloadUrl.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().downloadCourse() because courseDownloadUrl is empty", tag: tag);
      return;
    }

    String folderPath = await getCourseDownloadDirectoryPath(courseDTOModel: courseDTOModel, parentEventTrackId: parentEventTrackId);
    MyPrint.printOnConsole("downloadFolderPath:'$folderPath'", tag: tag);

    String fileName = getCourseDownloadFileName(courseDTOModel: courseDTOModel);
    MyPrint.printOnConsole("fileName:'$fileName'", tag: tag);

    if (folderPath.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().downloadCourse() because downloadFolderPath is empty", tag: tag);
      return;
    } else if (fileName.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().downloadCourse() because downloadFileName is empty", tag: tag);
      return;
    }

    FlutterDownloadRequestModel requestModel = FlutterDownloadRequestModel(
      downloadUrl: courseDownloadUrlResponse.downloadUrl,
      destinationFolderPath: folderPath,
      fileName: fileName,
    );

    ({String? taskId, Stream<FlutterDownloadResponseModel>? downloadStream}) response = await FlutterDownloadController().downloadFileWithGetStream(
      requestModel: requestModel,
      context: NavigationController.mainNavigatorKey.currentContext,
    );

    if (response.taskId.checkEmpty || response.downloadStream == null) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().downloadCourse() because download couldn't start", tag: tag);
      return;
    }

    String downloadId = CourseDownloadDataModel.getDownloadId(contentId: courseDTOModel.ContentID, eventTrackContentId: parentEventTrackId);

    CourseDownloadDataModel courseDownloadDataModel = CourseDownloadDataModel(
      id: downloadId,
      contentId: courseDTOModel.ContentID,
      courseDTOModel: courseDTOModel,
      eventTrackContentId: parentEventTrackId,
      eventTrackContentName: parentEventTrackName,
      taskId: response.taskId!,
      trackModel: trackModel,
      downloadFileUrl: courseDownloadUrlResponse.downloadUrl,
      downloadFileDirectoryPath: folderPath,
      downloadFileName: fileName,
      downloadFilePath: "$folderPath${AppController.getPathSeparator() ?? "/"}$fileName",
      isZip: courseDownloadUrlResponse.isZipFile,
      isEventTrackContent: parentEventTrackId.isNotEmpty,
      isFileDownloading: true,
      downloadStatus: DownloadTaskStatus.running,
      isCourseDownloading: true,
    );
    addNewCourseDownload(courseDownloadDataModel: courseDownloadDataModel);

    ({bool isDownloaded, bool isDownloadCanceled}) watchDownloadProcessResponse = await _watchDownloadProcess(
      downloadId: downloadId,
      downloadStream: response.downloadStream!,
    );

    MyPrint.printOnConsole("watchDownloadProcessResponse:$watchDownloadProcessResponse", tag: tag);

    if (!watchDownloadProcessResponse.isDownloaded) {
      MyPrint.printOnConsole("Download Failed", tag: tag);
      removeFromDownload(downloadId: downloadId);

      BuildContext? context = NavigationController.mainNavigatorKey.currentContext;
      if (context != null && context.mounted) {
        if (watchDownloadProcessResponse.isDownloadCanceled) {
          MyToast.showError(context: context, msg: "Download Cancelled");
        } else {
          MyToast.showError(context: context, msg: "Download Failed");
        }
      }
      return;
    }

    CourseDownloadDataModel? model = downloadProvider.getCourseDownloadDataModelFromId(courseDownloadId: downloadId, isNewInstance: true);
    if (model == null) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().downloadCourse() after download because model is null", tag: tag);
      return;
    }

    if (!model.isFileDownloaded) {
      MyPrint.printOnConsole("File Couldn't Downloaded", tag: tag);
      removeFromDownload(downloadId: downloadId);

      BuildContext? context = NavigationController.mainNavigatorKey.currentContext;
      if (context != null && context.mounted) {
        MyToast.showError(context: context, msg: "File Couldn't Downloaded");
      }
      return;
    }

    if (!(await File(model.downloadFilePath).exists())) {
      MyPrint.printOnConsole("Downloaded File Not Exist", tag: tag);
      removeFromDownload(downloadId: downloadId);

      BuildContext? context = NavigationController.mainNavigatorKey.currentContext;
      if (context != null && context.mounted) {
        MyToast.showError(context: context, msg: "Downloaded File Not Exist");
      }
      return;
    }

    if (model.isZip) {
      MyPrint.printOnConsole("It is a Zip File", tag: tag);
      MyPrint.printOnConsole("Starting Extraction of Zip File", tag: tag);

      model.zipFileExtractionPercentage = 0;
      model.isFileExtracted = false;
      model.isFileExtracting = true;
      updateCourseDownload(courseDownloadDataModel: model);

      bool isZipFileExtracted = await FlutterDownloadController().extractZipFile(
        destinationFolderPath: folderPath,
        zipFilePath: model.downloadFilePath,
        onFileOperation: (int totalOperations) {
          MyPrint.printOnConsole("onFileOperation called with totalOperations:$totalOperations", tag: tag);
          model.zipFileExtractionPercentage += (100 / totalOperations);
          model.totalDownloadPercentage = (model.fileDownloadPercentage + model.zipFileExtractionPercentage) / 2;
          updateCourseDownload(courseDownloadDataModel: model);
        },
      );
      MyPrint.printOnConsole("isZipFileExtracted:$isZipFileExtracted", tag: tag);

      if (!isZipFileExtracted) {
        MyPrint.printOnConsole("Course Extraction Failed", tag: tag);
        downloadProvider.courseDownloadMap.clearKey(key: downloadId, isNotify: true);

        BuildContext? context = NavigationController.mainNavigatorKey.currentContext;
        if (context != null && context.mounted) {
          MyToast.showError(context: context, msg: "Course Extraction Failed");
        }
        return;
      }

      model.isFileExtracted = true;
      model.isFileExtracting = false;
      MyPrint.printOnConsole("Zip File Extracted", tag: tag);
    }
    MyPrint.printOnConsole("Course Downloaded Successfully", tag: tag);
    model.isCourseDownloading = false;
    model.isCourseDownloaded = true;
    updateCourseDownload(courseDownloadDataModel: model);

    BuildContext? context = NavigationController.mainNavigatorKey.currentContext;
    if (context != null && context.mounted) {
      MyToast.showSuccess(context: context, msg: "Course Downloaded Successfully");
    }
  }

  Future<({bool isDownloaded, bool isDownloadCanceled})> _watchDownloadProcess({required String downloadId, required Stream<FlutterDownloadResponseModel> downloadStream}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadController()._watchDownloadProcess() called for downloadId:$downloadId", tag: tag);

    CourseDownloadProvider downloadProvider = courseDownloadProvider;

    ({bool isDownloaded, bool isDownloadCanceled}) response = (isDownloaded: false, isDownloadCanceled: false);

    try {
      bool isDownloadCanceled = false;

      Completer<bool> completer = Completer<bool>();

      StreamSubscription<FlutterDownloadResponseModel> subscription = downloadStream.listen(
        (FlutterDownloadResponseModel responseModel) {
          MyPrint.printOnConsole("downloadUpdateCallback called responseModel:$responseModel", tag: tag);
          CourseDownloadDataModel? model = downloadProvider.getCourseDownloadDataModelFromId(courseDownloadId: downloadId, isNewInstance: false);
          if (model == null) {
            MyPrint.printOnConsole("Returning from downloadUpdateCallback because model is null", tag: tag);
            completer.complete(false);
            return;
          }

          if (responseModel.id != model.taskId) {
            return;
          }

          model = CourseDownloadDataModel.fromMap(model.toMap());

          MyPrint.printOnConsole("downloadStream response:$responseModel", tag: tag);

          if (responseModel.status == DownloadTaskStatus.canceled) {
            MyPrint.printOnConsole("Download Cancelled", tag: tag);

            completer.complete(false);
            isDownloadCanceled = true;
            return;
          } else if (responseModel.status == DownloadTaskStatus.failed) {
            MyPrint.printOnConsole("Download Failed", tag: tag);

            completer.complete(false);
            return;
          }

          if (responseModel.status == DownloadTaskStatus.complete) {
            completer.complete(true);
          }

          model.isCourseDownloading = true;
          model.downloadStatus = responseModel.status;
          model.isFileDownloadingPaused = responseModel.status == DownloadTaskStatus.paused;
          model.isFileDownloaded = responseModel.status == DownloadTaskStatus.complete && responseModel.progress == 100;
          model.isFileDownloading = responseModel.status == DownloadTaskStatus.running;
          if (responseModel.progress >= 0 && responseModel.progress <= 100) {
            model.fileDownloadPercentage = MyUtils.roundTo(responseModel.progress.toDouble(), 100);
            model.totalDownloadPercentage = model.isZip ? model.fileDownloadPercentage / 2 : model.fileDownloadPercentage;
          }
          updateCourseDownload(courseDownloadDataModel: model);
        },
      );

      bool isDownloaded = await completer.future;
      subscription.cancel();

      MyPrint.printOnConsole("isDownloaded:$isDownloaded", tag: tag);

      response = (isDownloaded: isDownloaded, isDownloadCanceled: isDownloadCanceled);
    } catch (e, s) {
      MyPrint.printOnConsole("Error in Downloading in CourseDownloadController().downloadCourse():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    MyPrint.printOnConsole("Final response:$response", tag: tag);

    return response;
  }

  Future<bool> isDownloadPermissionGranted() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadController().isDownloadPermissionGranted() called", tag: tag);

    PermissionStatus? storagePermission;
    try {
      storagePermission = await Permission.storage.request();
    } catch (e, s) {
      MyPrint.printOnConsole("Error in Requesting Permission:$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }
    MyPrint.printOnConsole("storagePermission:$storagePermission", tag: tag);

    if (!(storagePermission?.isGranted ?? false)) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().isDownloadPermissionGranted() because Storage Permission Not Granted", tag: tag);
      return false;
    }

    return true;
  }

  ({String downloadUrl, bool isZipFile}) getCourseDownloadUrl({required CourseDTOModel courseDTOModel}) {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadController().getCourseDownloadUrl() called for ContentId:${courseDTOModel.ContentID}", tag: tag);

    String downloadUrl = "";
    bool isZipFile = false;

    int ContentTypeId = courseDTOModel.ContentTypeId;
    int MediaTypeID = courseDTOModel.MediaTypeID;
    MyPrint.printOnConsole("ContentTypeId:'$ContentTypeId'", tag: tag);
    MyPrint.printOnConsole("MediaTypeID:'$MediaTypeID'", tag: tag);

    String baseUrl = "";
    int SiteId = courseDTOModel.SiteId;
    int SiteUserID = courseDTOModel.SiteUserID;
    String ContentID = courseDTOModel.ContentID;
    String startPage = courseDTOModel.startpage;
    String FolderPath = courseDTOModel.FolderPath;
    String jwvideokey = courseDTOModel.JWVideoKey;

    if (appProvider.appSystemConfigurationModel.isCloudStorageEnabled) {
      baseUrl = appProvider.appSystemConfigurationModel.azureRootPath;
    } else {
      baseUrl = ApiController().apiDataProvider.getCurrentSiteUrl();
    }
    if (!baseUrl.endsWith("/")) baseUrl = "$baseUrl/";
    if (baseUrl.startsWith("http://")) baseUrl = baseUrl.replaceFirst("http://", "https://");

    if (ContentTypeId == InstancyObjectTypes.certificate) {
      if (startPage.contains(".")) startPage = startPage.substring(0, startPage.indexOf("."));
      downloadUrl = "${baseUrl}content/sitefiles/$SiteId/UserCertificates/$SiteUserID/$ContentID/$startPage.pdf";
    } else if (ContentTypeId == InstancyObjectTypes.dictionaryGlossary) {
      downloadUrl = "${baseUrl}content/publishfiles/$FolderPath/${startPage.isNotEmpty ? startPage : "glossary_english.html"}";
    } else if (ContentTypeId == InstancyObjectTypes.mediaResource && MediaTypeID == InstancyMediaTypes.video && jwvideokey.isNotEmpty) {
      downloadUrl = "https://content.jwplatform.com/videos/$jwvideokey.mp4";
    } else if ([
          InstancyObjectTypes.contentObject,
          InstancyObjectTypes.assessment,
          InstancyObjectTypes.scorm1_2,
          InstancyObjectTypes.xApi,
        ].contains(ContentTypeId) ||
        (ContentTypeId == InstancyObjectTypes.html && MediaTypeID == InstancyMediaTypes.htmlZIPFile)) {
      downloadUrl = "${baseUrl}content/publishfiles/$FolderPath/$ContentID.zip";
      isZipFile = true;
    } else {
      downloadUrl = "${baseUrl}content/publishfiles/$FolderPath/$startPage";
    }

    if ([
      InstancyObjectTypes.mediaResource,
      InstancyObjectTypes.document,
      InstancyObjectTypes.dictionaryGlossary,
      InstancyObjectTypes.webPage,
    ].contains(ContentTypeId)) {
      downloadUrl = "$downloadUrl?fromNativeapp=true";
    }

    return (downloadUrl: downloadUrl, isZipFile: isZipFile);
  }

  Future<String> getCourseDownloadDirectoryPath({required CourseDTOModel courseDTOModel, String parentEventTrackId = ""}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadController().getCourseDownloadDirectoryPath() called for ContentId:${courseDTOModel.ContentID}", tag: tag);

    MyPrint.printOnConsole("FolderPath:'${courseDTOModel.FolderPath}'", tag: tag);

    String pathSeparator = AppController.getPathSeparator() ?? "/";
    MyPrint.printOnConsole("pathSeparator:'$pathSeparator'", tag: tag);

    String documentsDirectoryPath = await AppController.getDocumentsDirectory();
    MyPrint.printOnConsole("documentsDirectoryPath:'$documentsDirectoryPath'", tag: tag);

    // path: '/storage/emulated/0/Android/data/com.instancy.qalearning2/files/CourseDownloads/'
    String downloadDestFolderPath = "$documentsDirectoryPath${pathSeparator}CourseDownloads";

    // path: '/storage/emulated/0/Android/data/com.instancy.qalearning2/files/CourseDownloads/qalearning.instancy.com/1945'
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = ApiController().apiDataProvider;
    Uri? uri = Uri.tryParse(apiUrlConfigurationProvider.getCurrentSiteUrl());
    int userId = apiUrlConfigurationProvider.getCurrentUserId();
    if (uri != null && userId > 0) {
      downloadDestFolderPath += "$pathSeparator${uri.host}$pathSeparator$userId";
    }

    // path: '/storage/emulated/0/Android/data/com.instancy.qalearning2/files/CourseDownloads/qalearning.instancy.com/1945/9889078E-71F4-4FB4-AAF9-CAAC82DF711C'
    if (parentEventTrackId.isNotEmpty) {
      downloadDestFolderPath += "$pathSeparator$parentEventTrackId";
    }
    if (courseDTOModel.FolderPath.isNotEmpty) {
      downloadDestFolderPath += "$pathSeparator${courseDTOModel.FolderPath}";
    }

    return downloadDestFolderPath;
  }

  String getCourseDownloadFileName({required CourseDTOModel courseDTOModel}) {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadController().getCourseDownloadFileName() called for ContentId:${courseDTOModel.ContentID}", tag: tag);

    String downloadFileName = courseDTOModel.startpage;

    String ContentID = courseDTOModel.ContentID;
    int ContentTypeId = courseDTOModel.ContentTypeId;
    int MediaTypeID = courseDTOModel.MediaTypeID;
    MyPrint.printOnConsole("ContentTypeId:'$ContentTypeId'", tag: tag);
    MyPrint.printOnConsole("MediaTypeID:'$MediaTypeID'", tag: tag);

    String startPage = courseDTOModel.startpage;

    if (ContentTypeId == InstancyObjectTypes.certificate) {
      if (startPage.contains(".")) startPage = startPage.substring(0, startPage.indexOf("."));
      downloadFileName = "$startPage.pdf";
    } else if (ContentTypeId == InstancyObjectTypes.dictionaryGlossary) {
      downloadFileName = startPage.isNotEmpty ? startPage : "glossary_english.html";
    } else if ([
          InstancyObjectTypes.contentObject,
          InstancyObjectTypes.assessment,
          InstancyObjectTypes.scorm1_2,
          InstancyObjectTypes.xApi,
        ].contains(ContentTypeId) ||
        (ContentTypeId == InstancyObjectTypes.html && MediaTypeID == InstancyMediaTypes.htmlZIPFile)) {
      downloadFileName = "$ContentID.zip";
    } else {
      downloadFileName = startPage;
      if (downloadFileName.contains("/")) downloadFileName = downloadFileName.substring(downloadFileName.lastIndexOf("/") + 1);
    }

    return downloadFileName;
  }

  // endregion

  // region Other Operations Related to Download
  Future<void> removeFromDownload({required String downloadId, BuildContext? context}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadController().removeFromDownload() called with downloadId:'$downloadId'", tag: tag);

    CourseDownloadProvider provider = courseDownloadProvider;
    CourseDownloadRepository repository = courseDownloadRepository;

    provider.courseDownloadList.removeItems(items: [downloadId], isNotify: false);
    provider.courseDownloadMap.clearKey(key: downloadId, isNotify: true);

    bool isRemovedDownloadIdFromHive = false;
    bool isRemovedDownloadModelFromHive = false;

    await Future.wait([
      repository.removeCourseDownloadIdsFromHive(downloadIds: [downloadId]).then((value) {
        isRemovedDownloadIdFromHive = value;
      }),
      repository.removeCourseDownloadDataModelsFromHive(downloadIds: [downloadId]).then((value) {
        isRemovedDownloadModelFromHive = value;
      }),
    ]);

    MyPrint.printOnConsole("isRemovedDownloadIdFromHive:$isRemovedDownloadIdFromHive", tag: tag);
    MyPrint.printOnConsole("isRemovedDownloadModelFromHive:$isRemovedDownloadModelFromHive", tag: tag);

    if (context != null && context.mounted) MyToast.showSuccess(context: context, msg: "Removed from Download Successfully");
  }

  Future<void> cancelDownload({required String downloadId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadController().cancelDownload() called with downloadId:'$downloadId'", tag: tag);

    CourseDownloadProvider provider = courseDownloadProvider;

    CourseDownloadDataModel? courseDownloadDataModel = provider.getCourseDownloadDataModelFromId(courseDownloadId: downloadId);

    if (courseDownloadDataModel == null) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().cancelDownload() no such downloadId exist", tag: tag);
      return;
    } else if (!courseDownloadDataModel.isFileDownloading && !courseDownloadDataModel.isFileDownloadingPaused) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().cancelDownload() file not downloading", tag: tag);
      return;
    } else if (courseDownloadDataModel.taskId.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().cancelDownload() taskId is empty", tag: tag);
      return;
    }

    bool isCancelInitiated = await FlutterDownloadController().cancelDownload(taskId: courseDownloadDataModel.taskId);
    MyPrint.printOnConsole("isCancelInitiated:$isCancelInitiated", tag: tag);

    FlutterDownloadController.downloadResponseStreamController?.add(
      FlutterDownloadResponseModel(
        id: courseDownloadDataModel.taskId,
        progress: 0,
        status: DownloadTaskStatus.canceled,
      ),
    );
  }

  Future<void> pauseDownload({required String downloadId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadController().pauseDownload() called with downloadId:'$downloadId'", tag: tag);

    CourseDownloadProvider provider = courseDownloadProvider;

    CourseDownloadDataModel? courseDownloadDataModel = provider.getCourseDownloadDataModelFromId(courseDownloadId: downloadId);

    if (courseDownloadDataModel == null) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().pauseDownload() no such downloadId exist", tag: tag);
      return;
    } else if (!courseDownloadDataModel.isFileDownloading) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().pauseDownload() file not downloading", tag: tag);
      return;
    } else if (courseDownloadDataModel.isFileDownloadingPaused) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().pauseDownload() file downloading already paused", tag: tag);
      return;
    } else if (courseDownloadDataModel.taskId.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().pauseDownload() taskId is empty", tag: tag);
      return;
    }

    bool isPauseInitiated = await FlutterDownloadController().pauseDownload(taskId: courseDownloadDataModel.taskId);
    MyPrint.printOnConsole("isPauseInitiated:$isPauseInitiated", tag: tag);
  }

  Future<void> resumeDownload({required String downloadId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadController().pauseDownload() called with downloadId:'$downloadId'", tag: tag);

    CourseDownloadProvider provider = courseDownloadProvider;

    CourseDownloadDataModel? courseDownloadDataModel = provider.getCourseDownloadDataModelFromId(courseDownloadId: downloadId);

    if (courseDownloadDataModel == null) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().pauseDownload() no such downloadId exist", tag: tag);
      return;
    } else if (!courseDownloadDataModel.isFileDownloadingPaused) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().pauseDownload() file downloading not paused", tag: tag);
      return;
    } else if (courseDownloadDataModel.taskId.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().pauseDownload() taskId is empty", tag: tag);
      return;
    }

    String? newTaskId = await FlutterDownloadController().resumeDownload(taskId: courseDownloadDataModel.taskId);
    MyPrint.printOnConsole("newTaskId:$newTaskId", tag: tag);

    if (newTaskId.checkEmpty) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().pauseDownload() newTaskId is empty", tag: tag);
      FlutterDownloadController.downloadResponseStreamController?.add(
        FlutterDownloadResponseModel(
          id: courseDownloadDataModel.taskId,
          progress: 0,
          status: DownloadTaskStatus.failed,
        ),
      );
      return;
    }

    courseDownloadDataModel = provider.getCourseDownloadDataModelFromId(courseDownloadId: downloadId, isNewInstance: true);

    if (courseDownloadDataModel == null) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().pauseDownload() courseDownloadDataModel is null after resume", tag: tag);
      return;
    }

    courseDownloadDataModel.taskId = newTaskId!;
    updateCourseDownload(courseDownloadDataModel: courseDownloadDataModel);
  }

  // endregion

  Future<void> addNewCourseDownload({required CourseDownloadDataModel courseDownloadDataModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadController().addNewCourseDownload() called for courseDownloadDataModel:$courseDownloadDataModel", tag: tag);

    if (courseDownloadDataModel.id.isEmpty) {
      MyPrint.printOnConsole("downloadId is empty, assigning", tag: tag);
      courseDownloadDataModel.id = CourseDownloadDataModel.getDownloadId(contentId: courseDownloadDataModel.contentId, eventTrackContentId: courseDownloadDataModel.eventTrackContentId);
    }
    if (courseDownloadDataModel.id.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().addNewCourseDownload() because downloadId is empty", tag: tag);
      return;
    }

    CourseDownloadProvider provider = courseDownloadProvider;

    CourseDownloadDataModel? model = provider.courseDownloadMap.getMap(isNewInstance: false)[courseDownloadDataModel.id];
    if (model == null) {
      model = courseDownloadDataModel;
    } else {
      model.updateFromMap(courseDownloadDataModel.toMap());
    }

    provider.courseDownloadList.insertAt(index: 0, element: model.id, isNotify: false);
    provider.courseDownloadMap.setMap(map: {model.id: model}, isClear: false, isNotify: true);
    await Future.wait([
      courseDownloadRepository.addCourseDownloadIdsInHive(downloadIds: <String>[model.id]),
      courseDownloadRepository.setCourseDownloadDataModelInHive(downloadId: model.id, model: model),
    ]);
  }

  Future<void> updateCourseDownload({required CourseDownloadDataModel courseDownloadDataModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadController().updateCourseDownload() called for courseDownloadDataModel:$courseDownloadDataModel", tag: tag);

    if (courseDownloadDataModel.id.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().addNewCourseDownload() because downloadId is empty", tag: tag);
      return;
    }

    CourseDownloadProvider provider = courseDownloadProvider;

    CourseDownloadDataModel? model = provider.getCourseDownloadDataModelFromId(courseDownloadId: courseDownloadDataModel.id, isNewInstance: false);
    if (model == null) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().addNewCourseDownload() because model is null", tag: tag);
      return;
    }

    model.updateFromMap(courseDownloadDataModel.toMap());
    provider.courseDownloadMap.setMap(map: {model.id: model}, isClear: false, isNotify: true);
    await courseDownloadRepository.setCourseDownloadDataModelInHive(downloadId: model.id, model: model);
  }

  Future<void> getAllMyCourseDownloadsAndSaveInProvider({bool isRefresh = true, bool isNotify = true}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadController().getAllMyCourseDownloadsAndSaveInProvider() called with isRefresh:$isRefresh, isNotify:$isNotify", tag: tag);

    CourseDownloadProvider provider = courseDownloadProvider;

    MyPrint.printOnConsole("MyCourseDownloads Length:${provider.courseDownloadList.length}", tag: tag);

    if (isRefresh || provider.courseDownloadList.length == 0) {
      MyPrint.printOnConsole("Getting MyCourseDownloads From Hive", tag: tag);

      provider.isLoadingCourseDownloadsData.set(value: true, isNotify: isNotify);

      List<String> list = <String>[];
      Map<String, CourseDownloadDataModel> map = <String, CourseDownloadDataModel>{};

      await Future.wait([
        courseDownloadRepository.getAllCourseDownloadIdsFromHive().then((value) {
          list = value;
        }),
        courseDownloadRepository.getAllCourseDownloadModelsFromHive().then((value) {
          map = value;
        }),
      ]);

      list = list.toSet().toList();
      list.removeWhere((element) => element.isEmpty);

      MyPrint.printOnConsole("list length from Hive:${list.length}", tag: tag);
      MyPrint.printOnConsole("map length from Hive:${map.length}", tag: tag);

      List<String> itemsToRemove = <String>[];
      if (list.isNotEmpty) {
        MyPrint.printOnConsole("Starting Checking Course Exist In File System Operation", tag: tag);

        await Future.wait(list.map((String downloadId) {
          return Future(() async {
            bool isDirectoryExist = false;

            try {
              CourseDownloadDataModel? downloadDataModel = map[downloadId];

              if (downloadDataModel?.downloadFileDirectoryPath.isNotEmpty ?? false) {
                isDirectoryExist = await Directory(downloadDataModel!.downloadFileDirectoryPath).exists();
              }
            } catch (e, s) {
              MyPrint.printOnConsole("Error in Checking Directory Exist:$e", tag: tag);
              MyPrint.printOnConsole(s, tag: tag);
            }

            MyPrint.printOnConsole("Final isDirectoryExist for DownloadId '$downloadId':$isDirectoryExist", tag: tag);
            if (!isDirectoryExist) {
              MyPrint.printOnConsole("Removing DownloadID '$downloadId' from MyDownloads because course directory not exist", tag: tag);
              itemsToRemove.add(downloadId);
            }
          });
        }));

        MyPrint.printOnConsole("Completed Checking Course Exist In File System Operation", tag: tag);
      }

      MyPrint.printOnConsole("itemsToRemove:$itemsToRemove", tag: tag);

      itemsToRemove.addAll(map.keys.where((element) => !list.contains(element)));
      MyPrint.printOnConsole("itemsToRemove after adding downloadIds which are not in list but present in map:$itemsToRemove", tag: tag);

      if (itemsToRemove.isNotEmpty) {
        list.removeWhere((element) => itemsToRemove.contains(element));
        map.removeWhere((key, value) => itemsToRemove.contains(key));
        courseDownloadRepository.removeCourseDownloadIdsFromHive(downloadIds: itemsToRemove);
        courseDownloadRepository.removeCourseDownloadDataModelsFromHive(downloadIds: itemsToRemove);
      }

      provider.courseDownloadList.setList(list: list.reversed.toList(), isClear: true, isNotify: false);
      provider.courseDownloadMap.setMap(map: map, isClear: true, isNotify: false);

      provider.isLoadingCourseDownloadsData.set(value: false, isNotify: true);
    }

    MyPrint.printOnConsole("Final MyCourseDownloads Length:${provider.courseDownloadList.length}", tag: tag);
  }
}
