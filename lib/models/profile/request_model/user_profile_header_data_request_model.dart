import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class UserProfileHeaderDataRequestModel {
  String intUserID = "";
  String intSiteID = "";
  String strLocale = "";
  String intProfileUserID = "";
  String intProfileSiteID = "";
  String viewconnection = "";
  String type = "";
  int intCompID = 0;
  int intCompInsID = 0;

  UserProfileHeaderDataRequestModel({
    this.intUserID = "",
    this.intSiteID = "",
    this.strLocale = "",
    this.intProfileUserID = "",
    this.intProfileSiteID = "",
    this.viewconnection = "",
    this.type = "",
    this.intCompID = 0,
    this.intCompInsID = 0,
  });

  UserProfileHeaderDataRequestModel.fromJson(Map<String, dynamic> json) {
    intUserID = ParsingHelper.parseStringMethod(json["intUserID"]);
    intSiteID = ParsingHelper.parseStringMethod(json["intSiteID"]);
    strLocale = ParsingHelper.parseStringMethod(json["strLocale"]);
    intProfileUserID = ParsingHelper.parseStringMethod(json["intProfileUserID"]);
    intProfileSiteID = ParsingHelper.parseStringMethod(json["intProfileSiteID"]);
    viewconnection = ParsingHelper.parseStringMethod(json["viewconnection"]);
    type = ParsingHelper.parseStringMethod(json["type"]);
    intCompID = ParsingHelper.parseIntMethod(json["intCompID"]);
    intCompInsID = ParsingHelper.parseIntMethod(json["intCompInsID"]);
  }

  Map<String, String> toJson() {
    return <String, String>{
      "intUserID": intUserID,
      "intSiteID": intSiteID,
      "strLocale": strLocale,
      "intProfileUserID": intProfileUserID,
      "intProfileSiteID": intProfileSiteID,
      "viewconnection": viewconnection,
      "type": type,
      "intCompID": intCompID.toString(),
      "intCompInsID": intCompInsID.toString(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}