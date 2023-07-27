import 'dart:io';

import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_instancy_2/models/common/app_error_model.dart';
import 'package:flutter_instancy_2/models/course/data_model/gloassary_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/event_track_content_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/event_track_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/event_track_reference_item_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/track_block_model.dart';
import 'package:flutter_instancy_2/models/event_track/request_model/event_related_content_data_request_model.dart';
import 'package:flutter_instancy_2/models/event_track/request_model/event_track_tab_request_model.dart';
import 'package:flutter_instancy_2/models/event_track/request_model/track_content_data_request_model.dart';
import 'package:flutter_instancy_2/models/event_track/response_model/event_related_content_data_response_model.dart';
import 'package:flutter_instancy_2/models/event_track/response_model/event_track_resourse_response_model.dart';
import 'package:flutter_instancy_2/models/event_track/response_model/track_content_data_response_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:http/http.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../api/api_controller.dart';
import '../../models/classroom_events/data_model/event_recodting_mobile_lms_data_model.dart';
import '../../models/common/data_response_model.dart';
import '../../models/event_track/data_model/event_track_header_dto_model.dart';
import '../../models/event_track/data_model/event_track_tab_dto_model.dart';
import '../../models/event_track/request_model/event_track_headers_request_model.dart';
import '../../models/event_track/request_model/event_track_overview_request_model.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';
import 'event_track_provider.dart';
import 'event_track_repository.dart';

class EventTrackController {
  late EventTrackProvider _eventTrackProvider;
  late EventTrackRepository _eventTrackRepository;

  EventTrackController({required EventTrackProvider? learningPathProvider, EventTrackRepository? repository, ApiController? apiController}) {
    _eventTrackProvider = learningPathProvider ?? EventTrackProvider();
    _eventTrackRepository = repository ?? EventTrackRepository(apiController: apiController ?? ApiController());
  }

  EventTrackProvider get eventTrackProvider => _eventTrackProvider;

  EventTrackRepository get eventTrackRepository => _eventTrackRepository;

  Future<bool> getEventTrackHeaderData({
    required EventTrackHeadersRequestModel requestModel,
    bool isNotify = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("EventTrackController.getEventTrackHeaderData() called with requestModel:'$requestModel'", tag: tag);

    EventTrackProvider provider = eventTrackProvider;
    provider.isHeaderDataLoading.set(value: true, isNotify: isNotify);

    DataResponseModel<EventTrackHeaderDTOModel> dataResponseModel = await eventTrackRepository.getEventTrackTrackHeader(requestModel: requestModel);
    MyPrint.printOnConsole("getEventTrackTrackHeader response:$dataResponseModel", tag: tag);

    provider.eventTrackHeaderData.set(value: dataResponseModel.data ?? EventTrackHeaderDTOModel(), isNotify: false);
    provider.isHeaderDataLoading.set(value: false, isNotify: true);

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from EventTrackController.getEventTrackHeaderData() because getEventTrackTrackHeader had some error", tag: tag);
      return false;
    }

    return true;
  }

  Future<bool> getEventTrackTabsData({
    required EventTrackTabRequestModel requestModel,
    bool isNotify = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("EventTrackController().getLEventTrackTabsData() called with requestModel:'$requestModel'", tag: tag);

    EventTrackProvider provider = eventTrackProvider;
    provider.isTabListLoading.set(value: true, isNotify: isNotify);

    DataResponseModel<List<EventTrackTabDTOModel>> dataResponseModel = await eventTrackRepository.getEventTrackTabList(
      requestModel: requestModel,
    );

    MyPrint.printOnConsole("EventTrackTabDTOModelList response:$dataResponseModel", tag: tag);

    provider.eventTrackTabList.setList(list: dataResponseModel.data ?? [], isNotify: false);
    provider.isTabListLoading.set(value: false, isNotify: true);

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from EventTrackController.getLEventTrackTabsData() because getLearningPathTabList had some error", tag: tag);
      return false;
    }

    return true;
  }

  Future<bool> getOverviewData({
    required EventTrackOverviewRequestModel requestModel,
    bool isNotify = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("EventTrackController().getOverviewData() called with requestModel:'$requestModel'", tag: tag);

    EventTrackProvider provider = eventTrackProvider;
    provider.isOverviewDataLoading.set(value: true, isNotify: isNotify);

    DataResponseModel<List<EventTrackDTOModel>> dataResponseModel = await eventTrackRepository.getEventTrackOverviewData(
      requestModel: requestModel,
    );

    MyPrint.printOnConsole("EventTrackDTOModel response:$dataResponseModel", tag: tag);

    provider.overviewData.set(value: dataResponseModel.data?.firstElement, isNotify: false);
    provider.isOverviewDataLoading.set(value: false, isNotify: true);

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from EventTrackController.getOverviewData() because getEventTrackOverviewData had some error", tag: tag);
      return false;
    }

    return true;
  }

  Future<bool> getGlossaryData({
    required String contentId,
    bool isNotify = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("EventTrackController().getGlossaryData() called with contentId:'$contentId'", tag: tag);

    EventTrackProvider provider = eventTrackProvider;
    provider.isGlossaryDataLoading.set(value: true, isNotify: isNotify);

    DataResponseModel<List<GlossaryModel>> dataResponseModel = await eventTrackRepository.getGlossaryData(
      contentid: contentId,
    );

    MyPrint.printOnConsole("GlossaryModelList response:$dataResponseModel", tag: tag);

    provider.glossaryData.setList(list: dataResponseModel.data ?? <GlossaryModel>[], isNotify: false);
    provider.isGlossaryDataLoading.set(value: false, isNotify: true);

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from EventTrackController.getGlossaryData() because getGlossaryData had some error", tag: tag);
      return false;
    }

    return true;
  }

  Future<bool> getResourcesData({
    required String contentId,
    bool isNotify = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("EventTrackController().getResourcesData() called with contentId:'$contentId'", tag: tag);

    EventTrackProvider provider = eventTrackProvider;
    provider.isResourcesDataLoading.set(value: true, isNotify: isNotify);

    DataResponseModel<EventTrackResourceResponseModel> dataResponseModel = await eventTrackRepository.getResourcesData(
      contentid: contentId,
    );

    MyPrint.printOnConsole("EventTrackResourceResponseModel response:$dataResponseModel", tag: tag);

    provider.resourcesData.setList(list: dataResponseModel.data?.references?.referenceItem ?? <EventTrackReferenceItemModel>[], isNotify: false);
    provider.isResourcesDataLoading.set(value: false, isNotify: true);

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from EventTrackController.getResourcesData() because getResourcesData had some error", tag: tag);
      return false;
    }

    return true;
  }

  Future<bool> getContentsData({
    required String contentId,
    required int objectTypeId,
    int trackScoId = 0,
    required bool isRelatedContent,
    bool isNotify = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("EventTrackController().getContentsData() called with contentId:'$contentId'", tag: tag);

    EventTrackProvider provider = eventTrackProvider;
    provider.isContentsDataLoading.set(value: true, isNotify: isNotify);

    List<TrackBlockModel> blocksList = <TrackBlockModel>[];
    AppErrorModel? appErrorModel;

    if (isRelatedContent) {
      DataResponseModel<EventRelatedContentDataResponseModel> dataResponseModel = await eventTrackRepository.getEventRelatedContentData(
        requestModel: EventRelatedContentDataRequestModel(
          contentId: contentId,
        ),
      );
      MyPrint.printOnConsole("EventTrackResourceResponseModel response:$dataResponseModel", tag: tag);

      appErrorModel = dataResponseModel.appErrorModel;
      if (dataResponseModel.appErrorModel != null) {
        MyPrint.printOnConsole("Returning from EventTrackController.getContentsData() because getContentsData had some error", tag: tag);
      }

      if (dataResponseModel.data != null) {
        EventRelatedContentDataResponseModel responseModel = dataResponseModel.data!;

        TrackBlockModel defaultBlockModel = TrackBlockModel();
        defaultBlockModel.contents.addAll(responseModel.eventrelatedcontentdata);
        blocksList.add(defaultBlockModel);
      }
    } else {
      DataResponseModel<TrackContentDataResponseModel> dataResponseModel = await eventTrackRepository.getTrackContentData(
        requestModel: TrackContentDataRequestModel(
          ContentID: contentId,
          TrackObjectTypeID: objectTypeId,
          TrackScoID: trackScoId,
        ),
      );

      MyPrint.printOnConsole("EventTrackResourceResponseModel response:$dataResponseModel", tag: tag);

      appErrorModel = dataResponseModel.appErrorModel;
      if (dataResponseModel.appErrorModel != null) {
        MyPrint.printOnConsole("Returning from EventTrackController.getContentsData() because getContentsData had some error", tag: tag);
      }

      if (dataResponseModel.data != null) {
        TrackContentDataResponseModel responseModel = dataResponseModel.data!;

        TrackBlockModel defaultBlockModel = TrackBlockModel();
        Map<String, TrackBlockModel> blocksMap = <String, TrackBlockModel>{};

        //region Initialize Mapping of Blocks with Their Id
        blocksList.add(defaultBlockModel);

        for (TrackBlockModel element in responseModel.table8) {
          if (element.blockid.isEmpty || blocksMap.containsKey(element.blockid)) continue;

          blocksMap[element.blockid] = element;
          blocksList.add(element);
        }
        //endregion

        //region Initialize Mapping of Recordings with Their Id
        Map<String, EventRecordingMobileLMSDataModel> recordingsMap = <String, EventRecordingMobileLMSDataModel>{};
        for (EventRecordingMobileLMSDataModel element in responseModel.eventrecording) {
          if (element.eventid.isEmpty || recordingsMap.containsKey(element.eventid)) continue;

          recordingsMap[element.eventid] = element;
        }
        //endregion

        //region Add Contents into the block content according to parent id
        for (EventTrackContentModel element in responseModel.table5) {
          if (element.objectid.isNotEmpty) element.recordingModel = recordingsMap[element.objectid];

          if (element.parentid.isNotEmpty) {
            blocksMap[element.parentid]?.contents.add(element);
          } else {
            defaultBlockModel.contents.add(element);
          }
        }
        //endregion

        /*//region Sort Contents in Blocks According to Their sequencenumber
        for (TrackBlockModel element in blocksList) {
          element.contents.sort((a, b) => a.sequencenumber.compareTo(b.sequencenumber));
        }
        //endregion*/
      }
    }

    // MyPrint.printOnConsole("Blocks List:${blocksList.map((e) => e.blockname).toList()}");

    provider.contentsData.setList(list: blocksList, isClear: true, isNotify: false);
    provider.isContentsDataLoading.set(value: false, isNotify: true);

    if (appErrorModel != null) {
      return false;
    }

    return true;
  }


  //region Simple File Download
 Future<bool> simpleDownloadFileAndSave({required String downloadUrl, required String downloadFileName, String downloadFolderPath = ""}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
      "EventTrackController.simpleDownloadFileAndSave() called with downloadUrl:'$downloadUrl', "
          "downloadFileName:'$downloadFileName', downloadFolderPath:'$downloadFolderPath'",
      tag: tag,
    );

    try {
      if (kIsWeb) {
        MyPrint.printOnConsole("Returning from EventTrackController.simpleDownloadFileAndSave() because running on web platform.", tag: tag);
        return false;
      }

      if (downloadUrl.isEmpty) {
        MyPrint.printOnConsole("Returning from EventTrackController.simpleDownloadFileAndSave() because downloadUrl is empty", tag: tag);
        return false;
      }

      if (downloadFileName.isEmpty) {
        MyPrint.printOnConsole("Returning from EventTrackController.simpleDownloadFileAndSave() because downloadFileName is empty", tag: tag);
        return false;
      }

      String pathSeparator = Platform.pathSeparator;
      MyPrint.printOnConsole("pathSeparator:'$pathSeparator'", tag: tag);
      if (pathSeparator.isEmpty) {
        MyPrint.printOnConsole("Returning from EventTrackController.simpleDownloadFileAndSave() because pathSeparator is empty", tag: tag);
        return false;
      }

      Uint8List? bytes = await downloadFile(url: downloadUrl);
      MyPrint.printOnConsole("bytes:'${bytes?.length}'", tag: tag);
      if (bytes == null) {
        MyPrint.printOnConsole("Returning from EventTrackController.simpleDownloadFileAndSave() because bytes are null", tag: tag);
        return false;
      }

      bool isDownloaded = await downloadFileFromBytes(bytes: bytes, downloadFileName: downloadFileName);
      MyPrint.printOnConsole("isDownloaded:'$isDownloaded'", tag: tag);

      return isDownloaded;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in EventTrackController.simpleDownloadFileAndSave():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return false;
    }
  }

  static Future<Uint8List?> downloadFile({required String url}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("`EventTrackController`.downloadFile() called with url:'$url'", tag: tag);

    Response? response;

    try {
      response = await get(Uri.parse(url));

      return response.bodyBytes;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in EventTrackController.downloadFile():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return null;
    }
  }

  static Future<String> getDownloadsDirectoryPath() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("EventTrackController.getDownloadsDirectoryPath() called", tag: tag);

    if (kIsWeb) {
      MyPrint.printOnConsole("Returning from EventTrackController.getDownloadsDirectoryPath() because running on web platform.", tag: tag);
      return "";
    }

    //region Download Directory Path Initialization
    String downloadDirectoryPath = "";

    if (Platform.isAndroid) {
      downloadDirectoryPath = "/storage/emulated/0/Download";
    } else if (Platform.isIOS) {
      try {
        downloadDirectoryPath = (await getApplicationDocumentsDirectory()).path;
      } catch (e, s) {
        MyPrint.printOnConsole("Error in EventTrackController.getDownloadsDirectoryPath():$e", tag: tag);
        MyPrint.printOnConsole(s, tag: tag);
      }
    }

    if (downloadDirectoryPath.isEmpty) {
      MyPrint.printOnConsole("Returning from EventTrackController.getDownloadsDirectoryPath() because downloadDirectoryPath is empty", tag: tag);
      return "";
    }
    //endregion

    //region Download Directory Existance Verification
    MyPrint.printOnConsole("downloadDirectoryPath checking for existance:'$downloadDirectoryPath'", tag: tag);
    try {
      Directory savedDir = Directory(downloadDirectoryPath);
      bool directoryExist = await savedDir.exists();
      MyPrint.printOnConsole("directoryExist:$directoryExist", tag: tag);

      if (!directoryExist) {
        MyPrint.printOnConsole("Creating Directory", tag: tag);
        savedDir = await savedDir.create(recursive: true);

        directoryExist = await savedDir.exists();
        MyPrint.printOnConsole("directoryExist after creation:$directoryExist", tag: tag);
        if (!directoryExist) {
          MyPrint.printOnConsole("Returning from EventTrackController.getDownloadsDirectoryPath() because couldn't create download directory", tag: tag);
          return "";
        }
      }

      MyPrint.printOnConsole("Final downloadDirectoryPath:'$downloadDirectoryPath'", tag: tag);
      return downloadDirectoryPath;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in Checking Directory Exist in EventTrackController.getDownloadsDirectoryPath():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return "";
    }
    //endregion
  }

  static Future<bool> downloadFileFromBytes({required Uint8List bytes, String downloadFileName = ""}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("EventTrackController.downloadFileFromBytes() called with bytes:'${bytes.length}'", tag: tag);

    if (kIsWeb) {
      MyPrint.printOnConsole("Returning from EventTrackController.downloadFileFromBytes() because running on web platform.", tag: tag);
      return false;
    }

    if (downloadFileName.isEmpty) {
      MyPrint.printOnConsole("Returning from EventTrackController.downloadFileFromBytes() because downloadFileName is empty", tag: tag);
      return false;
    }

    //region Permission Validation
    List<Permission> permissions = [Permission.storage];

    for (Permission permission in permissions) {
      PermissionStatus permissionStatus = await permission.status;
      MyPrint.printOnConsole("Permission Status For $permission:$permissionStatus", tag: tag);

      if ([PermissionStatus.denied].contains(permissionStatus)) {
        permissionStatus = await permission.request();
      }
      MyPrint.printOnConsole("Final Permission Status For $permission:$permissionStatus", tag: tag);
      /*if (![PermissionStatus.granted, PermissionStatus.restricted].contains(permissionStatus)) {
        MyPrint.printOnConsole("Returning from EventTrackController.downloadFileFromBytes() because $permission not granted", tag: tag);
        MyPrint.printOnConsole("$permission Permission Not Granted", tag: tag);
        return false;
      }*/
    }
    //endregion

    try {
      //Save single text file
      String mimeType = lookupMimeType(downloadFileName) ?? "application/octet-stream";
      MyPrint.printOnConsole("mimeTypeL:'$mimeType'", tag: tag);
      await DocumentFileSavePlus().saveFile(bytes, downloadFileName, mimeType);
      return true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in EventTrackController.downloadFileFromBytes():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return false;
    }
  }

  static Future<bool> saveBytesInFile2({required Uint8List bytes, String downloadFilePath = "", String downloadFileName = "", bool askForDirectory = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("EventTrackController.saveBytesInFile2() called with bytes:'${bytes.length}', downloadFilePath:'$downloadFilePath'", tag: tag);

    if (kIsWeb) {
      MyPrint.printOnConsole("Returning from EventTrackController.saveBytesInFile2() because running on web platform.", tag: tag);
      return false;
    }

    if (downloadFileName.isEmpty) {
      MyPrint.printOnConsole("Returning from EventTrackController.saveBytesInFile2() because downloadFileName is empty", tag: tag);
      return false;
    }

    if (!askForDirectory) {
      if (downloadFilePath.isEmpty) {
        MyPrint.printOnConsole("Returning from EventTrackController.saveBytesInFile2() because downloadFilePath is empty", tag: tag);
        return false;
      }
    }
    else {
      if(downloadFileName.isEmpty) {
        MyPrint.printOnConsole("Returning from EventTrackController.saveBytesInFile2() because downloadFileName is empty", tag: tag);
        return false;
      }
    }

    //region Permission Validation
    List<Permission> permissions = [Permission.storage];
    if (Platform.isAndroid) {
      permissions.addAll([Permission.accessMediaLocation, Permission.manageExternalStorage]);
    } else if (Platform.isIOS) {
      permissions.add(Permission.mediaLibrary);
    }

    for (Permission permission in permissions) {
      PermissionStatus permissionStatus = await permission.status;
      MyPrint.printOnConsole("Permission Status For $permission:$permissionStatus", tag: tag);

      if (![PermissionStatus.granted, PermissionStatus.restricted].contains(permissionStatus)) {
        permissionStatus = await permission.request();
      }
      MyPrint.printOnConsole("Final Permission Status For $permission:$permissionStatus", tag: tag);
      /*if (![PermissionStatus.granted, PermissionStatus.restricted].contains(permissionStatus)) {
        MyPrint.printOnConsole("Returning from EventTrackController.saveBytesInFile2() because $permission not granted", tag: tag);
        MyPrint.printOnConsole("$permission Permission Not Granted", tag: tag);
        return false;
      }*/
    }
    //endregion

    try {
      String pathSeparator = Platform.pathSeparator;
      MyPrint.printOnConsole("pathSeparator:'$pathSeparator'", tag: tag);
      if (pathSeparator.isEmpty) {
        MyPrint.printOnConsole("Returning from saveBytesInFile2() because pathSeparator is empty", tag: tag);
        return false;
      }

      if (askForDirectory) {
        String? directoryPath = await FilePicker.platform.getDirectoryPath(
          dialogTitle: "Save",
        );
        if (directoryPath.checkEmpty) {
          MyPrint.printOnConsole("Returning from EventTrackController.saveBytesInFile2() because Save Directory Path is empty", tag: tag);
          return false;
        }
        downloadFilePath = "$directoryPath$pathSeparator$downloadFileName";
      }

      MyPrint.printOnConsole("Final downloadFilePath:'$downloadFilePath'");

      File file = File(downloadFilePath);

      bool fileExist = await file.exists();
      MyPrint.printOnConsole("fileExist:$fileExist", tag: tag);

      if (fileExist) {
        MyPrint.printOnConsole("Deleting File", tag: tag);
        try {
          await file.delete(recursive: true);
          MyPrint.printOnConsole("File Deleted", tag: tag);
        }
        catch(e, s) {
          MyPrint.printOnConsole("Error in Deleting File in EventTrackController.saveBytesInFile2():$e", tag: tag);
          MyPrint.printOnConsole(s, tag: tag);
        }
      }

      if (!fileExist) {
        MyPrint.printOnConsole("Creating File", tag: tag);
        try {
          file = await file.create(recursive: true);
          MyPrint.printOnConsole("File Created", tag: tag);
        } catch (e, s) {
          MyPrint.printOnConsole("Error in Creating File in EventTrackController.saveBytesInFile2():$e", tag: tag);
          MyPrint.printOnConsole(s, tag: tag);
        }

        /*fileExist = await file.exists();
        MyPrint.printOnConsole("fileExist after creation:$fileExist", tag: tag);
        if (!fileExist) {
          MyPrint.printOnConsole("Returning from EventTrackController.getDownloadsDirectoryPath() because couldn't create download file", tag: tag);
          return false;
        }*/
      }

      MyPrint.printOnConsole("Writing in File", tag: tag);
      await file.open(mode: FileMode.write);
      file = await file.writeAsBytes(bytes);

      return true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in EventTrackController.saveBytesInFile2():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return false;
    }
  }
//endregion

}
