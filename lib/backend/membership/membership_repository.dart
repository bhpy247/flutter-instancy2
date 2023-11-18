import 'package:flutter_instancy_2/api/api_call_model.dart';
import 'package:flutter_instancy_2/api/api_endpoints.dart';
import 'package:flutter_instancy_2/api/api_url_configuration_provider.dart';
import 'package:flutter_instancy_2/api/rest_client.dart';
import 'package:flutter_instancy_2/models/common/data_response_model.dart';
import 'package:flutter_instancy_2/models/common/model_data_parser.dart';
import 'package:flutter_instancy_2/models/membership/data_model/member_ship_dto_model.dart';

import '../../api/api_controller.dart';
import '../../models/membership/request_model/cancel_user_membership_request_model.dart';
import '../../models/membership/request_model/membership_plan_request_model.dart';
import '../../models/membership/request_model/user_active_membership_request_model.dart';
import '../../models/membership/response_model/user_active_membership_response_model.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';

class MembershipRepository {
  final ApiController apiController;

  const MembershipRepository({required this.apiController});

  Future<DataResponseModel<List<MemberShipDTOModel>>> GetMemberShipDetails({required MembershipPlanRequestModel requestModel}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.Locale = apiUrlConfigurationProvider.getLocale();
    requestModel.SiteID = apiUrlConfigurationProvider.getCurrentSiteId();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, String>>(
      restCallType: RestCallType.xxxUrlEncodedFormDataRequestCall,
      parsingType: ModelDataParsingType.MemberShipDTOModelList,
      url: apiEndpoints.getMemberShipDetails(),
      requestBody: requestModel.toJson(),
    );

    DataResponseModel<List<MemberShipDTOModel>> apiResponseModel = await apiController.callApi<List<MemberShipDTOModel>>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<List<MemberShipDTOModel>>> GetUpdateMemberShipDetails({required MembershipPlanRequestModel requestModel}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.Locale = apiUrlConfigurationProvider.getLocale();
    requestModel.SiteID = apiUrlConfigurationProvider.getCurrentSiteId();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, String>>(
      restCallType: RestCallType.xxxUrlEncodedFormDataRequestCall,
      parsingType: ModelDataParsingType.MemberShipDTOModelList,
      url: apiEndpoints.GetUpdateMemberShipDetails(),
      requestBody: requestModel.toJson(),
    );

    DataResponseModel<List<MemberShipDTOModel>> apiResponseModel = await apiController.callApi<List<MemberShipDTOModel>>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<UserActiveMembershipResponseModel>> GetUserActiveMembership({required UserActiveMembershipRequestModel requestModel}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.Locale = apiUrlConfigurationProvider.getLocale();
    requestModel.SiteID = apiUrlConfigurationProvider.getCurrentSiteId();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.UserActiveMembershipResponseModel,
      url: apiEndpoints.GetUserActiveMembership(),
      requestBody: MyUtils.encodeJson(requestModel.toJson()),
    );

    DataResponseModel<UserActiveMembershipResponseModel> apiResponseModel = await apiController.callApi<UserActiveMembershipResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> CancelUserMembership({required CancelUserMembershipRequestModel requestModel}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.Locale = apiUrlConfigurationProvider.getLocale();
    requestModel.UserSiteID = apiUrlConfigurationProvider.getCurrentSiteId();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.CancelUserMembership(),
      queryParameters: requestModel.toJson(),
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }
}
