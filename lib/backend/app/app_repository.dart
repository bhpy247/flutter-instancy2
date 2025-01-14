import 'package:flutter_instancy_2/api/api_call_model.dart';
import 'package:flutter_instancy_2/api/api_endpoints.dart';
import 'package:flutter_instancy_2/api/api_url_configuration_provider.dart';
import 'package:flutter_instancy_2/api/rest_client.dart';
import 'package:flutter_instancy_2/models/app/data_model/dynamic_tabs_dto_model.dart';
import 'package:flutter_instancy_2/models/app/request_model/get_dynamic_tabs_request_model.dart';
import 'package:flutter_instancy_2/models/common/data_response_model.dart';
import 'package:flutter_instancy_2/models/common/model_data_parser.dart';

import '../../api/api_controller.dart';
import '../../models/app_configuration_models/request_model/currency_data_request_model.dart';
import '../../models/app_configuration_models/response_model/currency_data_response_model.dart';

class AppRepository {
  final ApiController apiController;

  const AppRepository({required this.apiController});

  Future<DataResponseModel<CurrencyDataResponseModel>> GetCurrencyData({
    required CurrencyDataRequestModel requestModel,
    bool isStoreDataInHive = false,
    bool isGetDataFromHive = false,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.intSiteID = apiUrlConfigurationProvider.getCurrentSiteId();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.CurrencyDataResponseModel,
      url: apiEndpoints.GetCurrencyData(),
      queryParameters: requestModel.toJson(),
      isStoreDataInHive: isStoreDataInHive,
      isGetDataFromHive: isGetDataFromHive,
    );

    DataResponseModel<CurrencyDataResponseModel> apiResponseModel = await apiController.callApi<CurrencyDataResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<List<DynamicTabsDTOModel>>> getDynamicTabsList({required GetDynamicTabsRequestModel requestModel}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.Locale = apiUrlConfigurationProvider.getLocale();
    requestModel.aintUserID = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.SiteID = apiUrlConfigurationProvider.getCurrentSiteId();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, dynamic>>(
      restCallType: RestCallType.simpleGetCall,
      queryParameters: requestModel.toJson(),
      parsingType: ModelDataParsingType.DynamicTabsDTOModelList,
      url: apiEndpoints.getDynamicTabs(),
    );

    DataResponseModel<List<DynamicTabsDTOModel>> apiResponseModel = await apiController.callApi<List<DynamicTabsDTOModel>>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }
}
