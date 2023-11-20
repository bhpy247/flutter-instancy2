import 'package:flutter_chat_bot/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';

class LikeDislikeTopicAndCommentRequestModel {
  int intUserID = 0;
  int intTypeID = 0;
  int intSiteID = 0;
  String strLocale = "";
  String strObjectID = "";
  bool blnIsLiked = false;

  LikeDislikeTopicAndCommentRequestModel({
    this.intUserID = 0,
    this.intTypeID = 0,
    this.intSiteID = 0,
    this.strLocale = "",
    this.strObjectID = "",
    this.blnIsLiked = false,
  });

  LikeDislikeTopicAndCommentRequestModel.fromJson(Map<String, dynamic> json) {
    intUserID = ParsingHelper.parseIntMethod(json['intUserID']);
    strObjectID = ParsingHelper.parseStringMethod(json['strObjectID']);
    intTypeID = ParsingHelper.parseIntMethod(json['intTypeID']);
    blnIsLiked = ParsingHelper.parseBoolMethod(json['blnIsLiked']);
    intSiteID = ParsingHelper.parseIntMethod(json['intSiteID']);
    strLocale = ParsingHelper.parseStringMethod(json['strLocale']);
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['intUserID'] = ParsingHelper.parseStringMethod(intUserID);
    data['strObjectID'] = strObjectID;
    data['intTypeID'] = ParsingHelper.parseStringMethod(intTypeID);
    data['blnIsLiked'] = ParsingHelper.parseStringMethod(blnIsLiked);
    data['intSiteID'] = ParsingHelper.parseStringMethod(intSiteID);
    data['strLocale'] = strLocale;
    return data;
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
