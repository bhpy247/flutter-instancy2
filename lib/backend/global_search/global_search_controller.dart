import 'package:collection/collection.dart';
import 'package:flutter_instancy_2/backend/global_search/global_search_provider.dart';
import 'package:flutter_instancy_2/backend/global_search/global_search_repository.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/dto/global_search_dto_model.dart';
import 'package:flutter_instancy_2/models/global_search/response_model/global_search_component_response_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';

import '../../api/api_controller.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/pagination/pagination_model.dart';
import '../../models/dto/global_search_course_dto_model.dart';
import '../../models/filter/data_model/enabled_content_filter_by_type_model.dart';
import '../../models/global_search/request_model/global_search_request_model.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';
import '../filter/filter_provider.dart';

class GlobalSearchController {
  late GlobalSearchProvider _globalSearchProvider;
  late GlobalSearchRepository _globalSearchRepository;

  GlobalSearchController({required GlobalSearchProvider? globalSearchProvider, GlobalSearchRepository? repository, ApiController? apiController}) {
    _globalSearchProvider = globalSearchProvider ?? GlobalSearchProvider();
    _globalSearchRepository = repository ?? GlobalSearchRepository(apiController: apiController ?? ApiController());
  }

  GlobalSearchProvider get globalSearchProvider => _globalSearchProvider;

  GlobalSearchRepository get globalSearchRepository => _globalSearchRepository;

  Future<bool> getGlobalSearchComponent() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("GlobalSearchController().getGlobalSearchComponent() called '", tag: tag);

    DataResponseModel<GlobalSearchComponentResponseModel> dataResponseModel = await _globalSearchRepository.getSearchComponent();

    MyPrint.printOnConsole("dataResponseModel response:$dataResponseModel", tag: tag);

    if (dataResponseModel.data != null || (dataResponseModel.data?.searchComponents.checkNotEmpty ?? false)) {
      List<SearchComponents> searchComponentList = dataResponseModel.data?.searchComponents ?? [];
      final myMap = groupBy<SearchComponents, String>(searchComponentList, (item) => item.siteName).map((key, value) => MapEntry(key, value.toList()));
      globalSearchProvider.globalSearchComponent.setMap(map: myMap);
    }

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from DiscussionController().getUserListBaseOnUserInfo() because addTopic had some error", tag: tag);
      return false;
    }

    return dataResponseModel.data?.searchComponents.checkNotEmpty ?? false;
  }

  Future<List<GlobalSearchCourseDTOModel>> getGlobalSearchResult2({int objectComponentList = 0, int intComponentSiteID = 0}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("GlobalSearchController().getGlobalSearchResult2() called '", tag: tag);
    GlobalSearchResultRequestModel globalSearchResultRequestModel = GlobalSearchResultRequestModel(
      componentID: InstancyComponents.GlobalSearchComponent,
      componentInsID: InstancyComponents.GlobalSearchComponentInsId,
      searchStr: globalSearchProvider.globalSearchListSearchString.get(),
      objComponentList: objectComponentList,
      intComponentSiteID: intComponentSiteID,
      pageIndex: 1,
      pageSize: 10,
      AuthorID: "-1",
      source: "0",
      type: "0",
    );

    DataResponseModel<GlobalSearchDTOModel> dataResponseModel = await _globalSearchRepository.getGlobalSearchResult(requestModel: globalSearchResultRequestModel);

    MyPrint.printOnConsole("addTopicComment response:$dataResponseModel", tag: tag);

    if (dataResponseModel.data != null && (dataResponseModel.data?.CourseList.checkNotEmpty ?? false)) {
      return dataResponseModel.data?.CourseList ?? [];
    }

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from DiscussionController().getUserListBaseOnUserInfo() because addTopic had some error", tag: tag);
      return [];
    }

    return [];
  }

  //region Get Global Search List with Pagination
  Future<bool> getGlobalSearchResultWithPagination({
    bool isRefresh = true,
    bool isGetFromCache = false,
    bool isNotify = true,
    int componentId = -1,
    int componentInstanceId = -1,
    int objectComponentList = 0,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
        "DiscussionController().getGlobal SearchsList() called with isRefresh:$isRefresh, isGetFromCache:$isGetFromCache, "
        "isNotify:$isNotify, componentId:$componentId, componentInstanceId:$componentInstanceId",
        tag: tag);

    GlobalSearchProvider provider = globalSearchProvider;
    GlobalSearchRepository repository = globalSearchRepository;
    PaginationModel paginationModel = provider.GlobalSearchCourseListPaginationModel.get();

    //region If Not refresh and Data available, return Cached Data
    if (!isRefresh && isGetFromCache && provider.globalSearchCourseList.length > 0) {
      MyPrint.printOnConsole("Returning Cached Data", tag: tag);
      return true;
    }
    //endregion

    //region If refresh, then reset provider data
    if (isRefresh) {
      MyPrint.printOnConsole("Refresh", tag: tag);
      PaginationModel.updatePaginationData(
        paginationModel: paginationModel,
        hasMore: true,
        pageIndex: 1,
        isFirstTimeLoading: true,
        isLoading: false,
        notifier: provider.notify,
        notify: false,
      );
      provider.globalSearchCourseList.setList(list: <GlobalSearchCourseDTOModel>[], isClear: true, isNotify: isNotify);
    }
    //endregion

    //region If Not Has More Data, then return
    if (!paginationModel.hasMore) {
      MyPrint.printOnConsole('No More Global Search Contents', tag: tag);
      return false;
    }
    //endregion

    //region If Data already Loading, then return
    if (paginationModel.isLoading) return false;
    //endregion

    //region Set Loading True
    PaginationModel.updatePaginationData(
      paginationModel: paginationModel,
      isLoading: true,
      notifier: provider.notify,
      notify: isNotify,
    );
    //endregion

    DateTime startTime = DateTime.now();

    //region Get Request Model From Provider Data
    GlobalSearchResultRequestModel requestModel = getGlobalSearchListRequestModelFromProviderData(
        provider: provider, paginationModel: paginationModel, componentId: componentId, componentInstanceId: componentInstanceId, objectComponentList: objectComponentList);
    //endregion

    //region Make Api Call
    DataResponseModel<GlobalSearchDTOModel> response = await repository.getGlobalSearchResult(
      requestModel: requestModel,
    );
    MyPrint.printOnConsole("Global Search Response:$response", tag: tag);
    //endregion

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole("Global Search Data got in ${endTime.difference(startTime).inMilliseconds} Milliseconds", tag: tag);

    List<GlobalSearchCourseDTOModel> globalSearchList = response.data?.CourseList ?? <GlobalSearchCourseDTOModel>[];
    MyPrint.printOnConsole("Global search List Length got in Api:${globalSearchList.length}", tag: tag);

    List<GlobalSearchCourseDTOModel> globalSearchResultList = <GlobalSearchCourseDTOModel>[];

    //region Set Provider Data After Getting Data From Api
    provider.maxGlobalSearchCourseListCount.set(value: response.data?.CourseCount ?? 0, isNotify: false);
    provider.globalSearchCourseList.setList(list: globalSearchResultList, isClear: false, isNotify: false);
    PaginationModel.updatePaginationData(
      paginationModel: paginationModel,
      isFirstTimeLoading: false,
      pageIndex: paginationModel.pageIndex + 1,
      hasMore: provider.globalSearchCourseList.length < provider.maxGlobalSearchCourseListCount.get(),
      isLoading: false,
      notifier: provider.notify,
      notify: true,
    );
    //endregion

    return true;
  }

  GlobalSearchResultRequestModel getGlobalSearchListRequestModelFromProviderData(
      {required GlobalSearchProvider provider, required PaginationModel paginationModel, required int componentId, required int componentInstanceId, required int objectComponentList}) {
    FilterProvider filterProvider = provider.filterProvider;
    EnabledContentFilterByTypeModel? enabledContentFilterByTypeModel = filterProvider.getEnabledContentFilterByTypeModel(isNewInstance: false);

    return GlobalSearchResultRequestModel(
        componentID: componentId,
        componentInsID: componentInstanceId,
        searchStr: provider.globalSearchListSearchString.get(),
        objComponentList: objectComponentList,
        pageIndex: paginationModel.pageIndex,
        pageSize: provider.pageSize.get(),
        AuthorID: "-1",
        source: "0",
        type: "0");
  }

//endregion

  Future<void> getIdBasedSearchedCourseList({required int componentId, required int componentInsId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("GlobalSearchController().getIdBasedSearchedCourseList() called '", tag: tag);

    Map<SearchComponents, List<GlobalSearchCourseDTOModel>> courseListMapWithComponentId = {};

    List<SearchComponents> addCheckSearchComponent = <SearchComponents>[];
    MyPrint.printOnConsole("DataDataDataDataData: ${globalSearchProvider.globalSearchComponent.getMap()} '", tag: tag);
    List<SearchComponents> searchComponent = [];
    globalSearchProvider.globalSearchComponent.getMap().values.forEach((element) {
      searchComponent.addAll(element);
    });
    MyPrint.printOnConsole("searchComponentsearchComponent :${searchComponent.length}", tag: tag);
    globalSearchProvider.isLoading.set(value: true);
    for (var element in searchComponent) {
      if (element.check) {
        MyPrint.printOnConsole("Is Check ${element.componentID} : ${element.check}");
        addCheckSearchComponent.add(element);
      }
    }

    if (addCheckSearchComponent.checkNotEmpty) {
      List<Future> futures = <Future>[];
      for (SearchComponents component in addCheckSearchComponent) {
        futures.add(Future(() async {
          List<GlobalSearchCourseDTOModel> dataList = await getGlobalSearchResult2(
            objectComponentList: component.componentID,
            intComponentSiteID: component.siteID,
          );
          if (dataList.checkNotEmpty) {
            courseListMapWithComponentId[component] = dataList.map((e) => GlobalSearchCourseDTOModel.fromMap(e.toMap())).toList();
          }
        }));
      }

      await Future.wait(futures);
    }
    MyPrint.printOnConsole("courseListMapWithComponentId : ${courseListMapWithComponentId.length}");
    globalSearchProvider.courseListBasedOnIdMap.setMap(map: courseListMapWithComponentId);
    globalSearchProvider.isLoading.set(value: false);
  }
}
