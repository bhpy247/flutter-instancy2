import 'package:flutter_instancy_2/backend/common/common_provider.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/data_model/ask_the_expert_dto.dart';

import '../../models/ask_the_expert/response_model/filter_user_skills_dto.dart';
import '../../models/common/pagination/pagination_model.dart';
import '../filter/filter_provider.dart';

class AskTheExpertProvider extends CommonProvider {
  AskTheExpertProvider() {
    pageSize = CommonProviderPrimitiveParameter<int>(
      value: 10,
      notify: notify,
    );
    filterEnabled = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    sortEnabled = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    isLoading = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    questionListMap = CommonProviderMapParameter<int, UserQuestionListDto>(
      map: <int, UserQuestionListDto>{},
      notify: notify,
    );

    questionList = CommonProviderListParameter<UserQuestionListDto>(
      list: <UserQuestionListDto>[],
      notify: notify,
    );
    filterSkillsList = CommonProviderListParameter<FilterSkills>(
      list: <FilterSkills>[],
      notify: notify,
    );
    userFilterSkillsList = CommonProviderListParameter<UserFilterSkills>(
      list: <UserFilterSkills>[],
      notify: notify,
    );
    questionId = CommonProviderPrimitiveParameter<String>(
      value: "",
      notify: notify,
    );
    sortingData = CommonProviderPrimitiveParameter<String>(
      value: "CreatedDate Desc",
      notify: notify,
    );
    filterCategoriesIds = CommonProviderPrimitiveParameter<String>(
      value: "",
      notify: notify,
    );
    questionListSearchString = CommonProviderPrimitiveParameter<String>(
      value: "",
      notify: notify,
    );
    maxQuestionListCount = CommonProviderPrimitiveParameter<int>(
      value: 0,
      notify: notify,
    );
    questionListPaginationModel = CommonProviderPrimitiveParameter<PaginationModel>(
      value: PaginationModel(
        pageIndex: 1,
        pageSize: 10,
        refreshLimit: 3,
      ),
      notify: notify,
    );
  }

  late CommonProviderPrimitiveParameter<int> pageSize;
  late CommonProviderPrimitiveParameter<bool> filterEnabled;
  late CommonProviderPrimitiveParameter<bool> sortEnabled;
  late CommonProviderPrimitiveParameter<bool> isLoading;

  late CommonProviderMapParameter<int, UserQuestionListDto> questionListMap;

  late final CommonProviderPrimitiveParameter<String> sortingData;

  late CommonProviderListParameter<UserQuestionListDto> questionList;
  late CommonProviderListParameter<FilterSkills> filterSkillsList;
  late CommonProviderListParameter<UserFilterSkills> userFilterSkillsList;
  late final CommonProviderPrimitiveParameter<String> questionId;
  late final CommonProviderPrimitiveParameter<String> questionListSearchString;
  late final CommonProviderPrimitiveParameter<String> filterCategoriesIds;
  late final CommonProviderPrimitiveParameter<String> myQuestionCategoriesIds;
  late final CommonProviderPrimitiveParameter<int> maxQuestionListCount;
  late final CommonProviderPrimitiveParameter<PaginationModel> questionListPaginationModel;
  final FilterProvider filterProvider = FilterProvider();

  void resetData() {
    questionListMap.setMap(map: {}, isClear: true, isNotify: false);
    pageSize.set(value: 10, isNotify: false);
    filterEnabled.set(value: false, isNotify: false);
    sortEnabled.set(value: false, isNotify: false);
    isLoading.set(value: false, isNotify: false);

    questionList.setList(list: [], isNotify: false);
    filterSkillsList.setList(list: [], isNotify: false);
    userFilterSkillsList.setList(list: [], isNotify: false);
    questionId.set(value: "", isNotify: false);
    filterCategoriesIds.set(value: "", isNotify: false);
    questionListSearchString.set(value: "", isNotify: false);
    maxQuestionListCount.set(value: 0, isNotify: false);
    questionListPaginationModel.set(
      value: PaginationModel(
        pageIndex: 1,
        pageSize: 10,
        refreshLimit: 3,
      ),
      isNotify: false,
    );
    sortingData.set(value: "CreatedDate Desc", isNotify: false);
  }
}
