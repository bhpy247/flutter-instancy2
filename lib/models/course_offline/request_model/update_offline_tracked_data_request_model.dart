import 'package:flutter_instancy_2/utils/my_utils.dart';

class UpdateOfflineTrackedDataRequestModel {
  String studId = "";
  String scoId = "";
  String siteURL = "";
  String siteID = "";
  String requestString = "";

  UpdateOfflineTrackedDataRequestModel({
    this.studId = "",
    this.scoId = "",
    this.siteURL = "",
    this.siteID = "",
    this.requestString = "",
  });

  Map<String, String> toMap() {
    return <String, String>{
      "_studId": studId,
      "_scoId": scoId,
      "_siteURL": siteURL,
      "_siteID": siteID,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
