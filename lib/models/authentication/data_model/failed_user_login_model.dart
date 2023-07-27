import '../../../configs/app_constants.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class FailedUserLoginModel {
  int userid = 0, siteid = AppConstants.defaultSiteId;
  String userstatus = "", hasscanprivilege = "";

  FailedUserLoginModel({
    this.userid = 0,
    this.siteid = AppConstants.defaultSiteId,
    this.userstatus = "",
    this.hasscanprivilege = "",
  });

  FailedUserLoginModel.fromJson(Map<String, dynamic> json) {
    userid = ParsingHelper.parseIntMethod(json["userid"]);
    siteid = ParsingHelper.parseIntMethod(json["siteid"], defaultValue: AppConstants.defaultSiteId);
    userstatus = ParsingHelper.parseStringMethod(json["userstatus"]);
    hasscanprivilege = ParsingHelper.parseStringMethod(json["hasscanprivilege"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "userid": userid,
      "siteid": siteid,
      "userstatus": userstatus,
      "hasscanprivilege": hasscanprivilege,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}