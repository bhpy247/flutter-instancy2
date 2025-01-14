class MyCourseDownloadUIActionCallbackModel {
  final void Function()? onRemoveFromDownloadTap;
  final void Function()? onCancelDownloadTap;
  final void Function()? onPauseDownloadTap;
  final void Function()? onResumeDownloadTap;
  final void Function()? onSetCompleteTap;

  MyCourseDownloadUIActionCallbackModel({
    this.onRemoveFromDownloadTap,
    this.onCancelDownloadTap,
    this.onPauseDownloadTap,
    this.onResumeDownloadTap,
    this.onSetCompleteTap,
  });
}
