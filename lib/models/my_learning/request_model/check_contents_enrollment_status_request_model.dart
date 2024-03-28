import 'package:flutter_instancy_2/utils/my_utils.dart';

class CheckContentsEnrollmentStatusRequestModel {
  int userId = 0;
  int siteId = 0;
  String localeId = "";
  List<String> contentIds = <String>[];

  CheckContentsEnrollmentStatusRequestModel({
    this.userId = 0,
    this.siteId = 0,
    this.localeId = "",
    List<String>? contentIds,
  }) {
    this.contentIds = contentIds ?? <String>[];
  }

  Map<String, String> toJson() {
    return <String, String>{
      "userId": userId.toString(),
      "siteId": siteId.toString(),
      "localeId": localeId,
      "contentIds": contentIds.join(","),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
