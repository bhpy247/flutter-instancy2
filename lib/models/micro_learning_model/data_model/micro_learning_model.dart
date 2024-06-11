import 'package:flutter_instancy_2/configs/app_constants.dart';

import '../../co_create_knowledge/quiz/data_models/quiz_question_model.dart';

class MicroLearningModel {
  final String htmlContentCode;
  final String questionType;
  final String title;
  final String? image;
  final QuizQuestionModel? quizQuestionModel;

  MicroLearningModel({this.htmlContentCode = "", this.questionType = MicrolearningTypes.text, this.title = "", this.quizQuestionModel, this.image});
}

class MainMicroLearningModel {
  List<MicroLearningModel>? mainMicroLearningModelList;

  MainMicroLearningModel({this.mainMicroLearningModelList});
}
