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
}
