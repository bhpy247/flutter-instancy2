import 'package:flutter_instancy_2/models/event_track/data_model/tag_model.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../../utils/my_utils.dart';
import '../../classroom_events/data_model/EventRecordingDetailsModel.dart';

class EventTrackHeaderDTOModel {
  String TitleName = "";
  String progress = "";
  String percentagecompleted = "";
  String AuthorDisplayName = "";
  String ContentType = "";
  String ContentStatus = "";
  String ViewLink = "";
  String ThumbnailImagePath = "";
  String TotalRatings = "";
  String RatingID = "";
  String PercentCompletedClass = "";
  String ContentProgress = "";
  String Location = "";
  String EventStartDateTime = "";
  String EventEndDateTime = "";
  String TimeZone = "";
  String FolderPath = "";
  String PresenterName = "";
  String SuggestwithFriendLink = "";
  String SuggesttoConnLink = "";
  String ContentID = "";
  String reportaction = "";
  String certificateaction = "";
  String certificatelink = "";
  String TrackPrintStatus = "";
  String NotifyMessage = "";
  String RecommendedLink = "";
  String CancelEventLink = "";
  String isBadCancellationEnabled = "";
  String DisplayStatus = "";
  int objecttypeid = 0;
  int TypeofEvent = 0;
  int EventType = 0;
  int CreatedUserID = 0;
  bool isShowReview = false;
  EventRecordingDetailsModel? RecordingDetails;
  List<TagModel> RelatedTags = <TagModel>[];

  EventTrackHeaderDTOModel({
    this.TitleName = "",
    this.progress = "",
    this.percentagecompleted = "",
    this.AuthorDisplayName = "",
    this.ContentType = "",
    this.ContentStatus = "",
    this.ViewLink = "",
    this.ThumbnailImagePath = "",
    this.TotalRatings = "",
    this.RatingID = "",
    this.PercentCompletedClass = "",
    this.ContentProgress = "",
    this.Location = "",
    this.EventStartDateTime = "",
    this.EventEndDateTime = "",
    this.TimeZone = "",
    this.FolderPath = "",
    this.PresenterName = "",
    this.SuggestwithFriendLink = "",
    this.SuggesttoConnLink = "",
    this.ContentID = "",
    this.reportaction = "",
    this.certificateaction = "",
    this.certificatelink = "",
    this.TrackPrintStatus = "",
    this.NotifyMessage = "",
    this.RecommendedLink = "",
    this.CancelEventLink = "",
    this.isBadCancellationEnabled = "",
    this.DisplayStatus = "",
    this.objecttypeid = 0,
    this.TypeofEvent = 0,
    this.EventType = 0,
    this.CreatedUserID = 0,
    this.isShowReview = false,
    this.RecordingDetails,
    List<TagModel>? RelatedTags,
  }) {
    this.RelatedTags = RelatedTags ?? <TagModel>[];
  }

  EventTrackHeaderDTOModel.fromJson(Map<String, dynamic> json) {
    TitleName = ParsingHelper.parseStringMethod(json["TitleName"]);
    progress = ParsingHelper.parseStringMethod(json["progress"]);
    percentagecompleted = ParsingHelper.parseStringMethod(json["percentagecompleted"]);
    AuthorDisplayName = ParsingHelper.parseStringMethod(json["AuthorDisplayName"]);
    ContentType = ParsingHelper.parseStringMethod(json["ContentType"]);
    ContentStatus = ParsingHelper.parseStringMethod(json["ContentStatus"]);
    ViewLink = ParsingHelper.parseStringMethod(json["ViewLink"]);
    ThumbnailImagePath = ParsingHelper.parseStringMethod(json["ThumbnailImagePath"]);
    TotalRatings = ParsingHelper.parseStringMethod(json["TotalRatings"]);
    RatingID = ParsingHelper.parseStringMethod(json["RatingID"]);
    PercentCompletedClass = ParsingHelper.parseStringMethod(json["PercentCompletedClass"]);
    ContentProgress = ParsingHelper.parseStringMethod(json["ContentProgress"]);
    Location = ParsingHelper.parseStringMethod(json["Location"]);
    EventStartDateTime = ParsingHelper.parseStringMethod(json["EventStartDateTime"]);
    EventEndDateTime = ParsingHelper.parseStringMethod(json["EventEndDateTime"]);
    TimeZone = ParsingHelper.parseStringMethod(json["TimeZone"]);
    FolderPath = ParsingHelper.parseStringMethod(json["FolderPath"]);
    PresenterName = ParsingHelper.parseStringMethod(json["PresenterName"]);
    SuggestwithFriendLink = ParsingHelper.parseStringMethod(json["SuggestwithFriendLink"]);
    SuggesttoConnLink = ParsingHelper.parseStringMethod(json["SuggesttoConnLink"]);
    ContentID = ParsingHelper.parseStringMethod(json["ContentID"]);
    reportaction = ParsingHelper.parseStringMethod(json["reportaction"]);
    certificateaction = ParsingHelper.parseStringMethod(json["certificateaction"]);
    certificatelink = ParsingHelper.parseStringMethod(json["certificatelink"]);
    TrackPrintStatus = ParsingHelper.parseStringMethod(json["TrackPrintStatus"]);
    NotifyMessage = ParsingHelper.parseStringMethod(json["NotifyMessage"]);
    RecommendedLink = ParsingHelper.parseStringMethod(json["RecommendedLink"]);
    CancelEventLink = ParsingHelper.parseStringMethod(json["CancelEventLink"]);
    isBadCancellationEnabled = ParsingHelper.parseStringMethod(json["isBadCancellationEnabled"]);
    DisplayStatus = ParsingHelper.parseStringMethod(json["DisplayStatus"]);
    objecttypeid = ParsingHelper.parseIntMethod(json["objecttypeid"]);
    TypeofEvent = ParsingHelper.parseIntMethod(json["TypeofEvent"]);
    EventType = ParsingHelper.parseIntMethod(json["EventType"]);
    CreatedUserID = ParsingHelper.parseIntMethod(json["CreatedUserID"]);
    isShowReview = ParsingHelper.parseBoolMethod(json["isShowReview"]);

    Map<String, dynamic> recordingDetailsMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(json['RecordingDetails']);
    if(recordingDetailsMap.isNotEmpty) RecordingDetails = EventRecordingDetailsModel.fromMap(recordingDetailsMap);

    List<Map<String, dynamic>> RelatedTagsMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(json['RelatedTags']);
    RelatedTags = RelatedTagsMapsList.map((e) {
      return TagModel.fromJson(e);
    }).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      "TitleName": TitleName,
      "progress": progress,
      "percentagecompleted": percentagecompleted,
      "AuthorDisplayName": AuthorDisplayName,
      "ContentType": ContentType,
      "ContentStatus": ContentStatus,
      "ViewLink": ViewLink,
      "ThumbnailImagePath": ThumbnailImagePath,
      "TotalRatings": TotalRatings,
      "RatingID": RatingID,
      "PercentCompletedClass": PercentCompletedClass,
      "ContentProgress": ContentProgress,
      "Location": Location,
      "EventStartDateTime": EventStartDateTime,
      "EventEndDateTime": EventEndDateTime,
      "TimeZone": TimeZone,
      "FolderPath": FolderPath,
      "PresenterName": PresenterName,
      "SuggestwithFriendLink": SuggestwithFriendLink,
      "SuggesttoConnLink": SuggesttoConnLink,
      "ContentID": ContentID,
      "reportaction": reportaction,
      "certificateaction": certificateaction,
      "certificatelink": certificatelink,
      "TrackPrintStatus": TrackPrintStatus,
      "NotifyMessage": NotifyMessage,
      "RecommendedLink": RecommendedLink,
      "CancelEventLink": CancelEventLink,
      "isBadCancellationEnabled": isBadCancellationEnabled,
      "DisplayStatus": DisplayStatus,
      "objecttypeid": objecttypeid,
      "TypeofEvent": TypeofEvent,
      "EventType": EventType,
      "CreatedUserID": CreatedUserID,
      "isShowReview": isShowReview,
      "RecordingDetails": RecordingDetails?.toMap(),
      "RelatedTags": RelatedTags.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}

