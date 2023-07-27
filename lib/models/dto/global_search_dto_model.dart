import 'package:flutter_instancy_2/models/dto/global_search_course_dto_model.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../utils/my_utils.dart';

class GlobalSearchDTOModel {
  List<GlobalSearchCourseDTOModel> CourseList = <GlobalSearchCourseDTOModel>[];
  int CourseCount = 0;

  GlobalSearchDTOModel({
    List<GlobalSearchCourseDTOModel>? CourseList,
    this.CourseCount = 0,
  }) {
    this.CourseList = CourseList ?? <GlobalSearchCourseDTOModel>[];
  }

  GlobalSearchDTOModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    List<Map<String, dynamic>> courseMapsList = ParsingHelper.parseMapsListMethod(map['CourseList']);
    CourseList = courseMapsList.map((e) {
      return GlobalSearchCourseDTOModel.fromMap(e);
    }).toList();
    CourseCount = ParsingHelper.parseIntMethod(map['CourseCount']);
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return <String, dynamic>{
      "CourseList" : CourseList.map((e) => e.toMap()).toList(),
      "CourseCount" : CourseCount,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}