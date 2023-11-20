import 'package:flutter_chat_bot/utils/parsing_helper.dart';

class ReEnrollmentHistoryResponseModel {
  List<ScheduleReportDataDTO> scheduleReportDataDTO = [];
  String name = "";

  ReEnrollmentHistoryResponseModel({this.scheduleReportDataDTO = const [], this.name = ""});

  ReEnrollmentHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['ScheduleReportDataDTO'] != null) {
      scheduleReportDataDTO = <ScheduleReportDataDTO>[];
      json['ScheduleReportDataDTO'].forEach((v) {
        scheduleReportDataDTO.add(ScheduleReportDataDTO.fromJson(v));
      });
    }
    name = ParsingHelper.parseStringMethod(json['Name']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ScheduleReportDataDTO'] = scheduleReportDataDTO.map((v) => v.toJson()).toList();
    data['Name'] = name;
    return data;
  }
}

class ScheduleReportDataDTO {
  String authorDisplayName = "";
  String eventStartDateTime = "";
  String mediaName = "";
  String eventEndDateTime = "";
  String locationName = "";
  String status = "";
  String eventName = "";
  String enrolledOn = "";
  String eventStatus = "";
  String eventID = "";

  ScheduleReportDataDTO(
      {this.authorDisplayName = "",
      this.eventStartDateTime = "",
      this.mediaName = "",
      this.eventEndDateTime = "",
      this.locationName = "",
      this.status = "",
      this.eventName = "",
      this.enrolledOn = "",
      this.eventStatus = "",
      this.eventID = ""});

  ScheduleReportDataDTO.fromJson(Map<String, dynamic> json) {
    authorDisplayName = ParsingHelper.parseStringMethod(json['AuthorDisplayName']);
    eventStartDateTime = ParsingHelper.parseStringMethod(json['EventStartDateTime']);
    mediaName = ParsingHelper.parseStringMethod(json['MediaName']);
    eventEndDateTime = ParsingHelper.parseStringMethod(json['EventEndDateTime']);
    locationName = ParsingHelper.parseStringMethod(json['LocationName']);
    status = ParsingHelper.parseStringMethod(json['status']);
    eventName = ParsingHelper.parseStringMethod(json['EventName']);
    enrolledOn = ParsingHelper.parseStringMethod(json['EnrolledOn']);
    eventStatus = ParsingHelper.parseStringMethod(json['EventStatus']);
    eventID = ParsingHelper.parseStringMethod(json['EventID']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AuthorDisplayName'] = authorDisplayName;
    data['EventStartDateTime'] = eventStartDateTime;
    data['MediaName'] = mediaName;
    data['EventEndDateTime'] = eventEndDateTime;
    data['LocationName'] = locationName;
    data['status'] = status;
    data['EventName'] = eventName;
    data['EnrolledOn'] = enrolledOn;
    data['EventStatus'] = eventStatus;
    data['EventID'] = eventID;
    return data;
  }
}
