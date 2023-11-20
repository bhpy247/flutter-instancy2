class DiscussionCommentUIActionCallbackModel {
  void Function()? onAddReplyTap;
  void Function()? onDeleteTap;
  void Function()? onEditTap;
  void Function()? onViewLikesTap;

  DiscussionCommentUIActionCallbackModel({
    this.onAddReplyTap,
    this.onDeleteTap,
    this.onEditTap,
    this.onViewLikesTap,
  });
}
