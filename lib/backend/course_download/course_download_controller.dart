import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/api/api_url_configuration_provider.dart';
import 'package:flutter_instancy_2/backend/app/app_controller.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/authentication/authentication_provider.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_provider.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_repository.dart';
import 'package:flutter_instancy_2/backend/course_offline/course_offline_controller.dart';
import 'package:flutter_instancy_2/backend/download/flutter_download_controller.dart';
import 'package:flutter_instancy_2/backend/event_track/event_track_hive_repository.dart';
import 'package:flutter_instancy_2/backend/my_learning/my_learning_controller.dart';
import 'package:flutter_instancy_2/backend/my_learning/my_learning_repository.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation_controller.dart';
import 'package:flutter_instancy_2/backend/network_connection/network_connection_controller.dart';
import 'package:flutter_instancy_2/backend/ui_actions/my_learning/my_learning_ui_action_configs.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/common/data_response_model.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/models/course_download/data_model/course_download_data_model.dart';
import 'package:flutter_instancy_2/models/course_download/request_model/course_download_request_model.dart';
import 'package:flutter_instancy_2/models/course_offline/data_model/cmi_model.dart';
import 'package:flutter_instancy_2/models/course_offline/request_model/course_offline_launch_request_model.dart';
import 'package:flutter_instancy_2/models/course_offline/response_model/course_learner_session_response_model.dart';
import 'package:flutter_instancy_2/models/course_offline/response_model/student_course_response_model.dart';
import 'package:flutter_instancy_2/models/download/request_model/flutter_download_request_model.dart';
import 'package:flutter_instancy_2/models/download/response_model/flutter_download_response_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/event_track_header_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/related_track_data_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/track_course_dto_model.dart';
import 'package:flutter_instancy_2/models/my_learning/request_model/check_contents_enrollment_status_request_model.dart';
import 'package:flutter_instancy_2/models/my_learning/response_model/check_contents_enrollment_status_response_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class CourseDownloadController {
  final AppProvider appProvider;
  late CourseDownloadProvider _courseDownloadProvider;
  late CourseDownloadRepository _courseDownloadRepository;

  static const bool isDownloadModuleEnabled = true;

  CourseDownloadController({required this.appProvider, required CourseDownloadProvider? courseDownloadProvider, CourseDownloadRepository? courseDownloadRepository, ApiController? apiController}) {
    _courseDownloadProvider = courseDownloadProvider ?? CourseDownloadProvider();
    _courseDownloadRepository = courseDownloadRepository ?? CourseDownloadRepository(apiController: apiController ?? ApiController());
  }

  CourseDownloadProvider get courseDownloadProvider => _courseDownloadProvider;

  CourseDownloadRepository get courseDownloadRepository => _courseDownloadRepository;

  // region Course Download
  // https://instancylivesites.blob.core.windows.net/upgradedenterprise/content/publishfiles/f35af8f3-28a8-4fd7-8102-9da5f80fd86a/acting%20skills.pdf?fromNativeapp=true
  // /storage/emulated/0/Android/data/com.instancy.upgradedenterpriseapp/files/.Mydownloads/Contentdownloads/f35af8f3-28a8-4fd7-8102-9da5f80fd86a-389/acting skills.pdf

  Future<void> downloadCourse({
    required CourseDownloadRequestModel courseDownloadRequestModel,
    CourseDTOModel? courseDTOModel,
    TrackCourseDTOModel? trackCourseDTOModel,
    RelatedTrackDataDTOModel? relatedTrackDataDTOModel,
    CourseDTOModel? parentEventTrackModel,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadController().downloadCourse() called for ContentId:${courseDownloadRequestModel.ContentID}", tag: tag);

    CourseDownloadProvider downloadProvider = courseDownloadProvider;

    if (!MyLearningUIActionConfigs.isContentTypeDownloadable(objectTypeId: courseDownloadRequestModel.ContentTypeId, mediaTypeId: courseDownloadRequestModel.MediaTypeID)) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().getCourseDownloadUrl() because Content Not Downloadable", tag: tag);

      BuildContext? context = NavigationController.mainNavigatorKey.currentContext;
      if (context != null && context.mounted) MyToast.showError(context: context, msg: "Course Not Downloadable");
      return;
    }

    if (kIsWeb) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().downloadCourse() because It is Web Platform", tag: tag);

      BuildContext? context = NavigationController.mainNavigatorKey.currentContext;
      if (context != null && context.mounted) MyToast.showError(context: context, msg: "Course Not Downloadable in Web Platform");

      return;
    }

    bool isNetworkConnected = NetworkConnectionController().checkConnection(context: NavigationController.mainNavigatorKey.currentContext, isShowErrorSnakbar: true);
    if (!isNetworkConnected) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().downloadCourse() because Internet Not Connected", tag: tag);
      return;
    }

    bool isDownloadPermissionGranted = await checkDownloadPermissionGranted();
    MyPrint.printOnConsole("isDownloadPermissionGranted:$isDownloadPermissionGranted", tag: tag);

    /*if (!isDownloadPermissionGranted && ) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().downloadCourse() because Download Permission Not Granted", tag: tag);
      MyToast.showError(context: NavigationController.mainNavigatorKey.currentContext!, msg: "Download Permission Not Granted");
      return;
    }*/

    ({String downloadUrl, bool isZipFile}) courseDownloadUrlResponse = getCourseDownloadUrl(courseDownloadRequestModel: courseDownloadRequestModel);
    MyPrint.printOnConsole("courseDownloadUrl:'${courseDownloadUrlResponse.downloadUrl}'", tag: tag);
    MyPrint.printOnConsole("isZipFile:${courseDownloadUrlResponse.isZipFile}", tag: tag);

    if (courseDownloadUrlResponse.downloadUrl.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().downloadCourse() because courseDownloadUrl is empty", tag: tag);
      return;
    }

    String parentEventTrackId = parentEventTrackModel?.ContentID ?? "";

    String folderPath = await getCourseDownloadDirectoryPath(courseDownloadRequestModel: courseDownloadRequestModel, parentEventTrackId: parentEventTrackId);
    MyPrint.printOnConsole("downloadFolderPath:'$folderPath'", tag: tag);

    String fileName = getCourseDownloadFileName(courseDownloadRequestModel: courseDownloadRequestModel);
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

    String downloadId = CourseDownloadDataModel.getDownloadId(contentId: courseDownloadRequestModel.ContentID, eventTrackContentId: parentEventTrackId);

    CourseDownloadDataModel courseDownloadDataModel = CourseDownloadDataModel(
      id: downloadId,
      contentId: courseDownloadRequestModel.ContentID,
      scoId: courseDownloadRequestModel.ScoId,
      contentTypeId: courseDownloadRequestModel.ContentTypeId,
      mediaTypeId: courseDownloadRequestModel.MediaTypeID,
      parentContentId: parentEventTrackId,
      parentContentName: parentEventTrackModel?.ContentName ?? "",
      parentContentScoId: parentEventTrackModel?.ScoID ?? 0,
      parentContentTypeId: parentEventTrackModel?.ContentTypeId ?? 0,
      taskId: response.taskId!,
      courseDTOModel: courseDTOModel,
      trackCourseDTOModel: trackCourseDTOModel,
      relatedTrackDataDTOModel: relatedTrackDataDTOModel,
      parentCourseModel: parentEventTrackModel,
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
      courseDownloadProvider.notify(isNotify: true);

      bool isZipFileExtracted = await FlutterDownloadController().extractZipFile(
        destinationFolderPath: folderPath,
        zipFilePath: model.downloadFilePath,
        onFileOperation: (int totalOperations) {
          MyPrint.printOnConsole("onFileOperation called with totalOperations:$totalOperations", tag: tag);
          model.zipFileExtractionPercentage += (100 / totalOperations);
          if (model.zipFileExtractionPercentage < 0) {
            model.zipFileExtractionPercentage = 0;
          } else if (model.zipFileExtractionPercentage > 100) {
            model.zipFileExtractionPercentage = 100;
          }
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
      courseDownloadProvider.notify(isNotify: true);
    }

    String coreLessonStatus = courseDTOModel?.ActualStatus ?? trackCourseDTOModel?.CoreLessonStatus ?? relatedTrackDataDTOModel?.CoreLessonStatus ?? "";
    MyPrint.printOnConsole("coreLessonStatus:$coreLessonStatus", tag: tag);
    if (coreLessonStatus.isNotEmpty && coreLessonStatus != ContentStatusTypes.notAttempted) {
      MyPrint.printOnConsole("Syncing Course Data to Offline", tag: tag);
      CourseOfflineLaunchRequestModel? courseOfflineLaunchRequestModel = getCourseOfflineLaunchRequestModelFromCourseDownloadDataModel(downloadDataModel: courseDownloadDataModel);
      if (courseOfflineLaunchRequestModel != null) {
        await CourseOfflineController().syncDataToOffline(requestModels: [courseOfflineLaunchRequestModel]).then((value) {
          MyPrint.printOnConsole("Synced Downloaded Data Successfully with Course Download", tag: tag);
        }).catchError((e, s) {
          MyPrint.printOnConsole("Error in Syncing Downloaded Data when Course Downloaded:$e", tag: tag);
          MyPrint.printOnConsole(s, tag: tag);
        });
      }
    }

    MyPrint.printOnConsole("Course Downloaded Successfully", tag: tag);
    model.isCourseDownloading = false;
    model.isCourseDownloaded = true;
    updateCourseDownload(courseDownloadDataModel: model);
    courseDownloadProvider.notify(isNotify: true);

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

  Future<bool> checkDownloadPermissionGranted() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadController().checkDownloadPermissionGranted() called", tag: tag);

    PermissionStatus? storagePermission;
    try {
      storagePermission = await Permission.storage.request();
    } catch (e, s) {
      MyPrint.printOnConsole("Error in Requesting Permission:$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }
    MyPrint.printOnConsole("storagePermission:$storagePermission", tag: tag);

    if (!(storagePermission?.isGranted ?? false)) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().checkDownloadPermissionGranted() because Storage Permission Not Granted", tag: tag);
      return false;
    }

    return true;
  }

  ({String downloadUrl, bool isZipFile}) getCourseDownloadUrl({required CourseDownloadRequestModel courseDownloadRequestModel}) {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadController().getCourseDownloadUrl() called for ContentId:${courseDownloadRequestModel.ContentID}", tag: tag);

    String downloadUrl = "";
    bool isZipFile = false;

    int ContentTypeId = courseDownloadRequestModel.ContentTypeId;
    int MediaTypeID = courseDownloadRequestModel.MediaTypeID;
    MyPrint.printOnConsole("ContentTypeId:'$ContentTypeId'", tag: tag);
    MyPrint.printOnConsole("MediaTypeID:'$MediaTypeID'", tag: tag);

    String baseUrl = "";
    int SiteId = courseDownloadRequestModel.SiteId;
    int SiteUserID = courseDownloadRequestModel.UserID;
    String ContentID = courseDownloadRequestModel.ContentID;
    String startPage = courseDownloadRequestModel.StartPage;
    String FolderPath = courseDownloadRequestModel.FolderPath;
    String jwvideokey = courseDownloadRequestModel.JWVideoKey;

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
    } else if (ContentTypeId == InstancyObjectTypes.mediaResource && MediaTypeID == InstancyMediaTypes.video && jwvideokey.isNotEmpty) {
      downloadUrl = "https://content.jwplatform.com/videos/$jwvideokey.mp4";
    } else if ([
      InstancyObjectTypes.contentObject,
      InstancyObjectTypes.assessment,
      InstancyObjectTypes.scorm1_2,
      InstancyObjectTypes.xApi,
      InstancyObjectTypes.webPage,
      InstancyObjectTypes.dictionaryGlossary,
    ].contains(ContentTypeId)) {
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
      InstancyObjectTypes.dictionaryGlossary,
    ].contains(ContentTypeId)) {
      downloadUrl = "$downloadUrl?fromNativeapp=true";
    }

    return (downloadUrl: downloadUrl, isZipFile: isZipFile);
  }

  Future<String> getCourseDownloadDirectoryPath({required CourseDownloadRequestModel courseDownloadRequestModel, String parentEventTrackId = ""}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadController().getCourseDownloadDirectoryPath() called for ContentId:${courseDownloadRequestModel.ContentID}", tag: tag);

    MyPrint.printOnConsole("FolderPath:'${courseDownloadRequestModel.FolderPath}'", tag: tag);

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
    if (courseDownloadRequestModel.FolderPath.isNotEmpty) {
      downloadDestFolderPath += "$pathSeparator${courseDownloadRequestModel.FolderPath}";
    }

    return downloadDestFolderPath;
  }

  String getCourseDownloadFileName({required CourseDownloadRequestModel courseDownloadRequestModel}) {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadController().getCourseDownloadFileName() called for ContentId:${courseDownloadRequestModel.ContentID}", tag: tag);

    String downloadFileName = courseDownloadRequestModel.StartPage;

    String ContentID = courseDownloadRequestModel.ContentID;
    int ContentTypeId = courseDownloadRequestModel.ContentTypeId;
    int MediaTypeID = courseDownloadRequestModel.MediaTypeID;
    MyPrint.printOnConsole("ContentTypeId:'$ContentTypeId'", tag: tag);
    MyPrint.printOnConsole("MediaTypeID:'$MediaTypeID'", tag: tag);

    String startPage = courseDownloadRequestModel.StartPage;

    if (ContentTypeId == InstancyObjectTypes.certificate) {
      if (startPage.contains(".")) startPage = startPage.substring(0, startPage.indexOf("."));
      downloadFileName = "$startPage.pdf";
    } else if ([
      InstancyObjectTypes.contentObject,
      InstancyObjectTypes.assessment,
      InstancyObjectTypes.scorm1_2,
      InstancyObjectTypes.xApi,
      InstancyObjectTypes.webPage,
      InstancyObjectTypes.dictionaryGlossary,
    ].contains(ContentTypeId)) {
      downloadFileName = "$ContentID.zip";
    } else {
      downloadFileName = startPage;
      if (downloadFileName.contains("/")) downloadFileName = downloadFileName.substring(downloadFileName.lastIndexOf("/") + 1);
    }

    return downloadFileName;
  }

  // endregion

  CourseOfflineLaunchRequestModel? getCourseOfflineLaunchRequestModelFromCourseDownloadDataModel({required CourseDownloadDataModel downloadDataModel}) {
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = ApiController().apiDataProvider;
    int SiteId = apiUrlConfigurationProvider.getCurrentSiteId();
    int UserId = apiUrlConfigurationProvider.getCurrentUserId();

    String UserName = AppController.mainAppContext?.read<AuthenticationProvider>().getEmailLoginResponseModel()?.username ?? "";

    return CourseOfflineLaunchRequestModel(
      ContentId: downloadDataModel.contentId,
      ContentTypeId: downloadDataModel.contentTypeId,
      MediaTypeId: downloadDataModel.mediaTypeId,
      ScoId: downloadDataModel.scoId,
      ParentContentId: downloadDataModel.parentContentId,
      UserName: UserName,
      ParentContentTypeId: downloadDataModel.parentContentTypeId,
      ParentContentScoId: downloadDataModel.parentContentScoId,
      SiteId: SiteId,
      UserId: UserId,
      isJWVideo: downloadDataModel.courseDTOModel?.JWVideoKey.isNotEmpty ??
          downloadDataModel.trackCourseDTOModel?.JWVideoKey.isNotEmpty ??
          downloadDataModel.relatedTrackDataDTOModel?.JWVideoKey.isNotEmpty ??
          false,
    );
  }

  // region Other Operations Related to Download
  Future<void> removeFromDownload({required String downloadId, BuildContext? context}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadController().removeFromDownload() called with downloadId:'$downloadId'", tag: tag);

    CourseDownloadProvider provider = courseDownloadProvider;
    CourseDownloadRepository repository = courseDownloadRepository;

    CourseDownloadDataModel? courseDownloadDataModel = provider.getCourseDownloadDataModelFromId(courseDownloadId: downloadId);

    if (courseDownloadDataModel != null) {
      CourseOfflineLaunchRequestModel? courseOfflineLaunchRequestModel = getCourseOfflineLaunchRequestModelFromCourseDownloadDataModel(downloadDataModel: courseDownloadDataModel);
      if (courseOfflineLaunchRequestModel != null) {
        CourseOfflineController courseOfflineController = CourseOfflineController();
        courseOfflineController.setCmiModelsFromRequestModels(requests: {courseOfflineLaunchRequestModel: null});
        courseOfflineController.setLearnerSessionModelsFromRequestModels(requests: {courseOfflineLaunchRequestModel: null});
        courseOfflineController.setStudentResponseModelsFromRequestModels(requests: {courseOfflineLaunchRequestModel: null});
      }
    }

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
      deleteCourseFromFileSystem(downloadId: downloadId, courseDownloadDataModel: courseDownloadDataModel),
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

  Future<bool> setCompleteDownload({required CourseDownloadDataModel courseDownloadDataModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadController().setCompleteDownload() called with downloadId:'${courseDownloadDataModel.id}'", tag: tag);

    CourseOfflineLaunchRequestModel? courseOfflineLaunchRequestModel = getCourseOfflineLaunchRequestModelFromCourseDownloadDataModel(downloadDataModel: courseDownloadDataModel);

    if (courseOfflineLaunchRequestModel == null) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().setCompleteDownload() because courseOfflineLaunchRequestModel is null", tag: tag);
      return false;
    }

    bool isSetCompletedInOffline = await CourseOfflineController().setCompleteOffline(requestModel: courseOfflineLaunchRequestModel);
    MyPrint.printOnConsole("isSetCompletedInOffline:$isSetCompletedInOffline", tag: tag);

    if (!isSetCompletedInOffline) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().setCompleteDownload() Couldn't Set Complete in Offline", tag: tag);
      return false;
    }

    await CourseOfflineController().updateContentProgressInOfflineAndDownloadWithTrackProgress(
      ContentId: courseDownloadDataModel.contentId,
      CoreLessonStatus: ContentStatusTypes.completed,
      ContentDisplayStatus: "Completed",
      contentProgress: 100,
      ParentContentId: courseDownloadDataModel.parentContentId,
      ParentContentTypeId: courseDownloadDataModel.parentContentTypeId,
    );

    MyPrint.printOnConsole("Updated Course Tracking Data in Downloads", tag: tag);

    if (isSetCompletedInOffline) {
      MyLearningController.isGetMyLearningData = true;
    }

    return isSetCompletedInOffline;
  }

  Future<bool> setContentToInProgress({required CourseDownloadDataModel courseDownloadDataModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadController().setContentToInProgress() called with downloadId:'${courseDownloadDataModel.id}'", tag: tag);

    CourseOfflineLaunchRequestModel? courseOfflineLaunchRequestModel = getCourseOfflineLaunchRequestModelFromCourseDownloadDataModel(downloadDataModel: courseDownloadDataModel);

    if (courseOfflineLaunchRequestModel == null) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().setContentToInProgress() because courseOfflineLaunchRequestModel is null", tag: tag);
      return false;
    }

    bool isSetContentToInProgress = await CourseOfflineController().setContentToInProgress(requestModel: courseOfflineLaunchRequestModel);
    MyPrint.printOnConsole("isSetContentToInProgress:$isSetContentToInProgress", tag: tag);

    if (!isSetContentToInProgress) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().setContentToInProgress() Couldn't Set Content to In Progress in Offline", tag: tag);
      return false;
    }

    await CourseOfflineController().updateContentProgressInOfflineAndDownloadWithTrackProgress(
      ContentId: courseDownloadDataModel.contentId,
      CoreLessonStatus: ContentStatusTypes.incomplete,
      ContentDisplayStatus: "In Progress",
      contentProgress: 50,
      ParentContentId: courseDownloadDataModel.parentContentId,
      ParentContentTypeId: courseDownloadDataModel.parentContentTypeId,
    );

    MyPrint.printOnConsole("Updated Course Tracking Data in Downloads", tag: tag);

    return isSetContentToInProgress;
  }

  Future<bool> updateCourseDownloadTrackingProgress({required String contentId, String parentContentId = "", String? coreLessonStatus, String? displayStatus, double? contentProgress}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
        "CourseDownloadController().updateCourseDownloadTrackingProgress() called with contentId:'$contentId', parentContentId:'$parentContentId',"
        " coreLessonStatus:'$coreLessonStatus', displayStatus:'$displayStatus', contentProgress:'$contentProgress'",
        tag: tag);

    if (coreLessonStatus == null && displayStatus == null && contentProgress == null) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().updateCourseDownloadTrackingProgress() because no values were passed to update", tag: tag);
      return false;
    }

    CourseDownloadProvider provider = courseDownloadProvider;
    CourseDownloadRepository repository = courseDownloadRepository;

    bool isUpdated = false;

    String downloadId = CourseDownloadDataModel.getDownloadId(contentId: contentId, eventTrackContentId: parentContentId);
    CourseDownloadDataModel? courseDownloadDataModel = provider.getCourseDownloadDataModelFromId(courseDownloadId: downloadId);

    if (courseDownloadDataModel == null) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().updateCourseDownloadTrackingProgress() because download model not found", tag: tag);
      return false;
    }

    CourseDownloadDataModel newModel = courseDownloadDataModel;

    if (coreLessonStatus != null) {
      newModel.courseDTOModel?.ActualStatus = coreLessonStatus;
      newModel.trackCourseDTOModel?.CoreLessonStatus = coreLessonStatus;
      newModel.relatedTrackDataDTOModel?.CoreLessonStatus = coreLessonStatus;
    }

    if (displayStatus != null) {
      newModel.courseDTOModel?.ContentStatus = displayStatus;
      newModel.trackCourseDTOModel?.ContentStatus = displayStatus;
      newModel.relatedTrackDataDTOModel?.ContentDisplayStatus = displayStatus;
    }

    if (contentProgress != null) {
      newModel.courseDTOModel?.PercentCompleted = contentProgress;
      newModel.trackCourseDTOModel?.ContentProgress = contentProgress.toString();
      newModel.relatedTrackDataDTOModel?.PercentCompleted = contentProgress;
    }

    isUpdated = await repository.setCourseDownloadDataModelInHive(courseDownloadData: {newModel.id: newModel});
    MyPrint.printOnConsole("isUpdated:$isUpdated", tag: tag);

    if (isUpdated) {
      provider.courseDownloadMap.setMap(map: {newModel.id: newModel}, isClear: false, isNotify: true);
    }

    return isUpdated;
  }

  Future<bool> deleteCourseFromFileSystem({required String downloadId, CourseDownloadDataModel? courseDownloadDataModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
        "CourseDownloadController().deleteCourseFromFileSystem() called with downloadId:'$downloadId',"
        " courseDownloadDataModel not null:'${courseDownloadDataModel != null}'",
        tag: tag);

    bool isDeleted = false;

    if (downloadId.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().deleteCourseFromFileSystem() because downloadId is empty", tag: tag);
      return isDeleted;
    }

    CourseDownloadProvider provider = courseDownloadProvider;

    courseDownloadDataModel ??= provider.courseDownloadMap.getMap(isNewInstance: false)[downloadId];

    if (courseDownloadDataModel == null) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().deleteCourseFromFileSystem() because courseDownloadDataModel is null", tag: tag);
      return isDeleted;
    }

    MyPrint.printOnConsole("downloadFileDirectoryPath:${courseDownloadDataModel.downloadFileDirectoryPath}", tag: tag);

    if (courseDownloadDataModel.downloadFileDirectoryPath.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().deleteCourseFromFileSystem() because downloadFileDirectoryPath is empty", tag: tag);
      return isDeleted;
    }

    try {
      Directory directory = Directory(courseDownloadDataModel.downloadFileDirectoryPath);
      await directory.delete(recursive: true);
      MyPrint.printOnConsole("Deleted Course From File System", tag: tag);

      isDeleted = true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseDownloadController().deleteCourseFromFileSystem():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    MyPrint.printOnConsole("Final isDeleted:$isDeleted", tag: tag);

    return isDeleted;
  }

  // endregion

  Future<void> addNewCourseDownload({required CourseDownloadDataModel courseDownloadDataModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadController().addNewCourseDownload() called for courseDownloadDataModel:$courseDownloadDataModel", tag: tag);

    if (courseDownloadDataModel.id.isEmpty) {
      MyPrint.printOnConsole("downloadId is empty, assigning", tag: tag);
      courseDownloadDataModel.id = CourseDownloadDataModel.getDownloadId(contentId: courseDownloadDataModel.contentId, eventTrackContentId: courseDownloadDataModel.parentContentId);
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
      courseDownloadRepository.setCourseDownloadDataModelInHive(courseDownloadData: {model.id: model}, isClear: false),
    ]);
  }

  Future<void> updateCourseDownload({required CourseDownloadDataModel courseDownloadDataModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadController().updateCourseDownload() called for courseDownloadDataModel:$courseDownloadDataModel", tag: tag);

    if (courseDownloadDataModel.id.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().updateCourseDownload() because downloadId is empty", tag: tag);
      return;
    }

    CourseDownloadProvider provider = courseDownloadProvider;

    CourseDownloadDataModel? model = provider.getCourseDownloadDataModelFromId(courseDownloadId: courseDownloadDataModel.id, isNewInstance: false);
    if (model == null) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().updateCourseDownload() because model is null", tag: tag);
      return;
    }

    model.updateFromMap(courseDownloadDataModel.toMap());
    provider.courseDownloadMap.setMap(map: {model.id: model}, isClear: false, isNotify: false);
    model.notify(isNotify: true);
    await courseDownloadRepository.setCourseDownloadDataModelInHive(courseDownloadData: {model.id: model}, isClear: false);
  }

  Future<void> updateMultipleCourseDownload({required Map<String, CourseDownloadDataModel> courseDownloadDataModelsMap}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadController().updateMultipleCourseDownload() called for courseDownloadDataModelsMap:${courseDownloadDataModelsMap.length}", tag: tag);

    if (courseDownloadDataModelsMap.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().updateMultipleCourseDownload() because courseDownloadDataModelsMap is empty", tag: tag);
      return;
    }

    CourseDownloadProvider provider = courseDownloadProvider;

    Map<String, CourseDownloadDataModel> newMap = <String, CourseDownloadDataModel>{};
    courseDownloadDataModelsMap.forEach((String downloadId, CourseDownloadDataModel courseDownloadDataModel) {
      CourseDownloadDataModel? model = provider.getCourseDownloadDataModelFromId(courseDownloadId: courseDownloadDataModel.id, isNewInstance: false);
      if (model != null) {
        model.updateFromMap(courseDownloadDataModel.toMap());
        newMap[model.id] = model;
      }
    });
    MyPrint.printOnConsole("Final DownloadIds to Update:${newMap.keys.toList()}", tag: tag);

    await courseDownloadRepository.setCourseDownloadDataModelInHive(courseDownloadData: newMap, isClear: false);
    provider.courseDownloadMap.setMap(map: newMap, isClear: false, isNotify: true);
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

      if (list.isNotEmpty) await checkAndValidateDownloadedItemsEnrollmentStatus();

      provider.isLoadingCourseDownloadsData.set(value: false, isNotify: true);
    }

    MyPrint.printOnConsole("Final MyCourseDownloads Length:${provider.courseDownloadList.length}", tag: tag);
  }

  Future<List<CourseDownloadDataModel>> getEventTrackContentDownloadsList({required String eventTrackContentId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadController().getEventTrackContentDownloadsList() called with eventTrackContentId:'$eventTrackContentId'", tag: tag);

    CourseDownloadProvider provider = courseDownloadProvider;

    List<String> courseDownloadIds = provider.courseDownloadList.getList();

    if (courseDownloadIds.isEmpty) {
      await getAllMyCourseDownloadsAndSaveInProvider(isRefresh: true, isNotify: false);
      courseDownloadIds = provider.courseDownloadList.getList();
    }

    List<CourseDownloadDataModel> courseDownloadDataList = <CourseDownloadDataModel>[];
    for (String courseDownloadId in courseDownloadIds) {
      CourseDownloadDataModel? courseDownloadDataModel = provider.getCourseDownloadDataModelFromId(courseDownloadId: courseDownloadId);
      if (courseDownloadDataModel?.parentContentId == eventTrackContentId) {
        courseDownloadDataList.add(courseDownloadDataModel!);
      }
    }

    MyPrint.printOnConsole("Final courseDownloadDataList length:${courseDownloadDataList.length}", tag: tag);

    return courseDownloadDataList;
  }

  Future<bool> checkCourseDownloaded({required String contentId, String parentEventTrackContentId = ""}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadController().checkCourseDownloaded() called with contentId:'$contentId', parentEventTrackContentId:'$parentEventTrackContentId'", tag: tag);

    String downloadId = CourseDownloadDataModel.getDownloadId(contentId: contentId, eventTrackContentId: parentEventTrackContentId);
    MyPrint.printOnConsole("downloadId:'$downloadId'", tag: tag);

    if (downloadId.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().checkCourseDownloaded() because downloadId is empty", tag: tag);
      return false;
    }

    CourseDownloadProvider provider = courseDownloadProvider;

    CourseDownloadDataModel? model = provider.courseDownloadMap.getMap(isNewInstance: false)[downloadId];
    if (model == null) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().checkCourseDownloaded() because not such download exist", tag: tag);
      return false;
    }

    bool isCourseDownloaded = model.isCourseDownloaded;
    MyPrint.printOnConsole("isCourseDownloaded:$isCourseDownloaded", tag: tag);

    return isCourseDownloaded;
  }

  Future<bool> setCourseDownloadModelInProviderAndHive({required Map<String, CourseDownloadDataModel> courseDownloads, bool isClear = false, bool isNotify = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadController().setCourseDownloadModelInProviderAndHive() called with courseDownloads length:'${courseDownloads.length}'", tag: tag);

    bool isSetSuccess = false;

    courseDownloadProvider.courseDownloadMap.setMap(map: courseDownloads, isClear: isClear, isNotify: isNotify);
    bool isHiveSetSuccess = await courseDownloadRepository.setCourseDownloadDataModelInHive(courseDownloadData: courseDownloads, isClear: isClear);
    MyPrint.printOnConsole("isHiveSetSuccess:$isHiveSetSuccess", tag: tag);

    isSetSuccess = true;

    return isSetSuccess;
  }

  Future<void> syncAllTheDownloadDataInOffline() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadController().syncAllTheDownloadDataInOffline() called", tag: tag);

    CourseDownloadProvider provider = courseDownloadProvider;

    await getAllMyCourseDownloadsAndSaveInProvider(isRefresh: true, isNotify: false);

    if (!NetworkConnectionController().checkConnection()) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().syncAllTheDownloadDataInOffline() because no internet connection", tag: tag);
      return;
    }

    List<Future> futures = <Future>[];

    provider.courseDownloadMap.getMap(isNewInstance: false).forEach((String downloadId, CourseDownloadDataModel courseDownloadDataModel) {
      MyPrint.printOnConsole("Syncing Course Data to Offline for downloadId:'$downloadId'", tag: tag);
      CourseOfflineLaunchRequestModel? courseOfflineLaunchRequestModel = getCourseOfflineLaunchRequestModelFromCourseDownloadDataModel(downloadDataModel: courseDownloadDataModel);
      if (courseOfflineLaunchRequestModel != null) {
        Future future = CourseOfflineController().syncDataToOffline(requestModels: [courseOfflineLaunchRequestModel]).then((value) {
          MyPrint.printOnConsole("Synced Downloaded Data Successfully with Course Download", tag: tag);
        }).catchError((e, s) {
          MyPrint.printOnConsole("Error in Syncing Downloaded Data when Course Downloaded:$e", tag: tag);
          MyPrint.printOnConsole(s, tag: tag);
        });
        futures.add(future);
      }
    });

    if (futures.isNotEmpty) await Future.wait(futures);

    MyPrint.printOnConsole("Synced All Courses Tracking Data to Offline", tag: tag);
  }

  //region For Updating (MyLearning, Track and Event Related Contents) (Models and Tracking Data) in Download and Offline
  Future<void> updateMyLearningContentsInDownloadsAndSyncDataOffline({required List<CourseDTOModel> contentsList}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadController().updateMyLearningContentsInDownloadsAndSyncDataOffline() called with contentsList:${contentsList.length}", tag: tag);

    AppProvider? appProvider = AppController.mainAppContext?.read<AppProvider>();

    List<Future> futures = <Future>[];

    if (appProvider != null) {
      CourseDownloadController courseDownloadController = CourseDownloadController(appProvider: appProvider, courseDownloadProvider: courseDownloadProvider);

      Map<String, CourseDownloadDataModel> courseDownloadDataModelsMap = <String, CourseDownloadDataModel>{};
      List<CourseOfflineLaunchRequestModel> requestModels = <CourseOfflineLaunchRequestModel>[];

      for (CourseDTOModel model in contentsList) {
        if ([InstancyObjectTypes.events, InstancyObjectTypes.track].contains(model.ContentTypeId)) {
          futures.add(updateEventTrackParentModelInDownloadsAndHeaderModel(
            eventTrackContentId: model.ContentID,
            PercentageCompleted: model.PercentCompleted,
            CoreLessonStatus: model.ActualStatus,
            DisplayStatus: model.ContentStatus,
          ));
        } else {
          String downloadId = CourseDownloadDataModel.getDownloadId(contentId: model.ContentID);
          CourseDownloadDataModel? courseDownloadDataModel = courseDownloadProvider.getCourseDownloadDataModelFromId(courseDownloadId: downloadId);
          if (courseDownloadDataModel != null) {
            courseDownloadDataModel.courseDTOModel = model;
            courseDownloadDataModelsMap[downloadId] = courseDownloadDataModel;

            CourseOfflineLaunchRequestModel? courseOfflineLaunchRequestModel = getCourseOfflineLaunchRequestModelFromCourseDownloadDataModel(downloadDataModel: courseDownloadDataModel);

            if (courseOfflineLaunchRequestModel == null) {
              MyPrint.printOnConsole("Continuing in Loop for CourseDownloadController().setContentToInProgress() because courseOfflineLaunchRequestModel is null", tag: tag);
              continue;
            }

            requestModels.add(courseOfflineLaunchRequestModel);
          }
        }
      }

      MyPrint.printOnConsole("Final contentsList to Update Data:${requestModels.map((e) => e.ContentId).toList()}", tag: tag);

      if (courseDownloadDataModelsMap.isNotEmpty) futures.add(courseDownloadController.updateMultipleCourseDownload(courseDownloadDataModelsMap: courseDownloadDataModelsMap));
      if (requestModels.isNotEmpty) futures.add(CourseOfflineController().syncDataToOffline(requestModels: requestModels));
    }

    if (futures.isNotEmpty) await Future.wait(futures);

    MyPrint.printOnConsole("MyLearning Data Updated in Downloads and Offline Successfully", tag: tag);
  }

  Future<void> updateTrackContentsInDownloadsAndSyncDataOffline({required List<TrackCourseDTOModel> contentsList, required String parentCourseId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadController().updateTrackContentsInDownloadsAndSyncDataOffline() called with contentsList:${contentsList.length}", tag: tag);

    AppProvider? appProvider = AppController.mainAppContext?.read<AppProvider>();

    List<Future> futures = <Future>[];

    if (appProvider != null) {
      CourseDownloadController courseDownloadController = CourseDownloadController(appProvider: appProvider, courseDownloadProvider: courseDownloadProvider);

      Map<String, CourseDownloadDataModel> courseDownloadDataModelsMap = <String, CourseDownloadDataModel>{};
      List<CourseOfflineLaunchRequestModel> requestModels = <CourseOfflineLaunchRequestModel>[];

      for (TrackCourseDTOModel model in contentsList) {
        String downloadId = CourseDownloadDataModel.getDownloadId(contentId: model.ContentID, eventTrackContentId: parentCourseId);
        CourseDownloadDataModel? courseDownloadDataModel = courseDownloadProvider.getCourseDownloadDataModelFromId(courseDownloadId: downloadId);
        if (courseDownloadDataModel != null) {
          courseDownloadDataModel.trackCourseDTOModel = model;
          courseDownloadDataModelsMap[downloadId] = courseDownloadDataModel;

          CourseOfflineLaunchRequestModel? courseOfflineLaunchRequestModel = getCourseOfflineLaunchRequestModelFromCourseDownloadDataModel(downloadDataModel: courseDownloadDataModel);

          if (courseOfflineLaunchRequestModel == null) {
            MyPrint.printOnConsole("Continuing in Loop for CourseDownloadController().setContentToInProgress() because courseOfflineLaunchRequestModel is null", tag: tag);
            continue;
          }

          requestModels.add(courseOfflineLaunchRequestModel);
        }
      }

      MyPrint.printOnConsole("Final contentsList to Update Data:${requestModels.map((e) => e.ContentId).toList()}", tag: tag);

      if (courseDownloadDataModelsMap.isNotEmpty) futures.add(courseDownloadController.updateMultipleCourseDownload(courseDownloadDataModelsMap: courseDownloadDataModelsMap));
      if (requestModels.isNotEmpty) futures.add(CourseOfflineController().syncDataToOffline(requestModels: requestModels));
    }

    if (futures.isNotEmpty) await Future.wait(futures);

    MyPrint.printOnConsole("Track Contents Data Updated in Downloads and Offline Successfully", tag: tag);
  }

  Future<void> updateEventRelatedContentsInDownloadsAndSyncDataOffline({required List<RelatedTrackDataDTOModel> contentsList, required String parentCourseId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadController().updateEventRelatedContentsInDownloadsAndSyncDataOffline() called with contentsList:${contentsList.length}", tag: tag);

    AppProvider? appProvider = AppController.mainAppContext?.read<AppProvider>();

    List<Future> futures = <Future>[];

    if (appProvider != null) {
      CourseDownloadController courseDownloadController = CourseDownloadController(appProvider: appProvider, courseDownloadProvider: courseDownloadProvider);

      Map<String, CourseDownloadDataModel> courseDownloadDataModelsMap = <String, CourseDownloadDataModel>{};
      List<CourseOfflineLaunchRequestModel> requestModels = <CourseOfflineLaunchRequestModel>[];

      for (RelatedTrackDataDTOModel model in contentsList) {
        String downloadId = CourseDownloadDataModel.getDownloadId(contentId: model.ContentID, eventTrackContentId: parentCourseId);
        CourseDownloadDataModel? courseDownloadDataModel = courseDownloadProvider.getCourseDownloadDataModelFromId(courseDownloadId: downloadId);
        if (courseDownloadDataModel != null) {
          courseDownloadDataModel.relatedTrackDataDTOModel = model;
          courseDownloadDataModelsMap[downloadId] = courseDownloadDataModel;

          CourseOfflineLaunchRequestModel? courseOfflineLaunchRequestModel = getCourseOfflineLaunchRequestModelFromCourseDownloadDataModel(downloadDataModel: courseDownloadDataModel);

          if (courseOfflineLaunchRequestModel == null) {
            MyPrint.printOnConsole("Continuing in Loop for CourseDownloadController().updateEventRelatedContentsInDownloadsAndSyncDataOffline() because courseOfflineLaunchRequestModel is null",
                tag: tag);
            continue;
          }

          requestModels.add(courseOfflineLaunchRequestModel);
        }
      }

      MyPrint.printOnConsole("Final contentsList to Update Data:${requestModels.map((e) => e.ContentId).toList()}", tag: tag);

      if (courseDownloadDataModelsMap.isNotEmpty) futures.add(courseDownloadController.updateMultipleCourseDownload(courseDownloadDataModelsMap: courseDownloadDataModelsMap));
      if (requestModels.isNotEmpty) futures.add(CourseOfflineController().syncDataToOffline(requestModels: requestModels));
    }

    if (futures.isNotEmpty) await Future.wait(futures);

    MyPrint.printOnConsole("Event Related Contents Data Updated in Downloads and Offline Successfully", tag: tag);
  }

  Future<void> updateEventTrackParentModelInDownloadsAndHeaderModel({required String eventTrackContentId, String? CoreLessonStatus, String? DisplayStatus, double? PercentageCompleted}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
        "CourseDownloadController().updateEventTrackParentModelInDownloadsAndHeaderModel() called with eventTrackContentId:$eventTrackContentId,"
        " CoreLessonStatus:$CoreLessonStatus, DisplayStatus:$DisplayStatus, PercentageCompleted:$PercentageCompleted",
        tag: tag);

    if (eventTrackContentId.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().updateEventTrackParentModelInDownloadsAndSyncDataOffline() eventTrackContentId is empty", tag: tag);
      return;
    }

    Future eventTrackDownloadModelUpdateFuture = Future(() async {
      Map<String, CourseDownloadDataModel> courseDownloadDataModelsMap = <String, CourseDownloadDataModel>{};

      List<CourseDownloadDataModel> downloadDataModels = await getEventTrackContentDownloadsList(eventTrackContentId: eventTrackContentId);

      for (CourseDownloadDataModel downloadDataModel in downloadDataModels) {
        if (CoreLessonStatus != null) downloadDataModel.parentCourseModel?.ActualStatus = CoreLessonStatus;
        if (DisplayStatus != null) downloadDataModel.parentCourseModel?.ContentStatus = DisplayStatus;
        if (PercentageCompleted != null) downloadDataModel.parentCourseModel?.PercentCompleted = PercentageCompleted;
        courseDownloadDataModelsMap[downloadDataModel.id] = downloadDataModel;
      }

      MyPrint.printOnConsole("downloadDataModels length:${downloadDataModels.length}", tag: tag);
      await updateMultipleCourseDownload(courseDownloadDataModelsMap: courseDownloadDataModelsMap);

      MyPrint.printOnConsole("Updated Event Track Parent Model in Downloads", tag: tag);
    });

    Future eventTrackHeaderUpdateFuture = Future(() async {
      EventTrackHiveRepository eventTrackHiveRepository = EventTrackHiveRepository(apiController: ApiController());
      EventTrackHeaderDTOModel? eventTrackHeaderDTOModel = await eventTrackHiveRepository.getEventTrackHeaderDTOModelById(eventTrackContentId: eventTrackContentId);
      if (eventTrackHeaderDTOModel != null) {
        if (CoreLessonStatus != null) eventTrackHeaderDTOModel.ContentStatus = CoreLessonStatus;
        if (DisplayStatus != null) eventTrackHeaderDTOModel.DisplayStatus = DisplayStatus;
        if (PercentageCompleted != null) {
          eventTrackHeaderDTOModel.percentagecompleted = PercentageCompleted.getFormattedNumber(precision: 2) ?? "0";
        }
        await eventTrackHiveRepository.addEventTrackHeaderDTOModelInBox(headerData: {eventTrackHeaderDTOModel.ContentID: eventTrackHeaderDTOModel}, isClear: false);

        MyPrint.printOnConsole("Updated Event Track Header Model in Hive", tag: tag);
      }
    });

    await Future.wait([
      eventTrackDownloadModelUpdateFuture,
      eventTrackHeaderUpdateFuture,
    ]);

    MyPrint.printOnConsole("Updated Event Track Parent Data in Downloads and Hive", tag: tag);
  }

//endregion

  Future<void> checkAndValidateDownloadedItemsEnrollmentStatus() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseDownloadController().checkAndValidateDownloadedItemsEnrollmentStatus() called", tag: tag);

    CourseDownloadProvider provider = courseDownloadProvider;
    CourseDownloadRepository repository = courseDownloadRepository;

    if (!NetworkConnectionController().checkConnection()) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().checkAndValidateDownloadedItemsEnrollmentStatus() because no internet connection", tag: tag);
      return;
    }

    Map<String, CourseDownloadDataModel> courseDownloadModelsMap = provider.courseDownloadMap.getMap();

    // region Initialization of contentIdsToVerify
    // Map<ContentId, IsEventTrackContent>
    Map<String, bool> contentIdsToVerify = <String, bool>{};

    for (CourseDownloadDataModel courseDownloadDataModel in courseDownloadModelsMap.values) {
      String contentId = "";
      bool isEventTrackContent = false;

      if (courseDownloadDataModel.parentContentId.isNotEmpty) {
        contentId = courseDownloadDataModel.parentContentId;
        isEventTrackContent = true;
      } else {
        contentId = courseDownloadDataModel.contentId;
      }

      if (contentId.isNotEmpty && contentIdsToVerify[contentId] == null) {
        contentIdsToVerify[contentId] = isEventTrackContent;
      }
    }

    MyPrint.printOnConsole("Final contentIdsToVerify:$contentIdsToVerify", tag: tag);
    // endregion

    if (contentIdsToVerify.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().checkAndValidateDownloadedItemsEnrollmentStatus() because contentIdsToVerify is empty", tag: tag);
      return;
    }

    // region Get Enrollment Status for contentIdsToVerify
    DataResponseModel<CheckContentsEnrollmentStatusResponseModel?> responseModel = await MyLearningRepository(apiController: ApiController()).checkContentsEnrollmentStatus(
      requestModel: CheckContentsEnrollmentStatusRequestModel(contentIds: contentIdsToVerify.keys.toList()),
    );

    MyPrint.printOnConsole("checkContentsEnrollmentStatus response:$responseModel", tag: tag);

    if (responseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().checkAndValidateDownloadedItemsEnrollmentStatus() because Error Occurred in Api:${responseModel.appErrorModel?.message}",
          tag: tag);
      MyPrint.printOnConsole(responseModel.appErrorModel?.stackTrace ?? "", tag: tag);
      return;
    } else if (responseModel.data == null) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().checkAndValidateDownloadedItemsEnrollmentStatus() because Response Data is null", tag: tag);
      MyPrint.printOnConsole(responseModel.appErrorModel?.stackTrace ?? "", tag: tag);
      return;
    }

    CheckContentsEnrollmentStatusResponseModel checkContentsEnrollmentStatusResponseModel = responseModel.data!;
    MyPrint.printOnConsole("checkContentsEnrollmentStatusResponseModel:$checkContentsEnrollmentStatusResponseModel", tag: tag);
    // endregion

    // region Calculate Download Models To Remove From Download
    // Map<DownloadId, CourseOfflineLaunchRequestModel>
    Map<String, CourseOfflineLaunchRequestModel> requestModelsToRemoveFromDownload = <String, CourseOfflineLaunchRequestModel>{};

    for (MapEntry<String, CourseDownloadDataModel> mapEntry in courseDownloadModelsMap.entries) {
      CourseDownloadDataModel courseDownloadDataModel = mapEntry.value;

      MyPrint.printOnConsole("Checking Enrolled and Modified for ContentId:${courseDownloadDataModel.contentId}", tag: tag);
      CheckContentsEnrollmentStatusContentDataModel? checkContentsEnrollmentStatusContentDataModel = checkContentsEnrollmentStatusResponseModel.CourseData[courseDownloadDataModel.contentId];

      bool isRemove = false;

      if (checkContentsEnrollmentStatusContentDataModel == null) {
        MyPrint.printOnConsole("ContentId ${courseDownloadDataModel.contentId} Not Enrolled", tag: tag);
        isRemove = true;
      } else {
        if (courseDownloadDataModel.parentContentId.isNotEmpty) {
          MyPrint.printOnConsole("ContentId ${courseDownloadDataModel.contentId} Enrolled, Checking Modified Date", tag: tag);
          if (courseDownloadDataModel.parentContentTypeId == InstancyObjectTypes.track) {
            MyPrint.printOnConsole("ContentId ${courseDownloadDataModel.contentId} Is Track Content", tag: tag);
            if (courseDownloadDataModel.trackCourseDTOModel != null) {
              MyPrint.printOnConsole(
                  "For ContentId ${courseDownloadDataModel.contentId}, Saved Time:${courseDownloadDataModel.trackCourseDTOModel!.ContentModifiedDateTime}, Current Time:${checkContentsEnrollmentStatusContentDataModel.ModifiedDate}",
                  tag: tag);
              isRemove = checkContentsEnrollmentStatusContentDataModel.ModifiedDate != courseDownloadDataModel.trackCourseDTOModel!.ContentModifiedDateTime;
            }
          } else if (courseDownloadDataModel.parentContentTypeId == InstancyObjectTypes.events) {
            MyPrint.printOnConsole("ContentId ${courseDownloadDataModel.contentId} Is Event Related Content", tag: tag);
            if (courseDownloadDataModel.relatedTrackDataDTOModel != null) {
              MyPrint.printOnConsole(
                  "For ContentId ${courseDownloadDataModel.contentId}, Saved Time:${courseDownloadDataModel.relatedTrackDataDTOModel!.ContentModifiedDateTime}, Current Time:${checkContentsEnrollmentStatusContentDataModel.ModifiedDate}",
                  tag: tag);
              isRemove = checkContentsEnrollmentStatusContentDataModel.ModifiedDate != courseDownloadDataModel.relatedTrackDataDTOModel!.ContentModifiedDateTime;
            }
          }
        } else {
          if (courseDownloadDataModel.courseDTOModel != null) {
            MyPrint.printOnConsole("ContentId ${courseDownloadDataModel.contentId} Is Regular MyLearning Content", tag: tag);
            MyPrint.printOnConsole(
                "For ContentId ${courseDownloadDataModel.contentId}, Saved Time:${courseDownloadDataModel.courseDTOModel!.ContentModifiedDateTime}, Current Time:${checkContentsEnrollmentStatusContentDataModel.ModifiedDate}",
                tag: tag);
            isRemove = checkContentsEnrollmentStatusContentDataModel.ModifiedDate != courseDownloadDataModel.courseDTOModel!.ContentModifiedDateTime;
          }
        }
      }

      MyPrint.printOnConsole("isRemove:$isRemove", tag: tag);
      if (isRemove) {
        CourseOfflineLaunchRequestModel? courseOfflineLaunchRequestModel = getCourseOfflineLaunchRequestModelFromCourseDownloadDataModel(downloadDataModel: courseDownloadDataModel);
        if (courseOfflineLaunchRequestModel != null) {
          requestModelsToRemoveFromDownload[courseDownloadDataModel.id] = courseOfflineLaunchRequestModel;
        }
      }
    }
    MyPrint.printOnConsole("requestModelsToRemoveFromDownload:${requestModelsToRemoveFromDownload.keys.toList()}", tag: tag);

    if (requestModelsToRemoveFromDownload.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseDownloadController().checkAndValidateDownloadedItemsEnrollmentStatus() because requestModelsToRemoveFromDownload is empty", tag: tag);
      return;
    }
    // endregion

    // region Remove Course Tracking Data From Offline
    CourseOfflineController courseOfflineController = CourseOfflineController();
    await Future.wait([
      courseOfflineController.setCmiModelsFromRequestModels(
        requests: Map<CourseOfflineLaunchRequestModel, CMIModel?>.fromEntries(
          requestModelsToRemoveFromDownload.values.map<MapEntry<CourseOfflineLaunchRequestModel, CMIModel?>>(
            (e) => MapEntry<CourseOfflineLaunchRequestModel, CMIModel?>(e, null),
          ),
        ),
      ),
      courseOfflineController.setLearnerSessionModelsFromRequestModels(
        requests: Map<CourseOfflineLaunchRequestModel, CourseLearnerSessionResponseModel?>.fromEntries(
          requestModelsToRemoveFromDownload.values.map<MapEntry<CourseOfflineLaunchRequestModel, CourseLearnerSessionResponseModel?>>(
            (e) => MapEntry<CourseOfflineLaunchRequestModel, CourseLearnerSessionResponseModel?>(e, null),
          ),
        ),
      ),
      courseOfflineController.setStudentResponseModelsFromRequestModels(
        requests: Map<CourseOfflineLaunchRequestModel, StudentCourseResponseModel?>.fromEntries(
          requestModelsToRemoveFromDownload.values.map<MapEntry<CourseOfflineLaunchRequestModel, StudentCourseResponseModel?>>(
            (e) => MapEntry<CourseOfflineLaunchRequestModel, StudentCourseResponseModel?>(e, null),
          ),
        ),
      ),
    ]);
    // endregion

    // region Remove Course Download Models from Provider, Hive and File System
    bool isRemovedDownloadIdFromHive = false;
    bool isRemovedDownloadModelFromHive = false;

    List<String> downloadIdsToRemove = requestModelsToRemoveFromDownload.keys.toList();

    await Future.wait([
      repository.removeCourseDownloadIdsFromHive(downloadIds: downloadIdsToRemove).then((value) {
        isRemovedDownloadIdFromHive = value;
      }),
      repository.removeCourseDownloadDataModelsFromHive(downloadIds: downloadIdsToRemove).then((value) {
        isRemovedDownloadModelFromHive = value;
      }),
      ...downloadIdsToRemove.map((String downloadId) {
        return deleteCourseFromFileSystem(downloadId: downloadId, courseDownloadDataModel: courseDownloadModelsMap[downloadId]);
      }).toList(),
    ]);

    MyPrint.printOnConsole("isRemovedDownloadIdFromHive:$isRemovedDownloadIdFromHive", tag: tag);
    MyPrint.printOnConsole("isRemovedDownloadModelFromHive:$isRemovedDownloadModelFromHive", tag: tag);

    provider.courseDownloadList.removeItems(items: downloadIdsToRemove, isNotify: false);
    provider.courseDownloadMap.clearKeys(keys: downloadIdsToRemove, isNotify: true);
    // endregion

    MyPrint.printOnConsole("Validation of Course Downloads Successful", tag: tag);
  }
}
