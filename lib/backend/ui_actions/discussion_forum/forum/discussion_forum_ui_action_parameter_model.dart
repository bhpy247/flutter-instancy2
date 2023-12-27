class DiscussionForumUiActionParameterModel {
  final int CreatedUserID;
  final bool CreateNewTopic;
  final bool LikePosts;
  final bool AllowShare;
  final bool CreateNewTopicEditValue;
  final bool LikePostsEditValue;
  final bool AttachFileEditValue;
  final bool AllowShareEditValue;
  final bool AllowPinEditValue;

  const DiscussionForumUiActionParameterModel({
    this.CreatedUserID = 0,
    this.CreateNewTopic = false,
    this.LikePosts = false,
    this.AllowShare = false,
    this.CreateNewTopicEditValue = false,
    this.LikePostsEditValue = false,
    this.AttachFileEditValue = false,
    this.AllowShareEditValue = false,
    this.AllowPinEditValue = false,
  });
}
