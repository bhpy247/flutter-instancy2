import 'package:flutter_instancy_2/configs/app_constants.dart';

import '../../../utils/my_utils.dart';

class EcommercePurchaseDataRequestModel {
  String Locale = "";
  String CouponCode = "";
  String ContentID = "";
  String contentIDList = "";
  int UserID = -1;
  int SiteID = AppConstants.defaultSiteId;
  int? ComponentID;
  int? ComponentInsID;

  EcommercePurchaseDataRequestModel({
    this.Locale = "",
    this.CouponCode = "",
    this.ContentID = "",
    this.contentIDList = "",
    this.UserID = -1,
    this.SiteID = AppConstants.defaultSiteId,
    this.ComponentID,
    this.ComponentInsID,
  });

  Map<String, String> toJson() {
    return {
      "Locale": Locale,
      "CouponCode": CouponCode,
      "ContentID": ContentID,
      "contentIDList": contentIDList,
      "UserID": UserID.toString(),
      "SiteID": SiteID.toString(),
      "ComponentID": ComponentID.toString(),
      "ComponentInsID": ComponentInsID.toString(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
