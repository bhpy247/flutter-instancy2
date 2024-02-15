import 'package:flutter_instancy_2/backend/event/event_provider.dart';
import 'package:flutter_instancy_2/backend/my_connections/my_connections_provider.dart';

import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class DynamicTabsDTOModel {
  String TabID = "";
  String DisplayName = "";
  String MobileDisplayName = "";
  String DisplayIcon = "";
  String ComponentName = "";
  String TabComponentInstanceID = "";
  String ComponentID = "";
  String ParameterString = "";
  EventProvider eventProvider = EventProvider();
  MyConnectionsProvider myConnectionsProvider = MyConnectionsProvider();

  DynamicTabsDTOModel({
    this.TabID = "",
    this.DisplayName = "",
    this.MobileDisplayName = "",
    this.DisplayIcon = "",
    this.ComponentName = "",
    this.TabComponentInstanceID = "",
    this.ComponentID = "",
    this.ParameterString = "",
  });

  DynamicTabsDTOModel.fromJson(Map<String, dynamic> json) {
    TabID = ParsingHelper.parseStringMethod(json["TabID"]);
    DisplayName = ParsingHelper.parseStringMethod(json["DisplayName"]);
    MobileDisplayName = ParsingHelper.parseStringMethod(json["MobileDisplayName"]);
    DisplayIcon = ParsingHelper.parseStringMethod(json["DisplayIcon"]);
    ComponentName = ParsingHelper.parseStringMethod(json["ComponentName"]);
    TabComponentInstanceID = ParsingHelper.parseStringMethod(json["TabComponentInstanceID"]);
    ComponentID = ParsingHelper.parseStringMethod(json["ComponentID"]);
    ParameterString = ParsingHelper.parseStringMethod(json["ParameterString"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "TabID": TabID,
      "DisplayName": DisplayName,
      "MobileDisplayName": MobileDisplayName,
      "DisplayIcon": DisplayIcon,
      "ComponentName": ComponentName,
      "TabComponentInstanceID": TabComponentInstanceID,
      "ComponentID": ComponentID,
      "ParameterString": ParameterString,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
