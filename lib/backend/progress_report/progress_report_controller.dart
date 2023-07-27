import 'package:flutter_instancy_2/models/progress_report/data_model/content_progress_details_question_data_model.dart';
import 'package:flutter_instancy_2/models/progress_report/data_model/content_progress_summary_data_model.dart.dart';
import 'package:flutter_instancy_2/models/progress_report/request_model/content_progress_details_data_request_model.dart';
import 'package:flutter_instancy_2/models/progress_report/request_model/content_progress_summary_data_request_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';

import '../../api/api_controller.dart';
import '../../models/common/data_response_model.dart';
import '../../models/progress_report/request_model/mylearning_content_progress_summary_data_request_model.dart';
import '../../models/progress_report/response_model/content_progress_detail_data_response.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';
import 'progress_report_provider.dart';
import 'progress_report_repository.dart';

class ProgressReportController {
  late ProgressReportProvider _progressReportProvider;
  late ProgressReportRepository _progressReportRepository;

  ProgressReportController({required ProgressReportProvider? progressReportProvider, ProgressReportRepository? repository, ApiController? apiController}) {
    _progressReportProvider = progressReportProvider ?? ProgressReportProvider();
    _progressReportRepository = repository ?? ProgressReportRepository(apiController: apiController ?? ApiController());
  }
  
  ProgressReportProvider get progressReportProvider => _progressReportProvider;
  ProgressReportRepository get progressReportRepository => _progressReportRepository;

  Future<List<ContentProgressDetailsQuestionDataModel>> getContentProgressDetailsData({
    required ContentProgressDetailsDataRequestModel requestModel,
    bool isNotify = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("ProgressReportController().getContentProgressDetailsData() called with requestModel:'$requestModel'", tag: tag);

    ProgressReportProvider provider = progressReportProvider;

    List<ContentProgressDetailsQuestionDataModel> progressDetailsData = <ContentProgressDetailsQuestionDataModel>[];

    if(requestModel.startDate == null && requestModel.endDate == null) {
      DateTime now = DateTime.now();
      requestModel.startDate = now.subtract(const Duration(days: 10));
      requestModel.endDate = now;
    }

    provider.isLoadingContentProgressDetailsQuestionsData.set(value: true, isNotify: isNotify);

    DataResponseModel<ContentProgressDetailDataResponseModel> response = await progressReportRepository.getContentProgressDetailsData(requestModel: requestModel);
    MyPrint.printOnConsole("getProgressDetailsData response:$response", tag: tag);

    provider.isLoadingContentProgressDetailsQuestionsData.set(value: false, isNotify: isNotify);

    if(response.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from ProgressReportController().getContentProgressDetailsData() because getProgressDetailsData had some error", tag: tag);
      return progressDetailsData;
    }

    if(response.data?.progressDetail != null) {
      progressDetailsData = response.data!.progressDetail;
    }
    MyPrint.printOnConsole("final ContentProgressDetailsData:$progressDetailsData", tag: tag);

    provider.contentProgressDetailsQuestionsData.setList(list: progressDetailsData);

    return progressDetailsData;
  }

  Future<ContentProgressSummaryDataModel?> getContentProgressSummaryData({required ContentProgressSummaryDataRequestModel requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("ProgressReportController().getContentProgressSummaryData() called with requestModel:'$requestModel'", tag: tag);

    ContentProgressSummaryDataModel? contentProgressSummaryDataModel;

    DataResponseModel<List<ContentProgressSummaryDataModel>> response = await progressReportRepository.getContentProgressSummaryData(requestModel: requestModel);
    MyPrint.printOnConsole("getContentProgressSummaryData response:$response", tag: tag);

    if(response.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from ProgressReportController().getContentProgressSummaryData() because getContentProgressSummaryData had some error", tag: tag);
      return contentProgressSummaryDataModel;
    }

    contentProgressSummaryDataModel = response.data?.firstElement;
    MyPrint.printOnConsole("final contentProgressSummaryDataModel:$contentProgressSummaryDataModel", tag: tag);

    return contentProgressSummaryDataModel;
  }

  Future<ContentProgressSummaryDataModel?> getMyLearningContentProgressSummaryData({
    required MyLearningContentProgressSummaryDataRequestModel requestModel,
    bool isNotify = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("ProgressReportController().getMyLearningContentProgressSummaryData() called with requestModel:'$requestModel'", tag: tag);

    ProgressReportProvider provider = progressReportProvider;

    ContentProgressSummaryDataModel? contentProgressSummaryDataModel;

    if(requestModel.startDate == null && requestModel.endDate == null) {
      DateTime now = DateTime.now();
      requestModel.startDate = now.subtract(const Duration(days: 10));
      requestModel.endDate = now;
    }

    provider.isLoadingContentMyLearningSummaryData.set(value: true, isNotify: isNotify);

    DataResponseModel<List<ContentProgressSummaryDataModel>> response = await progressReportRepository.getMylearningContentProgressSummaryData(requestModel: requestModel);
    MyPrint.printOnConsole("getMylearningContentProgressSummaryData response:$response", tag: tag);

    provider.isLoadingContentMyLearningSummaryData.set(value: false, isNotify: isNotify);

    if(response.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from ProgressReportController().getMyLearningContentProgressSummaryData() because getMylearningContentProgressSummaryData had some error", tag: tag);
      return contentProgressSummaryDataModel;
    }

    contentProgressSummaryDataModel = response.data?.firstElement;
    MyPrint.printOnConsole("final contentProgressSummaryDataModel:$contentProgressSummaryDataModel", tag: tag);

    provider.contentMyLearningSummaryData.set(value: contentProgressSummaryDataModel);

    return contentProgressSummaryDataModel;
  }
}