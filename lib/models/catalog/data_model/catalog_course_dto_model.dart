import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';

import '../../../backend/configurations/app_configuration_operations.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class CatalogCourseDTOModel extends CourseDTOModel {
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
  String EditMetadataLink = "";
  String ReplaceLink = "";
  String EditLink = "";
  String DeleteLink = "";
  String SampleContentLink = "";
  String TitleExpired = "";
  String PracticeAssessmentsAction = "";
  String CreateAssessmentAction = "";
  String OverallProgressReportAction = "";
  String ContentScoID = "";
  String ContentViewType = "";
  String WindowProperties = "";
  String AddtoWishList = "";
  String RemoveFromWishList = "";
  String Duration = "";
  String Credits = "";
  String DetailspopupTags = "";
  String Modules = "";
  String EnrollmentLimit = "";
  String AvailableSeats = "";
  String NoofUsersEnrolled = "";
  String WaitListLimit = "";
  String WaitListEnrolls = "";
  String EventStartDateforEnroll = "";
  String DownLoadLink = "";
  String PrerequisiteDateConflictName = "";
  String PrerequisiteDateConflictDateTime = "";
  String isContentEnrolled = "";
  String SkinID = "";
  int Count = 0;
  int isWishListContent = 0;
  bool isBadCancellationEnabled = false;
  bool isBookingOpened = false;
  bool EventRecording = false;
  bool ShowParentPrerequisiteEventDate = false;
  bool ShowPrerequisiteEventDate = false;

  CatalogCourseDTOModel({
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
    this.EditMetadataLink = "",
    this.ReplaceLink = "",
    this.EditLink = "",
    this.DeleteLink = "",
    this.SampleContentLink = "",
    this.TitleExpired = "",
    this.PracticeAssessmentsAction = "",
    this.CreateAssessmentAction = "",
    this.OverallProgressReportAction = "",
    this.ContentScoID = "",
    this.ContentViewType = "",
    this.WindowProperties = "",
    this.AddtoWishList = "",
    this.RemoveFromWishList = "",
    this.Duration = "",
    this.Credits = "",
    this.DetailspopupTags = "",
    this.Modules = "",
    this.EnrollmentLimit = "",
    this.AvailableSeats = "",
    this.NoofUsersEnrolled = "",
    this.WaitListLimit = "",
    this.WaitListEnrolls = "",
    this.EventStartDateforEnroll = "",
    this.DownLoadLink = "",
    this.PrerequisiteDateConflictName = "",
    this.PrerequisiteDateConflictDateTime = "",
    this.SkinID = "",
    this.isContentEnrolled = "",
    this.Count = 0,
    this.isWishListContent = 0,
    this.isBadCancellationEnabled = false,
    this.isBookingOpened = false,
    this.EventRecording = false,
    this.ShowParentPrerequisiteEventDate = false,
    this.ShowPrerequisiteEventDate = false,
  });

  CatalogCourseDTOModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    super.updateFromMap(map);

    Titlewithlink = ParsingHelper.parseStringMethod(map['Titlewithlink']);
    rcaction = ParsingHelper.parseStringMethod(map['rcaction']);
    Categories = ParsingHelper.parseStringMethod(map['Categories']);
    IsSubSite = ParsingHelper.parseStringMethod(map['IsSubSite']);
    MembershipName = ParsingHelper.parseStringMethod(map['MembershipName']);
    EventAvailableSeats = ParsingHelper.parseStringMethod(map['EventAvailableSeats']);
    EventCompletedProgress = ParsingHelper.parseStringMethod(map['EventCompletedProgress']);
    EventContentProgress = ParsingHelper.parseStringMethod(map['EventContentProgress']);
    PreviewLink = ParsingHelper.parseStringMethod(map['PreviewLink']);
    ApproveLink = ParsingHelper.parseStringMethod(map['ApproveLink']);
    RejectLink = ParsingHelper.parseStringMethod(map['RejectLink']);
    ReadLink = ParsingHelper.parseStringMethod(map['ReadLink']);
    AddLink = ParsingHelper.parseStringMethod(map['AddLink']);
    EnrollNowLink = ParsingHelper.parseStringMethod(map['EnrollNowLink']);
    CancelEventLink = ParsingHelper.parseStringMethod(map['CancelEventLink']);
    WaitListLink = ParsingHelper.parseStringMethod(map['WaitListLink']);
    InapppurchageLink = ParsingHelper.parseStringMethod(map['InapppurchageLink']);
    AlredyinmylearnigLink = ParsingHelper.parseStringMethod(map['AlredyinmylearnigLink']);
    RecommendedLink = ParsingHelper.parseStringMethod(map['RecommendedLink']);
    EditMetadataLink = ParsingHelper.parseStringMethod(map['EditMetadataLink']);
    ReplaceLink = ParsingHelper.parseStringMethod(map['ReplaceLink']);
    EditLink = ParsingHelper.parseStringMethod(map['EditLink']);
    DeleteLink = ParsingHelper.parseStringMethod(map['DeleteLink']);
    SampleContentLink = ParsingHelper.parseStringMethod(map['SampleContentLink']);
    TitleExpired = ParsingHelper.parseStringMethod(map['TitleExpired']);
    PracticeAssessmentsAction = ParsingHelper.parseStringMethod(map['PracticeAssessmentsAction']);
    CreateAssessmentAction = ParsingHelper.parseStringMethod(map['CreateAssessmentAction']);
    OverallProgressReportAction = ParsingHelper.parseStringMethod(map['OverallProgressReportAction']);
    ContentScoID = ParsingHelper.parseStringMethod(map['ContentScoID']);
    ContentViewType = ParsingHelper.parseStringMethod(map['ContentViewType']);
    WindowProperties = ParsingHelper.parseStringMethod(map['WindowProperties']);
    AddtoWishList = ParsingHelper.parseStringMethod(map['AddtoWishList']);
    RemoveFromWishList = ParsingHelper.parseStringMethod(map['RemoveFromWishList']);
    Duration = ParsingHelper.parseStringMethod(map['Duration']);
    Credits = ParsingHelper.parseStringMethod(map['Credits']);
    DetailspopupTags = ParsingHelper.parseStringMethod(map['DetailspopupTags']);
    Modules = ParsingHelper.parseStringMethod(map['Modules']);
    EnrollmentLimit = ParsingHelper.parseStringMethod(map['EnrollmentLimit']);
    AvailableSeats = ParsingHelper.parseStringMethod(map['AvailableSeats']);
    NoofUsersEnrolled = ParsingHelper.parseStringMethod(map['NoofUsersEnrolled']);
    WaitListLimit = ParsingHelper.parseStringMethod(map['WaitListLimit']);
    WaitListEnrolls = ParsingHelper.parseStringMethod(map['WaitListEnrolls']);
    EventStartDateforEnroll = ParsingHelper.parseStringMethod(map['EventStartDateforEnroll']);
    DownLoadLink = ParsingHelper.parseStringMethod(map['DownLoadLink']);
    PrerequisiteDateConflictName = ParsingHelper.parseStringMethod(map['PrerequisiteDateConflictName']);
    PrerequisiteDateConflictDateTime = ParsingHelper.parseStringMethod(map['PrerequisiteDateConflictDateTime']);
    SkinID = ParsingHelper.parseStringMethod(map['SkinID']);
    isContentEnrolled = ParsingHelper.parseStringMethod(map['isContentEnrolled']);
    Count = ParsingHelper.parseIntMethod(map['Count']);
    isWishListContent = ParsingHelper.parseIntMethod(map['isWishListContent']);
    isBadCancellationEnabled = ParsingHelper.parseBoolMethod(map['isBadCancellationEnabled']);
    isBookingOpened = ParsingHelper.parseBoolMethod(map['isBookingOpened']);
    EventRecording = ParsingHelper.parseBoolMethod(map['EventRecording']);
    ShowParentPrerequisiteEventDate = ParsingHelper.parseBoolMethod(map['ShowParentPrerequisiteEventDate']);
    ShowPrerequisiteEventDate = ParsingHelper.parseBoolMethod(map['ShowPrerequisiteEventDate']);
  }

  Map<String, dynamic> toMap() {
    return super.toMap()..addAll(<String, dynamic>{
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
      "EditMetadataLink": EditMetadataLink,
      "ReplaceLink": ReplaceLink,
      "EditLink": EditLink,
      "DeleteLink": DeleteLink,
      "SampleContentLink": SampleContentLink,
      "TitleExpired": TitleExpired,
      "PracticeAssessmentsAction": PracticeAssessmentsAction,
      "CreateAssessmentAction": CreateAssessmentAction,
      "OverallProgressReportAction": OverallProgressReportAction,
      "ContentScoID": ContentScoID,
      "ContentViewType": ContentViewType,
      "WindowProperties": WindowProperties,
      "AddtoWishList": AddtoWishList,
      "RemoveFromWishList": RemoveFromWishList,
      "Duration": Duration,
      "Credits": Credits,
      "DetailspopupTags": DetailspopupTags,
      "Modules": Modules,
      "EnrollmentLimit": EnrollmentLimit,
      "AvailableSeats": AvailableSeats,
      "NoofUsersEnrolled": NoofUsersEnrolled,
      "WaitListLimit": WaitListLimit,
      "WaitListEnrolls": WaitListEnrolls,
      "EventStartDateforEnroll": EventStartDateforEnroll,
      "DownLoadLink": DownLoadLink,
      "PrerequisiteDateConflictName": PrerequisiteDateConflictName,
      "PrerequisiteDateConflictDateTime": PrerequisiteDateConflictDateTime,
      "SkinID": SkinID,
      "isContentEnrolled": isContentEnrolled,
      "Count": Count,
      "isWishListContent": isWishListContent,
      "isBadCancellationEnabled": isBadCancellationEnabled,
      "isBookingOpened": isBookingOpened,
      "EventRecording": EventRecording,
      "ShowParentPrerequisiteEventDate": ShowParentPrerequisiteEventDate,
      "ShowPrerequisiteEventDate": ShowPrerequisiteEventDate,
    });
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }

  bool hasPrerequisiteContents() {
    return AppConfigurationOperations.hasPrerequisiteContents(AddLink);
  }
}