import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class GameActivityLevelDataModel {
  String levelName = "";
  String levelMessage = "";

  GameActivityLevelDataModel({
    this.levelName = "",
    this.levelMessage = "",
  });

  GameActivityLevelDataModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> json) {
    levelName = ParsingHelper.parseStringMethod(json["levelName"]);
    levelMessage = ParsingHelper.parseStringMethod(json["levelMessage"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "levelName": levelName,
      "levelMessage": levelMessage,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
