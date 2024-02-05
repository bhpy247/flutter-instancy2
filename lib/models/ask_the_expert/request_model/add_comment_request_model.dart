import 'dart:typed_data';

import '../../../utils/parsing_helper.dart';
import '../../common/Instancy_multipart_file_upload_model.dart';

class AddCommentRequestModel {
  String UserCommentImage = "";
  String Comment = "";
  String Locale = "";
  String Response = "";
  String UserName = "";
  int siteID = 0;
  int userID = 0;
  int ResponseID = 0;
  int QuestionID = 0;
  int CommentID = 0;
  int CommentStatus = 0;
  bool IsRemoveCommentImage = false;
  Uint8List? strAttachFileBytes;
  List<InstancyMultipartFileUploadModel>? fileUploads;

  AddCommentRequestModel(
      {this.UserCommentImage = "",
      this.Comment = "",
      this.Locale = "",
      this.Response = "",
      this.UserName = "",
      this.siteID = 0,
      this.userID = 0,
      this.ResponseID = 0,
      this.QuestionID = 0,
      this.CommentID = 0,
      this.CommentStatus = 0,
      this.IsRemoveCommentImage = false,
      this.strAttachFileBytes,
      this.fileUploads});

  AddCommentRequestModel.fromJson(Map<String, dynamic> json) {
    UserCommentImage = ParsingHelper.parseStringMethod(json['UserCommentImage']);
    Comment = ParsingHelper.parseStringMethod(json['Comment']);
    Locale = ParsingHelper.parseStringMethod(json['Locale']);
    Response = ParsingHelper.parseStringMethod(json['Response']);
    UserName = ParsingHelper.parseStringMethod(json['UserName']);
    siteID = ParsingHelper.parseIntMethod(json['SiteID']);
    userID = ParsingHelper.parseIntMethod(json['UserID']);
    ResponseID = ParsingHelper.parseIntMethod(json['ResponseID']);
    QuestionID = ParsingHelper.parseIntMethod(json['QuestionID']);
    CommentID = ParsingHelper.parseIntMethod(json['CommentID']);
    CommentStatus = ParsingHelper.parseIntMethod(json['CommentStatus']);
    IsRemoveCommentImage = ParsingHelper.parseBoolMethod(json['IsRemoveCommentImage']);
  }

  Map<String, String> toJson() {
    return {
      'UserCommentImage': UserCommentImage,
      'Comment': Comment,
      'Locale': Locale,
      'Response': Response,
      'UserName': UserName,
      'SiteID': ParsingHelper.parseStringMethod(siteID),
      'UserID': ParsingHelper.parseStringMethod(userID),
      'ResponseID': ParsingHelper.parseStringMethod(ResponseID),
      'QuestionID': ParsingHelper.parseStringMethod(QuestionID),
      'CommentID': ParsingHelper.parseStringMethod(CommentID),
      'CommentStatus': ParsingHelper.parseStringMethod(CommentStatus),
      'IsRemoveCommentImage': ParsingHelper.parseStringMethod(IsRemoveCommentImage)
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
