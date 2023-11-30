import 'dart:core';

import 'package:flutter_instancy_2/models/gamification/data_model/users_leader_board_dto_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class LeaderBoardDTOModel {
  int TotalCount = 0;
  bool showBadges = false;
  bool showPoints = false;
  bool showLevels = false;
  bool showLoggedUserTop = false;
  List<UsersLeaderBoardDTOModel> LeaderBoardList = <UsersLeaderBoardDTOModel>[];

  LeaderBoardDTOModel({
    this.TotalCount = 0,
    this.showBadges = false,
    this.showPoints = false,
    this.showLevels = false,
    this.showLoggedUserTop = false,
    List<UsersLeaderBoardDTOModel>? LeaderBoardList,
  }) {
    this.LeaderBoardList = LeaderBoardList ?? <UsersLeaderBoardDTOModel>[];
  }

  LeaderBoardDTOModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    TotalCount = ParsingHelper.parseIntMethod(map['TotalCount']);
    showBadges = ParsingHelper.parseBoolMethod(map['showBadges']);
    showPoints = ParsingHelper.parseBoolMethod(map['showPoints']);
    showLevels = ParsingHelper.parseBoolMethod(map['showLevels']);
    showLoggedUserTop = ParsingHelper.parseBoolMethod(map['showLoggedUserTop']);

    LeaderBoardList.clear();
    List<Map<String, dynamic>> LeaderBoardMapList = ParsingHelper.parseMapsListMethod<String, dynamic>(map["LeaderBoardList"]);
    LeaderBoardList.addAll(LeaderBoardMapList.map((e) => UsersLeaderBoardDTOModel.fromMap(e)).toList());
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "TotalCount": TotalCount,
      "showBadges": showBadges,
      "showPoints": showPoints,
      "showLevels": showLevels,
      "showLoggedUserTop": showLoggedUserTop,
      "LeaderBoardList": LeaderBoardList.map((e) => e.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
