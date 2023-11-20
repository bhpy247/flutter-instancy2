import 'dart:typed_data';

import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class PostCommentRequestModel {
  String topicID = "";
  String topicName = "";
  int forumID = 0;
  String forumTitle = "";
  String message = "";
  int userID = 0;
  int siteID = 0;
  String localeID = "";
  String strAttachFile = "";
  String strReplyID = "";
  String commentedBy = "";
  Uint8List? fileBytes;

  PostCommentRequestModel({
    this.topicID = "",
    this.topicName = "",
    this.forumID = 0,
    this.forumTitle = "",
    this.message = "",
    this.userID = 0,
    this.siteID = 0,
    this.localeID = "",
    this.strAttachFile = "",
    this.strReplyID = "",
    this.commentedBy = "",
    this.fileBytes,
  });

  PostCommentRequestModel.fromJson(Map<String, dynamic> json) {
    topicID = ParsingHelper.parseStringMethod(json['TopicID']);
    topicName = ParsingHelper.parseStringMethod(json['TopicName']);
    forumID = ParsingHelper.parseIntMethod(json['ForumID']);
    forumTitle = ParsingHelper.parseStringMethod(json['ForumTitle']);
    message = ParsingHelper.parseStringMethod(json['Message']);
    userID = ParsingHelper.parseIntMethod(json['UserID']);
    siteID = ParsingHelper.parseIntMethod(json['SiteID']);
    localeID = ParsingHelper.parseStringMethod(json['LocaleID']);
    strAttachFile = ParsingHelper.parseStringMethod(json['strAttachFile']);
    strReplyID = ParsingHelper.parseStringMethod(json['strReplyID']);
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['TopicID'] = topicID;
    data['TopicName'] = topicName;
    data['ForumID'] = ParsingHelper.parseStringMethod(forumID);
    data['ForumTitle'] = forumTitle;
    data['Message'] = message;
    data['UserID'] = ParsingHelper.parseStringMethod(userID);
    data['SiteID'] = ParsingHelper.parseStringMethod(siteID);
    data['LocaleID'] = localeID;
    data['strAttachFile'] = strAttachFile;
    data['strReplyID'] = strReplyID;
    return data;
  }
}
