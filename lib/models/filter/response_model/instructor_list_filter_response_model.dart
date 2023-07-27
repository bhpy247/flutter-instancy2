import 'package:flutter_instancy_2/models/filter/data_model/instructor_user_model.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class InstructorListFilterResponseModel {
  List<InstructorUserModel> Table = <InstructorUserModel>[];

  InstructorListFilterResponseModel.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> tableList = ParsingHelper.parseMapsListMethod<String, dynamic>(json["Table"]);
    Table = tableList.map((e) {
      return InstructorUserModel.fromJson(e);
    }).toList();
  }
}