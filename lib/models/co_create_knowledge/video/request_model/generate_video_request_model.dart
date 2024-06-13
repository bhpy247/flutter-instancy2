import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class GenerateVideoRequestModel {
  String videoID = "";
  Content? content;
  VideoInput? videoInput;

  GenerateVideoRequestModel({this.videoID = "", this.content, this.videoInput});

  Map<String, dynamic> toMap() {
    return {
      'videoID': videoID,
      'content': content?.toMap(),
      'videoInput': videoInput?.toMap(),
    };
  }
}

class Content {
  String contentID = "";
  String pageID = "";
  String sectionID = "";
  int userID = 0;

  Content({
    this.contentID = "",
    this.pageID = "",
    this.sectionID = "",
    this.userID = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'contentID': contentID,
      'pageID': pageID,
      'sectionID': sectionID,
      'userID': userID,
    };
  }
}

class VideoInput {
  String title = "";
  List<Input> input = const [];

  VideoInput({this.title = "", this.input = const []});

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "input": input.map((e) => e.toMap()).toList(),
    };
  }
}

class Input {
  String scriptText = "";
  String avatar = "";
  String background = "";
  AvatarSettings? avatarSettings;

  Input({
    this.scriptText = "",
    this.avatar = "",
    this.background = "",
    this.avatarSettings,
  });

  Map<String, dynamic> toMap() {
    return {
      'scriptText': scriptText,
      'avatar': avatar,
      'background': background,
      'avatarSettings': avatarSettings?.toMap(),
    };
  }
}

class AvatarSettings {
  String voice = "";
  String horizontalAlign = "";
  String style = "";

  int scale = 0;

  AvatarSettings({
    this.voice = "",
    this.horizontalAlign = "",
    this.scale = 0,
    this.style = "",
  });

  AvatarSettings.fromJson(Map<String, dynamic> json) {
    voice = ParsingHelper.parseStringMethod(json['voice']);
    horizontalAlign = ParsingHelper.parseStringMethod(json['horizontalAlign']);
    style = ParsingHelper.parseStringMethod(json['style']);
    scale = ParsingHelper.parseIntMethod(json['scale']);
  }

  Map<String, dynamic> toMap() {
    return {
      'voice': voice,
      'horizontalAlign': horizontalAlign,
      'style': style,
      'scale': scale,
    };
  }
}
