class DiscussionTopicUIActionCallbackModel {
  void Function()? onAddCommentTap;
  void Function()? onDeleteTap;
  void Function()? onEditTap;
  void Function()? onPinTap;
  void Function()? onUnPinTap;
  void Function()? onViewLikesTap;
  void Function()? onShareWithConnectionTap;
  void Function()? onShareWithPeopleTap;

  DiscussionTopicUIActionCallbackModel({
    this.onAddCommentTap,
    this.onDeleteTap,
    this.onEditTap,
    this.onPinTap,
    this.onUnPinTap,
    this.onViewLikesTap,
    this.onShareWithConnectionTap,
    this.onShareWithPeopleTap,
  });
}
