class DiscussionForumUIActionCallbackModel {
  void Function()? onAddToTopic;
  void Function()? onEdit;
  void Function()? onDelete;
  void Function()? onViewLikes;
  void Function()? onShareWithConnectionTap;
  void Function()? onShareWithPeopleTap;

  DiscussionForumUIActionCallbackModel({
    this.onAddToTopic,
    this.onEdit,
    this.onDelete,
    this.onViewLikes,
    this.onShareWithConnectionTap,
    this.onShareWithPeopleTap,
  });
}
