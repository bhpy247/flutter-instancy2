import 'package:flutter_instancy_2/models/gamification/data_model/game_activity_data_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class ContentGameActivityResponseModel {
  String NotifyMessage = "";
  String status = "";
  List<GameActivityDataModel> GameActivities = <GameActivityDataModel>[];

  ContentGameActivityResponseModel({
    this.NotifyMessage = "",
    this.status = "",
    List<GameActivityDataModel>? GameActivities,
  }) {
    this.GameActivities = GameActivities ?? <GameActivityDataModel>[];
  }

  ContentGameActivityResponseModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    NotifyMessage = ParsingHelper.parseStringMethod(map['NotifyMessage']);
    status = ParsingHelper.parseStringMethod(map['status']);

    GameActivities.clear();
    List<Map<String, dynamic>> LeaderBoardMapList = ParsingHelper.parseMapsListMethod<String, dynamic>(map["GameActivities"]);
    GameActivities.addAll(LeaderBoardMapList.map((e) => GameActivityDataModel.fromMap(e)).toList());
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "NotifyMessage": NotifyMessage,
      "status": status,
      "GameActivities": GameActivities.map((e) => e.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
