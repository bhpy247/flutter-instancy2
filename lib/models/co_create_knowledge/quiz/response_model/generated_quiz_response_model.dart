import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/data_models/quiz_question_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class GeneratedQuizResponseModel {
  List<QuizQuestionModel> assessment = <QuizQuestionModel>[];

  GeneratedQuizResponseModel({
    List<QuizQuestionModel>? assessment,
  }) {
    this.assessment = assessment ?? <QuizQuestionModel>[];
  }

  GeneratedQuizResponseModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    if (map["assessment"] != null) {
      assessment.clear();
      List<Map<String, dynamic>> flashcardMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(map["assessment"]);
      assessment.addAll(flashcardMapsList.map((e) => QuizQuestionModel.fromMap(e)));
    }
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return <String, dynamic>{
      "assessment": assessment.map((e) => e.toMap(toJson: toJson)).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}
