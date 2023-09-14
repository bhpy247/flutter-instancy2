import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';

import '../../utils/my_utils.dart';
import '../../utils/parsing_helper.dart';

class GlobalSearchCourseDTOModel extends CourseDTOModel {
  String NamePreFix = "";
  String DestinationLink = "";
  String EnrollLink = "";
  String LongDescription = "";
  String StartPage = "";
  String ParticipantURL = "";
  String PublishedDate = "";
  String ItunesProductID = "";
  String SiteURL = "";
  String ViewProfileLink = "";
  String NoImageText = "";
  bool ListView = false;

  GlobalSearchCourseDTOModel({
    this.NamePreFix = "",
    this.DestinationLink = "",
    this.EnrollLink = "",
    this.LongDescription = "",
    this.StartPage = "",
    this.ParticipantURL = "",
    this.PublishedDate = "",
    this.ItunesProductID = "",
    this.SiteURL = "",
    this.ViewProfileLink = "",
    this.NoImageText = "",
    this.ListView = false,
  });

  GlobalSearchCourseDTOModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  @override
  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    super.updateFromMap(map);

    NamePreFix = ParsingHelper.parseStringMethod(map["NamePreFix"]);
    DestinationLink = ParsingHelper.parseStringMethod(map["DestinationLink"]);
    EnrollLink = ParsingHelper.parseStringMethod(map["EnrollLink"]);
    LongDescription = ParsingHelper.parseStringMethod(map["LongDescription"]);
    StartPage = ParsingHelper.parseStringMethod(map["StartPage"]);
    ParticipantURL = ParsingHelper.parseStringMethod(map["ParticipantURL"]);
    PublishedDate = ParsingHelper.parseStringMethod(map["PublishedDate"]);
    ItunesProductID = ParsingHelper.parseStringMethod(map["ItunesProductID"]);
    SiteURL = ParsingHelper.parseStringMethod(map["SiteURL"]);
    ViewProfileLink = ParsingHelper.parseStringMethod(map["ViewProfileLink"]);
    NoImageText = ParsingHelper.parseStringMethod(map["NoImageText"]);
    ListView = ParsingHelper.parseBoolMethod(map["ListView"]);
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()..addAll(<String, dynamic>{
      "NamePreFix": NamePreFix,
      "DestinationLink": DestinationLink,
      "EnrollLink": EnrollLink,
      "LongDescription": LongDescription,
      "StartPage": StartPage,
      "ParticipantURL": ParticipantURL,
      "PublishedDate": PublishedDate,
      "ItunesProductID": ItunesProductID,
      "SiteURL": SiteURL,
      "ViewProfileLink": ViewProfileLink,
      "NoImageText": NoImageText,
      "ListView": ListView,
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