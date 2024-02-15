import 'package:flutter_instancy_2/configs/app_constants.dart';

class PeopleListingActionsRequestModel {
  String SelectAction = "";
  String UserName = "";
  String Locale = "";
  String CurrentMenu = "";
  String ConsolidationType = "";
  int SelectedObjectID = -1;
  int UserID = -1;
  int MainSiteUserID = -1;
  int SiteID = AppConstants.defaultSiteId;

  PeopleListingActionsRequestModel({
    this.SelectAction = "",
    this.UserName = "",
    this.Locale = "",
    this.CurrentMenu = "",
    this.ConsolidationType = "",
    this.SelectedObjectID = -1,
    this.UserID = -1,
    this.MainSiteUserID = -1,
    this.SiteID = AppConstants.defaultSiteId,
  });

  Map<String, dynamic> toJson() {
    return {
      "SelectAction": SelectAction,
      "UserName": UserName,
      "Locale": Locale,
      "CurrentMenu": CurrentMenu,
      "ConsolidationType": ConsolidationType,
      "SelectedObjectID": SelectedObjectID,
      "UserID": UserID,
      "MainSiteUserID": MainSiteUserID,
      "SiteID": SiteID,
    };
  }
}
