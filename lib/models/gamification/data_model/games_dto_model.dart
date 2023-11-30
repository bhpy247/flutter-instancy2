import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class GamesDTOModel {
  String GameName = "";
  int GameID = 0;

  GamesDTOModel({
    this.GameID = 0,
    this.GameName = "",
  });

  GamesDTOModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> json) {
    GameName = ParsingHelper.parseStringMethod(json["GameName"]);
    GameID = ParsingHelper.parseIntMethod(json["GameID"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "GameID": GameID,
      "GameName": GameName,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
