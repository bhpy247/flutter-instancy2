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
    this.actualStatus = "",
    this.CancelEventLink = "",
    this.eventEndDatetime = "",
    this.actionviewqrcode = "",
    this.InstanceEventReSchedule = "",
    this.InstanceEventReclass = "",
    this.ReEnrollmentHistoryLink = "",
    this.showRelatedContents = false,
    this.showReportAction = false,
    this.recordingDetails,
    // this.bit4,
  });
}