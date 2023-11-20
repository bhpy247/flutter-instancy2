class DiscussionForumUiActionParameterModel {
  final int CreatedUserID;
  final bool CreateNewTopic;
  final bool LikePosts;
  final bool AllowShare;

  const DiscussionForumUiActionParameterModel({
    this.CreatedUserID = 0,
    this.CreateNewTopic = false,
    this.LikePosts = false,
    this.AllowShare = false,
  });
}
