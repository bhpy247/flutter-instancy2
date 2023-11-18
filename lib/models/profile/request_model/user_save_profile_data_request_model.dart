import '../../../utils/my_utils.dart';

class UserSaveProfileDataRequestModel {
  String strProfileJSON = "";
  String localeId = "";
  String type = "";
  String RenewType = "";
  String utm_source = "";
  String utm_medium = "";
  String utm_campaign = "";
  String utm_term = "";
  String utm_content = "";
  String JobRoleIDs = "";
  String ContentIDs = "";
  int userId = -1;
  int siteId = -1;
  int intCompID = -1;
  int intCompInsID = -1;
  int MemberShipDurationID = 0;
  int ContentAssignOrgUnitID = 0;
  bool enablegroupmembership = false;
  bool enablecontenturl = false;
  bool groupsignup = false;
  bool isnativeapp = true;

  UserSaveProfileDataRequestModel({
    this.strProfileJSON = "",
    this.localeId = "",
    this.type = "",
    this.RenewType = "",
    this.utm_source = "",
    this.utm_medium = "",
    this.utm_campaign = "",
    this.utm_term = "",
    this.utm_content = "",
    this.JobRoleIDs = "",
    this.ContentIDs = "",
    this.userId = -1,
    this.siteId = -1,
    this.intCompID = -1,
    this.intCompInsID = -1,
    this.MemberShipDurationID = 0,
    this.ContentAssignOrgUnitID = 0,
    this.enablegroupmembership = false,
    this.enablecontenturl = false,
    this.groupsignup = false,
    this.isnativeapp = true,
  });

  Map<String, String> toJson() {
    return <String, String>{
      "strProfileJSON": strProfileJSON,
      "localeId": localeId,
      "type": type,
      "RenewType": RenewType,
      "utm_source": utm_source,
      "utm_medium": utm_medium,
      "utm_campaign": utm_campaign,
      "utm_term": utm_term,
      "utm_content": utm_content,
      "JobRoleIDs": JobRoleIDs,
      "ContentIDs": ContentIDs,
      "userId": userId.toString(),
      "siteId": siteId.toString(),
      "intCompID": intCompID.toString(),
      "intCompInsID": intCompInsID.toString(),
      "MemberShipDurationID": MemberShipDurationID.toString(),
      "ContentAssignOrgUnitID": ContentAssignOrgUnitID.toString(),
      "enablegroupmembership": enablegroupmembership.toString(),
      "enablecontenturl": enablecontenturl.toString(),
      "groupsignup": groupsignup.toString(),
      "isnativeapp": isnativeapp.toString(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
