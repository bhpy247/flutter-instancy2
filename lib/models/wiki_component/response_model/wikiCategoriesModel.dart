import '../../../utils/parsing_helper.dart';

class WikiCategoriesModel {
  List<WikiCategoryTable> wikiCategoriesList = [];
  List<dynamic> table1 = [];

  WikiCategoriesModel({this.wikiCategoriesList = const [], this.table1 = const []});

  WikiCategoriesModel.fromMap(Map<String, dynamic> json) {
    wikiCategoriesList = ParsingHelper.parseMapsListMethod<String, dynamic>(json["Table"]).map((x) => WikiCategoryTable.fromMap(x)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
    "Table": wikiCategoriesList.map((x) => x.toMap()).toList()};
  }
}

class WikiCategoryTable {
  int parentCategoryID = 0;
  int categoryID = 0;
  String name = "";

  WikiCategoryTable({this.parentCategoryID = 0, this.categoryID = 0, this.name = ""});

  WikiCategoryTable.fromMap(Map<String, dynamic> json) {
    parentCategoryID = ParsingHelper.parseIntMethod(json['ParentCategoryID']);
    categoryID = ParsingHelper.parseIntMethod(json['CategoryID']);
    name = ParsingHelper.parseStringMethod(json['Name']);
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ParentCategoryID'] = parentCategoryID;
    data['CategoryID'] = categoryID;
    data['Name'] = name;
    return data;
  }
}
