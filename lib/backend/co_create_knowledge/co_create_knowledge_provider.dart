import 'package:flutter_instancy_2/backend/common/common_provider.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/response_model/avatar_voice_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/response_model/avtar_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/response_model/background_response_model.dart';

import '../../models/common/pagination/pagination_model.dart';
import '../../models/course/data_model/CourseDTOModel.dart';
import '../filter/filter_provider.dart';

class CoCreateKnowledgeProvider extends CommonProvider {
  CoCreateKnowledgeProvider() {
    pageSize = CommonProviderPrimitiveParameter<int>(
      value: 500,
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

    myKnowledgeList = CommonProviderListParameter<CourseDTOModel>(
      list: <CourseDTOModel>[],
      notify: notify,
    );
    shareKnowledgeList = CommonProviderListParameter<CourseDTOModel>(
      list: <CourseDTOModel>[],
      notify: notify,
    );
    sortingData = CommonProviderPrimitiveParameter<String>(
      value: "CreatedDate Desc",
      notify: notify,
    );
    avatarList = CommonProviderListParameter<Avatars>(
      list: <Avatars>[],
      notify: notify,
    );
    backgroundColorList = CommonProviderListParameter<BackgroundColorModel>(
      list: <BackgroundColorModel>[],
      notify: notify,
    );
    avatarVoiceList = CommonProviderListParameter<AvtarVoiceModel>(
      list: <AvtarVoiceModel>[],
      notify: notify,
    );

    allLearningCommunitiesSearchString = CommonProviderPrimitiveParameter<String>(
      value: "",
      notify: notify,
    );
    maxAllLearningCommunitiesListCount = CommonProviderPrimitiveParameter<int>(
      value: 0,
      notify: notify,
    );
    allLearningCommunitiesPaginationModel = CommonProviderPrimitiveParameter<PaginationModel>(
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

  late final CommonProviderPrimitiveParameter<String> sortingData;

  late CommonProviderListParameter<CourseDTOModel> myKnowledgeList;
  late CommonProviderListParameter<CourseDTOModel> shareKnowledgeList;
  late final CommonProviderPrimitiveParameter<String> allLearningCommunitiesSearchString;
  late final CommonProviderPrimitiveParameter<int> maxAllLearningCommunitiesListCount;
  late final CommonProviderPrimitiveParameter<PaginationModel> allLearningCommunitiesPaginationModel;
  late final CommonProviderListParameter<Avatars> avatarList;
  late final CommonProviderListParameter<BackgroundColorModel> backgroundColorList;
  late final CommonProviderListParameter<AvtarVoiceModel> avatarVoiceList;

  final FilterProvider filterProvider = FilterProvider();

  void addToMyKnowledgeList(CourseDTOModel model) {
    List<CourseDTOModel> modelList = myKnowledgeList.getList();
    modelList.add(model);
    myKnowledgeList.setList(list: modelList);
    notify();
  }

  void updateMyKnowledgeListModel(CourseDTOModel model, int index) {
    List<CourseDTOModel> modelList = myKnowledgeList.getList();
    modelList.removeAt(index);
    modelList.insert(index, model);
    myKnowledgeList.setList(list: modelList);
    notify();
  }

  void resetData() {
    pageSize.set(value: 10, isNotify: false);
    filterEnabled.set(value: false, isNotify: false);
    sortEnabled.set(value: false, isNotify: false);
    isLoading.set(value: false, isNotify: false);

    myKnowledgeList.setList(list: [], isNotify: false);
    shareKnowledgeList.setList(list: [], isNotify: false);
    allLearningCommunitiesSearchString.set(value: "", isNotify: false);
    maxAllLearningCommunitiesListCount.set(value: 0, isNotify: false);
    allLearningCommunitiesPaginationModel.set(
      value: PaginationModel(
        pageIndex: 1,
        pageSize: 10,
        refreshLimit: 3,
      ),
      isNotify: false,
    );
    sortingData.set(value: "CreatedDate Desc", isNotify: false);

    avatarVoiceList.setList(list: [], isNotify: false);
    backgroundColorList.setList(list: [], isNotify: false);
    avatarList.setList(list: [], isNotify: false);
  }
}
