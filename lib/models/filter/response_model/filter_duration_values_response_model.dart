import 'package:flutter_instancy_2/models/filter/data_model/filter_duration_value_model.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class FilterDurationValuesResponseModel {
  List<FilterDurationValueModel> Table = <FilterDurationValueModel>[];
  List<FilterDurationValueModel> Table1 = <FilterDurationValueModel>[];

  FilterDurationValuesResponseModel.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> tableList = ParsingHelper.parseMapsListMethod<String, dynamic>(json["Table"]);
    Table = tableList.map((e) {
      return FilterDurationValueModel.fromJson(e);
    }).toList();

    List<Map<String, dynamic>> table1List = ParsingHelper.parseMapsListMethod<String, dynamic>(json["Table1"]);
    Table1 = table1List.map((e) {
      return FilterDurationValueModel.fromJson(e);
    }).toList();
  }
}