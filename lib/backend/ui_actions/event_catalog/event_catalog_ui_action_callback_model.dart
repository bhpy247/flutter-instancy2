class EventCatalogUIActionCallbackModel {
  void Function()? onEnrollTap;
  void Function()? onJoinTap;
  void Function()? onDetailsTap;
  void Function()? onAddToWishlist;
  void Function()? onRemoveWishlist;
  void Function()? onAddToWaitListTap;
  void Function()? onAddToCalenderTap;
  void Function()? onCancelEnrollmentTap;
  void Function()? onRescheduleTap;
  void Function()? onViewQRCodeTap;
  void Function()? onReEnrollmentHistoryTap;
  void Function()? onViewResources;
  void Function()? onViewRecordingTap;
  void Function()? onViewSessionsTap;
  void Function()? onRecommendToTap;
  void Function()? onShareWithConnectionTap;
  void Function()? onShareWithPeopleTap;
  void Function()? onShareTap;

  EventCatalogUIActionCallbackModel({
    this.onEnrollTap,
    this.onJoinTap,
    this.onViewQRCodeTap,
    this.onDetailsTap,
    this.onAddToWishlist,
    this.onRemoveWishlist,
    this.onAddToWaitListTap,
    this.onAddToCalenderTap,
    this.onCancelEnrollmentTap,
    this.onRescheduleTap,
    this.onReEnrollmentHistoryTap,
    this.onViewResources,
    this.onViewRecordingTap,
    this.onViewSessionsTap,
    this.onRecommendToTap,
    this.onShareWithConnectionTap,
    this.onShareWithPeopleTap,
    this.onShareTap,
  });
}
