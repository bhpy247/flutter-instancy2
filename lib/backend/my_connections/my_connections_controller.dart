import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/app/app_repository.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/app/data_model/dynamic_tabs_dto_model.dart';
import 'package:flutter_instancy_2/models/app/request_model/get_dynamic_tabs_request_model.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/local_str.dart';
import 'package:flutter_instancy_2/models/dto/response_dto_model.dart';
import 'package:flutter_instancy_2/models/my_connections/request_model/people_listing_actions_request_model.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/views/common/components/common_confirmation_dialog.dart';
import 'package:provider/provider.dart';

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

  Future<List<DynamicTabsDTOModel>> getTabsList({
    bool isRefresh = true,
    bool isGetFromCache = false,
    bool isNotify = true,
    int componentId = InstancyComponents.PeopleList,
    int componentInstanceId = InstancyComponents.PeopleListComponentInsId,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MyConnectionsController().getTabs() called", tag: tag);

    MyConnectionsProvider provider = connectionsProvider;

    //region If Not refresh and Data available, return Cached Data
    if (!isRefresh && isGetFromCache && provider.tabsList.length > 0) {
      MyPrint.printOnConsole("Returning Cached Data", tag: tag);
      return provider.tabsList.getList();
    }
    //endregion

    List<DynamicTabsDTOModel> tabsList = <DynamicTabsDTOModel>[];

    provider.isLoadingTabsList.set(value: true, isNotify: isNotify);

    GetDynamicTabsRequestModel requestModel = GetDynamicTabsRequestModel(
      ComponentID: componentId,
      ComponentInsID: componentInstanceId,
    );

    DataResponseModel<List<DynamicTabsDTOModel>> response = await AppRepository(apiController: connectionsRepository.apiController).getDynamicTabsList(requestModel: requestModel);
    MyPrint.logOnConsole("getTabs response:$response", tag: tag);

    provider.isLoadingTabsList.set(value: false, isNotify: true);

    if (response.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from MyConnectionsController().getTabs() because getTabsList had some error", tag: tag);
      return tabsList;
    }

    tabsList = response.data ?? <DynamicTabsDTOModel>[];

    provider.tabsList.setList(list: tabsList, isClear: true, isNotify: true);

    return tabsList;
  }

  //region Get People List with Pagination
  Future<bool> getPeopleList({
    bool isRefresh = true,
    bool isGetFromCache = false,
    bool isNotify = true,
    String filterType = "",
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
      filterType: filterType,
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
    required String filterType,
    required int componentId,
    required int componentInstanceId,
  }) {
    return GetPeopleListRequestModel(
      SearchText: provider.peopleListSearchString.get(),
      contentid: provider.peopleListContentId.get(),
      pageIndex: paginationModel.pageIndex,
      pageSize: provider.pageSize.get(),
      filterType: filterType,
      ComponentID: componentId,
      ComponentInstanceID: componentInstanceId,
    );
  }

//endregion

  // region People Listing Actions
  Future<bool> addToMyConnection({required PeopleListingActionsRequestModel requestModel, BuildContext? context}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MyConnectionsController().addToMyConnection() called with connectionId:'${requestModel.SelectedObjectID}', connectionName:'${requestModel.UserName}'", tag: tag);

    bool isSuccess = false;

    requestModel.SelectAction = PeopleListingActionTypes.AddConnection;

    try {
      DataResponseModel<ResponseDTOModel> responseModel = await connectionsRepository.doPeopleListingActions(requestModel: requestModel);
      MyPrint.printOnConsole("doPeopleListingActions statusCode:${responseModel.statusCode}", tag: tag);
      MyPrint.printOnConsole("doPeopleListingActions data:${responseModel.data}", tag: tag);

      if (responseModel.statusCode == 200 && responseModel.data?.IsSuccess == true) {
        isSuccess = true;
      }

      MyPrint.printOnConsole("Final isSuccess:$isSuccess", tag: tag);

      String message = responseModel.data?.Message ?? "";
      if (message.isNotEmpty && context != null && context.mounted) {
        if (isSuccess) {
          MyToast.showSuccess(context: context, msg: message);
        } else {
          MyToast.showError(context: context, msg: message);
        }
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in MyConnectionsController().addToMyConnection():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    return isSuccess;
  }

  Future<bool> removeFromMyConnection({required PeopleListingActionsRequestModel requestModel, BuildContext? context}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MyConnectionsController().removeFromMyConnection() called with connectionId:'${requestModel.SelectedObjectID}', connectionName:'${requestModel.UserName}'", tag: tag);

    bool isSuccess = false;

    if (context != null && context.mounted) {
      dynamic value = await showDialog(
        context: context,
        builder: (BuildContext context) {
          LocalStr localStrNew = context.read<AppProvider>().localStr;

          return CommonConfirmationDialog(
            title: localStrNew.myConnectionsAlertTitleRemoveConnection,
            description: localStrNew.myconnectionsAlertsubtitleAreyousurewanttoremoveconnection,
            confirmationText: localStrNew.myconnectionsAlertbuttonRemovebutton,
            cancelText: localStrNew.myconnectionsAlertbuttonCancelbutton,
          );
        },
      );

      if (value != true) {
        MyPrint.printOnConsole("Returning from DiscussionController().deleteComment() because couldn't get confirmation", tag: tag);
        return false;
      }
    }

    requestModel.SelectAction = PeopleListingActionTypes.RemoveConnection;

    try {
      DataResponseModel<ResponseDTOModel> responseModel = await connectionsRepository.doPeopleListingActions(requestModel: requestModel);
      MyPrint.printOnConsole("doPeopleListingActions statusCode:${responseModel.statusCode}", tag: tag);
      MyPrint.printOnConsole("doPeopleListingActions data:${responseModel.data}", tag: tag);

      if (responseModel.statusCode == 200 && responseModel.data?.IsSuccess == true) {
        isSuccess = true;
      }

      MyPrint.printOnConsole("Final isSuccess:$isSuccess", tag: tag);

      String message = responseModel.data?.Message ?? "";
      if (message.isNotEmpty && context != null && context.mounted) {
        if (isSuccess) {
          MyToast.showSuccess(context: context, msg: message);
        } else {
          MyToast.showError(context: context, msg: message);
        }
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in MyConnectionsController().removeFromMyConnection():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    return isSuccess;
  }

  Future<bool> acceptConnectionRequest({required PeopleListingActionsRequestModel requestModel, BuildContext? context}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MyConnectionsController().acceptConnectionRequest() called with connectionId:'${requestModel.SelectedObjectID}', connectionName:'${requestModel.UserName}'", tag: tag);

    bool isSuccess = false;

    requestModel.SelectAction = PeopleListingActionTypes.Accept;

    try {
      DataResponseModel<ResponseDTOModel> responseModel = await connectionsRepository.doPeopleListingActions(requestModel: requestModel);
      MyPrint.printOnConsole("doPeopleListingActions statusCode:${responseModel.statusCode}", tag: tag);
      MyPrint.printOnConsole("doPeopleListingActions data:${responseModel.data}", tag: tag);

      if (responseModel.statusCode == 200 && responseModel.data?.IsSuccess == true) {
        isSuccess = true;
      }

      MyPrint.printOnConsole("Final isSuccess:$isSuccess", tag: tag);

      String message = responseModel.data?.Message ?? "";
      if (message.isNotEmpty && context != null && context.mounted) {
        if (isSuccess) {
          MyToast.showSuccess(context: context, msg: message);
        } else {
          MyToast.showError(context: context, msg: message);
        }
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in MyConnectionsController().acceptConnectionRequest():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    return isSuccess;
  }

  Future<bool> rejectConnectionRequest({required PeopleListingActionsRequestModel requestModel, BuildContext? context}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MyConnectionsController().rejectConnectionRequest() called with connectionId:'${requestModel.SelectedObjectID}', connectionName:'${requestModel.UserName}'", tag: tag);

    bool isSuccess = false;

    requestModel.SelectAction = PeopleListingActionTypes.Ignore;

    try {
      DataResponseModel<ResponseDTOModel> responseModel = await connectionsRepository.doPeopleListingActions(requestModel: requestModel);
      MyPrint.printOnConsole("doPeopleListingActions statusCode:${responseModel.statusCode}", tag: tag);
      MyPrint.printOnConsole("doPeopleListingActions data:${responseModel.data}", tag: tag);

      if (responseModel.statusCode == 200 && responseModel.data?.IsSuccess == true) {
        isSuccess = true;
      }

      MyPrint.printOnConsole("Final isSuccess:$isSuccess", tag: tag);

      String message = responseModel.data?.Message ?? "";
      if (message.isNotEmpty && context != null && context.mounted) {
        if (isSuccess) {
          MyToast.showSuccess(context: context, msg: message);
        } else {
          MyToast.showError(context: context, msg: message);
        }
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in MyConnectionsController().rejectConnectionRequest():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    return isSuccess;
  }
// endregion
}