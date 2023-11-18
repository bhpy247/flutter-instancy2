import 'package:flutter_instancy_2/models/app_configuration_models/data_models/currency_model.dart';

import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class CurrencyDataResponseModel {
  List<CurrencyModel> Table = <CurrencyModel>[];

  CurrencyDataResponseModel({
    List<CurrencyModel>? Table,
  }) {
    this.Table = Table ?? <CurrencyModel>[];
  }

  CurrencyDataResponseModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    Table.clear();
    List<Map<String, dynamic>> TableMapList = ParsingHelper.parseMapsListMethod<String, dynamic>(map["Table"]);
    Table.addAll(TableMapList.map((e) => CurrencyModel.fromMap(e)).toList());
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "Table": Table.map((e) => e.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
