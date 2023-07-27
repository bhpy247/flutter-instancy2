import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class CatalogCategoriesForBrowseModel {
  int parentID = 0, categoryID = 0;
  String categoryIcon = "", categoryName = "";
  bool hasChild = false, isChecked = false;
  List<CatalogCategoriesForBrowseModel> children = <CatalogCategoriesForBrowseModel>[];

  CatalogCategoriesForBrowseModel({
    this.parentID = 0,
    this.categoryName = "",
    this.categoryID = 0,
    this.categoryIcon = "",
    this.hasChild = false,
    this.isChecked = false,
  });

  CatalogCategoriesForBrowseModel.fromJson(Map<String, dynamic> json) {
    parentID = ParsingHelper.parseIntMethod(json['ParentID'] ?? 0);
    categoryName = ParsingHelper.parseStringMethod(json['CategoryName'] ?? "");
    categoryID = ParsingHelper.parseIntMethod(json['CategoryID'] ?? 0);
    categoryIcon = ParsingHelper.parseStringMethod(json['CategoryIcon'] ?? "");
    hasChild = ParsingHelper.parseBoolMethod(json['hasChild'] ?? false);
    isChecked = ParsingHelper.parseBoolMethod(json['isChecked'] ?? false);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ParentID'] = parentID;
    data['CategoryName'] = categoryName;
    data['CategoryID'] = categoryID;
    data['CategoryIcon'] = categoryIcon;
    data['hasChild'] = hasChild;
    data['isChecked'] = isChecked;
    return data;
  }
}
