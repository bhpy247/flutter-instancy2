import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/data_models/quiz_question_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class QuizContentModel {
  int questionCount = 0;
  String questionType = "";
  String difficultyLevel = "";
  List<QuizQuestionModel> questions = <QuizQuestionModel>[];

  QuizContentModel({
    this.questionCount = 0,
    this.questionType = "",
    this.difficultyLevel = "",
    List<QuizQuestionModel>? questions,
  }) {
    this.questions = questions ?? <QuizQuestionModel>[];
  }

  QuizContentModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    questionCount = map["questionCount"] != null ? ParsingHelper.parseIntMethod(map["questionCount"]) : questionCount;
    questionType = map["questionType"] != null ? ParsingHelper.parseStringMethod(map["questionType"]) : questionType;
    difficultyLevel = map["difficultyLevel"] != null ? ParsingHelper.parseStringMethod(map["difficultyLevel"]) : difficultyLevel;

    if (map["questions"] != null) {
      List<Map<String, dynamic>> questionMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(map["questions"]);
      questions = questionMapsList.map((e) => QuizQuestionModel.fromMap(e)).toList();
    }
  }

  Map<String, dynamic> toMap({bool toJson = true}) {
    return <String, dynamic>{
      "questionCount": questionCount,
      "questionType": questionType,
      "difficultyLevel": difficultyLevel,
      "questions": questions.map((e) => e.toMap(toJson: toJson)).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}
