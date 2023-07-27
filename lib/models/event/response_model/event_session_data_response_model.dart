import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../../utils/my_utils.dart';
import '../../catalog/data_model/catalog_course_dto_model.dart';
import '../data_model/event_session_course_dto_model.dart';

class EventSessionDataResponseModel {
  List<EventSessionCourseDTOModel> CourseList = [];
  String eventdatetimeformat = "";

  EventSessionDataResponseModel({
    List<CatalogCourseDTOModel>? CourseList,
    this.eventdatetimeformat = "",
  });

  EventSessionDataResponseModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    List<Map<String, dynamic>> sessionMapsList = ParsingHelper.parseMapsListMethod(map['CourseList']);
    CourseList = sessionMapsList.map((e) {
      return EventSessionCourseDTOModel.fromMap(e);
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