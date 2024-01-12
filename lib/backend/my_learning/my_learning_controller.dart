import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/api/api_url_configuration_provider.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/backend/filter/filter_provider.dart';
import 'package:flutter_instancy_2/backend/gamification/gamification_controller.dart';
import 'package:flutter_instancy_2/backend/gamification/gamification_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/component_configurations_model.dart';
import 'package:flutter_instancy_2/models/common/pagination/pagination_model.dart';
import 'package:flutter_instancy_2/models/gamification/request_model/update_content_gamification_request_model.dart';
import 'package:flutter_instancy_2/models/my_learning/request_model/my_learning_data_request_model.dart';
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
import 'my_learning_provider.dart';
import 'my_learning_repository.dart';

class MyLearningController {
  late MyLearningProvider _myLearningProvider;
  late MyLearningRepository myLearningRepository;

  MyLearningController({required MyLearningProvider? provider, MyLearningRepository? repository, ApiController? apiController}) {
    _myLearningProvider = provider ?? MyLearningProvider();
    myLearningRepository = repository ?? MyLearningRepository(apiController: apiController ?? ApiController());
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

    //region Make Api Call
    DataResponseModel<MyLearningResponseDTOModel> response = await myLearningRepository.getMyLearningContentsListMain(
      requestModel: myLearningDataRequestModel,
      componentId: componentId,
      componentInstanceId: componentInstanceId,
      isStoreDataInHive: true,
      isFromOffline: false,
    );
    MyPrint.printOnConsole("My Learning Contents Length:${response.data?.CourseList.length ?? 0}", tag: tag);
    //endregion

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole("My Learning Data got in ${endTime.difference(startTime).inMilliseconds} Milliseconds", tag: tag);

    List<CourseDTOModel> contentsList = response.data?.CourseList ?? <CourseDTOModel>[];
    MyPrint.printOnConsole("My Learning Contents Length got in Api:${contentsList.length}", tag: tag);

    //region Set Provider Data After Getting Data From Api
    if (contentsList.length < provider.pageSize.get()) provider.updateMyLearningPaginationData(hasMore: false);
    if (contentsList.isNotEmpty) provider.updateMyLearningPaginationData(pageIndex: paginationModel.pageIndex + 1);
    provider.addMyLearningContentsInList(myLearningContentModels: contentsList, isClear: false, isNotify: false);
    provider.updateMyLearningPaginationData(isFirstTimeLoading: false, isNotify: false);
    provider.updateMyLearningPaginationData(isLoading: false, isNotify: true);
    //endregion

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

    //region Make Api Call
    DataResponseModel<MyLearningResponseDTOModel> response = await myLearningRepository.getMyLearningContentsListMain(
      requestModel: myLearningDataRequestModel,
      componentId: componentId,
      componentInstanceId: componentInstanceId,
      isStoreDataInHive: true,
      isFromOffline: false,
    );
    MyPrint.printOnConsole("My Learning Archived Contents Length:${response.data?.CourseList.length ?? 0}", tag: tag);
    //endregion

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole("My Learning Archived Data got in ${endTime.difference(startTime).inMilliseconds} Milliseconds", tag: tag);

    List<CourseDTOModel> contentsList = response.data?.CourseList ?? <CourseDTOModel>[];
    MyPrint.printOnConsole("My Learning Archived Contents Length got in Api:${contentsList.length}", tag: tag);

    //region Set Provider Data After Getting Data From Api
    if (contentsList.length < provider.pageSize.get()) provider.updateMyLearningArchivedPaginationData(hasMore: false);
    if (contentsList.isNotEmpty) provider.updateMyLearningArchivedPaginationData(pageIndex: paginationModel.pageIndex + 1);
    provider.addMyLearningArchivedContentsInList(myLearningContentModels: contentsList, isClear: false, isNotify: false);
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

  Future<bool> setComplete({required String contentId, required int scoId, required int contentTypeId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MyLearningController().setComplete() called with contentId:'$contentId', scoId:'$scoId', contentTypeId:'$contentTypeId'", tag: tag);

    DataResponseModel response = await myLearningRepository.setCompleteStatus(
      contentID: contentId,
      scoId: scoId,
    );
    MyPrint.printOnConsole("Set Complete Response Data:$response", tag: tag);

    bool isSuccess = response.statusCode == 200;

    if (isSuccess) {
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
}
