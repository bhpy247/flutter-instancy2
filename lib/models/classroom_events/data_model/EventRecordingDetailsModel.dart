import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../../utils/my_utils.dart';

class EventRecordingDetailsModel {
  String eventRecordingMessage = "";
  String eventRecordingURL = "";
  String eventRecordingContentID = "";
  String eventRecordStatus = "";
  String contentTypeId = "";
  String contentID = "";
  String viewLink = "";
  String scoID = "";
  String jWVideoKey = "";
  String contentName = "";
  String windowProperties = "";
  String viewType = "";
  String recordingType = "";
  String wstatus = "";
  String percentCompletedClass = "";
  String eventID = "";
  String language = "";
  String cloudMediaPlayerKey = "";
  bool eventRecording = false;
  int eventSCOID = 0;
  int contentProgress = 0;

  EventRecordingDetailsModel({
    this.eventRecordingMessage = "",
    this.eventRecordingURL = "",
    this.eventRecordingContentID = "",
    this.eventRecordStatus = "",
    this.contentTypeId = "",
    this.contentID = "",
    this.viewLink = "",
    this.scoID = "",
    this.jWVideoKey = "",
    this.contentName = "",
    this.windowProperties = "",
    this.viewType = "",
    this.recordingType = "",
    this.wstatus = "",
    this.percentCompletedClass = "",
    this.eventID = "",
    this.language = "",
    this.cloudMediaPlayerKey = "",
    this.eventRecording = false,
    this.eventSCOID = 0,
    this.contentProgress = 0,
  });

  EventRecordingDetailsModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    eventRecordingMessage = ParsingHelper.parseStringMethod(map['EventRecordingMessage']);
    eventRecordingURL = ParsingHelper.parseStringMethod(map['EventRecordingURL']);
    eventRecordingContentID = ParsingHelper.parseStringMethod(map['EventRecordingContentID']);
    eventRecordStatus = ParsingHelper.parseStringMethod(map['EventRecordStatus']);
    contentTypeId = ParsingHelper.parseStringMethod(map['ContentTypeId']);
    contentID = ParsingHelper.parseStringMethod(map['ContentID']);
    viewLink = ParsingHelper.parseStringMethod(map['ViewLink']);
    scoID = ParsingHelper.parseStringMethod(map['ScoID']);
    jWVideoKey = ParsingHelper.parseStringMethod(map['JWVideoKey']);
    contentName = ParsingHelper.parseStringMethod(map['ContentName']);
    windowProperties = ParsingHelper.parseStringMethod(map['WindowProperties']);
    viewType = ParsingHelper.parseStringMethod(map['ViewType']);
    recordingType = ParsingHelper.parseStringMethod(map['RecordingType']);
    wstatus = ParsingHelper.parseStringMethod(map['wstatus']);
    percentCompletedClass = ParsingHelper.parseStringMethod(map['PercentCompletedClass']);
    eventID = ParsingHelper.parseStringMethod(map['EventID']);
    language = ParsingHelper.parseStringMethod(map['Language']);
    cloudMediaPlayerKey = ParsingHelper.parseStringMethod(map['cloudMediaPlayerKey']);
    eventRecording = ParsingHelper.parseBoolMethod(map['EventRecording']);
    eventSCOID = ParsingHelper.parseIntMethod(map['EventSCOID']);
    contentProgress = ParsingHelper.parseIntMethod(map['ContentProgress']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "EventRecordingMessage": eventRecordingMessage,
      "EventRecordingURL": eventRecordingURL,
      "EventRecordingContentID": eventRecordingContentID,
      "EventRecordStatus": eventRecordStatus,
      "ContentTypeId": contentTypeId,
      "ContentID": contentID,
      "ViewLink": viewLink,
      "ScoID": scoID,
      "JWVideoKey": jWVideoKey,
      "ContentName": contentName,
      "WindowProperties": windowProperties,
      "ViewType": viewType,
      "RecordingType": recordingType,
      "wstatus": wstatus,
      "PercentCompletedClass": percentCompletedClass,
      "EventID": eventID,
      "Language": language,
      "cloudMediaPlayerKey": cloudMediaPlayerKey,
      "EventRecording": eventRecording,
      "EventSCOID": eventSCOID,
      "ContentProgress": contentProgress,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}