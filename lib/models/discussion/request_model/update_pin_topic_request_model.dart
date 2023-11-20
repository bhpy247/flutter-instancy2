import 'package:flutter_chat_bot/utils/parsing_helper.dart';

class UpdatePinTopicRequestModel {
  int forumID = 0;
  String strContentID = "";
  bool isPin = false;
  int userID = 0;

  UpdatePinTopicRequestModel({this.forumID = 0, this.strContentID = "", this.isPin = false, this.userID = 0});

  UpdatePinTopicRequestModel.fromJson(Map<String, dynamic> json) {
    forumID = ParsingHelper.parseIntMethod(json['ForumID']);
    strContentID = ParsingHelper.parseStringMethod(json['strContentID']);
    isPin = ParsingHelper.parseBoolMethod(json['IsPin']);
    userID = ParsingHelper.parseIntMethod(json['UserID']);
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['ForumID'] = ParsingHelper.parseStringMethod(forumID);
    data['strContentID'] = strContentID;
    data['IsPin'] = ParsingHelper.parseStringMethod(isPin);
    data['UserID'] = ParsingHelper.parseStringMethod(userID);
    return data;
  }
}
