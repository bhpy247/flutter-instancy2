import 'package:flutter_instancy_2/models/discussion/data_model/like_user_id_model.dart';
import 'package:flutter_instancy_2/models/discussion/data_model/topic_model.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';

import '../../../utils/my_utils.dart';
import './../../../utils/parsing_helper.dart';
import 'forum_info_user_model.dart';

class ForumModel {
  String Name = "";
  String Description = "";
  String CreatedDate = "";
  String SendEmail = "";
  String Author = "";
  String DFProfileImage = "";
  String NoImageText = "";
  String ForumThumbnailPath = "";
  String DescriptionWithLimit = "";
  String ModeratorID = "";
  String UpdatedAuthor = "";
  String UpdatedDate = "";
  String ModeratorName = "";
  String DescriptionWithoutLimit = "";
  String CategoryIDs = "";
  String MappedContentNames = "";
  int ForumID = 0;
  int ParentForumID = 0;
  int DisplayOrder = 0;
  int SiteID = 0;
  int CreatedUserID = 0;
  int NoOfTopics = 0;
  int TotalPosts = 0;
  int Existing = 0;
  int totalLikeUserCount = 0;
  bool Active = false;
  bool RequiresSubscription = false;
  bool CreateNewTopic = false;
  bool AttachFile = false;
  bool LikePosts = false;
  bool Moderation = false;
  bool IsPrivate = false;
  bool AllowShare = false;
  bool AllowPin = false;
  bool CreateNewTopicEditValue = false;
  bool LikePostsEditValue = false;
  bool AttachFileEditValue = false;
  bool AllowShareEditValue = false;
  bool AllowPinEditValue = false;
  DateTime? DFUpdateTime;
  DateTime? DFChangeUpdateTime;
  DateTime? CreatedDateTime;
  List<LikeUserIDModel> TotalLikes = <LikeUserIDModel>[];
  List<TopicModel> MainTopicsList = List<TopicModel>.empty(growable: true);
  List<TopicModel> PinnedTopicsList = List<TopicModel>.empty(growable: true);
  List<TopicModel> UnpinnedTopicsList = List<TopicModel>.empty(growable: true);
  List<ForumUserInfoModel> likeUserList = <ForumUserInfoModel>[];
  bool isLoadingTopics = false;
  bool isLikedByMe = false;

  ForumModel({
    this.Name = "",
    this.Description = "",
    this.CreatedDate = "",
    this.SendEmail = "",
    this.Author = "",
    this.DFProfileImage = "",
    this.NoImageText = "",
    this.ForumThumbnailPath = "",
    this.DescriptionWithLimit = "",
    this.ModeratorID = "",
    this.UpdatedAuthor = "",
    this.UpdatedDate = "",
    this.ModeratorName = "",
    this.DescriptionWithoutLimit = "",
    this.CategoryIDs = "",
    this.MappedContentNames = "",
    this.ForumID = 0,
    this.ParentForumID = 0,
    this.DisplayOrder = 0,
    this.SiteID = 0,
    this.CreatedUserID = 0,
    this.NoOfTopics = 0,
    this.TotalPosts = 0,
    this.Existing = 0,
    this.totalLikeUserCount = 0,
    this.Active = false,
    this.RequiresSubscription = false,
    this.CreateNewTopic = false,
    this.AttachFile = false,
    this.LikePosts = false,
    this.Moderation = false,
    this.IsPrivate = false,
    this.AllowShare = false,
    this.AllowPin = false,
    this.CreateNewTopicEditValue = false,
    this.LikePostsEditValue = false,
    this.AttachFileEditValue = false,
    this.AllowShareEditValue = false,
    this.AllowPinEditValue = false,
    this.DFUpdateTime,
    this.DFChangeUpdateTime,
    List<LikeUserIDModel>? TotalLikes,
    List<TopicModel>? MainTopicsList,
    List<ForumUserInfoModel>? likeUserList,
    this.isLoadingTopics = false,
  }) {
    this.TotalLikes = TotalLikes ?? <LikeUserIDModel>[];
    this.MainTopicsList = MainTopicsList ?? List<TopicModel>.empty(growable: true);
    this.likeUserList = likeUserList ?? <ForumUserInfoModel>[];
  }

  ForumModel.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> json) {
    Name = ParsingHelper.parseStringMethod(json["Name"]);
    Description = ParsingHelper.parseStringMethod(json["Description"]);
    CreatedDate = ParsingHelper.parseStringMethod(json["CreatedDate"]);
    SendEmail = ParsingHelper.parseStringMethod(json["SendEmail"]);
    Author = ParsingHelper.parseStringMethod(json["Author"]);
    DFProfileImage = ParsingHelper.parseStringMethod(json["DFProfileImage"]);
    NoImageText = ParsingHelper.parseStringMethod(json["NoImageText"]);
    ForumThumbnailPath = ParsingHelper.parseStringMethod(json["ForumThumbnailPath"]);
    DescriptionWithLimit = ParsingHelper.parseStringMethod(json["DescriptionWithLimit"]);
    ModeratorID = ParsingHelper.parseStringMethod(json["ModeratorID"]);
    UpdatedAuthor = ParsingHelper.parseStringMethod(json["UpdatedAuthor"]);
    UpdatedDate = ParsingHelper.parseStringMethod(json["UpdatedDate"]);
    ModeratorName = ParsingHelper.parseStringMethod(json["ModeratorName"]);
    DescriptionWithoutLimit = ParsingHelper.parseStringMethod(json["DescriptionWithoutLimit"]);
    CategoryIDs = ParsingHelper.parseStringMethod(json["CategoryIDs"]);
    MappedContentNames = ParsingHelper.parseStringMethod(json["MappedContentNames"]);
    ForumID = ParsingHelper.parseIntMethod(json["ForumID"]);
    ParentForumID = ParsingHelper.parseIntMethod(json["ParentForumID"]);
    DisplayOrder = ParsingHelper.parseIntMethod(json["DisplayOrder"]);
    SiteID = ParsingHelper.parseIntMethod(json["SiteID"]);
    CreatedUserID = ParsingHelper.parseIntMethod(json["CreatedUserID"]);
    NoOfTopics = ParsingHelper.parseIntMethod(json["NoOfTopics"]);
    TotalPosts = ParsingHelper.parseIntMethod(json["TotalPosts"]);
    Existing = ParsingHelper.parseIntMethod(json["Existing"]);
    Active = ParsingHelper.parseBoolMethod(json["Active"]);
    RequiresSubscription = ParsingHelper.parseBoolMethod(json["RequiresSubscription"]);
    CreateNewTopic = ParsingHelper.parseBoolMethod(json["CreateNewTopic"]);
    AttachFile = ParsingHelper.parseBoolMethod(json["AttachFile"]);
    LikePosts = ParsingHelper.parseBoolMethod(json["LikePosts"]);
    Moderation = ParsingHelper.parseBoolMethod(json["Moderation"]);
    IsPrivate = ParsingHelper.parseBoolMethod(json["IsPrivate"]);
    AllowShare = ParsingHelper.parseBoolMethod(json["AllowShare"]);
    AllowPin = ParsingHelper.parseBoolMethod(json["AllowPin"]);
    CreateNewTopicEditValue = ParsingHelper.parseBoolMethod(json["CreateNewTopicEditValue"]);
    LikePostsEditValue = ParsingHelper.parseBoolMethod(json["LikePostsEditValue"]);
    AttachFileEditValue = ParsingHelper.parseBoolMethod(json["AttachFileEditValue"]);
    AllowShareEditValue = ParsingHelper.parseBoolMethod(json["AllowShareEditValue"]);
    AllowPinEditValue = ParsingHelper.parseBoolMethod(json["AllowPinEditValue"]);
    DFUpdateTime = ParsingHelper.parseDateTimeMethod(json["DFUpdateTime"]);
    DFChangeUpdateTime = ParsingHelper.parseDateTimeMethod(json["DFChangeUpdateTime"]);
    CreatedDateTime = ParsingHelper.parseDateTimeMethod(CreatedDate);

    TotalLikes.clear();
    List<Map<String, dynamic>> TotalLikesMapsList = ParsingHelper.parseMapsListMethod(json["TotalLikes"]);
    TotalLikes.addAll(TotalLikesMapsList.map((e) => LikeUserIDModel.fromJson(e)).toList());
    calculateLikeUserCount();

    MainTopicsList.clear();
    calculatePinnedTopics();
    isLoadingTopics = false;
  }

  void calculateLikeUserCount() {
    totalLikeUserCount = TotalLikes.map((e) => e.UserID).toList().toSet().length;
  }

  void calculatePinnedTopics() {
    PinnedTopicsList.clear();
    UnpinnedTopicsList.clear();

    for (TopicModel topicModel in MainTopicsList) {
      if (topicModel.IsPin) {
        PinnedTopicsList.add(topicModel);
      } else {
        UnpinnedTopicsList.add(topicModel);
      }
    }

    sortTopics(false);
  }

  void sortTopics(bool isAscending) {
    UnpinnedTopicsList.sort((TopicModel a, TopicModel b) {
      MyPrint.printOnConsole("a.CreatedDateTime:${a.CreatedDateTime}, b.CreatedDateTime:${b.CreatedDateTime}");
      return a.CreatedDateTime != null && b.CreatedDateTime != null ? (isAscending ? a.CreatedDateTime!.compareTo(b.CreatedDateTime!) : b.CreatedDateTime!.compareTo(a.CreatedDateTime!)) : 0;
    });
  }

  Map<String, dynamic> toJson() {
    return {
      "Name": Name,
      "Description": Description,
      "CreatedDate": CreatedDate,
      "SendEmail": SendEmail,
      "Author": Author,
      "DFProfileImage": DFProfileImage,
      "NoImageText": NoImageText,
      "ForumThumbnailPath": ForumThumbnailPath,
      "DescriptionWithLimit": DescriptionWithLimit,
      "ModeratorID": ModeratorID,
      "UpdatedAuthor": UpdatedAuthor,
      "UpdatedDate": UpdatedDate,
      "ModeratorName": ModeratorName,
      "DescriptionWithoutLimit": DescriptionWithoutLimit,
      "CategoryIDs": CategoryIDs,
      "MappedContentNames": MappedContentNames,
      "ForumID": ForumID,
      "ParentForumID": ParentForumID,
      "DisplayOrder": DisplayOrder,
      "SiteID": SiteID,
      "CreatedUserID": CreatedUserID,
      "NoOfTopics": NoOfTopics,
      "TotalPosts": TotalPosts,
      "Existing": Existing,
      "Active": Active,
      "RequiresSubscription": RequiresSubscription,
      "CreateNewTopic": CreateNewTopic,
      "AttachFile": AttachFile,
      "LikePosts": LikePosts,
      "Moderation": Moderation,
      "IsPrivate": IsPrivate,
      "AllowShare": AllowShare,
      "AllowPin": AllowPin,
      "CreateNewTopicEditValue": CreateNewTopicEditValue,
      "LikePostsEditValue": LikePostsEditValue,
      "AttachFileEditValue": AttachFileEditValue,
      "AllowShareEditValue": AllowShareEditValue,
      "AllowPinEditValue": AllowPinEditValue,
      "DFUpdateTime": DFUpdateTime,
      "DFChangeUpdateTime": DFChangeUpdateTime,
      "TotalLikes": TotalLikes.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
