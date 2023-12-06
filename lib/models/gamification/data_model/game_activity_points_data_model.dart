import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class GameActivityPointsDataModel {
  String pointMessage = "";
  int pointCount = 0;

  GameActivityPointsDataModel({
    this.pointMessage = "",
    this.pointCount = 0,
  });

  GameActivityPointsDataModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> json) {
    pointMessage = ParsingHelper.parseStringMethod(json["pointMessage"]);
    pointCount = ParsingHelper.parseIntMethod(json["pointCount"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "pointMessage": pointMessage,
      "pointCount": pointCount,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
