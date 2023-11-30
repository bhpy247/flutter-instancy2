import 'package:flutter_instancy_2/utils/my_utils.dart';

class LeaderboardRequestModel {
  String Locale = "";
  String Mode = "";
  String GroupIDList = "";
  String JobRoleIDList = "";
  String fromAchievement = "true";
  int UserID = 0;
  int SiteID = 0;
  int ComponentID = 0;
  int ComponentInsID = 0;
  int GameID = -1;
  bool LeaderByGroup = false;

  LeaderboardRequestModel({
    this.Locale = "",
    this.Mode = "",
    this.GroupIDList = "",
    this.JobRoleIDList = "",
    this.fromAchievement = "true",
    this.UserID = 0,
    this.SiteID = 0,
    this.ComponentID = 0,
    this.ComponentInsID = 0,
    this.GameID = -1,
    this.LeaderByGroup = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "Locale": Locale,
      "Mode": Mode,
      "GroupIDList": GroupIDList,
      "JobRoleIDList": JobRoleIDList,
      "fromAchievement": fromAchievement,
      "UserID": UserID,
      "SiteID": SiteID,
      "ComponentID": ComponentID,
      "ComponentInsID": ComponentInsID,
      "GameID": GameID,
      "LeaderByGroup": LeaderByGroup,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
