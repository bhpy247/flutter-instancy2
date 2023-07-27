import 'package:flutter/foundation.dart';
import 'package:flutter_instancy_2/api/api_call_model.dart';
import 'package:flutter_instancy_2/api/api_endpoints.dart';
import 'package:flutter_instancy_2/api/rest_client.dart';
import 'package:flutter_instancy_2/backend/app/app_controller.dart';
import 'package:flutter_instancy_2/backend/common/main_hive_controller.dart';
import 'package:flutter_instancy_2/hive/hive_call_model.dart';
import 'package:flutter_instancy_2/hive/hive_operation_controller.dart';
import 'package:flutter_instancy_2/models/common/data_response_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';

import '../configs/app_strings.dart';
import '../models/common/Instancy_multipart_file_upload_model.dart';
import '../models/common/app_error_model.dart';
import '../models/common/model_data_parser.dart';
import 'api_url_configuration_provider.dart';

class ApiController {
  static final ApiController _instance = ApiController.getNewInstance();
  ApiController.getNewInstance();
  factory ApiController() => _instance;

  final ApiUrlConfigurationProvider _apiDataProvider = ApiUrlConfigurationProvider();

  ApiUrlConfigurationProvider get apiDataProvider => _apiDataProvider;

  ApiEndpoints get apiEndpoints => ApiEndpoints(
    siteUrl: apiDataProvider.getCurrentSiteUrl(),
    authUrl: apiDataProvider.getAuthUrl(),
    apiUrl: apiDataProvider.getCurrentBaseApiUrl(),
  );

  //(1) This is the main method which is responsible for Making the API Call and Handle That
  Future<DataResponseModel<T>> callApi<T>({required ApiCallModel apiCallModel, bool isLogoutOnAuthorizationExpired = true, bool isIsolateCall = true}) async {
    DataResponseModel<T> responseModel;

    if(isIsolateCall && !apiCallModel.isGetDataFromHive && !apiCallModel.isStoreDataInHive) {
      responseModel = await compute<ApiCallModel, DataResponseModel<T>>(makeApiCallAndParseData<T>, apiCallModel);
    }
    else {
      responseModel = await makeApiCallAndParseData<T>(apiCallModel);
    }

    if(responseModel.appErrorModel?.code == 401 && isLogoutOnAuthorizationExpired) {
      //Logout
      AppController().sessionTimeOut();
    }

    return responseModel;
  }

  //(2) This Method is Responsible for Making a ApiCall and parse the data in the desired format
  Future<DataResponseModel<T>> makeApiCallAndParseData<T>(ApiCallModel apiCallModel) async {
    if(apiCallModel.isGetDataFromHive) {
      return HiveOperationController().makeCall(
        hiveCallModel: HiveCallModel(
          operationType: HiveOperationType.get,
          parsingType: apiCallModel.parsingType,
          key: apiCallModel.url,
          box: apiCallModel.hiveBox,
        ),
      );
    }
    else {
      MyUtils.initializeHttpOverrides();

      Response? response = await RestClient.callApi(apiCallModel: apiCallModel);

      T? data;
      AppErrorModel? appErrorModel;

      if(response?.statusCode == 200) {
        MyPrint.printOnConsole("Parsing Data For Type:${apiCallModel.parsingType}");
        data = ModelDataParser.parseDataFromDecodedValue<T>(parsingType: apiCallModel.parsingType, decodedValue: MyUtils.decodeJson(response!.body));

        if(apiCallModel.isStoreDataInHive) {
          HiveOperationController().makeCall(
            hiveCallModel: HiveCallModel(
              operationType: HiveOperationType.set,
              parsingType: apiCallModel.parsingType,
              key: apiCallModel.url,
              box: apiCallModel.hiveBox,
              value: response.body,
            ),
          );
        }
      }
      else if(response?.statusCode == 401) {
        appErrorModel = AppErrorModel(
          message: AppStrings.tokenExpired,
          code: 401,
        );
      }
      else {
        appErrorModel = AppErrorModel(
          message: response?.body ?? AppStrings.errorInApiCall,
          code: response?.statusCode ?? -1,
        );
      }

      return DataResponseModel<T>(
        data: data,
        appErrorModel: appErrorModel,
        statusCode: response?.statusCode ?? -1,
      );
    }
  }


  //To Get Api Request Data with the minimum required values, other parameters it will get from ApiProvider present in the object
  Future<ApiCallModel> getApiCallModelFromData<RequestBodyType>({
    required RestCallType restCallType,
    required ModelDataParsingType parsingType,
    required String url,
    Map<String, String>? queryParameters,
    RequestBodyType? requestBody,
    List<InstancyMultipartFileUploadModel>? files,
    Map<String, String>? fields,
    String? siteUrl,
    int? userId,
    int? siteId,
    String? locale,
    String? token,
    bool isAuthenticatedApiCall = true,
    bool isGetDataFromHive = false,
    bool isStoreDataInHive = false,
  }) async {
    String currentSiteUrl = siteUrl.checkNotEmpty ? siteUrl! : apiDataProvider.getCurrentSiteUrl();

    Box? box;
    if(isGetDataFromHive || isStoreDataInHive) {
      box = await MainHiveController().initializeCurrentSiteBox(
        currentSiteUrl: currentSiteUrl,
      );
    }

    return ApiCallModel<RequestBodyType>(
      restCallType: restCallType,
      parsingType: parsingType,
      url: url,
      queryParameters: queryParameters,
      requestBody: requestBody,
      fields: fields,
      files: files,
      siteUrl: currentSiteUrl,
      locale: locale.checkNotEmpty ? locale! : apiDataProvider.getLocale(),
      token: token.checkNotEmpty ? token! : apiDataProvider.getAuthToken(),
      userId: userId ?? apiDataProvider.getCurrentUserId(),
      siteId: siteId ?? apiDataProvider.getCurrentSiteId(),
      isAuthenticatedApiCall: isAuthenticatedApiCall,
      isGetDataFromHive: isGetDataFromHive,
      isStoreDataInHive: isStoreDataInHive,
      hiveBox: box,
    );
  }
}

