import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../../utils/my_utils.dart';
import 'tag_model.dart';

class EventTrackDTOModel {
  String Description = "";
  String AboutAuthor = "";
  String Tags = "";
  String Datedetails = "";
  String longdescription = "";
  String shortdescription = "";
  String DisplayName = "";
  String FirtsandLastname = "";
  String About = "";
  String totalRatings = "";
  String contentCount = "";
  String createddate = "";
  String Name = "";
  String EventStartDateTime = "";
  String EventEndDateTime = "";
  String Timezone = "";
  String OrgName = "";
  String ProfileImgPath = "";
  String downloadcalendaraction = "";
  List<TagModel> RelatedTags = <TagModel>[];

  EventTrackDTOModel({
    this.Description = "",
    this.AboutAuthor = "",
    this.Tags = "",
    this.Datedetails = "",
    this.longdescription = "",
    this.shortdescription = "",
    this.DisplayName = "",
    this.FirtsandLastname = "",
    this.About = "",
    this.totalRatings = "",
    this.contentCount = "",
    this.createddate = "",
    this.Name = "",
    this.EventStartDateTime = "",
    this.EventEndDateTime = "",
    this.Timezone = "",
    this.OrgName = "",
    this.ProfileImgPath = "",
    this.downloadcalendaraction = "",
    List<TagModel>? RelatedTags,
  }) {
    this.RelatedTags = RelatedTags ?? <TagModel>[];
  }

  EventTrackDTOModel.fromJson(Map<String, dynamic> json) {
    Description = ParsingHelper.parseStringMethod(json["Description"]);
    AboutAuthor = ParsingHelper.parseStringMethod(json["AboutAuthor"]);
    Tags = ParsingHelper.parseStringMethod(json["Tags"]);
    Datedetails = ParsingHelper.parseStringMethod(json["Datedetails"]);
    longdescription = ParsingHelper.parseStringMethod(json["longdescription"]);
    shortdescription = ParsingHelper.parseStringMethod(json["shortdescription"]);
    DisplayName = ParsingHelper.parseStringMethod(json["DisplayName"]);
    FirtsandLastname = ParsingHelper.parseStringMethod(json["FirtsandLastname"]);
    About = ParsingHelper.parseStringMethod(json["About"]);
    totalRatings = ParsingHelper.parseStringMethod(json["totalRatings"]);
    contentCount = ParsingHelper.parseStringMethod(json["contentCount"]);
    createddate = ParsingHelper.parseStringMethod(json["createddate"]);
    Name = ParsingHelper.parseStringMethod(json["Name"]);
    EventStartDateTime = ParsingHelper.parseStringMethod(json["EventStartDateTime"]);
    EventEndDateTime = ParsingHelper.parseStringMethod(json["EventEndDateTime"]);
    Timezone = ParsingHelper.parseStringMethod(json["Timezone"]);
    OrgName = ParsingHelper.parseStringMethod(json["OrgName"]);
    ProfileImgPath = ParsingHelper.parseStringMethod(json["ProfileImgPath"]);
    downloadcalendaraction = ParsingHelper.parseStringMethod(json["downloadcalendaraction"]);

    List<Map<String, dynamic>> RelatedTagsMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(json['RelatedTags']);
      RelatedTags = RelatedTagsMapsList.map((e) {
      return TagModel.fromJson(e);
    }).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      "Description": Description,
      "AboutAuthor": AboutAuthor,
      "Tags": Tags,
      "Datedetails": Datedetails,
      "longdescription": longdescription,
      "shortdescription": shortdescription,
      "DisplayName": DisplayName,
      "FirtsandLastname": FirtsandLastname,
      "About": About,
      "totalRatings": totalRatings,
      "contentCount": contentCount,
      "createddate": createddate,
      "Name": Name,
      "EventStartDateTime": EventStartDateTime,
      "EventEndDateTime": EventEndDateTime,
      "Timezone": Timezone,
      "OrgName": OrgName,
      "ProfileImgPath": ProfileImgPath,
      "downloadcalendaraction": downloadcalendaraction,
      "RelatedTags": RelatedTags.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}

