import 'package:flutter_instancy_2/models/course_offline/data_model/student_response_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class StudentCourseResponseModel {
  String id = "";
  int siteId = 0;
  int userId = 0;
  int scoId = 0;
  Map<int, StudentResponseModel> questionResponseMap = <int, StudentResponseModel>{};

  StudentCourseResponseModel({
    this.id = "",
    this.siteId = 0,
    this.userId = 0,
    this.scoId = 0,
    Map<int, StudentResponseModel>? questionResponseMap,
  }) {
    this.questionResponseMap = questionResponseMap ?? <int, StudentResponseModel>{};
  }

  StudentCourseResponseModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    id = ParsingHelper.parseStringMethod(map["id"]);
    siteId = ParsingHelper.parseIntMethod(map["siteId"]);
    userId = ParsingHelper.parseIntMethod(map["userId"]);
    scoId = ParsingHelper.parseIntMethod(map["scoId"]);

    questionResponseMap.clear();
    Map<int, dynamic> questionStudentResponseDataMap = ParsingHelper.parseMapMethod<dynamic, dynamic, int, dynamic>(map["questionResponseMap"]);
    questionStudentResponseDataMap.forEach((int questionId, dynamic studentResponse) {
      Map<String, dynamic> studentResponseModelMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(studentResponse);
      if (studentResponseModelMap.isNotEmpty) {
        questionResponseMap[questionId] = StudentResponseModel.fromMap(studentResponseModelMap);
      }
    });
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "siteId": siteId,
      "userId": userId,
      "scoId": scoId,
      "questionResponseMap": questionResponseMap.map((key, value) => MapEntry(key, value.toMap())),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }

  static getStudentCourseResponseId({required int siteId, required int userId, required int scoId}) {
    return "${siteId}_${userId}_$scoId";
  }
}
