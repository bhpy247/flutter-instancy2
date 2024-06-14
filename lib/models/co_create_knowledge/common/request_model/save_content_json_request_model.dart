import 'package:flutter_instancy_2/utils/my_utils.dart';

class SaveContentJsonRequestModel {
  String contentId = "";
  String folderPath = "";
  String contentData = "";
  int objectTypeId = 0;
  int mediaTypeId = 0;

  SaveContentJsonRequestModel({
    this.contentId = "",
    this.folderPath = "",
    this.contentData = "",
    this.objectTypeId = 0,
    this.mediaTypeId = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      "contentId": contentId,
      "folderPath": folderPath,
      "contentData": contentData,
      "objectTypeId": objectTypeId,
      "mediaTypeId": mediaTypeId,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
