import 'package:flutter_instancy_2/utils/my_utils.dart';

import '../../api/api_call_model.dart';
import '../../api/api_controller.dart';
import '../../api/api_endpoints.dart';
import '../../api/api_url_configuration_provider.dart';
import '../../api/rest_client.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/model_data_parser.dart';
import '../../models/my_connections/request_model/get_people_list_request_model.dart';
import '../../models/my_connections/response_model/people_listing_dto_response_model.dart';

class MyConnectionsRepository {
  final ApiController apiController;

  const MyConnectionsRepository({required this.apiController});

  Future<DataResponseModel<PeopleListingDTOResponseModel>> getPeopleList({
    required GetPeopleListRequestModel requestModel,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.UserID = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.SiteID = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.Locale = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      requestBody: MyUtils.encodeJson(requestModel.toJson()),
      parsingType: ModelDataParsingType.peopleListingDTOResponseModel,
      url: apiEndpoints.getPeopleList(),
    );

    DataResponseModel<PeopleListingDTOResponseModel> apiResponseModel = await apiController.callApi<PeopleListingDTOResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }
}