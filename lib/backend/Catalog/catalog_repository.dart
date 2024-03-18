import 'package:flutter_instancy_2/models/catalog/catalogCategoriesForBrowseModel.dart';
import 'package:flutter_instancy_2/models/catalog/request_model/addToWishlistRequestModel.dart';
import 'package:flutter_instancy_2/models/catalog/request_model/add_associated_content_to_my_learning_request_model.dart';
import 'package:flutter_instancy_2/models/catalog/request_model/catalog_request_model.dart';
import 'package:flutter_instancy_2/models/catalog/response_model/removeFromWishlistModel.dart';
import 'package:flutter_instancy_2/models/catalog/response_model/user_coming_soon_response.dart';
import 'package:flutter_instancy_2/models/waitlist/request_model/waitlist_request_model.dart';
import 'package:flutter_instancy_2/models/waitlist/response_model/add_to_waitList_response_model.dart';

import '../../api/api_call_model.dart';
import '../../api/api_controller.dart';
import '../../api/api_endpoints.dart';
import '../../api/api_url_configuration_provider.dart';
import '../../api/rest_client.dart';
import '../../models/catalog/request_model/add_content_to_my_learning_request_model.dart';
import '../../models/catalog/request_model/add_expired_event_to_my_learning_request_model.dart';
import '../../models/catalog/request_model/enroll_waiting_list_event_request_model.dart';
import '../../models/catalog/request_model/mobile_catalog_objects_data_request_model.dart';
import '../../models/catalog/request_model/user_coming_soon_request_model.dart';
import '../../models/catalog/response_model/add_associated_content_to_mylearning_response_model.dart';
import '../../models/catalog/response_model/add_expired_event_to_mylearning_response_model.dart';
import '../../models/catalog/response_model/associated_content_response_model.dart';
import '../../models/catalog/response_model/catalog_dto_response_model.dart';
import '../../models/catalog/response_model/enroll_waiting_list_event_response_model.dart';
import '../../models/catalog/response_model/mobile_catalog_objects_data_response_model.dart';
import '../../models/catalog/response_model/prerequisiteDetailsResponseModel.dart';
import '../../models/common/app_error_model.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/model_data_parser.dart';
import '../../models/dto/response_dto_model.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';
import '../../utils/parsing_helper.dart';

class CatalogRepository {
  final ApiController apiController;

  const CatalogRepository({required this.apiController});

  Future<DataResponseModel<List<CatalogCategoriesForBrowseModel>>> getCatalogCategoriesForBrowseModel({
    required int componentId,
    required int componentInstanceId,
    bool isFromOffline = false,
    bool isStoreDataInHive = false,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.catalogCategoriesForBrowseModel,
      url: apiEndpoints.apiGetCatalogCategoriesForBrowseModel(
        componentInstanceId: ParsingHelper.parseStringMethod(componentInstanceId),
        siteId: apiUrlConfigurationProvider.getCurrentSiteId(),
        locale: apiUrlConfigurationProvider.getLocale(),
        userId: apiUrlConfigurationProvider.getCurrentUserId(),
      ),
      isGetDataFromHive: isFromOffline,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<List<CatalogCategoriesForBrowseModel>> apiResponseModel = await apiController.callApi<List<CatalogCategoriesForBrowseModel>>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<CatalogResponseDTOModel>> getCatalogContentList(
      {required CatalogRequestModel requestModel,
      required int componentId,
      required int componentInstanceId,
      bool isFromOffline = false,
      bool isStoreDataInHive = false,
      String? clientUrl,
      int? userId,
      int? siteId}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.catalogResponseDTOModel,
      url: apiEndpoints.getCatalogContents(),
      requestBody: MyUtils.encodeJson(requestModel.toJson()),
      isGetDataFromHive: isFromOffline,
      isStoreDataInHive: isStoreDataInHive,
      // userId: userId,
      // siteUrl: clientUrl,
      // siteId: siteId,
    );

    DataResponseModel<CatalogResponseDTOModel> apiResponseModel = await apiController.callApi<CatalogResponseDTOModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<MobileCatalogObjectsDataResponseModel>> getMobileCatalogObjectsData({
    required MobileCatalogObjectsDataRequestModel requestModel,
    required int componentId,
    required int componentInstanceId,
    bool isFromOffline = false,
    bool isStoreDataInHive = false,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.mobileCatalogObjectsDataResponseModel,
      url: apiEndpoints.apiGetMobileCatalogObjectsData(),
      requestBody: MyUtils.encodeJson(requestModel.toJson()),
      isGetDataFromHive: isFromOffline,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<MobileCatalogObjectsDataResponseModel> apiResponseModel = await apiController.callApi<MobileCatalogObjectsDataResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<ResponseDTOModel>> addContentToMyLearning({
    required AddContentToMyLearningRequestModel requestModel,
    bool isFromOffline = false,
    bool isStoreDataInHive = false,
  }) async {
    MyPrint.printOnConsole('CatalogRepository().addContentToMyLearning() called with requestModel:$requestModel');
    if (requestModel.SelectedContent.isEmpty) {
      return DataResponseModel(
        appErrorModel: AppErrorModel(
          message: "Content ID is empty",
        ),
      );
    }

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.UserID = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.SiteID = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.OrgUnitID = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.Locale = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, String>>(
      restCallType: RestCallType.xxxUrlEncodedFormDataRequestCall,
      parsingType: ModelDataParsingType.responseDTOModel,
      url: apiEndpoints.getAddToMyLearning(),
      requestBody: requestModel.toJson(),
      isGetDataFromHive: isFromOffline,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<ResponseDTOModel> apiResponseModel = await apiController.callApi<ResponseDTOModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<AddAssociatedContentToMyLearningResponseModel>> addAssociatedContentToMyLearning({
    required AddAssociatedContentToMyLearningRequestModel requestModel,
    bool isFromOffline = false,
    bool isStoreDataInHive = false,
  }) async {
    MyPrint.printOnConsole('CatalogRepository().addAssociatedContentToMyLearning() called with requestModel:$requestModel');

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.UserID = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.SiteID = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.OrgUnitID = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.Locale = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.addAssociatedContentToMyLearningResponseModel,
      url: apiEndpoints.getAssociatedAddtoMyLearning(),
      requestBody: MyUtils.encodeJson(requestModel.toJson()),
      isGetDataFromHive: isFromOffline,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<AddAssociatedContentToMyLearningResponseModel> apiResponseModel = await apiController.callApi<AddAssociatedContentToMyLearningResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<EnrollWaitingListEventResponseModel>> enrollWaitListEvent({
    required EnrollWaitingListEventRequestModel requestModel,
    bool isFromOffline = false,
    bool isStoreDataInHive = false,
  }) async {
    MyPrint.printOnConsole('CatalogRepository().enrollWaitListEvent() called with requestModel:$requestModel');

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.UserID = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.siteid = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.locale = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.enrollWaitingListEventResponseModel,
      url: apiEndpoints.getEnrollWaitListEvent(),
      requestBody: MyUtils.encodeJson(requestModel.toJson()),
      isGetDataFromHive: isFromOffline,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<EnrollWaitingListEventResponseModel> apiResponseModel = await apiController.callApi<EnrollWaitingListEventResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<AddExpiredEventToMyLearningResponseModel>> addExpiredEventToMyLearning({
    required AddExpiredEventToMyLearningRequestModel requestModel,
    bool isFromOffline = false,
    bool isStoreDataInHive = false,
  }) async {
    MyPrint.printOnConsole('CatalogRepository().addExpiredEventToMyLearning() called with requestModel:$requestModel');

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.UserID = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.SiteID = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.OrgUnitID = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.Locale = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.addExpiredEventToMyLearningResponseModel,
      url: apiEndpoints.getExpiredContentAddToMyLearning(),
      requestBody: MyUtils.encodeJson(requestModel.toJson()),
      isGetDataFromHive: isFromOffline,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<AddExpiredEventToMyLearningResponseModel> apiResponseModel = await apiController.callApi<AddExpiredEventToMyLearningResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> removeContentFromMyLearning({
    required String contentID,
  }) async {
    MyPrint.printOnConsole('CatalogRepository().removeContentFromMyLearning() called with contentID:$contentID');

    if (contentID.isEmpty) {
      return DataResponseModel(
        appErrorModel: AppErrorModel(
          message: "Content ID is empty",
        ),
      );
    }

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.getRemoveFromMyLearning(),
      queryParameters: <String, String>{
        'ContentID': contentID.toString(),
        'UserID': apiUrlConfigurationProvider.getCurrentUserId().toString(),
        'SiteID': apiUrlConfigurationProvider.getCurrentSiteId().toString(),
      },
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> addToWishlist({
    required String contentId,
    required int componentId,
    required int componentInstanceId,
    bool isFromOffline = false,
    bool isStoreDataInHive = false,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl} 2023-03-02 20:39:53");
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
    AddToWishlistRequestModel addToWishlistRequestModel = AddToWishlistRequestModel(
        componentInstanceID: componentInstanceId, addedDate: DateTime.now().toString(), componentID: "$componentId", contentID: contentId, userID: "${apiUrlConfigurationProvider.getCurrentUserId()}");

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.string,
      requestBody: MyUtils.encodeJson(addToWishlistRequestModel.toMap()),
      url: apiEndpoints.getAddToWishlist(),
      isGetDataFromHive: isFromOffline,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<AddToWaitListResponseModel>> addToWaitList({
    required String contentId,
    required int componentId,
    required int componentInstanceId,
    bool isFromOffline = false,
    bool isStoreDataInHive = false,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl} 2023-03-02 20:39:53");
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
    AddToWaitListRequestModel addToWaitListRequestModel = AddToWaitListRequestModel(
        contentID: contentId,
        locale: "${apiUrlConfigurationProvider.getLocale()}",
        siteId: "${apiUrlConfigurationProvider.getCurrentSiteId()}",
        userID: "${apiUrlConfigurationProvider.getCurrentUserId()}");

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.addToWaitListResponseModel,
      requestBody: MyUtils.encodeJson(addToWaitListRequestModel.toMap()),
      url: apiEndpoints.getAddToWaitList(),
      isGetDataFromHive: isFromOffline,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<AddToWaitListResponseModel> apiResponseModel = await apiController.callApi<AddToWaitListResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<RemoveFromWishlistResponseModel>> removeFromWishlist({
    required String contentId,
    required int componentId,
    required int componentInstanceId,
    bool isFromOffline = false,
    bool isStoreDataInHive = false,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl} 2023-03-02 20:39:53 ${DateTime.now().toString()}");
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.removeFromWishlist,
      url: apiEndpoints.getRemovedFromWishlist(contentId: contentId, userId: apiUrlConfigurationProvider.getCurrentUserId()),
      isGetDataFromHive: isFromOffline,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<RemoveFromWishlistResponseModel> apiResponseModel = await apiController.callApi<RemoveFromWishlistResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<PrerequisiteDetailResponseModel>> getPreRequisiteDetails({
    required String contentId,
    required int componentId,
    required int componentInstanceId,
    bool isFromOffline = false,
    bool isStoreDataInHive = false,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl} 2023-03-02 20:39:53 ${DateTime.now().toString()}");
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.prerequisiteResponseModel,
      url: apiEndpoints.getPrerequisiteDetails(contentId: contentId, userId: apiUrlConfigurationProvider.getCurrentUserId()),
      isGetDataFromHive: isFromOffline,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<PrerequisiteDetailResponseModel> apiResponseModel = await apiController.callApi<PrerequisiteDetailResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<AssociatedContentResponseModel>> getAssociatedContent({
    required String contentId,
    required int componentId,
    required int componentInstanceId,
    String instanceData = "",
    int preRequisiteSequencePathId = 0,
    bool isFromOffline = false,
    bool isStoreDataInHive = false,
  }) async {
    MyPrint.printOnConsole("repo getAssociatedContent");
    try {
      ApiEndpoints apiEndpoints = apiController.apiEndpoints;

      MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl} 2023-03-02 20:39:53 ${DateTime.now().toString()}");
      ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
      ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
        restCallType: RestCallType.simpleGetCall,
        parsingType: ModelDataParsingType.associatedContent,
        url: apiEndpoints.getAssociatedContent(
            contentId: contentId,
            userId: apiUrlConfigurationProvider.getCurrentUserId(),
            componentId: componentId,
            componentInstanceId: componentInstanceId,
            instanceData: instanceData,
            preRequisiteSequencePathId: preRequisiteSequencePathId,
            siteId: apiUrlConfigurationProvider.getCurrentSiteId(),
            locale: apiUrlConfigurationProvider.getLocale()),
        isGetDataFromHive: isFromOffline,
        isStoreDataInHive: isStoreDataInHive,
      );
      DataResponseModel<AssociatedContentResponseModel> apiResponseModel = await apiController.callApi<AssociatedContentResponseModel>(
        apiCallModel: apiCallModel,
      );
      MyPrint.printOnConsole("apiCallModel : ${apiResponseModel.data}");
      MyPrint.printOnConsole("Repo getAssociatedContent : ${apiResponseModel.data}");
      return apiResponseModel;
    } catch (e, s) {
      MyPrint.printOnConsole("Error CatalogRepository.getAssociatedContent() :$e");
      MyPrint.printOnConsole(s);
      return const DataResponseModel();
    }
  }

  Future<DataResponseModel<RemoveFromWishlistResponseModel>> pre({
    required String contentId,
    required int componentId,
    required int componentInstanceId,
    bool isFromOffline = false,
    bool isStoreDataInHive = false,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl} 2023-03-02 20:39:53 ${DateTime.now().toString()}");
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.removeFromWishlist,
      url: apiEndpoints.getRemovedFromWishlist(contentId: contentId, userId: apiUrlConfigurationProvider.getCurrentUserId()),
      isGetDataFromHive: isFromOffline,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<RemoveFromWishlistResponseModel> apiResponseModel = await apiController.callApi<RemoveFromWishlistResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<UserComingSoonResponse>> getComingResponse({
    required String contentId,
    bool isFromOffline = false,
    bool isStoreDataInHive = false,
  }) async {
    MyPrint.printOnConsole("repo getAssociatedContent");
    try {
      ApiEndpoints apiEndpoints = apiController.apiEndpoints;

      MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl} 2023-03-02 20:39:53 ${DateTime.now().toString()}");
      ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
      ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
        restCallType: RestCallType.simpleGetCall,
        parsingType: ModelDataParsingType.userComingSoonResponseModel,
        url: apiEndpoints.getUserComingSoonResponse(
          contentId: contentId,
          userId: apiUrlConfigurationProvider.getCurrentUserId(),
        ),
        isGetDataFromHive: isFromOffline,
        isStoreDataInHive: isStoreDataInHive,
      );
      DataResponseModel<UserComingSoonResponse> apiResponseModel = await apiController.callApi<UserComingSoonResponse>(
        apiCallModel: apiCallModel,
      );
      MyPrint.printOnConsole("apiCallModel : ${apiResponseModel.data}");
      MyPrint.printOnConsole("Repo getAssociatedContent : ${apiResponseModel.data}");
      return apiResponseModel;
    } catch (e, s) {
      MyPrint.printOnConsole("Error CatalogRepository.getAssociatedContent() :$e");
      MyPrint.printOnConsole(s);
      return const DataResponseModel();
    }
  }

  Future<DataResponseModel<UserComingSoonResponse>> createUpdateUserComingSoonResponse({
    required String contentId,
    required String text,
    required bool isUpdate,
    bool isFromOffline = false,
    bool isStoreDataInHive = false,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl} 2023-03-02 20:39:53");
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
    UserComingSoonRequestModel userComingSoonRequestModel =
        UserComingSoonRequestModel(contentId: contentId, responseText: text, savingtype: isUpdate ? "update" : "create", userID: apiUrlConfigurationProvider.getCurrentUserId());

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.userComingSoonResponseModel,
      requestBody: MyUtils.encodeJson(userComingSoonRequestModel.toJson()),
      url: apiEndpoints.apiCreateUpdateUserComingSoonResponse(),
      isGetDataFromHive: isFromOffline,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<UserComingSoonResponse> apiResponseModel = await apiController.callApi<UserComingSoonResponse>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> setCompleteStatus({
    required String contentID,
    required int scoId,
  }) async {
    MyPrint.printOnConsole('MyLearningRepository().setCompleteStatus() called with contentID:$contentID, scoId:$scoId');

    if (contentID.isEmpty) {
      return DataResponseModel(
        appErrorModel: AppErrorModel(
          message: "Content ID is empty",
        ),
      );
    }

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
    Map<String, dynamic> requestBody = {
      'ContentID': contentID,
      'ScoId': scoId.toString(),
      'UserID': apiUrlConfigurationProvider.getCurrentUserId().toString(),
    };

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.string,
      requestBody: MyUtils.encodeJson(requestBody),
      url: apiEndpoints.setCompleteStatusCatalog(),
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }
}
