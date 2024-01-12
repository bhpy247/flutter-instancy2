class EventTrackUIActionCallbackModel {
  final void Function()? onEnrollTap;
  final void Function()? onCancelEnrollmentTap;
  final void Function()? onRescheduleTap;
  final void Function()? onViewTap;
  final void Function()? onPlayTap;
  final void Function()? onReportTap;
  final void Function()? onJoinTap;
  final void Function()? onViewResourcesTap;
  final void Function()? onViewQRCodeTap;
  final void Function()? onViewRecordingTap;
  final void Function()? onSetCompleteTap;
  final void Function()? onReEnrollmentHistoryTap;
  final void Function()? onReEnrollTap;

  EventTrackUIActionCallbackModel(
      {this.onEnrollTap,
      this.onCancelEnrollmentTap,
      this.onRescheduleTap,
      this.onViewTap,
      this.onPlayTap,
      this.onReportTap,
      this.onJoinTap,
      this.onViewResourcesTap,
      this.onViewQRCodeTap,
      this.onViewRecordingTap,
      this.onSetCompleteTap,
      this.onReEnrollTap,
      this.onReEnrollmentHistoryTap});
}