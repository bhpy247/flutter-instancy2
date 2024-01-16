import '../../api/api_call_model.dart';
import '../../api/api_controller.dart';
import '../../api/api_endpoints.dart';
import '../../api/api_url_configuration_provider.dart';
import '../../api/rest_client.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/model_data_parser.dart';
import '../../models/feedback/data_model/feedback_dto_model.dart';

class FeedbackRepository {
  final ApiController apiController;

  const FeedbackRepository({required this.apiController});

  Future<DataResponseModel<List<FeedbackDtoModel>>> getFeedbackList() async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    Map<String, String> requestBody = {
      "siteid": apiUrlConfigurationProvider.getCurrentSiteId().toString(),
      "currentuserid": apiUrlConfigurationProvider.getCurrentUserId().toString(),
    };

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, String>>(
      restCallType: RestCallType.simpleGetCall,
      requestBody: requestBody,
      parsingType: ModelDataParsingType.FeedbackDTOModel,
      url: apiEndpoints.getDiscussionForumList(),
    );

    DataResponseModel<List<FeedbackDtoModel>> apiResponseModel = await apiController.callApi<List<FeedbackDtoModel>>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }
}
