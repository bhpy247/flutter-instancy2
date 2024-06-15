import 'dart:typed_data';

import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class PodcastContentModel {
  String filePath = "";
  String fileName = "";
  String audioUrl = "";
  String audioTranscript = "";
  String promptText = "";
  String voiceTone = "";
  String voiceName = "";
  String voiceLanguage = "";
  double voiceSpeed = 1;
  Uint8List? fileBytes;

  PodcastContentModel({
    this.fileName = "",
    this.audioUrl = "",
    this.voiceLanguage = "",
    this.audioTranscript = "",
    this.promptText = "",
    this.voiceTone = "",
    this.voiceName = "",
    this.voiceSpeed = 1,
  });

  PodcastContentModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    fileName = map["fileName"] != null ? ParsingHelper.parseStringMethod(map["fileName"]) : fileName;
    audioUrl = map["audioUrl"] != null ? ParsingHelper.parseStringMethod(map["audioUrl"]) : audioUrl;
    audioTranscript = map["audioTranscript"] != null ? ParsingHelper.parseStringMethod(map["audioTranscript"]) : audioTranscript;
    promptText = map["promptText"] != null ? ParsingHelper.parseStringMethod(map["promptText"]) : promptText;
    voiceLanguage = map["voiceLanguage"] != null ? ParsingHelper.parseStringMethod(map["voiceLanguage"]) : voiceLanguage;
    voiceTone = map["voiceTone"] != null ? ParsingHelper.parseStringMethod(map["voiceTone"]) : voiceTone;
    voiceName = map["voiceName"] != null ? ParsingHelper.parseStringMethod(map["voiceName"]) : voiceName;
    voiceSpeed = map["voiceSpeed"] != null ? ParsingHelper.parseDoubleMethod(map["voiceSpeed"]) : voiceSpeed;
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return <String, dynamic>{
      "fileName": fileName,
      "audioUrl": audioUrl,
      "audioTranscript": audioTranscript,
      "promptText": promptText,
      "voiceTone": voiceTone,
      "voiceLanguage": voiceLanguage,
      "voiceName": voiceName,
      "voiceSpeed": voiceSpeed,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}
