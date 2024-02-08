import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class CMIModel {
  String cmiId = "";
  String location = "";
  String status = "";
  String suspenddata = "";
  String isupdate = "";
  String siteurl = "";
  String objecttypeid = "";
  String datecompleted = "";
  String score = "";
  String startdate = "";
  String timespent = "";
  String attemptsleft = "";
  String coursemode = "";
  String scoremin = "";
  String scoremax = "";
  String submittime = "";
  String textResponses = "";
  String percentageCompleted = "";
  String parentObjTypeId = "";
  String parentContentId = "";
  String parentScoId = "";
  String contentId = "";
  String showStatus = "";
  String randomquesseq = "";
  String pooledquesseq = "";
  int scoid = 0;
  int userid = 0;
  int siteid = 0;
  int noofattempts = 0;
  int sequencenumber = 0;

  CMIModel({
    this.cmiId = "",
    this.percentageCompleted = "",
    this.parentObjTypeId = "",
    this.parentContentId = "",
    this.parentScoId = "",
    this.contentId = "",
    this.showStatus = "",
    this.location = "",
    this.status = "",
    this.suspenddata = "",
    this.isupdate = "",
    this.siteurl = "",
    this.objecttypeid = "",
    this.datecompleted = "",
    this.score = "",
    this.startdate = "",
    this.timespent = "",
    this.attemptsleft = "",
    this.coursemode = "",
    this.scoremin = "",
    this.scoremax = "",
    this.submittime = "",
    this.textResponses = "",
    this.randomquesseq = "",
    this.pooledquesseq = "",
    this.scoid = 0,
    this.userid = 0,
    this.siteid = 0,
    this.noofattempts = 0,
    this.sequencenumber = 0,
  });

  CMIModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    cmiId = ParsingHelper.parseStringMethod(map["cmiId"]);
    location = ParsingHelper.parseStringMethod(map["location"]);
    status = ParsingHelper.parseStringMethod(map["status"]);
    suspenddata = ParsingHelper.parseStringMethod(map["suspenddata"]);
    isupdate = ParsingHelper.parseStringMethod(map["isupdate"]);
    siteurl = ParsingHelper.parseStringMethod(map["siteurl"]);
    objecttypeid = ParsingHelper.parseStringMethod(map["objecttypeid"]);
    datecompleted = ParsingHelper.parseStringMethod(map["datecompleted"]);
    score = ParsingHelper.parseStringMethod(map["score"]);
    startdate = ParsingHelper.parseStringMethod(map["startdate"]);
    timespent = ParsingHelper.parseStringMethod(map["timespent"]);
    attemptsleft = ParsingHelper.parseStringMethod(map["attemptsleft"]);
    coursemode = ParsingHelper.parseStringMethod(map["coursemode"]);
    scoremin = ParsingHelper.parseStringMethod(map["scoremin"]);
    scoremax = ParsingHelper.parseStringMethod(map["scoremax"]);
    submittime = ParsingHelper.parseStringMethod(map["submittime"]);
    textResponses = ParsingHelper.parseStringMethod(map["textResponses"]);
    percentageCompleted = ParsingHelper.parseStringMethod(map["percentageCompleted"]);
    parentObjTypeId = ParsingHelper.parseStringMethod(map["parentObjTypeId"]);
    parentContentId = ParsingHelper.parseStringMethod(map["parentContentId"]);
    parentScoId = ParsingHelper.parseStringMethod(map["parentScoId"]);
    contentId = ParsingHelper.parseStringMethod(map["contentId"]);
    showStatus = ParsingHelper.parseStringMethod(map["showStatus"]);
    randomquesseq = ParsingHelper.parseStringMethod(map["randomquesseq"]);
    pooledquesseq = ParsingHelper.parseStringMethod(map["pooledquesseq"]);
    scoid = ParsingHelper.parseIntMethod(map["scoid"]);
    userid = ParsingHelper.parseIntMethod(map["userid"]);
    siteid = ParsingHelper.parseIntMethod(map["siteid"]);
    noofattempts = ParsingHelper.parseIntMethod(map["noofattempts"]);
    sequencenumber = ParsingHelper.parseIntMethod(map["sequencenumber"]);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "cmiId": cmiId,
      "percentageCompleted": percentageCompleted,
      "parentObjTypeId": parentObjTypeId,
      "parentContentId": parentContentId,
      "parentScoId": parentScoId,
      "contentId": contentId,
      "showStatus": showStatus,
      "location": location,
      "status": status,
      "suspenddata": suspenddata,
      "isupdate": isupdate,
      "siteurl": siteurl,
      "objecttypeid": objecttypeid,
      "datecompleted": datecompleted,
      "score": score,
      "startdate": startdate,
      "timespent": timespent,
      "attemptsleft": attemptsleft,
      "coursemode": coursemode,
      "scoremin": scoremin,
      "scoremax": scoremax,
      "submittime": submittime,
      "textResponses": textResponses,
      "randomquesseq": randomquesseq,
      "pooledquesseq": pooledquesseq,
      "scoid": scoid,
      "userid": userid,
      "siteid": siteid,
      "noofattempts": noofattempts,
      "sequencenumber": sequencenumber,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }

  static getCmiId({required int siteId, required int userId, required int scoId}) {
    return "${siteId}_${userId}_$scoId";
  }
}
