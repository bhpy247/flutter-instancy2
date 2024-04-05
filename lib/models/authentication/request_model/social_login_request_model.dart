import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';

class SocialLoginRequestModel {
  String authKey = "";
  int siteId = AppConstants.defaultSiteId;

  SocialLoginRequestModel({
    this.authKey = "",
    this.siteId = AppConstants.defaultSiteId,
  });

  Map<String, String> toJson() {
    return {
      "authKey": authKey,
      "siteId": siteId.toString(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
