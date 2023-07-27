import '../../../configs/app_constants.dart';
import '../../../utils/my_utils.dart';

class CourseDetailsScheduleDataRequestModel {
  String EventID;
  String LocalID;
  String multiInstanceEventEnroll;
  String MultiLocation;
  int UserID;
  int SiteID;

  CourseDetailsScheduleDataRequestModel({
    required this.EventID,
    this.LocalID = AppConstants.defaultLocale,
    this.multiInstanceEventEnroll = "",
    this.MultiLocation = "",
    this.UserID = 0,
    this.SiteID = AppConstants.defaultSiteId,
  });

  Map<String, String> toJson() {
    return {
      "EventID": EventID,
      "LocalID": LocalID,
      "MultiInstanceEventEnroll": multiInstanceEventEnroll,
      "MultiLocation": MultiLocation,
      "UserID": UserID.toString(),
      "SiteID": SiteID.toString(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}