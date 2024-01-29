import '../../api/api_call_model.dart';
import '../../api/api_controller.dart';
import '../../api/api_endpoints.dart';
import '../../api/api_url_configuration_provider.dart';
import '../../api/rest_client.dart';
import '../../models/common/Instancy_multipart_file_upload_model.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/model_data_parser.dart';
import '../../models/common/response_model/common_response_model.dart';
import '../../models/feedback/data_model/feedback_dto_model.dart';
import '../../models/feedback/request_model/update_feedback_request_model.dart';
import '../../utils/my_utils.dart';

class FeedbackRepository {
  final ApiController apiController;

  const FeedbackRepository({required this.apiController});

  Future<DataResponseModel<List<FeedbackDtoModel>>> getFeedbackList({bool viewAll = true}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    Map<String, String> requestBody = {
      "siteid": apiUrlConfigurationProvider.getCurrentSiteId().toString(),
      "currentuserid": apiUrlConfigurationProvider.getCurrentUserId().toString(),
      "viewall": "$viewAll"
    };

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, String>>(
      restCallType: RestCallType.simpleGetCall,
      queryParameters: requestBody,
      parsingType: ModelDataParsingType.FeedbackDTOModel,
      url: apiEndpoints.GetFeedbackList(),
    );

    DataResponseModel<List<FeedbackDtoModel>> apiResponseModel = await apiController.callApi<List<FeedbackDtoModel>>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<List<CommonResponseModel>>> updateFeedback({bool isEdit = false, required UpdateFeedbackRequestModel requestModel}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.currentuserid = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.currentsiteid = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.currentUrl = apiUrlConfigurationProvider.getCurrentSiteUrl();

    List<InstancyMultipartFileUploadModel> files = [];

    if (requestModel.fileUploads != null) {
      files.addAll(requestModel.fileUploads!);
    }

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData(
      restCallType: RestCallType.multipartRequestCall,
      parsingType: ModelDataParsingType.CommonResponseModel,
      url: apiEndpoints.UploadFeedback(),
      fields: requestModel.toJson(),
      files: files,
    );

    DataResponseModel<List<CommonResponseModel>> apiResponseModel = await apiController.callApi<List<CommonResponseModel>>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> deleteFeedback({required int id}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    Map<String, String> requestBody = {
      "ID": "$id",
      "userid": apiUrlConfigurationProvider.getCurrentUserId().toString(),
    };

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      requestBody: MyUtils.encodeJson(requestBody),
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.DeleteFeedback(),
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }
}
