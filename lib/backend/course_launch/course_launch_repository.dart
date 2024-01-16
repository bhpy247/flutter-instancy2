import 'package:flutter_instancy_2/models/course_launch/request_model/content_status_request_model.dart';
import 'package:flutter_instancy_2/models/course_launch/response_model/content_status_response_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';

import '../../api/api_call_model.dart';
import '../../api/api_controller.dart';
import '../../api/api_endpoints.dart';
import '../../api/api_url_configuration_provider.dart';
import '../../api/rest_client.dart';
import '../../models/common/app_error_model.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/model_data_parser.dart';
import '../../models/course_launch/request_model/initial_course_tracking_request_model.dart';
import '../../models/course_launch/request_model/insert_course_data_by_token_request_model.dart';
import '../../models/course_launch/request_model/web_api_initialize_tracking_request_model.dart';
import '../../utils/my_print.dart';

class CourseLaunchRepository {
  final ApiController apiController;

  const CourseLaunchRepository({required this.apiController});

  Future<DataResponseModel<String>> getCourseTrackingSessionId({
    required WebApiInitializeTrackingRequestModel requestModel,
  }) async {
    MyPrint.printOnConsole('CourseLaunchRepository().getCourseTrackingSessionId() called with requestModel:$requestModel');

    if(requestModel.contentid.isEmpty) {
      return DataResponseModel(
        appErrorModel: AppErrorModel(
          message: "Content ID is empty",
        ),
      );
    }

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    // ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.getWebAPIInitialiseTrackingApiCall(),
      queryParameters: requestModel.toJson(),
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> insertCourseDataByToken({
    required InsertCourseDataByTokenRequestModel requestModel,
  }) async {
    MyPrint.printOnConsole('CourseLaunchRepository().getCourseTrackingSessionId() called with requestModel:$requestModel');

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    // ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, String>>(
      restCallType: RestCallType.xxxUrlEncodedFormDataRequestCall,
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.getInsertCourseDataByTokenApiCall(),
      requestBody: requestModel.toJson(),
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<ContentStatusResponseModel>> getContentStatus({
    required ContentStatusRequestModel requestModel,
  }) async {
    MyPrint.printOnConsole('CourseLaunchRepository().getCourseTrackingSessionId() called with requestModel:$requestModel');

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    // ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, String>>(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.ContentStatusResponseModel,
      url: apiEndpoints.getMobileGetContentStatusApiCall(),
      queryParameters: requestModel.toJson(),
    );

    DataResponseModel<ContentStatusResponseModel> apiResponseModel = await apiController.callApi<ContentStatusResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> initializeTrackingForMediaObjects({
    required InitialCourseTrackingRequestModel requestModel,
  }) async {
    MyPrint.printOnConsole('CourseLaunchRepository().getCourseTrackingSessionId() called with requestModel:$requestModel');

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    // ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.getInitializeTrackingforMediaObjectsApiCall(),
      requestBody: MyUtils.encodeJson(requestModel.toJson()),
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> updateTrackListViewBookmark({required String scoId, required String trackId}) async {
    MyPrint.printOnConsole('CourseLaunchRepository().getCourseTrackingSessionId() called with Scoid : $scoId, trackID: $trackId');

    if (scoId.checkEmpty) {
      return DataResponseModel(
        appErrorModel: AppErrorModel(
          message: "scoId is empty",
        ),
      );
    }

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
    int userId = apiUrlConfigurationProvider.getCurrentUserId();
    String contentScoId = scoId;
    String contentTrackId = trackId;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.updateBookmarkApiCall(),
      queryParameters: {"userId": "$userId", "scoId": contentScoId, "trackId": contentTrackId},
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }
}