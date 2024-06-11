import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class BackgroundColorModel {
  String bgGroup = "";
  List<String> backgrounds = const [];

  BackgroundColorModel({this.bgGroup = "", this.backgrounds = const []});

  BackgroundColorModel.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> map) {
    bgGroup = ParsingHelper.parseStringMethod(map['bgGroup']);
    backgrounds = ParsingHelper.parseListMethod(map['backgrounds']);
  }

  Map<String, dynamic> toJson() {
    return {
      'bgGroup': bgGroup,
      'backgrounds': backgrounds,
    };
  }
}
