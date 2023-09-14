import 'package:flutter_chat_bot/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';

class ChatUserModel {
  String FullName = "";
  String ProfPic = "";
  String SendDateTime = "";
  String Country = "";
  String Role = "";
  String LatestMessage = "";
  String JobTitle = "";
  int UserID = 0;
  int UnReadCount = 0;
  int Myconid = 0;
  int ConnectionStatus = 0;
  int RoleID = 0;
  int SiteID = 0;
  int UserStatus = 0;
  int RankNo = 0;
  int ArchivedUserID = 0;

  ChatUserModel({
    this.FullName = "",
    this.ProfPic = "",
    this.SendDateTime = "",
    this.Country = "",
    this.Role = "",
    this.LatestMessage = "",
    this.JobTitle = "",
    this.UserID = 0,
    this.UnReadCount = 0,
    this.Myconid = 0,
    this.ConnectionStatus = 0,
    this.RoleID = 0,
    this.SiteID = 0,
    this.UserStatus = 0,
    this.RankNo = 0,
    this.ArchivedUserID = 0,
  });

  ChatUserModel.fromJson(Map<String, dynamic> json) {
    FullName = ParsingHelper.parseStringMethod(json['FullName']);
    ProfPic = ParsingHelper.parseStringMethod(json['ProfPic']);
    SendDateTime = ParsingHelper.parseStringMethod(json['SendDateTime']);
    Country = ParsingHelper.parseStringMethod(json['Country']);
    Role = ParsingHelper.parseStringMethod(json['Role']);
    LatestMessage = ParsingHelper.parseStringMethod(json['LatestMessage']);
    JobTitle = ParsingHelper.parseStringMethod(json['JobTitle']);
    UserID = ParsingHelper.parseIntMethod(json['UserID']);
    UnReadCount = ParsingHelper.parseIntMethod(json['UnReadCount']);
    Myconid = ParsingHelper.parseIntMethod(json['Myconid']);
    ConnectionStatus = ParsingHelper.parseIntMethod(json['ConnectionStatus']);
    RoleID = ParsingHelper.parseIntMethod(json['RoleID']);
    SiteID = ParsingHelper.parseIntMethod(json['SiteID']);
    UserStatus = ParsingHelper.parseIntMethod(json['UserStatus']);
    RankNo = ParsingHelper.parseIntMethod(json['RankNo']);
    ArchivedUserID = ParsingHelper.parseIntMethod(json['ArchivedUserID']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "FullName": FullName,
      "ProfPic": ProfPic,
      "SendDateTime": SendDateTime,
      "Country": Country,
      "Role": Role,
      "LatestMessage": LatestMessage,
      "JobTitle": JobTitle,
      "UserID": UserID,
      "UnReadCount": UnReadCount,
      "Myconid": Myconid,
      "ConnectionStatus": ConnectionStatus,
      "RoleID": RoleID,
      "SiteID": SiteID,
      "UserStatus": UserStatus,
      "RankNo": RankNo,
      "ArchivedUserID": ArchivedUserID,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
