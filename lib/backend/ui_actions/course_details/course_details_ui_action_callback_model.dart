class CourseDetailsUIActionCallbackModel {
  final void Function()? onBuyTap;
  final void Function()? onAddToMyLearningTap;
  final void Function()? onEnrollTap;
  final void Function()? onCancelEnrollmentTap;
  final void Function()? onJoinTap;
  final void Function()? onViewTap;
  final void Function()? onPlayTap;

  CourseDetailsUIActionCallbackModel({
    this.onBuyTap,
    this.onAddToMyLearningTap,
    this.onEnrollTap,
    this.onCancelEnrollmentTap,
    this.onJoinTap,
    this.onViewTap,
    this.onPlayTap,
  });
}