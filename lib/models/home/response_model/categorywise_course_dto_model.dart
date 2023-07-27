import '../../../utils/parsing_helper.dart';
import '../data_model/new_course_list_dto.dart';

class CategoryWiseCourseDTOResponseModel {
  List categoryDTO = [];
  List<NewCourseListDTOModel> courseDTO = <NewCourseListDTOModel>[];

  CategoryWiseCourseDTOResponseModel({
    required this.categoryDTO,
    required this.courseDTO,
  });

  CategoryWiseCourseDTOResponseModel.fromJson(Map<String, dynamic> json) {
     List<Map<String, dynamic>> categoryMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(json['CategoryDTO']);
    categoryDTO = categoryMapsList;

    List<Map<String, dynamic>> courseMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(json['CourseDTO']);
    courseDTO = courseMapsList.map((e) => NewCourseListDTOModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      "CategoryDTO" : categoryDTO,
      "CourseDTO" : courseDTO.map((v) => v.toMap()).toList(),
    };
  }
}

