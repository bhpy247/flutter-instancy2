import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class NativeAuthoringGetResourcesYoutubeSourceModel {
  String url = "";
  String thumbnail = "";
  String title = "";

  NativeAuthoringGetResourcesYoutubeSourceModel({
    this.url = "",
    this.thumbnail = "",
    this.title = "",
  });

  NativeAuthoringGetResourcesYoutubeSourceModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    url = map["url"] != null ? ParsingHelper.parseStringMethod(map["url"]) : url;
    thumbnail = map["thumbnail"] != null ? ParsingHelper.parseStringMethod(map["thumbnail"]) : thumbnail;
    title = map["title"] != null ? ParsingHelper.parseStringMethod(map["title"]) : title;
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return <String, dynamic>{
      "url": url,
      "thumbnail": thumbnail,
      "title": title,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}
