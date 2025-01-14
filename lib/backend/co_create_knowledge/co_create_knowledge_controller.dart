import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/api/api_url_configuration_provider.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/app/dependency_injection.dart';
import 'package:flutter_instancy_2/backend/ask_the_expert/ask_the_expert_repository.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/app_ststem_configurations.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/local_str.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/data_model/user_question_skill_model.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/response_model/user_question_skills_response_model.dart';
import 'package:flutter_instancy_2/models/catalog/response_model/catalog_dto_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/article/data_model/article_content_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/co_create_content_authoring_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/request_model/create_new_content_item_formdata_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/request_model/create_new_content_item_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/request_model/delete_co_create_content_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/request_model/generate_images_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/request_model/get_co_create_knowledgebase_list_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/request_model/native_authoring_get_module_names_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/request_model/native_authoring_get_resources_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/request_model/save_content_json_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/request_model/share_co_create_knowledge_base_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/response_model/avatar_voice_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/response_model/avtar_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/response_model/background_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/response_model/native_authoring_get_module_names_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/response_model/native_authoring_get_resources_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/event/data_model/event_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/flashcards/data_model/flashcard_content_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/flashcards/request_model/flashcard_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/flashcards/response_model/generated_flashcard_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/micro_learning_model/data_model/micro_learning_content_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/micro_learning_model/data_model/micro_learning_page_element_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/micro_learning_model/data_model/micro_learningt_page_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/podcast/data_model/podcast_content_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/podcast/response_model/language_voice_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/podcast/response_model/speaking_style_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/data_models/quiz_content_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/data_models/quiz_question_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/request_model/assessment_generate_content_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/request_model/generate_assessment_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/request_model/quiz_generate_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/response_model/assessment_generate_content_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/response_model/generate_assessment_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/roleplay/data_models/roleplay_content_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/video/data_model/video_content_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/video/request_model/generate_video_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/video/response_model/video_detail_response_model.dart';
import 'package:flutter_instancy_2/models/common/Instancy_multipart_file_upload_model.dart';
import 'package:flutter_instancy_2/models/common/data_response_model.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/models/filter/data_model/content_filter_category_tree_model.dart';
import 'package:flutter_instancy_2/models/profile/data_model/user_profile_details_model.dart';
import 'package:flutter_instancy_2/utils/date_representation.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/views/common/components/common_confirmation_dialog.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../api/api_controller.dart';
import '../../models/co_create_knowledge/article/request_model/generate_whole_article_content_request_model.dart';
import '../../models/co_create_knowledge/article/response_model/article_response_model.dart';
import '../../models/co_create_knowledge/learning_path/data_model/learning_path_content_model.dart';
import '../../models/co_create_knowledge/podcast/request_model/play_audio_for_text_request_model.dart';
import '../../models/co_create_knowledge/podcast/response_model/language_response_model.dart';
import 'co_create_knowledge_provider.dart';
import 'co_create_knowledge_repository.dart';

class CoCreateKnowledgeController {
  late CoCreateKnowledgeProvider _coCreateKnowledgeProvider;
  late CoCreateKnowledgeRepository _coCreateKnowledgeRepository;

  CoCreateKnowledgeController({
    required CoCreateKnowledgeProvider? coCreateKnowledgeProvider,
    CoCreateKnowledgeRepository? repository,
    ApiController? apiController,
  }) {
    _coCreateKnowledgeProvider = coCreateKnowledgeProvider ?? CoCreateKnowledgeProvider();
    _coCreateKnowledgeRepository = repository ?? CoCreateKnowledgeRepository(apiController: apiController ?? ApiController());
  }

  CoCreateKnowledgeProvider get coCreateKnowledgeProvider => _coCreateKnowledgeProvider;

  CoCreateKnowledgeRepository get coCreateKnowledgeRepository => _coCreateKnowledgeRepository;

  Future<void> getSkillsList() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().getSkillsList() called", tag: tag);

    CoCreateKnowledgeProvider provider = coCreateKnowledgeProvider;
    CoCreateKnowledgeRepository repository = coCreateKnowledgeRepository;

    DataResponseModel<UserQuestionSkillsResponseModel> dataResponseModel = await AskTheExpertRepository(apiController: repository.apiController).getUserSkills();

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from FilterController().getContentFilterCategoryTree() because appErrorModel is not null", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);
      return;
    } else if (dataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from FilterController().getContentFilterCategoryTree() because data is null", tag: tag);
      return;
    }

    UserQuestionSkillsResponseModel responseModel = dataResponseModel.data!;
    List<UserQuestionSkillModel> list = responseModel.Table;
    MyPrint.printOnConsole("list length:${list.length}", tag: tag);

    List<ContentFilterCategoryTreeModel> finalList = list.map((e) {
      return ContentFilterCategoryTreeModel(
        categoryId: e.PreferrenceID.toString(),
        categoryName: e.PreferrenceTitle,
      );
    }).toList();

    provider.skills.setList(list: finalList, isClear: true, isNotify: true);

    MyPrint.printOnConsole("Final Skills Length in Provider:${provider.skills.length}", tag: tag);
  }

  Future<bool> getMyKnowledgeList({GetCoCreateKnowledgebaseListRequestModel? requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().getMyKnowledgeList() called with requestModel:$requestModel", tag: tag);

    CoCreateKnowledgeProvider provider = coCreateKnowledgeProvider;
    provider.isLoadingMyKnowledge.set(value: true, isNotify: false);

    if (requestModel == null) {
      MyPrint.printOnConsole("Initializing requestModel", tag: tag);

      ApiUrlConfigurationProvider apiUrlConfigurationProvider = coCreateKnowledgeRepository.apiController.apiDataProvider;
      AppSystemConfigurationModel appSystemConfigurationModel = DependencyInjection.appProvider.appSystemConfigurationModel;

      requestModel = GetCoCreateKnowledgebaseListRequestModel(
        userId: apiUrlConfigurationProvider.getCurrentUserId(),
        cmsGroupId: appSystemConfigurationModel.CoCreateKnowledgeDefaultCMSGroupID,
        folderId: appSystemConfigurationModel.CoCreateKnowledgeDefaultFolderID,
      );

      MyPrint.printOnConsole("Final requestModel", tag: tag);
    }

    DataResponseModel<CatalogResponseDTOModel> dataResponseModel = await coCreateKnowledgeRepository.getMyKnowledgeList2(requestModel: requestModel);
    // DataResponseModel<List<CourseDTOModel>> dataResponseModel = await coCreateKnowledgeRepository.getMyKnowledgeList(requestModel: requestModel);
    // DataResponseModel<List<CourseDTOModel>> dataResponseModel = await coCreateKnowledgeRepository.getMyKnowledgeListTemp(requestModel: requestModel);

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getMyKnowledgeList() because appErrorModel is not null", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);

      provider.isLoadingMyKnowledge.set(value: false, isNotify: false);
      provider.myKnowledgeList.setList(list: <CourseDTOModel>[]);

      return false;
    } else if (dataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getMyKnowledgeList() because data is null", tag: tag);

      provider.isLoadingMyKnowledge.set(value: false, isNotify: false);
      provider.myKnowledgeList.setList(list: <CourseDTOModel>[]);

      return false;
    }

    List<CourseDTOModel> contentsList = dataResponseModel.data?.CourseList ?? <CourseDTOModel>[];
    MyPrint.printOnConsole("MyKnowledge Contents Length got in Api:${contentsList.length}", tag: tag);

    provider.isLoadingMyKnowledge.set(value: false, isNotify: false);
    provider.myKnowledgeList.setList(list: contentsList);

    MyPrint.printOnConsole("Final myKnowledgeList length:${provider.myKnowledgeList.length}", tag: tag);

    return true;
  }

  Future<bool> getSharedKnowledgeList({GetCoCreateKnowledgebaseListRequestModel? requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().getSharedKnowledgeList() called with requestModel:$requestModel", tag: tag);

    CoCreateKnowledgeProvider provider = coCreateKnowledgeProvider;
    provider.isLoadingSharedKnowledge.set(value: true, isNotify: false);

    if (requestModel == null) {
      MyPrint.printOnConsole("Initializing requestModel", tag: tag);

      ApiUrlConfigurationProvider apiUrlConfigurationProvider = coCreateKnowledgeRepository.apiController.apiDataProvider;
      AppSystemConfigurationModel appSystemConfigurationModel = DependencyInjection.appProvider.appSystemConfigurationModel;

      requestModel = GetCoCreateKnowledgebaseListRequestModel(
        userId: apiUrlConfigurationProvider.getCurrentUserId(),
        cmsGroupId: appSystemConfigurationModel.CoCreateKnowledgeDefaultCMSGroupID,
        folderId: appSystemConfigurationModel.CoCreateKnowledgeDefaultFolderID,
      );

      MyPrint.printOnConsole("Final requestModel", tag: tag);
    }

    requestModel.componentId = InstancyComponents.CoCreateKnowledgeComponent;

    DataResponseModel<CatalogResponseDTOModel> dataResponseModel = await coCreateKnowledgeRepository.getMyKnowledgeList2(requestModel: requestModel);
    // DataResponseModel<List<CourseDTOModel>> dataResponseModel = await coCreateKnowledgeRepository.getMyKnowledgeList(requestModel: requestModel);
    // DataResponseModel<List<CourseDTOModel>> dataResponseModel = await coCreateKnowledgeRepository.getMyKnowledgeListTemp(requestModel: requestModel);

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getSharedKnowledgeList() because appErrorModel is not null", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);

      provider.isLoadingSharedKnowledge.set(value: false, isNotify: false);
      provider.sharedKnowledgeList.setList(list: <CourseDTOModel>[]);

      return false;
    } else if (dataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getSharedKnowledgeList() because data is null", tag: tag);

      provider.isLoadingSharedKnowledge.set(value: false, isNotify: false);
      provider.sharedKnowledgeList.setList(list: <CourseDTOModel>[]);

      return false;
    }

    List<CourseDTOModel> contentsList = dataResponseModel.data?.CourseList ?? <CourseDTOModel>[];
    MyPrint.printOnConsole("ShareKnowledge Contents Length got in Api:${contentsList.length}", tag: tag);

    provider.isLoadingSharedKnowledge.set(value: false, isNotify: false);
    provider.sharedKnowledgeList.setList(list: contentsList);

    MyPrint.printOnConsole("Final shareKnowledgeList length:${provider.sharedKnowledgeList.length}", tag: tag);

    return true;
  }

  Future<List<Uint8List>> generateImagesFromAi({required GenerateImagesRequestModel requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().generateImagesFromAi() called with requestModel:$requestModel", tag: tag);

    List<Uint8List> images = <Uint8List>[];

    DataResponseModel<List<String>> dataResponseModel = await CoCreateKnowledgeRepository(apiController: ApiController()).generateImage(requestModel: requestModel);
    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateImagesFromAi() because appErrorModel is not null", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);
      return images;
    } else if (dataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateImagesFromAi() because data is null", tag: tag);
      return images;
    }

    MyPrint.printOnConsole("Got Images Data", tag: tag);

    List<String> base64EncodedImages = dataResponseModel.data!;

    for (String base64ImageString in base64EncodedImages) {
      Uint8List? bytes = MyUtils.convertBase64ToBytes(base64ImageString);
      if (bytes.checkNotEmpty) images.add(bytes!);
    }

    MyPrint.printOnConsole("Final images length:${images.length}", tag: tag);

    return images;
  }

  //region Add/Edit Content
  Future<String?> CreateNewContentItem({required CreateNewContentItemRequestModel requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().CreateNewContentItem() called with requestModel:$requestModel", tag: tag);

    CoCreateKnowledgeRepository repository = coCreateKnowledgeRepository;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = repository.apiController.apiDataProvider;
    String authorName = "";

    UserProfileDetailsModel? userProfileDetailsModel = DependencyInjection.profileProvider.userProfileDetails.getList(isNewInstance: false).firstElement;
    if (userProfileDetailsModel != null) {
      authorName = "${userProfileDetailsModel.firstname} ${userProfileDetailsModel.lastname}";
    }

    AppSystemConfigurationModel appSystemConfigurationModel = DependencyInjection.appProvider.appSystemConfigurationModel;

    requestModel.authorName = authorName;
    requestModel.UserID = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.SiteID = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.FolderID = appSystemConfigurationModel.CoCreateKnowledgeDefaultFolderID;
    requestModel.CMSGroupID = appSystemConfigurationModel.CoCreateKnowledgeDefaultCMSGroupID;
    requestModel.Language = apiUrlConfigurationProvider.getLocale();

    DataResponseModel<String> dataResponseModel = await repository.CreateNewContentItem(requestModel: requestModel);
    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().CreateNewContentItem() because appErrorModel is not null for CreateNewContentItem", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);
      return null;
    } else if (dataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().CreateNewContentItem() because data is null for CreateNewContentItem", tag: tag);
      return null;
    }

    String contentId = dataResponseModel.data!;
    MyPrint.printOnConsole("Final contentId:'$contentId'", tag: tag);

    if (contentId.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().CreateNewContentItem() because Content couldn't be created/updated", tag: tag);
      return null;
    } else if (requestModel.ContentID.isNotEmpty && contentId != requestModel.ContentID) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().CreateNewContentItem() because Content Update Failed, Response:'$contentId'", tag: tag);
      return null;
    }

    if (requestModel.ActionType == CreateNewContentItemActionType.update) {
      SaveContentJsonRequestModel saveContentJsonRequestModel = SaveContentJsonRequestModel(
        contentId: requestModel.ContentID,
        folderPath: requestModel.FolderPath,
        objectTypeId: requestModel.ObjectTypeID,
        mediaTypeId: requestModel.MediaTypeID,
        contentData: requestModel.additionalData,
      );

      bool isSaved = await SaveContentJSON(requestModel: saveContentJsonRequestModel);

      if (!isSaved) {
        MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().CreateNewContentItem() because SaveContentJSON failed", tag: tag);
        return null;
      }
    }

    return contentId;
  }

  Future<bool> SaveContentJSON({required SaveContentJsonRequestModel requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().SaveContentJSON() called with requestModel:$requestModel", tag: tag);

    List<String> typesToCallSaveContentJSONForUpdate = [
      "${InstancyObjectTypes.flashCard}_${InstancyMediaTypes.none}",
      "${InstancyObjectTypes.assessment}_${InstancyMediaTypes.test}",
      "${InstancyObjectTypes.events}_${InstancyMediaTypes.none}",
      "${InstancyObjectTypes.webPage}_${InstancyMediaTypes.none}",
      "${InstancyObjectTypes.contentObject}_${InstancyMediaTypes.microLearning}",
    ];
    if (!typesToCallSaveContentJSONForUpdate.contains("${requestModel.objectTypeId}_${requestModel.mediaTypeId}")) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().SaveContentJSON() with true because content type is not valid for update", tag: tag);
      return true;
    }

    if (requestModel.contentId.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().SaveContentJSON() because contentId is empty", tag: tag);
      return false;
    } else if (requestModel.folderPath.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().SaveContentJSON() because folderPath is empty", tag: tag);
      return false;
    }

    CoCreateKnowledgeRepository repository = coCreateKnowledgeRepository;

    DataResponseModel<String> dataResponseModel = await repository.SaveContentJSON(requestModel: requestModel);

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().SaveContentJSON() because appErrorModel is not null for SaveContentJSON", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);
      return false;
    } else if (dataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().SaveContentJSON() because data is null for SaveContentJSON", tag: tag);
      return false;
    }

    String response = dataResponseModel.data!;
    MyPrint.printOnConsole("Final SaveContentJSON response:'$response'", tag: tag);

    if (response != "1") {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().SaveContentJSON() because response is not 1 for SaveContentJSON", tag: tag);
      return false;
    }

    MyPrint.printOnConsole("ContentJSON Saved Successfully", tag: tag);
    return true;
  }

  Future<String?> addEditContentItem({required CoCreateContentAuthoringModel coCreateContentAuthoringModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
        "CoCreateKnowledgeController().addEditContentItem() called with ContentId:${coCreateContentAuthoringModel.contentId}, "
        "ContentTypeId:${coCreateContentAuthoringModel.contentTypeId}",
        tag: tag);

    CoCreateContentAuthoringModel newcoCreateContentAuthoringModel = coCreateContentAuthoringModel;

    // UserProfileDetailsModel? userProfileDetailsModel = DependencyInjection.profileProvider.userProfileDetails.getList(isNewInstance: false).firstElement;
    // if (userProfileDetailsModel != null) {
    //   authorName = "${userProfileDetailsModel.firstname} ${userProfileDetailsModel.lastname}";
    // }
    // if(newcoCreateContentAuthoringModel.newCurrentCourseDTOModel != null){
    //
    // }
    // newcoCreateContentAuthoringModel

    CreateNewContentItemRequestModel requestModel = getCreateNewContentItemRequestModelFromCoCreateContentAuthoringModel(coCreateContentAuthoringModel: coCreateContentAuthoringModel);

    String? contentId = await CreateNewContentItem(requestModel: requestModel);
    MyPrint.printOnConsole("Final contentId:'$contentId'", tag: tag);

    if (contentId.checkEmpty) {
      return null;
    }


    coCreateContentAuthoringModel.contentId = contentId!;

    initializeContentDataInCourseDTOModelFromCoCreateContentAuthoringModel(coCreateContentAuthoringModel: coCreateContentAuthoringModel);

    CourseDTOModel? courseDTOModel = coCreateContentAuthoringModel.courseDTOModel ?? coCreateContentAuthoringModel.newCurrentCourseDTOModel;
    if (courseDTOModel != null && !coCreateContentAuthoringModel.isEdit) {
      coCreateKnowledgeProvider.myKnowledgeList.setList(list: [courseDTOModel], isClear: false, isNotify: true);
    }

    return contentId;
  }

  CreateNewContentItemRequestModel getCreateNewContentItemRequestModelFromCoCreateContentAuthoringModel({required CoCreateContentAuthoringModel coCreateContentAuthoringModel}) {
    CoCreateKnowledgeProvider provider = coCreateKnowledgeProvider;
    CoCreateKnowledgeRepository repository = coCreateKnowledgeRepository;

    CreateNewContentItemFormDataModel createNewContentItemFormDataModel = CreateNewContentItemFormDataModel(
      Name: coCreateContentAuthoringModel.title,
      ShortDescription: coCreateContentAuthoringModel.description,
      // ThumbnailImagePath: coCreateContentAuthoringModel.ThumbnailImagePath,
      MediaTypeID: coCreateContentAuthoringModel.mediaTypeId.toString(),
      Language: repository.apiController.apiDataProvider.getLocale(),
      Bit3: coCreateContentAuthoringModel.contentTypeId == InstancyObjectTypes.reference && coCreateContentAuthoringModel.mediaTypeId == InstancyMediaTypes.url,
      StartPage: coCreateContentAuthoringModel.referenceUrl ?? coCreateContentAuthoringModel.startPage,
    );

    if (coCreateContentAuthoringModel.skillsMap.isEmpty && coCreateContentAuthoringModel.skills.isNotEmpty) {
      Map<String, String> allSkillsMap = Map<String, String>.fromEntries(provider.skills.getList().map((e) => MapEntry(e.categoryId, e.categoryName)));

      coCreateContentAuthoringModel.skillsMap = Map<String, String>.fromEntries(allSkillsMap.entries.where((element) => coCreateContentAuthoringModel.skills.contains(element.value)));
      coCreateContentAuthoringModel.skills = coCreateContentAuthoringModel.skillsMap.values.toList();
    }

    bool isContentShared = false;
    if (coCreateContentAuthoringModel.contentId.isNotEmpty && coCreateContentAuthoringModel.isEdit) {
      List<CourseDTOModel> list = provider.sharedKnowledgeList.getList();
      isContentShared = list.where((element) => element.ContentID == coCreateContentAuthoringModel.contentId).isNotEmpty;
    }

    CreateNewContentItemRequestModel requestModel = CreateNewContentItemRequestModel(
      formData: createNewContentItemFormDataModel,
      ObjectTypeID: coCreateContentAuthoringModel.contentTypeId,
      MediaTypeID: coCreateContentAuthoringModel.mediaTypeId,
      ThumbnailImage: coCreateContentAuthoringModel.thumbNailImageBytes,
      ThumbnailImageName: coCreateContentAuthoringModel.ThumbnailImageName,
      ActionType: coCreateContentAuthoringModel.isEdit ? CreateNewContentItemActionType.update : CreateNewContentItemActionType.create,
      Categories: coCreateContentAuthoringModel.skillsMap.keys.map((e) => e.toString()).toList(),
      UnAssignCategories: coCreateContentAuthoringModel.oldSkillsMap.keys.map((e) => e.toString()).toList(),
      CategoryType: CreateNewContentItemCategoryType.skl,
      ContentID: coCreateContentAuthoringModel.contentId,
      FolderPath: coCreateContentAuthoringModel.courseDTOModel?.FolderPath ?? "",
      isContentShared: isContentShared,
    );
    requestModel.UnAssignCategories.removeWhere((element) => requestModel.Categories.contains(element));

    if (coCreateContentAuthoringModel.uploadedDocumentName.checkNotEmpty) {
      requestModel.fileName = coCreateContentAuthoringModel.uploadedDocumentName!;
    }
    if (coCreateContentAuthoringModel.uploadedDocumentBytes.checkNotEmpty) {
      requestModel.Files = [
        InstancyMultipartFileUploadModel(
          fieldName: "Files",
          fileName: coCreateContentAuthoringModel.uploadedDocumentName,
          bytes: coCreateContentAuthoringModel.uploadedDocumentBytes,
        ),
      ];
    }

    if (coCreateContentAuthoringModel.flashcardContentModel != null) {
      FlashcardContentModel flashcardContentModel = coCreateContentAuthoringModel.flashcardContentModel!;
      requestModel.additionalData = flashcardContentModel.toString();
    }
    if (coCreateContentAuthoringModel.quizContentModel != null) {
      QuizContentModel quizContentModel = coCreateContentAuthoringModel.quizContentModel!;
      requestModel.additionalData = quizContentModel.toString();
    }
    if (coCreateContentAuthoringModel.articleContentModel != null) {
      ArticleContentModel articleContentModel = coCreateContentAuthoringModel.articleContentModel!;
      requestModel.additionalData = articleContentModel.toString();
    }
    if (coCreateContentAuthoringModel.podcastContentModel != null) {
      PodcastContentModel podcastContentModel = coCreateContentAuthoringModel.podcastContentModel!;
      requestModel.additionalData = podcastContentModel.toString();
    }
    if (coCreateContentAuthoringModel.eventModel != null) {
      EventModel eventModel = coCreateContentAuthoringModel.eventModel!;
      createNewContentItemFormDataModel.EventStartDateTime = "${eventModel.date} ${eventModel.startTime}";
      createNewContentItemFormDataModel.EventEndDateTime = "${eventModel.date} ${eventModel.endTime}";
      createNewContentItemFormDataModel.RegistrationURL = eventModel.eventUrl;
      createNewContentItemFormDataModel.Location = eventModel.location;

      DateTime? startDateTime = ParsingHelper.parseDateTimeMethod(
        createNewContentItemFormDataModel.EventStartDateTime,
        dateFormat: "dd MMM yyyy hh:mm:ss aa",
      );
      DateTime? endDateTime = ParsingHelper.parseDateTimeMethod(
        createNewContentItemFormDataModel.EventEndDateTime,
        dateFormat: "dd MMM yyyy hh:mm:ss aa",
      );
      if (startDateTime != null && endDateTime != null) {
        createNewContentItemFormDataModel.Duration = DatePresentation.getDifferenceBetweenDatesInMinutes(
          startDateTime,
          endDateTime,
        );
      }

      requestModel.additionalData = eventModel.toString();
    }
    if (coCreateContentAuthoringModel.microLearningContentModel != null) {
      MicroLearningContentModel microLearningContentModel = coCreateContentAuthoringModel.microLearningContentModel!;
      requestModel.additionalData = microLearningContentModel.toString();
    }
    if (coCreateContentAuthoringModel.roleplayContentModel != null) {
      RoleplayContentModel roleplayContentModel = coCreateContentAuthoringModel.roleplayContentModel!;
      requestModel.additionalData = roleplayContentModel.toString();
    }
    if (coCreateContentAuthoringModel.learningPathContentModel != null) {
      LearningPathContentModel learningPathContentModel = coCreateContentAuthoringModel.learningPathContentModel!;
      requestModel.additionalData = learningPathContentModel.toString();
    }
    if (coCreateContentAuthoringModel.videoContentModel != null) {
      VideoContentModel videoContentModel = coCreateContentAuthoringModel.videoContentModel!;
      requestModel.additionalData = videoContentModel.toString();
    }

    // if (requestModel.additionalData.isNotEmpty && coCreateContentAuthoringModel.microLearningContentModel == null) requestModel.additionalData = MyUtils.encodeJson(requestModel.additionalData);

    return requestModel;
  }

  void initializeContentDataInCourseDTOModelFromCoCreateContentAuthoringModel({required CoCreateContentAuthoringModel coCreateContentAuthoringModel}) {
    CourseDTOModel? courseDTOModel = coCreateContentAuthoringModel.courseDTOModel ?? coCreateContentAuthoringModel.newCurrentCourseDTOModel;
    if (courseDTOModel == null) {
      return;
    }

    courseDTOModel.ContentID = coCreateContentAuthoringModel.contentId;
    courseDTOModel.FolderPath = coCreateContentAuthoringModel.contentId;

    courseDTOModel.ContentName = coCreateContentAuthoringModel.title;
    courseDTOModel.Title = coCreateContentAuthoringModel.title;
    courseDTOModel.TitleName = coCreateContentAuthoringModel.title;
    courseDTOModel.ShortDescription = coCreateContentAuthoringModel.description;
    courseDTOModel.LongDescription = coCreateContentAuthoringModel.description;
    courseDTOModel.ContentType = coCreateContentAuthoringModel.contentType;
    courseDTOModel.ThumbnailImagePath = coCreateContentAuthoringModel.ThumbnailImagePath;
    courseDTOModel.ThumbnailImageName = coCreateContentAuthoringModel.ThumbnailImageName;
    courseDTOModel.thumbNailFileBytes = coCreateContentAuthoringModel.thumbNailImageBytes;
    courseDTOModel.startpage = coCreateContentAuthoringModel.startPage;
    courseDTOModel.ContentSkills = coCreateContentAuthoringModel.skillsMap.entries.map((e) {
      return ContentFilterCategoryTreeModel(
        categoryId: e.key,
        categoryName: e.value,
      );
    }).toList();
    courseDTOModel.ContentTypeId = coCreateContentAuthoringModel.contentTypeId;
    courseDTOModel.MediaTypeID = coCreateContentAuthoringModel.mediaTypeId;

    if (coCreateContentAuthoringModel.contentTypeId == InstancyObjectTypes.reference && coCreateContentAuthoringModel.mediaTypeId == InstancyMediaTypes.url) {
      courseDTOModel.ViewLink = coCreateContentAuthoringModel.referenceUrl ?? "";
    } else if (coCreateContentAuthoringModel.contentTypeId == InstancyObjectTypes.document ||
        (coCreateContentAuthoringModel.contentTypeId == InstancyObjectTypes.mediaResource &&
            [
              InstancyMediaTypes.audio,
              InstancyMediaTypes.video,
            ].contains(coCreateContentAuthoringModel.mediaTypeId))) {
      courseDTOModel.uploadedDocumentBytes = coCreateContentAuthoringModel.uploadedDocumentBytes;
      courseDTOModel.uploadedFileName = coCreateContentAuthoringModel.uploadedDocumentName;
    }

    EventModel? eventModel = coCreateContentAuthoringModel.eventModel;
    if (eventModel != null) {
      courseDTOModel.EventStartDateTime = "${eventModel.date} ${eventModel.startTime}";
      courseDTOModel.EventEndDateTime = "${eventModel.date} ${eventModel.endTime}";
      courseDTOModel.EventStartDateTimeWithoutConvert = coCreateContentAuthoringModel.eventModel?.startTime ?? "";
      courseDTOModel.EventEndDateTimeTimeWithoutConvert = coCreateContentAuthoringModel.eventModel?.endTime ?? "";
      // courseDTOModel.Duration = "30 Minutes";
      // courseDTOModel.AvailableSeats = "10";

      //   UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
      // ContentTypeId: InstancyObjectTypes.events,
      // MediaTypeID: InstancyMediaTypes.none,
      // ContentType: "Events",
      // ThumbnailImagePath: "/Content/SiteFiles/Images/Event.jpg",
      // ShortDescription: "Unleash the potential of nations through economic growth and development",
      // EventStartDateTime: "30 May 2024",
      // EventStartDateTimeWithoutConvert: "05/30/2024 05:30:00 PM",
      // EventEndDateTime: "30 May 2024",
      // EventEndDateTimeTimeWithoutConvert: "05/30/2024 06:00:00 PM",
      // Duration: "30 Minutes",
      // AvailableSeats: "10",
    }
    courseDTOModel.eventModel = eventModel;
    courseDTOModel.flashcardContentModel = coCreateContentAuthoringModel.flashcardContentModel;
    courseDTOModel.quizContentModel = coCreateContentAuthoringModel.quizContentModel;
    courseDTOModel.articleContentModel = coCreateContentAuthoringModel.articleContentModel;
    courseDTOModel.podcastContentModel = coCreateContentAuthoringModel.podcastContentModel;
    courseDTOModel.microLearningContentModel = coCreateContentAuthoringModel.microLearningContentModel;
    courseDTOModel.roleplayContentModel = coCreateContentAuthoringModel.roleplayContentModel;
    courseDTOModel.learningPathContentModel = coCreateContentAuthoringModel.learningPathContentModel;
    courseDTOModel.videoContentModel = coCreateContentAuthoringModel.videoContentModel;
  }

  // endregion

  void initializeCoCreateContentAuthoringModelFromCourseDTOModel({
    required CourseDTOModel courseDTOModel,
    required CoCreateContentAuthoringModel coCreateContentAuthoringModel,
  }) {
    coCreateContentAuthoringModel.courseDTOModel = courseDTOModel;
    coCreateContentAuthoringModel.isEdit = coCreateContentAuthoringModel.coCreateAuthoringType != CoCreateAuthoringType.Create;

    coCreateContentAuthoringModel.contentId = courseDTOModel.ContentID;
    coCreateContentAuthoringModel.title = courseDTOModel.ContentName;
    coCreateContentAuthoringModel.description = courseDTOModel.ShortDescription;
    coCreateContentAuthoringModel.contentType = courseDTOModel.ContentType;
    coCreateContentAuthoringModel.ThumbnailImagePath = courseDTOModel.ThumbnailImagePath;
    coCreateContentAuthoringModel.ThumbnailImageName = courseDTOModel.ThumbnailImageName;
    coCreateContentAuthoringModel.thumbNailImageBytes = courseDTOModel.thumbNailFileBytes;
    coCreateContentAuthoringModel.startPage = courseDTOModel.startpage;
    coCreateContentAuthoringModel.skillsMap = Map<String, String>.fromEntries(courseDTOModel.ContentSkills.map((e) => MapEntry(e.categoryId, e.categoryName)));
    coCreateContentAuthoringModel.skills = courseDTOModel.ContentSkills.map((e) => e.categoryName).toList();
    coCreateContentAuthoringModel.oldSkillsMap = Map<String, String>.from(coCreateContentAuthoringModel.skillsMap);

    if (coCreateContentAuthoringModel.contentTypeId == InstancyObjectTypes.reference && coCreateContentAuthoringModel.mediaTypeId == InstancyMediaTypes.url) {
      coCreateContentAuthoringModel.referenceUrl = courseDTOModel.ViewLink;
    } else if (coCreateContentAuthoringModel.contentTypeId == InstancyObjectTypes.document) {
      coCreateContentAuthoringModel.uploadedDocumentBytes = courseDTOModel.uploadedDocumentBytes;
      coCreateContentAuthoringModel.uploadedDocumentName = courseDTOModel.uploadedFileName;
      if (coCreateContentAuthoringModel.uploadedDocumentName.checkEmpty) {
        int index = coCreateContentAuthoringModel.startPage.lastIndexOf("/");
        if (index != -1 && (index + 1) < coCreateContentAuthoringModel.startPage.length) {
          coCreateContentAuthoringModel.uploadedDocumentName = coCreateContentAuthoringModel.startPage.substring(index + 1);
        }
      }
    }

    coCreateContentAuthoringModel.eventModel = courseDTOModel.eventModel;
    coCreateContentAuthoringModel.flashcardContentModel = courseDTOModel.flashcardContentModel;
    coCreateContentAuthoringModel.quizContentModel = courseDTOModel.quizContentModel;
    coCreateContentAuthoringModel.articleContentModel = courseDTOModel.articleContentModel;
    coCreateContentAuthoringModel.podcastContentModel = courseDTOModel.podcastContentModel;
    coCreateContentAuthoringModel.microLearningContentModel = courseDTOModel.microLearningContentModel;
    coCreateContentAuthoringModel.roleplayContentModel = courseDTOModel.roleplayContentModel;
    coCreateContentAuthoringModel.learningPathContentModel = courseDTOModel.learningPathContentModel;
    coCreateContentAuthoringModel.videoContentModel = courseDTOModel.videoContentModel;
  }

  Future<GeneratedFlashcardResponseModel?> generateFlashcard({required FlashcardRequestModel requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().CreateNewContentItem() called with requestModel:$requestModel", tag: tag);

    CoCreateKnowledgeRepository repository = coCreateKnowledgeRepository;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = repository.apiController.apiDataProvider;

    requestModel.userID = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.siteID = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.clientUrl = apiUrlConfigurationProvider.getCurrentSiteUrl();

    DataResponseModel<GeneratedFlashcardResponseModel> dataResponseModel = await repository.generateFlashcard(requestModel: requestModel);
    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateFlashcard() because appErrorModel is not null", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);
      return null;
    } else if (dataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateFlashcard() because data is null", tag: tag);
      return null;
    }
    MyPrint.printOnConsole("GeneratedFlashcardResponseModel : ${dataResponseModel.data}'", tag: tag);

    GeneratedFlashcardResponseModel responseModel = GeneratedFlashcardResponseModel.fromMap(dataResponseModel.data!.toMap());
    MyPrint.printOnConsole("Final contentId:'${responseModel.flashcards.length}'", tag: tag);

    return responseModel;
  }

  Future<List<QuizQuestionModel>?> generateQuiz({required QuizGenerateRequestModel requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().generateQuiz() called with requestModel:$requestModel", tag: tag);

    CoCreateKnowledgeRepository repository = coCreateKnowledgeRepository;
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = repository.apiController.apiDataProvider;

    // region Chat Completion
    String prompt = "Generate meta-data fields below in 'English' language \nTag line, \nShort description (less than 25 words),"
        " Long description (less than 120 words), keywords, Table of content and Learning objectives.\n "
        "for this eLearning Course Title: '${requestModel.prompt}'.\n Provide them in JSON format with the following keys:\n  "
        "short_description,learning_objectives as string.";

    DataResponseModel<String> dataResponseModel = await repository.chatCompletionCall(prompt: prompt);
    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateQuiz() because appErrorModel is not null for chatCompletionCall", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);
      return null;
    } else if (dataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateQuiz() because data is null for chatCompletionCall", tag: tag);
      return null;
    }

    MyPrint.printOnConsole("chatCompletionCall data : ${dataResponseModel.data}", tag: tag);
    Map mapResponse = jsonDecode(dataResponseModel.data!);
    String learningObjective = ParsingHelper.parseStringMethod(mapResponse["learning_objectives"]);
    if (learningObjective.isEmpty) learningObjective = ParsingHelper.parseStringMethod(mapResponse["Learning_objectives"]);
    if (learningObjective.isEmpty) learningObjective = ParsingHelper.parseStringMethod(mapResponse["Learning_Objectives"]);
    if (learningObjective.isEmpty) learningObjective = ParsingHelper.parseStringMethod(mapResponse["Learning Objectives"]);
    MyPrint.printOnConsole("learningObjective : $learningObjective", tag: tag);
    if (learningObjective.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateQuiz() learningObjective is empty", tag: tag);
      return null;
    }
    // endregion

    // region AssessmentGenerateContent
    String adminUrl = coCreateKnowledgeRepository.apiController.apiEndpoints.getAdminSiteUrl();
    AssessmentGenerateContentRequestModel requestModel1 = AssessmentGenerateContentRequestModel(
      learningObjectives: learningObjective,
      llmContent: true,
      word_count: 300,
      adminUrl: adminUrl,
    );
    DataResponseModel<AssessmentGenerateContentResponseModel> assessmentDataResponseModel = await repository.assessmentGenerateContent(requestModel: requestModel1);

    if (assessmentDataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateQuiz() because appErrorModel is not null for assessmentGenerateContent", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);
      return null;
    } else if (assessmentDataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateQuiz() because data is null for assessmentGenerateContent", tag: tag);
      return null;
    }

    AssessmentGenerateContentResponseModel assessmentGenerateContentResponseModel = assessmentDataResponseModel.data!;
    MyPrint.printOnConsole("assessmentGenerateContentResponseModel:$assessmentGenerateContentResponseModel", tag: tag);

    if (assessmentGenerateContentResponseModel.generated_content.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateQuiz() because assessmentGenerateContentResponseModel is empty", tag: tag);
      return null;
    }
    // endregion

    // region GenerateAssessment
    int requestedBy = apiUrlConfigurationProvider.getCurrentUserId();
    GenerateAssessmentRequestModel requestModel2 = GenerateAssessmentRequestModel(
      content: assessmentGenerateContentResponseModel.generated_content,
      type: requestModel.questionType.toString(),
      difficultyLevel: requestModel.difficultyLevel,
      numberofQuestions: requestModel.numberOfQuestions,
      requestedBy: requestedBy,
      adminUrl: adminUrl,
    );
    DataResponseModel<GenerateAssessmentResponseModel> generateAssessmentDataResponseModel = await repository.generateAssessment(requestModel: requestModel2);

    if (generateAssessmentDataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateQuiz() because appErrorModel is not null for generateAssessment", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);
      return null;
    } else if (generateAssessmentDataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateQuiz() because data is null for generateAssessment", tag: tag);
      return null;
    }

    GenerateAssessmentResponseModel generateAssessmentResponseModel = generateAssessmentDataResponseModel.data!;
    MyPrint.printOnConsole("generateAssessmentResponseModel.Assessment.length : ${generateAssessmentResponseModel.Assessment.length}");
    // endregion

    List<QuizQuestionModel> questionsList = generateAssessmentResponseModel.Assessment;
    MyPrint.printOnConsole("Final questionsList length : ${questionsList.length}");

    return questionsList;
  }

  Future<void> getAllAvtarList() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().getAllAvtarList() Called", tag: tag);

    DataResponseModel<AvtarResponseModel> dataResponseModel = await coCreateKnowledgeRepository.getAllAvtarList();

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getAllAvtarList() because appErrorModel is not null", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);
      return;
    } else if (dataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getAllAvtarList() because data is null", tag: tag);
      return;
    }

    MyPrint.printOnConsole("Got Images Data", tag: tag);

    List<Avatars> avatarList = [];

    AvtarResponseModel avtarResponseModel = dataResponseModel.data!;

    if (avtarResponseModel.avatars.checkNotEmpty) {
      avatarList = avtarResponseModel.avatars;
    }

    coCreateKnowledgeProvider.avatarList.setList(list: avatarList);

    return;
  }

  Future<void> getBackgroundColorList() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().getBackgroundColorList() Called", tag: tag);

    DataResponseModel<List<BackgroundColorModel>> dataResponseModel = await coCreateKnowledgeRepository.getBackgroundColorList();

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getBackgroundColorList() because appErrorModel is not null", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);
      return;
    } else if (dataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getBackgroundColorList() because data is null", tag: tag);
      return;
    }

    MyPrint.printOnConsole("Got getBackgroundColorList Data", tag: tag);

    List<BackgroundColorModel> backgroundColorModelList = dataResponseModel.data!;

    coCreateKnowledgeProvider.backgroundColorList.setList(list: backgroundColorModelList);

    return;
  }

  Future<void> getAvatarVoiceList() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().getAvatarVoiceList() Called", tag: tag);

    DataResponseModel<List<AvtarVoiceModel>> dataResponseModel = await coCreateKnowledgeRepository.getAvtarVoiceList();

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getAvatarVoiceList() because appErrorModel is not null", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);
      return;
    } else if (dataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getAvatarVoiceList() because data is null", tag: tag);
      return;
    }

    MyPrint.printOnConsole("Got getBackgroundColorList Data", tag: tag);

    List<AvtarVoiceModel> avatarVoiceList = dataResponseModel.data!;

    coCreateKnowledgeProvider.avatarVoiceList.setList(list: avatarVoiceList);

    return;
  }

  Future<Uint8List?> generateVideo({required GenerateVideoRequestModel requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().generateVideo() called with requestModel:$requestModel", tag: tag);

    CoCreateKnowledgeRepository repository = coCreateKnowledgeRepository;
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = repository.apiController.apiDataProvider;

    String contentId = MyUtils.getNewId();
    // String contentId = "generate_content_page_${apiUrlConfigurationProvider.getCurrentUserId()}";

    requestModel.content = Content(
      contentID: contentId,
      pageID: contentId,
      sectionID: contentId,
      userID: apiUrlConfigurationProvider.getCurrentUserId(),
    );

    DataResponseModel<String> dataResponseModel = await repository.generateVideo(requestModel: requestModel);
    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateVideo() because appErrorModel is not null", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);
      return null;
    } else if (dataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateVideo() because data is null", tag: tag);
      return null;
    }

    if (dataResponseModel.data != "1") {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateVideo() because generateVideo is not 1", tag: tag);
      return null;
    }

    String videoId = await getVideoIdFromVideoDetails(videoContentId: contentId);
    if (videoId.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateVideo() because videoId empty", tag: tag);
      return null;
    }

    String value = await getAiVideoGenerator(videoContentId: videoId);
    MyPrint.printOnConsole("getAiVideoGenerator value : $value");
    if (value != "1") {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateVideo() because getAiVideoGenerator response is not 1", tag: tag);
      return null;
    }

    String videoUrl = "${repository.apiController.apiEndpoints.adminSiteUrl}/content/aigeneratedvideos/$videoId.mp4";
    MyPrint.printOnConsole("Video Generated Successfully, videoUrl:'$videoUrl'", tag: tag);

    Uint8List? convertedBytes = await repository.getBytesFromUrl(url: videoUrl);
    if (convertedBytes == null || convertedBytes.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateVideo() because generated video bytes are null or empty", tag: tag);
      return null;
    }

    coCreateKnowledgeProvider.generatedVideoUrl.set(value: videoUrl);
    return convertedBytes;
  }

  Future<String> getVideoIdFromVideoDetails({required String videoContentId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().getVideoIdFromVideoDetails() called with videoContentId:$videoContentId", tag: tag);

    CoCreateKnowledgeRepository repository = coCreateKnowledgeRepository;
    String videoIdFromVideoDetail = "";

    DataResponseModel<List<VideoDetails>> dataResponseModelOfVideoDetails = await repository.getVideoDetails(videoContentId: videoContentId);
    if (dataResponseModelOfVideoDetails.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getVideoIdFromVideoDetails() because appErrorModel is not null", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModelOfVideoDetails.appErrorModel}", tag: tag);
      return videoIdFromVideoDetail;
    } else if (dataResponseModelOfVideoDetails.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getVideoIdFromVideoDetails() because data is null", tag: tag);
      return videoIdFromVideoDetail;
    }

    if (dataResponseModelOfVideoDetails.data.checkNotEmpty) {
      VideoDetails? videoDetails = dataResponseModelOfVideoDetails.data?.first;
      if (videoDetails != null) {
        videoIdFromVideoDetail = videoDetails.videoID;
      }
    }

    return videoIdFromVideoDetail;
  }

  Future<String> getAiVideoGenerator({required String videoContentId, int count = 0}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().getAiVideoGenerator() called with videoContentId:'$videoContentId', count:$count", tag: tag);

    CoCreateKnowledgeRepository repository = coCreateKnowledgeRepository;

    if (count > 50) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getAiVideoGenerator() because max call achieved", tag: tag);
      return "";
    }

    DataResponseModel<String> dataResponseModelOfAiVideoGenerator = await repository.aiVideoGeneratorApi(videoId: videoContentId);
    if (dataResponseModelOfAiVideoGenerator.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getAiVideoGenerator() because appErrorModel is not null", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModelOfAiVideoGenerator.appErrorModel}", tag: tag);
      return "";
    } else if (dataResponseModelOfAiVideoGenerator.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getAiVideoGenerator() because data is null", tag: tag);
      return "";
    }
    MyPrint.printOnConsole("dataResponseModelOfAiVideoGenerator.data ${dataResponseModelOfAiVideoGenerator.data}", tag: tag);

    String response = dataResponseModelOfAiVideoGenerator.data!;

    if (response == "1") {
      MyPrint.printOnConsole("Video with videoContentId '$videoContentId' Created Successfully", tag: tag);
      return "1";
    }

    count++;
    await Future.delayed(const Duration(seconds: 10));

    String responseString = await getAiVideoGenerator(videoContentId: videoContentId, count: count);

    return responseString;
  }

  Future<List<String>> getInternetSearchUrls({required NativeAuthoringGetResourcesRequestModel requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().getInternetSearchUrls() called with requestModel:$requestModel", tag: tag);

    CoCreateKnowledgeRepository repository = coCreateKnowledgeRepository;
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = repository.apiController.apiDataProvider;

    requestModel.client_url = apiUrlConfigurationProvider.getCurrentSiteLMSUrl();

    List<String> urls = <String>[];

    DataResponseModel<NativeAuthoringGetResourcesResponseModel> dataResponseModel = await repository.NativeAuthoringGetResources(requestModel: requestModel);
    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getInternetSearchUrls() because appErrorModel is not null", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);
      return urls;
    } else if (dataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getInternetSearchUrls() because data is null", tag: tag);
      return urls;
    }

    MyPrint.printOnConsole("dataResponseModel.data ${dataResponseModel.data}", tag: tag);

    NativeAuthoringGetResourcesResponseModel responseModel = dataResponseModel.data!;

    urls = responseModel.sources_from_web.map((e) => e.link).toList();

    MyPrint.printOnConsole("Final urls:$urls", tag: tag);
    return urls;
  }

  Future<({String nextPageToken, List<String> urls})> getYoutubeSearchUrls({required NativeAuthoringGetResourcesRequestModel requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().getYoutubeSearchUrls() called with requestModel:$requestModel", tag: tag);

    CoCreateKnowledgeRepository repository = coCreateKnowledgeRepository;
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = repository.apiController.apiDataProvider;

    requestModel.client_url = apiUrlConfigurationProvider.getCurrentSiteLMSUrl();

    ({String nextPageToken, List<String> urls}) response = (nextPageToken: "", urls: <String>[]);

    DataResponseModel<NativeAuthoringGetResourcesResponseModel> dataResponseModel = await repository.NativeAuthoringGetResources(requestModel: requestModel);
    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getYoutubeSearchUrls() because appErrorModel is not null", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);
      return response;
    } else if (dataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getYoutubeSearchUrls() because data is null", tag: tag);
      return response;
    }

    MyPrint.printOnConsole("dataResponseModel.data ${dataResponseModel.data}", tag: tag);

    NativeAuthoringGetResourcesResponseModel responseModel = dataResponseModel.data!;

    List<String> urls = responseModel.sources_from_youtube.map((e) => e.url).toList();

    response = (nextPageToken: responseModel.next_page_token, urls: urls);

    MyPrint.printOnConsole("Final response:$response", tag: tag);
    return response;
  }

  Future<List<String>> getMicroLearningTopicsListing({required NativeAuthoringGetModuleNamesRequestModel requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().getMicroLearningTopicsListing() called with requestModel:$requestModel", tag: tag);

    CoCreateKnowledgeRepository repository = coCreateKnowledgeRepository;

    List<String> topics = <String>[];

    DataResponseModel<NativeAuthoringGetModuleNamesResponseModel> dataResponseModel = await repository.NativeAuthoringGetModuleNames(requestModel: requestModel);
    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getMicroLearningTopicsListing() because appErrorModel is not null", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);
      return topics;
    } else if (dataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getMicroLearningTopicsListing() because data is null", tag: tag);
      return topics;
    }

    MyPrint.printOnConsole("dataResponseModel.data ${dataResponseModel.data}", tag: tag);

    NativeAuthoringGetModuleNamesResponseModel responseModel = dataResponseModel.data!;

    topics = responseModel.learning_modules;

    MyPrint.printOnConsole("Final topics:$topics", tag: tag);
    return topics;
  }

  Future<bool> getLanguageList() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().getLanguageList() called ", tag: tag);

    CoCreateKnowledgeRepository repository = coCreateKnowledgeRepository;

    DataResponseModel<List<LanguageModel>> dataResponseModel = await repository.getLanguageList();
    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getLanguageList() because appErrorModel is not null", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);
      return false;
    } else if (dataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getLanguageList() because data is null", tag: tag);
      return false;
    }

    if (dataResponseModel.data.checkNotEmpty) {
      List<LanguageModel> languageList = dataResponseModel.data ?? [];
      coCreateKnowledgeProvider.languageList.setList(list: languageList);
      return true;
    }
    return true;
  }

  Future<List<LanguageVoiceModel>> getLanguageVoiceList(String languageCode) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().getLanguageVoiceList() called ", tag: tag);

    CoCreateKnowledgeRepository repository = coCreateKnowledgeRepository;

    List<LanguageVoiceModel> languageList = <LanguageVoiceModel>[];

    DataResponseModel<List<LanguageVoiceModel>> dataResponseModel = await repository.getLanguageVoiceList(languageCode: languageCode);
    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getLanguageVoiceList() because appErrorModel is not null", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);
      return languageList;
    } else if (dataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getLanguageVoiceList() because data is null", tag: tag);
      return languageList;
    } else if (dataResponseModel.data!.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getLanguageVoiceList() because data is empty", tag: tag);
      return languageList;
    }

    languageList = dataResponseModel.data!;
    coCreateKnowledgeProvider.languageVoiceList.setList(list: languageList);

    return languageList;
  }

  Future<SpeakingStyleModel?> getSpeakingStyle(String voiceName) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().getSpeakingStyle() called ", tag: tag);

    CoCreateKnowledgeRepository repository = coCreateKnowledgeRepository;

    DataResponseModel<SpeakingStyleModel> dataResponseModel = await repository.getSpeakingStyleList(voiceName: voiceName);
    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getSpeakingStyle() because appErrorModel is not null", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);
      return null;
    } else if (dataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getSpeakingStyle() because data is null", tag: tag);
      return null;
    }

    SpeakingStyleModel speakingStyleModel = dataResponseModel.data!;
    return speakingStyleModel;
  }

  Future<Uint8List?> getAudioGenerator({required PlayAudioForTextRequestModel requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().getAudioGenerator() called ", tag: tag);

    CoCreateKnowledgeRepository repository = coCreateKnowledgeRepository;
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = repository.apiController.apiDataProvider;
    AppSystemConfigurationModel appSystemConfigurationModel = DependencyInjection.appProvider.appSystemConfigurationModel;

    requestModel.uID = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.folderID = appSystemConfigurationModel.CoCreateKnowledgeDefaultFolderID;
    requestModel.cmsGroupID = appSystemConfigurationModel.CoCreateKnowledgeDefaultCMSGroupID;

    DataResponseModel<String> dataResponseModel = await repository.getAudioGenerator(requestModel: requestModel);
    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getAudioGenerator() because appErrorModel is not null", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);
      return null;
    } else if (dataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getAudioGenerator() because data is null", tag: tag);
      return null;
    }

    MyPrint.printOnConsole("dataResponseModel.data : ${dataResponseModel.data}");
    if (dataResponseModel.data == null || dataResponseModel.data!.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getAudioGenerator() because generated audio url is null or empty", tag: tag);
      return null;
    }

    String audioUrl = dataResponseModel.data!;

    Uint8List? convertedBytes = await repository.getBytesFromUrl(url: audioUrl);
    if (convertedBytes == null || convertedBytes.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getAudioGenerator() because generated audio bytes are null or empty", tag: tag);
      return null;
    }

    coCreateKnowledgeProvider.audioUrlFromApi.set(value: audioUrl);

    return convertedBytes;
  }

  Future<String> generateWholeArticleContent({required GenerateWholeArticleContentRequestModel requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().generateWholeArticleContent() called ", tag: tag);

    CoCreateKnowledgeRepository repository = coCreateKnowledgeRepository;

    requestModel.clientUrl = repository.apiController.apiEndpoints.adminSiteUrl;
    try {
      DataResponseModel<ArticleResponseModel> dataResponseModel = await repository.generateWholeArticleContent(requestModel: requestModel);
      if (dataResponseModel.appErrorModel != null) {
        MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateWholeArticleContent() because appErrorModel is not null", tag: tag);
        MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);
        return "";
      } else if (dataResponseModel.data == null) {
        MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateWholeArticleContent() because data is null", tag: tag);
        return "";
      }

      String articleString = "";
      if (dataResponseModel.data != null) {
        List<Article> articleList = dataResponseModel.data?.article ?? [];

        if (articleList.checkNotEmpty) {
          for (var element in (dataResponseModel.data?.article ?? [])) {
            articleString += "<h4>${element.title}</h4><p>${element.content}</p><br>";
          }
        }
      }
      return articleString;
    } catch (e, s) {
      MyPrint.printOnConsole("error in this generateWholeArticleContent $e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return "";
    }
  }

  Future<String> internetSearch({required AssessmentGenerateContentRequestModel requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().internetSearch() called ", tag: tag);

    CoCreateKnowledgeRepository repository = coCreateKnowledgeRepository;

    try {
      DataResponseModel<AssessmentGenerateContentResponseModel> dataResponseModel = await repository.assessmentGenerateContent(requestModel: requestModel);
      if (dataResponseModel.appErrorModel != null) {
        MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().internetSearch() because appErrorModel is not null", tag: tag);
        MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);
        return "";
      } else if (dataResponseModel.data == null) {
        MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().internetSearch() because data is null", tag: tag);
        return "";
      }

      String internetSearchString = "";
      if (dataResponseModel.data != null) {}
      return internetSearchString;
    } catch (e, s) {
      MyPrint.printOnConsole("error in this generateWholeArticleContent $e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return "";
    }
  }

  Future<String> chatCompletion({required String promptText}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().generateQuiz() called with chatCompletion:$promptText", tag: tag);

    CoCreateKnowledgeRepository repository = coCreateKnowledgeRepository;
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = repository.apiController.apiDataProvider;

    // region Chat Completion

    String generatedString = "";

    DataResponseModel<String> dataResponseModel = await repository.chatCompletionCall(prompt: promptText);
    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().chatCompletion() because appErrorModel is not null for chatCompletionCall", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);
      return generatedString;
    } else if (dataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().chatCompletion() because data is null for chatCompletionCall", tag: tag);
      return generatedString;
    }

    MyPrint.printOnConsole("chatCompletionCall data : ${dataResponseModel.data}", tag: tag);
    generatedString = dataResponseModel.data!;

    return generatedString;
  }

  //region Generate MicroLearning Content
  Future<List<MicroLearningPageModel>> generateMicroLearningContentPages({required MicroLearningContentModel microLearningContentModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().generateMicroLearningContentPages() called with microLearningContentModel:$microLearningContentModel", tag: tag);

    List<MicroLearningPageModel> pages = <MicroLearningPageModel>[];

    if (microLearningContentModel.pageCount < 1) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateMicroLearningContentPages() because pageCount is less than 1", tag: tag);
      return pages;
    } else if (microLearningContentModel.wordsPerPageCount < 1) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateMicroLearningContentPages() because wordsPerPageCount is less than 1", tag: tag);
      return pages;
    } else if (microLearningContentModel.selectedTopics.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateMicroLearningContentPages() because selectedTopics is empty", tag: tag);
      return pages;
    }

    List<String> totalElementsEnabled = [
      if (microLearningContentModel.isGenerateTextEnabled) MicroLearningElementType.Text,
      if (microLearningContentModel.isGenerateImageEnabled) MicroLearningElementType.Image,
      if (microLearningContentModel.isGenerateAudioEnabled) MicroLearningElementType.Audio,
      if (microLearningContentModel.isGenerateVideoEnabled) MicroLearningElementType.Video,
      if (microLearningContentModel.isGenerateQuizEnabled) MicroLearningElementType.Quiz,
    ];
    MyPrint.printOnConsole("totalElementsEnabled:$totalElementsEnabled", tag: tag);

    if (totalElementsEnabled.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateMicroLearningContentPages() because totalElementsEnabled is empty", tag: tag);
      return pages;
    }

    List<String> elementsEnabled = totalElementsEnabled.toList();
    bool isQuizEnabled = elementsEnabled.remove(MicroLearningElementType.Quiz);

    Map<String, List<String>> pagesElementWise = <String, List<String>>{};

    List<String> selectedTopics = microLearningContentModel.selectedTopics;
    bool isGenerateAudio = false;
    bool isGenerateVideo = false;

    for (String topic in selectedTopics) {
      List<String> elements = <String>[];
      elements.addAll(elementsEnabled);
      pagesElementWise[topic] = elements;

      if (elements.contains(MicroLearningElementType.Audio)) isGenerateAudio = true;
      if (elements.contains(MicroLearningElementType.Video)) isGenerateVideo = true;
    }

    MyPrint.printOnConsole("Final pagesElementWise:$pagesElementWise", tag: tag);

    if (isGenerateAudio || isGenerateVideo) {
      MyPrint.printOnConsole("Getting Audio/Video Generation Metadata", tag: tag);

      DateTime start = DateTime.now();

      String language = "en-US";

      List<Future> futures = <Future>[
        getLanguageVoiceList(language),
      ];

      if (isGenerateVideo) {
        futures.addAll([
          getAllAvtarList(),
          getAvatarVoiceList(),
          getBackgroundColorList(),
        ]);
      }

      if (futures.isNotEmpty) await Future.wait(futures);

      DateTime end = DateTime.now();
      MyPrint.printOnConsole("Completed Getting Audio/Video Generation Metadata in ${start.difference(end).inMilliseconds} Milliseconds", tag: tag);
    }

    Map<String, MicroLearningPageModel?> pagesMap = <String, MicroLearningPageModel?>{};

    String quizTopic = "";
    List<QuizQuestionModel> quizQuestions = <QuizQuestionModel>[];

    for (MapEntry<String, List<String>> entry in pagesElementWise.entries) {
      String topic = entry.key;
      List<String> elementsList = entry.value;

      MicroLearningPageModel? microLearningPageModel = await generateMicroLearningPage(topic: topic, pageElements: elementsList);
      pagesMap[topic] = microLearningPageModel;
    }

    if (isQuizEnabled) {
      quizTopic = selectedTopics[Random().nextInt(selectedTopics.length)];
      quizQuestions = await generateMicroLearningQuiz(topic: quizTopic);
    }

    MyPrint.printOnConsole("pagesMap length:${pagesMap.length}", tag: tag);

    for (String topic in selectedTopics) {
      MicroLearningPageModel? microLearningPageModel = pagesMap[topic];

      if (microLearningPageModel != null) {
        pages.add(microLearningPageModel);
      }
    }

    if (quizTopic.isNotEmpty && quizQuestions.isNotEmpty) {
      MicroLearningPageModel microLearningPageModel = MicroLearningPageModel(
        title: quizTopic,
        elements: [
          MicroLearningPageElementModel(
            elementType: MicroLearningElementType.Quiz,
            quizQuestionModels: quizQuestions,
          ),
        ],
      );
      pages.add(microLearningPageModel);
    }

    MyPrint.printOnConsole("Final pages length:${pages.length}", tag: tag);
    MyPrint.logOnConsole("Final pages:$pages", tag: tag);

    return pages;
  }

  Future<MicroLearningPageModel?> generateMicroLearningPage({required String topic, required List<String> pageElements}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().generateMicroLearningPage() called for topic:'$topic', pageElements:$pageElements", tag: tag);

    MicroLearningPageModel? page;

    if (topic.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateMicroLearningPage() because topic is empty", tag: tag);
      return page;
    } else if (pageElements.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateMicroLearningPage() because topic is empty", tag: tag);
      return page;
    }

    List<Future<void>> futures = <Future<void>>[];
    Map<int, MicroLearningPageElementModel?> elementsMap = <int, MicroLearningPageElementModel?>{};

    for (int i = 0; i < pageElements.length; i++) {
      String pageElement = pageElements[i];

      Completer<void> completer = Completer<void>();

      generateMicroLearningPageElementModel(topic: topic, elementType: pageElement).then((MicroLearningPageElementModel? microLearningPageElementModel) {
        MyPrint.printOnConsole("Got Data for Element '$pageElement' not null:${microLearningPageElementModel != null}", tag: tag);

        elementsMap[i] = microLearningPageElementModel;
      }).catchError((e, s) {
        MyPrint.printOnConsole("Error in Getting MicroLearningPageElementModel for Element '$pageElement' for topic '$topic':$e", tag: tag);
        MyPrint.printOnConsole(s, tag: tag);
      }).whenComplete(() {
        MyPrint.printOnConsole("Completed Getting Data for Topic '$topic'", tag: tag);
        if (!completer.isCompleted) {
          completer.complete();
        }
      });

      futures.add(completer.future);
    }

    await Future.wait(futures);

    MyPrint.printOnConsole("Final elementsMap:${elementsMap.length}", tag: tag);

    if (elementsMap.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateMicroLearningPage() because generated elementsMap is empty", tag: tag);
      return page;
    }

    List<int> indexes = elementsMap.keys.toList();
    indexes.sort();
    List<MicroLearningPageElementModel> elementsList = <MicroLearningPageElementModel>[];

    for (int index in indexes) {
      MicroLearningPageElementModel? microLearningPageElementModel = elementsMap[index];
      if (microLearningPageElementModel != null) {
        elementsList.add(microLearningPageElementModel);
      }
    }

    page = MicroLearningPageModel(
      title: topic,
      elements: elementsList,
    );

    MyPrint.printOnConsole("Final page:$page", tag: tag);

    return page;
  }

  Future<MicroLearningPageElementModel?> generateMicroLearningPageElementModel({required String topic, required String elementType}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().generateMicroLearningPageElementModel() called for topic:'$topic', elementType:'$elementType'", tag: tag);

    MicroLearningPageElementModel? pageElement;

    if (topic.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateMicroLearningPageElementModel() because topic is empty", tag: tag);
      return pageElement;
    } else if (elementType.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateMicroLearningPageElementModel() because elementType is empty", tag: tag);
      return pageElement;
    }

    if (elementType == MicroLearningElementType.Text) {
      String text = await generateMicroLearningText(topic: topic);

      if (text.isEmpty) {
        MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateMicroLearningPageElementModel() because generated text is empty", tag: tag);
        return pageElement;
      }

      pageElement = MicroLearningPageElementModel(
        elementType: elementType,
        htmlContentCode: text,
      );
    } else if (elementType == MicroLearningElementType.Image) {
      Uint8List? bytes = await generateMicroLearningImage(topic: topic);

      if (bytes.checkEmpty) {
        MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateMicroLearningPageElementModel() because generated ImageBytes are null or empty", tag: tag);
        return pageElement;
      }

      pageElement = MicroLearningPageElementModel(
        elementType: elementType,
        contentBytes: bytes,
      );
    } else if (elementType == MicroLearningElementType.Audio) {
      Uint8List? bytes = await generateMicroLearningAudio(topic: topic);

      if (bytes.checkEmpty) {
        MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateMicroLearningPageElementModel() because generated AudioBytes are null or empty", tag: tag);
        return pageElement;
      }

      pageElement = MicroLearningPageElementModel(
        elementType: elementType,
        contentBytes: bytes,
      );
    } else if (elementType == MicroLearningElementType.Video) {
      Uint8List? bytes = await generateMicroLearningVideo(topic: topic);

      if (bytes.checkEmpty) {
        MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateMicroLearningPageElementModel() because generated VideoBytes are null or empty", tag: tag);
        return pageElement;
      }

      Uri uri = Uri.dataFromBytes(bytes!);
      VideoPlayerController videoPlayerController = VideoPlayerController.networkUrl(uri);
      await videoPlayerController.initialize();

      pageElement = MicroLearningPageElementModel(
        elementType: elementType,
        contentBytes: bytes,
        videoPlayerController: videoPlayerController,
      );
    } else if (elementType == MicroLearningElementType.Quiz) {}

    MyPrint.printOnConsole("Completed CoCreateKnowledgeController().generateMicroLearningPageElementModel() for topic:'$topic', elementType:'$elementType'", tag: tag);
    return pageElement;
  }

  Future<String> generateMicroLearningText({required String topic}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().generateMicroLearningText() called", tag: tag);

    // CoCreateKnowledgeRepository repository = coCreateKnowledgeRepository;

    String text = "";

    if (topic.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateMicroLearningText() because topic is empty", tag: tag);
      return text;
    }

    text = await generateWholeArticleContent(
      requestModel: GenerateWholeArticleContentRequestModel(
        title: topic,
        numberOfTopics: 3,
        source: "internet",
        wordsCount: 200,
      ),
    );

    MyPrint.printOnConsole("Final text:$text", tag: tag);

    return text;
  }

  Future<Uint8List?> generateMicroLearningImage({required String topic}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().generateMicroLearningImage() called", tag: tag);

    Uint8List? imageBytes;

    if (topic.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateMicroLearningImage() because topic is empty", tag: tag);
      return imageBytes;
    }

    List<Uint8List> images = await generateImagesFromAi(
      requestModel: GenerateImagesRequestModel(
        count: 1,
        size: "1024x1024",
        topic: topic,
      ),
    );

    imageBytes = images.firstElement;

    MyPrint.printOnConsole("Final imageBytes:${imageBytes?.length}", tag: tag);

    return imageBytes;
  }

  Future<Uint8List?> generateMicroLearningAudio({required String topic}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().generateMicroLearningAudio() called", tag: tag);

    CoCreateKnowledgeProvider provider = coCreateKnowledgeProvider;

    if (topic.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateMicroLearningAudio() because topic is empty", tag: tag);
      return null;
    }

    String scriptText = await chatCompletion(promptText: "Detailed Info about '$topic'");
    if (scriptText.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateMicroLearningAudio() because scriptText is empty", tag: tag);
      return null;
    }

    String language = "en-US";

    List<LanguageVoiceModel> voiceList = provider.languageVoiceList.getList();
    if (voiceList.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateMicroLearningAudio() because voiceList is empty", tag: tag);
      return null;
    }
    LanguageVoiceModel voiceModel = voiceList[Random().nextInt(voiceList.length)];

    SpeakingStyleModel? speakingStyleModel = await getSpeakingStyle(voiceModel.voiceName);
    if (speakingStyleModel == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateMicroLearningAudio() because speakingStyleModel is null", tag: tag);
      return null;
    } else if (speakingStyleModel.voiceStyle.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateMicroLearningAudio() because voiceStyle is null", tag: tag);
      return null;
    }

    PlayAudioForTextRequestModel playerRequestModel = PlayAudioForTextRequestModel(
      text: scriptText,
      language: language,
      voice: voiceModel.voiceName,
      voiceStyle: speakingStyleModel.voiceStyle.first,
      isOptionsChanged: true,
      speekingPitch: 1,
      speekingSpeed: 1,
      isPlay: true,
    );
    Uint8List? bytes = await getAudioGenerator(requestModel: playerRequestModel);
    MyPrint.printOnConsole("bytes:${bytes?.length}", tag: tag);

    if (bytes == null || bytes.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateMicroLearningVideo() because Video Couldn't Generate", tag: tag);
      return bytes;
    }

    MyPrint.printOnConsole("Audio Generated", tag: tag);

    return bytes;
  }

  Future<Uint8List?> generateMicroLearningVideo({required String topic}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().generateMicroLearningVideo() called", tag: tag);

    CoCreateKnowledgeProvider provider = coCreateKnowledgeProvider;

    if (topic.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateMicroLearningVideo() because topic is empty", tag: tag);
      return null;
    }

    // String scriptText = "Heart Attack is a major disises";
    String scriptText = await chatCompletion(promptText: "Detailed Info about '$topic'");
    if (scriptText.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateMicroLearningVideo() because scriptText is empty", tag: tag);
      return null;
    }

    List<Avatars> avatarModelsList = provider.avatarList.getList();
    if (avatarModelsList.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateMicroLearningVideo() because avatarModelsList is empty", tag: tag);
      return null;
    }
    Avatars avatarModel = avatarModelsList[Random().nextInt(avatarModelsList.length)];

    List<AvtarVoiceModel> avtarVoiceModelsList = provider.avatarVoiceList.getList();
    if (avtarVoiceModelsList.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateMicroLearningVideo() because avtarVoiceModelsList is empty", tag: tag);
      return null;
    }
    AvtarVoiceModel avtarVoiceModel = avtarVoiceModelsList[Random().nextInt(avtarVoiceModelsList.length)];

    List<BackgroundColorModel> backgroundColorModelsList = provider.backgroundColorList.getList();
    if (avtarVoiceModelsList.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateMicroLearningVideo() because backgroundColorModelsList is empty", tag: tag);
      return null;
    }
    BackgroundColorModel backgroundColorModel = backgroundColorModelsList[Random().nextInt(backgroundColorModelsList.length)];

    List<LanguageVoiceModel> voiceList = provider.languageVoiceList.getList();
    if (voiceList.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateMicroLearningVideo() because voiceList is empty", tag: tag);
      return null;
    }
    LanguageVoiceModel voiceModel = voiceList[Random().nextInt(voiceList.length)];

    SpeakingStyleModel? speakingStyleModel = await getSpeakingStyle(voiceModel.voiceName);
    if (speakingStyleModel == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateMicroLearningVideo() because speakingStyleModel is null", tag: tag);
      return null;
    } else if (speakingStyleModel.voiceStyle.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateMicroLearningVideo() because voiceStyle is null", tag: tag);
      return null;
    }

    Uint8List? bytes = await generateVideo(
      requestModel: GenerateVideoRequestModel(
        videoInput: VideoInput(
          title: topic,
          input: [
            Input(
              scriptText: scriptText,
              avatar: avatarModel.actorID,
              background: backgroundColorModel.backgrounds.first,
              avatarSettings: AvatarSettings(
                voice: avtarVoiceModel.voiceID,
                scale: 1,
                horizontalAlign: 'center',
                style: "rectangular",
              ),
            ),
          ],
        ),
      ),
    );
    MyPrint.printOnConsole("bytes:${bytes?.length}", tag: tag);

    if (bytes == null || bytes.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateMicroLearningVideo() because Video Couldn't Generate", tag: tag);
      return bytes;
    }

    MyPrint.printOnConsole("Video Generated", tag: tag);

    return bytes;
  }

  Future<List<QuizQuestionModel>> generateMicroLearningQuiz({required String topic, int numberOfQuestions = 1}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().generateMicroLearningQuiz() called with topic:$topic", tag: tag);

    List<QuizQuestionModel> quizQuestionModelsList = <QuizQuestionModel>[];

    if (topic.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateMicroLearningQuiz() because topic is empty", tag: tag);
      return quizQuestionModelsList;
    }

    List<QuizQuestionModel>? list = await generateQuiz(
      requestModel: QuizGenerateRequestModel(
        prompt: topic,
        questionType: QuizQuestionType.mcq,
        difficultyLevel: QuizDifficultyTypes.intermediate,
        numberOfQuestions: numberOfQuestions,
      ),
    );

    quizQuestionModelsList = list ?? <QuizQuestionModel>[];
    MyPrint.printOnConsole("Final quizQuestionModelsList:$quizQuestionModelsList", tag: tag);

    return quizQuestionModelsList;
  }

// endregion

  Future<bool> DeleteCoCreateContent({required BuildContext context, required DeleteCoCreateContentRequestModel requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().DeleteCoCreateContent() called", tag: tag);

    CoCreateKnowledgeProvider provider = coCreateKnowledgeProvider;
    CoCreateKnowledgeRepository repository = coCreateKnowledgeRepository;

    bool isDeleted = false;

    if (requestModel.ContentID.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().DeleteCoCreateContent() because ContentID is empty", tag: tag);
      if (context.checkMounted()) MyToast.showError(context: context, msg: "ContentID is Empty");
      return isDeleted;
    }

    dynamic value = await showDialog(
      context: context,
      builder: (BuildContext context) {
        LocalStr localStrNew = context.read<AppProvider>().localStr;

        return CommonConfirmationDialog(
          title: "Delete ${requestModel.contentName}",
          description: "Are you sure want to delete this knowledge?",
          confirmationText: localStrNew.catalogActionsheetDeleteoption,
          cancelText: localStrNew.catalogAlertbuttonCancelbutton,
        );
      },
    );

    if (value != true) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().DeleteCoCreateContent() because couldn't get confirmation", tag: tag);
      return isDeleted;
    }

    DataResponseModel<String> dataResponseModel = await repository.DeleteCoCreateContent(requestModel: requestModel);
    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().DeleteCoCreateContent() because appErrorModel is not null", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);
      return isDeleted;
    } else if (dataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().DeleteCoCreateContent() because data is null", tag: tag);
      return isDeleted;
    }

    MyPrint.printOnConsole("dataResponseModel.data:${dataResponseModel.data}", tag: tag);

    isDeleted = dataResponseModel.data!.isNotEmpty;

    MyPrint.printOnConsole("Final isDeleted:$isDeleted", tag: tag);

    if (isDeleted) {
      List<CourseDTOModel> myKnowledgeList = provider.myKnowledgeList.getList(isNewInstance: false).where((element) => element.ContentID == requestModel.ContentID).toList();
      provider.myKnowledgeList.removeItems(items: myKnowledgeList, isNotify: false);

      List<CourseDTOModel> sharedKnowledgeList = provider.sharedKnowledgeList.getList(isNewInstance: false).where((element) => element.ContentID == requestModel.ContentID).toList();
      provider.sharedKnowledgeList.removeItems(items: sharedKnowledgeList, isNotify: true);
    }

    if (isDeleted) {
      if (context.checkMounted()) MyToast.showSuccess(context: context, msg: "Knowledge Deleted Successfully!");
    } else {
      if (context.checkMounted()) MyToast.showError(context: context, msg: "Knowledge Delete Failed!");
    }

    return isDeleted;
  }

  Future<bool> ShareCoCreateContent({required BuildContext context, required ShareCoCreateKnowledgeBaseRequestModel requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().ShareCoCreateContent() called", tag: tag);

    CoCreateKnowledgeRepository repository = coCreateKnowledgeRepository;

    bool isShared = false;

    if (requestModel.contentId.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().DeleteCoCreateContent() because ContentID is empty", tag: tag);
      if (context.checkMounted()) MyToast.showError(context: context, msg: "ContentID is Empty");
      return isShared;
    } else if (requestModel.folderPath.isEmpty) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().DeleteCoCreateContent() because FolderPath is empty", tag: tag);
      if (context.checkMounted()) MyToast.showError(context: context, msg: "FolderPath is Empty");
      return isShared;
    }

    dynamic value = await showDialog(
      context: context,
      builder: (BuildContext context) {
        LocalStr localStrNew = context.read<AppProvider>().localStr;

        return CommonConfirmationDialog(
          title: "Share Knowledge",
          description: "Are you sure want to share ${requestModel.contentName} to your knowledge?",
          confirmationText: localStrNew.catalogActionsheetShareoption,
          cancelText: localStrNew.catalogAlertbuttonCancelbutton,
        );
      },
    );

    if (value != true) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().DeleteCoCreateContent() because couldn't get confirmation", tag: tag);
      return isShared;
    }

    DataResponseModel<String> dataResponseModel = await repository.ShareCoCreateKnowledgeBase(requestModel: requestModel);
    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().ShareCoCreateContent() because appErrorModel is not null", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);
      return isShared;
    } else if (dataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().ShareCoCreateContent() because data is null", tag: tag);
      return isShared;
    }

    MyPrint.printOnConsole("dataResponseModel.data:${dataResponseModel.data}", tag: tag);

    isShared = dataResponseModel.data! == '1';

    MyPrint.printOnConsole("Final isShared:$isShared", tag: tag);

    if (isShared) {
      getSharedKnowledgeList();
    }

    if (isShared) {
      if (context.checkMounted()) MyToast.showSuccess(context: context, msg: "Knowledge Shared Successfully!");
    } else {
      if (context.checkMounted()) MyToast.showError(context: context, msg: "Knowledge Share Failed!");
    }

    return isShared;
  }

  Future<void> DeleteAllContentsTemp() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().DeleteAllContentsTemp()", tag: tag);

    CoCreateKnowledgeProvider provider = coCreateKnowledgeProvider;
    CoCreateKnowledgeRepository repository = coCreateKnowledgeRepository;

    List<CourseDTOModel> list = provider.myKnowledgeList.getList();

    List<Future<bool>> futures = <Future<bool>>[];

    for (CourseDTOModel model in list) {
      Completer<bool> completer = Completer<bool>();

      repository.DeleteCoCreateContent(
        requestModel: DeleteCoCreateContentRequestModel(
          UserID: model.SiteUserID,
          ContentID: model.ContentID,
        ),
      ).then((DataResponseModel<String> dataResponseModel) {
        if (dataResponseModel.appErrorModel != null) {
          MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().DeleteAllContentsTemp() because appErrorModel is not null for ContentId ${model.ContentID}", tag: tag);
          MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);
          return completer.complete(false);
        } else if (dataResponseModel.data == null) {
          MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().DeleteAllContentsTemp() because data is null for ContentId ${model.ContentID}", tag: tag);
          return completer.complete(false);
        }

        bool isDeleted = dataResponseModel.data!.isNotEmpty;
        MyPrint.printOnConsole("Final isDeleted for ContentId ${model.ContentID} : $isDeleted", tag: tag);

        return completer.complete(isDeleted);
      }).catchError((e, s) {
        MyPrint.printOnConsole("Error in Deleting Content for ContentId ${model.ContentID}:$e", tag: tag);
        MyPrint.printOnConsole(s, tag: tag);

        return completer.complete(false);
      });

      futures.add(completer.future);
    }

    await Future.wait(futures);

    MyPrint.printOnConsole("Completed", tag: tag);
  }

  Future<bool> getLearningPathContentItem({GetCoCreateKnowledgebaseListRequestModel? requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().getMyKnowledgeList() called with requestModel:$requestModel", tag: tag);

    CoCreateKnowledgeProvider provider = coCreateKnowledgeProvider;
    provider.isLoadingLearningPathContent.set(value: true, isNotify: false);

    if (requestModel == null) {
      MyPrint.printOnConsole("Initializing requestModel", tag: tag);

      ApiUrlConfigurationProvider apiUrlConfigurationProvider = coCreateKnowledgeRepository.apiController.apiDataProvider;
      AppSystemConfigurationModel appSystemConfigurationModel = DependencyInjection.appProvider.appSystemConfigurationModel;

      requestModel = GetCoCreateKnowledgebaseListRequestModel(
          userId: apiUrlConfigurationProvider.getCurrentUserId(),
          cmsGroupId: appSystemConfigurationModel.CoCreateKnowledgeDefaultCMSGroupID,
          folderId: appSystemConfigurationModel.CoCreateKnowledgeDefaultFolderID,
          additionalFilter: "trackcontent");

      MyPrint.printOnConsole("Final requestModel", tag: tag);
    }

    DataResponseModel<CatalogResponseDTOModel> dataResponseModel = await coCreateKnowledgeRepository.getMyKnowledgeList2(requestModel: requestModel);
    // DataResponseModel<List<CourseDTOModel>> dataResponseModel = await coCreateKnowledgeRepository.getMyKnowledgeList(requestModel: requestModel);
    // DataResponseModel<List<CourseDTOModel>> dataResponseModel = await coCreateKnowledgeRepository.getMyKnowledgeListTemp(requestModel: requestModel);

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getMyKnowledgeList() because appErrorModel is not null", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);

      provider.isLoadingLearningPathContent.set(value: false, isNotify: false);
      provider.learningContentItemList.setList(list: <CourseDTOModel>[]);

      return false;
    } else if (dataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getMyKnowledgeList() because data is null", tag: tag);

      provider.isLoadingLearningPathContent.set(value: false, isNotify: false);
      provider.learningContentItemList.setList(list: <CourseDTOModel>[]);

      return false;
    }

    List<CourseDTOModel> contentsList = dataResponseModel.data?.CourseList ?? <CourseDTOModel>[];
    MyPrint.printOnConsole("MyKnowledge Contents Length got in Api:${contentsList.length}", tag: tag);

    provider.isLoadingLearningPathContent.set(value: false, isNotify: false);
    provider.learningContentItemList.setList(list: contentsList);

    MyPrint.printOnConsole("Final myKnowledgeList length:${provider.myKnowledgeList.length}", tag: tag);

    return true;
  }
}
