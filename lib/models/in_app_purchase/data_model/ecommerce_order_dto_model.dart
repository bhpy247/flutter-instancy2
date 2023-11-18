import 'package:flutter_instancy_2/utils/my_utils.dart';

import '../../../utils/parsing_helper.dart';

class EcommerceOrderDTOModel {
  String ContentID = "";
  String CurrencySign = "";
  String ItemName = "";
  String PaymentType = "";
  String PurchaseDate = "";
  String PurchasedDate = "";
  String VerisignTransID = "";
  int RN = 0;
  int UserID = 0;
  double Price = 0;
  bool CombinedTransaction = false;
  DateTime? PurchaseDateTime;

  EcommerceOrderDTOModel({
    this.ContentID = "",
    this.CurrencySign = "",
    this.ItemName = "",
    this.PaymentType = "",
    this.PurchaseDate = "",
    this.PurchasedDate = "",
    this.VerisignTransID = "",
    this.RN = 0,
    this.UserID = 0,
    this.Price = 0,
    this.CombinedTransaction = false,
    this.PurchaseDateTime,
  });

  EcommerceOrderDTOModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    ContentID = ParsingHelper.parseStringMethod(map['ContentID']);
    CurrencySign = ParsingHelper.parseStringMethod(map['CurrencySign']);
    ItemName = ParsingHelper.parseStringMethod(map['ItemName']);
    PaymentType = ParsingHelper.parseStringMethod(map['PaymentType']);
    PurchaseDate = ParsingHelper.parseStringMethod(map['PurchaseDate']);
    PurchasedDate = ParsingHelper.parseStringMethod(map['PurchasedDate']);
    VerisignTransID = ParsingHelper.parseStringMethod(map['VerisignTransID']);
    RN = ParsingHelper.parseIntMethod(map['RN']);
    UserID = ParsingHelper.parseIntMethod(map['UserID']);
    Price = ParsingHelper.parseDoubleMethod(map['Price']);
    CombinedTransaction = ParsingHelper.parseBoolMethod(map['CombinedTransaction']);

    PurchaseDateTime = ParsingHelper.parseDateTimeMethod(PurchaseDate);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "ContentID": ContentID,
      "CurrencySign": CurrencySign,
      "ItemName": ItemName,
      "PaymentType": PaymentType,
      "PurchaseDate": PurchaseDate,
      "PurchasedDate": PurchasedDate,
      "VerisignTransID": VerisignTransID,
      "RN": RN,
      "UserID": UserID,
      "Price": Price,
      "CombinedTransaction": CombinedTransaction,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
