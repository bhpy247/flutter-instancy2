import 'package:flutter_instancy_2/models/gamification/data_model/game_activity_data_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class NativeLoginDTOModel {
  String userstatus = "";
  String username = "";
  String image = "";
  String tcapiurl = "";
  String hasscanprivilege = "";
  String autolaunchcontent = "";
  String jwttoken = "";
  String sessionid = "";
  String email = "";
  String password = "";
  int userid = 0;
  int orgunitid = 0;
  int siteid = 0;
  List<GameActivityDataModel> GameActivities = <GameActivityDataModel>[];

  NativeLoginDTOModel({
    this.userstatus = "",
    this.username = "",
    this.image = "",
    this.tcapiurl = "",
    this.hasscanprivilege = "",
    this.autolaunchcontent = "",
    this.jwttoken = "",
    this.sessionid = "",
    this.email = "",
    this.password = "",
    this.userid = 0,
    this.orgunitid = 0,
    this.siteid = 0,
    List<GameActivityDataModel>? GameActivities,
  }) {
    this.GameActivities = GameActivities ?? <GameActivityDataModel>[];
  }

  NativeLoginDTOModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    userstatus = ParsingHelper.parseStringMethod(map['userstatus']);
    username = ParsingHelper.parseStringMethod(map['username']);
    image = ParsingHelper.parseStringMethod(map['image']);
    tcapiurl = ParsingHelper.parseStringMethod(map['tcapiurl']);
    hasscanprivilege = ParsingHelper.parseStringMethod(map['hasscanprivilege']);
    autolaunchcontent = ParsingHelper.parseStringMethod(map['autolaunchcontent']);
    jwttoken = ParsingHelper.parseStringMethod(map['jwttoken']);
    sessionid = ParsingHelper.parseStringMethod(map['sessionid']);
    email = ParsingHelper.parseStringMethod(map['email']);
    password = ParsingHelper.parseStringMethod(map['password']);
    userid = ParsingHelper.parseIntMethod(map['userid']);
    orgunitid = ParsingHelper.parseIntMethod(map['orgunitid']);
    siteid = ParsingHelper.parseIntMethod(map['siteid']);
    GameActivities = ParsingHelper.parseMapsListMethod<String, dynamic>(map['GameActivities']).map((e) => GameActivityDataModel.fromMap(e)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      "userstatus": userstatus,
      "username": username,
      "image": image,
      "tcapiurl": tcapiurl,
      "hasscanprivilege": hasscanprivilege,
      "autolaunchcontent": autolaunchcontent,
      "jwttoken": jwttoken,
      "sessionid": sessionid,
      "email": email,
      "password": password,
      "userid": userid,
      "orgunitid": orgunitid,
      "siteid": siteid,
      "GameActivities": GameActivities.map((e) => e.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
