import 'package:flutter_chat_bot/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';

class LikeDislikeReplyRequestModel {
  int intUserID = 0;
  int intTypeID = 0;
  String strObjectID = "";
  bool blnIsLiked = false;

  LikeDislikeReplyRequestModel({
    this.intUserID = 0,
    this.intTypeID = 0,
    this.strObjectID = "",
    this.blnIsLiked = false,
  });

  LikeDislikeReplyRequestModel.fromJson(Map<String, dynamic> json) {
    intUserID = ParsingHelper.parseIntMethod(json['intUserID']);
    strObjectID = ParsingHelper.parseStringMethod(json['strObjectID']);
    intTypeID = ParsingHelper.parseIntMethod(json['intTypeID']);
    blnIsLiked = ParsingHelper.parseBoolMethod(json['blnIsLiked']);
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['intUserID'] = ParsingHelper.parseStringMethod(intUserID);
    data['strObjectID'] = strObjectID;
    data['intTypeID'] = ParsingHelper.parseStringMethod(intTypeID);
    data['blnIsLiked'] = ParsingHelper.parseStringMethod(blnIsLiked);
    return data;
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
