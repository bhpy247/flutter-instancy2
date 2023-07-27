import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class GlossaryModel {
  String Type = "";
  String id = "";
  String Meaning = "";
  String Text = "";

  GlossaryModel({
    this.Type = "",
    this.id = "",
    this.Meaning = "",
    this.Text = "",
  });

  GlossaryModel.fromJson(Map<String, dynamic> json) {
    Type = ParsingHelper.parseStringMethod(json["Type"]);
    id = ParsingHelper.parseStringMethod(json["id"]);
    Meaning = ParsingHelper.parseStringMethod(json["Meaning"]);
    Text = ParsingHelper.parseStringMethod(json["Text"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "Type" : Type,
      "id" : id,
      "Meaning" : Meaning,
      "Text" : Text,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}