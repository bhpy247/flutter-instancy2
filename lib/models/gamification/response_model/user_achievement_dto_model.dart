import 'dart:core';

import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../data_model/user_badges_model.dart';
import '../data_model/user_level_model.dart';
import '../data_model/user_over_all_data_model.dart';
import '../data_model/user_points_model.dart';

class UserAchievementDTOModel {
  bool showBadgeSection = false;
  bool showPointSection = false;
  bool showLevelSection = false;
  UserOverAllDataModel? UserOverAllData;
  List<UserPointsModel> UserPoints = <UserPointsModel>[];
  List<UserLevelModel> UserLevel = <UserLevelModel>[];
  List<UserBadgesModel> UserBadges = <UserBadgesModel>[];

  UserAchievementDTOModel({
    this.showBadgeSection = false,
    this.showPointSection = false,
    this.showLevelSection = false,
    this.UserOverAllData,
    List<UserPointsModel>? UserPoints,
    List<UserLevelModel>? UserLevel,
    List<UserBadgesModel>? UserBadges,
  }) {
    this.UserPoints = UserPoints ?? <UserPointsModel>[];
    this.UserLevel = UserLevel ?? <UserLevelModel>[];
    this.UserBadges = UserBadges ?? <UserBadgesModel>[];
  }

  UserAchievementDTOModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    showBadgeSection = ParsingHelper.parseBoolMethod(map['showBadgeSection']);
    showPointSection = ParsingHelper.parseBoolMethod(map['showPointSection']);
    showLevelSection = ParsingHelper.parseBoolMethod(map['showLevelSection']);

    Map<String, dynamic> UserOverAllDataMap = ParsingHelper.parseMapMethod(map['UserOverAllData']);
    UserOverAllData = UserOverAllDataMap.isNotEmpty ? UserOverAllDataModel.fromMap(UserOverAllDataMap) : null;

    UserPoints.clear();
    List<Map<String, dynamic>> UserPointsMapList = ParsingHelper.parseMapsListMethod<String, dynamic>(map["UserPoints"]);
    UserPoints.addAll(UserPointsMapList.map((e) => UserPointsModel.fromMap(e)).toList());

    UserLevel.clear();
    List<Map<String, dynamic>> UserLevelMapList = ParsingHelper.parseMapsListMethod<String, dynamic>(map["UserLevel"]);
    UserLevel.addAll(UserLevelMapList.map((e) => UserLevelModel.fromMap(e)).toList());

    UserBadges.clear();
    List<Map<String, dynamic>> UserBadgesMapList = ParsingHelper.parseMapsListMethod<String, dynamic>(map["UserBadges"]);
    UserBadges.addAll(UserBadgesMapList.map((e) => UserBadgesModel.fromMap(e)).toList());
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "showBadgeSection": showBadgeSection,
      "showPointSection": showPointSection,
      "showLevelSection": showLevelSection,
      "UserOverAllData": UserOverAllData?.toMap(),
      "UserPoints": UserPoints.map((e) => e.toMap()).toList(),
      "UserLevel": UserLevel.map((e) => e.toMap()).toList(),
      "UserBadges": UserBadges.map((e) => e.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
