import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class UserLevelModel {
  String LevelName = "";
  String LevelRecivedDate = "";
  int LevelPoints = 0;
  int LevelID = 0;

  UserLevelModel({
    this.LevelName = "",
    this.LevelRecivedDate = "",
    this.LevelPoints = 0,
    this.LevelID = 0,
  });

  UserLevelModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    LevelName = ParsingHelper.parseStringMethod(map['LevelName']);
    LevelRecivedDate = ParsingHelper.parseStringMethod(map['LevelRecivedDate']);
    LevelPoints = ParsingHelper.parseIntMethod(map['LevelPoints']);
    LevelID = ParsingHelper.parseIntMethod(map['LevelID']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "LevelName": LevelName,
      "LevelRecivedDate": LevelRecivedDate,
      "LevelPoints": LevelPoints,
      "LevelID": LevelID,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
