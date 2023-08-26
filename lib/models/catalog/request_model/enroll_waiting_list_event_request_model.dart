import 'package:flutter_instancy_2/configs/app_constants.dart';

class EnrollWaitingListEventRequestModel {
  String WLContentID = "";
  String locale = "";
  int UserID = 0;
  int siteid = AppConstants.defaultSiteId;

  EnrollWaitingListEventRequestModel({
    this.WLContentID = "",
    this.locale = "",
    this.UserID = 0,
    this.siteid = AppConstants.defaultSiteId,
  });

  Map<String, dynamic> toJson() {
    return {
      "WLContentID": WLContentID,
      "locale": locale,
      "UserID": UserID,
      "siteid": siteid,
    };
  }
}
