import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class EventModel {
  String date = "";
  String startTime = "";
  String endTime = "";
  String eventUrl = "";
  String location = "";

  EventModel({
    this.date = "",
    this.startTime = "",
    this.endTime = "",
    this.eventUrl = "",
    this.location = "",
  });

  EventModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    date = map["date"] != null ? ParsingHelper.parseStringMethod(map["date"]) : date;
    startTime = map["startTime"] != null ? ParsingHelper.parseStringMethod(map["startTime"]) : startTime;
    endTime = map["endTime"] != null ? ParsingHelper.parseStringMethod(map["endTime"]) : endTime;
    eventUrl = map["eventUrl"] != null ? ParsingHelper.parseStringMethod(map["eventUrl"]) : eventUrl;
    location = map["location"] != null ? ParsingHelper.parseStringMethod(map["location"]) : location;
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return <String, dynamic>{
      "date": date,
      "startTime": startTime,
      "endTime": endTime,
      "eventUrl": eventUrl,
      "location": location,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}
