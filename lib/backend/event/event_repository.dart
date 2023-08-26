import 'package:flutter_instancy_2/models/classroom_events/data_model/tab_data_model.dart';

import '../../api/api_call_model.dart';
import '../../api/api_controller.dart';
import '../../api/api_endpoints.dart';
import '../../api/api_url_configuration_provider.dart';
import '../../api/rest_client.dart';
import '../../models/classroom_events/request_model/tabs_list_request_model.dart';
import '../../models/common/app_error_model.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/model_data_parser.dart';
import '../../models/event/response_model/event_session_data_response_model.dart';
import '../../utils/my_print.dart';

class EventRepository {
  final ApiController apiController;

  const EventRepository({required this.apiController});

  Future<DataResponseModel<String>> checkIsFallUnderBadCancelEnrollment({required String eventId}) async {
    MyPrint.printOnConsole('EventRepository().checkIsFallUnderBadCancelEnrollment() called with contentID:$eventId');

    if (eventId.isEmpty) {
      return DataResponseModel(
        appErrorModel: AppErrorModel(
          message: "Event ID is empty",
        ),
      );
    }

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.getCheckIsFallUnderBadCancelEnrollment(),
      queryParameters: <String, String>{
        'EventID': eventId,
        'SiteID': apiUrlConfigurationProvider.getCurrentSiteId().toString(),
      },
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> cancelEnrolledEvent({
    required String eventId,
    required bool isBadCancel,
  }) async {
    MyPrint.printOnConsole('EventRepository().checkIsFallUnderBadCancelEnrollment() called with contentID:$eventId');

    if (eventId.isEmpty) {
      return DataResponseModel(
        appErrorModel: AppErrorModel(
          message: "Event ID is empty",
        ),
      );
    }

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.getCancelEnrolledEvent(),
      queryParameters: <String, String>{
        'EventContentId': eventId,
        'isBadCancel': isBadCancel.toString(),
        'UserID': apiUrlConfigurationProvider.getCurrentUserId().toString(),
        'SiteID': apiUrlConfigurationProvider.getCurrentSiteId().toString(),
        'LocaleID': apiUrlConfigurationProvider.getLocale(),
      },
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<EventSessionDataResponseModel>> getEventSessionData({
    required String eventId,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, dynamic>>(
      restCallType: RestCallType.simpleGetCall,
      queryParameters: {
        "ContentID": eventId,
        "UserID": apiUrlConfigurationProvider.getCurrentUserId().toString(),
        "SiteID": apiUrlConfigurationProvider.getCurrentSiteId().toString(),
        "locale": apiUrlConfigurationProvider.getLocale().toString(),
        "multiLocation": "",
      },
      parsingType: ModelDataParsingType.eventSessionDataResponseModel,
      url: apiEndpoints.getEventSessionData(),
    );

    DataResponseModel<EventSessionDataResponseModel> apiResponseModel = await apiController.callApi<EventSessionDataResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<List<TabDataModel>>> getTabsList({required TabsListRequestModel requestModel}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.Locale = apiUrlConfigurationProvider.getLocale();
    requestModel.aintUserID = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.SiteID = apiUrlConfigurationProvider.getCurrentSiteId();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, dynamic>>(
      restCallType: RestCallType.simpleGetCall,
      queryParameters: requestModel.toJson(),
      parsingType: ModelDataParsingType.tabDataModelList,
      url: apiEndpoints.getDynamicTabs(),
    );

    DataResponseModel<List<TabDataModel>> apiResponseModel = await apiController.callApi<List<TabDataModel>>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }
}
