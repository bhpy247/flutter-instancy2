import 'package:flutter_instancy_2/backend/common/common_provider.dart';
import 'package:flutter_instancy_2/backend/filter/filter_provider.dart';

import '../../models/catalog/catalogCategoriesForBrowseModel.dart';
import '../../models/catalog/data_model/associated_content_course_dto_model.dart';
import '../../models/catalog/data_model/catalog_course_dto_model.dart';
import '../../models/common/pagination/pagination_model.dart';

class CatalogProvider extends CommonProvider {
  CatalogProvider() {
    pageSize = CommonProviderPrimitiveParameter<int>(
      value: 10,
      notify: notify,
    );
    filterEnabled = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    sortEnabled = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    catalogCategoriesForBrowserList = CommonProviderListParameter<CatalogCategoriesForBrowseModel>(
      list: [],
      notify: notify,
    );
    catalogCategoryContent = CommonProviderListParameter<CatalogCourseDTOModel>(
      list: [],
      notify: notify,
    );
    catalogContentSearchString = CommonProviderPrimitiveParameter<String>(
      value: "",
      notify: notify,
    );
    wishlistContents = CommonProviderListParameter<CatalogCourseDTOModel>(
      list: [],
      notify: notify,
    );
    maxWishlistContentsCount = CommonProviderPrimitiveParameter<int>(
      value: 0,
      notify: notify,
    );
    catalogContentPaginationModel = CommonProviderPrimitiveParameter<PaginationModel>(
      value: PaginationModel(
        pageIndex: 1,
        pageSize: 10,
        refreshLimit: 3,
      ),
      notify: notify,
    );
    wishlistContentsPaginationModel = CommonProviderPrimitiveParameter<PaginationModel>(
      value: PaginationModel(
        pageIndex: 1,
        pageSize: 10,
        refreshLimit: 3,
      ),
      notify: notify,
    );
  }

  //region Configurations
  late CommonProviderPrimitiveParameter<int> pageSize;
  late CommonProviderPrimitiveParameter<bool> filterEnabled;
  late CommonProviderPrimitiveParameter<bool> sortEnabled;
  //endregion

  late final CommonProviderListParameter<CatalogCategoriesForBrowseModel> catalogCategoriesForBrowserList;

  late final CommonProviderListParameter<CatalogCourseDTOModel> catalogCategoryContent;
  int get catalogContentLength => catalogCategoryContent.getList(isNewInstance: false).length;

  late final CommonProviderPrimitiveParameter<String> catalogContentSearchString;

  late final CommonProviderListParameter<CatalogCourseDTOModel> wishlistContents;
  late final CommonProviderPrimitiveParameter<int> maxWishlistContentsCount;
  int get wishlistContentsLength => wishlistContents.getList(isNewInstance: false).length;

  late final CommonProviderPrimitiveParameter<PaginationModel> catalogContentPaginationModel;
  late final CommonProviderPrimitiveParameter<PaginationModel> wishlistContentsPaginationModel;

  final List<AssociatedContentCourseDTOModel> _prerequisiteModelArrayListRecommended = [];
  List<AssociatedContentCourseDTOModel> get prerequisiteModelArrayListRecommended => _prerequisiteModelArrayListRecommended;

  // String prerequisiteRecommended;
  final List<AssociatedContentCourseDTOModel> _prerequisiteModelArrayListRequired = [];
   List<AssociatedContentCourseDTOModel> get prerequisiteModelArrayListRequired => _prerequisiteModelArrayListRequired;

  // String prerequisiteRequired;
  final List<AssociatedContentCourseDTOModel> _prerequisiteModelArrayListCompletion = [];
  List<AssociatedContentCourseDTOModel> get prerequisiteModelArrayListCompletion => _prerequisiteModelArrayListCompletion;

  void setPrerequisiteModelArrayListRecommended({required AssociatedContentCourseDTOModel prerequisiteModelList, int prerequisites = 0}){
   if(prerequisites == 1){
      //recommended
     _prerequisiteModelArrayListRecommended.add(prerequisiteModelList);
   } else if(prerequisites == 2){
     //required
     _prerequisiteModelArrayListRequired.add(prerequisiteModelList);
   } else if(prerequisites == 3){
     //completion
     _prerequisiteModelArrayListCompletion.add(prerequisiteModelList);
   }
  }

  final FilterProvider filterProvider = FilterProvider();

  void resetData() {
    pageSize.set(value: 10, isNotify: false);
    filterEnabled.set(value: false, isNotify: false);
    sortEnabled.set(value: false, isNotify: false);
    catalogCategoriesForBrowserList.setList(list: [], isNotify: false);
    catalogCategoryContent.setList(list: [], isNotify: false);
    catalogContentSearchString.set(value: "", isNotify: false);
    wishlistContents.setList(list: [], isNotify: false);
    maxWishlistContentsCount.set(value: 0, isNotify: false);
    catalogContentPaginationModel.set(
      value: PaginationModel(
        pageIndex: 1,
        pageSize: 10,
        refreshLimit: 3,
      ),
      isNotify: false,
    );
    wishlistContentsPaginationModel.set(
      value: PaginationModel(
        pageIndex: 1,
        pageSize: 10,
        refreshLimit: 3,
      ),
      isNotify: true,
    );
    filterProvider.resetData();
  }
}