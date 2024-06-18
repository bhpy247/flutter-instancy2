import 'package:flutter_instancy_2/models/co_create_knowledge/micro_learning_model/data_model/micro_learning_page_element_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class MicroLearningPageModel {
  String title = "";
  List<MicroLearningPageElementModel> elements = <MicroLearningPageElementModel>[];

  MicroLearningPageModel({
    this.title = "",
    List<MicroLearningPageElementModel>? elements,
  }) {
    this.elements = elements ?? <MicroLearningPageElementModel>[];
  }

  MicroLearningPageModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    title = map["title"] != null ? ParsingHelper.parseStringMethod(map["title"]) : title;

    if (map["elements"] != null) {
      List<Map<String, dynamic>> elementsMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(map["elements"]);
      elements = elementsMapsList.map((e) => MicroLearningPageElementModel.fromMap(e)).toList();
    }
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return <String, dynamic>{
      "title": title,
      "elements": elements.map((e) => e.toMap(toJson: toJson)).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}
