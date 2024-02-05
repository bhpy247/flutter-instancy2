import 'package:flutter_chat_bot/utils/parsing_helper.dart';

class AnswerCommentDTOModel {
  List<AnswerCommentsModel> table = [];

  AnswerCommentDTOModel({this.table = const []});

  AnswerCommentDTOModel.fromJson(Map<String, dynamic> json) {
    if (json['Table'] != null) {
      table = <AnswerCommentsModel>[];
      json['Table'].forEach((v) {
        table.add(AnswerCommentsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Table'] = table.map((v) => v.toJson()).toList();
    return data;
  }
}

class AnswerCommentsModel {
  int commentID = 0;
  int commentUserID = 0;
  int commentQuestionID = 0;
  int commentResponseID = 0;
  String commentDescription = "";
  String commentImage = "";
  String commentDate = "";

  String picture = "";
  String commentedUserName = "";
  String commentedDate = "";

  String userCommentImagePath = "";
  String commentAction = "";
  String commentImageUploadName = "";
  String commentUploadIconPath = "";
  String noImageText = "";
  bool? isLiked = false;
  bool isPublic = false;

  AnswerCommentsModel({
    this.commentID = 0,
    this.commentUserID = 0,
    this.commentQuestionID = 0,
    this.commentResponseID = 0,
    this.commentDescription = "",
    this.commentImage = "",
    this.commentDate = "",
    this.picture = "",
    this.commentedUserName = "",
    this.commentedDate = "",
    this.userCommentImagePath = "",
    this.commentAction = "",
    this.commentImageUploadName = "",
    this.commentUploadIconPath = "",
    this.noImageText = "",
    this.isLiked = false,
    this.isPublic = false,
  });

  AnswerCommentsModel.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  _initializeFromJson(Map<String, dynamic> json) {
    commentID = ParsingHelper.parseIntMethod(json['CommentID']);
    commentUserID = ParsingHelper.parseIntMethod(json['CommentUserID']);
    commentQuestionID = ParsingHelper.parseIntMethod(json['CommentQuestionID']);
    commentResponseID = ParsingHelper.parseIntMethod(json['CommentResponseID']);
    commentDescription = ParsingHelper.parseStringMethod(json['CommentDescription']);
    commentImage = ParsingHelper.parseStringMethod(json['CommentImage']);
    commentDate = ParsingHelper.parseStringMethod(json['CommentDate']);

    picture = ParsingHelper.parseStringMethod(json['Picture']);
    commentedUserName = ParsingHelper.parseStringMethod(json['CommentedUserName']);
    commentedDate = ParsingHelper.parseStringMethod(json['CommentedDate']);

    userCommentImagePath = ParsingHelper.parseStringMethod(json['UserCommentImagePath']);
    commentAction = ParsingHelper.parseStringMethod(json['CommentAction']);
    commentImageUploadName = ParsingHelper.parseStringMethod(json['CommentImageUploadName']);
    commentUploadIconPath = ParsingHelper.parseStringMethod(json['CommentUploadIconPath']);
    noImageText = ParsingHelper.parseStringMethod(json['NoImageText']);
    isLiked = ParsingHelper.parseBoolMethod(json['IsLiked']);
    isPublic = ParsingHelper.parseBoolMethod(json['IsPublic']);
  }

  Map<String, dynamic> toJson() {
    return {
      'CommentID': commentID,
      'CommentUserID': commentUserID,
      'CommentQuestionID': commentQuestionID,
      'CommentResponseID': commentResponseID,
      'CommentDescription': commentDescription,
      'CommentImage': commentImage,
      'CommentDate': commentDate,
      'Picture': picture,
      'CommentedUserName': commentedUserName,
      'CommentedDate': commentedDate,
      'UserCommentImagePath': userCommentImagePath,
      'CommentAction': commentAction,
      'CommentImageUploadName': commentImageUploadName,
      'CommentUploadIconPath': commentUploadIconPath,
      'NoImageText': noImageText,
      'IsLiked': isLiked,
      'IsPublic': isPublic,
    };
  }
}
