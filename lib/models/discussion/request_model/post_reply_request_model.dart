import 'package:flutter_chat_bot/utils/parsing_helper.dart';

class PostReplyRequestModel {
  String topicID = "";
  String forumTitle = "";
  String strCommenttxt = "";
  String involvedUserIDList = "";
  String topicName = "";
  String strAttachFile = "";
  String message = "";
  String localeID = "";
  String strReplyID = "";
  int userID = 0;
  int siteID = 0;
  int forumID = 0;
  int strCommentID = 0;

  PostReplyRequestModel({
    this.topicID = "",
    this.forumTitle = "",
    this.strCommenttxt = "",
    this.involvedUserIDList = "",
    this.topicName = "",
    this.strAttachFile = "",
    this.message = "",
    this.localeID = "",
    this.strReplyID = "",
    this.userID = 0,
    this.siteID = 0,
    this.forumID = 0,
    this.strCommentID = 0,
  });

  PostReplyRequestModel.fromJson(Map<String, dynamic> json) {
    topicID = ParsingHelper.parseStringMethod(json['TopicID']);
    forumTitle = ParsingHelper.parseStringMethod(json['ForumTitle']);
    strCommenttxt = ParsingHelper.parseStringMethod(json['strCommenttxt']);
    involvedUserIDList = ParsingHelper.parseStringMethod(json['InvolvedUserIDList']);
    topicName = ParsingHelper.parseStringMethod(json['TopicName']);
    strAttachFile = ParsingHelper.parseStringMethod(json['strAttachFile']);
    message = ParsingHelper.parseStringMethod(json['Message']);
    localeID = ParsingHelper.parseStringMethod(json['LocaleID']);
    strReplyID = ParsingHelper.parseStringMethod(json['strReplyID']);
    userID = ParsingHelper.parseIntMethod(json['UserID']);
    siteID = ParsingHelper.parseIntMethod(json['SiteID']);
    forumID = ParsingHelper.parseIntMethod(json['ForumID']);
    strCommentID = ParsingHelper.parseIntMethod(json['strCommentID']);
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['strCommentID'] = ParsingHelper.parseStringMethod(strCommentID);
    data['TopicID'] = topicID;
    data['ForumID'] = ParsingHelper.parseStringMethod(forumID);
    data['InvolvedUserIDList'] = involvedUserIDList;
    data['TopicName'] = topicName;
    data['strAttachFile'] = strAttachFile;
    data['Message'] = message;
    data['LocaleID'] = localeID;
    data['strReplyID'] = strReplyID;
    data['UserID'] = ParsingHelper.parseStringMethod(userID);
    data['SiteID'] = ParsingHelper.parseStringMethod(siteID);
    data['ForumTitle'] = forumTitle;
    data['strCommenttxt'] = strCommenttxt;
    return data;
  }
}
