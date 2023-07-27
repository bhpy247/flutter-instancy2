import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class SiteUserInfoModel {
  String picture = "", displayname = "", email = "", profileimagepath = "";
  int userid = 0;

  SiteUserInfoModel({
    this.picture = "",
    this.displayname = "",
    this.email = "",
    this.profileimagepath = "",
    this.userid = -1,
  });

  SiteUserInfoModel.fromJson(Map<String, dynamic> json) {
    picture = ParsingHelper.parseStringMethod(json["picture"]);
    displayname = ParsingHelper.parseStringMethod(json["displayname"]);
    email = ParsingHelper.parseStringMethod(json["email"]);
    profileimagepath = ParsingHelper.parseStringMethod(json["profileimagepath"]);
    userid = ParsingHelper.parseIntMethod(json["userid"], defaultValue: -1);
  }

  Map<String, dynamic> toJson() {
    return {
      "picture": picture,
      "displayname": displayname,
      "email": email,
      "profileimagepath": profileimagepath,
      "userid": userid,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}