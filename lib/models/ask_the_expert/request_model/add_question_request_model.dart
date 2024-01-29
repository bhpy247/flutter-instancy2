import 'dart:typed_data';

import '../../../utils/parsing_helper.dart';
import '../../common/Instancy_multipart_file_upload_model.dart';

class AddQuestionRequestModel {
  String UserResponseImageName = "";
  String UserEmail = "";
  String Locale = "";
  String Response = "";
  String UserName = "";
  String UserQuestion = "";
  String UserQuestionDesc = "";
  String UseruploadedImageName = "";
  String skills = "";
  String SeletedSkillIds = "";
  int siteID = 0;
  int userID = 0;
  int ResponseID = 0;
  int QuestionID = 0;
  int QuestionTypeID = 0;
  int EditQueID = 0;
  bool IsRemoveEditimage = false;
  Uint8List? strAttachFileBytes;
  List<InstancyMultipartFileUploadModel>? fileUploads;

  AddQuestionRequestModel(
      {this.UserResponseImageName = "",
      this.UserEmail = "",
      this.Locale = "",
      this.Response = "",
      this.UserName = "",
      this.UserQuestion = "",
      this.UserQuestionDesc = "",
      this.UseruploadedImageName = "",
      this.skills = "",
      this.SeletedSkillIds = "",
      this.siteID = 0,
      this.userID = 0,
      this.EditQueID = 0,
      this.QuestionTypeID = 0,
      this.ResponseID = 0,
      this.QuestionID = 0,
      this.IsRemoveEditimage = false,
      this.strAttachFileBytes,
      this.fileUploads});

  AddQuestionRequestModel.fromJson(Map<String, dynamic> json) {
    UserResponseImageName = ParsingHelper.parseStringMethod(json['UserResponseImageName']);
    UserEmail = ParsingHelper.parseStringMethod(json['UserEmail']);
    UserName = ParsingHelper.parseStringMethod(json['UserName']);
    siteID = ParsingHelper.parseIntMethod(json['SiteID']);
    userID = ParsingHelper.parseIntMethod(json['UserID']);
    IsRemoveEditimage = ParsingHelper.parseBoolMethod(json['IsRemoveEditimage']);
    QuestionTypeID = ParsingHelper.parseIntMethod(json['QuestionTypeID']);
    UserQuestion = ParsingHelper.parseStringMethod(json['UserQuestion']);
    UserQuestionDesc = ParsingHelper.parseStringMethod(json['UserQuestionDesc']);
    UseruploadedImageName = ParsingHelper.parseStringMethod(json['UseruploadedImageName']);
    skills = ParsingHelper.parseStringMethod(json['skills']);
    SeletedSkillIds = ParsingHelper.parseStringMethod(json['SeletedSkillIds']);
    EditQueID = ParsingHelper.parseIntMethod(json['EditQueID']);
  }

  Map<String, String> toJson() {
    return {
      'UseruploadedImageName': UseruploadedImageName,
      'UserEmail': UserEmail,
      'SeletedSkillIds': SeletedSkillIds,
      'UserQuestionDesc': UserQuestionDesc,
      'UserQuestion': UserQuestion,
      'skills': skills,
      'UserName': UserName,
      'SiteID': ParsingHelper.parseStringMethod(siteID),
      'UserID': ParsingHelper.parseStringMethod(userID),
      'EditQueID': ParsingHelper.parseStringMethod(EditQueID),
      'QuestionTypeID': ParsingHelper.parseStringMethod(QuestionTypeID),
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
