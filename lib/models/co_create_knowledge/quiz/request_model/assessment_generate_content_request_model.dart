import '../../../../utils/my_utils.dart';

class AssessmentGenerateContentRequestModel {
  String adminUrl = "";
  String learningObjectives = "";
  String sourceType = "";
  int word_count = 0;
  bool llmContent = false;
  List<String> sources = <String>[];

  AssessmentGenerateContentRequestModel({
    this.adminUrl = "",
    this.learningObjectives = "",
    this.sourceType = "",
    this.word_count = 0,
    this.llmContent = false,
    List<String>? sources,
  }) {
    this.sources = sources ?? <String>[];
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return {
      "adminUrl": adminUrl,
      "learningObjectives": learningObjectives,
      "sourceType": sourceType,
      "word_count": word_count,
      "llmContent": llmContent ? "1" : "0",
      "sources": sources,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}
