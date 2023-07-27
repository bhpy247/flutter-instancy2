import 'package:flutter_instancy_2/api/api_call_model.dart';

import '../../api/api_controller.dart';
import '../../api/api_endpoints.dart';
import '../../api/api_url_configuration_provider.dart';
import '../../api/rest_client.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/model_data_parser.dart';
import '../../models/home/response_model/categorywise_course_dto_model.dart';
import '../../models/home/response_model/static_web_page_podel.dart';
import '../../utils/my_print.dart';

class HomeRepository {
  final ApiController apiController;

  const HomeRepository({required this.apiController});

  Future<DataResponseModel<CategoryWiseCourseDTOResponseModel>> getNewResourceList({required int componentId, required int componentInstanceId, bool isFromOffline = false, bool isStoreDataInHive = false}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.newLearningResourcesResponseModel,
      url: apiEndpoints.apiGetNewLearningResource(
        userId: apiUrlConfigurationProvider.getCurrentUserId(),
        siteID: apiUrlConfigurationProvider.getCurrentSiteId(),
        language: apiUrlConfigurationProvider.getLocale(),
        componentId: componentId,
        componentInstanceId: componentInstanceId,
      ),
      isGetDataFromHive: isFromOffline,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<CategoryWiseCourseDTOResponseModel> apiResponseModel = await apiController.callApi<CategoryWiseCourseDTOResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<CategoryWiseCourseDTOResponseModel>> getRecommendedCourseList({required int componentId, required int componentInstanceId, bool isFromOffline = false, bool isStoreDataInHive = false}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.newLearningResourcesResponseModel,
      url: apiEndpoints.apiGetRecommendedResource(
        userId: apiUrlConfigurationProvider.getCurrentUserId(),
        siteID: apiUrlConfigurationProvider.getCurrentSiteId(),
        language: apiUrlConfigurationProvider.getLocale(),
        componentId: componentId,
        componentInstanceId: componentInstanceId,
      ),
      isGetDataFromHive: isFromOffline,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<CategoryWiseCourseDTOResponseModel> apiResponseModel = await apiController.callApi<CategoryWiseCourseDTOResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<StaticWebPageModel>> getStaticWebPages({required int componentId, required int componentInstanceId, bool isFromOffline = false, bool isStoreDataInHive = false}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.staticWebPageModel,
      url: apiEndpoints.apiGetStaticWebPages(
        userId: apiUrlConfigurationProvider.getCurrentUserId(),
        siteID: apiUrlConfigurationProvider.getCurrentSiteId(),
        language: apiUrlConfigurationProvider.getLocale(),
        componentId: componentId,
        componentInstanceId: componentInstanceId,
      ),
      isGetDataFromHive: isFromOffline,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<StaticWebPageModel> apiResponseModel = await apiController.callApi<StaticWebPageModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }
}