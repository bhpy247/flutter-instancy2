import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class WorkflowRulesDTOModel {
  String USerID = "";
  String TrackID = "";
  String TrackObjectID = "";
  String result = "";
  String wmessage = "";
  String RuleID = "";
  String StepID = "";

  WorkflowRulesDTOModel({
    this.USerID = "",
    this.TrackID = "",
    this.TrackObjectID = "",
    this.result = "",
    this.wmessage = "",
    this.RuleID = "",
    this.StepID = "",
  });

  WorkflowRulesDTOModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    USerID = ParsingHelper.parseStringMethod(map["USerID"]);
    TrackID = ParsingHelper.parseStringMethod(map["TrackID"]);
    TrackObjectID = ParsingHelper.parseStringMethod(map["TrackObjectID"]);
    result = ParsingHelper.parseStringMethod(map["result"]);
    wmessage = ParsingHelper.parseStringMethod(map["wmessage"]);
    RuleID = ParsingHelper.parseStringMethod(map["RuleID"]);
    StepID = ParsingHelper.parseStringMethod(map["StepID"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "USerID": USerID,
      "TrackID": TrackID,
      "TrackObjectID": TrackObjectID,
      "result": result,
      "wmessage": wmessage,
      "RuleID": RuleID,
      "StepID": StepID,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
