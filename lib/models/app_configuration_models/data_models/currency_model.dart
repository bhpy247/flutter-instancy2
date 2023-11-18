import 'package:flutter_instancy_2/utils/my_utils.dart';

import '../../../utils/parsing_helper.dart';

// "UserCurrency": "$",
// "ConversionRate": 1,
// "CurrencyCode": "USD"

class CurrencyModel {
  String UserCurrency = "";
  String CurrencyCode = "";
  double ConversionRate = 0;

  CurrencyModel({
    this.UserCurrency = "",
    this.CurrencyCode = "",
    this.ConversionRate = 0,
  });

  CurrencyModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    UserCurrency = ParsingHelper.parseStringMethod(map['UserCurrency']);
    CurrencyCode = ParsingHelper.parseStringMethod(map['CurrencyCode']);
    ConversionRate = ParsingHelper.parseDoubleMethod(map['ConversionRate']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "UserCurrency": UserCurrency,
      "CurrencyCode": CurrencyCode,
      "ConversionRate": ConversionRate,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
