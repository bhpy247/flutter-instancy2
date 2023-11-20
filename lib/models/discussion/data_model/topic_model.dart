import 'package:flutter_chat_bot/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/models/discussion/data_model/topic_comment_model.dart';

import '../../../utils/my_utils.dart';
import 'forum_info_user_model.dart';

class TopicModel {
  String ContentID = "";
  String Name = "";
  String CreatedDate = "";
  String LongDescription = "";
  String LatestReplyBy = "";
  String Author = "";
  String UploadFileName = "";
  String UpdatedTime = "";
  String CreatedTime = "";
  String ModifiedUserName = "";
  String UploadedImageName = "";
  String TopicImageUploadName = "";
  String TopicUploadIconPath = "";
  String TopicUserProfile = "";
  String Comments = "";
  String LikedUserList = "";
  int CreatedUserID = 0;
  int NoOfReplies = 0;
  int NoOfViews = 0;
  int PinID = 0;
  int Likes = 0;
  bool IsPin = false;
  bool likeState = false;
  List<TopicCommentModel> commentList = <TopicCommentModel>[];
  List<ForumUserInfoModel> userLikeList = <ForumUserInfoModel>[];
  bool isLoadingComments = false;
  DateTime? CreatedDateTime;

  TopicModel({
    this.ContentID = "",
    this.Name = "",
    this.CreatedDate = "",
    this.LongDescription = "",
    this.LatestReplyBy = "",
    this.Author = "",
    this.UploadFileName = "",
    this.UpdatedTime = "",
    this.CreatedTime = "",
    this.ModifiedUserName = "",
    this.UploadedImageName = "",
    this.TopicImageUploadName = "",
    this.TopicUploadIconPath = "",
    this.TopicUserProfile = "",
    this.Comments = "",
    this.LikedUserList = "",
    this.CreatedUserID = 0,
    this.NoOfReplies = 0,
    this.NoOfViews = 0,
    this.PinID = 0,
    this.Likes = 0,
    this.IsPin = false,
    this.likeState = false,
    List<TopicCommentModel>? commentList,
    List<ForumUserInfoModel>? userLikeList,
    this.isLoadingComments = false,
  }) {
    this.commentList = commentList ?? <TopicCommentModel>[];
    this.userLikeList = userLikeList ?? <ForumUserInfoModel>[];
  }

  TopicModel.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> map) {
    ContentID = ParsingHelper.parseStringMethod(map['ContentID']);
    Name = ParsingHelper.parseStringMethod(map['Name']);
    CreatedDate = ParsingHelper.parseStringMethod(map['CreatedDate']);
    LongDescription = ParsingHelper.parseStringMethod(map['LongDescription']);
    LatestReplyBy = ParsingHelper.parseStringMethod(map['LatestReplyBy']);
    Author = ParsingHelper.parseStringMethod(map['Author']);
    UploadFileName = ParsingHelper.parseStringMethod(map['UploadFileName']);
    UpdatedTime = ParsingHelper.parseStringMethod(map['UpdatedTime']);
    CreatedTime = ParsingHelper.parseStringMethod(map['CreatedTime']);
    ModifiedUserName = ParsingHelper.parseStringMethod(map['ModifiedUserName']);
    UploadedImageName = ParsingHelper.parseStringMethod(map['UploadedImageName']);
    TopicImageUploadName = ParsingHelper.parseStringMethod(map['TopicImageUploadName']);
    TopicUploadIconPath = ParsingHelper.parseStringMethod(map['TopicUploadIconPath']);
    TopicUserProfile = ParsingHelper.parseStringMethod(map['TopicUserProfile']);
    Comments = ParsingHelper.parseStringMethod(map['Comments']);
    LikedUserList = ParsingHelper.parseStringMethod(map['LikedUserList']);
    CreatedUserID = ParsingHelper.parseIntMethod(map['CreatedUserID']);
    NoOfReplies = ParsingHelper.parseIntMethod(map['NoOfReplies']);
    NoOfViews = ParsingHelper.parseIntMethod(map['NoOfViews']);
    PinID = ParsingHelper.parseIntMethod(map['PinID']);
    Likes = ParsingHelper.parseIntMethod(map['Likes']);
    IsPin = ParsingHelper.parseBoolMethod(map['IsPin']);
    likeState = ParsingHelper.parseBoolMethod(map['likeState']);

    CreatedDateTime = ParsingHelper.parseDateTimeMethod(CreatedDate);

    commentList.clear();
    isLoadingComments = false;
  }

  Map<String, dynamic> toJson() {
    return {
      "ContentID": ContentID,
      "Name": Name,
      "createdDate": CreatedDate,
      "longDescription": LongDescription,
      "latestReplyBy": LatestReplyBy,
      "author": Author,
      "uploadFileName": UploadFileName,
      "updatedTime": UpdatedTime,
      "createdTime": CreatedTime,
      "modifiedUserName": ModifiedUserName,
      "uploadedImageName": UploadedImageName,
      "topicImageUploadName": TopicImageUploadName,
      "topicUploadIconPath": TopicUploadIconPath,
      "topicUserProfile": TopicUserProfile,
      "comments": Comments,
      "likedUserList": LikedUserList,
      "createdUserID": CreatedUserID,
      "noOfReplies": NoOfReplies,
      "noOfViews": NoOfViews,
      "pinID": PinID,
      "likes": Likes,
      "isPin": IsPin,
      "likeState": likeState,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
