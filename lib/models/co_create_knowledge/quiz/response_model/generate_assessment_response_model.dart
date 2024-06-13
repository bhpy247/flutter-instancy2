import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/data_models/quiz_question_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class GenerateAssessmentResponseModel {
  List<QuizQuestionModel> Assessment = <QuizQuestionModel>[];

  GenerateAssessmentResponseModel({
    List<QuizQuestionModel>? Assessment,
  }) {
    this.Assessment = Assessment ?? <QuizQuestionModel>[];
  }

  GenerateAssessmentResponseModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    if (map["Assessment"] != null) {
      Assessment.clear();
      List<Map<String, dynamic>> quizQuestionsMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(map["Assessment"]);
      Assessment.addAll(quizQuestionsMapsList.map((e) => QuizQuestionModel.fromMap(e)));
    }
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return <String, dynamic>{
      "Assessment": Assessment.map((e) => e.toMap(toJson: toJson)).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}
