import 'package:flutter_instancy_2/utils/my_utils.dart';

import '../../../configs/app_constants.dart';

class GetDynamicTabsRequestModel {
  String Locale = "";
  int ComponentID = 0;
  int ComponentInsID = 0;
  int SiteID = AppConstants.defaultSiteId;
  int aintUserID = 0;

  GetDynamicTabsRequestModel({
    this.Locale = "",
    this.ComponentID = 0,
    this.ComponentInsID = 0,
    this.SiteID = AppConstants.defaultSiteId,
    this.aintUserID = 0,
  });

  Map<String, String> toJson() {
    return {
      "Locale": Locale,
      "ComponentID": ComponentID.toString(),
      "ComponentInsID": ComponentInsID.toString(),
      "SiteID": SiteID.toString(),
      "aintUserID": aintUserID.toString(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
