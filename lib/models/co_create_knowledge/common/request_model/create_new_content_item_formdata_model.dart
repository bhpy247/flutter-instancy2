import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';

class CreateNewContentItemFormDataModel {
  String Language = AppConstants.defaultLocale;
  String StartPage = "";
  String Name = "";
  String TagName = "";
  String VideoIntroduction = "";
  String ShortDescription = "";
  String LongDescription = "";
  String LearningObjectives = "";
  String TableofContent = "";
  String Keywords = "";
  String NoofModules = "";
  String GroupCodeID = "";
  String ContentCode = "";
  String MediaTypeID = "";
  String EventStartDateTime = "";
  String EventEndDateTime = "";
  String RegistrationURL = "";
  String Location = "";
  int Duration = 0;
  int TotalAttempts = 0;
  bool Bit3 = false;

  CreateNewContentItemFormDataModel({
    this.Language = AppConstants.defaultLocale,
    this.StartPage = "",
    this.Name = "",
    this.TagName = "",
    this.VideoIntroduction = "",
    this.ShortDescription = "",
    this.LongDescription = "",
    this.LearningObjectives = "",
    this.TableofContent = "",
    this.Keywords = "",
    this.NoofModules = "",
    this.GroupCodeID = "",
    this.ContentCode = "",
    this.MediaTypeID = "",
    this.EventStartDateTime = "",
    this.EventEndDateTime = "",
    this.RegistrationURL = "",
    this.Location = "",
    this.Duration = 0,
    this.TotalAttempts = 0,
    this.Bit3 = false,
  });

  Map<String, dynamic> toMap() {
    return {
      "Language": Language,
      "StartPage": StartPage,
      "Name": Name,
      "TagName": TagName,
      "VideoIntroduction": VideoIntroduction,
      "ShortDescription": ShortDescription,
      "LongDescription": LongDescription,
      "LearningObjectives": LearningObjectives,
      "TableofContent": TableofContent,
      "Keywords": Keywords,
      "NoofModules": NoofModules,
      "GroupCodeID": GroupCodeID,
      "ContentCode": ContentCode,
      "MediaTypeID": MediaTypeID,
      "EventStartDateTime": EventStartDateTime,
      "EventEndDateTime": EventEndDateTime,
      "RegistrationURL": RegistrationURL,
      "Location": Location,
      "Duration": Duration,
      "TotalAttempts": TotalAttempts,
      "Bit3": Bit3,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
