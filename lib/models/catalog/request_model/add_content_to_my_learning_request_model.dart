import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';

class AddContentToMyLearningRequestModel {
  String SelectedContent = "";
  String multiInstanceParentId = "";
  String Locale = "";
  String ERitems = "";
  String HideAdd = "";
  String AdditionalParams = "";
  String TargetDate = "";
  String MultiInstanceEventEnroll = "";
  int UserID = 0;
  int SiteID = AppConstants.defaultSiteId;
  int OrgUnitID = AppConstants.defaultSiteId;
  int ComponentID = 0;
  int ComponentInsID = 0;
  int scoId = 0;
  int objecttypeId = 0;
  CourseDTOModel? courseDTOModel;

  AddContentToMyLearningRequestModel({
    required this.SelectedContent,
    this.multiInstanceParentId = "",
    this.Locale = "",
    required this.ERitems,
    required this.HideAdd,
    required this.AdditionalParams,
    required this.TargetDate,
    required this.MultiInstanceEventEnroll,
    this.UserID = 0,
    this.SiteID = AppConstants.defaultSiteId,
    this.OrgUnitID = AppConstants.defaultSiteId,
    required this.ComponentID,
    required this.ComponentInsID,
    required this.scoId,
    required this.objecttypeId,
    this.courseDTOModel,
  });

  Map<String, String> toJson() {
    return {
      "SelectedContent" : SelectedContent,
      "multiInstanceParentId" : multiInstanceParentId,
      "Locale" : Locale,
      "ERitems" : ERitems,
      "HideAdd" : HideAdd,
      "AdditionalParams" : AdditionalParams,
      "TargetDate" : TargetDate,
      "MultiInstanceEventEnroll" : MultiInstanceEventEnroll,
      "UserID" : UserID.toString(),
      "SiteID" : SiteID.toString(),
      "OrgUnitID" : OrgUnitID.toString(),
      "ComponentID" : ComponentID.toString(),
      "ComponentInsID" : ComponentInsID.toString(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}