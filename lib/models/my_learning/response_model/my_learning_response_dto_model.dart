import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';
import '../data_model/my_learning_course_dto_model.dart';

class MyLearningResponseDTOModel {
  List<MyLearningCourseDTOModel> CourseList = <MyLearningCourseDTOModel>[];
  int CourseCount = 0;
  String NotifyMessage = "";

  MyLearningResponseDTOModel({
    List<MyLearningCourseDTOModel>? CourseList,
    this.CourseCount = 0,
    this.NotifyMessage = "",
  }) {
    this.CourseList = CourseList ?? <MyLearningCourseDTOModel>[];
  }

  MyLearningResponseDTOModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    List<Map<String, dynamic>> courseMapsList = ParsingHelper.parseMapsListMethod(map['CourseList']);
    CourseList = courseMapsList.map((e) {
      return MyLearningCourseDTOModel.fromMap(e);
    }).toList();
    CourseCount = ParsingHelper.parseIntMethod(map['CourseCount']);
    NotifyMessage = ParsingHelper.parseStringMethod(map['NotifyMessage']);
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return <String, dynamic>{
      "CourseList" : CourseList.map((e) => e.toMap()).toList(),
      "CourseCount" : CourseCount,
      "NotifyMessage" : NotifyMessage,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}