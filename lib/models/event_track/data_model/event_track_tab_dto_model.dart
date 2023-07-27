import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../../utils/my_utils.dart';

class EventTrackTabDTOModel {
  String tabName = "";
  String tabidName = "";
  String Glossaryhtml = "";
  int tabID = 0;

  EventTrackTabDTOModel({
    this.tabName = "",
    this.tabidName = "",
    this.Glossaryhtml = "",
    this.tabID = 0,
  });

  EventTrackTabDTOModel.fromJson(Map<String, dynamic> json) {
    tabName = ParsingHelper.parseStringMethod(json["tabName"]);
    tabidName = ParsingHelper.parseStringMethod(json["tabidName"]);
    Glossaryhtml = ParsingHelper.parseStringMethod(json["Glossaryhtml"]);
    tabID = ParsingHelper.parseIntMethod(json["tabID"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "tabName": tabName,
      "tabidName": tabidName,
      "Glossaryhtml": Glossaryhtml,
      "tabID": tabID,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
