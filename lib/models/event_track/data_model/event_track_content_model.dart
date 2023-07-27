import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../../utils/my_utils.dart';
import '../../classroom_events/data_model/event_recodting_mobile_lms_data_model.dart';

class EventTrackContentModel {
  String objectid = "";
  String contentid = "";
  String folderpath = "";
  String startpage = "";
  String name = "";
  String iconpath = "";
  String saleprice = "";
  String thumbnailimagepath = "";
  String contenttypethumbnail = "";
  String medianame = "";
  String version = "";
  String author = "";
  String listprice = "";
  String currency = "";
  String shortdescription = "";
  String longdescription = "";
  String createddate = "";
  String eventstartdatetime = "";
  String eventenddatetime = "";
  String participanturl = "";
  String timezone = "";
  String eventfulllocation = "";
  String objectfolderid = "";
  String parentid = "";
  String eventparentid = "";
  String jwvideokey = "";
  String cloudmediaplayerkey = "";
  String presentername = "";
  String percentcompleted = "";
  String corelessonstatus = "";
  String actualstatus = "";
  String jwstartpage = "";
  String eventid = "";
  String activityid = "";
  String progress = "";
  String actionviewqrcode = "";
  String qrimagename = "";
  String allowednavigation = "";
  String wstatus = "";
  String description = "";
  String contenttype = "";
  String language = "";
  String keywords = "";
  String publisheddate = "";
  String certificatepage = "";
  String certificateid = "";
  String status = "";
  String publicationdate = "";
  String activatedate = "";
  String expirydate = "";
  String folderid = "";
  String modifieddate = "";
  String windowproperties = "";
  String launchwindowmode = "";
  String contentstatus = "";
  String outputtype = "";
  String bit3 = "";
  String bit4 = "";
  String authordisplayname = "";
  String duration = "";
  String attemptsleft = "";
  String wresult = "";
  String wmessage = "";
  String invitationurl = "";
  String link = "";
  String pareportlink = "";
  String dareportlink = "";
  String disaplystatus = "";
  int objecttypeid = 0;
  int mediatypeid = 0;
  int viewtype = 0;
  int scoid = 0;
  int sequencenumber = 0;
  int devicetypeid = 0;
  int ratingid = 0;
  int eventscheduletype = 0;
  int eventtype = 0;
  int typeofevent = 0;
  int userid = 0;
  int createduserid = 0;
  int cmsgroupid = 0;
  int modifieduserid = 0;
  int totalratings = 0;
  int totalattempts = 0;
  int accessperiodtype = 0;
  int assignedby = 0;
  int displayorder = 0;
  int grading = 0;
  int isprivate = 0;
  int relatedconentcount = 0;
  bool downloadable = false;
  bool bit5 = false;
  bool iscontent = false;
  bool active = false;
  bool bit1 = false;
  bool isdeleted = false;
  bool usercontentstatus = false;
  bool bit11 = false;
  bool isBadCancellationEnabled = false;
  EventRecordingMobileLMSDataModel? recordingModel;

  EventTrackContentModel({
    this.objectid = "",
    this.contentid = "",
    this.folderpath = "",
    this.startpage = "",
    this.name = "",
    this.iconpath = "",
    this.saleprice = "",
    this.thumbnailimagepath = "",
    this.contenttypethumbnail = "",
    this.medianame = "",
    this.version = "",
    this.author = "",
    this.listprice = "",
    this.currency = "",
    this.shortdescription = "",
    this.longdescription = "",
    this.createddate = "",
    this.eventstartdatetime = "",
    this.eventenddatetime = "",
    this.participanturl = "",
    this.timezone = "",
    this.eventfulllocation = "",
    this.objectfolderid = "",
    this.parentid = "",
    this.eventparentid = "",
    this.jwvideokey = "",
    this.cloudmediaplayerkey = "",
    this.presentername = "",
    this.percentcompleted = "",
    this.corelessonstatus = "",
    this.actualstatus = "",
    this.jwstartpage = "",
    this.eventid = "",
    this.activityid = "",
    this.progress = "",
    this.actionviewqrcode = "",
    this.qrimagename = "",
    this.allowednavigation = "",
    this.wstatus = "",
    this.description = "",
    this.contenttype = "",
    this.language = "",
    this.keywords = "",
    this.publisheddate = "",
    this.certificatepage = "",
    this.certificateid = "",
    this.status = "",
    this.publicationdate = "",
    this.activatedate = "",
    this.expirydate = "",
    this.folderid = "",
    this.modifieddate = "",
    this.windowproperties = "",
    this.launchwindowmode = "",
    this.contentstatus = "",
    this.outputtype = "",
    this.bit3 = "",
    this.bit4 = "",
    this.authordisplayname = "",
    this.duration = "",
    this.attemptsleft = "",
    this.wresult = "",
    this.wmessage = "",
    this.invitationurl = "",
    this.link = "",
    this.pareportlink = "",
    this.dareportlink = "",
    this.disaplystatus = "",
    this.objecttypeid = 0,
    this.mediatypeid = 0,
    this.viewtype = 0,
    this.scoid = 0,
    this.sequencenumber = 0,
    this.devicetypeid = 0,
    this.ratingid = 0,
    this.eventscheduletype = 0,
    this.eventtype = 0,
    this.typeofevent = 0,
    this.userid = 0,
    this.createduserid = 0,
    this.cmsgroupid = 0,
    this.modifieduserid = 0,
    this.totalratings = 0,
    this.totalattempts = 0,
    this.accessperiodtype = 0,
    this.assignedby = 0,
    this.displayorder = 0,
    this.grading = 0,
    this.isprivate = 0,
    this.relatedconentcount = 0,
    this.downloadable = false,
    this.bit5 = false,
    this.iscontent = false,
    this.active = false,
    this.bit1 = false,
    this.isdeleted = false,
    this.usercontentstatus = false,
    this.bit11 = false,
    this.isBadCancellationEnabled = false,
    this.recordingModel,
  });

  EventTrackContentModel.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> json) {
    objectid = ParsingHelper.parseStringMethod(json["objectid"]);
    contentid = ParsingHelper.parseStringMethod(json["contentid"]);
    folderpath = ParsingHelper.parseStringMethod(json["folderpath"]);
    startpage = ParsingHelper.parseStringMethod(json["startpage"]);
    name = ParsingHelper.parseStringMethod(json["name"]);
    iconpath = ParsingHelper.parseStringMethod(json["iconpath"]);
    saleprice = ParsingHelper.parseStringMethod(json["saleprice"]);
    thumbnailimagepath = ParsingHelper.parseStringMethod(json["thumbnailimagepath"]);
    contenttypethumbnail = ParsingHelper.parseStringMethod(json["contenttypethumbnail"]);
    medianame = ParsingHelper.parseStringMethod(json["medianame"]);
    version = ParsingHelper.parseStringMethod(json["version"]);
    author = ParsingHelper.parseStringMethod(json["author"]);
    listprice = ParsingHelper.parseStringMethod(json["listprice"]);
    currency = ParsingHelper.parseStringMethod(json["currency"]);
    shortdescription = ParsingHelper.parseStringMethod(json["shortdescription"]);
    longdescription = ParsingHelper.parseStringMethod(json["longdescription"]);
    createddate = ParsingHelper.parseStringMethod(json["createddate"]);
    eventstartdatetime = ParsingHelper.parseStringMethod(json["eventstartdatetime"]);
    eventenddatetime = ParsingHelper.parseStringMethod(json["eventenddatetime"]);
    participanturl = ParsingHelper.parseStringMethod(json["participanturl"]);
    timezone = ParsingHelper.parseStringMethod(json["timezone"]);
    eventfulllocation = ParsingHelper.parseStringMethod(json["eventfulllocation"]);
    objectfolderid = ParsingHelper.parseStringMethod(json["objectfolderid"]);
    parentid = ParsingHelper.parseStringMethod(json["parentid"]);
    eventparentid = ParsingHelper.parseStringMethod(json["eventparentid"]);
    jwvideokey = ParsingHelper.parseStringMethod(json["jwvideokey"]);
    cloudmediaplayerkey = ParsingHelper.parseStringMethod(json["cloudmediaplayerkey"]);
    presentername = ParsingHelper.parseStringMethod(json["presentername"]);
    percentcompleted = ParsingHelper.parseStringMethod(json["percentcompleted"]);
    corelessonstatus = ParsingHelper.parseStringMethod(json["corelessonstatus"]);
    actualstatus = ParsingHelper.parseStringMethod(json["actualstatus"]);
    jwstartpage = ParsingHelper.parseStringMethod(json["jwstartpage"]);
    eventid = ParsingHelper.parseStringMethod(json["eventid"]);
    activityid = ParsingHelper.parseStringMethod(json["activityid"]);
    progress = ParsingHelper.parseStringMethod(json["progress"]);
    actionviewqrcode = ParsingHelper.parseStringMethod(json["actionviewqrcode"]);
    qrimagename = ParsingHelper.parseStringMethod(json["qrimagename"]);
    allowednavigation = ParsingHelper.parseStringMethod(json["allowednavigation"]);
    wstatus = ParsingHelper.parseStringMethod(json["wstatus"]);
    description = ParsingHelper.parseStringMethod(json["description"]);
    contenttype = ParsingHelper.parseStringMethod(json["contenttype"]);
    language = ParsingHelper.parseStringMethod(json["language"]);
    keywords = ParsingHelper.parseStringMethod(json["keywords"]);
    publisheddate = ParsingHelper.parseStringMethod(json["publisheddate"]);
    certificatepage = ParsingHelper.parseStringMethod(json["certificatepage"]);
    certificateid = ParsingHelper.parseStringMethod(json["certificateid"]);
    status = ParsingHelper.parseStringMethod(json["status"]);
    publicationdate = ParsingHelper.parseStringMethod(json["publicationdate"]);
    activatedate = ParsingHelper.parseStringMethod(json["activatedate"]);
    expirydate = ParsingHelper.parseStringMethod(json["expirydate"]);
    folderid = ParsingHelper.parseStringMethod(json["folderid"]);
    modifieddate = ParsingHelper.parseStringMethod(json["modifieddate"]);
    windowproperties = ParsingHelper.parseStringMethod(json["windowproperties"]);
    launchwindowmode = ParsingHelper.parseStringMethod(json["launchwindowmode"]);
    contentstatus = ParsingHelper.parseStringMethod(json["contentstatus"]);
    outputtype = ParsingHelper.parseStringMethod(json["outputtype"]);
    bit3 = ParsingHelper.parseStringMethod(json["bit3"]);
    bit4 = ParsingHelper.parseStringMethod(json["bit4"]);
    authordisplayname = ParsingHelper.parseStringMethod(json["authordisplayname"]);
    duration = ParsingHelper.parseStringMethod(json["duration"]);
    attemptsleft = ParsingHelper.parseStringMethod(json["attemptsleft"]);
    wresult = ParsingHelper.parseStringMethod(json["wresult"]);
    wmessage = ParsingHelper.parseStringMethod(json["wmessage"]);
    invitationurl = ParsingHelper.parseStringMethod(json["invitationurl"]);
    link = ParsingHelper.parseStringMethod(json["link"]);
    pareportlink = ParsingHelper.parseStringMethod(json["pareportlink"]);
    dareportlink = ParsingHelper.parseStringMethod(json["dareportlink"]);
    disaplystatus = ParsingHelper.parseStringMethod(json["disaplystatus"]);
    objecttypeid = ParsingHelper.parseIntMethod(json["objecttypeid"]);
    mediatypeid = ParsingHelper.parseIntMethod(json["mediatypeid"]);
    viewtype = ParsingHelper.parseIntMethod(json["viewtype"]);
    scoid = ParsingHelper.parseIntMethod(json["scoid"]);
    sequencenumber = ParsingHelper.parseIntMethod(json["sequencenumber"]);
    devicetypeid = ParsingHelper.parseIntMethod(json["devicetypeid"]);
    ratingid = ParsingHelper.parseIntMethod(json["ratingid"]);
    eventscheduletype = ParsingHelper.parseIntMethod(json["eventscheduletype"]);
    eventtype = ParsingHelper.parseIntMethod(json["eventtype"]);
    typeofevent = ParsingHelper.parseIntMethod(json["typeofevent"]);
    userid = ParsingHelper.parseIntMethod(json["userid"]);
    createduserid = ParsingHelper.parseIntMethod(json["createduserid"]);
    cmsgroupid = ParsingHelper.parseIntMethod(json["cmsgroupid"]);
    modifieduserid = ParsingHelper.parseIntMethod(json["modifieduserid"]);
    totalratings = ParsingHelper.parseIntMethod(json["totalratings"]);
    totalattempts = ParsingHelper.parseIntMethod(json["totalattempts"]);
    accessperiodtype = ParsingHelper.parseIntMethod(json["accessperiodtype"]);
    assignedby = ParsingHelper.parseIntMethod(json["assignedby"]);
    displayorder = ParsingHelper.parseIntMethod(json["displayorder"]);
    grading = ParsingHelper.parseIntMethod(json["grading"]);
    isprivate = ParsingHelper.parseIntMethod(json["isprivate"]);
    relatedconentcount = ParsingHelper.parseIntMethod(json["relatedconentcount"]);
    downloadable = ParsingHelper.parseBoolMethod(json["downloadable"]);
    bit5 = ParsingHelper.parseBoolMethod(json["bit5"]);
    iscontent = ParsingHelper.parseBoolMethod(json["iscontent"]);
    active = ParsingHelper.parseBoolMethod(json["active"]);
    bit1 = ParsingHelper.parseBoolMethod(json["bit1"]);
    isdeleted = ParsingHelper.parseBoolMethod(json["isdeleted"]);
    usercontentstatus = ParsingHelper.parseBoolMethod(json["usercontentstatus"]);
    bit11 = ParsingHelper.parseBoolMethod(json["bit11"]);
    isBadCancellationEnabled = ParsingHelper.parseBoolMethod(json["isBadCancellationEnabled"]);
  }

  Map<String, dynamic> toJson({bool toJson = false}) {
    return <String, dynamic>{
      "objectid": objectid,
      "contentid": contentid,
      "folderpath": folderpath,
      "startpage": startpage,
      "name": name,
      "iconpath": iconpath,
      "saleprice": saleprice,
      "thumbnailimagepath": thumbnailimagepath,
      "contenttypethumbnail": contenttypethumbnail,
      "medianame": medianame,
      "version": version,
      "author": author,
      "listprice": listprice,
      "currency": currency,
      "shortdescription": shortdescription,
      "longdescription": longdescription,
      "createddate": createddate,
      "eventstartdatetime": eventstartdatetime,
      "eventenddatetime": eventenddatetime,
      "participanturl": participanturl,
      "timezone": timezone,
      "eventfulllocation": eventfulllocation,
      "objectfolderid": objectfolderid,
      "parentid": parentid,
      "eventparentid": eventparentid,
      "jwvideokey": jwvideokey,
      "cloudmediaplayerkey": cloudmediaplayerkey,
      "presentername": presentername,
      "percentcompleted": percentcompleted,
      "corelessonstatus": corelessonstatus,
      "actualstatus": actualstatus,
      "jwstartpage": jwstartpage,
      "eventid": eventid,
      "activityid": activityid,
      "progress": progress,
      "actionviewqrcode": actionviewqrcode,
      "qrimagename": qrimagename,
      "allowednavigation": allowednavigation,
      "wstatus": wstatus,
      "description": description,
      "contenttype": contenttype,
      "language": language,
      "keywords": keywords,
      "publisheddate": publisheddate,
      "certificatepage": certificatepage,
      "certificateid": certificateid,
      "status": status,
      "publicationdate": publicationdate,
      "activatedate": activatedate,
      "expirydate": expirydate,
      "folderid": folderid,
      "modifieddate": modifieddate,
      "windowproperties": windowproperties,
      "launchwindowmode": launchwindowmode,
      "contentstatus": contentstatus,
      "outputtype": outputtype,
      "bit3": bit3,
      "bit4": bit4,
      "authordisplayname": authordisplayname,
      "duration": duration,
      "attemptsleft": attemptsleft,
      "wresult": wresult,
      "wmessage": wmessage,
      "invitationurl": invitationurl,
      "link": link,
      "pareportlink": pareportlink,
      "dareportlink": dareportlink,
      "disaplystatus": disaplystatus,
      "objecttypeid": objecttypeid,
      "mediatypeid": mediatypeid,
      "viewtype": viewtype,
      "scoid": scoid,
      "sequencenumber": sequencenumber,
      "devicetypeid": devicetypeid,
      "ratingid": ratingid,
      "eventscheduletype": eventscheduletype,
      "eventtype": eventtype,
      "typeofevent": typeofevent,
      "userid": userid,
      "createduserid": createduserid,
      "cmsgroupid": cmsgroupid,
      "modifieduserid": modifieduserid,
      "totalratings": totalratings,
      "totalattempts": totalattempts,
      "accessperiodtype": accessperiodtype,
      "assignedby": assignedby,
      "displayorder": displayorder,
      "grading": grading,
      "isprivate": isprivate,
      "relatedconentcount": relatedconentcount,
      "downloadable": downloadable,
      "bit5": bit5,
      "iscontent": iscontent,
      "active": active,
      "bit1": bit1,
      "isdeleted": isdeleted,
      "usercontentstatus": usercontentstatus,
      "bit11": bit11,
      "isBadCancellationEnabled": isBadCancellationEnabled,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson(toJson: true));
  }
}