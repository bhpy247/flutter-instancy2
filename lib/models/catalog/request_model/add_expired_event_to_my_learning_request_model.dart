import 'package:flutter_instancy_2/configs/app_constants.dart';

class AddExpiredEventToMyLearningRequestModel {
  String SelectedContent = "";
  String Locale = "";
  int UserID = 0;
  int SiteID = AppConstants.defaultSiteId;
  int OrgUnitID = AppConstants.defaultSiteId;
  int scoId = 0;
  int objecttypeId = 0;

  AddExpiredEventToMyLearningRequestModel({
    this.SelectedContent = "",
    this.Locale = "",
    this.UserID = 0,
    this.SiteID = AppConstants.defaultSiteId,
    this.OrgUnitID = AppConstants.defaultSiteId,
    this.scoId = 0,
    this.objecttypeId = 0,
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
