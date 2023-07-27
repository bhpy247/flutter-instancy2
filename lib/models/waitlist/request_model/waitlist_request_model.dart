import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class AddToWaitListRequestModel {
  String siteId = "";
  String locale = "";
  String contentID = "";
  String userID = "";

  AddToWaitListRequestModel(
      {this.siteId = "",
        this.locale = "",
        this.contentID = "",
        this.userID = ""});

  AddToWaitListRequestModel.fromMap(Map<String, dynamic> json) {
    siteId = ParsingHelper.parseStringMethod(json['siteid']);
    locale = ParsingHelper.parseStringMethod(json['locale']);
    contentID = ParsingHelper.parseStringMethod(json['WLContentID']);
    userID = ParsingHelper.parseStringMethod(json['UserID']);
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['siteid'] = siteId;
    data['locale'] = locale;
    data['WLContentID'] = contentID;
    data['UserID'] = userID;
    return data;
  }
}
