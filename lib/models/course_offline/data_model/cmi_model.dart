import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class CMIModel {
  String cmiId = "";
  String corelessonlocation = "";
  String corelessonstatus = "";
  String suspenddata = "";
  String isupdate = "";
  String siteurl = "";
  String objecttypeid = "";
  String datecompleted = "";
  String scoreraw = "";
  String startdate = "";
  String totalsessiontime = "";
  String attemptsleft = "";
  String corelessonmode = "";
  String scoremin = "";
  String scoremax = "";
  String submittime = "";
  String textresponses = "";
  String percentageCompleted = "";
  String trackprogress = "";
  String parentObjTypeId = "";
  String parentContentId = "";
  String parentScoId = "";
  String contentId = "";
  String statusdisplayname = "";
  String randomquestionnos = "";
  String pooledquestionnos = "";
  int id = 0;
  int scoid = 0;
  int userid = 0;
  int siteid = 0;
  int noofattempts = 0;
  int sequencenumber = 0;
  bool isJWVideo = false;

  CMIModel({
    this.cmiId = "",
    this.percentageCompleted = "",
    this.trackprogress = "",
    this.parentObjTypeId = "",
    this.parentContentId = "",
    this.parentScoId = "",
    this.contentId = "",
    this.statusdisplayname = "",
    this.corelessonlocation = "",
    this.corelessonstatus = "",
    this.suspenddata = "",
    this.isupdate = "",
    this.siteurl = "",
    this.objecttypeid = "",
    this.datecompleted = "",
    this.scoreraw = "",
    this.startdate = "",
    this.totalsessiontime = "",
    this.attemptsleft = "",
    this.corelessonmode = "",
    this.scoremin = "",
    this.scoremax = "",
    this.submittime = "",
    this.textresponses = "",
    this.randomquestionnos = "",
    this.pooledquestionnos = "",
    this.id = 0,
    this.scoid = 0,
    this.userid = 0,
    this.siteid = 0,
    this.noofattempts = 0,
    this.sequencenumber = 0,
    this.isJWVideo = false,
  });

  CMIModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    cmiId = ParsingHelper.parseStringMethod(map["cmiId"]);
    corelessonlocation = ParsingHelper.parseStringMethod(map["corelessonlocation"]);
    corelessonstatus = ParsingHelper.parseStringMethod(map["corelessonstatus"]);
    suspenddata = ParsingHelper.parseStringMethod(map["suspenddata"]);
    isupdate = ParsingHelper.parseStringMethod(map["isupdate"]);
    siteurl = ParsingHelper.parseStringMethod(map["siteurl"]);
    objecttypeid = ParsingHelper.parseStringMethod(map["objecttypeid"]);
    datecompleted = ParsingHelper.parseStringMethod(map["datecompleted"]);
    scoreraw = ParsingHelper.parseStringMethod(map["scoreraw"]);
    startdate = ParsingHelper.parseStringMethod(map["startdate"]);
    totalsessiontime = ParsingHelper.parseStringMethod(map["totalsessiontime"]);
    attemptsleft = ParsingHelper.parseStringMethod(map["attemptsleft"]);
    corelessonmode = ParsingHelper.parseStringMethod(map["coursemode"]);
    scoremin = ParsingHelper.parseStringMethod(map["scoremin"]);
    scoremax = ParsingHelper.parseStringMethod(map["scoremax"]);
    submittime = ParsingHelper.parseStringMethod(map["submittime"]);
    textresponses = ParsingHelper.parseStringMethod(map["textresponses"]);
    percentageCompleted = ParsingHelper.parseStringMethod(map["percentageCompleted"]);
    trackprogress = ParsingHelper.parseStringMethod(map["trackprogress"]);
    parentObjTypeId = ParsingHelper.parseStringMethod(map["parentObjTypeId"]);
    parentContentId = ParsingHelper.parseStringMethod(map["parentContentId"]);
    parentScoId = ParsingHelper.parseStringMethod(map["parentScoId"]);
    contentId = ParsingHelper.parseStringMethod(map["contentId"]);
    statusdisplayname = ParsingHelper.parseStringMethod(map["statusdisplayname"]);
    randomquestionnos = ParsingHelper.parseStringMethod(map["randomquestionnos"]);
    pooledquestionnos = ParsingHelper.parseStringMethod(map["pooledquestionnos"]);
    id = ParsingHelper.parseIntMethod(map["id"]);
    scoid = ParsingHelper.parseIntMethod(map["scoid"]);
    userid = ParsingHelper.parseIntMethod(map["userid"]);
    siteid = ParsingHelper.parseIntMethod(map["siteid"]);
    noofattempts = ParsingHelper.parseIntMethod(map["noofattempts"]);
    sequencenumber = ParsingHelper.parseIntMethod(map["sequencenumber"]);
    isJWVideo = ParsingHelper.parseBoolMethod(map["isJWVideo"]);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "cmiId": cmiId,
      "percentageCompleted": percentageCompleted,
      "trackprogress": trackprogress,
      "parentObjTypeId": parentObjTypeId,
      "parentContentId": parentContentId,
      "parentScoId": parentScoId,
      "contentId": contentId,
      "statusdisplayname": statusdisplayname,
      "corelessonlocation": corelessonlocation,
      "corelessonstatus": corelessonstatus,
      "suspenddata": suspenddata,
      "isupdate": isupdate,
      "siteurl": siteurl,
      "objecttypeid": objecttypeid,
      "datecompleted": datecompleted,
      "scoreraw": scoreraw,
      "startdate": startdate,
      "totalsessiontime": totalsessiontime,
      "attemptsleft": attemptsleft,
      "coursemode": corelessonmode,
      "scoremin": scoremin,
      "scoremax": scoremax,
      "submittime": submittime,
      "textresponses": textresponses,
      "randomquestionnos": randomquestionnos,
      "pooledquestionnos": pooledquestionnos,
      "id": id,
      "scoid": scoid,
      "userid": userid,
      "siteid": siteid,
      "noofattempts": noofattempts,
      "sequencenumber": sequencenumber,
      "isJWVideo": isJWVideo,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }

  static String getCmiId({required int siteId, required int userId, required int scoId}) {
    return "${siteId}_${userId}_$scoId";
  }
}
