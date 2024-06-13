import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class VideoContentModel {
  String avatarId = "";
  String background = "";
  String scriptText = "";
  String voice = "";
  String horizontalAlign = "";
  String style = "";

  VideoContentModel({
    this.avatarId = "",
    this.background = "",
    this.scriptText = "",
    this.voice = "",
    this.horizontalAlign = "",
    this.style = "",
  });

  VideoContentModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    avatarId = ParsingHelper.parseStringMethod(map["avatarId"]);
    background = ParsingHelper.parseStringMethod(map["background"]);
    scriptText = ParsingHelper.parseStringMethod(map["scriptText"]);
    voice = ParsingHelper.parseStringMethod(map["voice"]);
    horizontalAlign = ParsingHelper.parseStringMethod(map["horizontalAlign"]);
    style = ParsingHelper.parseStringMethod(map["style"]);
  }

  Map<String, dynamic> toMap({bool toJson = true}) {
    return <String, dynamic>{
      "avatarId": avatarId,
      "background": background,
      "scriptText": scriptText,
      "voice": voice,
      "horizontalAlign": horizontalAlign,
      "style": style,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}
