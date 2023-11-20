import 'package:flutter_chat_bot/utils/parsing_helper.dart';

class DeleteCommentRequestModel {
  String topicID = "";
  int forumID = 0;
  String replyID = "";
  String topicName = "";
  int siteID = 0;
  int userID = 0;
  String localeID = "";
  int noofReplies = 0;
  String lastPostedDate = "";
  int createdUserID = 0;
  String attachementPath = "";

  DeleteCommentRequestModel(
      {this.topicID = "",
      this.forumID = 0,
      this.replyID = "",
      this.topicName = "",
      this.siteID = 0,
      this.userID = 0,
      this.localeID = "",
      this.noofReplies = 0,
      this.lastPostedDate = "",
      this.createdUserID = 0,
      this.attachementPath = ""});

  DeleteCommentRequestModel.fromJson(Map<String, dynamic> json) {
    topicID = ParsingHelper.parseStringMethod(json['TopicID']);
    forumID = ParsingHelper.parseIntMethod(json['ForumID']);
    replyID = ParsingHelper.parseStringMethod(json['ReplyID']);
    topicName = ParsingHelper.parseStringMethod(json['TopicName']);
    userID = ParsingHelper.parseIntMethod(json['UserID']);
    siteID = ParsingHelper.parseIntMethod(json['SiteID']);
    localeID = ParsingHelper.parseStringMethod(json['LocaleID']);
    noofReplies = ParsingHelper.parseIntMethod(json['NoofReplies']);
    lastPostedDate = ParsingHelper.parseStringMethod(json['LastPostedDate']);
    createdUserID = ParsingHelper.parseIntMethod(json['CreatedUserID']);
    attachementPath = ParsingHelper.parseStringMethod(json['AttachementPath']);
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['TopicID'] = topicID;
    data['ForumID'] = ParsingHelper.parseStringMethod(forumID);
    data['ReplyID'] = replyID;
    data['TopicName'] = topicName;
    data['UserID'] = ParsingHelper.parseStringMethod(userID);
    data['SiteID'] = ParsingHelper.parseStringMethod(siteID);
    data['LocaleID'] = localeID;
    data['NoofReplies'] = ParsingHelper.parseStringMethod(noofReplies);
    data['LastPostedDate'] = lastPostedDate;
    data['CreatedUserID'] = ParsingHelper.parseStringMethod(createdUserID);
    data['AttachementPath'] = attachementPath;
    return data;
  }
}
