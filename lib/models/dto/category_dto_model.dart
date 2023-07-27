import '../../utils/my_utils.dart';
import '../../utils/parsing_helper.dart';

class CategoryDTOModel {
  int CategoryID = 0;
  String CategoryName = "";

  CategoryDTOModel({
    this.CategoryID = 0,
    this.CategoryName = "",
  });

  CategoryDTOModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    CategoryID = ParsingHelper.parseIntMethod(map['CategoryID']);
    CategoryName = ParsingHelper.parseStringMethod(map['CategoryName']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "CategoryID" : CategoryID,
      "CategoryName" : CategoryName,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}