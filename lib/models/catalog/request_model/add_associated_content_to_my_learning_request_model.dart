import 'package:flutter_instancy_2/configs/app_constants.dart';

class AddAssociatedContentToMyLearningRequestModel {
  String SelectedContent = "";
  String Locale = "";
  String AddLearnerPreRequisiteContent = "";
  String TargetDate = "";
  String AddMultiinstanceswithprice = "";
  String AddWaitlistContentIDs = "";
  String MultiInstanceEventEnroll = "";
  String Message = "";
  bool result = false;
  int UserID = 0;
  int SiteID = AppConstants.defaultSiteId;
  int OrgUnitID = AppConstants.defaultSiteId;
  int scoId = 0;
  int objecttypeId = 0;

  AddAssociatedContentToMyLearningRequestModel({
    this.SelectedContent = "",
    this.Locale = "",
    this.AddLearnerPreRequisiteContent = "",
    this.TargetDate = "",
    this.AddMultiinstanceswithprice = "",
    this.AddWaitlistContentIDs = "",
    this.MultiInstanceEventEnroll = "",
    this.Message = "",
    this.result = false,
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
      "AddLearnerPreRequisiteContent": AddLearnerPreRequisiteContent,
      "TargetDate": TargetDate,
      "AddMultiinstanceswithprice": AddMultiinstanceswithprice,
      "AddWaitlistContentIDs": AddWaitlistContentIDs,
      "MultiInstanceEventEnroll": MultiInstanceEventEnroll,
      "Message": Message,
      "result": result,
      "UserID": UserID,
      "SiteID": SiteID,
      "OrgUnitID": OrgUnitID,
    };
  }
}