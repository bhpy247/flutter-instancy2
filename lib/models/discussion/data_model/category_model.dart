import '../../../utils/parsing_helper.dart';
import '../response_model/CategoriesModel.dart';

class CategoriesDtoModel {
  List<CategoriesModel> categoriesList = [];
  List<dynamic> table1 = [];

  CategoriesDtoModel({this.categoriesList = const [], this.table1 = const []});

  CategoriesDtoModel.fromMap(Map<String, dynamic> json) {
    categoriesList = ParsingHelper.parseMapsListMethod<String, dynamic>(json["Table1"]).map((x) => CategoriesModel.fromMap(x)).toList();
  }

  Map<String, dynamic> toMap() {
    return {"Table1": categoriesList.map((x) => x.toMap()).toList()};
  }
}
