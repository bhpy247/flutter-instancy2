import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../../../utils/my_utils.dart';

class AssessmentGenerateRequestModel {
  String adminUrl = "";
  String learningObjectives = "";
  String numberOfQuestions = "";
  String requestedBy = "";
  String content = "";
  String difficultyLevel = "";
  String type = "";
  String prompt = "";
  bool isContentAvailable = true;

  AssessmentGenerateRequestModel({
    this.adminUrl = "",
    this.learningObjectives = "",
    this.numberOfQuestions = "",
    this.requestedBy = "",
    this.content = "",
    this.difficultyLevel = "",
    this.type = "",
    this.prompt = "",
    this.isContentAvailable = true,
  });

  AssessmentGenerateRequestModel.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> map) {
    adminUrl = ParsingHelper.parseStringMethod(map['adminUrl']);
    learningObjectives = ParsingHelper.parseStringMethod(map['learningObjectives']);
    numberOfQuestions = ParsingHelper.parseStringMethod(map['numberOfQuestions']);
    requestedBy = ParsingHelper.parseStringMethod(map['requestedBy']);
    content = ParsingHelper.parseStringMethod(map['content']);
    difficultyLevel = ParsingHelper.parseStringMethod(map['difficultyLevel']);
    type = ParsingHelper.parseStringMethod(map['type']);
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return {
      'adminUrl': adminUrl,
      'learningObjectives': learningObjectives,
      'numberOfQuestions': numberOfQuestions,
      'requestedBy': requestedBy,
      'content': content,
      'difficultyLevel': difficultyLevel,
      'type': type,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}
