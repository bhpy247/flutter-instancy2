import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import 'game_activity_badge_data_model.dart';
import 'game_activity_level_data_model.dart';
import 'game_activity_points_data_model.dart';

class GameActivityDataModel {
  String gameName = "";
  int gameId = 0;
  List<GameActivityPointsDataModel> pointsData = <GameActivityPointsDataModel>[];
  List<GameActivityBadgeDataModel> badgeData = <GameActivityBadgeDataModel>[];
  List<GameActivityLevelDataModel> levelData = <GameActivityLevelDataModel>[];

  GameActivityDataModel({
    this.gameName = "",
    this.gameId = 0,
    List<GameActivityPointsDataModel>? pointsData,
    List<GameActivityBadgeDataModel>? badgeData,
    List<GameActivityLevelDataModel>? levelData,
  }) {
    this.pointsData = pointsData ?? <GameActivityPointsDataModel>[];
    this.badgeData = badgeData ?? <GameActivityBadgeDataModel>[];
    this.levelData = levelData ?? <GameActivityLevelDataModel>[];
  }

  GameActivityDataModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    gameName = ParsingHelper.parseStringMethod(map['gameName']);
    gameId = ParsingHelper.parseIntMethod(map['gameId']);

    pointsData = ParsingHelper.parseMapsListMethod<String, dynamic>(map['pointsData']).map((e) => GameActivityPointsDataModel.fromMap(e)).toList();
    badgeData = ParsingHelper.parseMapsListMethod<String, dynamic>(map['badgeData']).map((e) => GameActivityBadgeDataModel.fromMap(e)).toList();
    levelData = ParsingHelper.parseMapsListMethod<String, dynamic>(map['levelData']).map((e) => GameActivityLevelDataModel.fromMap(e)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      "gameName": gameName,
      "gameId": gameId,
      "pointsData": pointsData.map((e) => e.toMap()).toList(),
      "badgeData": badgeData.map((e) => e.toMap()).toList(),
      "levelData": levelData.map((e) => e.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
