import 'package:flutter_instancy_2/models/profile/data_model/profile_group_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';

import '../../../utils/parsing_helper.dart';

class MobileGetUserDetailsResponseModel {
  List<ProfileGroupModel> table2 = [];
  List<Table5> table5 = [];

  MobileGetUserDetailsResponseModel({
    List<ProfileGroupModel>? table2,
    required this.table5,
  }) {
    this.table2 = table2 ?? <ProfileGroupModel>[];
  }

  MobileGetUserDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    table2 = ParsingHelper.parseMapsListMethod<String, dynamic>(json["table2"]).map((x) => ProfileGroupModel.fromJson(x)).toList();
    table5 = ParsingHelper.parseMapsListMethod<String, dynamic>(json["table5"]).map((x) => Table5.fromJson(x)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      "table2": table2.map((x) => x.toJson()).toList(),
      "table5": List<dynamic>.from(table5.map((x) => x.toJson())),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}

class Table5 {
  Table5({
    this.choiceid = 0,
    this.attributeconfigid = 0,
    this.choicetext = "",
    this.choicevalue = "",
    this.localename = "",
    this.parenttext,
  });

  int choiceid = 0;
  int attributeconfigid = 0;
  String choicetext = "";
  String choicevalue = "";
  String localename = "";
  dynamic parenttext;

  factory Table5.fromJson(Map<String, dynamic> json) => Table5(
        choiceid: json["choiceid"] ?? 0,
        attributeconfigid: json["attributeconfigid"] ?? 0,
        choicetext: json["choicetext"] ?? "",
        choicevalue: json["choicevalue"] ?? "",
        localename: json["localename"] ?? "",
        parenttext: json["parenttext"],
      );

  Map<String, dynamic> toJson() => {
        "choiceid": choiceid,
        "attributeconfigid": attributeconfigid,
        "choicetext": choicetext,
        "choicevalue": choicevalue,
        "localename": localename,
        "parenttext": parenttext,
      };
}
