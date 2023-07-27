class CourseDetailsUIActionCallbackModel {
  final void Function()? onEnrollTap;
  final void Function()? onCancelEnrollmentTap;
  final void Function()? onViewTap;
  final void Function()? onPlayTap;
  final void Function()? onJoinTap;
  final void Function()? onAddToMyLearningTap;

  CourseDetailsUIActionCallbackModel({
    this.onEnrollTap,
    this.onCancelEnrollmentTap,
    this.onViewTap,
    this.onPlayTap,
    this.onJoinTap,
    this.onAddToMyLearningTap,
  });
}