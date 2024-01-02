import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/classroom_events/data_model/EventRecordingDetailsModel.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class TrackCourseDTOModel {
  String ActivityId = "";
  String ContentID = "";
  String Titlewithlink = "";
  String rcaction = "";
  String Categories = "";
  String IsSubSite = "";
  String MembershipName = "";
  String EventAvailableSeats = "";
  String EventCompletedProgress = "";
  String EventContentProgress = "";
  String PreviewLink = "";
  String ApproveLink = "";
  String RejectLink = "";
  String ReadLink = "";
  String AddLink = "";
  String EnrollNowLink = "";
  String CancelEventLink = "";
  String WaitListLink = "";
  String InapppurchageLink = "";
  String AlredyinmylearnigLink = "";
  String RecommendedLink = "";
  String Sharelink = "";
  String EditMetadataLink = "";
  String ReplaceLink = "";
  String EditLink = "";
  String DeleteLink = "";
  String SampleContentLink = "";
  String TitleExpired = "";
  String PracticeAssessmentsAction = "";
  String CreateAssessmentAction = "";
  String OverallProgressReportAction = "";
  String ContentName = "";
  String ContentScoID = "";
  String TotalRatings = "";
  String RatingID = "";
  String PercentCompletedClass = "";
  String ContentStatus = "";
  String ContentType = "";
  String ShortDescription = "";
  String Title = "";
  String AuthorDisplayName = "";
  String ThumbnailImagePath = "";
  String ContentProgress = "";
  String ViewLink = "";
  String WindowProperties = "";
  String Timezone = "";
  String ViewType = "";
  String isContentEnrolled = "";
  String firstObjectViewLink = "";
  String firstlaunchContentID = "";
  String firstlaunchContentName = "";
  String firstlaunchContentTypeId = "";
  String SetCompleteAction = "";
  String JWVideoKey = "";
  String ThumbnailIconPath = "";
  String InstanceEventEnroll = "";
  String ReEnrollmentHistory = "";
  String InstanceEventReclass = "";
  String InstanceEventReclassStatus = "";
  String DetailsLink = "";
  String wstatus = "";
  String wmessage = "";
  String TimeSpentType = "";
  String TimeToBeSpent = "";
  String TimeSpent = "";
  String EventStartDateTime = "";
  String EventEndDateTime = "";
  String PresenterName = "";
  String EventType = "";
  String CoreLessonStatus = "";
  String PAOrDAReporLink = "";
  String ActionViewQRcode = "";
  String isEnrollFutureInstance = "";
  String InstanceEventReSchedule = "";
  String DownloadLink = "";
  String ShareContentwithUser = "";
  String MediaColor = "";
  String MediaFontColor = "";
  String Duration = "";
  String SkinID = "";
  String RelatedContentLink = "";
  String ExpiredContentAvailableUntill = "";
  String ExpiredContentExpiryDate = "";
  String ReportLink = "";
  String prevCourseName = "";
  String FolderPath = "";
  String JwStartPage = "";
  String StartPage = "";
  int Count = 0;
  int ScoID = 0;
  int ContentTypeId = 0;
  int firstlaunchScoID = 0;
  int SequenceID = 0;
  int EventScheduleType = 0;
  int MediaTypeID = 0;
  int timeSpentHours = 0;
  int ViewTypeValue = 0;
  bool AllowedNavigation = false;
  bool isBadCancellationEnabled = false;
  bool bit1 = false;
  bool bit5 = false;
  EventRecordingDetailsModel? RecordingDetails;

  TrackCourseDTOModel({
    this.ActivityId = "",
    this.ContentID = "",
    this.Titlewithlink = "",
    this.rcaction = "",
    this.Categories = "",
    this.IsSubSite = "",
    this.MembershipName = "",
    this.EventAvailableSeats = "",
    this.EventCompletedProgress = "",
    this.EventContentProgress = "",
    this.PreviewLink = "",
    this.ApproveLink = "",
    this.RejectLink = "",
    this.ReadLink = "",
    this.AddLink = "",
    this.EnrollNowLink = "",
    this.CancelEventLink = "",
    this.WaitListLink = "",
    this.InapppurchageLink = "",
    this.AlredyinmylearnigLink = "",
    this.RecommendedLink = "",
    this.Sharelink = "",
    this.EditMetadataLink = "",
    this.ReplaceLink = "",
    this.EditLink = "",
    this.DeleteLink = "",
    this.SampleContentLink = "",
    this.TitleExpired = "",
    this.PracticeAssessmentsAction = "",
    this.CreateAssessmentAction = "",
    this.OverallProgressReportAction = "",
    this.ContentName = "",
    this.ContentScoID = "",
    this.TotalRatings = "",
    this.RatingID = "",
    this.PercentCompletedClass = "",
    this.ContentStatus = "",
    this.ContentType = "",
    this.ShortDescription = "",
    this.Title = "",
    this.AuthorDisplayName = "",
    this.ThumbnailImagePath = "",
    this.ContentProgress = "",
    this.ViewLink = "",
    this.WindowProperties = "",
    this.Timezone = "",
    this.ViewType = "",
    this.isContentEnrolled = "",
    this.firstObjectViewLink = "",
    this.firstlaunchContentID = "",
    this.firstlaunchContentName = "",
    this.firstlaunchContentTypeId = "",
    this.SetCompleteAction = "",
    this.JWVideoKey = "",
    this.ThumbnailIconPath = "",
    this.InstanceEventEnroll = "",
    this.ReEnrollmentHistory = "",
    this.InstanceEventReclass = "",
    this.InstanceEventReclassStatus = "",
    this.DetailsLink = "",
    this.wstatus = "",
    this.wmessage = "",
    this.TimeSpentType = "",
    this.TimeToBeSpent = "",
    this.TimeSpent = "",
    this.EventStartDateTime = "",
    this.EventEndDateTime = "",
    this.PresenterName = "",
    this.EventType = "",
    this.CoreLessonStatus = "",
    this.PAOrDAReporLink = "",
    this.ActionViewQRcode = "",
    this.isEnrollFutureInstance = "",
    this.InstanceEventReSchedule = "",
    this.DownloadLink = "",
    this.ShareContentwithUser = "",
    this.MediaColor = "",
    this.MediaFontColor = "",
    this.Duration = "",
    this.SkinID = "",
    this.RelatedContentLink = "",
    this.ExpiredContentAvailableUntill = "",
    this.ExpiredContentExpiryDate = "",
    this.ReportLink = "",
    this.prevCourseName = "",
    this.FolderPath = "",
    this.JwStartPage = "",
    this.StartPage = "",
    this.Count = 0,
    this.ScoID = 0,
    this.ContentTypeId = 0,
    this.firstlaunchScoID = 0,
    this.SequenceID = 0,
    this.EventScheduleType = 0,
    this.MediaTypeID = 0,
    this.timeSpentHours = 0,
    this.ViewTypeValue = 0,
    this.AllowedNavigation = false,
    this.isBadCancellationEnabled = false,
    this.bit1 = false,
    this.bit5 = false,
    this.RecordingDetails,
  });

  TrackCourseDTOModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    ActivityId = ParsingHelper.parseStringMethod(map["ActivityId"]);
    ContentID = ParsingHelper.parseStringMethod(map["ContentID"]);
    Titlewithlink = ParsingHelper.parseStringMethod(map["Titlewithlink"]);
    rcaction = ParsingHelper.parseStringMethod(map["rcaction"]);
    Categories = ParsingHelper.parseStringMethod(map["Categories"]);
    IsSubSite = ParsingHelper.parseStringMethod(map["IsSubSite"]);
    MembershipName = ParsingHelper.parseStringMethod(map["MembershipName"]);
    EventAvailableSeats = ParsingHelper.parseStringMethod(map["EventAvailableSeats"]);
    EventCompletedProgress = ParsingHelper.parseStringMethod(map["EventCompletedProgress"]);
    EventContentProgress = ParsingHelper.parseStringMethod(map["EventContentProgress"]);
    PreviewLink = ParsingHelper.parseStringMethod(map["PreviewLink"]);
    ApproveLink = ParsingHelper.parseStringMethod(map["ApproveLink"]);
    RejectLink = ParsingHelper.parseStringMethod(map["RejectLink"]);
    ReadLink = ParsingHelper.parseStringMethod(map["ReadLink"]);
    AddLink = ParsingHelper.parseStringMethod(map["AddLink"]);
    EnrollNowLink = ParsingHelper.parseStringMethod(map["EnrollNowLink"]);
    CancelEventLink = ParsingHelper.parseStringMethod(map["CancelEventLink"]);
    WaitListLink = ParsingHelper.parseStringMethod(map["WaitListLink"]);
    InapppurchageLink = ParsingHelper.parseStringMethod(map["InapppurchageLink"]);
    AlredyinmylearnigLink = ParsingHelper.parseStringMethod(map["AlredyinmylearnigLink"]);
    RecommendedLink = ParsingHelper.parseStringMethod(map["RecommendedLink"]);
    Sharelink = ParsingHelper.parseStringMethod(map["Sharelink"]);
    EditMetadataLink = ParsingHelper.parseStringMethod(map["EditMetadataLink"]);
    ReplaceLink = ParsingHelper.parseStringMethod(map["ReplaceLink"]);
    EditLink = ParsingHelper.parseStringMethod(map["EditLink"]);
    DeleteLink = ParsingHelper.parseStringMethod(map["DeleteLink"]);
    SampleContentLink = ParsingHelper.parseStringMethod(map["SampleContentLink"]);
    TitleExpired = ParsingHelper.parseStringMethod(map["TitleExpired"]);
    PracticeAssessmentsAction = ParsingHelper.parseStringMethod(map["PracticeAssessmentsAction"]);
    CreateAssessmentAction = ParsingHelper.parseStringMethod(map["CreateAssessmentAction"]);
    OverallProgressReportAction = ParsingHelper.parseStringMethod(map["OverallProgressReportAction"]);
    ContentName = ParsingHelper.parseStringMethod(map["ContentName"]);
    ContentScoID = ParsingHelper.parseStringMethod(map["ContentScoID"]);
    TotalRatings = ParsingHelper.parseStringMethod(map["TotalRatings"]);
    RatingID = ParsingHelper.parseStringMethod(map["RatingID"]);
    PercentCompletedClass = ParsingHelper.parseStringMethod(map["PercentCompletedClass"]);
    ContentStatus = ParsingHelper.parseStringMethod(map["ContentStatus"]);
    ContentType = ParsingHelper.parseStringMethod(map["ContentType"]);
    ShortDescription = ParsingHelper.parseStringMethod(map["ShortDescription"]);
    Title = ParsingHelper.parseStringMethod(map["Title"]);
    AuthorDisplayName = ParsingHelper.parseStringMethod(map["AuthorDisplayName"]);
    ThumbnailImagePath = ParsingHelper.parseStringMethod(map["ThumbnailImagePath"]);
    ContentProgress = ParsingHelper.parseStringMethod(map["ContentProgress"]);
    ViewLink = ParsingHelper.parseStringMethod(map["ViewLink"]);
    WindowProperties = ParsingHelper.parseStringMethod(map["WindowProperties"]);
    Timezone = ParsingHelper.parseStringMethod(map["Timezone"]);
    ViewType = ParsingHelper.parseStringMethod(map["ViewType"]);
    isContentEnrolled = ParsingHelper.parseStringMethod(map["isContentEnrolled"]);
    firstObjectViewLink = ParsingHelper.parseStringMethod(map["firstObjectViewLink"]);
    firstlaunchContentID = ParsingHelper.parseStringMethod(map["firstlaunchContentID"]);
    firstlaunchContentName = ParsingHelper.parseStringMethod(map["firstlaunchContentName"]);
    firstlaunchContentTypeId = ParsingHelper.parseStringMethod(map["firstlaunchContentTypeId"]);
    SetCompleteAction = ParsingHelper.parseStringMethod(map["SetCompleteAction"]);
    JWVideoKey = ParsingHelper.parseStringMethod(map["JWVideoKey"]);
    ThumbnailIconPath = ParsingHelper.parseStringMethod(map["ThumbnailIconPath"]);
    InstanceEventEnroll = ParsingHelper.parseStringMethod(map["InstanceEventEnroll"]);
    ReEnrollmentHistory = ParsingHelper.parseStringMethod(map["ReEnrollmentHistory"]);
    InstanceEventReclass = ParsingHelper.parseStringMethod(map["InstanceEventReclass"]);
    InstanceEventReclassStatus = ParsingHelper.parseStringMethod(map["InstanceEventReclassStatus"]);
    DetailsLink = ParsingHelper.parseStringMethod(map["DetailsLink"]);
    wstatus = ParsingHelper.parseStringMethod(map["wstatus"]);
    wmessage = ParsingHelper.parseStringMethod(map["wmessage"]);
    TimeSpentType = ParsingHelper.parseStringMethod(map["TimeSpentType"]);
    TimeToBeSpent = ParsingHelper.parseStringMethod(map["TimeToBeSpent"]);
    TimeSpent = ParsingHelper.parseStringMethod(map["TimeSpent"]);
    EventStartDateTime = ParsingHelper.parseStringMethod(map["EventStartDateTime"]);
    EventEndDateTime = ParsingHelper.parseStringMethod(map["EventEndDateTime"]);
    PresenterName = ParsingHelper.parseStringMethod(map["PresenterName"]);
    EventType = ParsingHelper.parseStringMethod(map["EventType"]);
    CoreLessonStatus = ParsingHelper.parseStringMethod(map["CoreLessonStatus"]);
    PAOrDAReporLink = ParsingHelper.parseStringMethod(map["PAOrDAReporLink"]);
    ActionViewQRcode = ParsingHelper.parseStringMethod(map["ActionViewQRcode"]);
    isEnrollFutureInstance = ParsingHelper.parseStringMethod(map["isEnrollFutureInstance"]);
    InstanceEventReSchedule = ParsingHelper.parseStringMethod(map["InstanceEventReSchedule"]);
    DownloadLink = ParsingHelper.parseStringMethod(map["DownloadLink"]);
    ShareContentwithUser = ParsingHelper.parseStringMethod(map["ShareContentwithUser"]);
    MediaColor = ParsingHelper.parseStringMethod(map["MediaColor"]);
    MediaFontColor = ParsingHelper.parseStringMethod(map["MediaFontColor"]);
    Duration = ParsingHelper.parseStringMethod(map["Duration"]);
    SkinID = ParsingHelper.parseStringMethod(map["SkinID"]);
    RelatedContentLink = ParsingHelper.parseStringMethod(map["RelatedContentLink"]);
    ExpiredContentAvailableUntill = ParsingHelper.parseStringMethod(map["ExpiredContentAvailableUntill"]);
    ExpiredContentExpiryDate = ParsingHelper.parseStringMethod(map["ExpiredContentExpiryDate"]);
    ReportLink = ParsingHelper.parseStringMethod(map["ReportLink"]);
    prevCourseName = ParsingHelper.parseStringMethod(map["prevCourseName"]);
    FolderPath = ParsingHelper.parseStringMethod(map["FolderPath"]);
    JwStartPage = ParsingHelper.parseStringMethod(map["JwStartPage"]);
    StartPage = ParsingHelper.parseStringMethod(map["StartPage"]);
    Count = ParsingHelper.parseIntMethod(map["Count"]);
    ScoID = ParsingHelper.parseIntMethod(map["ScoID"]);
    ContentTypeId = ParsingHelper.parseIntMethod(map["ContentTypeId"]);
    firstlaunchScoID = ParsingHelper.parseIntMethod(map["firstlaunchScoID"]);
    SequenceID = ParsingHelper.parseIntMethod(map["SequenceID"]);
    EventScheduleType = ParsingHelper.parseIntMethod(map["EventScheduleType"]);
    MediaTypeID = ParsingHelper.parseIntMethod(map["MediaTypeID"]);
    timeSpentHours = ParsingHelper.parseIntMethod(map["timeSpentHours"]);
    ViewTypeValue = switch (ViewType) {
      EventTrackViewTypesForContent.View => ViewTypesForContent.View,
      EventTrackViewTypesForContent.Subscription => ViewTypesForContent.Subscription,
      EventTrackViewTypesForContent.ECommerce => ViewTypesForContent.ECommerce,
      EventTrackViewTypesForContent.ViewAndAddtoMyLearning => ViewTypesForContent.ViewAndAddToMyLearning,
      _ => 0,
    };
    AllowedNavigation = ParsingHelper.parseBoolMethod(map["AllowedNavigation"]);
    isBadCancellationEnabled = ParsingHelper.parseBoolMethod(map["isBadCancellationEnabled"]);
    bit1 = ParsingHelper.parseBoolMethod(map["bit1"]);
    bit5 = ParsingHelper.parseBoolMethod(map["bit5"]);

    RecordingDetails = null;
    Map<String, dynamic> recordingDetailsMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(map['RecordingDetails']);
    if (recordingDetailsMap.isNotEmpty) RecordingDetails = EventRecordingDetailsModel.fromMap(recordingDetailsMap);
  }

  Map<String, dynamic> toMap() {
    return {
      "ActivityId": ActivityId,
      "ContentID": ContentID,
      "Titlewithlink": Titlewithlink,
      "rcaction": rcaction,
      "Categories": Categories,
      "IsSubSite": IsSubSite,
      "MembershipName": MembershipName,
      "EventAvailableSeats": EventAvailableSeats,
      "EventCompletedProgress": EventCompletedProgress,
      "EventContentProgress": EventContentProgress,
      "PreviewLink": PreviewLink,
      "ApproveLink": ApproveLink,
      "RejectLink": RejectLink,
      "ReadLink": ReadLink,
      "AddLink": AddLink,
      "EnrollNowLink": EnrollNowLink,
      "CancelEventLink": CancelEventLink,
      "WaitListLink": WaitListLink,
      "InapppurchageLink": InapppurchageLink,
      "AlredyinmylearnigLink": AlredyinmylearnigLink,
      "RecommendedLink": RecommendedLink,
      "Sharelink": Sharelink,
      "EditMetadataLink": EditMetadataLink,
      "ReplaceLink": ReplaceLink,
      "EditLink": EditLink,
      "DeleteLink": DeleteLink,
      "SampleContentLink": SampleContentLink,
      "TitleExpired": TitleExpired,
      "PracticeAssessmentsAction": PracticeAssessmentsAction,
      "CreateAssessmentAction": CreateAssessmentAction,
      "OverallProgressReportAction": OverallProgressReportAction,
      "ContentName": ContentName,
      "ContentScoID": ContentScoID,
      "TotalRatings": TotalRatings,
      "RatingID": RatingID,
      "PercentCompletedClass": PercentCompletedClass,
      "ContentStatus": ContentStatus,
      "ContentType": ContentType,
      "ShortDescription": ShortDescription,
      "Title": Title,
      "AuthorDisplayName": AuthorDisplayName,
      "ThumbnailImagePath": ThumbnailImagePath,
      "ContentProgress": ContentProgress,
      "ViewLink": ViewLink,
      "WindowProperties": WindowProperties,
      "Timezone": Timezone,
      "ViewType": ViewType,
      "isContentEnrolled": isContentEnrolled,
      "firstObjectViewLink": firstObjectViewLink,
      "firstlaunchContentID": firstlaunchContentID,
      "firstlaunchContentName": firstlaunchContentName,
      "firstlaunchContentTypeId": firstlaunchContentTypeId,
      "SetCompleteAction": SetCompleteAction,
      "JWVideoKey": JWVideoKey,
      "ThumbnailIconPath": ThumbnailIconPath,
      "InstanceEventEnroll": InstanceEventEnroll,
      "ReEnrollmentHistory": ReEnrollmentHistory,
      "InstanceEventReclass": InstanceEventReclass,
      "InstanceEventReclassStatus": InstanceEventReclassStatus,
      "DetailsLink": DetailsLink,
      "wstatus": wstatus,
      "wmessage": wmessage,
      "TimeSpentType": TimeSpentType,
      "TimeToBeSpent": TimeToBeSpent,
      "TimeSpent": TimeSpent,
      "EventStartDateTime": EventStartDateTime,
      "EventEndDateTime": EventEndDateTime,
      "PresenterName": PresenterName,
      "EventType": EventType,
      "CoreLessonStatus": CoreLessonStatus,
      "PAOrDAReporLink": PAOrDAReporLink,
      "ActionViewQRcode": ActionViewQRcode,
      "isEnrollFutureInstance": isEnrollFutureInstance,
      "InstanceEventReSchedule": InstanceEventReSchedule,
      "DownloadLink": DownloadLink,
      "ShareContentwithUser": ShareContentwithUser,
      "MediaColor": MediaColor,
      "MediaFontColor": MediaFontColor,
      "Duration": Duration,
      "SkinID": SkinID,
      "RelatedContentLink": RelatedContentLink,
      "ExpiredContentAvailableUntill": ExpiredContentAvailableUntill,
      "ExpiredContentExpiryDate": ExpiredContentExpiryDate,
      "ReportLink": ReportLink,
      "prevCourseName": prevCourseName,
      "FolderPath": FolderPath,
      "JwStartPage": JwStartPage,
      "StartPage": StartPage,
      "Count": Count,
      "ScoID": ScoID,
      "ContentTypeId": ContentTypeId,
      "firstlaunchScoID": firstlaunchScoID,
      "SequenceID": SequenceID,
      "EventScheduleType": EventScheduleType,
      "MediaTypeID": MediaTypeID,
      "timeSpentHours": timeSpentHours,
      "ViewTypeValue": ViewTypeValue,
      "AllowedNavigation": AllowedNavigation,
      "isBadCancellationEnabled": isBadCancellationEnabled,
      "bit1": bit1,
      "bit5": bit5,
      "RecordingDetails": RecordingDetails?.toMap(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
