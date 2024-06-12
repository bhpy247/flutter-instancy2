import 'package:flutter_instancy_2/models/co_create_knowledge/micro_learning_model/data_model/micro_learning_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class MicroLearningContentModel {
  List<MicroLearningModel> microLearningModelList = <MicroLearningModel>[];

  MicroLearningContentModel({
    List<MicroLearningModel>? microLearningModelList,
  }) {
    this.microLearningModelList = microLearningModelList ?? <MicroLearningModel>[];
  }

  MicroLearningContentModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    if (map["microLearningModelList"] != null) {
      List<Map<String, dynamic>> questionMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(map["microLearningModelList"]);
      microLearningModelList = questionMapsList.map((e) => MicroLearningModel.fromMap(e)).toList();
    }
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return <String, dynamic>{
      "microLearningModelList": microLearningModelList.map((e) => e.toMap(toJson: toJson)).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}
