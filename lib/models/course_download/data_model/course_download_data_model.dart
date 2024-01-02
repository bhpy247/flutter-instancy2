import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class CourseDownloadDataModel {
  String id = "";
  String contentId = "";
  String taskId = "";
  String downloadFileUrl = "";
  String downloadFilePath = "";
  String downloadFileDirectoryPath = "";
  String downloadFileName = "";
  String eventTrackContentId = "";
  String eventTrackContentName = "";
  double totalDownloadPercentage = 0;
  double fileDownloadPercentage = 0;
  double zipFileExtractionPercentage = 0;
  DownloadTaskStatus downloadStatus = DownloadTaskStatus.undefined;
  CourseDTOModel? courseDTOModel;
  CourseDTOModel? trackModel;
  bool isEventTrackContent = false;
  bool isZip = false;
  bool isCourseDownloading = false;
  bool isCourseDownloaded = false;
  bool isFileDownloading = false;
  bool isFileDownloadingPaused = false;
  bool isFileDownloadCanceled = false;
  bool isFileDownloaded = false;
  bool isFileExtracting = false;
  bool isFileExtracted = false;

  CourseDownloadDataModel({
    this.id = "",
    this.contentId = "",
    this.taskId = "",
    this.downloadFileUrl = "",
    this.downloadFilePath = "",
    this.downloadFileDirectoryPath = "",
    this.downloadFileName = "",
    this.eventTrackContentId = "",
    this.eventTrackContentName = "",
    this.totalDownloadPercentage = 0,
    this.fileDownloadPercentage = 0,
    this.zipFileExtractionPercentage = 0,
    this.downloadStatus = DownloadTaskStatus.undefined,
    this.courseDTOModel,
    this.trackModel,
    this.isEventTrackContent = false,
    this.isZip = false,
    this.isCourseDownloading = false,
    this.isCourseDownloaded = false,
    this.isFileDownloading = false,
    this.isFileDownloadingPaused = false,
    this.isFileDownloadCanceled = false,
    this.isFileDownloaded = false,
    this.isFileExtracting = false,
    this.isFileExtracted = false,
  });

  CourseDownloadDataModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    id = ParsingHelper.parseStringMethod(map['id']);
    contentId = ParsingHelper.parseStringMethod(map['contentId']);
    taskId = ParsingHelper.parseStringMethod(map['taskId']);
    downloadFileUrl = ParsingHelper.parseStringMethod(map['downloadFileUrl']);
    downloadFilePath = ParsingHelper.parseStringMethod(map['downloadFilePath']);
    downloadFileDirectoryPath = ParsingHelper.parseStringMethod(map['downloadFileDirectoryPath']);
    downloadFileName = ParsingHelper.parseStringMethod(map['downloadFileName']);
    eventTrackContentId = ParsingHelper.parseStringMethod(map['eventTrackContentId']);
    eventTrackContentName = ParsingHelper.parseStringMethod(map['eventTrackContentName']);
    totalDownloadPercentage = ParsingHelper.parseDoubleMethod(map['totalDownloadPercentage']);
    fileDownloadPercentage = ParsingHelper.parseDoubleMethod(map['fileDownloadPercentage']);
    zipFileExtractionPercentage = ParsingHelper.parseDoubleMethod(map['zipFileExtractionPercentage']);

    try {
      downloadStatus = DownloadTaskStatus.fromInt(ParsingHelper.parseIntMethod(map['downloadStatus']));
    } catch (e, s) {
      MyPrint.printOnConsole("Error in Paring downloadStatus in CourseDownloadDataModel()._initializeFromMap():$e");
      MyPrint.printOnConsole(s);
    }

    Map<String, dynamic> courseDTOModelMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(map['courseDTOModel']);
    courseDTOModel = courseDTOModelMap.isNotEmpty ? CourseDTOModel.fromMap(courseDTOModelMap) : null;

    Map<String, dynamic> trackModelMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(map['trackModel']);
    trackModel = trackModelMap.isNotEmpty ? CourseDTOModel.fromMap(trackModelMap) : null;

    isEventTrackContent = ParsingHelper.parseBoolMethod(map['isEventTrackContent']);
    isZip = ParsingHelper.parseBoolMethod(map['isZip']);
    isCourseDownloading = ParsingHelper.parseBoolMethod(map['isCourseDownloading']);
    isCourseDownloaded = ParsingHelper.parseBoolMethod(map['isCourseDownloaded']);
    isFileDownloading = ParsingHelper.parseBoolMethod(map['isFileDownloading']);
    isFileDownloadingPaused = ParsingHelper.parseBoolMethod(map['isFileDownloadingPaused']);
    isFileDownloadCanceled = ParsingHelper.parseBoolMethod(map['isFileDownloadCanceled']);
    isFileDownloaded = ParsingHelper.parseBoolMethod(map['isFileDownloaded']);
    isFileExtracting = ParsingHelper.parseBoolMethod(map['isFileExtracting']);
    isFileExtracted = ParsingHelper.parseBoolMethod(map['isFileExtracted']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "contentId": contentId,
      "taskId": taskId,
      "downloadFileUrl": downloadFileUrl,
      "downloadFilePath": downloadFilePath,
      "downloadFileDirectoryPath": downloadFileDirectoryPath,
      "downloadFileName": downloadFileName,
      "eventTrackContentId": eventTrackContentId,
      "eventTrackContentName": eventTrackContentName,
      "totalDownloadPercentage": totalDownloadPercentage,
      "fileDownloadPercentage": fileDownloadPercentage,
      "zipFileExtractionPercentage": zipFileExtractionPercentage,
      "downloadStatus": downloadStatus.index,
      "courseDTOModel": courseDTOModel?.toMap(),
      "trackModel": trackModel?.toMap(),
      "isEventTrackContent": isEventTrackContent,
      "isZip": isZip,
      "isCourseDownloading": isCourseDownloading,
      "isCourseDownloaded": isCourseDownloaded,
      "isFileDownloading": isFileDownloading,
      "isFileDownloadingPaused": isFileDownloadingPaused,
      "isFileDownloadCanceled": isFileDownloadCanceled,
      "isFileDownloaded": isFileDownloaded,
      "isFileExtracting": isFileExtracting,
      "isFileExtracted": isFileExtracted,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }

  static String getDownloadId({required String contentId, String eventTrackContentId = ""}) {
    return "${eventTrackContentId.isNotEmpty ? "${eventTrackContentId}_" : ""}$contentId";
  }
}
