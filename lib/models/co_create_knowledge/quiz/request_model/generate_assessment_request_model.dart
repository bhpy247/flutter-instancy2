import '../../../../utils/my_utils.dart';

class GenerateAssessmentRequestModel {
  String content = "";
  String adminUrl = "";
  String difficultyLevel = "";
  String type = "";
  int numberofQuestions = 1;
  int requestedBy = 0;

  GenerateAssessmentRequestModel({
    this.content = "",
    this.adminUrl = "",
    this.difficultyLevel = "",
    this.type = "",
    this.numberofQuestions = 1,
    this.requestedBy = 0,
  });

  Map<String, dynamic> toMap({bool toJson = false}) {
    return {
      "content": content,
      "adminUrl": adminUrl,
      "difficultyLevel": difficultyLevel,
      "type": type,
      "numberofQuestions": numberofQuestions,
      "requestedBy": requestedBy,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}
