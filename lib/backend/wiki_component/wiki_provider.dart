import 'package:flutter/material.dart';

import '../../models/wiki_component/response_model/fileUploadControlModel.dart';
import '../../models/wiki_component/response_model/wikiCategoriesModel.dart';

class WikiProvider extends ChangeNotifier {
  //region fileUploadControl
  List<FileUploadControlsModel> _fileUploadControlsModelList = [];

  void setFileUploadControlsModelList(List<FileUploadControlsModel> fileUploadControlsModelList, {bool isNotify = true}){
    if(fileUploadControlsModelList.isNotEmpty){
      _fileUploadControlsModelList = fileUploadControlsModelList;
    }
    if(isNotify){
      notifyListeners();
    }
  }

  List<FileUploadControlsModel> get fileUploadControlsModelList => _fileUploadControlsModelList;
  //endregion

  //region Wiki Categories
  List<WikiCategoryTable> _wikiCategoriesList = [];

  void setWikiCategoriesList(List<WikiCategoryTable> wikiCategoriesList, {bool isNotify = true}){
    if(wikiCategoriesList.isNotEmpty){
      _wikiCategoriesList = wikiCategoriesList;
    }
    if(isNotify){
      notifyListeners();
    }
  }

  List<WikiCategoryTable> get wikiCategoriesList => _wikiCategoriesList;
  //endregion

  void resetData() {
    setFileUploadControlsModelList([], isNotify: false);
    setWikiCategoriesList([], isNotify: true);
  }
}