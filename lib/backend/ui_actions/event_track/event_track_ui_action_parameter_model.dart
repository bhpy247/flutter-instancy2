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
  final bool showRelatedContents;
  final bool showReportAction;
  final EventRecordingDetailsModel? recordingDetails;

  const EventTrackUIActionParameterModel({
    this.objectTypeId = 0,
    this.mediaTypeId = 0,
    this.viewType = 0,
    this.eventScheduleType = 0,
    this.parentId = "",
    this.actualStatus = "",
    this.eventEndDatetime = "",
    this.actionviewqrcode = "",
    this.showRelatedContents = false,
    this.showReportAction = false,
    this.recordingDetails,
  });
}