import '../../../utils/my_utils.dart';

class ViewRecordingRequestModel {
  String eventRecordingURL = "";
  int contentTypeId = 0;
  String contentID = "";
  String jwVideoPath = "";
  String scoID = "";
  String jWVideoKey = "";
  String contentName = "";
  String viewType = "";
  String recordingType = "";
  String language = "";
  bool eventRecording = false;

  ViewRecordingRequestModel({
    this.eventRecordingURL = "",
    this.contentTypeId = 0,
    this.contentID = "",
    this.jwVideoPath = "",
    this.scoID = "",
    this.jWVideoKey = "",
    this.contentName = "",
    this.viewType = "",
    this.recordingType = "",
    this.language = "",
    this.eventRecording = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "EventRecordingURL": eventRecordingURL,
      "ContentTypeId": contentTypeId,
      "ContentID": contentID,
      "jwVideoPath": jwVideoPath,
      "ScoID": scoID,
      "JWVideoKey": jWVideoKey,
      "ContentName": contentName,
      "ViewType": viewType,
      "RecordingType": recordingType,
      "Language": language,
      "EventRecording": eventRecording,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}