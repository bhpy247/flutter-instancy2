import 'package:flutter_instancy_2/models/filter/request_model/content_filter_params_model.dart';
import 'package:flutter_instancy_2/models/filter/request_model/learning_provider_filter_request_params_model.dart';
import 'package:flutter_instancy_2/models/filter/response_model/component_sort_options_response_model.dart';
import 'package:flutter_instancy_2/models/filter/response_model/learning_provider_filter_response_model.dart';

import '../../api/api_call_model.dart';
import '../../api/api_controller.dart';
import '../../api/api_endpoints.dart';
import '../../api/api_url_configuration_provider.dart';
import '../../api/rest_client.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/model_data_parser.dart';
import '../../models/filter/data_model/content_filter_category_tree_model.dart';
import '../../models/filter/request_model/component_sort_params_model.dart';
import '../../models/filter/request_model/instructor_list_filter_request_params_model.dart';
import '../../models/filter/response_model/filter_duration_values_response_model.dart';
import '../../models/filter/response_model/instructor_list_filter_response_model.dart';

class FilterRepository {
  final ApiController apiController;

  const FilterRepository({required this.apiController});

  Future<DataResponseModel<List<ContentFilterCategoryTreeModel>>> getContentFilterCategoryTree({
    required ContentFilterParamsModel contentFilterParams,
    bool isFromOffline = false,
    bool isStoreDataInHive = false,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    contentFilterParams.UserID = apiUrlConfigurationProvider.getCurrentUserId();
    contentFilterParams.SiteID = apiUrlConfigurationProvider.getCurrentSiteId();
    contentFilterParams.Locale = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData(
      restCallType: RestCallType.simpleGetCall,
      queryParameters: contentFilterParams.toMap(),
      parsingType: ModelDataParsingType.contentFilterCategoryTreeModelList,
      url: apiEndpoints.getContentFilterCategoryTree(),
      isGetDataFromHive: isFromOffline,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<List<ContentFilterCategoryTreeModel>> apiResponseModel = await apiController.callApi<List<ContentFilterCategoryTreeModel>>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<LearningProviderFilterResponseModel>> getLearningProviders({
    required String privacyType,
    bool isFromOffline = false,
    bool isStoreDataInHive = false,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    LearningProviderFilterRequestParamsModel requestParamsModel = LearningProviderFilterRequestParamsModel(
      UserID: apiUrlConfigurationProvider.getCurrentUserId(),
      SiteID: apiUrlConfigurationProvider.getCurrentSiteId(),
      PrivacyType: privacyType,
      // PrivacyType: "public",
    );

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData(
      restCallType: RestCallType.simpleGetCall,
      queryParameters: requestParamsModel.toMap(),
      parsingType: ModelDataParsingType.LearningProviderFilterResponseModel,
      url: apiEndpoints.getLearningProviderForFilter(),
      isGetDataFromHive: isFromOffline,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<LearningProviderFilterResponseModel> apiResponseModel = await apiController.callApi<LearningProviderFilterResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<InstructorListFilterResponseModel>> getInstructorsListForFilter({
    bool isFromOffline = false,
    bool isStoreDataInHive = false,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    InstructorListFilterRequestParamsModel requestParamsModel = InstructorListFilterRequestParamsModel(
      UserID: apiUrlConfigurationProvider.getCurrentUserId(),
      SiteID: apiUrlConfigurationProvider.getCurrentSiteId(),
      IsShowOnlyPresenter: 0,
    );

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData(
      restCallType: RestCallType.simpleGetCall,
      queryParameters: requestParamsModel.toMap(),
      parsingType: ModelDataParsingType.InstructorListFilterResponseModel,
      url: apiEndpoints.getInstructorListForFilter(),
      isGetDataFromHive: isFromOffline,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<InstructorListFilterResponseModel> apiResponseModel = await apiController.callApi<InstructorListFilterResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<FilterDurationValuesResponseModel>> getFilterDurationValues({
    bool isFromOffline = false,
    bool isStoreDataInHive = false,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.FilterDurationValuesResponseModel,
      url: apiEndpoints.getFilterDurationValues(),
      isGetDataFromHive: isFromOffline,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<FilterDurationValuesResponseModel> apiResponseModel = await apiController.callApi<FilterDurationValuesResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<ComponentSortResponseModel>> getComponentSortValues({
    required ComponentSortParamsModel requestParamsModel,
    bool isFromOffline = false,
    bool isStoreDataInHive = false,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestParamsModel.UserID = apiUrlConfigurationProvider.getCurrentUserId();
    requestParamsModel.OrgUnitID = apiUrlConfigurationProvider.getCurrentSiteId();
    requestParamsModel.LocaleID = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.ComponentSortResponseModel,
      url: apiEndpoints.getComponentSortOptions(),
      queryParameters: requestParamsModel.toMap(),
      isGetDataFromHive: isFromOffline,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<ComponentSortResponseModel> apiResponseModel = await apiController.callApi<ComponentSortResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }
}