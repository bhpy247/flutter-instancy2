import 'package:flutter_instancy_2/models/classroom_events/data_model/event_recodting_mobile_lms_data_model.dart';

class EventTrackUIActionParameterModel {
  final int objectTypeId;
  final int mediaTypeId;
  final int viewType;
  final int relatedConentCount;
  final int eventScheduleType;
  final String parentId;
  final String reportaction;
  final String suggestToConnectionsLink;
  final String suggestWithFriendLink;
  final String shareLink;
  final String eventEndDatetime;
  final String actionviewqrcode;
  final String actualStatus;
  final EventRecordingMobileLMSDataModel? recordingDetails;

  const EventTrackUIActionParameterModel({
    this.objectTypeId = 0,
    this.mediaTypeId = 0,
    this.viewType = 0,
    this.relatedConentCount = 0,
    this.eventScheduleType = 0,
    this.parentId = "",
    this.actualStatus = "",
    this.reportaction = "",
    this.suggestToConnectionsLink = "",
    this.suggestWithFriendLink = "",
    this.shareLink = "",
    this.eventEndDatetime = "",
    this.actionviewqrcode = "",
    this.recordingDetails,
  });
}