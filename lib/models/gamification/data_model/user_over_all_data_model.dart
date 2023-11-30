import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class UserOverAllDataModel {
  String UserLevel = "";
  String UserProfilePath = "";
  String UserDisplayName = "";
  String NeededLevel = "";
  int Badges = 0;
  int OverAllPoints = 0;
  int NeededPoints = 0;

  UserOverAllDataModel({
    this.UserLevel = "",
    this.UserProfilePath = "",
    this.UserDisplayName = "",
    this.NeededLevel = "",
    this.Badges = 0,
    this.OverAllPoints = 0,
    this.NeededPoints = 0,
  });

  UserOverAllDataModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    UserLevel = ParsingHelper.parseStringMethod(map['UserLevel']);
    UserProfilePath = ParsingHelper.parseStringMethod(map['UserProfilePath']);
    UserDisplayName = ParsingHelper.parseStringMethod(map['UserDisplayName']);
    NeededLevel = ParsingHelper.parseStringMethod(map['NeededLevel']);
    Badges = ParsingHelper.parseIntMethod(map['Badges']);
    OverAllPoints = ParsingHelper.parseIntMethod(map['OverAllPoints']);
    NeededPoints = ParsingHelper.parseIntMethod(map['NeededPoints']);
  }

  Map<String, dynamic> toMap() {
    return {
      "UserLevel": UserLevel,
      "UserProfilePath": UserProfilePath,
      "UserDisplayName": UserDisplayName,
      "NeededLevel": NeededLevel,
      "Badges": Badges,
      "OverAllPoints": OverAllPoints,
      "NeededPoints": NeededPoints,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
