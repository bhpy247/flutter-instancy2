import 'package:flutter_instancy_2/utils/my_utils.dart';

class GenerateImagesRequestModel {
  String topic = "";
  String size = "";
  int count = 0;

  GenerateImagesRequestModel({
    this.topic = "",
    this.size = "",
    this.count = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      "topic": topic,
      "size": size,
      "count": count,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
