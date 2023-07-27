class CatalogUIActionCallbackModel {
  void Function()? onViewTap;
  void Function()? onAddToMyLearningTap;
  void Function()? onBuyTap;
  void Function()? onEnrollTap;
  void Function()? onDetailsTap;
  void Function()? onIAmInterestedTap;
  void Function()? onContactTap;
  void Function()? onAddToWishlist;
  void Function()? onRemoveWishlist;
  void Function()? onEventRecordingTap;
  void Function()? onAddToWaitListTap;
  void Function()? onCancelEnrollmentTap;
  void Function()? onRescheduleTap;
  void Function()? onReEnrollmentHistoryTap;
  void Function()? onViewResources;
  void Function()? onRecommendToTap;
  void Function()? onShareWithConnectionTap;
  void Function()? onShareWithPeopleTap;
  void Function()? onShareTap;
  void Function()? onDownloadTap;

  CatalogUIActionCallbackModel({
    this.onViewTap,
    this.onAddToMyLearningTap,
    this.onBuyTap,
    this.onEnrollTap,
    this.onDetailsTap,
    this.onIAmInterestedTap,
    this.onContactTap,
    this.onDownloadTap,
    this.onAddToWishlist,
    this.onRemoveWishlist,
    this.onEventRecordingTap,
    this.onAddToWaitListTap,
    this.onCancelEnrollmentTap,
    this.onRescheduleTap,
    this.onReEnrollmentHistoryTap,
    this.onViewResources,
    this.onRecommendToTap,
    this.onShareWithConnectionTap,
    this.onShareWithPeopleTap,
    this.onShareTap,
  });
}