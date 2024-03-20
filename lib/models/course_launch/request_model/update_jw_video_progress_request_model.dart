import '../../../utils/my_utils.dart';

class UpdateJWVideoProgressRequestModel {
  int userId = 0;
  int SCOID = 0;
  int timeProgress = 0;
  int SiteID = 0;

  UpdateJWVideoProgressRequestModel({
    this.userId = 0,
    this.SCOID = 0,
    this.timeProgress = 0,
    this.SiteID = 0,
  });

  Map<String, String> toJson() {
    return {
      "userId": userId.toString(),
      "SCOID": SCOID.toString(),
      "timeProgress": timeProgress.toString(),
      "SiteID": SiteID.toString(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
