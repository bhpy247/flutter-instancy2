import 'package:flutter_instancy_2/models/classroom_events/data_model/EventRecordingDetailsModel.dart';

class EventTrackUIActionParameterModel {
  final int objectTypeId;
  final int mediaTypeId;
  final int viewType;
  final int eventScheduleType;
  final String parentId;
  final String eventEndDatetime;
  final String actionviewqrcode;
  final String actualStatus;
  final String CancelEventLink;
  final String ReEnrollmentHistoryLink;
  final String InstanceEventReSchedule;
  final String InstanceEventReclass;
  final String JWVideoKey;
  final bool showRelatedContents;
  final bool showReportAction;

  // final dynamic bit4;

  final EventRecordingDetailsModel? recordingDetails;

  const EventTrackUIActionParameterModel({
    this.objectTypeId = 0,
    this.mediaTypeId = 0,
    this.viewType = 0,
    this.eventScheduleType = 0,
    this.parentId = "",
    this.eventEndDatetime = "",
    this.actionviewqrcode = "",
    this.actualStatus = "",
    this.CancelEventLink = "",
    this.ReEnrollmentHistoryLink = "",
    this.InstanceEventReSchedule = "",
    this.InstanceEventReclass = "",
    this.JWVideoKey = "",
    this.showRelatedContents = false,
    this.showReportAction = false,
    this.recordingDetails,
    // this.bit4,
  });
}