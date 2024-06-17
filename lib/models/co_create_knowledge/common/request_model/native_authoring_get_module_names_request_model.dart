import 'package:flutter_instancy_2/utils/my_utils.dart';

class NativeAuthoringGetModuleNamesRequestModel {
  String learning_objective = "";
  String sourceType = "";
  int pages_in_content = 0;
  bool llmContent = false;
  List<String> sources = <String>[];

  NativeAuthoringGetModuleNamesRequestModel({
    this.learning_objective = "",
    this.sourceType = "",
    this.pages_in_content = 0,
    this.llmContent = false,
    List<String>? sources,
  }) {
    this.sources = sources ?? <String>[];
  }

  Map<String, dynamic> toMap() {
    return {
      "learning_objective": learning_objective,
      "sourceType": sourceType,
      "pages_in_content": pages_in_content,
      "llmContent": llmContent ? "1" : "0",
      "sources": sources,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
