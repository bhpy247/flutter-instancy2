import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class AvtarVoiceModel {
  String language = "";
  String name = "";
  String gender = "";
  String voiceID = "";

  AvtarVoiceModel({
    this.language = "",
    this.name = "",
    this.gender = "",
    this.voiceID = "",
  });

  AvtarVoiceModel.fromJson(Map<String, dynamic> json) {
    _initializeFromMap(json);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    language = ParsingHelper.parseStringMethod(map['Language']);
    name = ParsingHelper.parseStringMethod(map['Name']);
    gender = ParsingHelper.parseStringMethod(map['Gender']);
    voiceID = ParsingHelper.parseStringMethod(map['VoiceID']);
  }

  Map<String, dynamic> toJson() {
    return {
      'Language': language,
      'Name': name,
      'Gender': gender,
      'VoiceID': voiceID,
    };
  }
}
