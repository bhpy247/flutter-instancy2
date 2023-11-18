import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';
import '../data_model/ecommerce_order_dto_model.dart';

class EcommerceOrderResponseModel {
  List<EcommerceOrderDTOModel> Table = <EcommerceOrderDTOModel>[];
  String monthString = "";

  EcommerceOrderResponseModel({
    List<EcommerceOrderDTOModel>? Table,
    this.monthString = "",
  }) {
    this.Table = Table ?? <EcommerceOrderDTOModel>[];
  }

  EcommerceOrderResponseModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    Table.clear();
    List<Map<String, dynamic>> TableMapList = ParsingHelper.parseMapsListMethod<String, dynamic>(map["Table"]);
    Table.addAll(TableMapList.map((e) => EcommerceOrderDTOModel.fromMap(e)).toList());
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
