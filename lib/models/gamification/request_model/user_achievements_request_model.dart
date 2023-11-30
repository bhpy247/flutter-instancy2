import 'package:flutter_instancy_2/utils/my_utils.dart';

class UserAchievementsRequestModel {
  String Locale = "";
  int UserID = 0;
  int SiteID = 0;
  int ComponentID = 0;
  int ComponentInsID = 0;
  int GameID = 0;

  UserAchievementsRequestModel({
    this.Locale = "",
    this.UserID = 0,
    this.SiteID = 0,
    this.ComponentID = 0,
    this.ComponentInsID = 0,
    this.GameID = 0,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "Locale": Locale,
      "UserID": UserID,
      "SiteID": SiteID,
      "ComponentID": ComponentID,
      "ComponentInsID": ComponentInsID,
      "GameID": GameID,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
