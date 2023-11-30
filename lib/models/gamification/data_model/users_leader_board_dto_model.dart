import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class UsersLeaderBoardDTOModel {
  String GameName = "";
  String UserDisplayName = "";
  String UserEmail = "";
  String UserPicturePath = "";
  String LevelName = "";
  String ProfileAction = "";
  int GameID = 0;
  int intUserID = 0;
  int intSiteID = 0;
  int proflieleaderboarduserid = 0;
  int Points = 0;
  int Badges = 0;
  int Rank = 0;

  UsersLeaderBoardDTOModel({
    this.GameName = "",
    this.UserDisplayName = "",
    this.UserEmail = "",
    this.UserPicturePath = "",
    this.LevelName = "",
    this.ProfileAction = "",
    this.GameID = 0,
    this.intUserID = 0,
    this.intSiteID = 0,
    this.proflieleaderboarduserid = 0,
    this.Points = 0,
    this.Badges = 0,
    this.Rank = 0,
  });

  UsersLeaderBoardDTOModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    GameName = ParsingHelper.parseStringMethod(map['GameName']);
    UserDisplayName = ParsingHelper.parseStringMethod(map['UserDisplayName']);
    UserEmail = ParsingHelper.parseStringMethod(map['UserEmail']);
    UserPicturePath = ParsingHelper.parseStringMethod(map['UserPicturePath']);
    LevelName = ParsingHelper.parseStringMethod(map['LevelName']);
    ProfileAction = ParsingHelper.parseStringMethod(map['ProfileAction']);
    GameID = ParsingHelper.parseIntMethod(map['GameID']);
    intUserID = ParsingHelper.parseIntMethod(map['intUserID']);
    intSiteID = ParsingHelper.parseIntMethod(map['intSiteID']);
    proflieleaderboarduserid = ParsingHelper.parseIntMethod(map['proflieleaderboarduserid']);
    Points = ParsingHelper.parseIntMethod(map['Points']);
    Badges = ParsingHelper.parseIntMethod(map['Badges']);
    Rank = ParsingHelper.parseIntMethod(map['Rank']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "GameName": GameName,
      "UserDisplayName": UserDisplayName,
      "UserEmail": UserEmail,
      "UserPicturePath": UserPicturePath,
      "LevelName": LevelName,
      "ProfileAction": ProfileAction,
      "GameID": GameID,
      "intUserID": intUserID,
      "intSiteID": intSiteID,
      "proflieleaderboarduserid": proflieleaderboarduserid,
      "Points": Points,
      "Badges": Badges,
      "Rank": Rank,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
