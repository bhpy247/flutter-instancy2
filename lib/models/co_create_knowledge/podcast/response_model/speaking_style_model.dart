import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../../../utils/my_utils.dart';

class SpeakingStyleModel {
  String voiceName = "";
  List<String> voiceStyle = const [];

  SpeakingStyleModel({this.voiceName = "", this.voiceStyle = const []});

  SpeakingStyleModel.fromMap(Map<String, dynamic> json) {
    _initializeFromMap(json);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    voiceName = ParsingHelper.parseStringMethod(map['voiceName']);
    voiceStyle = ParsingHelper.parseListMethod(map['voiceStyle']);
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return {
      'voiceName': voiceName,
      'voiceStyle': voiceStyle,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}
