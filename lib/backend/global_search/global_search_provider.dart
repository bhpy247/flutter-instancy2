import 'package:flutter_instancy_2/models/global_search/response_model/global_search_component_response_model.dart';

import '../../models/common/pagination/pagination_model.dart';
import '../../models/dto/global_search_course_dto_model.dart';
import '../common/common_provider.dart';
import '../filter/filter_provider.dart';

class GlobalSearchProvider extends CommonProvider {
  GlobalSearchProvider() {
    pageSize = CommonProviderPrimitiveParameter<int>(
      value: 10,
      notify: notify,
    );
    filterEnabled = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    isAllChecked = CommonProviderPrimitiveParameter<bool>(
      value: true,
      notify: notify,
    );
    sortEnabled = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    globalSearchCourseList = CommonProviderListParameter<GlobalSearchCourseDTOModel>(
      list: <GlobalSearchCourseDTOModel>[],
      notify: notify,
    );
    globalSearchComponent = CommonProviderMapParameter<String, List<SearchComponents>>(
      map: <String, List<SearchComponents>>{},
      notify: notify,
    );
    globalSearchCourseContentId = CommonProviderPrimitiveParameter<String>(
      value: "",
      notify: notify,
    );
    globalSearchListSearchString = CommonProviderPrimitiveParameter<String>(
      value: "",
      notify: notify,
    );
    maxGlobalSearchCourseListCount = CommonProviderPrimitiveParameter<int>(
      value: 0,
      notify: notify,
    );
    GlobalSearchCourseListPaginationModel = CommonProviderPrimitiveParameter<PaginationModel>(
      value: PaginationModel(
        pageIndex: 1,
        pageSize: 10,
        refreshLimit: 3,
      ),
      notify: notify,
    );

    isCreateForum = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    isEditForum = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    isDeleteForum = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    isLoading = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );

    filterCategoriesIds = CommonProviderPrimitiveParameter<String>(
      value: "",
      notify: notify,
    );
    courseListBasedOnIdMap = CommonProviderMapParameter(
      map: {},
      notify: notify,
    );
  }

  //region Configurations
  late CommonProviderPrimitiveParameter<int> pageSize;
  late CommonProviderPrimitiveParameter<bool> filterEnabled;
  late CommonProviderPrimitiveParameter<bool> sortEnabled;

  //endregion

  late CommonProviderListParameter<GlobalSearchCourseDTOModel> globalSearchCourseList;
  late CommonProviderMapParameter<String, List<SearchComponents>> globalSearchComponent;
  late CommonProviderMapParameter<SearchComponents, List<GlobalSearchCourseDTOModel>> courseListBasedOnIdMap;
  late final CommonProviderPrimitiveParameter<String> globalSearchCourseContentId;
  late final CommonProviderPrimitiveParameter<String> globalSearchListSearchString;
  late final CommonProviderPrimitiveParameter<String> filterCategoriesIds;
  late final CommonProviderPrimitiveParameter<int> maxGlobalSearchCourseListCount;
  late final CommonProviderPrimitiveParameter<PaginationModel> GlobalSearchCourseListPaginationModel;

  late final CommonProviderPrimitiveParameter<bool> isCreateForum;
  late final CommonProviderPrimitiveParameter<bool> isEditForum;
  late final CommonProviderPrimitiveParameter<bool> isDeleteForum;
  late final CommonProviderPrimitiveParameter<bool> isLoading;
  late final CommonProviderPrimitiveParameter<bool> isAllChecked;

  void updateSearchComponentMap({required String key, required List<SearchComponents> list}) {
    final val = globalSearchComponent.getMap().update(key, (value) => list);
    globalSearchComponent.updateMap(key: key, updatedValue: val);
  }

  final FilterProvider filterProvider = FilterProvider();

  void resetData() {
    pageSize.set(value: 10, isNotify: false);
    filterEnabled.set(value: false, isNotify: false);
    isAllChecked.set(value: false, isNotify: false);
    sortEnabled.set(value: false, isNotify: false);

    globalSearchCourseList.setList(list: [], isNotify: false);
    globalSearchComponent.setMap(map: <String, List<SearchComponents>>{}, isNotify: false);
    globalSearchCourseContentId.set(value: "", isNotify: false);
    filterCategoriesIds.set(value: "", isNotify: false);
    globalSearchListSearchString.set(value: "", isNotify: false);
    maxGlobalSearchCourseListCount.set(value: 0, isNotify: false);
    GlobalSearchCourseListPaginationModel.set(
      value: PaginationModel(
        pageIndex: 1,
        pageSize: 10,
        refreshLimit: 3,
      ),
      isNotify: false,
    );

    isCreateForum.set(value: false, isNotify: false);
    isEditForum.set(value: false, isNotify: false);
    isDeleteForum.set(value: false, isNotify: false);
    isLoading.set(value: false, isNotify: false);
    courseListBasedOnIdMap.setMap(map: {}, isNotify: false);
    filterProvider.resetData();
  }
}
