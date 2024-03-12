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
import '../../models/course/data_model/CourseDTOModel.dart';

class CourseDetailsRepository {
  final ApiController apiController;

  const CourseDetailsRepository({required this.apiController});

  Future<DataResponseModel<CourseDTOModel>> getCourseDetailsData({
    required CourseDetailsRequestModel requestModel,
    String? clientUrl,
    int? userId,
    int? siteId,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.intUserID ??= userId ?? apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.SiteID = siteId ?? apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.Locale = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, String>>(
      restCallType: RestCallType.xxxUrlEncodedFormDataRequestCall,
      requestBody: requestModel.toJson(),
      parsingType: ModelDataParsingType.courseDTOModel,
      url: apiEndpoints.getContentDetailsUrl(),
      userId: userId,
      siteId: siteId,
      siteUrl: clientUrl,
    );

    DataResponseModel<CourseDTOModel> apiResponseModel = await apiController.callApi<CourseDTOModel>(
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
