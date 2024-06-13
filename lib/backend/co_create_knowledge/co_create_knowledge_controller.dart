import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_chat_bot/utils/my_print.dart';
import 'package:flutter_instancy_2/api/api_url_configuration_provider.dart';
import 'package:flutter_instancy_2/backend/app/dependency_injection.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/app_ststem_configurations.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/co_create_content_authoring_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/request_model/create_new_content_item_formdata_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/request_model/create_new_content_item_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/request_model/generate_images_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/response_model/avatar_voice_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/response_model/avtar_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/response_model/background_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/event/data_model/event_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/flashcards/data_model/flashcard_content_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/flashcards/request_model/flashcard_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/flashcards/response_model/generated_flashcard_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/data_models/quiz_content_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/data_models/quiz_question_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/request_model/assessment_generate_content_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/request_model/generate_assessment_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/request_model/quiz_generate_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/response_model/assessment_generate_content_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/response_model/generate_assessment_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/roleplay/data_models/roleplay_content_model.dart';
import 'package:flutter_instancy_2/models/common/data_response_model.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/models/profile/data_model/user_profile_details_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../api/api_controller.dart';
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

  Future<bool> getMyKnowledgeList() async {
    CoCreateKnowledgeProvider provider = coCreateKnowledgeProvider;
    provider.isLoading.set(value: true, isNotify: false);

    DataResponseModel<List<CourseDTOModel>> response = await coCreateKnowledgeRepository.getMyKnowledgeList(componentId: 3, componentInstanceId: 3);

    if (response.data?.isEmpty ?? false) return false;
    provider.myKnowledgeList.setList(list: response.data ?? []);
    provider.isLoading.set(value: false, isNotify: false);
    return true;
  }

  Future<bool> getSharedKnowledgeList() async {
    CoCreateKnowledgeProvider provider = coCreateKnowledgeProvider;
    provider.isLoading.set(value: true, isNotify: false);

    DataResponseModel<List<CourseDTOModel>> response = await coCreateKnowledgeRepository.getMyKnowledgeList(componentId: 3, componentInstanceId: 3);

    if (response.data?.isEmpty ?? false) return false;
    provider.shareKnowledgeList.setList(list: response.data ?? []);
    provider.isLoading.set(value: false, isNotify: false);
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
      try {
        UriData? data = Uri.tryParse(base64ImageString)?.data;

        if (data?.isBase64 == true) {
          Uint8List bytes = data!.contentAsBytes();
          if (bytes.isNotEmpty) images.add(bytes);
        }
      } catch (e, s) {
        MyPrint.printOnConsole("Error in Decoding Base64:$e", tag: tag);
        MyPrint.printOnConsole(s, tag: tag);
      }
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
    requestModel.CMSGroupID = appSystemConfigurationModel.CoCreateKnowledgeDefaultFolderID;
    requestModel.Language = apiUrlConfigurationProvider.getLocale();

    DataResponseModel<String> dataResponseModel = await repository.CreateNewContentItem(requestModel: requestModel);
    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().CreateNewContentItem() because appErrorModel is not null", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);
      return null;
    } else if (dataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().CreateNewContentItem() because data is null", tag: tag);
      return null;
    }

    String contentId = dataResponseModel.data!;
    MyPrint.printOnConsole("Final contentId:'$contentId'", tag: tag);

    return contentId;
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
      ThumbnailImagePath: coCreateContentAuthoringModel.ThumbnailImagePath,
      MediaTypeID: coCreateContentAuthoringModel.mediaTypeId.toString(),
      Language: repository.apiController.apiDataProvider.getLocale(),
      Bit3: coCreateContentAuthoringModel.contentTypeId == InstancyObjectTypes.referenceUrl,
      StartPage: coCreateContentAuthoringModel.referenceUrl ?? "",
    );

    CreateNewContentItemRequestModel requestModel = CreateNewContentItemRequestModel(
      formData: createNewContentItemFormDataModel,
      ObjectTypeID: coCreateContentAuthoringModel.contentTypeId,
    );

    if (coCreateContentAuthoringModel.flashcardContentModel != null) {
      FlashcardContentModel flashcardContentModel = coCreateContentAuthoringModel.flashcardContentModel!;
      requestModel.additionalData = flashcardContentModel.toString();
    }
    if (coCreateContentAuthoringModel.quizContentModel != null) {
      QuizContentModel quizContentModel = coCreateContentAuthoringModel.quizContentModel!;
      requestModel.additionalData = quizContentModel.toString();
    }
    if (coCreateContentAuthoringModel.eventModel != null) {
      EventModel eventModel = coCreateContentAuthoringModel.eventModel!;
      createNewContentItemFormDataModel.EventStartDateTime = "${eventModel.date} ${eventModel.startTime}";
      createNewContentItemFormDataModel.EventEndDateTime = "${eventModel.date} ${eventModel.endTime}";
      createNewContentItemFormDataModel.RegistrationURL = eventModel.eventUrl;
      createNewContentItemFormDataModel.Location = eventModel.location;
      requestModel.additionalData = eventModel.toString();
    }
    if (coCreateContentAuthoringModel.roleplayContentModel != null) {
      RoleplayContentModel roleplayContentModel = coCreateContentAuthoringModel.roleplayContentModel!;
      requestModel.additionalData = roleplayContentModel.toString();
    }

    return requestModel;
  }

  void initializeContentDataInCourseDTOModelFromCoCreateContentAuthoringModel({required CoCreateContentAuthoringModel coCreateContentAuthoringModel}) {
    CourseDTOModel? courseDTOModel = coCreateContentAuthoringModel.courseDTOModel ?? coCreateContentAuthoringModel.newCurrentCourseDTOModel;
    if (courseDTOModel == null) {
      return;
    }

    courseDTOModel.ContentID = coCreateContentAuthoringModel.contentId;

    courseDTOModel.ContentName = coCreateContentAuthoringModel.title;
    courseDTOModel.Title = coCreateContentAuthoringModel.title;
    courseDTOModel.TitleName = coCreateContentAuthoringModel.title;
    courseDTOModel.ShortDescription = coCreateContentAuthoringModel.description;
    courseDTOModel.LongDescription = coCreateContentAuthoringModel.description;
    courseDTOModel.ContentType = coCreateContentAuthoringModel.contentType;
    courseDTOModel.ThumbnailImagePath = coCreateContentAuthoringModel.ThumbnailImagePath;
    courseDTOModel.thumbNailFileBytes = coCreateContentAuthoringModel.thumbNailImageBytes;
    courseDTOModel.Skills = coCreateContentAuthoringModel.skills;

    if (coCreateContentAuthoringModel.contentTypeId == InstancyObjectTypes.referenceUrl) {
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
    coCreateContentAuthoringModel.thumbNailImageBytes = courseDTOModel.thumbNailFileBytes;
    coCreateContentAuthoringModel.skills = courseDTOModel.Skills;

    if (coCreateContentAuthoringModel.contentTypeId == InstancyObjectTypes.referenceUrl) {
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
}
