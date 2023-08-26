import 'package:flutter_instancy_2/configs/app_constants.dart';

class AddExpiredEventToMyLearningRequestModel {
  String SelectedContent = "";
  String Locale = "";
  int UserID = 0;
  int SiteID = AppConstants.defaultSiteId;
  int OrgUnitID = AppConstants.defaultSiteId;

  AddExpiredEventToMyLearningRequestModel({
    this.SelectedContent = "",
    this.Locale = "",
    this.UserID = 0,
    this.SiteID = AppConstants.defaultSiteId,
    this.OrgUnitID = AppConstants.defaultSiteId,
  });

  Map<String, dynamic> toJson() {
    return {
      "SelectedContent": SelectedContent,
      "Locale": Locale,
      "UserID": UserID,
      "SiteID": SiteID,
      "OrgUnitID": OrgUnitID,
    };
  }
}
