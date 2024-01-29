import 'dart:typed_data';

import '../../../utils/parsing_helper.dart';
import '../../common/Instancy_multipart_file_upload_model.dart';

class AddAnswerRequestModel {
  String UserResponseImageName = "";
  String UserEmail = "";
  String Locale = "";
  String Response = "";
  String UserName = "";
  int siteID = 0;
  int userID = 0;
  int ResponseID = 0;
  int QuestionID = 0;
  bool IsRemoveEditimage = false;
  Uint8List? strAttachFileBytes;
  List<InstancyMultipartFileUploadModel>? fileUploads;

  AddAnswerRequestModel(
      {this.UserResponseImageName = "",
      this.UserEmail = "",
      this.Locale = "",
      this.Response = "",
      this.UserName = "",
      this.siteID = 0,
      this.userID = 0,
      this.ResponseID = 0,
      this.QuestionID = 0,
      this.IsRemoveEditimage = false,
      this.strAttachFileBytes,
      this.fileUploads});

  AddAnswerRequestModel.fromJson(Map<String, dynamic> json) {
    UserResponseImageName = ParsingHelper.parseStringMethod(json['UserResponseImageName']);
    UserEmail = ParsingHelper.parseStringMethod(json['UserEmail']);
    Locale = ParsingHelper.parseStringMethod(json['Locale']);
    Response = ParsingHelper.parseStringMethod(json['Response']);
    UserName = ParsingHelper.parseStringMethod(json['UserName']);
    siteID = ParsingHelper.parseIntMethod(json['SiteID']);
    userID = ParsingHelper.parseIntMethod(json['UserID']);
    ResponseID = ParsingHelper.parseIntMethod(json['ResponseID']);
    QuestionID = ParsingHelper.parseIntMethod(json['QuestionID']);
    IsRemoveEditimage = ParsingHelper.parseBoolMethod(json['IsRemoveEditimage']);
  }

  Map<String, String> toJson() {
    return {
      'UserResponseImageName': UserResponseImageName,
      'UserEmail': UserEmail,
      'Locale': Locale,
      'Response': Response,
      'UserName': UserName,
      'SiteID': ParsingHelper.parseStringMethod(siteID),
      'UserID': ParsingHelper.parseStringMethod(userID),
      'ResponseID': ParsingHelper.parseStringMethod(ResponseID),
      'QuestionID': ParsingHelper.parseStringMethod(QuestionID),
      'IsRemoveEditimage': ParsingHelper.parseStringMethod(IsRemoveEditimage)
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
