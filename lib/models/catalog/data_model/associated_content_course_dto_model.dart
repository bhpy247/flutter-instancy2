import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../../utils/my_utils.dart';

class AssociatedContentCourseDTOModel {
  String ContentID = "";
  String ThumbnailIconPath = "";
  String CreatedOn = "";
  String AuthorDisplayName = "";
  String ThumbnailImagePath = "";
  String Tags = "";
  String Title = "";
  String ShortDescription = "";
  String Currency = "";
  String ContentType = "";
  String TimeZone = "";
  String SalePrice = "";
  String Usertimezone = "";
  String EventselectedinstanceID = "";
  String InstanceAttendence = "";
  String EventStartDateTime = "";
  String EventEndDateTime = "";
  String EventScheduleType = "";
  String DetailsLink = "";
  String ActionName = "";
  String PrerequisitehavingPrerequisites = "";
  String PrerequisitehavingPrerequisites1 = "";
  String AddLink = "";
  String AssignedContent = "";
  String ExcludeContent = "";
  String StartPage = "";
  int ScoID = 0;
  int ContentTypeId = 0;
  int Prerequisites = 0;
  int ViewType = 0;
  int MediaTypeID = 0;
  bool bit5 = false;
  bool IsLearnerContent = false;
  bool Ischecked = false;
  bool NoInstanceAvailable = false;
  bool bit1 = false;
  bool IsRequiredCompletionCompleted = false;
  PrerequisiteEnrolledDTOModel? PrerequisiteEnrolledContent;

  AssociatedContentCourseDTOModel({
    this.ContentID = "",
    this.ThumbnailIconPath = "",
    this.CreatedOn = "",
    this.AuthorDisplayName = "",
    this.ThumbnailImagePath = "",
    this.Tags = "",
    this.Title = "",
    this.ShortDescription = "",
    this.Currency = "",
    this.ContentType = "",
    this.TimeZone = "",
    this.SalePrice = "",
    this.Usertimezone = "",
    this.EventselectedinstanceID = "",
    this.InstanceAttendence = "",
    this.EventStartDateTime = "",
    this.EventEndDateTime = "",
    this.EventScheduleType = "",
    this.DetailsLink = "",
    this.ActionName = "",
    this.PrerequisitehavingPrerequisites = "",
    this.PrerequisitehavingPrerequisites1 = "",
    this.AddLink = "",
    this.AssignedContent = "",
    this.ExcludeContent = "",
    this.StartPage = "",
    this.ScoID = 0,
    this.ContentTypeId = 0,
    this.Prerequisites = 0,
    this.ViewType = 0,
    this.MediaTypeID = 0,
    this.bit5 = false,
    this.IsLearnerContent = false,
    this.Ischecked = false,
    this.NoInstanceAvailable = false,
    this.bit1 = false,
    this.IsRequiredCompletionCompleted = false,
    this.PrerequisiteEnrolledContent,
  });

  AssociatedContentCourseDTOModel.fromJson(Map<String, dynamic> json) {
    ContentID = ParsingHelper.parseStringMethod(json["ContentID"]);
    ThumbnailIconPath = ParsingHelper.parseStringMethod(json["ThumbnailIconPath"]);
    CreatedOn = ParsingHelper.parseStringMethod(json["CreatedOn"]);
    AuthorDisplayName = ParsingHelper.parseStringMethod(json["AuthorDisplayName"]);
    ThumbnailImagePath = ParsingHelper.parseStringMethod(json["ThumbnailImagePath"]);
    Tags = ParsingHelper.parseStringMethod(json["Tags"]);
    Title = ParsingHelper.parseStringMethod(json["Title"]);
    ShortDescription = ParsingHelper.parseStringMethod(json["ShortDescription"]);
    Currency = ParsingHelper.parseStringMethod(json["Currency"]);
    ContentType = ParsingHelper.parseStringMethod(json["ContentType"]);
    TimeZone = ParsingHelper.parseStringMethod(json["TimeZone"]);
    SalePrice = ParsingHelper.parseStringMethod(json["SalePrice"]);
    Usertimezone = ParsingHelper.parseStringMethod(json["Usertimezone"]);
    EventselectedinstanceID = ParsingHelper.parseStringMethod(json["EventselectedinstanceID"]);
    InstanceAttendence = ParsingHelper.parseStringMethod(json["InstanceAttendence"]);
    EventStartDateTime = ParsingHelper.parseStringMethod(json["EventStartDateTime"]);
    EventEndDateTime = ParsingHelper.parseStringMethod(json["EventEndDateTime"]);
    EventScheduleType = ParsingHelper.parseStringMethod(json["EventScheduleType"]);
    DetailsLink = ParsingHelper.parseStringMethod(json["DetailsLink"]);
    ActionName = ParsingHelper.parseStringMethod(json["ActionName"]);
    PrerequisitehavingPrerequisites = ParsingHelper.parseStringMethod(json["PrerequisitehavingPrerequisites"]);
    PrerequisitehavingPrerequisites1 = ParsingHelper.parseStringMethod(json["PrerequisitehavingPrerequisites1"]);
    AddLink = ParsingHelper.parseStringMethod(json["AddLink"]);
    AssignedContent = ParsingHelper.parseStringMethod(json["AssignedContent"]);
    ExcludeContent = ParsingHelper.parseStringMethod(json["ExcludeContent"]);
    StartPage = ParsingHelper.parseStringMethod(json["StartPage"]);
    ScoID = ParsingHelper.parseIntMethod(json["ScoID"]);
    ContentTypeId = ParsingHelper.parseIntMethod(json["ContentTypeId"]);
    Prerequisites = ParsingHelper.parseIntMethod(json["Prerequisites"]);
    ViewType = ParsingHelper.parseIntMethod(json["ViewType"]);
    MediaTypeID = ParsingHelper.parseIntMethod(json["MediaTypeID"]);
    bit5 = ParsingHelper.parseBoolMethod(json["bit5"]);
    IsLearnerContent = ParsingHelper.parseBoolMethod(json["IsLearnerContent"]);
    Ischecked = ParsingHelper.parseBoolMethod(json["Ischecked"]);
    NoInstanceAvailable = ParsingHelper.parseBoolMethod(json["NoInstanceAvailable"]);
    bit1 = ParsingHelper.parseBoolMethod(json["bit1"]);
    IsRequiredCompletionCompleted = ParsingHelper.parseBoolMethod(json["IsRequiredCompletionCompleted"]);

    Map<String, dynamic> PrerequisiteEnrolledContentMap = ParsingHelper.parseMapMethod(json['PrerequisiteEnrolledContent']);
    if(PrerequisiteEnrolledContentMap.isNotEmpty) {
      PrerequisiteEnrolledContent = PrerequisiteEnrolledDTOModel.fromJson(PrerequisiteEnrolledContentMap);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "ContentID": ContentID,
      "ThumbnailIconPath": ThumbnailIconPath,
      "CreatedOn": CreatedOn,
      "AuthorDisplayName": AuthorDisplayName,
      "ThumbnailImagePath": ThumbnailImagePath,
      "Tags": Tags,
      "Title": Title,
      "ShortDescription": ShortDescription,
      "Currency": Currency,
      "ContentType": ContentType,
      "TimeZone": TimeZone,
      "SalePrice": SalePrice,
      "Usertimezone": Usertimezone,
      "EventselectedinstanceID": EventselectedinstanceID,
      "InstanceAttendence": InstanceAttendence,
      "EventStartDateTime": EventStartDateTime,
      "EventEndDateTime": EventEndDateTime,
      "EventScheduleType": EventScheduleType,
      "DetailsLink": DetailsLink,
      "ActionName": ActionName,
      "PrerequisitehavingPrerequisites": PrerequisitehavingPrerequisites,
      "PrerequisitehavingPrerequisites1": PrerequisitehavingPrerequisites1,
      "AddLink": AddLink,
      "AssignedContent": AssignedContent,
      "ExcludeContent": ExcludeContent,
      "StartPage": StartPage,
      "ScoID": ScoID,
      "ContentTypeId": ContentTypeId,
      "Prerequisites": Prerequisites,
      "ViewType": ViewType,
      "MediaTypeID": MediaTypeID,
      "bit5": bit5,
      "IsLearnerContent": IsLearnerContent,
      "Ischecked": Ischecked,
      "NoInstanceAvailable": NoInstanceAvailable,
      "bit1": bit1,
      "IsRequiredCompletionCompleted": IsRequiredCompletionCompleted,
      "PrerequisiteEnrolledContent": PrerequisiteEnrolledContent?.toJson(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }

  bool hasPrerequisiteContents() {
    return AppConfigurationOperations.hasPrerequisiteContents(AddLink);
  }
}

class PrerequisiteEnrolledDTOModel {
  bool ShowPrerequisiteEventDate = false;
  bool ShowParentPrerequisiteEventDate = false;
  String PrerequisiteDateConflictName = "";
  String PrerequisiteDateConflictDateTime = "";

  PrerequisiteEnrolledDTOModel({
    this.ShowPrerequisiteEventDate = false,
    this.ShowParentPrerequisiteEventDate = false,
    this.PrerequisiteDateConflictName = "",
    this.PrerequisiteDateConflictDateTime = "",
  });

  PrerequisiteEnrolledDTOModel.fromJson(Map<String, dynamic> json) {
    ShowPrerequisiteEventDate = ParsingHelper.parseBoolMethod(json["ShowPrerequisiteEventDate"]);
    ShowParentPrerequisiteEventDate = ParsingHelper.parseBoolMethod(json["ShowParentPrerequisiteEventDate"]);
    PrerequisiteDateConflictName = ParsingHelper.parseStringMethod(json["PrerequisiteDateConflictName"]);
    PrerequisiteDateConflictDateTime = ParsingHelper.parseStringMethod(json["PrerequisiteDateConflictDateTime"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "ShowPrerequisiteEventDate": ShowPrerequisiteEventDate,
      "ShowParentPrerequisiteEventDate": ShowParentPrerequisiteEventDate,
      "PrerequisiteDateConflictName": PrerequisiteDateConflictName,
      "PrerequisiteDateConflictDateTime": PrerequisiteDateConflictDateTime,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}