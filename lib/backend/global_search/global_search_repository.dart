import 'package:flutter_instancy_2/models/global_search/response_model/global_search_component_response_model.dart';

import '../../api/api_call_model.dart';
import '../../api/api_controller.dart';
import '../../api/api_endpoints.dart';
import '../../api/api_url_configuration_provider.dart';
import '../../api/rest_client.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/model_data_parser.dart';
import '../../models/dto/global_search_dto_model.dart';
import '../../models/global_search/request_model/global_search_request_model.dart';

class GlobalSearchRepository {
  final ApiController apiController;

  const GlobalSearchRepository({required this.apiController});

  Future<DataResponseModel<GlobalSearchComponentResponseModel>> getSearchComponent() async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    int userId = apiUrlConfigurationProvider.getCurrentUserId();
    int siteId = apiUrlConfigurationProvider.getCurrentSiteId();
    String locale = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, String>>(
      restCallType: RestCallType.simpleGetCall,
      queryParameters: {
        "intUserID": "$userId",
        "intSiteID": "$siteId",
        "strLocale": locale,
      },
      parsingType: ModelDataParsingType.GlobalSearchComponentResponseDto,
      url: apiEndpoints.GetGlobalSearchComponent(),
    );

    DataResponseModel<GlobalSearchComponentResponseModel> apiResponseModel = await apiController.callApi<GlobalSearchComponentResponseModel>(
      apiCallModel: apiCallModel,
    );
    return apiResponseModel;
  }

  Future<DataResponseModel<GlobalSearchDTOModel>> getGlobalSearchResult({
    required GlobalSearchResultRequestModel requestModel,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.userID = apiUrlConfigurationProvider.getCurrentUserId().toString();
    requestModel.siteID = apiUrlConfigurationProvider.getCurrentSiteId().toString();
    // requestModel.intComponentSiteID = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.orgUnitID = apiUrlConfigurationProvider.getCurrentSiteId().toString();
    requestModel.locale = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, String>>(
      restCallType: RestCallType.simpleGetCall,
      queryParameters: requestModel.toJson(),
      parsingType: ModelDataParsingType.GlobalSearchResultDto,
      url: apiEndpoints.GetGlobalSearchResult(),
    );

    DataResponseModel<GlobalSearchDTOModel> apiResponseModel = await apiController.callApi<GlobalSearchDTOModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }
}
