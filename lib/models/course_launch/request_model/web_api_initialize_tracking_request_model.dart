import '../../../configs/app_constants.dart';
import '../../../utils/my_utils.dart';

class WebApiInitializeTrackingRequestModel {
  int userId;
  int scoId;
  int objectTypeID;
  int siteid;
  String disbaleAdminViewTracking;
  String contentid;

  WebApiInitializeTrackingRequestModel({
    this.userId = 0,
    this.scoId = 0,
    this.objectTypeID = 0,
    this.siteid = AppConstants.defaultSiteId,
    this.disbaleAdminViewTracking = "false",
    this.contentid = "",
  });

  Map<String, String> toJson() {
    return {
      "userId": userId.toString(),
      "scoId": scoId.toString(),
      "objectTypeID": objectTypeID.toString(),
      "siteid": siteid.toString(),
      "disbaleAdminViewTracking": disbaleAdminViewTracking,
      "contentid": contentid,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}