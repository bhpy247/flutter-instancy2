import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class UserSignUpDetailsModel {
  String message = "", action = "", login = "", pwd = "", autolaunchcontentid = "";

  UserSignUpDetailsModel({
    this.message = "",
    this.action = "",
    this.login = "",
    this.pwd = "",
    this.autolaunchcontentid = "",
  });

  UserSignUpDetailsModel.fromMap(Map<String, dynamic> json) {
    message = ParsingHelper.parseStringMethod(json["message"]);
    action = ParsingHelper.parseStringMethod(json["action"]);
    login = ParsingHelper.parseStringMethod(json["login"]);
    pwd = ParsingHelper.parseStringMethod(json["pwd"]);
    autolaunchcontentid = ParsingHelper.parseStringMethod(json["autolaunchcontentid"]);
  }

  Map<String, dynamic> toMap({bool toJson = true}) {
    return {
      "message": message,
      "action": action,
      "login": login,
      "pwd": pwd,
      "autolaunchcontentid": autolaunchcontentid,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}
