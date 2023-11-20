import '../../../models/classroom_events/data_model/EventRecordingDetailsModel.dart';

class MyLearningUIActionParameterModel {
  final int objectTypeId;
  final int mediaTypeId;
  final int EventType;
  final int eventScheduleType;
  final dynamic bit4;
  final bool isArchived;
  final EventRecordingDetailsModel? eventRecording;
  final String ViewLink;
  final String DetailsLink;
  final String CancelEventLink;
  final String removeLink;
  final String eventStartDatetime;
  final String eventenddatetime;
  final String actualStatus;
  final String InstanceEventReSchedule;
  final String CertificateLink;
  final String ActionViewQRcode;
  final String suggestToConnectionsLink;
  final String suggestWithFriendLink;
  final String shareLink;
  final String RelatedContentLink;
  final String IsRelatedcontent;
  final String ViewSessionsLink;
  final String ReEnrollmentHistoryLink;

  const MyLearningUIActionParameterModel(
      {this.objectTypeId = 0,
      this.mediaTypeId = 0,
      this.EventType = 0,
      this.eventScheduleType = 0,
      this.bit4,
      this.isArchived = false,
      this.eventRecording,
      this.ViewLink = "",
    this.DetailsLink = "",
    this.CancelEventLink = "",
    this.removeLink = "",
    this.eventStartDatetime = "",
    this.eventenddatetime = "",
    this.actualStatus = "",
    this.InstanceEventReSchedule = "",
    this.CertificateLink = "",
    this.ActionViewQRcode = "",
    this.suggestToConnectionsLink = "",
    this.suggestWithFriendLink = "",
    this.shareLink = "",
    this.RelatedContentLink = "",
    this.IsRelatedcontent = "",
    this.ViewSessionsLink = "",
    this.ReEnrollmentHistoryLink = ""});
}