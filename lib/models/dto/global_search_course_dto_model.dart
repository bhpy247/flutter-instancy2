import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';

import '../../utils/my_utils.dart';
import '../../utils/parsing_helper.dart';

class GlobalSearchCourseDTOModel extends CourseDTOModel {
  String NamePreFix = "";
  String EventAvailableSeats = "";
  String EventContentProgress = "";
  String DestinationLink = "";
  String AddLink = "";
  String CancelEventLink = "";
  String EnrollLink = "";
  String WaitListLink = "";
  String RecommendedLink = "";
  String LongDescription = "";
  String StartPage = "";
  String ParticipantURL = "";
  String PublishedDate = "";
  String ItunesProductID = "";
  String SiteURL = "";
  String MembershipName = "";
  String TitleExpired = "";
  String ViewProfileLink = "";
  String NoImageText = "";
  String ContentViewType = "";
  String WindowProperties = "";
  String DownLoadLink = "";
  String EnrollmentLimit = "";
  String AvailableSeats = "";
  String NoofUsersEnrolled = "";
  String WaitListLimit = "";
  String WaitListEnrolls = "";
  String SkinID = "";
  bool isBadCancellationEnabled = false;
  bool isContentEnrolled = false;
  bool ListView = false;
  bool isBookingOpened = false;
  bool EventRecording = false;

  GlobalSearchCourseDTOModel({
    this.NamePreFix = "",
    this.EventAvailableSeats = "",
    this.EventContentProgress = "",
    this.DestinationLink = "",
    this.AddLink = "",
    this.CancelEventLink = "",
    this.EnrollLink = "",
    this.WaitListLink = "",
    this.RecommendedLink = "",
    this.LongDescription = "",
    this.StartPage = "",
    this.ParticipantURL = "",
    this.PublishedDate = "",
    this.ItunesProductID = "",
    this.SiteURL = "",
    this.MembershipName = "",
    this.TitleExpired = "",
    this.ViewProfileLink = "",
    this.NoImageText = "",
    this.ContentViewType = "",
    this.WindowProperties = "",
    this.DownLoadLink = "",
    this.EnrollmentLimit = "",
    this.AvailableSeats = "",
    this.NoofUsersEnrolled = "",
    this.WaitListLimit = "",
    this.WaitListEnrolls = "",
    this.SkinID = "",
    this.isBadCancellationEnabled = false,
    this.isContentEnrolled = false,
    this.ListView = false,
    this.isBookingOpened = false,
    this.EventRecording = false,
  });

  GlobalSearchCourseDTOModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    super.updateFromMap(map);

    NamePreFix = ParsingHelper.parseStringMethod(map["NamePreFix"]);
    EventAvailableSeats = ParsingHelper.parseStringMethod(map["EventAvailableSeats"]);
    EventContentProgress = ParsingHelper.parseStringMethod(map["EventContentProgress"]);
    DestinationLink = ParsingHelper.parseStringMethod(map["DestinationLink"]);
    AddLink = ParsingHelper.parseStringMethod(map["AddLink"]);
    CancelEventLink = ParsingHelper.parseStringMethod(map["CancelEventLink"]);
    EnrollLink = ParsingHelper.parseStringMethod(map["EnrollLink"]);
    WaitListLink = ParsingHelper.parseStringMethod(map["WaitListLink"]);
    RecommendedLink = ParsingHelper.parseStringMethod(map["RecommendedLink"]);
    LongDescription = ParsingHelper.parseStringMethod(map["LongDescription"]);
    StartPage = ParsingHelper.parseStringMethod(map["StartPage"]);
    ParticipantURL = ParsingHelper.parseStringMethod(map["ParticipantURL"]);
    PublishedDate = ParsingHelper.parseStringMethod(map["PublishedDate"]);
    ItunesProductID = ParsingHelper.parseStringMethod(map["ItunesProductID"]);
    SiteURL = ParsingHelper.parseStringMethod(map["SiteURL"]);
    MembershipName = ParsingHelper.parseStringMethod(map["MembershipName"]);
    TitleExpired = ParsingHelper.parseStringMethod(map["TitleExpired"]);
    ViewProfileLink = ParsingHelper.parseStringMethod(map["ViewProfileLink"]);
    NoImageText = ParsingHelper.parseStringMethod(map["NoImageText"]);
    ContentViewType = ParsingHelper.parseStringMethod(map["ContentViewType"]);
    WindowProperties = ParsingHelper.parseStringMethod(map["WindowProperties"]);
    DownLoadLink = ParsingHelper.parseStringMethod(map["DownLoadLink"]);
    EnrollmentLimit = ParsingHelper.parseStringMethod(map["EnrollmentLimit"]);
    AvailableSeats = ParsingHelper.parseStringMethod(map["AvailableSeats"]);
    NoofUsersEnrolled = ParsingHelper.parseStringMethod(map["NoofUsersEnrolled"]);
    WaitListLimit = ParsingHelper.parseStringMethod(map["WaitListLimit"]);
    WaitListEnrolls = ParsingHelper.parseStringMethod(map["WaitListEnrolls"]);
    SkinID = ParsingHelper.parseStringMethod(map["SkinID"]);
    isBadCancellationEnabled = ParsingHelper.parseBoolMethod(map["isBadCancellationEnabled"]);
    isContentEnrolled = ParsingHelper.parseBoolMethod(map["isContentEnrolled"]);
    ListView = ParsingHelper.parseBoolMethod(map["ListView"]);
    isBookingOpened = ParsingHelper.parseBoolMethod(map["isBookingOpened"]);
    EventRecording = ParsingHelper.parseBoolMethod(map["EventRecording"]);
  }

  Map<String, dynamic> toMap() {
    return super.toMap()..addAll(<String, dynamic>{
      "NamePreFix": NamePreFix,
      "EventAvailableSeats": EventAvailableSeats,
      "EventContentProgress": EventContentProgress,
      "DestinationLink": DestinationLink,
      "AddLink": AddLink,
      "CancelEventLink": CancelEventLink,
      "EnrollLink": EnrollLink,
      "WaitListLink": WaitListLink,
      "RecommendedLink": RecommendedLink,
      "LongDescription": LongDescription,
      "StartPage": StartPage,
      "ParticipantURL": ParticipantURL,
      "PublishedDate": PublishedDate,
      "ItunesProductID": ItunesProductID,
      "SiteURL": SiteURL,
      "MembershipName": MembershipName,
      "TitleExpired": TitleExpired,
      "ViewProfileLink": ViewProfileLink,
      "NoImageText": NoImageText,
      "ContentViewType": ContentViewType,
      "WindowProperties": WindowProperties,
      "DownLoadLink": DownLoadLink,
      "EnrollmentLimit": EnrollmentLimit,
      "AvailableSeats": AvailableSeats,
      "NoofUsersEnrolled": NoofUsersEnrolled,
      "WaitListLimit": WaitListLimit,
      "WaitListEnrolls": WaitListEnrolls,
      "SkinID": SkinID,
      "isBadCancellationEnabled": isBadCancellationEnabled,
      "isContentEnrolled": isContentEnrolled,
      "ListView": ListView,
      "isBookingOpened": isBookingOpened,
      "EventRecording": EventRecording,
    });
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }

  bool hasRelatedContents() {
    return AddLink.startsWith("addrecommenedrelatedcontent");
  }
}