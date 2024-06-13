import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class QuizQuestionModel {
  String question = "";
  String correct_choice = "";
  String type = "";
  String selectedAnswer = "";
  String correctFeedback = "";
  String inCorrectFeedback = "";
  bool isAnswerGiven = false;
  bool isCorrectAnswerGiven = false;
  bool isQuestionEditable = false;
  bool isAnswerSelectedForSubmit = false;
  List<String> choices = [];
  List<bool> isEditModeEnable = <bool>[];

  QuizQuestionModel({
    this.question = "",
    this.correct_choice = "",
    this.type = "",
    this.selectedAnswer = "",
    this.correctFeedback = "",
    this.inCorrectFeedback = "",
    this.isAnswerGiven = false,
    this.isCorrectAnswerGiven = false,
    this.isQuestionEditable = false,
    this.isAnswerSelectedForSubmit = false,
    List<String>? choices,
    List<bool>? isEditModeEnable,
  }) {
    this.choices = choices ?? <String>[];
    this.isEditModeEnable = isEditModeEnable ?? <bool>[];
  }

  QuizQuestionModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    question = map["question"] != null ? ParsingHelper.parseStringMethod(map["question"]) : question;
    correct_choice = map["correct_choice"] != null ? ParsingHelper.parseStringMethod(map["correct_choice"]) : correct_choice;
    type = map["type"] != null ? ParsingHelper.parseStringMethod(map["type"]) : type;
    correctFeedback = map["correctFeedback"] != null ? ParsingHelper.parseStringMethod(map["correctFeedback"]) : correctFeedback;
    inCorrectFeedback = map["inCorrectFeedback"] != null ? ParsingHelper.parseStringMethod(map["inCorrectFeedback"]) : inCorrectFeedback;
    choices = map["choices"] != null ? ParsingHelper.parseListMethod<dynamic, String>(map["choices"]) : choices;
    if (choices.isNotEmpty && !choices.contains(correct_choice)) correct_choice = choices.first;

    isEditModeEnable
      ..clear()
      ..addAll(List.generate(choices.length, (index) => false));
  }

  Map<String, dynamic> toMap({bool toJson = true}) {
    return <String, dynamic>{
      "question": question,
      "correct_choice": correct_choice,
      "type": type,
      "correctFeedback": correctFeedback,
      "inCorrectFeedback": inCorrectFeedback,
      "choices": choices,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}
