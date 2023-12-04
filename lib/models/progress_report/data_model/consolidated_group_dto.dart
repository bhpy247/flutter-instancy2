import 'package:flutter_chat_bot/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/models/progress_report/data_model/credit_dto.dart';
import 'package:flutter_instancy_2/models/progress_report/data_model/parent_data_dto.dart';
import 'package:flutter_instancy_2/models/progress_report/data_model/status_count_dto.dart';

import '../../../utils/my_utils.dart';
import 'overall_score_dto.dart';

class ConsolidatedGroupDTO {
  int groupValue = 0;
  String groupText = "";
  List<ParentDataDto> parentData = [];
  List<ContentCountDTO> contentCountData = [];
  List<StatusCountDTO> statusCountData = [];
  List<OverallScoreDTO> scoreCount = [];
  List<ScoreMaxDTO> scoreMaxCount = [];
  List<CreditDto> scoreCredit = [];

  ConsolidatedGroupDTO(
      {this.groupValue = 0,
      this.groupText = "",
      this.parentData = const [],
      this.contentCountData = const [],
      this.statusCountData = const [],
      this.scoreCount = const [],
      this.scoreMaxCount = const [],
      this.scoreCredit = const []});

  ConsolidatedGroupDTO.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> json) {
    groupValue = ParsingHelper.parseIntMethod(json['GroupValue']);
    groupText = ParsingHelper.parseStringMethod(json['GroupText']);
    parentData.clear();
    List<Map<String, dynamic>> parentDataDataMapList = ParsingHelper.parseMapsListMethod<String, dynamic>(json["ParentData"]);
    parentData.addAll(parentDataDataMapList.map((e) => ParentDataDto.fromJson(e)).toList());

    contentCountData.clear();
    List<Map<String, dynamic>> contentCountDataMapList = ParsingHelper.parseMapsListMethod<String, dynamic>(json["ContentCountData"]);
    contentCountData.addAll(contentCountDataMapList.map((e) => ContentCountDTO.fromJson(e)).toList());

    statusCountData.clear();
    List<Map<String, dynamic>> statusCountDataMapList = ParsingHelper.parseMapsListMethod<String, dynamic>(json["StatusCountData"]);
    statusCountData.addAll(statusCountDataMapList.map((e) => StatusCountDTO.fromJson(e)).toList());

    scoreMaxCount.clear();
    List<Map<String, dynamic>> ScoreMaxCountMapList = ParsingHelper.parseMapsListMethod<String, dynamic>(json["ScoreMaxCount"]);
    scoreMaxCount.addAll(ScoreMaxCountMapList.map((e) => ScoreMaxDTO.fromJson(e)).toList());

    scoreCount.clear();
    List<Map<String, dynamic>> ScoreCountMapList = ParsingHelper.parseMapsListMethod<String, dynamic>(json["ScoreCount"]);
    scoreCount.addAll(ScoreCountMapList.map((e) => OverallScoreDTO.fromJson(e)).toList());

    scoreCredit.clear();
    List<Map<String, dynamic>> scoreCreditList = ParsingHelper.parseMapsListMethod<String, dynamic>(json["ScoreCredit"]);
    scoreCredit.addAll(scoreCreditList.map((e) => CreditDto.fromJson(e)).toList());
  }

  Map<String, dynamic> toJson() {
    return {
      "GroupValue": groupValue,
      "GroupText": groupText,
      "ParentData": parentData.map((e) => e.toJson()).toList(),
      "ContentCountData": contentCountData.map((e) => e.toMap()).toList(),
      "StatusCountData": statusCountData.map((e) => e.toMap()).toList(),
      "ScoreCount": scoreCount.map((e) => e.toMap()).toList(),
      "ScoreMaxCount": scoreMaxCount.map((e) => e.toMap()).toList(),
      "ScoreCredit": scoreCredit.map((e) => e.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
