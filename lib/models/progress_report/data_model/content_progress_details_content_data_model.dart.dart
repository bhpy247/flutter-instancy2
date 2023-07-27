import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../../utils/my_utils.dart';

class ContentProgressDetailsContentDataModel {
  String title = "";

  ContentProgressDetailsContentDataModel({
    this.title = "",
  });

  ContentProgressDetailsContentDataModel.fromJson(Map<String, dynamic> json) {
    title = ParsingHelper.parseStringMethod(json['Title']);
  }

  Map<String, dynamic> toJson() {
    return {
      "Title" : title,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
