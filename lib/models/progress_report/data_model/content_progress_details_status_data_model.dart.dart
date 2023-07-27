import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../../utils/my_utils.dart';

class ContentProgressDetailsStatusDataModel {
  String statusType = "";

  ContentProgressDetailsStatusDataModel({this.statusType = ""});

  ContentProgressDetailsStatusDataModel.fromJson(Map<String, dynamic> json) {
    statusType = ParsingHelper.parseStringMethod(json['statustype']);
  }

  Map<String, dynamic> toJson() {
    return {
      "statustype" : statusType,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}