import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class LearnerSessionModel {
  String learnerSessionID = "";
  String sessiondatetime = "";
  String timespent = "";
  int sessionid = 0;
  int userid = 0;
  int scoid = 0;
  int siteid = 0;
  int attemptnumber = 0;

  LearnerSessionModel({
    this.learnerSessionID = "",
    this.sessiondatetime = "",
    this.timespent = "",
    this.sessionid = 0,
    this.userid = 0,
    this.scoid = 0,
    this.siteid = 0,
    this.attemptnumber = 0,
  });

  LearnerSessionModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    learnerSessionID = ParsingHelper.parseStringMethod(map["learnerSessionID"]);
    sessiondatetime = ParsingHelper.parseStringMethod(map["sessiondatetime"]);
    timespent = ParsingHelper.parseStringMethod(map["timespent"]);
    sessionid = ParsingHelper.parseIntMethod(map["sessionid"]);
    userid = ParsingHelper.parseIntMethod(map["userid"]);
    scoid = ParsingHelper.parseIntMethod(map["scoid"]);
    siteid = ParsingHelper.parseIntMethod(map["siteid"]);
    attemptnumber = ParsingHelper.parseIntMethod(map["attemptnumber"]);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "learnerSessionID": learnerSessionID,
      "sessiondatetime": sessiondatetime,
      "timespent": timespent,
      "sessionid": sessionid,
      "userid": userid,
      "scoid": scoid,
      "siteid": siteid,
      "attemptnumber": attemptnumber,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }

  static getLearnerSessionId({required int siteId, required int userId, required int scoId}) {
    return "${siteId}_${userId}_$scoId";
  }
}
