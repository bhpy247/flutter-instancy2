import 'package:flutter_chat_bot/utils/parsing_helper.dart';

class UserComingSoonRequestModel {
  int userID = 0;
  String contentId = "";
  String savingtype = "";
  String responseText = "";

  UserComingSoonRequestModel(
      {this.userID = 0, this.contentId = "", this.savingtype = "", this.responseText = ""});

  UserComingSoonRequestModel.fromJson(Map<String, dynamic> json) {
    userID = ParsingHelper.parseIntMethod(json['userID']);
    contentId = ParsingHelper.parseStringMethod(json['contentId']);
    savingtype = ParsingHelper.parseStringMethod(json['savingtype']);
    responseText = ParsingHelper.parseStringMethod(json['responseText']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userID'] = userID;
    data['contentId'] = contentId;
    data['savingtype'] = savingtype;
    data['responseText'] = responseText;
    return data;
  }
}
