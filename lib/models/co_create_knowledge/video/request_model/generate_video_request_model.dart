class GenerateVideoRequestModel {
  String videoID = "";
  Content? content;
  VideoInput? videoInput;

  GenerateVideoRequestModel({this.videoID = "", this.content, this.videoInput});

  // GenerateVideoRequestModel.fromJson(Map<String, dynamic> json) {
  //   videoID = json['videoID'];
  //   content = json['content'] != null ? Content.fromJson(json['content']) : null;
  //   videoInput = json['videoInput'] != null ? VideoInput.fromJson(json['videoInput']) : null;
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['videoID'] = videoID;
    if (content != null) {
      data['content'] = content!.toJson();
    }
    if (videoInput != null) {
      data['videoInput'] = videoInput!.toJson();
    }
    return data;
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

  // Content.fromJson(Map<String, dynamic> json) {
  //   contentID = ParsingHelper.parseStringMethod(json['contentID']);
  //   pageID = ParsingHelper.parseStringMethod(json['pageID']);
  //   sectionID = ParsingHelper.parseStringMethod(json['sectionID']);
  //   userID = ParsingHelper.parseIntMethod(json['userID']);
  // }

  Map<String, dynamic> toJson() {
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

  // VideoInput.fromJson(Map<String, dynamic> json) {
  //   title = json['title'];
  //   if (json['input'] != null) {
  //     input = <Input>[];
  //     json['input'].forEach((v) {
  //       input.add(Input.fromJson(v));
  //     });
  //   }
  // }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "input": input.map((e) => e.toJson()).toList(),
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

  // Input.fromJson(Map<String, dynamic> json) {
  //   scriptText = json['scriptText'];
  //   avatar = json['avatar'];
  //   background = json['background'];
  //   avatarSettings = json['avatarSettings'] != null ? AvatarSettings.fromJson(json['avatarSettings']) : null;
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['scriptText'] = scriptText;
    data['avatar'] = avatar;
    data['background'] = background;
    if (avatarSettings != null) {
      data['avatarSettings'] = avatarSettings!.toJson();
    }
    return data;
  }
}

class AvatarSettings {
  String? voice;
  String? horizontalAlign;
  int? scale;
  String? style;

  AvatarSettings({this.voice, this.horizontalAlign, this.scale, this.style});

  AvatarSettings.fromJson(Map<String, dynamic> json) {
    voice = json['voice'];
    horizontalAlign = json['horizontalAlign'];
    scale = json['scale'];
    style = json['style'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['voice'] = voice;
    data['horizontalAlign'] = horizontalAlign;
    data['scale'] = scale;
    data['style'] = style;
    return data;
  }
}
