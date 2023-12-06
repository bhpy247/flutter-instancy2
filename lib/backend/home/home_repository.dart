import 'package:flutter_instancy_2/api/api_call_model.dart';
import 'package:flutter_instancy_2/models/home/data_model/web_list_data_dto.dart';

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

  Future<DataResponseModel<CategoryWiseCourseDTOResponseModel>> getNewResourceList(
      {required int componentId, required int componentInstanceId, bool isFromOffline = false, bool isStoreDataInHive = false}) async {
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

  Future<DataResponseModel<CategoryWiseCourseDTOResponseModel>> getRecommendedCourseList(
      {required int componentId, required int componentInstanceId, bool isFromOffline = false, bool isStoreDataInHive = false}) async {
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
      queryParameters: {
        "aintUserID": apiUrlConfigurationProvider.getCurrentUserId().toString(),
        "aintSiteID": apiUrlConfigurationProvider.getCurrentSiteId().toString(),
        "astrLocale": apiUrlConfigurationProvider.getLocale(),
        "astrContentID": "-1",
        "ScoID": "-1",
        "ComponentID": "$componentId",
        "ComponentInstanceID": "$componentInstanceId",
        "CurrentPath": "09",
        "isFromNativeApp": "true"
      },
      url: apiEndpoints.apiGetStaticWebPages(

          //     aintUserID: 467  ?aintUserID=$userId&aintSiteID=$siteID&astrLocale=$language&astrContentID=-1&ScoID=-1&ComponentID=$componentId&ComponentInstanceID=$componentInstanceId&CurrentPath=09&isFromNativeApp=true'
          //     aintSiteID: 374
          // astrLocale: en-us
          // astrContentID: -1
          // ScoID: -1
          // ComponentID: 51
          // ComponentInstanceID: 50052
          //     CurrentPath: 09
          ),
      isGetDataFromHive: isFromOffline,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<StaticWebPageModel> apiResponseModel = await apiController.callApi<StaticWebPageModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<WebListDataDTO>> getWebListWebPages({required int componentId, required int componentInstanceId, bool isFromOffline = false, bool isStoreDataInHive = false}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.listWebListModel,
      queryParameters: {
        "aintUserID": apiUrlConfigurationProvider.getCurrentUserId().toString(),
        "aintSiteID": apiUrlConfigurationProvider.getCurrentSiteId().toString(),
        "astrLocale": apiUrlConfigurationProvider.getLocale(),
        "ComponentID": "$componentId",
        "CompInsID": "$componentInstanceId",
        "TabTypeID": apiUrlConfigurationProvider.getCurrentSiteId().toString(),
        "tabtype": "1",
        "PreferenceType": "1",
        "DeliveryModeID": "1",
        "astrsorttype": "2",
        "externaluser": "1",
        "DataSource": "1",
        "groupId": "-1",
      },
      url: apiEndpoints.apiGetWebListApi(),
      isGetDataFromHive: isFromOffline,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<WebListDataDTO> apiResponseModel = await apiController.callApi<WebListDataDTO>(
      apiCallModel: apiCallModel,
    );
    return apiResponseModel;
  }
}
