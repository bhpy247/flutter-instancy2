import '../../../utils/parsing_helper.dart';

class CategoriesModel {
  int parentCategoryID = 0;
  int categoryID = 0;
  int DisplayOrder = 0;
  int RefParentID = 0;
  int ContentCount = 0;
  int RowNumber = 0;
  int parentId = 0;
  int id = 0;
  int ParentCategoryID = 0;
  String CategoryName = "";
  String AgreementDocId = "";
  String Iconpath = "";
  String fullName = "";

  CategoriesModel({
    this.parentCategoryID = 0,
    this.categoryID = 0,
    this.ContentCount = 0,
    this.RefParentID = 0,
    this.ParentCategoryID = 0,
    this.parentId = 0,
    this.DisplayOrder = 0,
    this.RowNumber = 0,
    this.CategoryName = "",
    this.AgreementDocId = "",
    this.Iconpath = "",
  });

  CategoriesModel.fromMap(Map<String, dynamic> json) {
    parentCategoryID = ParsingHelper.parseIntMethod(json['ParentCategoryID']);
    ContentCount = ParsingHelper.parseIntMethod(json['ContentCount']);
    RefParentID = ParsingHelper.parseIntMethod(json['RefParentID']);
    RowNumber = ParsingHelper.parseIntMethod(json['RowNumber']);
    id = ParsingHelper.parseIntMethod(json['id']);
    parentId = ParsingHelper.parseIntMethod(json['parentId']);
    ParentCategoryID = ParsingHelper.parseIntMethod(json['ParentCategoryID']);
    DisplayOrder = ParsingHelper.parseIntMethod(json['DisplayOrder']);
    categoryID = ParsingHelper.parseIntMethod(json['CategoryID']);
    CategoryName = ParsingHelper.parseStringMethod(json['CategoryName']);
    AgreementDocId = ParsingHelper.parseStringMethod(json['AgreementDocId']);
    Iconpath = ParsingHelper.parseStringMethod(json['Iconpath']);
    fullName = ParsingHelper.parseStringMethod(json['fullName']);
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ParentCategoryID'] = parentCategoryID;
    data['ContentCount'] = ContentCount;
    data['RefParentID'] = RefParentID;
    data['RowNumber'] = RowNumber;
    data['ParentCategoryID'] = ParentCategoryID;
    data['DisplayOrder'] = DisplayOrder;
    data['CategoryID'] = categoryID;
    data['id'] = id;
    data['parentId'] = parentId;
    data['CategoryName'] = CategoryName;
    data['AgreementDocId'] = AgreementDocId;
    data['Iconpath'] = Iconpath;
    data['fullName'] = fullName;
    return data;
  }
}
