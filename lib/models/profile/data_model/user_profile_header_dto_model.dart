import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class UserProfileHeaderDTOModel {
  String BackgroundImgProfilepath = "";
  String Profilepath = "";
  String UserProfilePath = "";
  String SocialSection = "";
  String UserJobTitle = "";
  String Aboutme = "";
  String Displayname = "";
  String Nodataiamge = "";
  String AcceptAction = "";
  String RejectAction = "";
  String ConnectionState = "";
  int intConnStatus = 0;

  UserProfileHeaderDTOModel({
    this.BackgroundImgProfilepath = "",
    this.Profilepath = "",
    this.UserProfilePath = "",
    this.SocialSection = "",
    this.UserJobTitle = "",
    this.Aboutme = "",
    this.Displayname = "",
    this.Nodataiamge = "",
    this.AcceptAction = "",
    this.RejectAction = "",
    this.ConnectionState = "",
    this.intConnStatus = 0,
  });

  UserProfileHeaderDTOModel.fromJson(Map<String, dynamic> json) {
    BackgroundImgProfilepath = ParsingHelper.parseStringMethod(json["BackgroundImgProfilepath"]);
    Profilepath = ParsingHelper.parseStringMethod(json["Profilepath"]);
    UserProfilePath = ParsingHelper.parseStringMethod(json["UserProfilePath"]);
    SocialSection = ParsingHelper.parseStringMethod(json["SocialSection"]);
    UserJobTitle = ParsingHelper.parseStringMethod(json["UserJobTitle"]);
    Aboutme = ParsingHelper.parseStringMethod(json["Aboutme"]);
    Displayname = ParsingHelper.parseStringMethod(json["Displayname"]);
    Nodataiamge = ParsingHelper.parseStringMethod(json["Nodataiamge"]);
    AcceptAction = ParsingHelper.parseStringMethod(json["AcceptAction"]);
    RejectAction = ParsingHelper.parseStringMethod(json["RejectAction"]);
    ConnectionState = ParsingHelper.parseStringMethod(json["ConnectionState"]);
    intConnStatus = ParsingHelper.parseIntMethod(json['intConnStatus']);
  }

  Map<String, dynamic> toJson() {
    return {
      "BackgroundImgProfilepath": BackgroundImgProfilepath,
      "Profilepath": Profilepath,
      "UserProfilePath": UserProfilePath,
      "SocialSection": SocialSection,
      "UserJobTitle": UserJobTitle,
      "Aboutme": Aboutme,
      "Displayname": Displayname,
      "Nodataiamge": Nodataiamge,
      "AcceptAction": AcceptAction,
      "RejectAction": RejectAction,
      "ConnectionState": ConnectionState,
      "intConnStatus": intConnStatus,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}