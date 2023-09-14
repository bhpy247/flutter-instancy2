import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';
import '../../course/data_model/CourseDTOModel.dart';
import '../../dto/category_dto_model.dart';

class CatalogResponseDTOModel {
  List<CourseDTOModel> CourseList = <CourseDTOModel>[];
  int CourseCount = 0;
  List<CategoryDTOModel> CategoryDTO = [];

  CatalogResponseDTOModel({
    List<CourseDTOModel>? CourseList,
    this.CourseCount = 0,
    List<CategoryDTOModel>? CategoryDTO,
  }) {
    this.CourseList = CourseList ?? <CourseDTOModel>[];
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
      return CourseDTOModel.fromMap(e);
    }).toList();

    CourseList = courseMapsList.map((e) {
      return CourseDTOModel.fromMap(e);
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