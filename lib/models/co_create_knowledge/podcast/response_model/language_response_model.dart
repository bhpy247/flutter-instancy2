import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../../../utils/my_utils.dart';

class LanguageModel {
  String language = "";
  String languageCode = "";

  LanguageModel({this.language = "", this.languageCode = ""});

  LanguageModel.fromJson(Map<String, dynamic> json) {
    _initializeFromMap(json);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    language = ParsingHelper.parseStringMethod(map['language']);
    languageCode = ParsingHelper.parseStringMethod(map['languageCode']);
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return {
      'language': language,
      'languageCode': languageCode,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}
