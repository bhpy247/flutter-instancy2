import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../../utils/my_utils.dart';
import '../data_model/component_sort_model.dart';

class ComponentSortResponseModel {
  List<ComponentSortModel> Table = [];

  ComponentSortResponseModel({
    required this.Table,
  });

  ComponentSortResponseModel.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> TableListMap = ParsingHelper.parseMapsListMethod<String, dynamic>(json['Table']);
    Table = TableListMap.map((Map<String, dynamic> map) {
      return ComponentSortModel.fromJson(map);
    }).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      "Table": Table.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
