import 'package:flutter_instancy_2/models/learning_communities/request_model/learning_communities_request_model.dart';

import '../../api/api_call_model.dart';
import '../../api/api_controller.dart';
import '../../api/api_endpoints.dart';
import '../../api/api_url_configuration_provider.dart';
import '../../api/rest_client.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/model_data_parser.dart';
import '../../models/learning_communities/data_model/learning_communities_dto_model.dart';

class LearningCommunitiesRepository {
  final ApiController apiController;

  const LearningCommunitiesRepository({required this.apiController});

  Future<DataResponseModel<LearningCommunitiesDtoModel>> getLearningCommunitiesList({
    required GetLearningCommunitiesRequestModel requestModel,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.UserID = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.SiteID = apiUrlConfigurationProvider.getCurrentSiteId();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, String>>(
      restCallType: RestCallType.simpleGetCall,
      queryParameters: requestModel.toJson(),
      parsingType: ModelDataParsingType.LearningCommunitiesDto,
      url: apiEndpoints.GetAllLearningCommunities(),
    );

    DataResponseModel<LearningCommunitiesDtoModel> apiResponseModel = await apiController.callApi<LearningCommunitiesDtoModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }
}
