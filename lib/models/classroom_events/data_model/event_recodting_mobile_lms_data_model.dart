import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class EventRecordingMobileLMSDataModel {
  String eventid = "";
  String eventrecording = "";
  String eventrecordingmessage = "";
  String eventrecordingurl = "";
  String eventrecordingcontentid = "";
  String eventrecordstatus = "";
  String recordingtype = "";
  String eventscoid = "";
  String language = "";
  double contentprogress = 0;
  dynamic contenttypeid;
  dynamic contentid;
  dynamic viewlink;
  dynamic scoid;
  dynamic jwvideokey;
  dynamic contentname;
  dynamic windowproperties;
  dynamic viewtype;
  dynamic wstatus;
  dynamic percentcompletedclass;

  EventRecordingMobileLMSDataModel({
    this.eventid = "",
    this.eventrecording = "",
    this.eventrecordingmessage = "",
    this.eventrecordingurl = "",
    this.eventrecordingcontentid = "",
    this.eventrecordstatus = "",
    this.recordingtype = "",
    this.eventscoid = "",
    this.language = "",
    this.contentprogress = 0,
    this.contenttypeid,
    this.contentid,
    this.viewlink,
    this.scoid,
    this.jwvideokey,
    this.contentname,
    this.windowproperties,
    this.viewtype,
    this.wstatus,
    this.percentcompletedclass,
  });

  EventRecordingMobileLMSDataModel.fromJson(Map<String, dynamic> json) {
    eventid = ParsingHelper.parseStringMethod(json["eventid"]);
    eventrecording = ParsingHelper.parseStringMethod(json["eventrecording"]);
    eventrecordingmessage = ParsingHelper.parseStringMethod(json["eventrecordingmessage"]);
    eventrecordingurl = ParsingHelper.parseStringMethod(json["eventrecordingurl"]);
    eventrecordingcontentid = ParsingHelper.parseStringMethod(json["eventrecordingcontentid"]);
    eventrecordstatus = ParsingHelper.parseStringMethod(json["eventrecordstatus"]);
    recordingtype = ParsingHelper.parseStringMethod(json["recordingtype"]);
    eventscoid = ParsingHelper.parseStringMethod(json["eventscoid"]);
    language = ParsingHelper.parseStringMethod(json["language"]);
    contentprogress = ParsingHelper.parseDoubleMethod(json['contentprogress']);
    contenttypeid = json["contenttypeid"];
    contentid = json["contentid"];
    viewlink = json["viewlink"];
    scoid = json["scoid"];
    jwvideokey = json["jwvideokey"];
    contentname = json["contentname"];
    windowproperties = json["windowproperties"];
    viewtype = json["viewtype"];
    wstatus = json["wstatus"];
    percentcompletedclass = json["percentcompletedclass"];
  }

  Map<String, dynamic> toJson({bool toJson = true}) {
    return {
      "eventid": eventid,
      "eventrecording": eventrecording,
      "eventrecordingmessage": eventrecordingmessage,
      "eventrecordingurl": eventrecordingurl,
      "eventrecordingcontentid": eventrecordingcontentid,
      "eventrecordstatus": eventrecordstatus,
      "recordingtype": recordingtype,
      "eventscoid": eventscoid,
      "language": language,
      "contentprogress": contentprogress,
      "contenttypeid": contenttypeid,
      "contentid": contentid,
      "viewlink": viewlink,
      "scoid": scoid,
      "jwvideokey": jwvideokey,
      "contentname": contentname,
      "windowproperties": windowproperties,
      "viewtype": viewtype,
      "wstatus": wstatus,
      "percentcompletedclass": percentcompletedclass,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson(toJson: true));
  }
}
