import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../../utils/my_utils.dart';
import '../../course/data_model/CourseDTOModel.dart';

class CourseDetailsScheduleDataResponseModel {
  List<CourseDTOModel> courseList = [];
  int courseCount = 0;
  dynamic selfScheduleInstancesData;

  CourseDetailsScheduleDataResponseModel({
    List<CourseDTOModel>? courseList,
    this.courseCount = 0,
    this.selfScheduleInstancesData,
  }) {
    this.courseList = courseList ?? <CourseDTOModel>[];
  }

  CourseDetailsScheduleDataResponseModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    List<Map<String, dynamic>> courseMapsList = ParsingHelper.parseMapsListMethod(map['CourseList']);
    courseList = courseMapsList.map((e) {
      return CourseDTOModel.fromMap(e);
    }).toList();
    courseCount = ParsingHelper.parseIntMethod(map['CourseCount']);
    selfScheduleInstancesData = map['selfScheduleInstancesData'];
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return <String, dynamic>{
      "CourseList" : courseList.map((e) => e.toMap()).toList(),
      "CourseCount" : courseCount,
      "selfScheduleInstancesData" : selfScheduleInstancesData,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}