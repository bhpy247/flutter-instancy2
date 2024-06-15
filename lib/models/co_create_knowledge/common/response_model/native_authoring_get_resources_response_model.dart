import 'package:flutter_instancy_2/models/co_create_knowledge/common/data_model/native_authoring_get_resources_web_source_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class NativeAuthoringGetResourcesResponseModel {
  List<NativeAuthoringGetResourcesWebSourceModel> sources_from_web = <NativeAuthoringGetResourcesWebSourceModel>[];

  NativeAuthoringGetResourcesResponseModel({
    List<NativeAuthoringGetResourcesWebSourceModel>? sources_from_web,
  }) {
    this.sources_from_web = sources_from_web ?? <NativeAuthoringGetResourcesWebSourceModel>[];
  }

  NativeAuthoringGetResourcesResponseModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    if (map["sources_from_web"] != null) {
      List<Map<String, dynamic>> sourcesFromWebMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(map["sources_from_web"]);
      sources_from_web = sourcesFromWebMapsList.map((e) => NativeAuthoringGetResourcesWebSourceModel.fromMap(e)).toList();
    }
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return <String, dynamic>{
      "sources_from_web": sources_from_web.map((e) => e.toMap(toJson: toJson)).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}
