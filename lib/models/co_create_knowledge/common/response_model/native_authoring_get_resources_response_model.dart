import 'package:flutter_instancy_2/models/co_create_knowledge/common/data_model/native_authoring_get_resources_web_source_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/data_model/native_authoring_get_resources_youtube_source_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class NativeAuthoringGetResourcesResponseModel {
  String next_page_token = "";
  List<NativeAuthoringGetResourcesWebSourceModel> sources_from_web = <NativeAuthoringGetResourcesWebSourceModel>[];
  List<NativeAuthoringGetResourcesYoutubeSourceModel> sources_from_youtube = <NativeAuthoringGetResourcesYoutubeSourceModel>[];

  NativeAuthoringGetResourcesResponseModel({
    this.next_page_token = "",
    List<NativeAuthoringGetResourcesWebSourceModel>? sources_from_web,
    List<NativeAuthoringGetResourcesYoutubeSourceModel>? sources_from_youtube,
  }) {
    this.sources_from_web = sources_from_web ?? <NativeAuthoringGetResourcesWebSourceModel>[];
    this.sources_from_youtube = sources_from_youtube ?? <NativeAuthoringGetResourcesYoutubeSourceModel>[];
  }

  NativeAuthoringGetResourcesResponseModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    next_page_token = map["next_page_token"] != null ? ParsingHelper.parseStringMethod(map["next_page_token"]) : next_page_token;

    if (map["sources_from_web"] != null) {
      List<Map<String, dynamic>> sourcesFromWebMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(map["sources_from_web"]);
      sources_from_web = sourcesFromWebMapsList.map((e) => NativeAuthoringGetResourcesWebSourceModel.fromMap(e)).toList();
    }

    if (map["sources_from_youtube"] != null) {
      List<Map<String, dynamic>> sourcesFromYoutubeMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(map["sources_from_youtube"]);
      sources_from_youtube = sourcesFromYoutubeMapsList.map((e) => NativeAuthoringGetResourcesYoutubeSourceModel.fromMap(e)).toList();
    }
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return <String, dynamic>{
      "next_page_token": next_page_token,
      "sources_from_web": sources_from_web.map((e) => e.toMap(toJson: toJson)).toList(),
      "sources_from_youtube": sources_from_youtube.map((e) => e.toMap(toJson: toJson)).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}
