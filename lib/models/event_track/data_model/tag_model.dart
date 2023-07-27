import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class TagModel {
  String Tag = "";

  TagModel({
    this.Tag = "",
  });

  TagModel.fromJson(Map<String, dynamic> json) {
    Tag = ParsingHelper.parseStringMethod(json["Tag"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "Tag": Tag,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}