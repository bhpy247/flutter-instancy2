import 'package:flutter_instancy_2/utils/my_utils.dart';

class NativeAuthoringGetModuleNamesRequestModel {
  String learning_objective = "";
  String llmContent = "";
  String sourceType = "";
  int pages_in_content = 0;
  List<String> sources = <String>[];

  NativeAuthoringGetModuleNamesRequestModel({
    this.learning_objective = "",
    this.llmContent = "",
    this.sourceType = "",
    this.pages_in_content = 0,
    List<String>? sources,
  }) {
    this.sources = sources ?? <String>[];
  }

  Map<String, dynamic> toMap() {
    return {
      "learning_objective": learning_objective,
      "llmContent": llmContent,
      "sourceType": sourceType,
      "pages_in_content": pages_in_content,
      "sources": sources,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
