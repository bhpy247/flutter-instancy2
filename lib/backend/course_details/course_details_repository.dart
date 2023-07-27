import 'package:flutter_instancy_2/models/content_details/data_model/content_details_dto_model.dart';
import 'package:flutter_instancy_2/models/content_details/request_model/course_details_request_model.dart';

import '../../api/api_call_model.dart';
import '../../api/api_controller.dart';
import '../../api/api_endpoints.dart';
import '../../api/api_url_configuration_provider.dart';
import '../../api/rest_client.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/model_data_parser.dart';
import '../../models/content_details/request_model/course_details_schedule_data_request_model.dart';
import '../../models/content_details/response_model/course_details_schedule_data_response_model.dart';

class CourseDetailsRepository {
  final ApiController apiController;

  const CourseDetailsRepository({required this.apiController});

  Future<DataResponseModel<ContentDetailsDTOModel>> getCourseDetailsData({
    required CourseDetailsRequestModel requestModel,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.intUserID ??= apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.SiteID = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.Locale = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, String>>(
      restCallType: RestCallType.xxxUrlEncodedFormDataRequestCall,
      requestBody: requestModel.toJson(),
      parsingType: ModelDataParsingType.contentDetailsDTOModel,
      url: apiEndpoints.getContentDetailsUrl(),
    );

    DataResponseModel<ContentDetailsDTOModel> apiResponseModel = await apiController.callApi<ContentDetailsDTOModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<CourseDetailsScheduleDataResponseModel>> getScheduleData({
    required CourseDetailsScheduleDataRequestModel requestModel,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.UserID = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.SiteID = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.LocalID = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, dynamic>>(
      restCallType: RestCallType.simpleGetCall,
      queryParameters: requestModel.toJson(),
      parsingType: ModelDataParsingType.courseDetailsScheduleDataResponseModel,
      url: apiEndpoints.getContentDetailsScheduleDataUrl(),
    );

    DataResponseModel<CourseDetailsScheduleDataResponseModel> apiResponseModel = await apiController.callApi<CourseDetailsScheduleDataResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }
}
