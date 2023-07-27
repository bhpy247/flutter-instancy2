import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../../utils/my_utils.dart';

class EducationTitleModel {
  int id = 0;
  String name = "";

  EducationTitleModel({
    this.id = 0,
    this.name = "",
  });

  EducationTitleModel.fromJson(Map<String, dynamic> json) {
    id = ParsingHelper.parseIntMethod(json["id"]);
    name = ParsingHelper.parseStringMethod(json["name"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}