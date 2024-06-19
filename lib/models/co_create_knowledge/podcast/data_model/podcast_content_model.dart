import 'dart:typed_data';

import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../response_model/language_response_model.dart';
import '../response_model/language_voice_model.dart';
import '../response_model/speaking_style_model.dart';

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
  LanguageModel? selectedLanguage;
  LanguageVoiceModel? selectedVoiceModel;
  SpeakingStyleModel? speakingStyleModel;
  String? selectedGender;

  PodcastContentModel({
    this.fileName = "",
    this.audioUrl = "",
    this.voiceLanguage = "",
    this.audioTranscript = "",
    this.promptText = "",
    this.voiceTone = "",
    this.voiceName = "",
    this.voiceSpeed = 1,
    this.selectedLanguage,
    this.selectedVoiceModel,
    this.speakingStyleModel,
    this.selectedGender,
  });

  PodcastContentModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    fileName = map["fileName"] != null ? ParsingHelper.parseStringMethod(map["fileName"]) : fileName;
    selectedGender = map["selectedGender"] != null ? ParsingHelper.parseStringMethod(map["selectedGender"]) : selectedGender;
    audioUrl = map["audioUrl"] != null ? ParsingHelper.parseStringMethod(map["audioUrl"]) : audioUrl;
    audioTranscript = map["audioTranscript"] != null ? ParsingHelper.parseStringMethod(map["audioTranscript"]) : audioTranscript;
    promptText = map["promptText"] != null ? ParsingHelper.parseStringMethod(map["promptText"]) : promptText;
    voiceLanguage = map["voiceLanguage"] != null ? ParsingHelper.parseStringMethod(map["voiceLanguage"]) : voiceLanguage;
    voiceTone = map["voiceTone"] != null ? ParsingHelper.parseStringMethod(map["voiceTone"]) : voiceTone;
    voiceName = map["voiceName"] != null ? ParsingHelper.parseStringMethod(map["voiceName"]) : voiceName;
    voiceSpeed = map["voiceSpeed"] != null ? ParsingHelper.parseDoubleMethod(map["voiceSpeed"]) : voiceSpeed;

    Map<String, dynamic>? selectedLanguageMap = map["selectedLanguage"] != null ? ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(map["selectedLanguage"]) : null;
    if (selectedLanguageMap.checkNotEmpty) {
      selectedLanguage = LanguageModel.fromJson(selectedLanguageMap!);
    } else {
      selectedLanguage = null;
    }

    Map<String, dynamic>? selectedVoiceModelMap = map["selectedVoiceModel"] != null ? ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(map["selectedVoiceModel"]) : null;
    if (selectedVoiceModelMap.checkNotEmpty) {
      selectedVoiceModel = LanguageVoiceModel.fromJson(selectedVoiceModelMap!);
    } else {
      selectedVoiceModel = null;
    }

    Map<String, dynamic>? speakingStyleModelMap = map["speakingStyleModel"] != null ? ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(map["speakingStyleModel"]) : null;
    if (speakingStyleModelMap.checkNotEmpty) {
      speakingStyleModel = SpeakingStyleModel.fromMap(speakingStyleModelMap!);
    } else {
      speakingStyleModel = null;
    }
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return <String, dynamic>{
      "fileName": fileName,
      "audioUrl": audioUrl,
      "selectedGender": selectedGender,
      "audioTranscript": audioTranscript,
      "promptText": promptText,
      "voiceTone": voiceTone,
      "voiceLanguage": voiceLanguage,
      "voiceName": voiceName,
      "voiceSpeed": voiceSpeed,
      "selectedLanguage": selectedLanguage?.toMap(toJson: toJson),
      "selectedVoiceModel": selectedVoiceModel?.toMap(toJson: toJson),
      "speakingStyleModel": speakingStyleModel?.toMap(toJson: toJson),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}
