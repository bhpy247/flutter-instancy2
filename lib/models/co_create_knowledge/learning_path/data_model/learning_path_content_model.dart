import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';

import '../../../../utils/my_utils.dart';
import '../../../../utils/parsing_helper.dart';

class LearningPathContentModel {
  List<BlockListModel> blockListModel = [];
  Map<String, List<CourseDTOModel>>? learningPathList;

  LearningPathContentModel({
    this.learningPathList,
    this.blockListModel = const [],
  });

  LearningPathContentModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    if (map["blockListModel"] != null) {
      List<Map<String, dynamic>> blockListModelList = ParsingHelper.parseMapsListMethod<String, dynamic>(map["blockListModel"]);
      blockListModel = blockListModelList.map((e) => BlockListModel.fromMap(e)).toList();
    }

    if (map["learningPathList"] != null) {
      learningPathList = ParsingHelper.parseMapMethod(map["learningPathList"]);
    }
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return {"blockListModel": blockListModel.map((e) => e.toMap()).toList()};
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}

class BlockListModel {
  String blockName = "";
  List<CourseDTOModel> blockContentList = [];

  BlockListModel({this.blockName = "", this.blockContentList = const []});

  BlockListModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    blockName = map["blockName"] != null ? ParsingHelper.parseStringMethod(map["blockName"]) : blockName;

    if (map["blockContentList"] != null) {
      List<Map<String, dynamic>> flashcardMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(map["blockContentList"]);
      blockContentList = flashcardMapsList.map((e) => CourseDTOModel.fromMap(e)).toList();
    }
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return {"blockName": blockName, "blockContentList": blockContentList.map((e) => e.toMap()).toList()};
  }
}
