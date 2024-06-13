import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class AssessmentGenerateContentResponseModel {
  String generated_content = "";
  String resource = "";

  AssessmentGenerateContentResponseModel({
    this.generated_content = "",
    this.resource = "",
  });

  AssessmentGenerateContentResponseModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    generated_content = map["generated_content"] != null ? ParsingHelper.parseStringMethod(map["generated_content"]) : generated_content;
    resource = map["resource"] != null ? ParsingHelper.parseStringMethod(map["resource"]) : resource;
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return <String, dynamic>{
      "generated_content": generated_content,
      "resource": resource,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}
