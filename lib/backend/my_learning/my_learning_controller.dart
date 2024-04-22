import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/api/api_url_configuration_provider.dart';
import 'package:flutter_instancy_2/backend/app/app_controller.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_controller.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_provider.dart';
import 'package:flutter_instancy_2/backend/filter/filter_provider.dart';
import 'package:flutter_instancy_2/backend/gamification/gamification_controller.dart';
import 'package:flutter_instancy_2/backend/gamification/gamification_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/backend/network_connection/network_connection_controller.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/component_configurations_model.dart';
import 'package:flutter_instancy_2/models/common/pagination/pagination_model.dart';
import 'package:flutter_instancy_2/models/course_download/data_model/course_download_data_model.dart';
import 'package:flutter_instancy_2/models/gamification/request_model/update_content_gamification_request_model.dart';
import 'package:flutter_instancy_2/models/my_learning/request_model/check_contents_enrollment_status_request_model.dart';
import 'package:flutter_instancy_2/models/my_learning/request_model/my_learning_data_request_model.dart';
import 'package:flutter_instancy_2/models/my_learning/response_model/check_contents_enrollment_status_response_model.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:provider/provider.dart';

import '../../api/api_controller.dart';
import '../../models/common/data_response_model.dart';
import '../../models/course/data_model/CourseDTOModel.dart';
import '../../models/filter/data_model/enabled_content_filter_by_type_model.dart';
import '../../models/filter/data_model/filter_duration_value_model.dart';
import '../../models/my_learning/response_model/my_learning_response_dto_model.dart';
import '../../models/my_learning/response_model/page_notes_response_model.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';
import '../../views/my_learning/component/mylearning_certificate_not_earned_alert_dialog.dart';
import 'my_learning_hive_repository.dart';
import 'my_learning_provider.dart';
import 'my_learning_repository.dart';

class MyLearningController {
  late MyLearningProvider _myLearningProvider;
  late MyLearningRepository myLearningRepository;
  late MyLearningHiveRepository myLearningHiveRepository;

  static bool isGetMyLearningData = false;

  MyLearningController({required MyLearningProvider? provider, MyLearningRepository? repository, MyLearningHiveRepository? hiveRepository, ApiController? apiController}) {
    _myLearningProvider = provider ?? MyLearningProvider();
    myLearningRepository = repository ?? MyLearningRepository(apiController: apiController ?? ApiController());
    myLearningHiveRepository = hiveRepository ?? MyLearningHiveRepository(apiController: apiController ?? ApiController());
  }

  MyLearningProvider get myLearningProvider => _myLearningProvider;

  void initializeMyLearningConfigurationsFromComponentConfigurationsModel({required ComponentConfigurationsModel componentConfigurationsModel}) {
    //Initializations
    myLearningProvider.pageSize.set(value: componentConfigurationsModel.itemsPerPage, isNotify: false);
    myLearningProvider.archieveEnabled.set(value: componentConfigurationsModel.showArchieve, isNotify: false);
    initializeFilterData(model: componentConfigurationsModel);
  }

  void initializeFilterData({required ComponentConfigurationsModel model}) {
    myLearningProvider.filterProvider.defaultSort.set(value: model.ddlSortList, isNotify: false);
    myLearningProvider.filterProvider.selectedSort.set(value: model.ddlSortList, isNotify: false);
    myLearningProvider.filterEnabled.set(
      value: AppConfigurations.getFilterEnabledFromShowIndexes(showIndexes: model.showIndexes),
      isNotify: false,
    );
    myLearningProvider.sortEnabled.set(
      value: AppConfigurations.getSortEnabledFromContentFilterBy(contentFilterBy: model.contentFilterBy),
      isNotify: false,
    );
    myLearningProvider.consolidationType.set(value: model.showConsolidatedLearning ? "consolidate" : "all", isNotify: false);
  }

  //region Get Contents
  Future<List<CourseDTOModel>> getMyLearningContentsListFromApi({
    bool isRefresh = true,
    bool isGetFromCache = false,
    bool isNotify = true,
    required int componentId,
    required int componentInstanceId,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
        "MyLearningController().getMyLearningContentsList() called with isRefresh:$isRefresh, isGetFromCache:$isGetFromCache, "
        "isNotify:$isNotify, componentId:$componentId, componentInstanceId:$componentInstanceId",
        tag: tag);

    MyLearningProvider provider = myLearningProvider;
    PaginationModel paginationModel = provider.myLearningPaginationModel;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = myLearningRepository.apiController.apiDataProvider;
    AppProvider? appProvider = AppController.mainAppContext?.read<AppProvider>();
    CourseDownloadProvider? courseDownloadProvider = AppController.mainAppContext?.read<CourseDownloadProvider>();
    CourseDownloadController? courseDownloadController;
    if (appProvider != null && courseDownloadProvider != null) {
      courseDownloadController = CourseDownloadController(appProvider: appProvider, courseDownloadProvider: courseDownloadProvider);
    }

    //region If Not refresh and Data available, return Cached Data
    if (!isRefresh && isGetFromCache && provider.myLearningContentsLength > 0) {
      MyPrint.printOnConsole("Returning Cached Data", tag: tag);
      return provider.getMyLearningContentsList();
    }
    //endregion

    //region If refresh, then reset provider data
    if (isRefresh) {
      MyPrint.printOnConsole("Refresh", tag: tag);
      provider.updateMyLearningPaginationData(hasMore: true, isNotify: false);
      provider.updateMyLearningPaginationData(pageIndex: 1, isNotify: false);
      provider.updateMyLearningPaginationData(isFirstTimeLoading: true, isNotify: false);
      provider.updateMyLearningPaginationData(isLoading: false, isNotify: false);
      provider.setMyLearningContentIdsList(contentIds: <String>[], isClear: true, isNotify: isNotify);
    }
    //endregion

    //region If Not Has More Data, then return
    if (!paginationModel.hasMore) {
      MyPrint.printOnConsole('No More My Learning Contents', tag: tag);
      return provider.getMyLearningContentsList();
    }
    //endregion

    //region If Data already Loading, then return
    if (paginationModel.isLoading) return provider.getMyLearningContentsList();
    //endregion

    //region Set Loading True
    provider.updateMyLearningPaginationData(isLoading: true, isNotify: isNotify);
    //endregion

    DateTime startTime = DateTime.now();

    //region Get Request Model From Provider Data
    MyLearningDataRequestModel myLearningDataRequestModel = getMyLearningDataRequestModelFromProviderData(
      myLearningProvider: provider,
      filterProvider: provider.filterProvider,
      paginationModel: provider.myLearningPaginationModel,
      componentId: componentId,
      componentInstanceId: componentInstanceId,
      apiUrlConfigurationProvider: apiUrlConfigurationProvider,
      isArchived: false,
      isWaitList: false,
    );
    //endregion

    bool isInternetAvailable = NetworkConnectionController().checkConnection();
    MyPrint.printOnConsole("isInternetAvailable:$isInternetAvailable", tag: tag);
    List<CourseDTOModel> contentsList = <CourseDTOModel>[];

    //region Make Api Call
    if (isInternetAvailable) {
      if (courseDownloadController != null) {
        await courseDownloadController.checkAndValidateDownloadedItemsEnrollmentStatus();
      }

      DataResponseModel<MyLearningResponseDTOModel> response = await myLearningRepository.getMyLearningContentsListMain(
        requestModel: myLearningDataRequestModel,
        componentId: componentId,
        componentInstanceId: componentInstanceId,
        isStoreDataInHive: true,
        isFromOffline: false,
      );
      MyPrint.printOnConsole("My Learning Contents Length From Api:${response.data?.CourseList.length ?? 0}", tag: tag);

      contentsList = response.data?.CourseList ?? <CourseDTOModel>[];
    } else {
      contentsList = await myLearningHiveRepository.getAllMyLearningCourseModelsListFromHive();
    }
    //endregion

    MyPrint.printOnConsole("Final My Learning Contents Length:${contentsList.length}", tag: tag);

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole("My Learning Data got in ${endTime.difference(startTime).inMilliseconds} Milliseconds", tag: tag);

    //region Set Provider Data After Getting Data From Api
    if (isInternetAvailable) {
      if (contentsList.length < provider.pageSize.get()) provider.updateMyLearningPaginationData(hasMore: false);
      if (contentsList.isNotEmpty) provider.updateMyLearningPaginationData(pageIndex: paginationModel.pageIndex + 1);
      provider.addMyLearningContentsInList(myLearningContentModels: contentsList, isClear: false, isNotify: false);

      List<Future> futures = [
        myLearningHiveRepository.addMyLearningCourseIdInHive(myLearningCourseIds: contentsList.map((e) => e.ContentID).toList(), isClear: isRefresh),
        myLearningHiveRepository.setMyLearningCourseModelInHive(courseModelsMap: Map.fromEntries(contentsList.map((e) => MapEntry(e.ContentID, e))), isClear: isRefresh),
      ];

      if (courseDownloadController != null) {
        futures.add(courseDownloadController.updateMyLearningContentsInDownloadsAndSyncDataOffline(contentsList: contentsList));
      }

      await Future.wait(futures);
    } else {
      provider.updateMyLearningPaginationData(hasMore: false);
      provider.setMyLearningContentIdsList(contentIds: <String>[], isClear: true, isNotify: false);
      provider.addMyLearningContentsInList(myLearningContentModels: contentsList, isClear: false, isNotify: false);
    }
    provider.updateMyLearningPaginationData(isFirstTimeLoading: false, isNotify: false);
    provider.updateMyLearningPaginationData(isLoading: false, isNotify: true);
    //endregion

    MyPrint.printOnConsole("Final My Learning Contents Length in Provider:${provider.myLearningContentsLength}", tag: tag);

    return provider.getMyLearningContentsList();
  }

  Future<List<CourseDTOModel>> getMyLearningArchivedContentsListFromApi({
    bool isRefresh = true,
    bool isGetFromCache = false,
    bool isNotify = true,
    required int componentId,
    required int componentInstanceId,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
        "MyLearningController().getMyLearningArchivedContentsListFromApi() called with isRefresh:$isRefresh, isGetFromCache:$isGetFromCache, "
        "isNotify:$isNotify, componentId:$componentId, componentInstanceId:$componentInstanceId",
        tag: tag);

    MyLearningProvider provider = myLearningProvider;
    PaginationModel paginationModel = provider.myLearningArchivedPaginationModel;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = myLearningRepository.apiController.apiDataProvider;
    AppProvider? appProvider = AppController.mainAppContext?.read<AppProvider>();
    CourseDownloadProvider? courseDownloadProvider = AppController.mainAppContext?.read<CourseDownloadProvider>();
    CourseDownloadController? courseDownloadController;
    if (appProvider != null && courseDownloadProvider != null) {
      courseDownloadController = CourseDownloadController(appProvider: appProvider, courseDownloadProvider: courseDownloadProvider);
    }

    //region If Not refresh and Data available, return Cached Data
    if (!isRefresh && isGetFromCache && provider.myLearningArchivedContentsLength > 0) {
      MyPrint.printOnConsole("Returning Cached Data", tag: tag);
      return provider.getMyLearningArchivedContentsList();
    }
    //endregion

    //region If refresh, then reset provider data
    if (isRefresh) {
      MyPrint.printOnConsole("Refresh", tag: tag);
      provider.updateMyLearningArchivedPaginationData(hasMore: true, isNotify: false);
      provider.updateMyLearningArchivedPaginationData(pageIndex: 1, isNotify: false);
      provider.updateMyLearningArchivedPaginationData(isFirstTimeLoading: true, isNotify: false);
      provider.updateMyLearningArchivedPaginationData(isLoading: false, isNotify: false);
      provider.setMyLearningArchivedContentIdsList(contentIds: <String>[], isClear: true, isNotify: isNotify);
    }
    //endregion

    //region If Not Has More Data, then return
    if (!paginationModel.hasMore) {
      MyPrint.printOnConsole('No More My Learning Contents', tag: tag);
      return provider.getMyLearningArchivedContentsList();
    }
    //endregion

    //region If Data already Loading, then return
    if (paginationModel.isLoading) return provider.getMyLearningArchivedContentsList();
    //endregion

    //region Set Loading True
    provider.updateMyLearningArchivedPaginationData(isLoading: true, isNotify: isNotify);
    //endregion

    DateTime startTime = DateTime.now();

    //region Get Request Model From Provider Data
    MyLearningDataRequestModel myLearningDataRequestModel = getMyLearningDataRequestModelFromProviderData(
      myLearningProvider: provider,
      filterProvider: provider.filterProvider,
      paginationModel: paginationModel,
      componentId: componentId,
      componentInstanceId: componentInstanceId,
      apiUrlConfigurationProvider: apiUrlConfigurationProvider,
      isArchived: true,
      isWaitList: false,
    );
    //endregion

    bool isInternetAvailable = NetworkConnectionController().checkConnection();
    MyPrint.printOnConsole("isInternetAvailable:$isInternetAvailable", tag: tag);
    List<CourseDTOModel> contentsList = <CourseDTOModel>[];

    //region Make Api Call
    if (isInternetAvailable) {
      if (courseDownloadController != null) {
        await courseDownloadController.checkAndValidateDownloadedItemsEnrollmentStatus();
      }

      DataResponseModel<MyLearningResponseDTOModel> response = await myLearningRepository.getMyLearningContentsListMain(
        requestModel: myLearningDataRequestModel,
        componentId: componentId,
        componentInstanceId: componentInstanceId,
        isStoreDataInHive: true,
        isFromOffline: false,
      );
      MyPrint.printOnConsole("My Learning Contents Length From Api:${response.data?.CourseList.length ?? 0}", tag: tag);

      contentsList = response.data?.CourseList ?? <CourseDTOModel>[];
    } else {
      // contentsList = await myLearningHiveRepository.getAllMyLearningCourseModelsListFromHive();
    }
    //endregion

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole("My Learning Archived Data got in ${endTime.difference(startTime).inMilliseconds} Milliseconds", tag: tag);

    MyPrint.printOnConsole("My Learning Archived Contents Length got in Api:${contentsList.length}", tag: tag);

    //region Set Provider Data After Getting Data From Api
    if (isInternetAvailable) {
      if (contentsList.length < provider.pageSize.get()) provider.updateMyLearningArchivedPaginationData(hasMore: false);
      if (contentsList.isNotEmpty) provider.updateMyLearningArchivedPaginationData(pageIndex: paginationModel.pageIndex + 1);
      provider.addMyLearningArchivedContentsInList(myLearningContentModels: contentsList, isClear: false, isNotify: false);

      List<Future> futures = [];

      if (courseDownloadController != null) {
        futures.add(courseDownloadController.updateMyLearningContentsInDownloadsAndSyncDataOffline(contentsList: contentsList));
      }

      await Future.wait(futures);
    } else {
      provider.updateMyLearningArchivedPaginationData(hasMore: false);
      provider.setMyLearningArchivedContentIdsList(contentIds: <String>[], isClear: true, isNotify: false);
      provider.addMyLearningArchivedContentsInList(myLearningContentModels: contentsList, isClear: false, isNotify: false);
    }
    provider.updateMyLearningArchivedPaginationData(isFirstTimeLoading: false, isNotify: false);
    provider.updateMyLearningArchivedPaginationData(isLoading: false, isNotify: true);
    //endregion

    return provider.getMyLearningArchivedContentsList();
  }

  Future<List<CourseDTOModel>> getMyLearningWaitlistContentsListFromApi({
    bool isRefresh = true,
    bool isGetFromCache = false,
    bool isNotify = true,
    required int componentId,
    required int componentInstanceId,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
        "MyLearningController().getMyLearningWaitlistContentsListFromApi() called with isRefresh:$isRefresh, isGetFromCache:$isGetFromCache, "
        "isNotify:$isNotify, componentId:$componentId, componentInstanceId:$componentInstanceId",
        tag: tag);

    MyLearningProvider provider = myLearningProvider;
    PaginationModel paginationModel = provider.myLearningWaitlistPaginationModel.get();

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = myLearningRepository.apiController.apiDataProvider;

    //region If Not refresh and Data available, return Cached Data
    if (!isRefresh && isGetFromCache && provider.myLearningWaitlistContentsLength > 0) {
      MyPrint.printOnConsole("Returning Cached Data", tag: tag);
      return provider.myLearningWaitlistContents.getList();
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
      provider.myLearningWaitlistContents.setList(list: [], isClear: true, isNotify: isNotify);
    }
    //endregion

    //region If Not Has More Data, then return
    if (!paginationModel.hasMore) {
      MyPrint.printOnConsole('No More My Learning Contents', tag: tag);
      return provider.myLearningWaitlistContents.getList();
    }
    //endregion

    //region If Data already Loading, then return
    if (paginationModel.isLoading) return provider.myLearningWaitlistContents.getList();
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
    MyLearningDataRequestModel myLearningDataRequestModel = getMyLearningDataRequestModelFromProviderData(
      myLearningProvider: provider,
      filterProvider: provider.filterProvider,
      paginationModel: paginationModel,
      componentId: componentId,
      componentInstanceId: componentInstanceId,
      apiUrlConfigurationProvider: apiUrlConfigurationProvider,
      isArchived: false,
      isWaitList: true,
    );
    //endregion

    //region Make Api Call
    DataResponseModel<MyLearningResponseDTOModel> response = await myLearningRepository.getMyLearningContentsListMain(
      requestModel: myLearningDataRequestModel,
      componentId: componentId,
      componentInstanceId: componentInstanceId,
      isStoreDataInHive: true,
      isFromOffline: false,
    );
    MyPrint.printOnConsole("My Learning Waitlist Contents Length:${response.data?.CourseList.length ?? 0}", tag: tag);
    //endregion

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole("My Learning Waitlist Data got in ${endTime.difference(startTime).inMilliseconds} Milliseconds", tag: tag);

    List<CourseDTOModel> contentsList = response.data?.CourseList ?? <CourseDTOModel>[];
    MyPrint.printOnConsole("My Learning Waitlist Contents Length got in Api:${contentsList.length}", tag: tag);

    //region Set Provider Data After Getting Data From Api
    PaginationModel.updatePaginationData(
      paginationModel: paginationModel,
      hasMore: contentsList.length == provider.pageSize.get(),
      pageIndex: paginationModel.pageIndex + 1,
      isFirstTimeLoading: false,
      isLoading: false,
      notifier: provider.notify,
      notify: true,
    );

    provider.myLearningWaitlistContents.setList(list: contentsList, isClear: false, isNotify: false);
    //endregion

    return provider.myLearningWaitlistContents.getList();
  }

  Future<List<CourseDTOModel>> getExternalContentsListFromApi({
    bool isRefresh = true,
    bool isGetFromCache = false,
    bool isNotify = true,
    required int componentId,
    required int componentInstanceId,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
        "MyLearningController().getExternalContentsListFromApi() called with isRefresh:$isRefresh, isGetFromCache:$isGetFromCache, "
        "isNotify:$isNotify, componentId:$componentId, componentInstanceId:$componentInstanceId",
        tag: tag);

    MyLearningProvider provider = myLearningProvider;
    PaginationModel paginationModel = provider.myLearningExternalPaginationModel.get();

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = myLearningRepository.apiController.apiDataProvider;

    //region If Not refresh and Data available, return Cached Data
    if (!isRefresh && isGetFromCache && provider.myLearningExternalContentsLength > 0) {
      MyPrint.printOnConsole("Returning Cached Data", tag: tag);
      return provider.myLearningExternalContents.getList();
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
      provider.myLearningExternalContents.setList(list: [], isClear: true, isNotify: isNotify);
    }
    //endregion

    //region If Not Has More Data, then return
    if (!paginationModel.hasMore) {
      MyPrint.printOnConsole('No More My Learning Contents', tag: tag);
      return provider.myLearningExternalContents.getList();
    }
    //endregion

    //region If Data already Loading, then return
    if (paginationModel.isLoading) return provider.myLearningExternalContents.getList();
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
    MyLearningDataRequestModel myLearningDataRequestModel = getMyLearningDataRequestModelFromProviderData(
      myLearningProvider: provider,
      filterProvider: provider.filterProvider,
      paginationModel: paginationModel,
      componentId: componentId,
      componentInstanceId: componentInstanceId,
      apiUrlConfigurationProvider: apiUrlConfigurationProvider,
      isArchived: false,
      isWaitList: false,
    );
    //endregion

    //region Make Api Call
    DataResponseModel<MyLearningResponseDTOModel> response = await Future<DataResponseModel<MyLearningResponseDTOModel>>.delayed(
      const Duration(seconds: 1),
      () => const DataResponseModel<MyLearningResponseDTOModel>(),
    );
    /*DataResponseModel<MyLearningResponseDTOModel> response = await myLearningRepository.getMyLearningContentsListMain(
      requestModel: myLearningDataRequestModel,
      componentId: componentId,
      componentInstanceId: componentInstanceId,
      isStoreDataInHive: true,
      isFromOffline: false,
    );*/
    MyPrint.printOnConsole("My Learning External Contents Length:${response.data?.CourseList.length ?? 0}", tag: tag);
    //endregion

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole("My Learning External Data got in ${endTime.difference(startTime).inMilliseconds} Milliseconds", tag: tag);

    List<CourseDTOModel> contentsList = response.data?.CourseList ?? <CourseDTOModel>[];
    MyPrint.printOnConsole("My Learning External Contents Length got in Api:${contentsList.length}", tag: tag);

    //region Set Provider Data After Getting Data From Api
    PaginationModel.updatePaginationData(
      paginationModel: paginationModel,
      hasMore: contentsList.length == provider.pageSize.get(),
      pageIndex: paginationModel.pageIndex + 1,
      isFirstTimeLoading: false,
      isLoading: false,
      notifier: provider.notify,
      notify: false,
    );

    provider.myLearningExternalContents.setList(list: contentsList, isClear: false, isNotify: false);

    if (isRefresh) {
      checkAndAddDummyContentsInExternalLearning(isNotify: true);
    }
    //endregion

    return provider.myLearningExternalContents.getList();
  }

  MyLearningDataRequestModel getMyLearningDataRequestModelFromProviderData({
    required MyLearningProvider myLearningProvider,
    required PaginationModel paginationModel,
    required int componentId,
    required int componentInstanceId,
    required bool isArchived,
    required bool isWaitList,
    required ApiUrlConfigurationProvider apiUrlConfigurationProvider,
    required FilterProvider filterProvider,
  }) {
    EnabledContentFilterByTypeModel enabledContentFilterByTypeModel = filterProvider.getEnabledContentFilterByTypeModel(isNewInstance: false);

    String filtercredits = "";
    if (enabledContentFilterByTypeModel.creditpoints) {
      FilterDurationValueModel? model = filterProvider.selectedFilterCredit.get();
      if (model != null) filtercredits = "${model.Minvalue},${model.Maxvalue}";
    }

    return MyLearningDataRequestModel(
      pageIndex: paginationModel.pageIndex,
      pageSize: myLearningProvider.pageSize.get(),
      searchText: isArchived ? myLearningProvider.myLearningArchivedSearchString : myLearningProvider.myLearningSearchString,
      source: 0,
      type: 0,
      componentId: componentId,
      componentInsId: componentInstanceId,
      hideComplete: "false",
      keywords: "",
      isArchived: isArchived ? 1 : 0,
      isWaitList: isWaitList ? 1 : 0,
      sortBy: myLearningProvider.filterProvider.selectedSort.get(),
      userId: apiUrlConfigurationProvider.getCurrentUserId(),
      siteId: apiUrlConfigurationProvider.getCurrentSiteId(),
      orgUnitId: apiUrlConfigurationProvider.getCurrentSiteId(),
      locale: apiUrlConfigurationProvider.getLocale().isNotEmpty ? apiUrlConfigurationProvider.getLocale() : "en-us",
      categories: enabledContentFilterByTypeModel.categories
          ? AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
              list: filterProvider.selectedCategories.getList().map((e) => e.categoryId).toList(),
            )
          : "",
      objectTypes: enabledContentFilterByTypeModel.objecttypeid
          ? AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
              list: filterProvider.selectedContentTypes.getList().map((e) => e.categoryId).toList(),
            )
          : "",
      skillCats: enabledContentFilterByTypeModel.skills
          ? AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
              list: filterProvider.selectedSkills.getList().map((e) => e.categoryId).toList(),
            )
          : "",
      skills: "",
      jobRoles: enabledContentFilterByTypeModel.jobroles
          ? AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
              list: filterProvider.selectedJobRoles.getList().map((e) => e.categoryId).toList(),
            )
          : "",
      solutions: enabledContentFilterByTypeModel.solutions
          ? AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
              list: filterProvider.selectedSolutions.getList().map((e) => e.categoryId).toList(),
            )
          : "",
      ratings: enabledContentFilterByTypeModel.rating ? ParsingHelper.parseStringMethod(filterProvider.selectedRating.get()) : "",
      priceRange: enabledContentFilterByTypeModel.ecommerceprice && filterProvider.minPrice.get() != null && filterProvider.maxPrice.get() != null
          ? "${filterProvider.minPrice.get()},${filterProvider.maxPrice.get()}"
          : "",
      duration: "",
      instructors: enabledContentFilterByTypeModel.instructor
          ? AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
              list: filterProvider.selectedInstructor.getList().map((e) => e.UserID).toList(),
            )
          : "",
      filterCredits: filtercredits,
      multiLocation: "",
      contentID: "",
      contentStatus: "",
    );
  }

  //endregion

  Future<bool> addToArchive({required String contentId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MyLearningController().addToArchive() called with contentId:'$contentId'", tag: tag);

    DataResponseModel response = await myLearningRepository.addRemoveFromArchieve(
      contentID: contentId,
      isArchived: true,
    );
    MyPrint.printOnConsole("Add to Archieve Response Data:${response.data}", tag: tag);

    return response.data == "1";
  }

  Future<bool> removeFromArchive({required String contentId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MyLearningController().removeFromArchive() called with contentId:'$contentId'", tag: tag);

    DataResponseModel response = await myLearningRepository.addRemoveFromArchieve(
      contentID: contentId,
      isArchived: false,
    );
    MyPrint.printOnConsole("Remove to Archieve Response Data:${response.data}", tag: tag);

    return response.data == "1";
  }

  Future<bool> setComplete({required String contentId, required int scoId, required int contentTypeId, String parentEventTrackContentId = ""}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MyLearningController().setComplete() called with contentId:'$contentId', scoId:'$scoId', contentTypeId:'$contentTypeId'", tag: tag);

    DataResponseModel response = await myLearningRepository.setCompleteStatus(
      contentID: contentId,
      scoId: scoId,
    );
    MyPrint.printOnConsole("Set Complete Response Data:$response", tag: tag);

    bool isSuccess = response.statusCode == 200;

    if (isSuccess) {
      if (AppController.mainAppContext != null) {
        CourseDownloadProvider courseDownloadProvider = AppController.mainAppContext!.read<CourseDownloadProvider>();
        AppProvider appProvider = AppController.mainAppContext!.read<AppProvider>();
        CourseDownloadController courseDownloadController = CourseDownloadController(appProvider: appProvider, courseDownloadProvider: courseDownloadProvider);

        CourseDownloadDataModel? courseDownloadDataModel = courseDownloadProvider.getCourseDownloadDataModelFromId(
          courseDownloadId: CourseDownloadDataModel.getDownloadId(
            contentId: contentId,
            eventTrackContentId: parentEventTrackContentId,
          ),
        );

        if (courseDownloadDataModel != null) {
          courseDownloadController.setCompleteDownload(courseDownloadDataModel: courseDownloadDataModel);
        }
      }

      await GamificationController(provider: NavigationController.mainNavigatorKey.currentContext?.read<GamificationProvider>()).UpdateContentGamification(
        requestModel: UpdateContentGamificationRequestModel(
          contentId: contentId,
          scoId: scoId,
          objecttypeId: contentTypeId,
          GameAction: GamificationActionType.Completed,
          isCourseLaunch: false,
          CanTrack: false,
        ),
      );
    }

    return isSuccess;
  }

  // Future<bool> setCompleteMyLearning({required String contentId, required int scoId}) async {
  //   String tag = MyUtils.getNewId();
  //   MyPrint.printOnConsole("MyLearningController().setComplete() called with contentId:'$contentId', scoId:'$scoId'", tag: tag);
  //
  //   DataResponseModel response = await myLearningRepository.setCompleteStatus(
  //     contentID: contentId,
  //     scoId: scoId,
  //   );
  //   MyPrint.printOnConsole("Set Complete Response Data:$response", tag: tag);
  //
  //   return response.statusCode == 200;
  // }

  Future<void> viewCompletionCertificate({
    required BuildContext context,
    required String contentId,
    required String certificateLink,
  }) async {
    if (!AppConfigurationOperations.isValidString(certificateLink) || certificateLink == 'notearned') {
      /*if(!ConnectionController().checkConnection(context: NavigationController().actbaseScaffoldKey.currentContext!)) {
        return;
      }*/

      showDialog(
        context: context,
        builder: (BuildContext context) => const MyLearningCertificateNotEarnedAlertDialog(),
      );
    } else {
      /*if(!ConnectionController().checkConnection(context: NavigationController().actbaseScaffoldKey.currentContext!)) {
        return;
      }*/

      List<String> list = AppConfigurationOperations.getListFromSeparatorJoinedString(parameterString: certificateLink, separator: ":,");

      String certificateId = list.isNotEmpty ? list[0] : "";
      String certificatePage = list.length >= 2 ? list[1] : "";

      NavigationController.navigateToViewCompletionCertificateScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: ViewCompletionCertificateScreenNavigationArguments(
          contentId: contentId,
          certificateId: certificateId,
          certificatePage: certificatePage,
        ),
      );
    }
  }

  //https://upgradedenterpriseapi.instancy.com/api/Notes/GetAllUserPageNotes?UserID=363&TrackID=&ContentID=8e7a9d32-c834-4c77-828e-ecb140742479&PageID=-1&SeqID=0&SiteID=374

  Future<PageNotesResponseModel> getAllUserPageNotes({
    required String contentId,
    required int componentId,
    required int componentInstanceId,
  }) async {
    MyPrint.printOnConsole("getAssociatedContent");

    DataResponseModel<PageNotesResponseModel> response = await myLearningRepository.getPageNotes(
      componentId: componentId,
      contentId: contentId,
      componentInstanceId: componentInstanceId,
    );
    MyPrint.printOnConsole("return getAssociatedContent");

    MyPrint.printOnConsole("response: ${response.data}");
    PageNotesResponseModel pageNotesResponseModel = PageNotesResponseModel();
    if (response.data != null) {
      pageNotesResponseModel = PageNotesResponseModel.fromJson(response.data!.toJson());
    }
    // AssociatedContentResponseModel associatedContentResponse = AssociatedContentResponseModel.fromJson(response.data!.toJson());
    // MyPrint.printOnConsole("getAssociatedContent.associatedContentResponse : ${associatedContentResponse.CourseList.length}");

    return pageNotesResponseModel;
  }

  Future<PageNotesResponseModel> savePageNote({
    required String contentID,
    int pageId = -1,
    String trackId = '',
    int seqId = 0,
    int count = 0,
    required String text,
  }) async {
    MyPrint.printOnConsole("getAssociatedContent");

    DataResponseModel<String> response = await myLearningRepository.savePageNote(
      text: text,
      contentID: contentID,
      count: count,
      pageId: pageId,
      seqId: seqId,
      trackId: trackId,
    );
    MyPrint.printOnConsole("return getAssociatedContent");

    MyPrint.printOnConsole("response: ${response.data}");
    PageNotesResponseModel pageNotesResponseModel = PageNotesResponseModel();
    if (response.data != null) {
      // pageNotesResponseModel = PageNotesResponseModel.fromJson(response.data!.toJson());
    }
    // AssociatedContentResponseModel associatedContentResponse = AssociatedContentResponseModel.fromJson(response.data!.toJson());
    // MyPrint.printOnConsole("getAssociatedContent.associatedContentResponse : ${associatedContentResponse.CourseList.length}");

    return pageNotesResponseModel;
  }

  Future<PageNotesResponseModel> deletePageNotes({
    required String contentID,
    int pageId = -1,
    String trackId = '',
    int seqId = 0,
    int count = 0,
  }) async {
    MyPrint.printOnConsole("getAssociatedContent");

    DataResponseModel<String> response = await myLearningRepository.deletePageNotes(contentID: contentID, count: count, pageId: pageId, seqId: seqId, trackId: trackId);
    MyPrint.printOnConsole("return getAssociatedContent");

    MyPrint.printOnConsole("response: ${response.data}");
    PageNotesResponseModel pageNotesResponseModel = PageNotesResponseModel();
    if (response.data != null) {
      // pageNotesResponseModel = PageNotesResponseModel.fromJson(response.data!.toJson());
    }
    // AssociatedContentResponseModel associatedContentResponse = AssociatedContentResponseModel.fromJson(response.data!.toJson());
    // MyPrint.printOnConsole("getAssociatedContent.associatedContentResponse : ${associatedContentResponse.CourseList.length}");

    return pageNotesResponseModel;
  }

  Future<Map<String, bool>> checkContentIdsEnrolled({required CheckContentsEnrollmentStatusRequestModel requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MyLearningController().checkContentIdsEnrolled() called for contentIds:${requestModel.contentIds}", tag: tag);

    Map<String, bool> response = <String, bool>{};

    DataResponseModel<CheckContentsEnrollmentStatusResponseModel?> responseModel = await myLearningRepository.checkContentsEnrollmentStatus(requestModel: requestModel);

    MyPrint.printOnConsole("checkContentsEnrollmentStatus response:$responseModel", tag: tag);

    if (responseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from MyLearningController().checkContentIdsEnrolled() because Error Occurred in Api:${responseModel.appErrorModel?.message}", tag: tag);
      MyPrint.printOnConsole(responseModel.appErrorModel?.stackTrace ?? "", tag: tag);
      return response;
    } else if (responseModel.data == null) {
      MyPrint.printOnConsole("Returning from MyLearningController().checkContentIdsEnrolled() because Response Data is null", tag: tag);
      MyPrint.printOnConsole(responseModel.appErrorModel?.stackTrace ?? "", tag: tag);
      return response;
    }

    CheckContentsEnrollmentStatusResponseModel responseContentIds = responseModel.data!;

    for (String contentId in requestModel.contentIds) {
      response[contentId] = responseContentIds.CourseData[contentId] != null;
    }

    MyPrint.printOnConsole("Final response:$response", tag: tag);

    return response;
  }

  Future<void> checkAndAddDummyContentsInExternalLearning({bool isNotify = true}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MyLearningController().checkAndAddDummyContentsInExternalLearning() called with isNotify:$isNotify", tag: tag);

    MyLearningProvider provider = myLearningProvider;

    if (provider.myLearningExternalContentsLength > 0) {
      MyPrint.printOnConsole("Returning from MyLearningController().checkAndAddDummyContentsInExternalLearning() because data are not empty", tag: tag);
      return;
    }

    Map<String, dynamic> contentMap = <String, dynamic>{
      "Expired": "",
      "ContentStatus": " <span title='Not Started' class='statusNotStarted'>Not Started</span>",
      "ReportLink":
          "<a class='fa viewicon' href='#' title='Delete' onclick=\"javascript:fnDelete(this,'Please confirm before deleting this content item?',3,688,'2ce73a32-0165-4266-bc7e-34a1d87e3b39',0,'Economic Developments','Delete Content');\">Delete</a>",
      "DiscussionsLink": "",
      "CertificateLink": "",
      "NotesLink": "",
      "CancelEventLink": "",
      "DownLoadLink": "",
      "RepurchaseLink": "",
      "SetcompleteLink": "",
      "ViewRecordingLink": "",
      "InstructorCommentsLink": "",
      "Required": 0,
      "DownloadCalender": "",
      "EventScheduleLink": "",
      "EventScheduleStatus": "",
      "EventScheduleConfirmLink": "",
      "EventScheduleCancelLink": "",
      "EventScheduleReserveTime": "",
      "EventScheduleReserveStatus": "",
      "ReScheduleEvent": "",
      "Addorremoveattendees": "",
      "CancelScheduleEvent": "",
      "Sharelink": "https://qalearning.instancy.com/InviteURLID/contentId/2ce73a32-0165-4266-bc7e-34a1d87e3b39/ComponentId/1",
      "SurveyLink": "",
      "RemoveLink":
          "<a id='remove_2ce73a32-0165-4266-bc7e-34a1d87e3b39' title='Delete' href=\"Javascript:fnUnassignUserContent('2ce73a32-0165-4266-bc7e-34a1d87e3b39','Are you sure you want to remove the content item?');\">Delete</a> ",
      "RatingLink": "https://qalearning.instancy.com/MyCatalog Details/Contentid/2ce73a32-0165-4266-bc7e-34a1d87e3b39/componentid/3/componentInstanceID/3134/Muserid/1962",
      "DurationEndDate": null,
      "PracticeAssessmentsAction": "",
      "CreateAssessmentAction": "",
      "OverallProgressReportAction": "",
      "EditLink": "",
      "TitleName": "Economic Developments",
      "PercentCompleted": 0.0,
      "PercentCompletedClass": "statusNotStarted",
      "WindowProperties": "status=no,toolbar=no,menubar=no,resizable=yes,location=no,scrollbars=yes,left=10,top=10,width=1000,height=680",
      "CancelOrderData": "",
      "CombinedTransaction": false,
      "EventScheduleType": 0,
      "TypeofEvent": 1,
      "Duration": "",
      "IsViewReview": true,
      "JWVideoKey": "",
      "Credits": "",
      "IsArchived": false,
      "DetailspopupTags": "",
      "ThumbnailIconPath": null,
      "InstanceEventEnroll": "",
      "Modules": "",
      "InstanceEventReSchedule": "",
      "InstanceEventReclass": "",
      "isEnrollFutureInstance": "",
      "ReEnrollmentHistory": "",
      "isBadCancellationEnabled": "true",
      "MediaTypeID": 0,
      "ActionViewQRcode": "",
      "RecordingDetails": null,
      "EnrollmentLimit": null,
      "AvailableSeats": null,
      "NoofUsersEnrolled": null,
      "WaitListLimit": null,
      "WaitListEnrolls": null,
      "isBookingOpened": false,
      "SubSiteMemberShipExpiried": false,
      "ShowLearnerActions": true,
      "SkinID": "",
      "BackGroundColor": "#2f2d3a",
      "FontColor": "#fff",
      "FilterId": 0,
      "SiteId": 374,
      "UserSiteId": 0,
      "SiteName": "Instancy Social Learning Network",
      "ContentTypeId": 688,
      "ContentID": "2ce73a32-0165-4266-bc7e-34a1d87e3b39",
      "Title": "Economic Developments",
      "TotalRatings": "0",
      "RatingID": "0",
      "ShortDescription":
          "This course will teach you how the Economic Developments of India Works. It will describe all the factors that affects it. Also the ways by which we can increase Economic Development.",
      "ThumbnailImagePath": "/Content/SiteFiles/Images/External Training.jpg",
      "InstanceParentContentID": "",
      "ImageWithLink": null,
      "AuthorWithLink": "Richard Parker",
      "EventStartDateTime": "",
      "EventEndDateTime": null,
      "EventStartDateTimeWithoutConvert": null,
      "EventEndDateTimeTimeWithoutConvert": null,
      "expandiconpath": null,
      "AuthorDisplayName": "Richard Parker",
      "ContentType": "External Training",
      "CreatedOn": null,
      "TimeZone": null,
      "Tags": null,
      "SalePrice": null,
      "Currency": null,
      "ViewLink": "",
      "DetailsLink": "https://qalearning.instancy.com/MyCatalog Details/Contentid/2ce73a32-0165-4266-bc7e-34a1d87e3b39/componentid/3/componentInstanceID/3134/Muserid/1962",
      "RelatedContentLink": "",
      "ViewSessionsLink": "",
      "SuggesttoConnLink": "2ce73a32-0165-4266-bc7e-34a1d87e3b39",
      "SuggestwithFriendLink": "2ce73a32-0165-4266-bc7e-34a1d87e3b39",
      "SharetoRecommendedLink": null,
      "IsCoursePackage": null,
      "IsRelatedcontent": "",
      "isaddtomylearninglogo": null,
      "LocationName": null,
      "BuildingName": null,
      "JoinURL": null,
      "Categorycolor": "#67BD4E",
      "InvitationURL": null,
      "HeaderLocationName": "none",
      "SubSiteUserID": null,
      "PresenterDisplayName": "",
      "PresenterWithLink": null,
      "ShowMembershipExpiryAlert": false,
      "AuthorName": "Richard Parker",
      "FreePrice": null,
      "SiteUserID": 1962,
      "ScoID": 26746,
      "BuyNowLink": "",
      "bit5": false,
      "bit4": false,
      "OpenNewBrowserWindow": false,
      "salepricestrikeoff": "",
      "CreditScoreWithCreditTypes": null,
      "CreditScoreFirstPrefix": null,
      "EventType": 0,
      "InstanceEventReclassStatus": "",
      "ExpiredContentExpiryDate": "",
      "ExpiredContentAvailableUntill": "",
      "Gradient1": null,
      "Gradient2": null,
      "GradientColor": null,
      "ShareContentwithUser": "",
      "bit1": false,
      "ViewType": 1,
      "startpage": "",
      "CategoryID": 0,
      "AddLinkTitle": null,
      "GoogleProductId": null,
      "ItunesProductId": null,
      "ContentName": "Economic Developments",
      "FolderPath": "2CE73A32-0165-4266-BC7E-34A1D87E3B39",
      "CloudMediaPlayerKey": "",
      "ActivityId": "http://instancy.com/2ce73a32-0165-4266-bc7e-34a1d87e3b39",
      "ActualStatus": "not attempted",
      "CoreLessonStatus": " <span title='Not Started' class='statusNotStarted'>Not Started</span>",
      "jwstartpage": "en-us/2ce73a32-0165-4266-bc7e-34a1d87e3b39.html",
      "IsReattemptCourse": false,
      "AttemptsLeft": 0,
      "TotalAttempts": 0,
      "ListPrice": null,
      "ContentModifiedDateTime": "04/22/2024 05:27:03 AM"
    };

    List<CourseDTOModel> list = List<CourseDTOModel>.generate(4, (index) {
      CourseDTOModel courseDTOModel = CourseDTOModel.fromMap(contentMap);

      courseDTOModel.ContentID = MyUtils.getNewId();
      courseDTOModel.UserProfileImagePath = "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg";

      switch (index) {
        case 0:
          {
            courseDTOModel.ContentName = "Certification in Economic Growth and development";
            courseDTOModel.Title = courseDTOModel.ContentName;
            courseDTOModel.TitleName = courseDTOModel.ContentName;
            courseDTOModel.ShortDescription = "Unleash the potential of nations through economic growth and development";
            break;
          }
        case 1:
          {
            courseDTOModel.ContentName = "Microeconomics: A Comprehensive Economics Course";
            courseDTOModel.Title = courseDTOModel.ContentName;
            courseDTOModel.TitleName = courseDTOModel.ContentName;
            courseDTOModel.ShortDescription = "A Course Designed to Give You a Better Understanding of the World Around You--Perfect for University and Adult Learners!";
            break;
          }
        case 2:
          {
            courseDTOModel.ContentName = "(Oxford) Master Diploma : Economics (Includes Macro/Micro)";
            courseDTOModel.Title = courseDTOModel.ContentName;
            courseDTOModel.TitleName = courseDTOModel.ContentName;
            courseDTOModel.ShortDescription = "92 HOURS : Micro/Macro/Global/Business/Behavioural Economics";
            break;
          }
        case 3:
          {
            courseDTOModel.ContentName = "International Economics: A Comprehensive Economics Course";
            courseDTOModel.Title = courseDTOModel.ContentName;
            courseDTOModel.TitleName = courseDTOModel.ContentName;
            courseDTOModel.ShortDescription = "A Course Designed to Give You a Better Understanding International Business--Perfect for University and Adult Learners!";
            break;
          }
        default:
          {
            break;
          }
      }

      return courseDTOModel;
    });

    provider.myLearningExternalContents.setList(list: list, isClear: true, isNotify: isNotify);
  }
}
