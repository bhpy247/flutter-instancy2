import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class UserExperienceDataModel {
  int userid = 0, displayno = 0;
  String title = "";
  String location = "", companyname = "", fromdate = "", todate = "", description = "", diffrence = "";
  bool tilldate = false;

  UserExperienceDataModel({
    this.userid = 0,
    this.displayno = 0,
    this.title = "",
    this.location = "",
    this.companyname = "",
    this.fromdate = "",
    this.todate = "",
    this.description = "",
    this.diffrence = "",
    this.tilldate = false,
  });

  UserExperienceDataModel.fromJson(Map<String, dynamic> json) {
    userid = ParsingHelper.parseIntMethod(json["userid"]);
    displayno = ParsingHelper.parseIntMethod(json["displayno"]);
    title = ParsingHelper.parseStringMethod(json["title"]);
    location = ParsingHelper.parseStringMethod(json["location"]);
    companyname = ParsingHelper.parseStringMethod(json["companyname"]);
    fromdate = ParsingHelper.parseStringMethod(json["fromdate"]);
    todate = ParsingHelper.parseStringMethod(json["todate"]);
    description = ParsingHelper.parseStringMethod(json["description"]);
    diffrence = ParsingHelper.parseStringMethod(json["diffrence"]);
    tilldate = ParsingHelper.parseBoolMethod(json["tilldate"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "userid": userid,
      "displayno": displayno,
      "title": title,
      "location": location,
      "companyname": companyname,
      "fromdate": fromdate,
      "todate": todate,
      "description": description,
      "diffrence": diffrence,
      "tilldate": tilldate,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}