import 'package:flutter_instancy_2/models/course/data_model/gloassary_model.dart';
import 'package:flutter_instancy_2/models/event_track/request_model/event_related_contents_data_request_model.dart';
import 'package:flutter_instancy_2/models/event_track/request_model/event_track_overview_request_model.dart';
import 'package:flutter_instancy_2/models/event_track/request_model/track_list_view_data_request_model.dart';
import 'package:flutter_instancy_2/models/event_track/response_model/event_track_resourse_response_model.dart';
import 'package:flutter_instancy_2/models/event_track/response_model/resource_content_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/response_model/track_list_view_data_response_model.dart';

import '../../api/api_call_model.dart';
import '../../api/api_controller.dart';
import '../../api/api_endpoints.dart';
import '../../api/api_url_configuration_provider.dart';
import '../../api/rest_client.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/model_data_parser.dart';
import '../../models/event_track/data_model/event_track_dto_model.dart';
import '../../models/event_track/data_model/event_track_header_dto_model.dart';
import '../../models/event_track/data_model/event_track_tab_dto_model.dart';
import '../../models/event_track/request_model/event_track_headers_request_model.dart';
import '../../models/event_track/request_model/event_track_tab_request_model.dart';

class EventTrackRepository {
  final ApiController apiController;

  const EventTrackRepository({required this.apiController});

  Future<DataResponseModel<EventTrackHeaderDTOModel>> getEventTrackTrackHeader({
    required EventTrackHeadersRequestModel requestModel,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.userID = apiUrlConfigurationProvider.getCurrentUserId().toString();
    requestModel.siteID = apiUrlConfigurationProvider.getCurrentSiteId().toString();
    requestModel.localeID = apiUrlConfigurationProvider.getLocale().toString();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, dynamic>>(
      restCallType: RestCallType.simpleGetCall,
      queryParameters: requestModel.toJson(),
      parsingType: ModelDataParsingType.eventTrackHeaderDTOModel,
      url: apiEndpoints.getEventTrackHeaderData(),
    );

    DataResponseModel<EventTrackHeaderDTOModel> apiResponseModel = await apiController.callApi<EventTrackHeaderDTOModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<List<EventTrackTabDTOModel>>> getEventTrackTabList({
    required EventTrackTabRequestModel requestModel,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
    requestModel.userID = apiUrlConfigurationProvider.getCurrentUserId().toString();
    requestModel.siteID = apiUrlConfigurationProvider.getCurrentSiteId().toString();
    requestModel.localeID = apiUrlConfigurationProvider.getLocale().toString();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, dynamic>>(
      restCallType: RestCallType.simpleGetCall,
      queryParameters: requestModel.toJson(),
      parsingType: ModelDataParsingType.eventTrackTabDTOModelList,
      url: apiEndpoints.getEventTrackTabData(),
    );

    DataResponseModel<List<EventTrackTabDTOModel>> apiResponseModel = await apiController.callApi<List<EventTrackTabDTOModel>>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<List<EventTrackDTOModel>>> getEventTrackOverviewData({
    required EventTrackOverviewRequestModel requestModel,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
    requestModel.TrackingUserId = apiUrlConfigurationProvider.getCurrentUserId().toString();
    requestModel.siteId = apiUrlConfigurationProvider.getCurrentSiteId().toString();
    requestModel.localeId = apiUrlConfigurationProvider.getLocale().toString();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, dynamic>>(
      restCallType: RestCallType.simpleGetCall,
      queryParameters: requestModel.toJson(),
      parsingType: ModelDataParsingType.eventTrackDTOModelList,
      url: apiEndpoints.getEventTrackOverview(),
    );

    DataResponseModel<List<EventTrackDTOModel>> apiResponseModel = await apiController.callApi<List<EventTrackDTOModel>>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<List<GlossaryModel>>> getGlossaryData({
    required String contentid,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    // ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, dynamic>>(
      restCallType: RestCallType.simpleGetCall,
      queryParameters: {
        "contentid": contentid,
      },
      parsingType: ModelDataParsingType.glossaryModelList,
      url: apiEndpoints.getGlossaryJsonData(),
    );

    DataResponseModel<List<GlossaryModel>> apiResponseModel = await apiController.callApi<List<GlossaryModel>>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<EventTrackResourceResponseModel>> getResourcesData({
    required String contentid,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    // ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, dynamic>>(
      restCallType: RestCallType.simpleGetCall,
      queryParameters: {
        "contentid": contentid,
      },
      parsingType: ModelDataParsingType.eventTrackResourceResponseModel,
      url: apiEndpoints.getEventTrackResourcesData(),
    );

    DataResponseModel<EventTrackResourceResponseModel> apiResponseModel = await apiController.callApi<EventTrackResourceResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<TrackListViewDataResponseModel>> getTrackListViewData({required TrackListViewDataRequestModel requestModel}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
    requestModel.localeID = apiUrlConfigurationProvider.getLocale();
    requestModel.userID = apiUrlConfigurationProvider.getCurrentUserId().toString();
    requestModel.siteID = apiUrlConfigurationProvider.getCurrentSiteId().toString();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, dynamic>>(
      restCallType: RestCallType.simpleGetCall,
      queryParameters: requestModel.toJson(),
      parsingType: ModelDataParsingType.TrackListViewDataResponseModel,
      url: apiEndpoints.getGetTrackListViewData(),
    );

    DataResponseModel<TrackListViewDataResponseModel> apiResponseModel = await apiController.callApi<TrackListViewDataResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<ResourceContentDTOModel>> getEventRelatedContentsData({required EventRelatedContentsDataRequestModel requestModel}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
    requestModel.Locale = apiUrlConfigurationProvider.getLocale();
    requestModel.UserID = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.SiteID = apiUrlConfigurationProvider.getCurrentSiteId();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, dynamic>>(
      restCallType: RestCallType.simpleGetCall,
      queryParameters: requestModel.toJson(),
      parsingType: ModelDataParsingType.ResourceContentDTOModel,
      url: apiEndpoints.getEventRelatedContentsDataUrl(),
    );

    DataResponseModel<ResourceContentDTOModel> apiResponseModel = await apiController.callApi<ResourceContentDTOModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }
}
