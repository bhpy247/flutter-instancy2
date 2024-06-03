import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';

class LearningPathModel {
  List<BlockListModel>? blockListModel;
  Map<String, List<CourseDTOModel>>? learningPathList;

  LearningPathModel({this.learningPathList, this.blockListModel = const []});
}

class BlockListModel {
  String blockName = "";
  List<CourseDTOModel>? blockContentList;

  BlockListModel({this.blockName = "", this.blockContentList});
}
