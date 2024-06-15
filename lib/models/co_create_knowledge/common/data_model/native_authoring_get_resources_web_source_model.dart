import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class NativeAuthoringGetResourcesWebSourceModel {
  String link = "";
  String snippet = "";
  String title = "";

  NativeAuthoringGetResourcesWebSourceModel({
    this.link = "",
    this.snippet = "",
    this.title = "",
  });

  NativeAuthoringGetResourcesWebSourceModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    link = map["link"] != null ? ParsingHelper.parseStringMethod(map["link"]) : link;
    snippet = map["snippet"] != null ? ParsingHelper.parseStringMethod(map["snippet"]) : snippet;
    title = map["title"] != null ? ParsingHelper.parseStringMethod(map["title"]) : title;
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return <String, dynamic>{
      "link": link,
      "snippet": snippet,
      "title": title,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}
