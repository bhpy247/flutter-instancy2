import 'package:flutter_instancy_2/models/progress_report/data_model/consolidated_group_dto.dart';

import '../../api/api_call_model.dart';
import '../../api/api_controller.dart';
import '../../api/api_endpoints.dart';
import '../../api/api_url_configuration_provider.dart';
import '../../api/rest_client.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/model_data_parser.dart';
import '../../models/progress_report/data_model/content_progress_summary_data_model.dart.dart';
import '../../models/progress_report/request_model/content_progress_details_data_request_model.dart';
import '../../models/progress_report/request_model/content_progress_summary_data_request_model.dart';
import '../../models/progress_report/request_model/my_progress_report_request_model.dart';
import '../../models/progress_report/request_model/mylearning_content_progress_summary_data_request_model.dart';
import '../../models/progress_report/response_model/content_progress_detail_data_response.dart';

class ProgressReportRepository {
  final ApiController apiController;

  const ProgressReportRepository({required this.apiController});

  Future<DataResponseModel<ContentProgressDetailDataResponseModel>> getContentProgressDetailsData({
    required ContentProgressDetailsDataRequestModel requestModel,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.siteId = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.locale = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      queryParameters: requestModel.toMap(),
      parsingType: ModelDataParsingType.progressDetailDataResponseModel,
      url: apiEndpoints.getContentProgressDetailDataUrl(),
    );

    DataResponseModel<ContentProgressDetailDataResponseModel> apiResponseModel = await apiController.callApi<ContentProgressDetailDataResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<List<ContentProgressSummaryDataModel>>> getContentProgressSummaryData({
    required ContentProgressSummaryDataRequestModel requestModel,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.siteId = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.locale = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      queryParameters: requestModel.toMap(),
      parsingType: ModelDataParsingType.contentProgressSummaryDataModelList,
      url: apiEndpoints.getContentProgressSummaryDataUrl(),
    );

    DataResponseModel<List<ContentProgressSummaryDataModel>> apiResponseModel = await apiController.callApi<List<ContentProgressSummaryDataModel>>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<List<ContentProgressSummaryDataModel>>> getMylearningContentProgressSummaryData({
    required MyLearningContentProgressSummaryDataRequestModel requestModel,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.siteId = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.locale = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      queryParameters: requestModel.toMap(),
      parsingType: ModelDataParsingType.contentProgressSummaryDataModelList,
      url: apiEndpoints.getMyLearningContentProgressSummaryDataUrl(),
    );

    DataResponseModel<List<ContentProgressSummaryDataModel>> apiResponseModel = await apiController.callApi<List<ContentProgressSummaryDataModel>>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<List<ConsolidatedGroupDTO>>> getMyProgressReportData({
    required MyProgressReportRequestModel requestModel,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.aintSiteID = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.aintUserID = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.astrLocale = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      queryParameters: requestModel.toMap(),
      parsingType: ModelDataParsingType.ConsolidatedGroupDTO,
      url: apiEndpoints.getMyProgressReportUrl(),
    );

    DataResponseModel<List<ConsolidatedGroupDTO>> apiResponseModel = await apiController.callApi<List<ConsolidatedGroupDTO>>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }
}
