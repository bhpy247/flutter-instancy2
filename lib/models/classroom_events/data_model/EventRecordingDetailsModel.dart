import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../../utils/my_utils.dart';

class EventRecordingDetailsModel {
  String EventRecordingMessage = "";
  String EventRecordingURL = "";
  String EventRecordingContentID = "";
  String EventRecordStatus = "";
  String ContentTypeId = "";
  String ContentID = "";
  String ViewLink = "";
  String ScoID = "";
  String JWVideoKey = "";
  String ContentName = "";
  String WindowProperties = "";
  String ViewType = "";
  String RecordingType = "";
  String wstatus = "";
  String PercentCompletedClass = "";
  String EventID = "";
  String Language = "";
  String cloudMediaPlayerKey = "";
  bool EventRecording = false;
  int EventSCOID = 0;
  int ContentProgress = 0;

  EventRecordingDetailsModel({
    this.EventRecordingMessage = "",
    this.EventRecordingURL = "",
    this.EventRecordingContentID = "",
    this.EventRecordStatus = "",
    this.ContentTypeId = "",
    this.ContentID = "",
    this.ViewLink = "",
    this.ScoID = "",
    this.JWVideoKey = "",
    this.ContentName = "",
    this.WindowProperties = "",
    this.ViewType = "",
    this.RecordingType = "",
    this.wstatus = "",
    this.PercentCompletedClass = "",
    this.EventID = "",
    this.Language = "",
    this.cloudMediaPlayerKey = "",
    this.EventRecording = false,
    this.EventSCOID = 0,
    this.ContentProgress = 0,
  });

  EventRecordingDetailsModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    EventRecordingMessage = ParsingHelper.parseStringMethod(map['EventRecordingMessage']);
    EventRecordingURL = ParsingHelper.parseStringMethod(map['EventRecordingURL']);
    EventRecordingContentID = ParsingHelper.parseStringMethod(map['EventRecordingContentID']);
    EventRecordStatus = ParsingHelper.parseStringMethod(map['EventRecordStatus']);
    ContentTypeId = ParsingHelper.parseStringMethod(map['ContentTypeId']);
    ContentID = ParsingHelper.parseStringMethod(map['ContentID']);
    ViewLink = ParsingHelper.parseStringMethod(map['ViewLink']);
    ScoID = ParsingHelper.parseStringMethod(map['ScoID']);
    JWVideoKey = ParsingHelper.parseStringMethod(map['JWVideoKey']);
    ContentName = ParsingHelper.parseStringMethod(map['ContentName']);
    WindowProperties = ParsingHelper.parseStringMethod(map['WindowProperties']);
    ViewType = ParsingHelper.parseStringMethod(map['ViewType']);
    RecordingType = ParsingHelper.parseStringMethod(map['RecordingType']);
    wstatus = ParsingHelper.parseStringMethod(map['wstatus']);
    PercentCompletedClass = ParsingHelper.parseStringMethod(map['PercentCompletedClass']);
    EventID = ParsingHelper.parseStringMethod(map['EventID']);
    Language = ParsingHelper.parseStringMethod(map['Language']);
    cloudMediaPlayerKey = ParsingHelper.parseStringMethod(map['cloudMediaPlayerKey']);
    EventRecording = ParsingHelper.parseBoolMethod(map['EventRecording']);
    EventSCOID = ParsingHelper.parseIntMethod(map['EventSCOID']);
    ContentProgress = ParsingHelper.parseIntMethod(map['ContentProgress']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "EventRecordingMessage": EventRecordingMessage,
      "EventRecordingURL": EventRecordingURL,
      "EventRecordingContentID": EventRecordingContentID,
      "EventRecordStatus": EventRecordStatus,
      "ContentTypeId": ContentTypeId,
      "ContentID": ContentID,
      "ViewLink": ViewLink,
      "ScoID": ScoID,
      "JWVideoKey": JWVideoKey,
      "ContentName": ContentName,
      "WindowProperties": WindowProperties,
      "ViewType": ViewType,
      "RecordingType": RecordingType,
      "wstatus": wstatus,
      "PercentCompletedClass": PercentCompletedClass,
      "EventID": EventID,
      "Language": Language,
      "cloudMediaPlayerKey": cloudMediaPlayerKey,
      "EventRecording": EventRecording,
      "EventSCOID": EventSCOID,
      "ContentProgress": ContentProgress,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}