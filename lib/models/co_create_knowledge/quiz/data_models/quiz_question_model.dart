import '../../../../utils/my_utils.dart';
import '../../../../utils/parsing_helper.dart';

class QuizResponseModel {
  List<QuizQuestionModel> assessment = const [];

  QuizResponseModel({this.assessment = const []});

  QuizResponseModel.fromMap(Map<String, dynamic> json) {
    if (json['Assessment'] != null) {
      assessment = <QuizQuestionModel>[];
      json['Assessment'].forEach((v) {
        assessment.add(QuizQuestionModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Assessment'] = assessment.map((v) => v.toJson()).toList();
    return data;
  }
}

class QuizQuestionModel {
  String question = "";
  String type = "";
  List<String> choices = [];
  List<bool> isEditModeEnable = <bool>[];
  String correctChoice = "";
  String selectedAnswer = "";
  String correctFeedback = "";
  String inCorrectFeedback = "";
  bool isAnswerGiven = false;
  bool isCorrectAnswerGiven = false;
  bool isQuestionEditable = false;
  bool isAnswerSelectedForSubmit = false;

  QuizQuestionModel({
    this.question = "",
    this.type = "",
    this.correctChoice = "",
    this.selectedAnswer = "",
    this.correctFeedback = "",
    this.inCorrectFeedback = "",
    this.choices = const [],
    this.isAnswerGiven = false,
    this.isCorrectAnswerGiven = false,
    this.isEditModeEnable = const [],
    this.isQuestionEditable = false,
    this.isAnswerSelectedForSubmit = false,
  });

  QuizQuestionModel.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> map) {
    choices = ParsingHelper.parseListMethod(map['choices']);
    correctChoice = ParsingHelper.parseStringMethod(map['correct_choice']);
    question = ParsingHelper.parseStringMethod(map['question']);
    type = ParsingHelper.parseStringMethod(map['type']);

    choices.forEach((element) {
      isEditModeEnable.add(false);
    });
  }

  Map<String, dynamic> toJson({bool toJson = false}) {
    return {
      'choices': choices,
      'correct_choice': correctChoice,
      'question': question,
      'type': type,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson(toJson: true));
  }
}
