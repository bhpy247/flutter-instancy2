import '../../../utils/parsing_helper.dart';

class FeedbackDtoModel {
  int ID = 0;
  String titlename = "";
  String desc = "";
  String imagepath = "";
  String url = "";
  String userid = "";
  String UserProfilePathdata = "";
  String UserDisplayName = "";
  String date = "";
  String FeedbackUploadImageName = "";
  String saveimagepath = "";
  String showimagepopup = "";

  FeedbackDtoModel({
    this.ID = 0,
    this.titlename = "",
    this.desc = "",
    this.imagepath = "",
    this.url = "",
    this.userid = "",
    this.UserProfilePathdata = "",
    this.UserDisplayName = "",
    this.date = "",
    this.FeedbackUploadImageName = "",
    this.saveimagepath = "",
    this.showimagepopup = "",
  });

  FeedbackDtoModel.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> json) {
    ID = ParsingHelper.parseIntMethod(json["ID"]);
    titlename = ParsingHelper.parseStringMethod(json["titlename"]);
    desc = ParsingHelper.parseStringMethod(json["desc"]);
    imagepath = ParsingHelper.parseStringMethod(json["imagepath"]);
    url = ParsingHelper.parseStringMethod(json["url"]);
    userid = ParsingHelper.parseStringMethod(json["userid"]);
    UserProfilePathdata = ParsingHelper.parseStringMethod(json["UserProfilePathdata"]);
    UserDisplayName = ParsingHelper.parseStringMethod(json["UserDisplayName"]);
    date = ParsingHelper.parseStringMethod(json["date"]);
    FeedbackUploadImageName = ParsingHelper.parseStringMethod(json["FeedbackUploadImageName"]);
    saveimagepath = ParsingHelper.parseStringMethod(json["saveimagepath"]);
    showimagepopup = ParsingHelper.parseStringMethod(json["showimagepopup"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "ID": ID,
      "titlename": titlename,
      "desc": desc,
      "imagepath": imagepath,
      "url": url,
      "userid": userid,
      "UserProfilePathdata": UserProfilePathdata,
      "UserDisplayName": UserDisplayName,
      "date": date,
      "FeedbackUploadImageName": FeedbackUploadImageName,
      "saveimagepath": saveimagepath,
      "showimagepopup": showimagepopup,
    };
  }
}
