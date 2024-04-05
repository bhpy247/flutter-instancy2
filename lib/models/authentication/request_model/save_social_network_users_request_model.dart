import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/authentication/data_model/social_login_user_data_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';

class SaveSocialNetworkUsersRequestModel {
  String type = "";
  String localeId = "";
  int siteId = AppConstants.defaultSiteId;
  List<SocialLoginUserDataModel> SocailNetworkData = <SocialLoginUserDataModel>[];

  SaveSocialNetworkUsersRequestModel({
    this.type = "",
    this.localeId = "",
    this.siteId = AppConstants.defaultSiteId,
    List<SocialLoginUserDataModel>? SocailNetworkData,
  }) {
    this.SocailNetworkData = SocailNetworkData ?? <SocialLoginUserDataModel>[];
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "localeId": localeId,
      "siteId": siteId,
      "SocailNetworkData": SocailNetworkData.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
