import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class AvtarResponseModel {
  List<Avatars> avatars = const [];

  AvtarResponseModel({this.avatars = const []});

  AvtarResponseModel.fromMap(Map<String, dynamic> json) {
    if (json['Avatars'] != null) {
      avatars = <Avatars>[];
      json['Avatars'].forEach((v) {
        avatars.add(Avatars.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Avatars'] = avatars.map((v) => v.toJson()).toList();
    return data;
  }
}

class Avatars {
  String name = "";
  String actorID = "";

  Avatars({this.name = "", this.actorID = ""});

  Avatars.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> map) {
    name = ParsingHelper.parseStringMethod(map['Name']);
    actorID = ParsingHelper.parseStringMethod(map['ActorID']);
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'ActorID': actorID,
    };
  }
}
