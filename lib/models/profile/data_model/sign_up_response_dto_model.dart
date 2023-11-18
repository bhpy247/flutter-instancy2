import 'package:flutter_chat_bot/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class SignUpResponseDTOModel {
  String Message = "";
  String adminapproval = "";
  String VerifyEmail = "";
  String generatePassword = "";
  String NotifyMessage = "";
  String loginID = "";
  String loginPwd = "";
  int UserID = -1;
  int FromSiteID = -1;
  int ToSiteID = -1;

  SignUpResponseDTOModel({
    this.Message = "",
    this.adminapproval = "",
    this.VerifyEmail = "",
    this.generatePassword = "",
    this.NotifyMessage = "",
    this.loginID = "",
    this.loginPwd = "",
    this.UserID = -1,
    this.FromSiteID = -1,
    this.ToSiteID = -1,
  });

  SignUpResponseDTOModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    Message = ParsingHelper.parseStringMethod(map['Message']);
    adminapproval = ParsingHelper.parseStringMethod(map['adminapproval']);
    VerifyEmail = ParsingHelper.parseStringMethod(map['VerifyEmail']);
    generatePassword = ParsingHelper.parseStringMethod(map['generatePassword']);
    NotifyMessage = ParsingHelper.parseStringMethod(map['NotifyMessage']);
    loginID = ParsingHelper.parseStringMethod(map['loginID']);
    loginPwd = ParsingHelper.parseStringMethod(map['loginPwd']);
    UserID = ParsingHelper.parseIntMethod(map['UserID'], defaultValue: -1);
    FromSiteID = ParsingHelper.parseIntMethod(map['FromSiteID'], defaultValue: -1);
    ToSiteID = ParsingHelper.parseIntMethod(map['ToSiteID'], defaultValue: -1);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "Message": Message,
      "adminapproval": adminapproval,
      "VerifyEmail": VerifyEmail,
      "generatePassword": generatePassword,
      "NotifyMessage": NotifyMessage,
      "loginID": loginID,
      "loginPwd": loginPwd,
      "UserID": UserID,
      "FromSiteID": FromSiteID,
      "ToSiteID": ToSiteID,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
