import '../../../../utils/my_utils.dart';
import '../../../../utils/parsing_helper.dart';

class ARSceneMeshObjectSettingModel {
  String backgroundColor = "";
  String borderColor = "";
  String borderWidth = "";
  String hotspotColor = "";
  String textColor = "";
  String textStyle = "";
  double transparency = 0;
  double radius = 0;
  double height = 0;
  double width = 0;
  double fontSize = 0;
  bool isBackground = false;
  bool isBorder = false;

  ARSceneMeshObjectSettingModel({
    this.backgroundColor = "",
    this.borderColor = "",
    this.borderWidth = "",
    this.hotspotColor = "",
    this.textColor = "",
    this.textStyle = "",
    this.transparency = 0,
    this.radius = 0,
    this.height = 0,
    this.width = 0,
    this.fontSize = 0,
    this.isBackground = false,
    this.isBorder = false,
  });

  ARSceneMeshObjectSettingModel.fromJson(Map<String, dynamic> json) {
    backgroundColor = ParsingHelper.parseStringMethod(json["backgroundColor"]);
    borderColor = ParsingHelper.parseStringMethod(json["borderColor"]);
    borderWidth = ParsingHelper.parseStringMethod(json["borderWidth"]);
    hotspotColor = ParsingHelper.parseStringMethod(json["hotspotColor"]);
    textColor = ParsingHelper.parseStringMethod(json["textColor"]);
    textStyle = ParsingHelper.parseStringMethod(json["textStyle"]);
    transparency = ParsingHelper.parseDoubleMethod(json["transparency"]);
    radius = ParsingHelper.parseDoubleMethod(json["radius"]);
    height = ParsingHelper.parseDoubleMethod(json["height"]);
    width = ParsingHelper.parseDoubleMethod(json["width"]);
    fontSize = ParsingHelper.parseDoubleMethod(json["fontSize"]);
    isBackground = ParsingHelper.parseBoolMethod("isBackground");
    isBorder = ParsingHelper.parseBoolMethod("isBorder");
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "backgroundColor": backgroundColor,
      "borderColor": borderColor,
      "borderWidth": borderWidth,
      "hotspotColor": hotspotColor,
      "textColor": textColor,
      "textStyle": textStyle,
      "transparency": transparency,
      "radius": radius,
      "height": height,
      "width": width,
      "fontSize": fontSize,
      "isBackground": isBackground,
      "isBorder": isBorder,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
