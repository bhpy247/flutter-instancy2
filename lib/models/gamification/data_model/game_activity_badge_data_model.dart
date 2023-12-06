import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class GameActivityBadgeDataModel {
  String badgeName = "";
  String badgeImageUrl = "";
  String badgeMessage = "";

  GameActivityBadgeDataModel({
    this.badgeName = "",
    this.badgeImageUrl = "",
    this.badgeMessage = "",
  });

  GameActivityBadgeDataModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> json) {
    badgeName = ParsingHelper.parseStringMethod(json["badgeName"]);
    badgeImageUrl = ParsingHelper.parseStringMethod(json["badgeImageUrl"]);
    badgeMessage = ParsingHelper.parseStringMethod(json["badgeMessage"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "badgeName": badgeName,
      "badgeImageUrl": badgeImageUrl,
      "badgeMessage": badgeMessage,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
