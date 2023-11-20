import 'package:flutter_chat_bot/utils/parsing_helper.dart';

class DeleteForumRequestModel {
  String LocaleID = "";
  int ForumID = 0;
  int UserID = 0;
  int SiteID = 0;

  DeleteForumRequestModel({
    this.LocaleID = "",
    this.UserID = 0,
    this.SiteID = 0,
    this.ForumID = 0,
  });

  DeleteForumRequestModel.fromJson(Map<String, dynamic> json) {
    LocaleID = ParsingHelper.parseStringMethod(json['LocaleID']);
    SiteID = ParsingHelper.parseIntMethod(json['SiteID']);
    UserID = ParsingHelper.parseIntMethod(json['UserID']);
    ForumID = ParsingHelper.parseIntMethod(json['ForumID']);
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['LocaleID'] = LocaleID;
    data['ForumID'] = ParsingHelper.parseStringMethod(ForumID);
    data['UserID'] = ParsingHelper.parseStringMethod(UserID);
    data['SiteID'] = ParsingHelper.parseStringMethod(SiteID);

    return data;
  }
}
