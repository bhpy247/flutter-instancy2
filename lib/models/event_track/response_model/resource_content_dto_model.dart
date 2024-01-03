import 'package:flutter_instancy_2/models/event_track/data_model/related_track_data_dto_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class ResourceContentDTOModel {
  List<RelatedTrackDataDTOModel> ResouseList = <RelatedTrackDataDTOModel>[];
  int CourseCount = 0;

  ResourceContentDTOModel({
    this.CourseCount = 0,
    List<RelatedTrackDataDTOModel>? ResouseList,
  }) {
    this.ResouseList = ResouseList ?? <RelatedTrackDataDTOModel>[];
  }

  ResourceContentDTOModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    CourseCount = ParsingHelper.parseIntMethod(map["CourseCount"]);

    ResouseList.clear();
    List<Map<String, dynamic>> ResouseListMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(map["ResouseList"]);
    ResouseList.addAll(ResouseListMapsList.map((e) => RelatedTrackDataDTOModel.fromMap(e)));
  }

  Map<String, dynamic> toMap() {
    return {
      "CourseCount": CourseCount,
      "ResouseList": ResouseList.map((e) => e.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
