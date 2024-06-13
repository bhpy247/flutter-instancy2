import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';

class QuizGenerateRequestModel {
  String difficultyLevel = QuizDifficultyTypes.beginner;
  String prompt = "";
  int numberOfQuestions = 1;
  int questionType = QuizQuestionType.mcq;

  QuizGenerateRequestModel({
    this.difficultyLevel = QuizDifficultyTypes.beginner,
    this.prompt = "",
    this.numberOfQuestions = 1,
    this.questionType = QuizQuestionType.mcq,
  });

  Map<String, dynamic> toMap({bool toJson = false}) {
    return {
      "difficultyLevel": difficultyLevel,
      "prompt": prompt,
      "numberOfQuestions": numberOfQuestions,
      "questionType": questionType,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}
