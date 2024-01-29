import 'dart:typed_data';

import '../../../utils/parsing_helper.dart';
import '../../common/Instancy_multipart_file_upload_model.dart';

class UpdateFeedbackRequestModel {
  String feedbackTitle = "";
  String feedbackdesc = "";
  String imageFileName = "";
  String currentUrl = "";
  String image = "";
  String date2 = "";
  int currentsiteid = 0;
  int currentuserid = 0;
  Uint8List? strAttachFileBytes;
  List<InstancyMultipartFileUploadModel>? fileUploads;

  UpdateFeedbackRequestModel({
    this.feedbackTitle = "",
    this.feedbackdesc = "",
    this.imageFileName = "",
    this.currentUrl = "",
    this.image = "",
    this.date2 = "",
    this.currentsiteid = 0,
    this.currentuserid = 0,
    this.strAttachFileBytes,
    this.fileUploads = const [],
  });

  UpdateFeedbackRequestModel.fromJson(Map<String, dynamic> json) {
    feedbackTitle = ParsingHelper.parseStringMethod(json['feedbackTitle']);
    feedbackdesc = ParsingHelper.parseStringMethod(json['feedbackdesc']);
    imageFileName = ParsingHelper.parseStringMethod(json['imageFileName']);
    currentUrl = ParsingHelper.parseStringMethod(json['currentUrl']);
    image = ParsingHelper.parseStringMethod(json['image']);
    date2 = ParsingHelper.parseStringMethod(json['date2']);
    currentsiteid = ParsingHelper.parseIntMethod(json['currentsiteid']);
    currentuserid = ParsingHelper.parseIntMethod(json['currentuserid']);
  }

  Map<String, String> toJson() {
    return {
      'FeedbackTitle': feedbackTitle,
      'Feedbackdesc': '"$feedbackdesc"',
      'ImageFileName': imageFileName,
      'CurrentUrl': currentUrl,
      'Date2': date2,
      'currentsiteid': ParsingHelper.parseStringMethod(currentsiteid),
      'currentuserid': ParsingHelper.parseStringMethod(currentuserid),
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
