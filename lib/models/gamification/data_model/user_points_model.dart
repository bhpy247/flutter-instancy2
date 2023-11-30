import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class UserPointsModel {
  String ActionName = "";
  String Description = "";
  String UserReceivedDate = "";
  int ActionID = 0;
  int Points = 0;

  UserPointsModel({
    this.ActionName = "",
    this.Description = "",
    this.UserReceivedDate = "",
    this.ActionID = 0,
    this.Points = 0,
  });

  UserPointsModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    ActionName = ParsingHelper.parseStringMethod(map['ActionName']);
    Description = ParsingHelper.parseStringMethod(map['Description']);
    UserReceivedDate = ParsingHelper.parseStringMethod(map['UserReceivedDate']);
    ActionID = ParsingHelper.parseIntMethod(map['ActionID']);
    Points = ParsingHelper.parseIntMethod(map['Points']);
  }

  Map<String, dynamic> toMap() {
    return {
      "ActionName": ActionName,
      "Description": Description,
      "UserReceivedDate": UserReceivedDate,
      "ActionID": ActionID,
      "Points": Points,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
