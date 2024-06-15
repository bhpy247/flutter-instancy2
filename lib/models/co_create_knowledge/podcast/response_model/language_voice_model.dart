import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../../../utils/my_utils.dart';

class LanguageVoiceModel {
  String locale = "";
  String gender = "";
  String displayName = "";
  String voiceName = "";

  LanguageVoiceModel({
    this.locale = "",
    this.gender = "",
    this.displayName = "",
    this.voiceName = "",
  });

  LanguageVoiceModel.fromJson(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    locale = ParsingHelper.parseStringMethod(map['locale']);
    gender = ParsingHelper.parseStringMethod(map['gender']);
    displayName = ParsingHelper.parseStringMethod(map['displayName']);
    voiceName = ParsingHelper.parseStringMethod(map['voiceName']);
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return {
      'locale': locale,
      'gender': gender,
      'displayName': displayName,
      'voiceName': voiceName,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}
