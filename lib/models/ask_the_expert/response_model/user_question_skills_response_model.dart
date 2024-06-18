import 'package:flutter_chat_bot/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/data_model/user_question_skill_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';

class UserQuestionSkillsResponseModel {
  List<UserQuestionSkillModel> Table = <UserQuestionSkillModel>[];

  UserQuestionSkillsResponseModel({
    List<UserQuestionSkillModel>? Table,
  }) {
    this.Table = Table ?? <UserQuestionSkillModel>[];
  }

  UserQuestionSkillsResponseModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    if (map["Table"] != null) {
      List<Map<String, dynamic>> TableMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(map["Table"]);
      Table = TableMapsList.map((e) => UserQuestionSkillModel.fromMap(e)).toList();
    }
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return <String, dynamic>{
      "Table": Table.map((e) => e.toMap(toJson: toJson)).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}
