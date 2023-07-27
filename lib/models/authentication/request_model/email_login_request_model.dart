import 'package:flutter_instancy_2/configs/app_constants.dart';

import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class EmailLoginRequestModel {
  String userName = "", password = "", mobileSiteUrl = "", downloadContent = "";
  int siteId = AppConstants.defaultSiteId;
  bool isFromSignUp = false;

  EmailLoginRequestModel({
    this.userName = "",
    this.password = "",
    this.mobileSiteUrl = "",
    this.downloadContent = "",
    this.siteId = AppConstants.defaultSiteId,
    this.isFromSignUp = false,
  });

  EmailLoginRequestModel.fromJson(Map<String, dynamic> json) {
    userName = ParsingHelper.parseStringMethod(json["UserName"]);
    password = ParsingHelper.parseStringMethod(json["Password"]);
    mobileSiteUrl = ParsingHelper.parseStringMethod(json["MobileSiteURL"]);
    downloadContent = ParsingHelper.parseStringMethod(json["DownloadContent"]);
    siteId = ParsingHelper.parseIntMethod(json["SiteID"]);
    isFromSignUp = ParsingHelper.parseBoolMethod(json["isFromSignUp"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "UserName": userName,
      "Password": password,
      "MobileSiteURL": mobileSiteUrl,
      "DownloadContent": downloadContent,
      "SiteID": siteId,
      "isFromSignUp": isFromSignUp,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}