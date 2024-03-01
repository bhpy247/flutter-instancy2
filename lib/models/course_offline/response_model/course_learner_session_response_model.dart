import 'package:flutter_instancy_2/models/course_offline/data_model/learner_session_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class CourseLearnerSessionResponseModel {
  String id = "";
  int siteId = 0;
  int userId = 0;
  int scoId = 0;
  Map<int, LearnerSessionModel> learnerSessionsResponseMap = <int, LearnerSessionModel>{};

  CourseLearnerSessionResponseModel({
    this.id = "",
    this.siteId = 0,
    this.userId = 0,
    this.scoId = 0,
    Map<int, LearnerSessionModel>? learnerSessionsResponseMap,
  }) {
    this.learnerSessionsResponseMap = learnerSessionsResponseMap ?? <int, LearnerSessionModel>{};
  }

  CourseLearnerSessionResponseModel.fromMap(Map<String, dynamic> map) {
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

    learnerSessionsResponseMap.clear();
    Map<int, dynamic> questionStudentResponseDataMap = ParsingHelper.parseMapMethod<dynamic, dynamic, int, dynamic>(map["learnerSessionsResponseMap"]);
    questionStudentResponseDataMap.forEach((int questionId, dynamic studentResponse) {
      Map<String, dynamic> studentResponseModelMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(studentResponse);
      if (studentResponseModelMap.isNotEmpty) {
        learnerSessionsResponseMap[questionId] = LearnerSessionModel.fromMap(studentResponseModelMap);
      }
    });
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "siteId": siteId,
      "userId": userId,
      "scoId": scoId,
      "learnerSessionsResponseMap": learnerSessionsResponseMap.map((key, value) => MapEntry<int, Map<String, dynamic>>(key, value.toMap())),
    };
  }

  int getLastLearnerAttempt() {
    int attempt = 0;

    for (int attemptNumber in learnerSessionsResponseMap.keys) {
      if (attempt < attemptNumber) attempt = attemptNumber;
    }

    return attempt;
  }

  LearnerSessionModel? getLastLearnerSessionModel() {
    int lastAttempt = getLastLearnerAttempt();

    return learnerSessionsResponseMap[lastAttempt];
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }

  static String getCourseLearnerSessionId({required int siteId, required int userId, required int scoId}) {
    return "${siteId}_${userId}_$scoId";
  }
}
