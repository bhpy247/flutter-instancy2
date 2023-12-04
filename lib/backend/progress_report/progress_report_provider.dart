import 'package:flutter_instancy_2/backend/common/common_provider.dart';
import 'package:flutter_instancy_2/models/progress_report/data_model/consolidated_group_dto.dart';

import '../../models/progress_report/data_model/content_progress_details_question_data_model.dart';
import '../../models/progress_report/data_model/content_progress_summary_data_model.dart.dart';

class ProgressReportProvider extends CommonProvider {
  ProgressReportProvider() {
    contentProgressDetailsQuestionsData = CommonProviderListParameter<ContentProgressDetailsQuestionDataModel>(
      list: [],
      notify: notify,
    );
    isLoadingContentProgressDetailsQuestionsData = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    contentMyLearningSummaryData = CommonProviderPrimitiveParameter<ContentProgressSummaryDataModel?>(
      value: null,
      notify: notify,
    );
    consolidatedGroupDTO = CommonProviderPrimitiveParameter<ConsolidatedGroupDTO?>(
      value: null,
      notify: notify,
    );
    isLoadingContentMyLearningSummaryData = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    isLoadingMyProgressReportData = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    filterSelectedString = CommonProviderPrimitiveParameter<String>(
      value: "All",
      notify: notify,
    );
  }

  late final CommonProviderListParameter<ContentProgressDetailsQuestionDataModel> contentProgressDetailsQuestionsData;
  late final CommonProviderPrimitiveParameter<bool> isLoadingContentProgressDetailsQuestionsData;

  late final CommonProviderPrimitiveParameter<ContentProgressSummaryDataModel?> contentMyLearningSummaryData;
  late final CommonProviderPrimitiveParameter<ConsolidatedGroupDTO?> consolidatedGroupDTO;
  late final CommonProviderPrimitiveParameter<bool> isLoadingContentMyLearningSummaryData;
  late final CommonProviderPrimitiveParameter<bool> isLoadingMyProgressReportData;
  late final CommonProviderPrimitiveParameter<String> filterSelectedString;

  void resetData() {
    contentProgressDetailsQuestionsData.setList(list: [], isClear: true, isNotify: false);
    isLoadingContentProgressDetailsQuestionsData.set(value: false, isNotify: false);
    contentMyLearningSummaryData.set(value: null, isNotify: false);
    consolidatedGroupDTO.set(value: null, isNotify: false);
    isLoadingContentMyLearningSummaryData.set(value: false, isNotify: true);
    isLoadingMyProgressReportData.set(value: false, isNotify: true);
    filterSelectedString.set(value: "All", isNotify: true);
  }
}
