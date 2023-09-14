import '../../../models/classroom_events/data_model/event_recodting_mobile_lms_data_model.dart';

class EventCatalogUIActionParameterModel {
  final int objectTypeId;
  final int mediaTypeId;
  final int viewType;
  final int relatedContentCount;
  final int eventScheduleType;
  final int eventType;
  final int waitListEnroll;
  final int waitListLimit;
  final int isWishlistContent;
  final String parentId;
  final String reportaction;
  final String suggestToConnectionsLink;
  final String suggestWithFriendLink;
  final String shareLink;
  final String eventStartDatetime;
  final String eventEndDatetime;
  final String actionviewqrcode;
  final String actualStatus;
  final String WaitListLink;
  final String RelatedContentLink;
  final bool isAddToMyLearning;
  final bool eventRecording;
  final EventRecordingMobileLMSDataModel? recordingDetails;

  const EventCatalogUIActionParameterModel({
    this.objectTypeId = 0,
    this.mediaTypeId = 0,
    this.viewType = 0,
    this.relatedContentCount = 0,
    this.eventScheduleType = 0,
    this.eventType = 0,
    this.waitListEnroll = 0,
    this.waitListLimit = 0,
    this.isWishlistContent = 0,
    this.parentId = "",
    this.actualStatus = "",
    this.reportaction = "",
    this.suggestToConnectionsLink = "",
    this.suggestWithFriendLink = "",
    this.shareLink = "",
    this.eventStartDatetime = "",
    this.eventEndDatetime = "",
    this.actionviewqrcode = "",
    this.WaitListLink = "",
    this.RelatedContentLink = "",
    this.isAddToMyLearning = false,
    this.eventRecording = false,
    this.recordingDetails,
  });
}
