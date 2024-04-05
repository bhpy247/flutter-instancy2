import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class SocialLoginUserDataModel {
  String id = "";
  String first_name = "";
  String last_name = "";
  String link = "";
  String username = "";
  String email = "";
  String gender = "";
  String picture = "";

  SocialLoginUserDataModel({
    this.id = "",
    this.first_name = "",
    this.last_name = "",
    this.link = "",
    this.username = "",
    this.email = "",
    this.gender = "",
    this.picture = "",
  });

  SocialLoginUserDataModel.fromJson(Map<String, dynamic> json) {
    id = ParsingHelper.parseStringMethod(json["id"]);
    first_name = ParsingHelper.parseStringMethod(json["first_name"]);
    last_name = ParsingHelper.parseStringMethod(json["last_name"]);
    link = ParsingHelper.parseStringMethod(json["link"]);
    username = ParsingHelper.parseStringMethod(json["username"]);
    email = ParsingHelper.parseStringMethod(json["email"]);
    gender = ParsingHelper.parseStringMethod(json["gender"]);
    picture = ParsingHelper.parseStringMethod(json["picture"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "first_name": first_name,
      "last_name": last_name,
      "link": link,
      "username": username,
      "email": email,
      "gender": gender,
      "picture": picture,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
