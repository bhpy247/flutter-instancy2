import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class ComponentSortModel {
  int ID = 0;
  int SiteID = 0;
  int ComponentID = 0;
  String LocalID = "";
  String OptionText = "";
  String OptionValue = "";
  String EnableColumn = "";

  ComponentSortModel({
    this.ID = 0,
    this.SiteID = 0,
    this.ComponentID = 0,
    this.LocalID = "",
    this.OptionText = "",
    this.OptionValue = "",
    this.EnableColumn = "",
  });

  ComponentSortModel.fromJson(Map<String, dynamic> json) {
    ID = ParsingHelper.parseIntMethod(json["ID"]);
    SiteID = ParsingHelper.parseIntMethod(json["SiteID"]);
    ComponentID = ParsingHelper.parseIntMethod(json["componentId"]);
    LocalID = ParsingHelper.parseStringMethod(json["LocalID"]);
    OptionText = ParsingHelper.parseStringMethod(json["OptionText"]);
    OptionValue = ParsingHelper.parseStringMethod(json["OptionValue"]);
    EnableColumn = ParsingHelper.parseStringMethod(json["EnableColumn"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": ID,
      "siteId": SiteID,
      "componentId": ComponentID,
      "LocalID": LocalID,
      "OptionText": OptionText,
      "OptionValue": OptionValue,
      "EnableColumn": EnableColumn,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}