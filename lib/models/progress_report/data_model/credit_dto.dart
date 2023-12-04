import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../../utils/my_utils.dart';

class CreditDto {
  String credittotal = "";
  String credityear = "";

  CreditDto({this.credittotal = "", this.credityear = ""});

  CreditDto.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> json) {
    credityear = ParsingHelper.parseStringMethod(json["credityear"]);
    credittotal = ParsingHelper.parseStringMethod(json["credittotal"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "credityear": credityear,
      "credittotal": credittotal,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}

class ContentCountDTO {
  int ContentCount = 0;
  String ContentType = "";

  ContentCountDTO({this.ContentCount = 0, this.ContentType = ""});

  ContentCountDTO.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> json) {
    ContentType = ParsingHelper.parseStringMethod(json["ContentType"]);
    ContentCount = ParsingHelper.parseIntMethod(json["ContentCount"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "ContentType": ContentType,
      "ContentCount": ContentCount,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
