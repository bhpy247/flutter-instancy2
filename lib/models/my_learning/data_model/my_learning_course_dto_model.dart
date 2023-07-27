import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../../utils/my_utils.dart';
import '../../classroom_events/data_model/EventRecordingDetailsModel.dart';

class MyLearningCourseDTOModel extends CourseDTOModel {
  String Expired = "";
  String ReportLink = "";
  String DiscussionsLink = "";
  String CertificateLink = "";
  String NotesLink = "";
  String CancelEventLink = "";
  String DownLoadLink = "";
  String RepurchaseLink = "";
  String SetcompleteLink = "";
  String ViewRecordingLink = "";
  String InstructorCommentsLink = "";
  String DownloadCalender = "";
  String EventScheduleLink = "";
  String EventScheduleStatus = "";
  String EventScheduleConfirmLink = "";
  String EventScheduleCancelLink = "";
  String EventScheduleReserveTime = "";
  String EventScheduleReserveStatus = "";
  String ReScheduleEvent = "";
  String Addorremoveattendees = "";
  String CancelScheduleEvent = "";
  String SurveyLink = "";
  String RemoveLink = "";
  String RatingLink = "";
  String PracticeAssessmentsAction = "";
  String CreateAssessmentAction = "";
  String OverallProgressReportAction = "";
  String EditLink = "";
  String TitleName = "";
  String WindowProperties = "";
  String CancelOrderData = "";
  String Duration = "";
  String Credits = "";
  String DetailspopupTags = "";
  String Modules = "";
  String ActionViewQRcode = "";
  String EnrollmentLimit = "";
  String AvailableSeats = "";
  String NoofUsersEnrolled = "";
  String WaitListLimit = "";
  String WaitListEnrolls = "";
  String SkinID = "";
  int AttemptsLeft = 0;
  int Required = 0;
  int TypeofEvent = 0;
  bool isBadCancellationEnabled = false;
  bool CombinedTransaction = false;
  bool IsViewReview = false;
  bool IsArchived = false;
  bool isBookingOpened = false;
  bool SubSiteMemberShipExpiried = false;
  bool ShowLearnerActions = false;
  EventRecordingDetailsModel? RecordingDetails;

  MyLearningCourseDTOModel({
    this.Expired = "",
    this.ReportLink = "",
    this.DiscussionsLink = "",
    this.CertificateLink = "",
    this.NotesLink = "",
    this.CancelEventLink = "",
    this.DownLoadLink = "",
    this.RepurchaseLink = "",
    this.SetcompleteLink = "",
    this.ViewRecordingLink = "",
    this.InstructorCommentsLink = "",
    this.DownloadCalender = "",
    this.EventScheduleLink = "",
    this.EventScheduleStatus = "",
    this.EventScheduleConfirmLink = "",
    this.EventScheduleCancelLink = "",
    this.EventScheduleReserveTime = "",
    this.EventScheduleReserveStatus = "",
    this.ReScheduleEvent = "",
    this.Addorremoveattendees = "",
    this.CancelScheduleEvent = "",
    this.SurveyLink = "",
    this.RemoveLink = "",
    this.RatingLink = "",
    this.PracticeAssessmentsAction = "",
    this.CreateAssessmentAction = "",
    this.OverallProgressReportAction = "",
    this.EditLink = "",
    this.TitleName = "",
    this.WindowProperties = "",
    this.CancelOrderData = "",
    this.Duration = "",
    this.Credits = "",
    this.DetailspopupTags = "",
    this.Modules = "",
    this.ActionViewQRcode = "",
    this.EnrollmentLimit = "",
    this.AvailableSeats = "",
    this.NoofUsersEnrolled = "",
    this.WaitListLimit = "",
    this.WaitListEnrolls = "",
    this.SkinID = "",
    this.AttemptsLeft = 0,
    this.Required = 0,
    this.TypeofEvent = 0,
    this.isBadCancellationEnabled = false,
    this.CombinedTransaction = false,
    this.IsViewReview = false,
    this.IsArchived = false,
    this.isBookingOpened = false,
    this.SubSiteMemberShipExpiried = false,
    this.ShowLearnerActions = false,
    this.RecordingDetails,
  });

  MyLearningCourseDTOModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    super.updateFromMap(map);

    Expired = ParsingHelper.parseStringMethod(map["Expired"]);
    ReportLink = ParsingHelper.parseStringMethod(map["ReportLink"]);
    DiscussionsLink = ParsingHelper.parseStringMethod(map["DiscussionsLink"]);
    CertificateLink = ParsingHelper.parseStringMethod(map["CertificateLink"]);
    NotesLink = ParsingHelper.parseStringMethod(map["NotesLink"]);
    CancelEventLink = ParsingHelper.parseStringMethod(map["CancelEventLink"]);
    DownLoadLink = ParsingHelper.parseStringMethod(map["DownLoadLink"]);
    RepurchaseLink = ParsingHelper.parseStringMethod(map["RepurchaseLink"]);
    SetcompleteLink = ParsingHelper.parseStringMethod(map["SetcompleteLink"]);
    ViewRecordingLink = ParsingHelper.parseStringMethod(map["ViewRecordingLink"]);
    InstructorCommentsLink = ParsingHelper.parseStringMethod(map["InstructorCommentsLink"]);
    DownloadCalender = ParsingHelper.parseStringMethod(map["DownloadCalender"]);
    EventScheduleLink = ParsingHelper.parseStringMethod(map["EventScheduleLink"]);
    EventScheduleStatus = ParsingHelper.parseStringMethod(map["EventScheduleStatus"]);
    EventScheduleConfirmLink = ParsingHelper.parseStringMethod(map["EventScheduleConfirmLink"]);
    EventScheduleCancelLink = ParsingHelper.parseStringMethod(map["EventScheduleCancelLink"]);
    EventScheduleReserveTime = ParsingHelper.parseStringMethod(map["EventScheduleReserveTime"]);
    EventScheduleReserveStatus = ParsingHelper.parseStringMethod(map["EventScheduleReserveStatus"]);
    ReScheduleEvent = ParsingHelper.parseStringMethod(map["ReScheduleEvent"]);
    Addorremoveattendees = ParsingHelper.parseStringMethod(map["Addorremoveattendees"]);
    CancelScheduleEvent = ParsingHelper.parseStringMethod(map["CancelScheduleEvent"]);
    SurveyLink = ParsingHelper.parseStringMethod(map["SurveyLink"]);
    RemoveLink = ParsingHelper.parseStringMethod(map["RemoveLink"]);
    RatingLink = ParsingHelper.parseStringMethod(map["RatingLink"]);
    PracticeAssessmentsAction = ParsingHelper.parseStringMethod(map["PracticeAssessmentsAction"]);
    CreateAssessmentAction = ParsingHelper.parseStringMethod(map["CreateAssessmentAction"]);
    OverallProgressReportAction = ParsingHelper.parseStringMethod(map["OverallProgressReportAction"]);
    EditLink = ParsingHelper.parseStringMethod(map["EditLink"]);
    TitleName = ParsingHelper.parseStringMethod(map["TitleName"]);
    WindowProperties = ParsingHelper.parseStringMethod(map["WindowProperties"]);
    CancelOrderData = ParsingHelper.parseStringMethod(map["CancelOrderData"]);
    Duration = ParsingHelper.parseStringMethod(map["Duration"]);
    Credits = ParsingHelper.parseStringMethod(map["Credits"]);
    DetailspopupTags = ParsingHelper.parseStringMethod(map["DetailspopupTags"]);
    Modules = ParsingHelper.parseStringMethod(map["Modules"]);
    ActionViewQRcode = ParsingHelper.parseStringMethod(map["ActionViewQRcode"]);
    EnrollmentLimit = ParsingHelper.parseStringMethod(map["EnrollmentLimit"]);
    AvailableSeats = ParsingHelper.parseStringMethod(map["AvailableSeats"]);
    NoofUsersEnrolled = ParsingHelper.parseStringMethod(map["NoofUsersEnrolled"]);
    WaitListLimit = ParsingHelper.parseStringMethod(map["WaitListLimit"]);
    WaitListEnrolls = ParsingHelper.parseStringMethod(map["WaitListEnrolls"]);
    SkinID = ParsingHelper.parseStringMethod(map["SkinID"]);
    AttemptsLeft = ParsingHelper.parseIntMethod(map["AttemptsLeft"]);
    Required = ParsingHelper.parseIntMethod(map["Required"]);
    TypeofEvent = ParsingHelper.parseIntMethod(map["TypeofEvent"]);
    isBadCancellationEnabled = ParsingHelper.parseBoolMethod(map["isBadCancellationEnabled"]);
    CombinedTransaction = ParsingHelper.parseBoolMethod(map["CombinedTransaction"]);
    IsViewReview = ParsingHelper.parseBoolMethod(map["IsViewReview"]);
    IsArchived = ParsingHelper.parseBoolMethod(map["IsArchived"]);
    isBookingOpened = ParsingHelper.parseBoolMethod(map["isBookingOpened"]);
    SubSiteMemberShipExpiried = ParsingHelper.parseBoolMethod(map["SubSiteMemberShipExpiried"]);
    ShowLearnerActions = ParsingHelper.parseBoolMethod(map["ShowLearnerActions"]);

    Map<String, dynamic> recordingDetailsMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(map['RecordingDetails']);
    if(recordingDetailsMap.isNotEmpty) RecordingDetails = EventRecordingDetailsModel.fromMap(recordingDetailsMap);
  }

  Map<String, dynamic> toMap() {
    return super.toMap()..addAll(<String, dynamic>{
      "Expired": Expired,
      "ReportLink": ReportLink,
      "DiscussionsLink": DiscussionsLink,
      "CertificateLink": CertificateLink,
      "NotesLink": NotesLink,
      "CancelEventLink": CancelEventLink,
      "DownLoadLink": DownLoadLink,
      "RepurchaseLink": RepurchaseLink,
      "SetcompleteLink": SetcompleteLink,
      "ViewRecordingLink": ViewRecordingLink,
      "InstructorCommentsLink": InstructorCommentsLink,
      "DownloadCalender": DownloadCalender,
      "EventScheduleLink": EventScheduleLink,
      "EventScheduleStatus": EventScheduleStatus,
      "EventScheduleConfirmLink": EventScheduleConfirmLink,
      "EventScheduleCancelLink": EventScheduleCancelLink,
      "EventScheduleReserveTime": EventScheduleReserveTime,
      "EventScheduleReserveStatus": EventScheduleReserveStatus,
      "ReScheduleEvent": ReScheduleEvent,
      "Addorremoveattendees": Addorremoveattendees,
      "CancelScheduleEvent": CancelScheduleEvent,
      "SurveyLink": SurveyLink,
      "RemoveLink": RemoveLink,
      "RatingLink": RatingLink,
      "PracticeAssessmentsAction": PracticeAssessmentsAction,
      "CreateAssessmentAction": CreateAssessmentAction,
      "OverallProgressReportAction": OverallProgressReportAction,
      "EditLink": EditLink,
      "TitleName": TitleName,
      "WindowProperties": WindowProperties,
      "CancelOrderData": CancelOrderData,
      "Duration": Duration,
      "Credits": Credits,
      "InstanceEventEnroll": InstanceEventEnroll,
      "Modules": Modules,
      "ActionViewQRcode": ActionViewQRcode,
      "EnrollmentLimit": EnrollmentLimit,
      "AvailableSeats": AvailableSeats,
      "NoofUsersEnrolled": NoofUsersEnrolled,
      "WaitListLimit": WaitListLimit,
      "WaitListEnrolls": WaitListEnrolls,
      "SkinID": SkinID,
      "AttemptsLeft": AttemptsLeft,
      "Required": Required,
      "TypeofEvent": TypeofEvent,
      "isBadCancellationEnabled": isBadCancellationEnabled,
      "CombinedTransaction": CombinedTransaction,
      "IsViewReview": IsViewReview,
      "IsArchived": IsArchived,
      "isBookingOpened": isBookingOpened,
      "SubSiteMemberShipExpiried": SubSiteMemberShipExpiried,
      "ShowLearnerActions": ShowLearnerActions,
      "recordingDetails": RecordingDetails?.toMap(),
    });
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}