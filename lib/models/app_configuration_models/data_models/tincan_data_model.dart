import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../../utils/my_utils.dart';

class TinCanDataModel {
  String lrsendpoint = "", lrsauthorization = "", lrsauthorizationpassword = "";
  bool istincan = false, enabletincansupportforco = false, enabletincansupportforao = false, enabletincansupportforlt = false;

  TinCanDataModel({
    this.lrsendpoint = "",
    this.lrsauthorization = "",
    this.lrsauthorizationpassword = "",
    this.istincan = false,
    this.enabletincansupportforco = false,
    this.enabletincansupportforao = false,
    this.enabletincansupportforlt = false,
  });

  TinCanDataModel.fromJson(Map<String, dynamic> json) {
    lrsendpoint = ParsingHelper.parseStringMethod(json["lrsendpoint"]);
    lrsauthorization = ParsingHelper.parseStringMethod(json["lrsauthorization"]);
    lrsauthorizationpassword = ParsingHelper.parseStringMethod(json["lrsauthorizationpassword"]);
    istincan = ParsingHelper.parseBoolMethod(json["istincan"]);
    enabletincansupportforco = ParsingHelper.parseBoolMethod(json["enabletincansupportforco"]);
    enabletincansupportforao = ParsingHelper.parseBoolMethod(json["enabletincansupportforao"]);
    enabletincansupportforlt = ParsingHelper.parseBoolMethod(json["enabletincansupportforlt"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "lrsendpoint": lrsendpoint,
      "lrsauthorization": lrsauthorization,
      "lrsauthorizationpassword": lrsauthorizationpassword,
      "istincan": istincan,
      "enabletincansupportforco": enabletincansupportforco,
      "enabletincansupportforao": enabletincansupportforao,
      "enabletincansupportforlt": enabletincansupportforlt,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
