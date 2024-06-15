import 'package:flutter_chat_bot/utils/parsing_helper.dart';

import '../../../../utils/my_utils.dart';

class PlayAudioForTextRequestModel {
  String text = "";
  String voiceStyle = "";
  String voice = "";
  String language = "";
  int speekingSpeed = 0;
  double speekingPitch = 0.0;
  int uID = 0;
  String cmsGroupID = "";
  String folderID = "";
  bool isOptionsChanged = false;
  bool isPlay = false;

  PlayAudioForTextRequestModel({
    this.text = "",
    this.voiceStyle = "",
    this.voice = "",
    this.language = "",
    this.speekingSpeed = 0,
    this.speekingPitch = 0,
    this.uID = 0,
    this.cmsGroupID = "",
    this.folderID = "",
    this.isOptionsChanged = false,
    this.isPlay = false,
  });

  PlayAudioForTextRequestModel.fromJson(Map<String, dynamic> json) {
    _initializeFromMap(json);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    text = ParsingHelper.parseStringMethod(map['text']);
    voiceStyle = ParsingHelper.parseStringMethod(map['voiceStyle']);
    voice = ParsingHelper.parseStringMethod(map['voice']);
    language = ParsingHelper.parseStringMethod(map['language']);
    speekingSpeed = ParsingHelper.parseIntMethod(map['speekingSpeed']);
    speekingPitch = ParsingHelper.parseDoubleMethod(map['speekingPitch']);
    uID = ParsingHelper.parseIntMethod(map['uID']);
    cmsGroupID = ParsingHelper.parseStringMethod(map['cmsGroupID']);
    folderID = ParsingHelper.parseStringMethod(map['folderID']);
    isOptionsChanged = ParsingHelper.parseBoolMethod(map['isOptionsChanged']);
    isPlay = ParsingHelper.parseBoolMethod(map['isPlay']);
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return {
      'text': text,
      'voiceStyle': voiceStyle,
      'voice': voice,
      'language': language,
      'speekingSpeed': speekingSpeed,
      'speekingPitch': speekingPitch,
      'uID': uID,
      'cmsGroupID': cmsGroupID,
      'folderID': folderID,
      'isOptionsChanged': isOptionsChanged,
      'isPlay': isPlay,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}
