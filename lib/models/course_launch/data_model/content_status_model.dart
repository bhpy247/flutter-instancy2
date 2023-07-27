import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../../utils/my_utils.dart';

class ContentStatusModel extends CourseDTOModel {
  String contentStatus = "";
  String status = "";
  String name = "";
  double progress = 0;

  ContentStatusModel({
    this.contentStatus = "",
    this.status = "",
    this.name = "",
    this.progress = 0,
  });

  ContentStatusModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    super.updateFromMap(map);

    contentStatus = ParsingHelper.parseStringMethod(map["contentStatus"]);
    status = ParsingHelper.parseStringMethod(map["status"]);
    name = ParsingHelper.parseStringMethod(map["name"]);
    progress = ParsingHelper.parseDoubleMethod(map["progress"]);
  }

  Map<String, dynamic> toMap() {
    return super.toMap()..addAll(<String, dynamic>{
      "contentStatus": contentStatus,
      "status": status,
      "name": name,
      "progress": progress,
    });
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}