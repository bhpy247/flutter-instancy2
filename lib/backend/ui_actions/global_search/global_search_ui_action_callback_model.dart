class GlobalSearchUIActionCallbackModel {
  void Function()? onAddToMyLearningTap;
  void Function()? onDetailsTap;
  void Function()? onShareTap;
  void Function()? onViewProfileTap;
  void Function()? onShareWithConnectionTap;
  void Function()? onShareWithPeopleTap;

  GlobalSearchUIActionCallbackModel({
    this.onAddToMyLearningTap,
    this.onDetailsTap,
    this.onShareTap,
    this.onViewProfileTap,
    this.onShareWithConnectionTap,
    this.onShareWithPeopleTap,
  });
}
