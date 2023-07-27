import 'package:flutter_instancy_2/models/catalog/data_model/catalog_course_dto_model.dart';
import 'package:flutter_instancy_2/models/dto/category_dto_model.dart';

import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class CatalogResponseDTOModel {
  List<CatalogCourseDTOModel> CourseList = <CatalogCourseDTOModel>[];
  int CourseCount = 0;
  List<CategoryDTOModel> CategoryDTO = [];

  CatalogResponseDTOModel({
    List<CatalogCourseDTOModel>? CourseList,
    this.CourseCount = 0,
    List<CategoryDTOModel>? CategoryDTO,
  }) {
    this.CourseList = CourseList ?? <CatalogCourseDTOModel>[];
    this.CategoryDTO = CategoryDTO ?? <CategoryDTOModel>[];
  }

  CatalogResponseDTOModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    List<Map<String, dynamic>> courseMapsList = ParsingHelper.parseMapsListMethod(map['CourseList']);
    CourseList = courseMapsList.map((e) {
      return CatalogCourseDTOModel.fromMap(e);
    }).toList();

    CourseCount = ParsingHelper.parseIntMethod(map['CourseCount']);

    List<Map<String, dynamic>> categoryDTOMapsList = ParsingHelper.parseMapsListMethod(map['CategoryDTO']);
    CategoryDTO = categoryDTOMapsList.map((e) {
      return CategoryDTOModel.fromMap(e);
    }).toList();
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return <String, dynamic>{
      "CourseList" : CourseList.map((e) => e.toMap()).toList(),
      "CourseCount" : CourseCount,
      "CategoryDTO" : CategoryDTO.map((e) => e.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}