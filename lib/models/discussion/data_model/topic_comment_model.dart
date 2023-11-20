import 'package:flutter_chat_bot/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/models/discussion/data_model/comment_reply_model.dart';

import 'forum_info_user_model.dart';

class TopicCommentModel {
  String topicid = "";
  String posteddate = "";
  String message = "";
  String ReplyID = "";
  String CommentedBy = "";
  String CommentedFromDays = "";
  String CommentFileUploadPath = "";
  String CommentFileUploadName = "";
  String CommentImageUploadName = "";
  String CommentUploadIconPath = "";
  String CommentUserProfile = "";
  int commentid = 0;
  int forumid = 0;
  int postedby = 0;
  int siteid = 0;
  int CommentLikes = 0;
  int CommentRepliesCount = 0;
  bool likeState = false;
  String NoImageText = "";
  String LikedUserList = '';
  List<CommentReplyModel> repliesList = <CommentReplyModel>[];
  List<ForumUserInfoModel> userLikeList = <ForumUserInfoModel>[];
  bool isLoadingReplies = false;

  TopicCommentModel({
    this.topicid = "",
    this.posteddate = "",
    this.message = "",
    this.ReplyID = "",
    this.CommentedBy = "",
    this.CommentedFromDays = "",
    this.CommentFileUploadPath = "",
    this.CommentFileUploadName = "",
    this.CommentImageUploadName = "",
    this.CommentUploadIconPath = "",
    this.CommentUserProfile = "",
    this.NoImageText = "",
    this.LikedUserList = "",
    this.commentid = 0,
    this.forumid = 0,
    this.postedby = 0,
    this.siteid = 0,
    this.CommentLikes = 0,
    this.CommentRepliesCount = 0,
    this.likeState = false,
    List<CommentReplyModel>? repliesList,
    List<ForumUserInfoModel>? userLikeList,
    this.isLoadingReplies = false,
  }) {
    this.repliesList = repliesList ?? <CommentReplyModel>[];
    this.userLikeList = userLikeList ?? <ForumUserInfoModel>[];
  }

  TopicCommentModel.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> json) {
    topicid = ParsingHelper.parseStringMethod(json['topicid']);

    posteddate = ParsingHelper.parseStringMethod(json['posteddate']);
    message = ParsingHelper.parseStringMethod(json['message']);

    ReplyID = ParsingHelper.parseStringMethod(json['ReplyID']);
    CommentedBy = ParsingHelper.parseStringMethod(json['CommentedBy']);
    CommentedFromDays = ParsingHelper.parseStringMethod(json['CommentedFromDays']);
    CommentFileUploadPath = ParsingHelper.parseStringMethod(json['CommentFileUploadPath']);
    CommentFileUploadName = ParsingHelper.parseStringMethod(json['CommentFileUploadName']);
    CommentImageUploadName = ParsingHelper.parseStringMethod(json['CommentImageUploadName']);
    CommentUploadIconPath = ParsingHelper.parseStringMethod(json['CommentUploadIconPath']);
    CommentUserProfile = ParsingHelper.parseStringMethod(json['CommentUserProfile']);
    NoImageText = ParsingHelper.parseStringMethod(json['NoImageText']);
    LikedUserList = ParsingHelper.parseStringMethod(json['LikedUserList']);
    forumid = ParsingHelper.parseIntMethod(json['forumid']);
    commentid = ParsingHelper.parseIntMethod(json['commentid']);
    postedby = ParsingHelper.parseIntMethod(json['postedby']);
    siteid = ParsingHelper.parseIntMethod(json['siteid']);
    CommentLikes = ParsingHelper.parseIntMethod(json['CommentLikes']);
    CommentRepliesCount = ParsingHelper.parseIntMethod(json['CommentRepliesCount']);
    likeState = ParsingHelper.parseBoolMethod(json['likeState']);

    repliesList.clear();
    isLoadingReplies = false;
  }

  Map<String, dynamic> toJson() {
    return {
      'commentid': commentid,
      'topicid': topicid,
      'forumid': forumid,
      'posteddate': posteddate,
      'message': message,
      'postedby': postedby,
      'siteid': siteid,
      'ReplyID': ReplyID,
      'CommentedBy': CommentedBy,
      'CommentedFromDays': CommentedFromDays,
      'CommentFileUploadPath': CommentFileUploadPath,
      'CommentFileUploadName': CommentFileUploadName,
      'CommentImageUploadName': CommentImageUploadName,
      'CommentUploadIconPath': CommentUploadIconPath,
      'likeState': likeState,
      'CommentLikes': CommentLikes,
      'CommentRepliesCount': CommentRepliesCount,
      'CommentUserProfile': CommentUserProfile,
      'NoImageText': NoImageText,
      'LikedUserList': LikedUserList,
    };
  }
}
