import 'package:flutter_instancy_2/api/api_url_configuration_provider.dart';

import '../../api/api_call_model.dart';
import '../../api/api_controller.dart';
import '../../api/api_endpoints.dart';
import '../../api/rest_client.dart';
import '../../models/common/app_error_model.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/model_data_parser.dart';
import '../../models/content_review_ratings/request_model/add_delete_content_user_ratings_request_model.dart';
import '../../models/content_review_ratings/request_model/content_user_ratings_data_request_model.dart';
import '../../models/content_review_ratings/response_model/content_user_ratings_data_response_model.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';

class ContentReviewRatingsRepository {
  final ApiController apiController;

  const ContentReviewRatingsRepository({required this.apiController});

  Future<DataResponseModel<ContentUserRatingsDataResponseModel>> getContentUserRatings({
    required ContentUserRatingsDataRequestModel requestModel,
  }) async {
    MyPrint.printOnConsole('ContentReviewRatingsRepository().getContentUserRatings() called with requestModel:$requestModel');

    if(requestModel.contentId.isEmpty) {
      return DataResponseModel(
        appErrorModel: AppErrorModel(
          message: "Content ID is empty",
        ),
      );
    }

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
    requestModel.locale = apiUrlConfigurationProvider.getLocale();
    requestModel.intUserId = apiUrlConfigurationProvider.getCurrentUserId().toString();
    requestModel.siteId = apiUrlConfigurationProvider.getCurrentSiteId().toString();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.contentUserRatingsDataResponseModel,
      url: apiEndpoints.getGetUserRatingsURL(),
      requestBody: MyUtils.encodeJson(requestModel.toJson()),
    );

    DataResponseModel<ContentUserRatingsDataResponseModel> apiResponseModel = await apiController.callApi<ContentUserRatingsDataResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> addReview({
    required AddDeleteContentUserRatingsRequestModel requestModel,
  }) async {
    MyPrint.printOnConsole('ContentReviewRatingsRepository().addReview() called with requestModel:$requestModel');

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    // final DateTime now = DateTime.now();
    // final String dateString = DatePresentation.getFormattedDate(dateFormat: "yyyy-MM-dd HH:mm:ss", dateTime: now) ?? "";

    requestModel.userId = apiUrlConfigurationProvider.getCurrentUserId().toString();
    // requestModel.reviewDate = dateString;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.getAddUserRatingsURL(),
      requestBody: MyUtils.encodeJson(requestModel.toJson()),
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> deleteReview({
    required AddDeleteContentUserRatingsRequestModel requestModel,
  }) async {
    MyPrint.printOnConsole('ContentReviewRatingsRepository().deleteReview() called with requestModel:$requestModel');

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.getDeleteUserRatingsURL(),
      requestBody: MyUtils.encodeJson(requestModel.toJson()),
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }
}