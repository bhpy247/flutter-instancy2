import 'dart:typed_data';

import '../../../utils/parsing_helper.dart';
import '../../common/Instancy_multipart_file_upload_model.dart';

class AddTopicRequestModel {
  String strAttachFile = "";
  String strContentID = "";
  String description = "";
  String localeID = "";
  String title = "";
  String forumName = "";
  int siteID = 0;
  int userID = 0;
  int orgID = 0;
  int forumID = 0;
  Uint8List? strAttachFileBytes;

  AddTopicRequestModel({
    this.strAttachFile = "",
    this.strContentID = "",
    this.description = "",
    this.localeID = "",
    this.title = "",
    this.forumName = "",
    this.siteID = 0,
    this.userID = 0,
    this.orgID = 0,
    this.forumID = 0,
    this.strAttachFileBytes,
  });

  AddTopicRequestModel.fromJson(Map<String, dynamic> json) {
    strAttachFile = ParsingHelper.parseStringMethod(json['strAttachFile']);
    strContentID = ParsingHelper.parseStringMethod(json['strContentID']);
    description = ParsingHelper.parseStringMethod(json['Description']);
    localeID = ParsingHelper.parseStringMethod(json['LocaleID']);
    title = ParsingHelper.parseStringMethod(json['Title']);
    forumName = ParsingHelper.parseStringMethod(json['ForumName']);
    siteID = ParsingHelper.parseIntMethod(json['SiteID']);
    userID = ParsingHelper.parseIntMethod(json['UserID']);
    orgID = ParsingHelper.parseIntMethod(json['OrgID']);
    forumID = ParsingHelper.parseIntMethod(json['ForumID']);
  }

  Map<String, String> toJson() {
    return {
      'strAttachFile': strAttachFile,
      'strContentID': strContentID,
      'Description': description,
      'LocaleID': localeID,
      'Title': title,
      'ForumName': forumName,
      'SiteID': ParsingHelper.parseStringMethod(siteID),
      'UserID': ParsingHelper.parseStringMethod(userID),
      'OrgID': ParsingHelper.parseStringMethod(orgID),
      'ForumID': ParsingHelper.parseStringMethod(forumID)
    };
  }
}

class UploadForumAttachmentModel {
  String strLocale = "";
  int siteID = 0;
  int userID = 0;
  String topicId = "";
  String ReplyID = "";
  bool isTopic = false;
  List<InstancyMultipartFileUploadModel>? fileUploads;

  UploadForumAttachmentModel({
    this.strLocale = "",
    this.siteID = 0,
    this.userID = 0,
    this.topicId = "",
    this.ReplyID = "",
    this.fileUploads,
    this.isTopic = false,
  });

  UploadForumAttachmentModel.fromJson(Map<String, dynamic> json) {
    strLocale = ParsingHelper.parseStringMethod(json['strLocale']);
    siteID = ParsingHelper.parseIntMethod(json['intSiteID']);
    userID = ParsingHelper.parseIntMethod(json['intUserID']);
    topicId = ParsingHelper.parseStringMethod(json['TopicID']);
    ReplyID = ParsingHelper.parseStringMethod(json['ReplyID']);
    isTopic = ParsingHelper.parseBoolMethod(json['isTopic']);
  }

  Map<String, String> toJson() {
    return {
      'strLocale': strLocale,
      'intSiteID': ParsingHelper.parseStringMethod(siteID),
      'intUserID': ParsingHelper.parseStringMethod(userID),
      'ReplyID': ParsingHelper.parseStringMethod(ReplyID),
      'TopicID': ParsingHelper.parseStringMethod(topicId),
      'isTopic': ParsingHelper.parseStringMethod(isTopic),
    };
  }
}
