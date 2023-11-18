import 'package:flutter/foundation.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';

import '../../api/api_call_model.dart';
import '../../api/api_controller.dart';
import '../../api/api_endpoints.dart';
import '../../api/api_url_configuration_provider.dart';
import '../../api/rest_client.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/model_data_parser.dart';
import '../../models/in_app_purchase/request_model/ecommerce_order_request_model.dart';
import '../../models/in_app_purchase/request_model/ecommerce_process_payment_request_model.dart';
import '../../models/in_app_purchase/request_model/ecommerce_purchase_data_request_model.dart';
import '../../models/in_app_purchase/request_model/mobile_save_in_app_purchase_details_request_model.dart';
import '../../models/in_app_purchase/response_model/ecommerce_order_response_model.dart';
import '../../models/in_app_purchase/response_model/ecommerce_process_payment_response_model.dart';

class InAppPurchaseRepository {
  final ApiController apiController;

  const InAppPurchaseRepository({required this.apiController});

  Future<DataResponseModel<String>> saveInAppPurchaseDetails({required MobileSaveInAppPurchaseDetailsRequestModel requestModel}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.userId = apiUrlConfigurationProvider.getCurrentUserId().toString();
    requestModel.siteURl = apiUrlConfigurationProvider.getCurrentSiteUrl();
    requestModel.deviceType = switch (defaultTargetPlatform) {
      TargetPlatform.android => "Android",
      TargetPlatform.iOS => "IOS",
      _ => "",
    };

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.getMobileSaveInAppPurchaseDetails(),
      queryParameters: requestModel.toJson(),
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<EcommerceProcessPaymentResponseModel>> processPayments({required EcommerceProcessPaymentRequestModel requestModel}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.Locale = apiUrlConfigurationProvider.getLocale();
    requestModel.SiteID = apiUrlConfigurationProvider.getCurrentSiteId();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.EcommerceProcessPaymentResponseModel,
      url: apiEndpoints.getEcommerceProcessPayments(),
      requestBody: MyUtils.encodeJson(requestModel.toJson()),
    );

    DataResponseModel<EcommerceProcessPaymentResponseModel> apiResponseModel = await apiController.callApi<EcommerceProcessPaymentResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<dynamic>> purchaseData({required EcommercePurchaseDataRequestModel requestModel}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.Locale = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, String>>(
      restCallType: RestCallType.xxxUrlEncodedFormDataRequestCall,
      parsingType: ModelDataParsingType.dynamic,
      url: apiEndpoints.getEcommercePurchaseData(),
      requestBody: requestModel.toJson(),
    );

    DataResponseModel<dynamic> apiResponseModel = await apiController.callApi<dynamic>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<EcommerceOrderResponseModel>> GetEcommerceOrderByUser({required EcommerceOrderRequestModel requestModel}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.Locale = apiUrlConfigurationProvider.getLocale();
    requestModel.SiteID = apiUrlConfigurationProvider.getCurrentSiteId();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.EcommerceOrderResponseModel,
      url: apiEndpoints.getGetEcommerceOrderByUser(),
      requestBody: MyUtils.encodeJson(requestModel.toJson()),
    );

    DataResponseModel<EcommerceOrderResponseModel> apiResponseModel = await apiController.callApi<EcommerceOrderResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }
}
