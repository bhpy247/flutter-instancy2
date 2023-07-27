import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../../utils/my_utils.dart';
import '../../catalog/data_model/catalog_course_dto_model.dart';

class CourseDetailsScheduleDataResponseModel {
  List<CatalogCourseDTOModel> courseList = [];
  int courseCount = 0;
  dynamic selfScheduleInstancesData;

  CourseDetailsScheduleDataResponseModel({
    List<CatalogCourseDTOModel>? courseList,
    this.courseCount = 0,
    this.selfScheduleInstancesData,
  }) {
    this.courseList = courseList ?? <CatalogCourseDTOModel>[];
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
      return CatalogCourseDTOModel.fromMap(e);
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