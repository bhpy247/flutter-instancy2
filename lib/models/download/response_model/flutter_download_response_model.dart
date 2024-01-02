import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';

class FlutterDownloadResponseModel {
  final String id;
  final DownloadTaskStatus status;
  final int progress;

  FlutterDownloadResponseModel({
    this.id = "",
    this.status = DownloadTaskStatus.undefined,
    this.progress = 0,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "status": status.name,
      "progress": progress,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
