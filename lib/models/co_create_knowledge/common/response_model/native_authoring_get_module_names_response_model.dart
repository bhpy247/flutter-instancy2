import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class NativeAuthoringGetModuleNamesResponseModel {
  List<String> learning_modules = <String>[];

  NativeAuthoringGetModuleNamesResponseModel({
    List<String>? learning_modules,
  }) {
    this.learning_modules = learning_modules ?? <String>[];
  }

  NativeAuthoringGetModuleNamesResponseModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    if (map["learning_modules"] != null) {
      learning_modules = ParsingHelper.parseListMethod<dynamic, String>(map["learning_modules"]);
    }
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return <String, dynamic>{
      "learning_modules": learning_modules,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}
