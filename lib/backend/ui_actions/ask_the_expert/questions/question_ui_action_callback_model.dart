class QuestionsUIActionCallbackModel {
  void Function()? onAddAnswer;
  void Function()? onEdit;
  void Function()? onDelete;
  void Function()? onViewLikes;
  void Function()? onShareWithConnectionTap;
  void Function()? onShareWithPeopleTap;

  QuestionsUIActionCallbackModel({
    this.onAddAnswer,
    this.onEdit,
    this.onDelete,
    this.onViewLikes,
    this.onShareWithConnectionTap,
    this.onShareWithPeopleTap,
  });
}
