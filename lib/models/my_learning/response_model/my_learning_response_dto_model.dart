import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';
import '../../course/data_model/CourseDTOModel.dart';

class MyLearningResponseDTOModel {
  List<CourseDTOModel> CourseList = <CourseDTOModel>[];
  int CourseCount = 0;
  String NotifyMessage = "";

  MyLearningResponseDTOModel({
    List<CourseDTOModel>? CourseList,
    this.CourseCount = 0,
    this.NotifyMessage = "",
  }) {
    this.CourseList = CourseList ?? <CourseDTOModel>[];
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
      return CourseDTOModel.fromMap(e);
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