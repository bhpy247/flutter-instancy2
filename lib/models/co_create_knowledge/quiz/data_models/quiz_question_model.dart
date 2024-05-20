class QuizQuestionModel {
  String question = "";
  List<String> optionList = [];
  List<bool> isEditModeEnable = <bool>[];
  String correctAnswer = "";
  String selectedAnswer = "";
  String correctFeedback = "";
  String inCorrectFeedback = "";
  bool isAnswerGiven = false;
  bool isCorrectAnswerGiven = false;
  bool isQuestionEditable = false;

  QuizQuestionModel({
    this.question = "",
    this.correctAnswer = "",
    this.selectedAnswer = "",
    this.correctFeedback = "",
    this.inCorrectFeedback = "",
    this.optionList = const [],
    this.isAnswerGiven = false,
    this.isCorrectAnswerGiven = false,
    this.isEditModeEnable = const [],
    this.isQuestionEditable = false,
  });
}
