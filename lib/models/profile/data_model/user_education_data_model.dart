import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class UserEducationDataModel {
  int userid = 0, titleid = 0, displayno = 0;
  String school = "", country = "", degree = "", description = "", titleeducation = "", totalperiod = "", fromyear = "", toyear = "";

  UserEducationDataModel({
    this.userid = 0,
    this.titleid = 0,
    this.displayno = 0,
    this.school = "",
    this.country = "",
    this.degree = "",
    this.description = "",
    this.titleeducation = "",
    this.totalperiod = "",
    this.fromyear = "",
    this.toyear = "",
  });

  UserEducationDataModel.fromJson(Map<String, dynamic> json) {
    userid = ParsingHelper.parseIntMethod(json["userid"]);
    titleid = ParsingHelper.parseIntMethod(json["titleid"]);
    displayno = ParsingHelper.parseIntMethod(json["displayno"]);
    school = ParsingHelper.parseStringMethod(json["school"]);
    country = ParsingHelper.parseStringMethod(json["country"]);
    degree = ParsingHelper.parseStringMethod(json["degree"]);
    description = ParsingHelper.parseStringMethod(json["description"]);
    titleeducation = ParsingHelper.parseStringMethod(json["titleeducation"]);
    totalperiod = ParsingHelper.parseStringMethod(json["totalperiod"]);
    fromyear = ParsingHelper.parseStringMethod(json["fromyear"]);
    toyear = ParsingHelper.parseStringMethod(json["toyear"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "userid": userid,
      "school": school,
      "country": country,
      "titleid": titleid,
      "degree": degree,
      "description": description,
      "displayno": displayno,
      "titleeducation": titleeducation,
      "totalperiod": totalperiod,
      "fromyear": fromyear,
      "toyear": toyear,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}