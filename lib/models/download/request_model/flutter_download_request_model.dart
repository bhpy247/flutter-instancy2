import 'package:flutter_instancy_2/utils/my_utils.dart';

class FlutterDownloadRequestModel {
  String downloadUrl = "";
  String destinationFolderPath = "";
  String fileName = "";
  bool requiresStorageNotLow = true;
  bool showNotification = false;
  bool openFileFromNotification = false;

  FlutterDownloadRequestModel({
    required this.downloadUrl,
    required this.destinationFolderPath,
    required this.fileName,
    this.requiresStorageNotLow = true,
    this.showNotification = false,
    this.openFileFromNotification = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "downloadUrl": downloadUrl,
      "destinationFolderPath": destinationFolderPath,
      "fileName": fileName,
      "requiresStorageNotLow": requiresStorageNotLow,
      "showNotification": showNotification,
      "openFileFromNotification": openFileFromNotification,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
