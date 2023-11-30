import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class UserBadgesModel {
  String BadgeName = "";
  String BadgeDescription = "";
  String BadgeImage = "";
  String BadgeReceivedDate = "";
  int BadgeID = 0;

  UserBadgesModel({
    this.BadgeName = "",
    this.BadgeDescription = "",
    this.BadgeImage = "",
    this.BadgeReceivedDate = "",
    this.BadgeID = 0,
  });

  UserBadgesModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    BadgeName = ParsingHelper.parseStringMethod(map['BadgeName']);
    BadgeDescription = ParsingHelper.parseStringMethod(map['BadgeDescription']);
    BadgeImage = ParsingHelper.parseStringMethod(map['BadgeImage']);
    BadgeReceivedDate = ParsingHelper.parseStringMethod(map['BadgeReceivedDate']);
    BadgeID = ParsingHelper.parseIntMethod(map['BadgeID']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "BadgeName": BadgeName,
      "BadgeDescription": BadgeDescription,
      "BadgeImage": BadgeImage,
      "BadgeReceivedDate": BadgeReceivedDate,
      "BadgeID": BadgeID,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
