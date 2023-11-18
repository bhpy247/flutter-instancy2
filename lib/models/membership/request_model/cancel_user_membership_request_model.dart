import 'package:flutter_instancy_2/utils/my_utils.dart';

class CancelUserMembershipRequestModel {
  String Locale = "";
  int UserMembershipID = -1;
  int UserSiteID = -1;

  CancelUserMembershipRequestModel({
    this.Locale = "",
    this.UserMembershipID = -1,
    this.UserSiteID = -1,
  });

  Map<String, String> toJson() {
    return {
      "Locale": Locale,
      "UserMembershipID": UserMembershipID.toString(),
      "UserSiteID": UserSiteID.toString(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
