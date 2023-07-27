import 'package:flutter_instancy_2/configs/app_constants.dart';

import '../../api/api_controller.dart';
import '../../configs/app_configurations.dart';
import '../../models/app_configuration_models/data_models/component_configurations_model.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/pagination/pagination_model.dart';
import '../../models/my_connections/data_model/people_listing_item_dto_model.dart';
import '../../models/my_connections/request_model/get_people_list_request_model.dart';
import '../../models/my_connections/response_model/people_listing_dto_response_model.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';
import 'my_connections_provider.dart';
import 'my_connections_repository.dart';

class MyConnectionsController {
  late MyConnectionsProvider _connectionsProvider;
  late MyConnectionsRepository _connectionsRepository;

  MyConnectionsController({required MyConnectionsProvider? connectionsProvider, MyConnectionsRepository? repository, ApiController? apiController}) {
    _connectionsProvider = connectionsProvider ?? MyConnectionsProvider();
    _connectionsRepository = repository ?? MyConnectionsRepository(apiController: apiController ?? ApiController());
  }

  MyConnectionsProvider get connectionsProvider => _connectionsProvider;

  MyConnectionsRepository get connectionsRepository => _connectionsRepository;

  //region Initializations
  void initializeConfigurationsFromComponentConfigurationsModel({required ComponentConfigurationsModel componentConfigurationsModel}) {
    connectionsProvider.pageSize.set(value: componentConfigurationsModel.itemsPerPage, isNotify: false);
    initializeFilterData(model: componentConfigurationsModel);
  }

  void initializeFilterData({required ComponentConfigurationsModel model}) {
    MyConnectionsProvider provider = connectionsProvider;

    provider.filterProvider
      ..defaultSort.set(value: model.ddlSortList, isNotify: false)
      ..selectedSort.set(value: model.ddlSortList, isNotify: false);
    provider.filterEnabled.set(value: AppConfigurations.getFilterEnabledFromShowIndexes(showIndexes: model.showIndexes), isNotify: false);
    provider.sortEnabled.set(value: AppConfigurations.getSortEnabledFromContentFilterBy(contentFilterBy: model.contentFilterBy), isNotify: false);
  }
  //endregion

  //region Get Forums List with Pagination
  Future<bool> getPeopleList({
    bool isRefresh = true,
    bool isGetFromCache = false,
    bool isNotify = true,
    int componentId = InstancyComponents.PeopleList,
    int componentInstanceId = InstancyComponents.PeopleListComponentInsId,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
        "MyConnectionsController().getPeopleList() called with isRefresh:$isRefresh, isGetFromCache:$isGetFromCache, "
            "isNotify:$isNotify, componentId:$componentId, componentInstanceId:$componentInstanceId",
        tag: tag);

    MyConnectionsProvider provider = connectionsProvider;
    MyConnectionsRepository repository = connectionsRepository;
    PaginationModel paginationModel = provider.peopleListPaginationModel.get();

    //region If Not refresh and Data available, return Cached Data
    if (!isRefresh && isGetFromCache && provider.peopleListLength > 0) {
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
      provider.peopleList.setList(list: <PeopleListingItemDTOModel>[], isClear: true, isNotify: isNotify);
    }
    //endregion

    //region If Not Has More Data, then return
    if (!paginationModel.hasMore) {
      MyPrint.printOnConsole('No More People', tag: tag);
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
    GetPeopleListRequestModel requestModel = getPeopleListDataRequestModelFromProviderData(
      provider: provider,
      paginationModel: paginationModel,
      componentId: componentId,
      componentInstanceId: componentInstanceId,
    );
    //endregion

    //region Make Api Call
    DataResponseModel<PeopleListingDTOResponseModel> response = await repository.getPeopleList(
      requestModel: requestModel,
    );
    MyPrint.printOnConsole("People List Response:$response", tag: tag);
    //endregion

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole("People List got in ${endTime.difference(startTime).inMilliseconds} Milliseconds", tag: tag);

    List<PeopleListingItemDTOModel> peopleList = response.data?.PeopleList ?? <PeopleListingItemDTOModel>[];
    MyPrint.printOnConsole("People List Length got in Api:${peopleList.length}", tag: tag);

    //region Set Provider Data After Getting Data From Api
    provider.maxPeopleListCount.set(value: response.data?.PeopleCount ?? 0, isNotify: false);
    provider.peopleList.setList(list: peopleList, isClear: false, isNotify: false);
    PaginationModel.updatePaginationData(
      paginationModel: paginationModel,
      isFirstTimeLoading: false,
      pageIndex: paginationModel.pageIndex + 1,
      hasMore: provider.peopleListLength < provider.maxPeopleListCount.get(),
      isLoading: false,
      notifier: provider.notify,
      notify: true,
    );
    //endregion

    return true;
  }

  GetPeopleListRequestModel getPeopleListDataRequestModelFromProviderData({
    required MyConnectionsProvider provider,
    required PaginationModel paginationModel,
    required int componentId,
    required int componentInstanceId,
  }) {
    return GetPeopleListRequestModel(
      SearchText: provider.peopleListSearchString.get(),
      contentid: provider.peopleListContentId.get(),
      pageIndex: paginationModel.pageIndex,
      pageSize: provider.pageSize.get(),
      ComponentID: componentId,
      ComponentInstanceID: componentInstanceId,
    );
  }
  //endregion
}