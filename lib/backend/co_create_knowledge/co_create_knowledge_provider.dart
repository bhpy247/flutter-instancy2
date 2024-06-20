import 'package:flutter_instancy_2/backend/common/common_provider.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/response_model/avatar_voice_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/response_model/avtar_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/response_model/background_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/podcast/response_model/language_response_model.dart';
import 'package:flutter_instancy_2/models/filter/data_model/content_filter_category_tree_model.dart';

import '../../models/co_create_knowledge/podcast/response_model/language_voice_model.dart';
import '../../models/course/data_model/CourseDTOModel.dart';
import '../filter/filter_provider.dart';

class CoCreateKnowledgeProvider extends CommonProvider {
  CoCreateKnowledgeProvider() {
    skills = CommonProviderListParameter<ContentFilterCategoryTreeModel>(
      list: <ContentFilterCategoryTreeModel>[],
      notify: notify,
    );

    isLoadingMyKnowledge = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    myKnowledgeList = CommonProviderListParameter<CourseDTOModel>(
      list: <CourseDTOModel>[],
      notify: notify,
    );

    isLoadingSharedKnowledge = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    sharedKnowledgeList = CommonProviderListParameter<CourseDTOModel>(
      list: <CourseDTOModel>[],
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

    generatedVideoUrl = CommonProviderPrimitiveParameter<String>(
      value: "",
      notify: notify,
    );

    languageList = CommonProviderListParameter<LanguageModel>(
      list: [],
      notify: notify,
    );
    languageVoiceList = CommonProviderListParameter<LanguageVoiceModel>(
      list: [],
      notify: notify,
    );
    audioUrlFromApi = CommonProviderPrimitiveParameter(
      value: "",
      notify: notify,
    );
  }

  late CommonProviderListParameter<ContentFilterCategoryTreeModel> skills;

  late final CommonProviderPrimitiveParameter<String> generatedVideoUrl;

  late CommonProviderPrimitiveParameter<bool> isLoadingMyKnowledge;
  late CommonProviderListParameter<CourseDTOModel> myKnowledgeList;

  late CommonProviderPrimitiveParameter<bool> isLoadingSharedKnowledge;
  late CommonProviderListParameter<CourseDTOModel> sharedKnowledgeList;

  late final CommonProviderListParameter<Avatars> avatarList;
  late final CommonProviderListParameter<BackgroundColorModel> backgroundColorList;
  late final CommonProviderListParameter<AvtarVoiceModel> avatarVoiceList;
  late final CommonProviderListParameter<LanguageModel> languageList;
  late final CommonProviderListParameter<LanguageVoiceModel> languageVoiceList;
  late final CommonProviderPrimitiveParameter<String> audioUrlFromApi;

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
    skills.setList(list: <ContentFilterCategoryTreeModel>[], isClear: true, isNotify: false);

    isLoadingMyKnowledge.set(value: false, isNotify: false);
    myKnowledgeList.setList(list: [], isNotify: false);

    isLoadingSharedKnowledge.set(value: false, isNotify: false);
    sharedKnowledgeList.setList(list: [], isNotify: false);

    avatarVoiceList.setList(list: [], isNotify: false);
    backgroundColorList.setList(list: [], isNotify: false);
    avatarList.setList(list: [], isNotify: false);
    languageList.setList(list: [], isNotify: false);
    languageVoiceList.setList(list: [], isNotify: false);
    generatedVideoUrl.set(value: "", isNotify: false);
    audioUrlFromApi.set(value: "", isNotify: false);
  }
}
