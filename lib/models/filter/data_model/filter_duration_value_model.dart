import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class FilterDurationValueModel {
  String Displayvalue = "";
  String defaultvalue = "";
  int Minvalue = 0;
  int Maxvalue = 0;

  FilterDurationValueModel({
    this.Displayvalue = "",
    this.defaultvalue = "",
    this.Minvalue = 0,
    this.Maxvalue = 0,
  });

  FilterDurationValueModel.fromJson(Map<String, dynamic> json) {
    Displayvalue = ParsingHelper.parseStringMethod(json["Displayvalue"]);
    defaultvalue = ParsingHelper.parseStringMethod(json["defaultvalue"]);
    Minvalue = ParsingHelper.parseIntMethod(json["Minvalue"], defaultValue: 0);
    Maxvalue = ParsingHelper.parseIntMethod(json["Maxvalue"], defaultValue: 0);
  }

  Map<String, dynamic> toJson() {
    return {
      "Displayvalue": Displayvalue,
      "defaultvalue": defaultvalue,
      "Minvalue": Minvalue,
      "Maxvalue": Maxvalue,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}