import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../../utils/my_utils.dart';
import '../../course/data_model/CourseDTOModel.dart';

class EventSessionDataResponseModel {
  List<CourseDTOModel> CourseList = [];
  String eventdatetimeformat = "";

  EventSessionDataResponseModel({
    List<CourseDTOModel>? CourseList,
    this.eventdatetimeformat = "",
  }) {
    this.CourseList = CourseList ?? <CourseDTOModel>[];
  }

  EventSessionDataResponseModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    List<Map<String, dynamic>> sessionMapsList = ParsingHelper.parseMapsListMethod(map['CourseList']);
    CourseList = sessionMapsList.map((e) {
      return CourseDTOModel.fromMap(e);
    }).toList();
    eventdatetimeformat = ParsingHelper.parseStringMethod(map['eventdatetimeformat']);
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return <String, dynamic>{
      "CourseList" : CourseList.map((e) => e.toMap()).toList(),
      "eventdatetimeformat" : eventdatetimeformat,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}