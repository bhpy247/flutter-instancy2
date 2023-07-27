import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class ContentFilterCategoryTreeModel {
  String categoryName = "";
  String categoryId = "";
  String parentId = "";

  //Local Variables used for Filter
  List<ContentFilterCategoryTreeModel> children = <ContentFilterCategoryTreeModel>[];
  bool isExpansionPanelExpanded = false;

  ContentFilterCategoryTreeModel({
    this.categoryName = "",
    this.categoryId = "",
    this.parentId = "",
  });

  ContentFilterCategoryTreeModel.fromJson(Map<String, dynamic> json) {
    categoryName = ParsingHelper.parseStringMethod(json["CategoryName"]);
    categoryId = ParsingHelper.parseStringMethod(json["CategoryID"]);
    parentId = ParsingHelper.parseStringMethod(json["ParentID"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "CategoryName": categoryName,
      "CategoryID": categoryId,
      "ParentID": parentId,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}