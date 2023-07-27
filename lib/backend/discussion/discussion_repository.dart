import 'package:flutter_instancy_2/models/discussion/request_model/get_discussion_forum_list_request_model.dart';
import 'package:flutter_instancy_2/models/discussion/response_model/forum_listing_dto_response_model.dart';

import '../../api/api_call_model.dart';
import '../../api/api_controller.dart';
import '../../api/api_endpoints.dart';
import '../../api/api_url_configuration_provider.dart';
import '../../api/rest_client.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/model_data_parser.dart';

class DiscussionRepository {
  final ApiController apiController;

  const DiscussionRepository({required this.apiController});

  Future<DataResponseModel<ForumListingDTOResponseModel>> getForumsList({
    required GetDiscussionForumListRequestModel requestModel,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.intUserID = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.intSiteID = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.strLocale = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, String>>(
      restCallType: RestCallType.xxxUrlEncodedFormDataRequestCall,
      requestBody: requestModel.toJson(),
      parsingType: ModelDataParsingType.forumListingDTOResponseModel,
      url: apiEndpoints.getDiscussionForumList(),
    );

    DataResponseModel<ForumListingDTOResponseModel> apiResponseModel = await apiController.callApi<ForumListingDTOResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }
}