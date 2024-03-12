import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/api/api_url_configuration_provider.dart';
import 'package:flutter_instancy_2/backend/Catalog/catalog_provider.dart';
import 'package:flutter_instancy_2/backend/Catalog/catalog_repository.dart';
import 'package:flutter_instancy_2/backend/gamification/gamification_controller.dart';
import 'package:flutter_instancy_2/backend/gamification/gamification_provider.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/catalog/catalogCategoriesForBrowseModel.dart';
import 'package:flutter_instancy_2/models/catalog/request_model/add_associated_content_to_my_learning_request_model.dart';
import 'package:flutter_instancy_2/models/catalog/request_model/add_expired_event_to_my_learning_request_model.dart';
import 'package:flutter_instancy_2/models/catalog/request_model/catalog_request_model.dart';
import 'package:flutter_instancy_2/models/catalog/response_model/add_associated_content_to_mylearning_response_model.dart';
import 'package:flutter_instancy_2/models/catalog/response_model/add_expired_event_to_mylearning_response_model.dart';
import 'package:flutter_instancy_2/models/catalog/response_model/associated_content_response_model.dart';
import 'package:flutter_instancy_2/models/catalog/response_model/enroll_waiting_list_event_response_model.dart';
import 'package:flutter_instancy_2/models/catalog/response_model/prerequisiteDetailsResponseModel.dart';
import 'package:flutter_instancy_2/models/dto/response_dto_model.dart';
import 'package:flutter_instancy_2/models/filter/data_model/filter_duration_value_model.dart';
import 'package:flutter_instancy_2/models/filter/data_model/learning_provider_model.dart';
import 'package:flutter_instancy_2/models/gamification/request_model/update_content_gamification_request_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../../api/api_controller.dart';
import '../../configs/app_configurations.dart';
import '../../models/app_configuration_models/data_models/component_configurations_model.dart';
import '../../models/app_configuration_models/data_models/local_str.dart';
import '../../models/catalog/request_model/add_content_to_my_learning_request_model.dart';
import '../../models/catalog/request_model/enroll_waiting_list_event_request_model.dart';
import '../../models/catalog/response_model/catalog_dto_response_model.dart';
import '../../models/catalog/response_model/removeFromWishlistModel.dart';
import '../../models/catalog/response_model/user_coming_soon_response.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/pagination/pagination_model.dart';
import '../../models/course/data_model/CourseDTOModel.dart';
import '../../models/filter/data_model/enabled_content_filter_by_type_model.dart';
import '../../models/in_app_purchase/request_model/ecommerce_process_payment_request_model.dart';
import '../../models/waitlist/response_model/add_to_waitList_response_model.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';
import '../../views/catalog/components/confirm_remove_content_by_user_dialog.dart';
import '../../views/catalog/screens/prerequisite_dialogue_view.dart';
import '../configurations/app_configuration_operations.dart';
import '../filter/filter_provider.dart';
import '../in_app_purchase/in_app_purchase_controller.dart';

class CatalogController {
  late CatalogRepository catalogRepository;
  late CatalogProvider catalogProvider;

  static bool isAddedContentToMyLearning = false;

  CatalogController({
    CatalogRepository? repository,
    ApiController? apiController,
    required CatalogProvider? provider,
  }) {
    catalogRepository = repository ?? CatalogRepository(apiController: apiController ?? ApiController());
    catalogProvider = provider ?? CatalogProvider();
  }

  void initializeCatalogConfigurationsFromComponentConfigurationsModel({required ComponentConfigurationsModel componentConfigurationsModel}) {
    //Initializations
    catalogProvider.pageSize.set(value: componentConfigurationsModel.itemsPerPage, isNotify: false);
    initializeFilterData(model: componentConfigurationsModel);
  }

  void initializeFilterData({required ComponentConfigurationsModel model}) {
    catalogProvider.filterProvider.defaultSort.set(value: model.ddlSortList, isNotify: false);
    catalogProvider.filterProvider.selectedSort.set(value: model.ddlSortList, isNotify: false);
    catalogProvider.filterEnabled.set(value: AppConfigurations.getFilterEnabledFromShowIndexes(showIndexes: model.showIndexes), isNotify: false);
    catalogProvider.sortEnabled.set(value: AppConfigurations.getSortEnabledFromContentFilterBy(contentFilterBy: model.contentFilterBy), isNotify: false);
  }

  Future<void> getCatalogCategoriesFromBrowseModel({
    bool isRefresh = true,
    bool isGetFromCache = false,
    bool isNotify = true,
    required int componentId,
    required int componentInstanceId,
  }) async {
    List<CatalogCategoriesForBrowseModel> catalogCategoriesList = [];
    CatalogProvider provider = catalogProvider;
    DataResponseModel<List<CatalogCategoriesForBrowseModel>> response = await catalogRepository.getCatalogCategoriesForBrowseModel(
      componentId: componentId,
      componentInstanceId: componentInstanceId,
      isStoreDataInHive: true,
    );
    catalogCategoriesList = response.data ?? [];
    MyPrint.printOnConsole("catalogCategoriesList length:${catalogCategoriesList.length}");

    Map<int, CatalogCategoriesForBrowseModel> map = <int, CatalogCategoriesForBrowseModel>{};
    for (CatalogCategoriesForBrowseModel element in catalogCategoriesList) {
      map[element.categoryID] = element;
    }

    map.forEach((int categoryId, CatalogCategoriesForBrowseModel categoryTreeModel) {
      if (categoryTreeModel.parentID != 0) {
        map[categoryTreeModel.parentID]?.children.add(categoryTreeModel);
        catalogCategoriesList.remove(categoryTreeModel);
      }
    });

    MyPrint.printOnConsole("Final catalogCategoriesList length:${catalogCategoriesList.length}");
    provider.catalogCategoriesForBrowserList.setList(list: catalogCategoriesList, isClear: true, isNotify: true);
  }

  Future<List<CourseDTOModel>> getCatalogContentsListFromApi({
    bool isRefresh = true,
    bool isGetFromCache = false,
    bool isNotify = true,
    bool isPinnedContent = false,
    required int componentId,
    required int componentInstanceId,
    int? HomeComponentId,
    String? clientUrl,
    int? userId,
    int? siteId,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
      "CatalogController().getCatalogContentsListFromApi() called with isRefresh:$isRefresh, isGetFromCache:$isGetFromCache, "
      "isNotify:$isNotify, componentId:$componentId, componentInstanceId:$componentInstanceId",
      tag: tag,
    );

    CatalogProvider provider = catalogProvider;
    PaginationModel paginationModel = provider.catalogContentPaginationModel.get();

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = catalogRepository.apiController.apiDataProvider;

    //region If Not refresh and Data available, return Cached Data
    if (!isRefresh && isGetFromCache && provider.catalogContentLength > 0) {
      MyPrint.printOnConsole("Returning Cached Data", tag: tag);
      return provider.catalogCategoryContent.getList(isNewInstance: true);
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
        notify: isNotify,
      );
      provider.catalogCategoryContent.setList(list: <CourseDTOModel>[], isClear: true, isNotify: isNotify);
    }
    //endregion

    //region If Not Has More Data, then return
    if (!paginationModel.hasMore) {
      MyPrint.printOnConsole('No More Catalog Contents', tag: tag);
      return provider.catalogCategoryContent.getList(isNewInstance: true);
    }
    //endregion

    //region If Data already Loading, then return
    if (paginationModel.isLoading) return provider.catalogCategoryContent.getList(isNewInstance: true);
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
    CatalogRequestModel catalogRequestModel = getCatalogContentDataRequestModelFromProviderData(
      provider: provider,
      paginationModel: provider.catalogContentPaginationModel.get(),
      componentId: componentId,
      componentInstanceId: componentInstanceId,
      apiUrlConfigurationProvider: apiUrlConfigurationProvider,
      isWishList: false,
      HomecomponentID: HomeComponentId,
      isPinnedContent: isPinnedContent,
      userId: userId,
      siteId: siteId,
    );
    //endregion

    //region Make Api Call
    DataResponseModel<CatalogResponseDTOModel> response = await catalogRepository.getCatalogContentList(
      requestModel: catalogRequestModel,
      componentId: componentId,
      componentInstanceId: componentInstanceId,
      isStoreDataInHive: true,
      isFromOffline: false,
      clientUrl: clientUrl,
      siteId: siteId,
      userId: userId,
    );
    MyPrint.printOnConsole("Catalog Contents Length:${response.data?.CourseList.length ?? 0}", tag: tag);
    //endregion

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole("Catalog Data got in ${endTime.difference(startTime).inMilliseconds} Milliseconds", tag: tag);

    List<CourseDTOModel> contentsList = response.data?.CourseList ?? <CourseDTOModel>[];
    MyPrint.printOnConsole("Catalog Contents Length got in Api:${contentsList.length}", tag: tag);

    //region Set Provider Data After Getting Data From Api
    PaginationModel.updatePaginationData(
      paginationModel: paginationModel,
      isFirstTimeLoading: false,
      pageIndex: paginationModel.pageIndex + 1,
      hasMore: contentsList.length == provider.pageSize.get(),
      isLoading: false,
      notifier: provider.notify,
      notify: isNotify,
    );
    provider.catalogCategoryContent.setList(list: contentsList, isClear: false, isNotify: true);
    //endregion

    return provider.catalogCategoryContent.getList(isNewInstance: true);
  }

  Future<List<CourseDTOModel>> getWishListContentsListFromApi({
    bool isRefresh = true,
    bool isGetFromCache = false,
    bool isNotify = true,
    bool isPinnedContent = false,
    required int componentId,
    required int componentInstanceId,
    int? HomeComponentId,
    String? clientUrl,
    int? userId,
    int? siteId,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
        "CatalogController().getWishListContentsListFromApi() called with isRefresh:$isRefresh, isGetFromCache:$isGetFromCache, "
        "isNotify:$isNotify, componentId:$componentId, componentInstanceId:$componentInstanceId",
        tag: tag);

    CatalogProvider provider = catalogProvider;
    PaginationModel paginationModel = provider.wishlistContentsPaginationModel.get();

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = catalogRepository.apiController.apiDataProvider;

    //region If Not refresh and Data available, return Cached Data
    if (!isRefresh && isGetFromCache && provider.wishlistContentsLength > 0) {
      MyPrint.printOnConsole("Returning Cached Data", tag: tag);
      return provider.wishlistContents.getList(isNewInstance: true);
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
        notify: isNotify,
      );
      provider.wishlistContents.setList(list: <CourseDTOModel>[], isClear: true, isNotify: isNotify);
    }
    //endregion

    //region If Not Has More Data, then return
    if (!paginationModel.hasMore) {
      MyPrint.printOnConsole('No More My Learning Contents', tag: tag);
      return provider.wishlistContents.getList(isNewInstance: true);
    }
    //endregion

    //region If Data already Loading, then return
    if (paginationModel.isLoading) return provider.wishlistContents.getList(isNewInstance: true);
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
    CatalogRequestModel catalogRequestModel = getCatalogContentDataRequestModelFromProviderData(
      provider: provider,
      paginationModel: provider.wishlistContentsPaginationModel.get(),
      componentId: componentId,
      componentInstanceId: componentInstanceId,
      apiUrlConfigurationProvider: apiUrlConfigurationProvider,
      isWishList: true,
      HomecomponentID: HomeComponentId,
      isPinnedContent: isPinnedContent,
      siteId: siteId,
      userId: userId,
    );
    //endregion

    //region Make Api Call
    DataResponseModel<CatalogResponseDTOModel> response = await catalogRepository.getCatalogContentList(
        requestModel: catalogRequestModel,
        componentId: componentId,
        componentInstanceId: componentInstanceId,
        isStoreDataInHive: true,
        isFromOffline: false,
        clientUrl: clientUrl,
        siteId: siteId,
        userId: userId);
    MyPrint.printOnConsole("Catalog Contents Length:${response.data?.CourseList.length ?? 0}", tag: tag);
    //endregion

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole("Catalog Data got in ${endTime.difference(startTime).inMilliseconds} Milliseconds", tag: tag);

    List<CourseDTOModel> contentsList = response.data?.CourseList ?? <CourseDTOModel>[];
    MyPrint.printOnConsole("Catalog Contents Length got in Api:${contentsList.length}", tag: tag);

    //region Set Provider Data After Getting Data From Api
    provider.wishlistContents.setList(list: contentsList, isClear: false, isNotify: false);
    provider.maxWishlistContentsCount.set(value: response.data?.CourseCount ?? 0, isNotify: false);
    PaginationModel.updatePaginationData(
      paginationModel: paginationModel,
      isFirstTimeLoading: false,
      pageIndex: paginationModel.pageIndex + 1,
      hasMore: provider.wishlistContentsLength < provider.maxWishlistContentsCount.get(),
      isLoading: false,
      notifier: provider.notify,
      notify: true,
    );
    //endregion

    return provider.wishlistContents.getList(
      isNewInstance: true,
    );
  }

  CatalogRequestModel getCatalogContentDataRequestModelFromProviderData(
      {required CatalogProvider provider,
      required PaginationModel paginationModel,
      required int componentId,
      required int componentInstanceId,
      required ApiUrlConfigurationProvider apiUrlConfigurationProvider,
      required bool isWishList,
      required bool isPinnedContent,
      int? HomecomponentID,
      int? userId,
      int? siteId}) {
    FilterProvider filterProvider = catalogProvider.filterProvider;
    EnabledContentFilterByTypeModel? enabledContentFilterByTypeModel = !isWishList ? filterProvider.getEnabledContentFilterByTypeModel(isNewInstance: false) : null;

    String filtercredits = "";
    if (enabledContentFilterByTypeModel?.creditpoints ?? false) {
      FilterDurationValueModel? model = filterProvider.selectedFilterCredit.get();
      if (model != null) filtercredits = "${model.Minvalue},${model.Maxvalue}";
    }
    MyPrint.printOnConsole("HomeComponentIDDDDDDDDD: $HomecomponentID");
    List<LearningProviderModel> learningProviderList = filterProvider.selectedLearningProviders.getList();
    String learningPortalsIds = "";
    if (learningProviderList.checkNotEmpty) {
      learningPortalsIds = learningProviderList.map((e) => e.SiteID).toList().join(",");
      MyPrint.printOnConsole("learningPortalsIds : $learningPortalsIds");
    }

    return CatalogRequestModel(
      learningprotals: learningPortalsIds,
      iswishlistcontent: isWishList ? 1 : 0,
      componentID: ParsingHelper.parseStringMethod(componentId),
      componentInsID: ParsingHelper.parseStringMethod(componentInstanceId),
      searchText: isWishList ? "" : provider.catalogContentSearchString.get(),
      // userID: "363",
      userID: userId?.toString() ?? ParsingHelper.parseStringMethod(apiUrlConfigurationProvider.getCurrentUserId()),
      siteID: siteId?.toString() ?? ParsingHelper.parseStringMethod(apiUrlConfigurationProvider.getCurrentSiteId()),
      orgUnitID: ParsingHelper.parseStringMethod(apiUrlConfigurationProvider.getCurrentSiteId()),
      locale: apiUrlConfigurationProvider.getLocale().isNotEmpty ? apiUrlConfigurationProvider.getLocale() : "en-us",
      pageIndex: paginationModel.pageIndex,
      // learningprotals: filterProvider.selectedLearningProviders.getList(),
      // pageSize: 500,
      pageSize: provider.pageSize.get(),
      contentID: "",
      keywords: "",
      sortBy: HomecomponentID != null
          ? "Publisheddate desc"
          : isWishList
          ? filterProvider.defaultSort.get()
          : filterProvider.selectedSort.get(),
      categories: (enabledContentFilterByTypeModel?.categories ?? false)
          ? AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
        list: filterProvider.selectedCategories.getList().map((e) => e.categoryId).toList(),
      )
          : "",
      objecttypes: (enabledContentFilterByTypeModel?.objecttypeid ?? false)
          ? AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
        list: filterProvider.selectedContentTypes.getList().map((e) => e.categoryId).toList(),
      )
          : "",
      skillcats: (enabledContentFilterByTypeModel?.skills ?? false)
          ? AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
        list: filterProvider.selectedSkills.getList().map((e) => e.categoryId).toList(),
      )
          : "",
      jobroles: (enabledContentFilterByTypeModel?.jobroles ?? false)
          ? AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
        list: filterProvider.selectedJobRoles.getList().map((e) => e.categoryId).toList(),
      )
          : "",
      solutions: (enabledContentFilterByTypeModel?.solutions ?? false)
          ? AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
        list: filterProvider.selectedSolutions.getList().map((e) => e.categoryId).toList(),
      )
          : "",
      ratings: (enabledContentFilterByTypeModel?.rating ?? false) ? ParsingHelper.parseStringMethod(filterProvider.selectedRating.get()) : "",
      pricerange: (enabledContentFilterByTypeModel?.ecommerceprice ?? false) && filterProvider.minPrice.get() != null && filterProvider.maxPrice.get() != null
          ? "${filterProvider.minPrice.get()},${filterProvider.maxPrice.get()}"
          : "",
      instructors: (enabledContentFilterByTypeModel?.instructor ?? false)
          ? AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
        list: filterProvider.selectedInstructor.getList().map((e) => e.UserID).toList(),
      )
          : "",
      filtercredits: filtercredits,
      HomecomponentID: HomecomponentID,
      PinnedContent: isPinnedContent,
    );
  }

  Future<bool> addContentToWishlist({
    required String contentId,
    required int componentId,
    required int componentInstanceId,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CatalogController().addContentToWishlist() called with contentId:'$contentId'", tag: tag);

    DataResponseModel<String> dataResponseModel = await catalogRepository.addToWishlist(
      componentId: componentId,
      contentId: contentId,
      componentInstanceId: componentInstanceId,
    );

    MyPrint.printOnConsole("addToWishlist response:$dataResponseModel", tag: tag);

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CatalogController().addContentToWishlist() because addToWishlist had some error", tag: tag);
      return false;
    }

    return dataResponseModel.data == "1";
  }

  Future<AddToWaitListResponseModel> addContentToWaitList({
    required String contentId,
    required int componentId,
    required int componentInstanceId,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CatalogController().addToWaitList() called with contentId:'$contentId'", tag: tag);

    DataResponseModel<AddToWaitListResponseModel> dataResponseModel = await catalogRepository.addToWaitList(
      componentId: componentId,
      contentId: contentId,
      componentInstanceId: componentInstanceId,
    );

    MyPrint.printOnConsole("addToWaitList response:$dataResponseModel", tag: tag);

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CatalogController().addToWaitList() because addToWaitList had some error", tag: tag);
      return AddToWaitListResponseModel();
    }

    return dataResponseModel.data ?? AddToWaitListResponseModel();
  }

  Future<bool> addContentToMyLearning({
    required AddContentToMyLearningRequestModel requestModel,
    required BuildContext context,
    bool hasPrerequisites = false,
    bool isShowToast = false,
    bool isWaitForOtherProcesses = true,
    Function? onPrerequisiteDialogShowStarted,
    Function? onPrerequisiteDialogShowEnd,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
        "CatalogController().addContentToMyLearning() called with requestModel:$requestModel, context:$context, "
        "isShowToast:$isShowToast",
        tag: tag);

    bool isSuccess = false;

    if (hasPrerequisites) {
      try {
        PrerequisiteDetailResponseModel? preRequisiteDetailResponseModel = await getPreRequisiteDetails(
          contentId: requestModel.multiInstanceParentId.isNotEmpty ? requestModel.multiInstanceParentId : requestModel.SelectedContent,
          componentId: requestModel.ComponentID,
          componentInstanceId: requestModel.ComponentInsID,
        );
        if (preRequisiteDetailResponseModel == null) {
          return isSuccess;
        }

        if (preRequisiteDetailResponseModel.isShowPopUp) {
          if (context.mounted) {
            // m
            if (onPrerequisiteDialogShowStarted != null) onPrerequisiteDialogShowStarted();
            dynamic value = await showPrerequisiteDialogue(
              context: context,
              prerequisiteDetailResponseModel: preRequisiteDetailResponseModel,
              contentId: requestModel.SelectedContent,
              componentId: requestModel.ComponentID,
              componentInstanceId: requestModel.ComponentInsID,
            );
            if (onPrerequisiteDialogShowEnd != null) onPrerequisiteDialogShowEnd();

            if (value == true) {
              isSuccess = true;
            }
          }
          return isSuccess;
        }
      } catch (e, s) {
        MyPrint.printOnConsole("Error in Handling Prerequisite:$e", tag: tag);
        MyPrint.printOnConsole(s, tag: tag);
        return isSuccess;
      }
    }

    try {
      if (isShowToast && context.mounted) {
        MyToast.greyMsg(context: context, msg: "Process initiated. Please be patience while we add the content to your My Learning section.", durationInSeconds: 4);
      }

      DataResponseModel<ResponseDTOModel> dataResponseModel = await catalogRepository.addContentToMyLearning(
        requestModel: requestModel,
      );

      MyPrint.printOnConsole("addContentToMyLearning response:$dataResponseModel", tag: tag);

      if (dataResponseModel.appErrorModel != null) {
        MyPrint.printOnConsole("Returning from CatalogController().addContentToMyLearning() because addContentToMyLearning had some error", tag: tag);

        if (isShowToast && context.mounted) {
          MyToast.showError(context: context, msg: dataResponseModel.appErrorModel!.message);
        }
        return false;
      }

      if (dataResponseModel.data == null) {
        MyPrint.printOnConsole("Returning from CatalogController().addContentToMyLearning() because addContentToMyLearning returned null", tag: tag);

        if (isShowToast && context.mounted) {
          MyToast.showError(context: context, msg: dataResponseModel.appErrorModel!.message);
        }
        return false;
      }

      ResponseDTOModel responseDTOModel = dataResponseModel.data!;

      isSuccess = responseDTOModel.IsSuccess;
      MyPrint.printOnConsole("isSuccess:$isSuccess", tag: tag);

      if (isSuccess) {
        if (requestModel.courseDTOModel != null) {
          if (responseDTOModel.CourseObject != null) {
            requestModel.courseDTOModel!.updateFromMap(responseDTOModel.CourseObject!.toMap());
          } else if (responseDTOModel.DetailsObject != null) {
            requestModel.courseDTOModel!.updateFromMap(responseDTOModel.DetailsObject!.toMap());
          }
        }

        CatalogController.isAddedContentToMyLearning = true;

        List<Future> futures = <Future>[
          removeContentFromWishlist(
            contentId: requestModel.SelectedContent,
            componentId: requestModel.ComponentID,
            componentInstanceId: requestModel.ComponentInsID,
          ).then((RemoveFromWishlistResponseModel removeFromWishlistResponseModel) {
            MyPrint.printOnConsole("removeFromWishlistResponseModel:$removeFromWishlistResponseModel", tag: tag);
          }).catchError((e, s) {
            MyPrint.printOnConsole("Error in removeFromWishlist:$e", tag: tag);
            MyPrint.printOnConsole(s, tag: tag);
          }),
        ];

        if (isWaitForOtherProcesses) {
          await Future.wait(futures);
        } else {
          Future.wait(futures);
        }

        await GamificationController(provider: context.read<GamificationProvider>()).UpdateContentGamification(
          requestModel: UpdateContentGamificationRequestModel(
            contentId: requestModel.SelectedContent,
            scoId: requestModel.scoId,
            objecttypeId: requestModel.objecttypeId,
            GameAction: GamificationActionType.Enrolled,
          ),
        );
      }

      if (isShowToast && context.mounted) {
        if (isSuccess) {
          int index = responseDTOModel.Message.indexOf("~~");
          MyToast.showSuccess(context: context, msg: index > -1 ? responseDTOModel.Message.substring(0, index) : responseDTOModel.Message, durationInSeconds: 5);
        } else {
          MyToast.showError(context: context, msg: responseDTOModel.Message);
        }
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in Adding Content To MyLearning:$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    return isSuccess;
  }

  Future<bool> buyCourse({
    required BuildContext context,
    required CourseDTOModel model,
    required int ComponentID,
    required int ComponentInsID,
    bool isWaitForPostPurchaseProcesses = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CatalogController().buyCourse() called for Content:'${model.ContentID}'", tag: tag);

    String productId = switch (defaultTargetPlatform) {
      // TargetPlatform.android => "1_dollar_product",
      // TargetPlatform.android => "product_1",
      // TargetPlatform.android => "com.instancy.instancylearningmarket_assessment25dollar",
      // TargetPlatform.android => "com.instancy.instancylearningmarket_e_commerce_event_multi_05dec2023_1600",
      // TargetPlatform.iOS => "com.instancy.instancyLearningMarket_product1",
      TargetPlatform.android => model.GoogleProductId,
      TargetPlatform.iOS => model.ItunesProductId,
      _ => "",
    };
    MyPrint.printOnConsole("Product Id:'$productId'", tag: tag);

    if (productId.isEmpty) {
      MyPrint.printOnConsole("Product Id not Available", tag: tag);
      if (context.mounted) MyToast.showError(context: context, msg: "Store Details Not Available");
      return false;
    }

    Map<String, ProductDetails> map = await InAppPurchaseController().getProductDetails([productId]);
    MyPrint.printOnConsole("Product Details Map:$map", tag: tag);

    ProductDetails? productDetails = map[productId];

    if (productDetails == null) {
      MyPrint.printOnConsole("Product Details Not Available", tag: tag);
      if (context.mounted) MyToast.showError(context: context, msg: "Product Details Not Available");
      return false;
    }

    PurchaseDetails? purchaseDetails = await InAppPurchaseController().launchInAppPurchase(
      productDetails,
      isShowConfirmationDialog: true,
      context: context,
      isConsumable: true,
    );
    MyPrint.printOnConsole("purchaseDetails.status:${purchaseDetails?.status}", tag: tag);

    if (purchaseDetails == null) {
      MyPrint.printOnConsole("Purchase Failed", tag: tag);
      if (context.mounted) MyToast.showError(context: context, msg: "Purchase Failed");
      return false;
    } else if (purchaseDetails.status == PurchaseStatus.canceled) {
      MyPrint.printOnConsole("Purchase Cancelled", tag: tag);
      if (context.mounted) MyToast.greyMsg(context: context, msg: "Purchase Cancelled");
      return false;
    } else if (purchaseDetails.status == PurchaseStatus.pending) {
      MyPrint.printOnConsole("Purchase Pending", tag: tag);
      if (context.mounted) MyToast.greyMsg(context: context, msg: "Purchase Pending");
      return false;
    } else if (purchaseDetails.status == PurchaseStatus.error) {
      IAPError? error = purchaseDetails.error;
      MyPrint.printOnConsole("Error in Store Purchase:$error", tag: tag);

      if (error != null) {
        if (context.mounted) MyToast.showError(context: context, msg: "Error in Buying Content : '${error.message}'");
      } else {
        if (context.mounted) MyToast.showError(context: context, msg: "Error in Buying Content");
      }

      return false;
    } else if (purchaseDetails.status == PurchaseStatus.restored) {
      MyPrint.printOnConsole("Purchase Restored", tag: tag);

      return false;
    }

    MyPrint.printOnConsole("Purchase Successful", tag: tag);

    bool isPurchaseSaved = await InAppPurchaseController().purchaseProduct(
      requestModel: EcommerceProcessPaymentRequestModel(
        ContentID: model.ContentID,
        token: purchaseDetails.purchaseID ?? "",
        CurrencySign: model.Currency,
        TotalPrice: ParsingHelper.parseDoubleMethod(model.SalePrice),
      ),
    );

    if (isPurchaseSaved) {
      CatalogController.isAddedContentToMyLearning = true;

      List<Future> futures = <Future>[
        removeContentFromWishlist(
          contentId: model.ContentID,
          componentId: ComponentID,
          componentInstanceId: ComponentInsID,
        ).then((RemoveFromWishlistResponseModel removeFromWishlistResponseModel) {
          MyPrint.printOnConsole("removeFromWishlistResponseModel:$removeFromWishlistResponseModel", tag: tag);
        }).catchError((e, s) {
          MyPrint.printOnConsole("Error in removeFromWishlist:$e", tag: tag);
          MyPrint.printOnConsole(s, tag: tag);
        }),
      ];

      if (isWaitForPostPurchaseProcesses) {
        await Future.wait(futures);
      } else {
        Future.wait(futures);
      }

      GamificationController(provider: context.read<GamificationProvider>()).UpdateContentGamification(
        requestModel: UpdateContentGamificationRequestModel(
          contentId: model.ContentID,
          scoId: model.ScoID,
          objecttypeId: model.ContentTypeId,
          GameAction: GamificationActionType.Purchased,
        ),
      );
    }

    return isPurchaseSaved;
  }

  Future<bool> addAssociatedContentToMyLearning({
    required AddAssociatedContentToMyLearningRequestModel requestModel,
    required BuildContext context,
    bool isShowToast = false,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
        "CatalogController().addAssociatedContentToMyLearning() called with requestModel:$requestModel, context:$context, "
        "isShowToast:$isShowToast",
        tag: tag);

    bool isSuccess = false;

    try {
      if (isShowToast && context.mounted) {
        MyToast.greyMsg(context: context, msg: "Process initiated. Please be patience while we add the content to your My Learning section.", durationInSeconds: 4);
      }

      DataResponseModel<AddAssociatedContentToMyLearningResponseModel> dataResponseModel = await catalogRepository.addAssociatedContentToMyLearning(
        requestModel: requestModel,
      );

      MyPrint.printOnConsole("addContentToMyLearning response:$dataResponseModel", tag: tag);

      if (dataResponseModel.appErrorModel != null) {
        MyPrint.printOnConsole("Returning from CatalogController().addAssociatedContentToMyLearning() because addAssociatedContentToMyLearning had some error", tag: tag);

        if (isShowToast && context.mounted) {
          MyToast.showError(context: context, msg: dataResponseModel.appErrorModel!.message);
        }
        return false;
      }

      if (dataResponseModel.data == null) {
        MyPrint.printOnConsole("Returning from CatalogController().addAssociatedContentToMyLearning() because addAssociatedContentToMyLearning returned null", tag: tag);

        if (isShowToast && context.mounted) {
          MyToast.showError(context: context, msg: dataResponseModel.appErrorModel!.message);
        }
        return false;
      }

      AddAssociatedContentToMyLearningResponseModel responseModel = dataResponseModel.data!;

      isSuccess = responseModel.result;
      MyPrint.printOnConsole("isSuccess:$isSuccess", tag: tag);

      if (isSuccess) {
        GamificationController(provider: context.read<GamificationProvider>()).UpdateContentGamification(
          requestModel: UpdateContentGamificationRequestModel(
            contentId: requestModel.SelectedContent,
            scoId: requestModel.scoId,
            objecttypeId: requestModel.objecttypeId,
            GameAction: GamificationActionType.Enrolled,
          ),
        );
      }

      if (isShowToast && context.mounted) {
        if (!isSuccess) {
          MyToast.showError(context: context, msg: responseModel.Message);
        }
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in Adding Associated Content To MyLearning:$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    return isSuccess;
  }

  Future<bool> enrollWaitListEvent({
    required EnrollWaitingListEventRequestModel requestModel,
    required BuildContext context,
    bool isShowToast = false,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
      "CatalogController().enrollWaitListEvent() called with requestModel:$requestModel, context:$context, "
      "isShowToast:$isShowToast",
      tag: tag,
    );

    bool isSuccess = false;

    try {
      if (isShowToast && context.mounted) {
        MyToast.greyMsg(context: context, msg: "Process initiated. Please be patience while we add the content to your My Learning section.", durationInSeconds: 4);
      }

      DataResponseModel<EnrollWaitingListEventResponseModel> dataResponseModel = await catalogRepository.enrollWaitListEvent(
        requestModel: requestModel,
      );

      MyPrint.printOnConsole("addContentToMyLearning response:$dataResponseModel", tag: tag);

      if (dataResponseModel.appErrorModel != null) {
        MyPrint.printOnConsole("Returning from CatalogController().enrollWaitListEvent() because enrollWaitListEvent had some error", tag: tag);

        if (isShowToast && context.mounted) {
          MyToast.showError(context: context, msg: dataResponseModel.appErrorModel!.message);
        }
        return false;
      }

      if (dataResponseModel.data == null) {
        MyPrint.printOnConsole("Returning from CatalogController().enrollWaitListEvent() because enrollWaitListEvent returned null", tag: tag);

        if (isShowToast && context.mounted) {
          MyToast.showError(context: context, msg: dataResponseModel.appErrorModel!.message);
        }
        return false;
      }

      EnrollWaitingListEventResponseModel responseModel = dataResponseModel.data!;

      isSuccess = responseModel.IsSuccess;
      MyPrint.printOnConsole("isSuccess:$isSuccess", tag: tag);

      if (isSuccess) {
        GamificationController(provider: context.read<GamificationProvider>()).UpdateContentGamification(
          requestModel: UpdateContentGamificationRequestModel(
            contentId: requestModel.WLContentID,
            scoId: 0,
            objecttypeId: InstancyObjectTypes.events,
            GameAction: GamificationActionType.Enrolled,
          ),
        );
      }

      if (isShowToast && context.mounted) {
        if (!isSuccess) {
          MyToast.showError(context: context, msg: responseModel.Message);
        }
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in Enrolling Waitinglist Event:$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    return isSuccess;
  }

  Future<bool> addExpiredEventToMyLearning({
    required AddExpiredEventToMyLearningRequestModel requestModel,
    required BuildContext context,
    bool isShowToast = false,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
      "CatalogController().addExpiredEventToMyLearning() called with requestModel:$requestModel, context:$context, "
      "isShowToast:$isShowToast",
      tag: tag,
    );

    bool isSuccess = false;

    try {
      if (isShowToast && context.mounted) {
        MyToast.greyMsg(context: context, msg: "Process initiated. Please be patience while we add the content to your My Learning section.", durationInSeconds: 4);
      }

      DataResponseModel<AddExpiredEventToMyLearningResponseModel> dataResponseModel = await catalogRepository.addExpiredEventToMyLearning(
        requestModel: requestModel,
      );

      MyPrint.printOnConsole("addContentToMyLearning response:$dataResponseModel", tag: tag);

      if (dataResponseModel.appErrorModel != null) {
        MyPrint.printOnConsole("Returning from CatalogController().addExpiredEventToMyLearning() because addExpiredEventToMyLearning had some error", tag: tag);

        if (isShowToast && context.mounted) {
          MyToast.showError(context: context, msg: dataResponseModel.appErrorModel!.message);
        }
        return false;
      }

      if (dataResponseModel.data == null) {
        MyPrint.printOnConsole("Returning from CatalogController().addExpiredEventToMyLearning() because addExpiredEventToMyLearning returned null", tag: tag);

        if (isShowToast && context.mounted) {
          MyToast.showError(context: context, msg: dataResponseModel.appErrorModel!.message);
        }
        return false;
      }

      AddExpiredEventToMyLearningResponseModel responseModel = dataResponseModel.data!;

      isSuccess = responseModel.result;
      MyPrint.printOnConsole("isSuccess:$isSuccess", tag: tag);

      if (isSuccess) {
        GamificationController(provider: context.read<GamificationProvider>()).UpdateContentGamification(
          requestModel: UpdateContentGamificationRequestModel(
            contentId: requestModel.SelectedContent,
            scoId: requestModel.scoId,
            objecttypeId: requestModel.objecttypeId,
            GameAction: GamificationActionType.Enrolled,
          ),
        );
      }

      if (isShowToast && context.mounted) {
        if (!isSuccess) {
          MyToast.showError(context: context, msg: responseModel.Message);
        }
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in Adding Expired Content To MyLearning in CatalogController().addExpiredEventToMyLearning():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    return isSuccess;
  }

  Future showPrerequisiteDialogue({
    required BuildContext context,
    required PrerequisiteDetailResponseModel prerequisiteDetailResponseModel,
    required String contentId,
    required int componentId,
    required int componentInstanceId,
  }) async {
    dynamic value = await showModalBottomSheet(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return PreRequisiteDialogueScreen(
          prerequisiteDetailResponseModel: prerequisiteDetailResponseModel,
          contentId: contentId,
          componentId: componentId,
          componentInsId: componentInstanceId,
        );
      },
    );

    return value;
  }

  Future<PrerequisiteDetailResponseModel?> getPreRequisiteDetails({
    required String contentId,
    required int componentId,
    required int componentInstanceId,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CatalogController().preRequisiteDetails() called for contentId:$contentId, componentId:$componentId, componentInstanceId:$componentInstanceId", tag: tag);

    PrerequisiteDetailResponseModel? prerequisiteDetailResponseModel;
    try {
      DataResponseModel<PrerequisiteDetailResponseModel> response = await catalogRepository.getPreRequisiteDetails(
        componentId: componentId,
        contentId: contentId,
        componentInstanceId: componentInstanceId,
      );
      MyPrint.printOnConsole("CatalogController().preRequisiteDetails() response : ${response.data!.toJson()}", tag: tag);

      if (response.appErrorModel != null) {
        MyPrint.printOnConsole("Error in getting getPreRequisiteDetails response:${response.appErrorModel}");
        return prerequisiteDetailResponseModel;
      }

      if (response.data != null) {
        prerequisiteDetailResponseModel = response.data!;

        Map<String, PreRequisitePathModel> pathMap = <String, PreRequisitePathModel>{};

        for (PreRequisitePathModel pathModel in prerequisiteDetailResponseModel.prerequisteData.table1) {
          pathMap["${pathModel.preRequisiteSequnceID}_${pathModel.preRequisiteSequncePathID}"] = pathModel;
        }

        for (PreRequisiteContentModel contentModel in prerequisiteDetailResponseModel.prerequisteData.table) {
          pathMap["${contentModel.preRequisiteSequnceID}_${contentModel.preRequisiteSequncePathID}"]?.contents.add(contentModel);
        }
      }
    } catch (e, s) {
      MyPrint.printOnConsole("CatalogController().preRequisiteDetails() error : $e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }
    return prerequisiteDetailResponseModel;
  }

  Future<bool> removeContentFromMyLearning({
    required BuildContext context,
    required String contentId,
    LocalStr? localStr,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CatalogController().removeContentFromMyLearning() called with contentId:'$contentId'", tag: tag);

    CatalogRepository repository = catalogRepository;

    bool isRemove = await checkRemoveContentByUserFromDialog(
      context: context,
      localStr: localStr,
    );
    MyPrint.printOnConsole("isRemove:$isRemove", tag: tag);

    if (!isRemove) {
      MyPrint.printOnConsole("Returning from CatalogController().removeContentFromMyLearning() because user has opted to not remove", tag: tag);
      return false;
    }

    DataResponseModel<String> dataResponseModel = await repository.removeContentFromMyLearning(
      contentID: contentId,
    );
    MyPrint.printOnConsole("removeContentFromMyLearning response:$dataResponseModel", tag: tag);

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CatalogController().removeContentFromMyLearning() because removeContentFromMyLearning had some error", tag: tag);
      return false;
    }

    return dataResponseModel.data == 'true';
  }

  Future<bool> checkRemoveContentByUserFromDialog({required BuildContext context, LocalStr? localStr}) async {
    dynamic value = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmRemoveContentByUserDialog(
          localStr: localStr,
        );
      },
    );

    return value == true;
  }

  Future<RemoveFromWishlistResponseModel> removeContentFromWishlist({
    required String contentId,
    required int componentId,
    required int componentInstanceId,
  }) async {
    DataResponseModel<RemoveFromWishlistResponseModel> response = await catalogRepository.removeFromWishlist(
      componentId: componentId,
      contentId: contentId,
      componentInstanceId: componentInstanceId,
    );
    return response.data ?? RemoveFromWishlistResponseModel();
  }

  Future<AssociatedContentResponseModel> getAssociatedContent({
    required String contentId,
    required int componentId,
    required int componentInstanceId,
    required int preRequisiteSequencePathId,
  }) async {
    MyPrint.printOnConsole("getAssociatedContent");

    DataResponseModel<AssociatedContentResponseModel> response = await catalogRepository.getAssociatedContent(
      componentId: componentId,
      contentId: contentId,
      componentInstanceId: componentInstanceId,
      preRequisiteSequencePathId: preRequisiteSequencePathId,
    );
    MyPrint.printOnConsole("return getAssociatedContent");

    MyPrint.printOnConsole("response: ${response.data}");
    AssociatedContentResponseModel associatedContentResponse = AssociatedContentResponseModel.fromJson(response.data!.toJson());
    MyPrint.printOnConsole("getAssociatedContent.associatedContentResponse : ${associatedContentResponse.CourseList.length}");

    return associatedContentResponse;
  }

  Future<UserComingSoonResponse> getComingResponseTable({
    required String contentId,
  }) async {
    MyPrint.printOnConsole("UserComingSoonResponse");

    DataResponseModel<UserComingSoonResponse> response = await catalogRepository.getComingResponse(contentId: contentId);
    MyPrint.printOnConsole("return UserComingSoonResponse");

    MyPrint.printOnConsole("response: ${response.data}");
    UserComingSoonResponse userComingSoonResponse = UserComingSoonResponse.fromJson(response.data!.toJson());
    MyPrint.printOnConsole("getComingResponseTable : ${userComingSoonResponse.table.length}");

    return userComingSoonResponse;
  }

  Future<UserComingSoonResponse> createUpdateUserComingSoonResponse({required String contentId, required String text, required bool isUpdate}) async {
    MyPrint.printOnConsole("UserComingSoonResponse");

    DataResponseModel<UserComingSoonResponse> response = await catalogRepository.createUpdateUserComingSoonResponse(contentId: contentId, text: text, isUpdate: isUpdate);
    MyPrint.printOnConsole("return UserComingSoonResponse");

    MyPrint.printOnConsole("response: ${response.data}");
    UserComingSoonResponse userComingSoonResponse = UserComingSoonResponse.fromJson(response.data!.toJson());
    MyPrint.printOnConsole("getComingResponseTable : ${userComingSoonResponse.table.length}");

    return userComingSoonResponse;
  }

  Future<bool> setComplete({required String contentId, required int scoId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CatalogController().setComplete() called with contentId:'$contentId', scoId:'$scoId'", tag: tag);

    DataResponseModel response = await catalogRepository.setCompleteStatus(
      contentID: contentId,
      scoId: scoId,
    );
    MyPrint.printOnConsole("Set Complete Response Data:$response", tag: tag);

    return response.statusCode == 200;
  }
}
