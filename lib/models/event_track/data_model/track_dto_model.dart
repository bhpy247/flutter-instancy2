import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import 'track_course_dto_model.dart';

class TrackDTOModel {
  String blockID = "";
  String blockname = "";
  String TimeSpentType = "";
  String TimeToBeSpent = "";
  String TimeSpent = "";
  int CourseCount = 0;
  int timeSpentHours = 0;
  List<TrackCourseDTOModel> TrackList = <TrackCourseDTOModel>[];

  TrackDTOModel({
    this.blockID = "",
    this.blockname = "",
    this.TimeSpentType = "",
    this.TimeToBeSpent = "",
    this.TimeSpent = "",
    this.CourseCount = 0,
    this.timeSpentHours = 0,
    List<TrackCourseDTOModel>? TrackList,
  }) {
    this.TrackList = TrackList ?? <TrackCourseDTOModel>[];
  }

  TrackDTOModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    blockID = ParsingHelper.parseStringMethod(map["blockID"]);
    blockname = ParsingHelper.parseStringMethod(map["blockname"]);
    TimeSpentType = ParsingHelper.parseStringMethod(map["TimeSpentType"]);
    TimeToBeSpent = ParsingHelper.parseStringMethod(map["TimeToBeSpent"]);
    TimeSpent = ParsingHelper.parseStringMethod(map["TimeSpent"]);
    CourseCount = ParsingHelper.parseIntMethod(map["CourseCount"]);
    timeSpentHours = ParsingHelper.parseIntMethod(map["timeSpentHours"]);

    TrackList.clear();
    List<Map<String, dynamic>> TrackMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(map["TrackList"]);
    TrackList.addAll(TrackMapsList.map((e) => TrackCourseDTOModel.fromMap(e)));
  }

  Map<String, dynamic> toMap() {
    return {
      "blockID": blockID,
      "blockname": blockname,
      "TimeSpentType": TimeSpentType,
      "TimeToBeSpent": TimeToBeSpent,
      "TimeSpent": TimeSpent,
      "CourseCount": CourseCount,
      "timeSpentHours": timeSpentHours,
      "TrackList": TrackList.map((e) => e.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
