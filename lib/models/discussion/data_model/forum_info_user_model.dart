import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class ForumUserInfoModel {
  String UserThumb = "";
  String UserName = "";
  String UserDesg = "";
  String UserAddress = "";
  String NotifyMsg = "";
  int UserID = 0;
  bool check = false;

  ForumUserInfoModel({
    this.UserThumb = "",
    this.UserName = "",
    this.UserDesg = "",
    this.UserAddress = "",
    this.NotifyMsg = "",
    this.UserID = 0,
    this.check = false,
  });

  ForumUserInfoModel.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> json) {
    UserThumb = ParsingHelper.parseStringMethod(json["UserThumb"]);
    UserName = ParsingHelper.parseStringMethod(json["UserName"]);
    UserDesg = ParsingHelper.parseStringMethod(json["UserDesg"]);
    UserAddress = ParsingHelper.parseStringMethod(json["UserAddress"]);
    NotifyMsg = ParsingHelper.parseStringMethod(json["NotifyMsg"]);
    UserID = ParsingHelper.parseIntMethod(json["UserID"]);
    check = ParsingHelper.parseBoolMethod(json["check"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "UserThumb": UserThumb,
      "UserName": UserName,
      "UserDesg": UserDesg,
      "UserAddress": UserAddress,
      "NotifyMsg": NotifyMsg,
      "UserID": UserID,
      "check": check,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
