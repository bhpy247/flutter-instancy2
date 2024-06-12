import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/data_models/quiz_question_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class MicroLearningModel {
  String htmlContentCode = "";
  String questionType = MicrolearningTypes.text;
  String title = "";
  String image = "";
  QuizQuestionModel? quizQuestionModel;

  MicroLearningModel({
    this.htmlContentCode = "",
    this.questionType = MicrolearningTypes.text,
    this.title = "",
    this.image = "",
    this.quizQuestionModel,
  });

  MicroLearningModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    htmlContentCode = map["htmlContentCode"] != null ? ParsingHelper.parseStringMethod(map["htmlContentCode"]) : htmlContentCode;
    questionType = map["questionType"] != null ? ParsingHelper.parseStringMethod(map["questionType"]) : questionType;
    title = map["title"] != null ? ParsingHelper.parseStringMethod(map["title"]) : title;
    image = map["image"] != null ? ParsingHelper.parseStringMethod(map["image"]) : image;

    Map<String, dynamic>? quizQuestionModelMap = map["quizQuestionModel"] != null ? ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(map["quizQuestionModel"]) : null;
    if (quizQuestionModelMap.checkNotEmpty) {
      quizQuestionModel = QuizQuestionModel.fromMap(quizQuestionModelMap!);
    } else {
      quizQuestionModel = null;
    }
  }

  Map<String, dynamic> toMap({bool toJson = true}) {
    return <String, dynamic>{
      "htmlContentCode": htmlContentCode,
      "questionType": questionType,
      "title": title,
      "image": image,
      "quizQuestionModel": quizQuestionModel?.toMap(toJson: toJson),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}
