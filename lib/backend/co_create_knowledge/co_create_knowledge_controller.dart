import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_instancy_2/api/api_url_configuration_provider.dart';
import 'package:flutter_instancy_2/backend/app/dependency_injection.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/app_ststem_configurations.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/article/data_model/article_content_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/co_create_content_authoring_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/request_model/create_new_content_item_formdata_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/request_model/create_new_content_item_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/request_model/generate_images_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/request_model/get_co_create_knowledgebase_list_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/request_model/native_authoring_get_module_names_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/request_model/native_authoring_get_resources_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/request_model/save_content_json_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/response_model/avatar_voice_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/response_model/avtar_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/response_model/background_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/response_model/native_authoring_get_module_names_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/response_model/native_authoring_get_resources_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/event/data_model/event_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/flashcards/data_model/flashcard_content_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/flashcards/request_model/flashcard_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/flashcards/response_model/generated_flashcard_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/podcast/response_model/language_voice_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/podcast/response_model/speaking_style_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/micro_learning_model/data_model/micro_learning_content_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/podcast/data_model/podcast_content_model.dart';
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
import 'package:flutter_instancy_2/models/common/data_response_model.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/models/profile/data_model/user_profile_details_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../api/api_controller.dart';
import '../../models/co_create_knowledge/article/request_model/generate_whole_article_content_request_model.dart';
import '../../models/co_create_knowledge/article/response_model/article_response_model.dart';
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

  Future<bool> getMyKnowledgeList({GetCoCreateKnowledgebaseListRequestModel? requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().getMyKnowledgeList() called with requestModel:$requestModel", tag: tag);

    CoCreateKnowledgeProvider provider = coCreateKnowledgeProvider;
    provider.isLoading.set(value: true, isNotify: false);

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

    DataResponseModel<List<CourseDTOModel>> dataResponseModel = await coCreateKnowledgeRepository.getMyKnowledgeList(requestModel: requestModel);
    // DataResponseModel<List<CourseDTOModel>> dataResponseModel = await coCreateKnowledgeRepository.getMyKnowledgeListTemp(requestModel: requestModel);

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getMyKnowledgeList() because appErrorModel is not null", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);

      provider.isLoading.set(value: false, isNotify: false);
      provider.myKnowledgeList.setList(list: <CourseDTOModel>[]);

      return false;
    } else if (dataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getMyKnowledgeList() because data is null", tag: tag);

      provider.isLoading.set(value: false, isNotify: false);
      provider.myKnowledgeList.setList(list: <CourseDTOModel>[]);

      return false;
    }

    provider.isLoading.set(value: false, isNotify: false);
    provider.myKnowledgeList.setList(list: dataResponseModel.data!);

    MyPrint.printOnConsole("Final myKnowledgeList length:${provider.myKnowledgeList.length}", tag: tag);

    return true;
  }

  Future<bool> getSharedKnowledgeList({GetCoCreateKnowledgebaseListRequestModel? requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().getSharedKnowledgeList() called with requestModel:$requestModel", tag: tag);

    CoCreateKnowledgeProvider provider = coCreateKnowledgeProvider;
    provider.isLoading.set(value: true, isNotify: false);

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

    DataResponseModel<List<CourseDTOModel>> dataResponseModel = await coCreateKnowledgeRepository.getMyKnowledgeList(requestModel: requestModel);
    // DataResponseModel<List<CourseDTOModel>> dataResponseModel = await coCreateKnowledgeRepository.getMyKnowledgeListTemp(requestModel: requestModel);

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getSharedKnowledgeList() because appErrorModel is not null", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);

      provider.isLoading.set(value: false, isNotify: false);
      provider.shareKnowledgeList.setList(list: <CourseDTOModel>[]);

      return false;
    } else if (dataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getSharedKnowledgeList() because data is null", tag: tag);

      provider.isLoading.set(value: false, isNotify: false);
      provider.shareKnowledgeList.setList(list: <CourseDTOModel>[]);

      return false;
    }

    provider.isLoading.set(value: false, isNotify: false);
    provider.shareKnowledgeList.setList(list: dataResponseModel.data!);

    MyPrint.printOnConsole("Final shareKnowledgeList length:${provider.shareKnowledgeList.length}", tag: tag);

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
    CoCreateKnowledgeRepository repository = coCreateKnowledgeRepository;

    CreateNewContentItemFormDataModel createNewContentItemFormDataModel = CreateNewContentItemFormDataModel(
      Name: coCreateContentAuthoringModel.title,
      ShortDescription: coCreateContentAuthoringModel.description,
      // ThumbnailImagePath: coCreateContentAuthoringModel.ThumbnailImagePath,
      MediaTypeID: coCreateContentAuthoringModel.mediaTypeId.toString(),
      Language: repository.apiController.apiDataProvider.getLocale(),
      Bit3: coCreateContentAuthoringModel.contentTypeId == InstancyObjectTypes.reference && coCreateContentAuthoringModel.mediaTypeId == InstancyMediaTypes.url,
      StartPage: coCreateContentAuthoringModel.referenceUrl ?? "",
    );

    CreateNewContentItemRequestModel requestModel = CreateNewContentItemRequestModel(
      formData: createNewContentItemFormDataModel,
      ObjectTypeID: coCreateContentAuthoringModel.contentTypeId,
      MediaTypeID: coCreateContentAuthoringModel.mediaTypeId,
      ThumbnailImage: coCreateContentAuthoringModel.thumbNailImageBytes,
      ThumbnailImageName: coCreateContentAuthoringModel.ThumbnailImageName,
      ActionType: coCreateContentAuthoringModel.isEdit ? CreateNewContentItemActionType.update : CreateNewContentItemActionType.create,
      Categories: coCreateContentAuthoringModel.skills,
      CategoryType: CreateNewContentItemCategoryType.skl,
      ContentID: coCreateContentAuthoringModel.contentId,
      FolderPath: coCreateContentAuthoringModel.courseDTOModel?.FolderPath ?? "",
    );

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
      // LearningPathContentModel learningPathContentModel = coCreateContentAuthoringModel.learningPathContentModel!;
      // requestModel.additionalData = learningPathContentModel.toString();
    }
    if (coCreateContentAuthoringModel.videoContentModel != null) {
      VideoContentModel videoContentModel = coCreateContentAuthoringModel.videoContentModel!;
      requestModel.additionalData = videoContentModel.toString();
    }

    if (requestModel.additionalData.isNotEmpty) requestModel.additionalData = MyUtils.encodeJson(requestModel.additionalData);

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
    courseDTOModel.Skills = coCreateContentAuthoringModel.skills;
    courseDTOModel.ContentTypeId = coCreateContentAuthoringModel.contentTypeId;
    courseDTOModel.MediaTypeID = coCreateContentAuthoringModel.mediaTypeId;

    if (coCreateContentAuthoringModel.contentTypeId == InstancyObjectTypes.reference && coCreateContentAuthoringModel.mediaTypeId == InstancyMediaTypes.url) {
      courseDTOModel.ViewLink = coCreateContentAuthoringModel.referenceUrl ?? "";
    } else if (coCreateContentAuthoringModel.contentTypeId == InstancyObjectTypes.document) {
      courseDTOModel.uploadedDocumentBytes = coCreateContentAuthoringModel.uploadedDocumentBytes;
      courseDTOModel.uploadedFileName = coCreateContentAuthoringModel.uploadedDocumentName;
    }

    EventModel? eventModel = coCreateContentAuthoringModel.eventModel;
    if (eventModel != null) {
      courseDTOModel.EventStartDateTime = "${eventModel.date} ${eventModel.startTime}";
      courseDTOModel.EventEndDateTime = "${eventModel.date} ${eventModel.endTime}";
      courseDTOModel.EventStartDateTimeWithoutConvert = coCreateContentAuthoringModel.eventModel?.startTime ?? "";
      courseDTOModel.EventEndDateTimeTimeWithoutConvert = coCreateContentAuthoringModel.eventModel?.endTime ?? "";
      courseDTOModel.Duration = "30 Minutes";
      courseDTOModel.AvailableSeats = "10";

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
    coCreateContentAuthoringModel.skills = courseDTOModel.Skills;

    if (coCreateContentAuthoringModel.contentTypeId == InstancyObjectTypes.reference && coCreateContentAuthoringModel.mediaTypeId == InstancyMediaTypes.url) {
      coCreateContentAuthoringModel.referenceUrl = courseDTOModel.ViewLink;
    } else if (coCreateContentAuthoringModel.contentTypeId == InstancyObjectTypes.document) {
      coCreateContentAuthoringModel.uploadedDocumentBytes = courseDTOModel.uploadedDocumentBytes;
      coCreateContentAuthoringModel.uploadedDocumentName = courseDTOModel.uploadedFileName;
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

  Future<bool> generateVideo({required GenerateVideoRequestModel requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().generateVideo() called with requestModel:$requestModel", tag: tag);

    CoCreateKnowledgeRepository repository = coCreateKnowledgeRepository;
    String contentId = MyUtils.getNewId();

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = repository.apiController.apiDataProvider;

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
      return false;
    } else if (dataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateVideo() because data is null", tag: tag);
      return false;
    }

    if (dataResponseModel.data == "1") {
      String videoId = await getVideoIdFromVideoDetails(videoContentId: contentId);
      if (videoId.checkNotEmpty) {
        String value = await getAiVideoGenerator(videoContentId: videoId);
        MyPrint.printOnConsole("getAiVideoGenerator value : $value");
        if (value == "1") {
          coCreateKnowledgeProvider.generatedVideoUrl.set(value: "${repository.apiController.apiEndpoints.adminSiteUrl}content/aigeneratedvideos/$videoId.mp4");
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<String> getVideoIdFromVideoDetails({required String videoContentId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().getVideoIdFromVideoDetails() called with videoContentId:$videoContentId", tag: tag);

    CoCreateKnowledgeRepository repository = coCreateKnowledgeRepository;
    String videoIdFromVideoDetail = "";

    DataResponseModel<List<VideoDetails>> dataResponseModelOfVideoDetails = await repository.getVideoDetails(videoContentId: videoContentId);
    if (dataResponseModelOfVideoDetails.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateVideo() because appErrorModel is not null", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModelOfVideoDetails.appErrorModel}", tag: tag);
      return videoIdFromVideoDetail;
    } else if (dataResponseModelOfVideoDetails.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateVideo() because data is null", tag: tag);
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

  Future<String> getAiVideoGenerator({required String videoContentId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().getAiVideoGenerator() called with videoContentId:$videoContentId", tag: tag);

    CoCreateKnowledgeRepository repository = coCreateKnowledgeRepository;

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

    if (dataResponseModelOfAiVideoGenerator.data == "0") {
      await Future.delayed(
        const Duration(seconds: 10),
        () async {
          await getAiVideoGenerator(videoContentId: videoContentId);
        },
      );
    } else {
      MyPrint.printOnConsole("dataResponseModelOfAiVideoGenerator.data 2 ${dataResponseModelOfAiVideoGenerator.data}", tag: tag);
      return dataResponseModelOfAiVideoGenerator.data ?? "";
    }
    // MyPrint.printOnConsole("dataResponseModelOfAiVideoGenerator.data 3 ${dataResponseModelOfAiVideoGenerator.data}", tag: tag);
    return "1";
  }

  Future<List<String>> getInternetYoutubeSearchUrls({required NativeAuthoringGetResourcesRequestModel requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().getInternetYoutubeSearchUrls() called with requestModel:$requestModel", tag: tag);

    CoCreateKnowledgeRepository repository = coCreateKnowledgeRepository;
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = repository.apiController.apiDataProvider;

    requestModel.client_url = apiUrlConfigurationProvider.getCurrentSiteLMSUrl();

    List<String> urls = <String>[];

    DataResponseModel<NativeAuthoringGetResourcesResponseModel> dataResponseModel = await repository.NativeAuthoringGetResources(requestModel: requestModel);
    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getInternetYoutubeSearchUrls() because appErrorModel is not null", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);
      return urls;
    } else if (dataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getInternetYoutubeSearchUrls() because data is null", tag: tag);
      return urls;
    }

    MyPrint.printOnConsole("dataResponseModel.data ${dataResponseModel.data}", tag: tag);

    NativeAuthoringGetResourcesResponseModel responseModel = dataResponseModel.data!;

    urls = responseModel.sources_from_web.map((e) => e.link).toList();

    MyPrint.printOnConsole("Final urls:$urls", tag: tag);
    return urls;
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

  Future<bool> getLanguageVoiceList(String languageCode) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().getLanguageVoiceList() called ", tag: tag);

    CoCreateKnowledgeRepository repository = coCreateKnowledgeRepository;

    DataResponseModel<List<LanguageVoiceModel>> dataResponseModel = await repository.getLanguageVoiceList(languageCode: languageCode);
    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getLanguageVoiceList() because appErrorModel is not null", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);
      return false;
    } else if (dataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getLanguageVoiceList() because data is null", tag: tag);
      return false;
    }

    if (dataResponseModel.data.checkNotEmpty) {
      List<LanguageVoiceModel> languageList = dataResponseModel.data ?? [];
      coCreateKnowledgeProvider.languageVoiceList.setList(list: languageList);
    }
    return true;
  }

  Future<bool> getSpeakingStyle(String voiceName) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().getSpeakingStyle() called ", tag: tag);

    CoCreateKnowledgeRepository repository = coCreateKnowledgeRepository;

    DataResponseModel<SpeakingStyleModel> dataResponseModel = await repository.getSpeakingStyleList(voiceName: voiceName);
    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getSpeakingStyle() because appErrorModel is not null", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);
      return false;
    } else if (dataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getSpeakingStyle() because data is null", tag: tag);
      return false;
    }

    if (dataResponseModel.data != null) {
      SpeakingStyleModel? speakingStyleModel = dataResponseModel.data;
      if (speakingStyleModel != null) {
        coCreateKnowledgeProvider.speakingStyleModel.set(value: speakingStyleModel);
      }
    }
    return true;
  }

  Future<bool> getAudioGenerator({required PlayAudioForTextRequestModel requestModel}) async {
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
      return false;
    } else if (dataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().getAudioGenerator() because data is null", tag: tag);
      return false;
    }

    MyPrint.printOnConsole("dataResponseModel.data : ${dataResponseModel.data}");

    if (dataResponseModel.data != null) {
      String? audioUrl = dataResponseModel.data;
      if (audioUrl != null) {
        coCreateKnowledgeProvider.audioUrlFromApi.set(value: audioUrl);
      }
    }
    return true;
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
}
