import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../data_model/education_title_model.dart';

class EducationTitleResponseModel {
  EducationTitleResponseModel({
    required this.educationTitleList,
  });

  List<EducationTitleModel> educationTitleList = [];

  EducationTitleResponseModel.fromJson(Map<String, dynamic> json) {
    educationTitleList = ParsingHelper.parseMapsListMethod<String, dynamic>(json["educationTitleList"]).map((e) {
      return EducationTitleModel.fromJson(e);
    }).toList();
  }

  Map<String, dynamic> toJson() => {
    "educationTitleList": educationTitleList.map((x) => x.toJson()).toList(),
  };
}

