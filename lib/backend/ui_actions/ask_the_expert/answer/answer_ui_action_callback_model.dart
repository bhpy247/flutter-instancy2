class AnswersUIActionCallbackModel {
  void Function()? onAddCommentTap;
  void Function()? onDeleteTap;
  void Function()? onEditTap;
  void Function()? onViewLikesTap;
  void Function()? onShareWithConnectionTap;
  void Function()? onShareWithPeopleTap;

  AnswersUIActionCallbackModel({
    this.onAddCommentTap,
    this.onDeleteTap,
    this.onEditTap,
    this.onViewLikesTap,
    this.onShareWithConnectionTap,
    this.onShareWithPeopleTap,
  });
}
