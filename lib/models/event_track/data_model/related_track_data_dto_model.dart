import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class RelatedTrackDataDTOModel {
  String ActionViewQRcode = "";
  String ActivityId = "";
  String ContentType = "";
  String Name = "";
  String Status = "";
  String CreatedDate = "";
  String EventStartDateTime = "";
  String EventEndDateTime = "";
  String AuthorWithLink = "";
  String ShortDescription = "";
  String ThumbnailImagePath = "";
  String DetailsLink = "";
  String ViewLink = "";
  String SetcompleteLink = "";
  String ContentID = "";
  String ContentStatus = "";
  String Duration = "";
  String IsHide = "";
  String IsDisable = "";
  String Delete = "";
  String TotalRatings = "";
  String PercentCompletedClass = "";
  String AuthorName = "";
  String WindowProperties = "";
  String ThumbnailIconPath = "";
  String JWVideoKey = "";
  String DownloadLink = "";
  String ShareContentwithUser = "";
  String ExpiredContentAvailableUntill = "";
  String ExpiredContentExpiryDate = "";
  String CoreLessonStatus = "";
  String ContentDisplayStatus = "";
  String FolderPath = "";
  String jwstartpage = "";
  String startpage = "";
  String ContentModifiedDateTime = "";
  int ScoID = 0;
  int UserID = 0;
  int SiteID = 0;
  int ContentTypeId = 0;
  int MediaTypeID = 0;
  int ViewType = 0;
  double PercentCompleted = 0;
  bool bit1 = false;
  bool bit5 = false;

  RelatedTrackDataDTOModel({
    this.ActionViewQRcode = "",
    this.ActivityId = "",
    this.ContentType = "",
    this.Name = "",
    this.Status = "",
    this.CreatedDate = "",
    this.EventStartDateTime = "",
    this.EventEndDateTime = "",
    this.AuthorWithLink = "",
    this.ShortDescription = "",
    this.ThumbnailImagePath = "",
    this.DetailsLink = "",
    this.ViewLink = "",
    this.SetcompleteLink = "",
    this.ContentID = "",
    this.ContentStatus = "",
    this.Duration = "",
    this.IsHide = "",
    this.IsDisable = "",
    this.Delete = "",
    this.TotalRatings = "",
    this.PercentCompletedClass = "",
    this.AuthorName = "",
    this.WindowProperties = "",
    this.ThumbnailIconPath = "",
    this.JWVideoKey = "",
    this.DownloadLink = "",
    this.ShareContentwithUser = "",
    this.ExpiredContentAvailableUntill = "",
    this.ExpiredContentExpiryDate = "",
    this.CoreLessonStatus = "",
    this.ContentDisplayStatus = "",
    this.FolderPath = "",
    this.jwstartpage = "",
    this.startpage = "",
    this.ContentModifiedDateTime = "",
    this.ScoID = 0,
    this.UserID = 0,
    this.SiteID = 0,
    this.ContentTypeId = 0,
    this.MediaTypeID = 0,
    this.ViewType = 0,
    this.PercentCompleted = 0,
    this.bit1 = false,
    this.bit5 = false,
  });

  RelatedTrackDataDTOModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    ActionViewQRcode = ParsingHelper.parseStringMethod(map["ActionViewQRcode"]);
    ActivityId = ParsingHelper.parseStringMethod(map["ActivityId"]);
    ContentType = ParsingHelper.parseStringMethod(map["ContentType"]);
    Name = ParsingHelper.parseStringMethod(map["Name"]);
    Status = ParsingHelper.parseStringMethod(map["Status"]);
    CreatedDate = ParsingHelper.parseStringMethod(map["CreatedDate"]);
    EventStartDateTime = ParsingHelper.parseStringMethod(map["EventStartDateTime"]);
    EventEndDateTime = ParsingHelper.parseStringMethod(map["EventEndDateTime"]);
    AuthorWithLink = ParsingHelper.parseStringMethod(map["AuthorWithLink"]);
    ShortDescription = ParsingHelper.parseStringMethod(map["ShortDescription"]);
    ThumbnailImagePath = ParsingHelper.parseStringMethod(map["ThumbnailImagePath"]);
    DetailsLink = ParsingHelper.parseStringMethod(map["DetailsLink"]);
    ViewLink = ParsingHelper.parseStringMethod(map["ViewLink"]);
    SetcompleteLink = ParsingHelper.parseStringMethod(map["SetcompleteLink"]);
    ContentID = ParsingHelper.parseStringMethod(map["ContentID"]);
    ContentStatus = ParsingHelper.parseStringMethod(map["ContentStatus"]);
    Duration = ParsingHelper.parseStringMethod(map["Duration"]);
    IsHide = ParsingHelper.parseStringMethod(map["IsHide"]);
    IsDisable = ParsingHelper.parseStringMethod(map["IsDisable"]);
    Delete = ParsingHelper.parseStringMethod(map["Delete"]);
    TotalRatings = ParsingHelper.parseStringMethod(map["TotalRatings"]);
    PercentCompletedClass = ParsingHelper.parseStringMethod(map["PercentCompletedClass"]);
    AuthorName = ParsingHelper.parseStringMethod(map["AuthorName"]);
    WindowProperties = ParsingHelper.parseStringMethod(map["WindowProperties"]);
    ThumbnailIconPath = ParsingHelper.parseStringMethod(map["ThumbnailIconPath"]);
    JWVideoKey = ParsingHelper.parseStringMethod(map["JWVideoKey"]);
    DownloadLink = ParsingHelper.parseStringMethod(map["DownloadLink"]);
    ShareContentwithUser = ParsingHelper.parseStringMethod(map["ShareContentwithUser"]);
    ExpiredContentAvailableUntill = ParsingHelper.parseStringMethod(map["ExpiredContentAvailableUntill"]);
    ExpiredContentExpiryDate = ParsingHelper.parseStringMethod(map["ExpiredContentExpiryDate"]);
    CoreLessonStatus = ParsingHelper.parseStringMethod(map["CoreLessonStatus"]);
    ContentDisplayStatus = ParsingHelper.parseStringMethod(map["ContentDisplayStatus"]);
    FolderPath = ParsingHelper.parseStringMethod(map["FolderPath"]);
    jwstartpage = ParsingHelper.parseStringMethod(map["jwstartpage"]);
    startpage = ParsingHelper.parseStringMethod(map["startpage"]);
    ContentModifiedDateTime = ParsingHelper.parseStringMethod(map["ContentModifiedDateTime"]);
    ScoID = ParsingHelper.parseIntMethod(map["ScoID"]);
    UserID = ParsingHelper.parseIntMethod(map["UserID"]);
    SiteID = ParsingHelper.parseIntMethod(map["SiteID"]);
    ContentTypeId = ParsingHelper.parseIntMethod(map["ContentTypeId"]);
    MediaTypeID = ParsingHelper.parseIntMethod(map["MediaTypeID"]);
    ViewType = ParsingHelper.parseIntMethod(map["ViewType"]);
    PercentCompleted = ParsingHelper.parseDoubleMethod(map["PercentCompleted"]);
    bit1 = ParsingHelper.parseBoolMethod(map["bit1"]);
    bit5 = ParsingHelper.parseBoolMethod(map["bit5"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "ActionViewQRcode": ActionViewQRcode,
      "ActivityId": ActivityId,
      "ContentType": ContentType,
      "Name": Name,
      "Status": Status,
      "CreatedDate": CreatedDate,
      "EventStartDateTime": EventStartDateTime,
      "EventEndDateTime": EventEndDateTime,
      "AuthorWithLink": AuthorWithLink,
      "ShortDescription": ShortDescription,
      "ThumbnailImagePath": ThumbnailImagePath,
      "DetailsLink": DetailsLink,
      "ViewLink": ViewLink,
      "SetcompleteLink": SetcompleteLink,
      "ContentID": ContentID,
      "ContentStatus": ContentStatus,
      "Duration": Duration,
      "IsHide": IsHide,
      "IsDisable": IsDisable,
      "Delete": Delete,
      "TotalRatings": TotalRatings,
      "PercentCompletedClass": PercentCompletedClass,
      "AuthorName": AuthorName,
      "WindowProperties": WindowProperties,
      "ThumbnailIconPath": ThumbnailIconPath,
      "JWVideoKey": JWVideoKey,
      "DownloadLink": DownloadLink,
      "ShareContentwithUser": ShareContentwithUser,
      "ExpiredContentAvailableUntill": ExpiredContentAvailableUntill,
      "ExpiredContentExpiryDate": ExpiredContentExpiryDate,
      "CoreLessonStatus": CoreLessonStatus,
      "ContentDisplayStatus": ContentDisplayStatus,
      "FolderPath": FolderPath,
      "jwstartpage": jwstartpage,
      "startpage": startpage,
      "ContentModifiedDateTime": ContentModifiedDateTime,
      "ScoID": ScoID,
      "UserID": UserID,
      "SiteID": SiteID,
      "ContentTypeId": ContentTypeId,
      "MediaTypeID": MediaTypeID,
      "ViewType": ViewType,
      "PercentCompleted": PercentCompleted,
      "bit1": bit1,
      "bit5": bit5,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
