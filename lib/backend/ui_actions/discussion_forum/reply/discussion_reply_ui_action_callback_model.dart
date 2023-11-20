class DiscussionReplyUIActionCallbackModel {
  void Function()? onAddReplyTap;
  void Function()? onDeleteTap;
  void Function()? onEditTap;

  DiscussionReplyUIActionCallbackModel({
    this.onAddReplyTap,
    this.onDeleteTap,
    this.onEditTap,
  });
}
