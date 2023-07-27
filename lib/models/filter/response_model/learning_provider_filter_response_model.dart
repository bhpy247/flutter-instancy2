import 'package:flutter_instancy_2/models/filter/data_model/learning_provider_model.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class LearningProviderFilterResponseModel {
  List<LearningProviderModel> Table = <LearningProviderModel>[];

  LearningProviderFilterResponseModel.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> tableList = ParsingHelper.parseMapsListMethod<String, dynamic>(json["Table"]);
    Table = tableList.map((e) {
      return LearningProviderModel.fromJson(e);
    }).toList();
  }
}