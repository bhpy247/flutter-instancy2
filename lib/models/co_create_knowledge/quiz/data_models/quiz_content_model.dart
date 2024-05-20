import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/data_models/quiz_question_model.dart';

class QuizContentModel {
  int questionCount = 0;
  String questionType = "";
  String difficultyLevel = "";
  List<QuizQuestionModel> questions = <QuizQuestionModel>[];
}
