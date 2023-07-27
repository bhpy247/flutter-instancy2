import '../../../backend/configurations/app_configuration_operations.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';
import '../../classroom_events/data_model/EventRecordingDetailsModel.dart';
import '../../course/data_model/CourseDTOModel.dart';

class ContentDetailsDTOModel extends CourseDTOModel {
  String strCatalogContentRemoved = "";
  String Presentername = "";
  String PresenterLink = "";
  String DirectionURL = "";
  String LongDescription = "";
  String ErrorMesage = "";
  String AddLink = "";
  String CancelEventlink = "";
  String EnrollNowLink = "";
  String DownloadCalender = "";
  String titleExpired = "";
  String AddPastLink = "";
  String EventScheduleLink = "";
  String EventScheduleStatus = "";
  String EventScheduleConfirmLink = "";
  String EventScheduleCancelLink = "";
  String EventScheduleReserveTime = "";
  String EventScheduleReserveStatus = "";
  String ReScheduleEvent = "";
  String Addorremoveattendees = "";
  String CancelScheduleEvent = "";
  String ShowReadMore = "";
  String SetCompleteAction = "";
  String TitleName = "";
  String TitleWithlink = "";
  String ImageWithlink = "";
  String ShowThumbnailImagePath = "";
  String CertificateLink = "";
  String SurveyLink = "";
  String NotesLink = "";
  String WaitListLink = "";
  String ShowParentPrerequisiteEventDate = "";
  String ShowPrerequisiteEventDate = "";
  String DiscussionsLink = "";
  String ContentViewType = "";
  String WindowProperties = "";
  String AutolaunchViewLink = "";
  String TitleViewlink = "";
  String NotifyMessage = "";
  String LearningObjectives = "";
  String TableofContent = "";
  String ThumbnailVideoPath = "";
  String SubTitleTag = "";
  String islearningcontent = "";
  String RedirectinstanceID = "";
  String Duration = "";
  String ActionViewQRcode = "";
  String EnrollmentLimit = "";
  String AvailableSeats = "";
  String NoofUsersEnrolled = "";
  String WaitListLimit = "";
  String WaitListEnrolls = "";
  String DownloadLink = "";
  String TypeofEvent = "";
  String jwstartpage = "";
  String QRImageName = "";
  String SkinID = "";
  String SampleContentLink = "";
  String UserProfileImagePath = "";
  bool isBadCancellationEnabled = false;
  bool isContentEnrolled = false;
  bool isShowEventFullStatus = false;
  bool isBookingOpened = false;
  bool IsSuccess = false;
  bool NoRecord = false;
  bool IsArchived = false;
  bool showSchedule = false;
  bool IsViewReview = false;
  double percentagecompleted = 0;
  EventRecordingDetailsModel? recordingDetails;

  ContentDetailsDTOModel({
    this.strCatalogContentRemoved = "",
    this.Presentername = "",
    this.PresenterLink = "",
    this.DirectionURL = "",
    this.LongDescription = "",
    this.ErrorMesage = "",
    this.AddLink = "",
    this.CancelEventlink = "",
    this.EnrollNowLink = "",
    this.DownloadCalender = "",
    this.titleExpired = "",
    this.AddPastLink = "",
    this.EventScheduleLink = "",
    this.EventScheduleStatus = "",
    this.EventScheduleConfirmLink = "",
    this.EventScheduleCancelLink = "",
    this.EventScheduleReserveTime = "",
    this.EventScheduleReserveStatus = "",
    this.ReScheduleEvent = "",
    this.Addorremoveattendees = "",
    this.CancelScheduleEvent = "",
    this.ShowReadMore = "",
    this.SetCompleteAction = "",
    this.TitleName = "",
    this.TitleWithlink = "",
    this.ImageWithlink = "",
    this.ShowThumbnailImagePath = "",
    this.CertificateLink = "",
    this.SurveyLink = "",
    this.NotesLink = "",
    this.WaitListLink = "",
    this.ShowParentPrerequisiteEventDate = "",
    this.ShowPrerequisiteEventDate = "",
    this.UserProfileImagePath = "",
    this.DiscussionsLink = "",
    this.ContentViewType = "",
    this.WindowProperties = "",
    this.AutolaunchViewLink = "",
    this.TitleViewlink = "",
    this.NotifyMessage = "",
    this.LearningObjectives = "",
    this.TableofContent = "",
    this.ThumbnailVideoPath = "",
    this.SubTitleTag = "",
    this.islearningcontent = "",
    this.RedirectinstanceID = "",
    this.Duration = "",
    this.ActionViewQRcode = "",
    this.EnrollmentLimit = "",
    this.AvailableSeats = "",
    this.NoofUsersEnrolled = "",
    this.WaitListLimit = "",
    this.WaitListEnrolls = "",
    this.DownloadLink = "",
    this.TypeofEvent = "",
    this.jwstartpage = "",
    this.QRImageName = "",
    this.SkinID = "",
    this.SampleContentLink = "",
    this.isBadCancellationEnabled = false,
    this.isContentEnrolled = false,
    this.isBookingOpened = false,
    this.isShowEventFullStatus = false,
    this.IsSuccess = false,
    this.NoRecord = false,
    this.IsArchived = false,
    this.showSchedule = false,
    this.IsViewReview = false,
    this.percentagecompleted = 0,
    this.recordingDetails,
  }) : super();

  ContentDetailsDTOModel.fromJson(Map<String, dynamic> json) {
    _initializeFromJson(json);
  }

  void updateFromJson(Map<String, dynamic> json) {
    _initializeFromJson(json);
  }

  void _initializeFromJson(Map<String, dynamic> json) {
    super.updateFromMap(json);

    strCatalogContentRemoved = ParsingHelper.parseStringMethod(json["strCatalogContentRemoved"]);
    Presentername = ParsingHelper.parseStringMethod(json["Presentername"]);
    PresenterLink = ParsingHelper.parseStringMethod(json["PresenterLink"]);
    DirectionURL = ParsingHelper.parseStringMethod(json["DirectionURL"]);
    LongDescription = ParsingHelper.parseStringMethod(json["LongDescription"]);
    ErrorMesage = ParsingHelper.parseStringMethod(json["ErrorMesage"]);
    AddLink = ParsingHelper.parseStringMethod(json["AddLink"]);
    CancelEventlink = ParsingHelper.parseStringMethod(json["CancelEventlink"]);
    EnrollNowLink = ParsingHelper.parseStringMethod(json["EnrollNowLink"]);
    DownloadCalender = ParsingHelper.parseStringMethod(json["DownloadCalender"]);
    titleExpired = ParsingHelper.parseStringMethod(json["titleExpired"]);
    AddPastLink = ParsingHelper.parseStringMethod(json["AddPastLink"]);
    EventScheduleLink = ParsingHelper.parseStringMethod(json["EventScheduleLink"]);
    EventScheduleStatus = ParsingHelper.parseStringMethod(json["EventScheduleStatus"]);
    EventScheduleConfirmLink = ParsingHelper.parseStringMethod(json["EventScheduleConfirmLink"]);
    EventScheduleCancelLink = ParsingHelper.parseStringMethod(json["EventScheduleCancelLink"]);
    EventScheduleReserveTime = ParsingHelper.parseStringMethod(json["EventScheduleReserveTime"]);
    EventScheduleReserveStatus = ParsingHelper.parseStringMethod(json["EventScheduleReserveStatus"]);
    ReScheduleEvent = ParsingHelper.parseStringMethod(json["ReScheduleEvent"]);
    Addorremoveattendees = ParsingHelper.parseStringMethod(json["Addorremoveattendees"]);
    CancelScheduleEvent = ParsingHelper.parseStringMethod(json["CancelScheduleEvent"]);
    ShowReadMore = ParsingHelper.parseStringMethod(json["ShowReadMore"]);
    SetCompleteAction = ParsingHelper.parseStringMethod(json["SetCompleteAction"]);
    TitleName = ParsingHelper.parseStringMethod(json["TitleName"]);
    UserProfileImagePath = ParsingHelper.parseStringMethod(json["UserProfileImagePath"]);
    TitleWithlink = ParsingHelper.parseStringMethod(json["TitleWithlink"]);
    ImageWithlink = ParsingHelper.parseStringMethod(json["ImageWithlink"]);
    ShowThumbnailImagePath = ParsingHelper.parseStringMethod(json["ShowThumbnailImagePath"]);
    CertificateLink = ParsingHelper.parseStringMethod(json["CertificateLink"]);
    SurveyLink = ParsingHelper.parseStringMethod(json["SurveyLink"]);
    NotesLink = ParsingHelper.parseStringMethod(json["NotesLink"]);
    WaitListLink = ParsingHelper.parseStringMethod(json["WaitListLink"]);
    ShowParentPrerequisiteEventDate = ParsingHelper.parseStringMethod(json["ShowParentPrerequisiteEventDate"]);
    ShowPrerequisiteEventDate = ParsingHelper.parseStringMethod(json["ShowPrerequisiteEventDate"]);
    DiscussionsLink = ParsingHelper.parseStringMethod(json["DiscussionsLink"]);
    ContentViewType = ParsingHelper.parseStringMethod(json["ContentViewType"]);
    WindowProperties = ParsingHelper.parseStringMethod(json["WindowProperties"]);
    AutolaunchViewLink = ParsingHelper.parseStringMethod(json["AutolaunchViewLink"]);
    TitleViewlink = ParsingHelper.parseStringMethod(json["TitleViewlink"]);
    NotifyMessage = ParsingHelper.parseStringMethod(json["NotifyMessage"]);
    LearningObjectives = ParsingHelper.parseStringMethod(json["LearningObjectives"]);
    TableofContent = ParsingHelper.parseStringMethod(json["TableofContent"]);
    ThumbnailVideoPath = ParsingHelper.parseStringMethod(json["ThumbnailVideoPath"]);
    SubTitleTag = ParsingHelper.parseStringMethod(json["SubTitleTag"]);
    islearningcontent = ParsingHelper.parseStringMethod(json["islearningcontent"]);
    RedirectinstanceID = ParsingHelper.parseStringMethod(json["RedirectinstanceID"]);
    Duration = ParsingHelper.parseStringMethod(json["Duration"]);
    ActionViewQRcode = ParsingHelper.parseStringMethod(json["ActionViewQRcode"]);
    EnrollmentLimit = ParsingHelper.parseStringMethod(json["EnrollmentLimit"]);
    AvailableSeats = ParsingHelper.parseStringMethod(json["AvailableSeats"]);
    NoofUsersEnrolled = ParsingHelper.parseStringMethod(json["NoofUsersEnrolled"]);
    WaitListLimit = ParsingHelper.parseStringMethod(json["WaitListLimit"]);
    WaitListEnrolls = ParsingHelper.parseStringMethod(json["WaitListEnrolls"]);
    DownloadLink = ParsingHelper.parseStringMethod(json["DownloadLink"]);
    TypeofEvent = ParsingHelper.parseStringMethod(json["TypeofEvent"]);
    jwstartpage = ParsingHelper.parseStringMethod(json["jwstartpage"]);
    QRImageName = ParsingHelper.parseStringMethod(json["QRImageName"]);
    SkinID = ParsingHelper.parseStringMethod(json["SkinID"]);
    SampleContentLink = ParsingHelper.parseStringMethod(json["SampleContentLink"]);
    isBadCancellationEnabled = ParsingHelper.parseBoolMethod(json["isBadCancellationEnabled"]);
    isContentEnrolled = ParsingHelper.parseBoolMethod(json["isContentEnrolled"]);
    isBookingOpened = ParsingHelper.parseBoolMethod(json["isBookingOpened"]);
    isShowEventFullStatus = ParsingHelper.parseBoolMethod(json["isShowEventFullStatus"]);
    IsSuccess = ParsingHelper.parseBoolMethod(json["IsSuccess"]);
    NoRecord = ParsingHelper.parseBoolMethod(json["NoRecord"]);
    IsArchived = ParsingHelper.parseBoolMethod(json["IsArchived"]);
    showSchedule = ParsingHelper.parseBoolMethod(json["showSchedule"]);
    IsViewReview = ParsingHelper.parseBoolMethod(json["IsViewReview"]);
    percentagecompleted = ParsingHelper.parseDoubleMethod(json['percentagecompleted']);

    Map<String, dynamic> recordingDetailsMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(json['RecordingDetails']);
    if(recordingDetailsMap.isNotEmpty) recordingDetails = EventRecordingDetailsModel.fromMap(recordingDetailsMap);
  }

  Map<String, dynamic> toJson() {
    return super.toMap()..addAll(<String, dynamic>{
      "strCatalogContentRemoved": strCatalogContentRemoved,
      "Presentername": Presentername,
      "PresenterLink": PresenterLink,
      "DirectionURL": DirectionURL,
      "LongDescription": LongDescription,
      "ErrorMesage": ErrorMesage,
      "AddLink": AddLink,
      "CancelEventlink": CancelEventlink,
      "EnrollNowLink": EnrollNowLink,
      "DownloadCalender": DownloadCalender,
      "titleExpired": titleExpired,
      "AddPastLink": AddPastLink,
      "EventScheduleLink": EventScheduleLink,
      "EventScheduleStatus": EventScheduleStatus,
      "EventScheduleConfirmLink": EventScheduleConfirmLink,
      "EventScheduleCancelLink": EventScheduleCancelLink,
      "EventScheduleReserveTime": EventScheduleReserveTime,
      "EventScheduleReserveStatus": EventScheduleReserveStatus,
      "ReScheduleEvent": ReScheduleEvent,
      "Addorremoveattendees": Addorremoveattendees,
      "CancelScheduleEvent": CancelScheduleEvent,
      "ShowReadMore": ShowReadMore,
      "SetCompleteAction": SetCompleteAction,
      "TitleName": TitleName,
      "UserProfileImagePath": UserProfileImagePath,
      "TitleWithlink": TitleWithlink,
      "ImageWithlink": ImageWithlink,
      "ShowThumbnailImagePath": ShowThumbnailImagePath,
      "CertificateLink": CertificateLink,
      "SurveyLink": SurveyLink,
      "NotesLink": NotesLink,
      "WaitListLink": WaitListLink,
      "ShowParentPrerequisiteEventDate": ShowParentPrerequisiteEventDate,
      "ShowPrerequisiteEventDate": ShowPrerequisiteEventDate,
      "DiscussionsLink": DiscussionsLink,
      "ContentViewType": ContentViewType,
      "WindowProperties": WindowProperties,
      "AutolaunchViewLink": AutolaunchViewLink,
      "TitleViewlink": TitleViewlink,
      "NotifyMessage": NotifyMessage,
      "LearningObjectives": LearningObjectives,
      "TableofContent": TableofContent,
      "ThumbnailVideoPath": ThumbnailVideoPath,
      "SubTitleTag": SubTitleTag,
      "islearningcontent": islearningcontent,
      "RedirectinstanceID": RedirectinstanceID,
      "Duration": Duration,
      "ActionViewQRcode": ActionViewQRcode,
      "EnrollmentLimit": EnrollmentLimit,
      "AvailableSeats": AvailableSeats,
      "NoofUsersEnrolled": NoofUsersEnrolled,
      "WaitListLimit": WaitListLimit,
      "WaitListEnrolls": WaitListEnrolls,
      "DownloadLink": DownloadLink,
      "TypeofEvent": TypeofEvent,
      "jwstartpage": jwstartpage,
      "QRImageName": QRImageName,
      "FontColor": FontColor,
      "SkinID": SkinID,
      "SampleContentLink": SampleContentLink,
      "isBadCancellationEnabled": isBadCancellationEnabled,
      "isContentEnrolled": isContentEnrolled,
      "isBookingOpened": isBookingOpened,
      "isShowEventFullStatus": isShowEventFullStatus,
      "IsSuccess": IsSuccess,
      "NoRecord": NoRecord,
      "IsArchived": IsArchived,
      "showSchedule": showSchedule,
      "IsViewReview": IsViewReview,
      "percentagecompleted": percentagecompleted,
      "RecordingDetails": recordingDetails?.toMap(),
    });
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }

  bool hasPrerequisiteContents() {
    return AppConfigurationOperations.hasPrerequisiteContents(AddLink);
  }
}