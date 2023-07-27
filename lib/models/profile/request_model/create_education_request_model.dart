import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class CreateEducationRequestModel {
  String showfromdate = "", degree = "", title = "", toyear = "", titleEducation = "", userId = "", school = "", fromyear = "", discription = "",
      oldtitle = "", country = "", displayNo = "";

  CreateEducationRequestModel({
    this.showfromdate = "",
    this.degree = "",
    this.title = "",
    this.toyear = "",
    this.titleEducation = "",
    this.userId = "",
    this.school = "",
    this.fromyear = "",
    this.discription = "",
    this.oldtitle = "",
    this.country = "",
    this.displayNo = "",
  });

  CreateEducationRequestModel.fromJson(Map<String, dynamic> json) {
    showfromdate = ParsingHelper.parseStringMethod(json["showfromdate"]);
    degree = ParsingHelper.parseStringMethod(json["degree"]);
    title = ParsingHelper.parseStringMethod(json["title"]);
    toyear = ParsingHelper.parseStringMethod(json["toyear"]);
    titleEducation = ParsingHelper.parseStringMethod(json["titleEducation"]);
    userId = ParsingHelper.parseStringMethod(json["UserID"]);
    school = ParsingHelper.parseStringMethod(json["school"]);
    fromyear = ParsingHelper.parseStringMethod(json["fromyear"]);
    discription = ParsingHelper.parseStringMethod(json["discription"]);
    oldtitle = ParsingHelper.parseStringMethod(json["oldtitle"]);
    country = ParsingHelper.parseStringMethod(json["Country"]);
    displayNo = ParsingHelper.parseStringMethod(json["DisplayNo"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "showfromdate": showfromdate,
      "degree": degree,
      "title": title,
      "toyear": toyear,
      "titleEducation": titleEducation,
      "UserID": userId,
      "school": school,
      "fromyear": fromyear,
      "discription": discription,
      "oldtitle": oldtitle,
      "Country": country,
      "DisplayNo": displayNo,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}