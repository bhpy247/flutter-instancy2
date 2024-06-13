import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class VideoDetails {
  String videoID = "";
  String videoName = "";
  String videoInput = "";
  String videoStatus = "";

  VideoDetails({
    this.videoID = "",
    this.videoName = "",
    this.videoInput = "",
    this.videoStatus = "",
  });

  VideoDetails.fromJson(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) => _initializeFromMap(map);

  void _initializeFromMap(Map<String, dynamic> map) {
    videoID = ParsingHelper.parseStringMethod(map['videoID']);
    videoName = ParsingHelper.parseStringMethod(map['videoName']);
    videoInput = ParsingHelper.parseStringMethod(map['videoInput']);
    videoStatus = ParsingHelper.parseStringMethod(map['videoStatus']);
  }

  Map<String, dynamic> toJson() {
    return {
      'videoID': videoID,
      'videoName': videoName,
      'videoInput': videoInput,
      'videoStatus': videoStatus,
    };
  }
}
