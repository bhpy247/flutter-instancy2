import 'package:flutter_chat_bot/utils/parsing_helper.dart';

import '../../common/Instancy_multipart_file_upload_model.dart';

class CreateDiscussionForumRequestModel {
  String locale;
  String Name;
  String Description;
  String SendEmail;
  String ForumThumbnailName;
  String CreatedDate;
  String UpdatedDate;
  String CategoryIDs;
  String ModeratorID;
  String thumbnailUrl;
  int ParentForumID;
  int SiteID;
  int CreatedUserID;
  int UpdatedUserID;
  int ForumID;
  bool IsPrivate;
  bool RequiresSubscription;
  bool LikePosts;
  bool Moderation;
  bool AllowShare;
  bool AllowPinTopic;
  bool CreateNewTopic;
  bool AttachFile;
  List<InstancyMultipartFileUploadModel>? fileUploads;

  CreateDiscussionForumRequestModel({
    this.locale = "",
    this.Name = "",
    this.Description = "",
    this.SendEmail = "",
    this.ForumThumbnailName = "",
    this.CreatedDate = "",
    this.UpdatedDate = "",
    this.CategoryIDs = "",
    this.ModeratorID = "",
    this.thumbnailUrl = "",
    this.ParentForumID = 0,
    this.SiteID = 0,
    this.CreatedUserID = 0,
    this.UpdatedUserID = 0,
    this.ForumID = 0,
    this.IsPrivate = false,
    this.RequiresSubscription = false,
    this.LikePosts = false,
    this.Moderation = false,
    this.AllowPinTopic = false,
    this.AllowShare = false,
    this.AttachFile = false,
    this.CreateNewTopic = false,
    this.fileUploads = const [],
  });

  Map<String, String> toJson() {
    return {
      'locale': locale,
      'ForumID': ParsingHelper.parseStringMethod(ForumID),
      'Name': Name,
      'Description': Description,
      'SendEmail': SendEmail,
      'CreateNewTopic': ParsingHelper.parseStringMethod(CreateNewTopic),
      'ForumThumbnailName': ForumThumbnailName,
      'AttachFile': ParsingHelper.parseStringMethod(AttachFile),
      'ParentForumID': ParsingHelper.parseStringMethod(ParentForumID),
      'SiteID': ParsingHelper.parseStringMethod(SiteID),
      'IsPrivate': ParsingHelper.parseStringMethod(IsPrivate),
      'RequiresSubscription': ParsingHelper.parseStringMethod(RequiresSubscription),
      'LikePosts': ParsingHelper.parseStringMethod(LikePosts),
      'Moderation': ParsingHelper.parseStringMethod(Moderation),
      'CreatedUserID': ParsingHelper.parseStringMethod(CreatedUserID),
      'CreatedDate': CreatedDate,
      'AllowShare': ParsingHelper.parseStringMethod(AllowShare),
      'ModeratorID': ParsingHelper.parseStringMethod(ModeratorID),
      'UpdatedUserID': ParsingHelper.parseStringMethod(UpdatedUserID),
      'UpdatedDate': UpdatedDate,
      'CategoryIDs': CategoryIDs,
      'AllowPinTopic': ParsingHelper.parseStringMethod(AllowPinTopic),
    };
  }
}

// 'locale': language,
// 'ForumID': forumID.toString(),
// 'Name': name,
// 'Description': description,
// 'SendEmail': sendEmail,
// 'CreateNewTopic': createNewTopic.toString(),
// 'ForumThumbnailName': forumThumbnailName,
// 'AttachFile': attachFile.toString(),
// 'ParentForumID': parentForumID.toString(),
// 'SiteID': strSiteID,
// 'IsPrivate': isPrivate.toString(),
// 'RequiresSubscription': requiresSubscription.toString(),
// 'LikePosts': likePosts.toString(),
// 'Moderation': moderation.toString(),
// 'CreatedUserID': strUserID,
// 'CreatedDate': createdDate,
// 'AllowShare': allowShare.toString(),
// 'ModeratorID': moderatorID,
// 'UpdatedUserID': strUserID,
// 'UpdatedDate': updatedDate,
// 'CategoryIDs': categoryIDs,
// 'AllowPinTopic': allowPinTopic.toString(),
