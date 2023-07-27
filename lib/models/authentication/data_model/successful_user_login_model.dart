import '../../../configs/app_constants.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class SuccessfulUserLoginModel {
  int userid = 0, orgunitid = 0, siteid = AppConstants.defaultSiteId;
  String email = "", password = "", userstatus = "", username = "", image = "", tcapiurl = "", hasscanprivilege = "", autolaunchcontent = "", jwttoken = "", sessionid = "";

  SuccessfulUserLoginModel({
    this.userid = 0,
    this.orgunitid = 0,
    this.siteid = AppConstants.defaultSiteId,
    this.email = "",
    this.password = "",
    this.userstatus = "",
    this.username = "",
    this.image = "",
    this.tcapiurl = "",
    this.hasscanprivilege = "",
    this.autolaunchcontent = "",
    this.jwttoken = "",
    this.sessionid = "",
  });

  SuccessfulUserLoginModel.fromJson(Map<String, dynamic> json) {
    userid = ParsingHelper.parseIntMethod(json["userid"]);
    orgunitid = ParsingHelper.parseIntMethod(json["orgunitid"]);
    siteid = ParsingHelper.parseIntMethod(json["siteid"], defaultValue: AppConstants.defaultSiteId);
    email = ParsingHelper.parseStringMethod(json["email"]);
    password = ParsingHelper.parseStringMethod(json["password"]);
    userstatus = ParsingHelper.parseStringMethod(json["userstatus"]);
    username = ParsingHelper.parseStringMethod(json["username"]);
    image = ParsingHelper.parseStringMethod(json["image"]);
    tcapiurl = ParsingHelper.parseStringMethod(json["tcapiurl"]);
    hasscanprivilege = ParsingHelper.parseStringMethod(json["hasscanprivilege"]);
    autolaunchcontent = ParsingHelper.parseStringMethod(json["autolaunchcontent"]);
    jwttoken = ParsingHelper.parseStringMethod(json["jwttoken"]);
    sessionid = ParsingHelper.parseStringMethod(json["sessionid"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "userid": userid,
      "orgunitid": orgunitid,
      "siteid": siteid,
      "email": email,
      "password": password,
      "userstatus": userstatus,
      "username": username,
      "image": image,
      "tcapiurl": tcapiurl,
      "hasscanprivilege": hasscanprivilege,
      "autolaunchcontent": autolaunchcontent,
      "jwttoken": jwttoken,
      "sessionid": sessionid,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}