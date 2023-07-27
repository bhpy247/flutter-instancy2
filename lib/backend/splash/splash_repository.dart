import 'package:flutter_instancy_2/api/api_call_model.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/api/api_endpoints.dart';
import 'package:flutter_instancy_2/api/api_url_configuration_provider.dart';
import 'package:flutter_instancy_2/api/rest_client.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/local_str.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/native_menu_component_model.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/native_menu_model.dart';
import 'package:flutter_instancy_2/models/common/data_response_model.dart';
import 'package:flutter_instancy_2/models/common/model_data_parser.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';

import '../../models/app_configuration_models/data_models/tincan_data_model.dart';
import '../../models/app_configuration_models/response_model/mobile_api_auth_response_model.dart';
import '../../models/app_configuration_models/response_model/mobile_get_learning_portal_info_response_model.dart';

class SplashRepository {
  final ApiController apiController;

  const SplashRepository({required this.apiController});

  Future<DataResponseModel<MobileApiAuthResponseModel>> getSiteApiUrlConfigurationData() async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.mobileApiAuthResponseModel,
      url: apiEndpoints.apiSiteApiUrlConfiguration(),
    );

    DataResponseModel<MobileApiAuthResponseModel> apiResponseModel = await apiController.callApi<MobileApiAuthResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<MobileGetLearningPortalInfoResponseModel>> getLearningPlatformInfoData({bool isFromOffline = false, bool isStoreDataInHive = false}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.mobileGetLearningPortalInfoResponseModel,
      url: apiEndpoints.apiMobileGetLearningPortalInfo(),
      isGetDataFromHive: isFromOffline,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<MobileGetLearningPortalInfoResponseModel> apiResponseModel = await apiController.callApi<MobileGetLearningPortalInfoResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<LocalStr>> getLanguageJsonFile({required String langCode, bool isGetDataFromHive = false, bool isStoreDataInHive = false}) async {
    if(langCode.isEmpty) {
      langCode = LocaleType.english;
    }

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.localStr,
      url: apiEndpoints.apiGetJsonFile(locale: langCode, siteid: apiController.apiDataProvider.getCurrentSiteId()),
      isGetDataFromHive: isGetDataFromHive,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<LocalStr> apiResponseModel = await apiController.callApi<LocalStr>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<TinCanDataModel>> getTinCanConfigurations({required String langCode, bool isGetDataFromHive = false, bool isStoreDataInHive = false}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.tinCanDataModel,
      url: apiEndpoints.apiMobileTinCanConfigurations(locale: langCode),
      isGetDataFromHive: isGetDataFromHive,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<TinCanDataModel> apiResponseModel = await apiController.callApi<TinCanDataModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<List<NativeMenuModel>>> getNativeMenuModelsList({bool isGetDataFromHive = false, bool isStoreDataInHive = false}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.nativeMenuModelsList,
      url: apiEndpoints.apiMobileGetNativeMenus(
        siteId: apiUrlConfigurationProvider.getCurrentSiteId(),
        locale: apiUrlConfigurationProvider.getLocale(),
      ),
      isGetDataFromHive: isGetDataFromHive,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<List<NativeMenuModel>> apiResponseModel = await apiController.callApi<List<NativeMenuModel>>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<List<NativeMenuComponentModel>>> getNativeMenuComponentModelsList({required int menuId, bool isGetDataFromHive = false, bool isStoreDataInHive = false}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.nativeMenusComponentModelsList,
      url: apiEndpoints.apiMobileGetNativeMenuComponents(
        siteId: apiUrlConfigurationProvider.getCurrentSiteId(),
        menuId: menuId,
        locale: apiUrlConfigurationProvider.getLocale(),
      ),
      isGetDataFromHive: isGetDataFromHive,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<List<NativeMenuComponentModel>> apiResponseModel = await apiController.callApi<List<NativeMenuComponentModel>>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  /*
  Future<Response?> notificationCount() async {
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);

      Map<String, dynamic> notificationRequest = {
        'UserID': strUserID,
      };

      response = await RestClient.postMethodWithQueryParamData(
          ApiEndpoints.viewNotificationCount(), notificationRequest);

      print("Aman: ${response?.body}");
    } catch (e) {
      print("Error in SplashRepositoryPublic.notificationCount():$e");
    }
    return response;
  }

  Future<Response?> wishlistcount() async {
    Response? response;
    try {
      var strUserID = await sharePrefGetString(sharedPref_userid);
      var strSiteID = await sharePrefGetString(sharedPref_siteid);

      Map<String, dynamic> wishlistRequest = {
        'UserID': strUserID,
        'SiteID': strSiteID,
        'Locale': "en-us",
      };

      response = await RestClient.postApiDataForm(
          ApiEndpoints.GetWishListComponentDetails(), wishlistRequest);

      log("Wishlist Response: ${response?.body}");
    } catch (e) {
      print("Error in SplashRepositoryPublic.wishlistcount():$e");
    }
    return response;
  }*/
}