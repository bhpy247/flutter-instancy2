import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';

class ShareWithPeopleRequestModel {
  String astrUserEmail = "";
  String astrUserName = "";
  String locale = "en-us";
  String subject = "";
  String message = "";
  String contentId = "";
  int forumID = 0;
  String topicID = "";
  String quesID = "";
  bool isSuggestToConnections = false;
  bool gameNotify = false;
  bool askQuestionLink = false;
  bool discussionForumLink = false;
  int siteID = 0;
  int userID = 0;
  List<String> userMails = <String>[];
  List<int> userIDList = <int>[];

  ShareWithPeopleRequestModel({
    this.astrUserEmail = "",
    this.astrUserName = "",
    this.locale = "en-us",
    this.subject = "",
    this.message = "",
    this.contentId = "",
    this.forumID = 0,
    this.topicID = "",
    this.quesID = "",
    this.isSuggestToConnections = false,
    this.gameNotify = false,
    this.askQuestionLink = false,
    this.discussionForumLink = false,
    this.siteID = 0,
    this.userID = 0,
    List<String>? userMails,
    List<int>? userIDList,
  }) {
    this.userMails = userMails ?? <String>[];
    this.userIDList = userIDList ?? <int>[];
  }

  Map<String, String> toMap() {
    return {
      'astrUserEmail': astrUserEmail,
      'astrUserName': astrUserName,
      'isSuggesttoConnections': isSuggestToConnections.toString(),
      'SiteID': siteID.toString(),
      'UserID': userID.toString(),
      'UserIDList': AppConfigurationOperations.getSeparatorJoinedStringFromStringList(list: userIDList.map((e) => e.toString()).toList()),
      'UserMails': AppConfigurationOperations.getSeparatorJoinedStringFromStringList(list: userMails),
      'Subject': subject,
      'Message': message,
      'Contentid': contentId,
      'ForumID': forumID.toString(),
      'TopicID': topicID,
      'quesID': quesID,
      "AskQuestionLink": askQuestionLink.toString(),
      "DiscusssionForumLink": !discussionForumLink ? "" : discussionForumLink.toString(),
      'LocaleID': locale,
      'GameNotify': gameNotify.toString(),
    };
  }

  @override
  String toString() {
    return "ShareWithPeopleRequestModel(${toMap()})";
  }
}
