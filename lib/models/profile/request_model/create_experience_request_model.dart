import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class CreateExperienceRequestModel {
  String showftoate = "", todate = "", discription = "", location = "", showfromdate = "", company = "", fromdate = "", displayNo = "", userId = "", title = "", oldtitle = "";
  int tilldate = 0;

  CreateExperienceRequestModel({
    this.showftoate = "",
    this.todate = "",
    this.discription = "",
    this.location = "",
    this.showfromdate = "",
    this.company = "",
    this.fromdate = "",
    this.displayNo = "",
    this.userId = "",
    this.title = "",
    this.oldtitle = "",
    this.tilldate = 0,
  });

  CreateExperienceRequestModel.fromJson(Map<String, dynamic> json) {
    showftoate = ParsingHelper.parseStringMethod(json["showftoate"]);
    todate = ParsingHelper.parseStringMethod(json["todate"]);
    discription = ParsingHelper.parseStringMethod(json["discription"]);
    location = ParsingHelper.parseStringMethod(json["location"]);
    showfromdate = ParsingHelper.parseStringMethod(json["showfromdate"]);
    company = ParsingHelper.parseStringMethod(json["Company"]);
    fromdate = ParsingHelper.parseStringMethod(json["fromdate"]);
    displayNo = ParsingHelper.parseStringMethod(json["DisplayNo"]);
    userId = ParsingHelper.parseStringMethod(json["UserID"]);
    title = ParsingHelper.parseStringMethod(json["title"]);
    oldtitle = ParsingHelper.parseStringMethod(json["oldtitle"]);
    tilldate = ParsingHelper.parseIntMethod(json["Tilldate"]);
  }

  Map<String, dynamic> toJson() => {
        "showftoate": showftoate,
        "todate": todate,
        "discription": discription,
        "location": location,
        "showfromdate": showfromdate,
        "Company": company,
        "fromdate": fromdate,
        "DisplayNo": displayNo,
        "UserID": userId,
        "title": title,
        "oldtitle": oldtitle,
        "Tilldate": tilldate,
      };

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
