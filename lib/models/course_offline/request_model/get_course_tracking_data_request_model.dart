import 'package:flutter_instancy_2/utils/my_utils.dart';

class GetCourseTrackingDataRequestModel {
  int studid = 0;
  int scoid = 0;
  String SiteURL = "";
  String contentId = "";
  String trackId = "";

  GetCourseTrackingDataRequestModel({
    this.studid = 0,
    this.scoid = 0,
    this.SiteURL = "",
    this.contentId = "",
    this.trackId = "",
  });

  Map<String, String> toJson() {
    return <String, String>{
      "_studid": studid.toString(),
      "_scoid": scoid.toString(),
      "_SiteURL": SiteURL,
      "_contentId": contentId,
      "_trackId": trackId,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
