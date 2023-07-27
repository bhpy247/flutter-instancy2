import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/utils/date_representation.dart';

class MyLearningContentProgressSummaryDataRequestModel {
  String contentId;
  int objectTypeId;
  int userID;
  DateTime? startDate;
  DateTime? endDate;
  String sequenceId;
  String trackID;
  String eventID;
  int siteId;
  String locale;

  MyLearningContentProgressSummaryDataRequestModel({
    required this.contentId,
    required this.objectTypeId,
    required this.userID,
    this.startDate,
    this.endDate,
    this.sequenceId = "-1",
    this.trackID = "",
    this.eventID = "",
    this.siteId = AppConstants.defaultSiteId,
    this.locale = AppConstants.defaultLocale,
  });

  Map<String, String> toMap() {
    return <String, String>{
      'CID': contentId,
      'ObjectTypeId': objectTypeId.toString(),
      'UserID': userID.toString(),
      'StartDate': DatePresentation.getFormattedDate(dateFormat: "MM/dd/yyyy", dateTime: startDate) ?? "",
      'EndDate': DatePresentation.getFormattedDate(dateFormat: "MM/dd/yyyy", dateTime: endDate) ?? "",
      'SeqID': sequenceId,
      'TrackID': trackID,
      'EventID': eventID,
      'SiteID': siteId.toString(),
      'Locale': locale,
    };
  }
}