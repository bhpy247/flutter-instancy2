import '../../../configs/app_constants.dart';
import '../../../utils/my_utils.dart';

class CourseDetailsRequestModel {
  String ContentID;
  String Locale;
  String CartID;
  String ERitems;
  String ComponentDetailsProperties;
  String FormContentList;
  String MultiInstanceEventEnroll;
  int metadata;
  int? intUserID;
  int ComponentID;
  int? SiteID;
  int? InstructorID;
  int DetailsCompID;
  int DetailsCompInsID;
  int? SkippedRows;
  int? NoofRows;
  int objectTypeID;
  int? scoID;
  bool iCMS;
  bool HideAdd;
  bool SubscribeERC;

  CourseDetailsRequestModel({
    required this.ContentID,
    this.Locale = AppConstants.defaultLocale,
    this.CartID = "",
    this.ERitems = "",
    this.ComponentDetailsProperties = "",
    this.FormContentList = "",
    this.MultiInstanceEventEnroll = "",
    required this.metadata,
    this.intUserID,
    required this.ComponentID,
    this.SiteID = AppConstants.defaultSiteId,
    this.InstructorID,
    required this.DetailsCompID,
    required this.DetailsCompInsID,
    this.SkippedRows,
    this.NoofRows,
    this.objectTypeID = -1,
    this.scoID,
    this.iCMS = false,
    this.HideAdd = false,
    this.SubscribeERC = false,
  });

  Map<String, String> toJson() {
    return {
      "ContentID": ContentID,
      "Locale": Locale,
      "CartID": CartID,
      "ERitems": ERitems,
      "ComponentDetailsProperties": ComponentDetailsProperties,
      "FormContentList": FormContentList,
      "MultiInstanceEventEnroll": MultiInstanceEventEnroll,
      "metadata": metadata.toString(),
      if(intUserID != null) "intUserID": intUserID.toString(),
      "ComponentID": ComponentID.toString(),
      if(SiteID != null) "SiteID": SiteID.toString(),
      if(InstructorID != null) "InstructorID": InstructorID.toString(),
      "DetailsCompID": DetailsCompID.toString(),
      "DetailsCompInsID": DetailsCompInsID.toString(),
      if(SkippedRows != null) "SkippedRows": SkippedRows.toString(),
      if(NoofRows != null) "NoofRows": NoofRows.toString(),
      "objectTypeID": objectTypeID.toString(),
      if(scoID != null) "scoID": scoID.toString(),
      "iCMS": iCMS.toString(),
      "HideAdd": HideAdd.toString(),
      "SubscribeERC": SubscribeERC.toString(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}