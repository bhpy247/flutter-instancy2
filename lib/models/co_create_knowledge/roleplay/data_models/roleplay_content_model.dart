import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class RoleplayContentModel {
  String learningObjective = "";
  String participantRoleDescription = "";
  String participantTone = "";
  String participantAvatar = "";
  String learnerRoleDescription = "";
  String scenarioDescription = "";
  String evaluatorDescription = "";
  String evaluationCriteriaDescription = "";
  String evaluationFeedbackMechanism = "";
  String roleplayCompletionMessage = "";
  int messageCount = 0;
  bool isScore = false;

  RoleplayContentModel({
    this.learningObjective = "",
    this.participantRoleDescription = "",
    this.participantTone = "",
    this.participantAvatar = "",
    this.learnerRoleDescription = "",
    this.scenarioDescription = "",
    this.evaluatorDescription = "",
    this.evaluationCriteriaDescription = "",
    this.evaluationFeedbackMechanism = "",
    this.roleplayCompletionMessage = "",
    this.messageCount = 0,
    this.isScore = false,
  });

  RoleplayContentModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    learningObjective = map["learningObjective"] != null ? ParsingHelper.parseStringMethod(map["learningObjective"]) : learningObjective;
    participantRoleDescription = map["participantRoleDescription"] != null ? ParsingHelper.parseStringMethod(map["participantRoleDescription"]) : participantRoleDescription;
    participantTone = map["participantTone"] != null ? ParsingHelper.parseStringMethod(map["participantTone"]) : participantTone;
    participantAvatar = map["participantAvatar"] != null ? ParsingHelper.parseStringMethod(map["participantAvatar"]) : participantAvatar;
    learnerRoleDescription = map["learnerRoleDescription"] != null ? ParsingHelper.parseStringMethod(map["learnerRoleDescription"]) : learnerRoleDescription;
    scenarioDescription = map["scenarioDescription"] != null ? ParsingHelper.parseStringMethod(map["scenarioDescription"]) : scenarioDescription;
    evaluatorDescription = map["evaluatorDescription"] != null ? ParsingHelper.parseStringMethod(map["evaluatorDescription"]) : evaluatorDescription;
    evaluationCriteriaDescription = map["evaluationCriteriaDescription"] != null ? ParsingHelper.parseStringMethod(map["evaluationCriteriaDescription"]) : evaluationCriteriaDescription;
    evaluationFeedbackMechanism = map["evaluationFeedbackMechanism"] != null ? ParsingHelper.parseStringMethod(map["evaluationFeedbackMechanism"]) : evaluationFeedbackMechanism;
    roleplayCompletionMessage = map["roleplayCompletionMessage"] != null ? ParsingHelper.parseStringMethod(map["roleplayCompletionMessage"]) : roleplayCompletionMessage;
    messageCount = map["messageCount"] != null ? ParsingHelper.parseIntMethod(map["messageCount"]) : messageCount;
    isScore = map["isScore"] != null ? ParsingHelper.parseBoolMethod(map["isScore"]) : isScore;
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return <String, dynamic>{
      "learningObjective": learningObjective,
      "participantRoleDescription": participantRoleDescription,
      "participantTone": participantTone,
      "participantAvatar": participantAvatar,
      "learnerRoleDescription": learnerRoleDescription,
      "scenarioDescription": scenarioDescription,
      "evaluatorDescription": evaluatorDescription,
      "evaluationCriteriaDescription": evaluationCriteriaDescription,
      "evaluationFeedbackMechanism": evaluationFeedbackMechanism,
      "roleplayCompletionMessage": roleplayCompletionMessage,
      "messageCount": messageCount,
      "isScore": isScore,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}
