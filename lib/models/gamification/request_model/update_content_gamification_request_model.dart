import 'package:flutter_instancy_2/utils/my_utils.dart';

class UpdateContentGamificationRequestModel {
  String contentId = "";
  int scoId;
  int objecttypeId = 0;
  int userId = -1;
  int siteId = 374;
  int GameAction = 0;
  bool CanTrack = false;
  bool isCourseLaunch = false;
  bool IsFromNativeApp = true;

  UpdateContentGamificationRequestModel({
    required this.contentId,
    required this.scoId,
    this.objecttypeId = 0,
    this.userId = -1,
    this.siteId = 374,
    this.GameAction = 0,
    this.CanTrack = false,
    this.isCourseLaunch = false,
    this.IsFromNativeApp = true,
  });

  Map<String, String> toMap() {
    return <String, String>{
      "contentId": contentId,
      "scoId": scoId.toString(),
      "objecttypeId": objecttypeId.toString(),
      "userId": userId.toString(),
      "siteId": siteId.toString(),
      "CanTrack": CanTrack.toString(),
      "isCourseLaunch": isCourseLaunch.toString(),
      "GameAction": GameAction.toString(),
      "IsFromNativeApp": IsFromNativeApp.toString(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
