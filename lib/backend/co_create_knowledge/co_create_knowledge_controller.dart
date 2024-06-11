import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_chat_bot/utils/my_print.dart';
import 'package:flutter_instancy_2/api/api_url_configuration_provider.dart';
import 'package:flutter_instancy_2/backend/app/dependency_injection.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/app_ststem_configurations.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/request_model/create_new_content_item_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/request_model/generate_images_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/response_model/avatar_voice_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/response_model/avtar_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/common/response_model/background_response_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/flashcards/flashcard_request_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/quiz/request_model/assessment_generate_request_model.dart';
import 'package:flutter_instancy_2/models/common/data_response_model.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/models/profile/data_model/user_profile_details_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';

import '../../api/api_controller.dart';
import '../../models/co_create_knowledge/flashcards/flashcard_model.dart';
import '../../models/co_create_knowledge/quiz/data_models/quiz_question_model.dart';
import 'co_create_knowledge_provider.dart';
import 'co_create_knowledge_repository.dart';

class CoCreateKnowledgeController {
  late CoCreateKnowledgeProvider _coCreateKnowledgeProvider;
  late CoCreateKnowledgeRepository _coCreateKnowledgeRepository;

  CoCreateKnowledgeController({required CoCreateKnowledgeProvider? coCreateKnowledgeProvider, CoCreateKnowledgeRepository? repository, ApiController? apiController}) {
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

  Future<FlashcardResponseModel?> generateFlashcard({required FlashcardRequestModel requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().CreateNewContentItem() called with requestModel:$requestModel", tag: tag);

    CoCreateKnowledgeRepository repository = coCreateKnowledgeRepository;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = repository.apiController.apiDataProvider;
    String authorName = "";

    // UserProfileDetailsModel? userProfileDetailsModel = DependencyInjection.profileProvider.userProfileDetails.getList(isNewInstance: false).firstElement;
    // if (userProfileDetailsModel != null) {
    //   authorName = "${userProfileDetailsModel.firstname} ${userProfileDetailsModel.lastname}";
    // }

    AppSystemConfigurationModel appSystemConfigurationModel = DependencyInjection.appProvider.appSystemConfigurationModel;

    // requestModel.authorName = authorName;
    requestModel.userID = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.siteID = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.clientUrl = apiUrlConfigurationProvider.getCurrentSiteUrl();

    // requestModel.FolderID = appSystemConfigurationModel.CoCreateKnowledgeDefaultFolderID;
    // requestModel.CMSGroupID = appSystemConfigurationModel.CoCreateKnowledgeDefaultFolderID;

    DataResponseModel<FlashcardResponseModel> dataResponseModel = await repository.generateFlashcard(requestModel: requestModel);
    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateFlashcard() because appErrorModel is not null", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);
      return null;
    } else if (dataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateFlashcard() because data is null", tag: tag);
      return null;
    }
    MyPrint.printOnConsole("FlashcardResponseModel : ${dataResponseModel.data}'", tag: tag);

    FlashcardResponseModel responseModel = FlashcardResponseModel.fromMap(dataResponseModel.data!.toMap());
    MyPrint.printOnConsole("Final contentId:'${responseModel.flashcards.length}'", tag: tag);

    return responseModel;
  }

  Future<QuizResponseModel?> generateQuiz({required AssessmentGenerateRequestModel requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CoCreateKnowledgeController().generateQuiz() called with requestModel:$requestModel", tag: tag);

    CoCreateKnowledgeRepository repository = coCreateKnowledgeRepository;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = repository.apiController.apiDataProvider;
    String authorName = "";

    // UserProfileDetailsModel? userProfileDetailsModel = DependencyInjection.profileProvider.userProfileDetails.getList(isNewInstance: false).firstElement;
    // if (userProfileDetailsModel != null) {
    //   authorName = "${userProfileDetailsModel.firstname} ${userProfileDetailsModel.lastname}";
    // }

    AppSystemConfigurationModel appSystemConfigurationModel = DependencyInjection.appProvider.appSystemConfigurationModel;

    // requestModel.authorName = authorName;
    requestModel.adminUrl = coCreateKnowledgeRepository.apiController.apiEndpoints.getAdminSiteUrl();
    requestModel.requestedBy = apiUrlConfigurationProvider.getCurrentUserId().toString();

    DataResponseModel<String> dataResponseModel = await repository.chatCompletionCall(prompt: requestModel.prompt);
    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateQuiz() because appErrorModel is not null", tag: tag);
      MyPrint.printOnConsole("appErrorModel:${dataResponseModel.appErrorModel}", tag: tag);
      return null;
    } else if (dataResponseModel.data == null) {
      MyPrint.printOnConsole("Returning from CoCreateKnowledgeController().generateQuiz() because data is null", tag: tag);
      return null;
    }

    if (dataResponseModel.data != null) {
      MyPrint.printOnConsole("dataResponseModel.data : ${dataResponseModel.data}");
      Map mapResponse = jsonDecode(dataResponseModel.data!);
      String? learningObjective = mapResponse["learning_objectives"];
      MyPrint.printOnConsole("learningObjective : $learningObjective");
      if (learningObjective != null || learningObjective.checkNotEmpty) {
        requestModel.learningObjectives = learningObjective ?? "";
        requestModel.isContentAvailable = true;
        DataResponseModel<String> assessmentDataResponseModel = await repository.assessmentGenerateContent(requestModel: requestModel);

        if (assessmentDataResponseModel.data != null) {
          MyPrint.printOnConsole("assessmentDataResponseModel.data : ${assessmentDataResponseModel.data}");
          Map mapResponse2 = jsonDecode(assessmentDataResponseModel.data!);
          MyPrint.printOnConsole("mapResponse[generated_content] : ${mapResponse2["generated_content"]}");
          String generatedContent = mapResponse2["generated_content"];
          MyPrint.printOnConsole("generatedContent : $generatedContent");
          requestModel.content = generatedContent;
          requestModel.learningObjectives = "";

          DataResponseModel<String> generateAssessmentDataResponseModel = await repository.generateAssessment(requestModel: requestModel);

          if (generateAssessmentDataResponseModel.data != null) {
            Map mapResponse3 = jsonDecode(generateAssessmentDataResponseModel.data!);
            MyPrint.printOnConsole("mapResponse3 : ${mapResponse3}");

            QuizResponseModel quizResponseModel = QuizResponseModel.fromMap(Map.from(mapResponse3));
            MyPrint.printOnConsole("quizResponseModel.assessment.length : ${quizResponseModel.assessment.length}");

            return quizResponseModel;
          }
        }
      }
    }

    return null;
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

// Future<List<FileUploadControlsModel>> getFileUploadControlsFromApi({
//   bool isRefresh = true,
//   bool isGetFromCache = false,
//   bool isNotify = true,
//   required int componentId,
//   required int componentInstanceId,
// }) async {
//   List<FileUploadControlsModel> fileUploadControlList = [];
//
//   CoCreateKnowledgeProvider provider = coCreateKnowledgeProvider;
//
//   DataResponseModel<List<FileUploadControlsModel>> response = await coCreateKnowledgeRepository.getFileUploadControlsModel(
//     componentId: componentId,
//     componentInstanceId: componentInstanceId,
//     isStoreDataInHive: true,
//   );
//
//   List<FileUploadControlsModel> fileUploadControlsModelList = response.data ?? <FileUploadControlsModel>[];
//   MyPrint.printOnConsole("fileUploadControlsModelList Length got in Api:${fileUploadControlsModelList.length}");
//
//   //region Set Provider Data After Getting Data From Api
//   // if (contentsList.length < provider.pageSize) provider.setHasMoreMyLearningData(value: false);
//   // if(contentsList.isNotEmpty) provider.setMyLearningPageIndex(value: provider.myLearningPageIndex + 1);
//   provider.setFileUploadControlsModelList(fileUploadControlsModelList);
//   // provider.addMyLearningContentsInList(myLearningContentModels: contentsList, isClear: false, isNotify: false);
//   // provider.setIsMyLearningContentsFirstTimeLoading(false, isNotify: false);
//   // provider.setIsMyLearningContentsLoading(false, isNotify: true);
//   // //endregion
//
//   return fileUploadControlList;
// }
//
// Future<CoCreateKnowledgeCategoriesModel> getCoCreateKnowledgeCategoriesFromApi({bool isRefresh = true, bool isGetFromCache = false, bool isNotify = true, required int componentId, required int componentInstanceId}) async {
//   CoCreateKnowledgeCategoriesModel wikiCategoriesModel = CoCreateKnowledgeCategoriesModel();
//   CoCreateKnowledgeProvider provider = coCreateKnowledgeProvider;
//   DataResponseModel<CoCreateKnowledgeCategoriesModel> response = await coCreateKnowledgeRepository.getCoCreateKnowledgeCategories(
//     componentId: componentId,
//     componentInstanceId: componentInstanceId,
//     isStoreDataInHive: true,
//   );
//   wikiCategoriesModel = response.data ?? CoCreateKnowledgeCategoriesModel();
//   MyPrint.printOnConsole("wikiCategoriesModel length:${wikiCategoriesModel.wikiCategoriesList.length}");
//   if (wikiCategoriesModel.wikiCategoriesList.isNotEmpty) {
//     provider.setCoCreateKnowledgeCategoriesList(wikiCategoriesModel.wikiCategoriesList);
//   }
//   return wikiCategoriesModel;
// }
//
// Future<DataResponseModel<String>> addContent({required CoCreateKnowledgeUploadRequestModel wikiUploadRequestModel}) async {
//   String tag = MyUtils.getNewId();
//   MyPrint.printOnConsole("CoCreateKnowledgeController().addContent() called", tag: tag);
//
//   ApiUrlConfigurationProvider apiUrlConfigurationProvider = coCreateKnowledgeRepository.apiController.apiDataProvider;
//   wikiUploadRequestModel.userID = apiUrlConfigurationProvider.getCurrentUserId();
//   wikiUploadRequestModel.siteID = apiUrlConfigurationProvider.getCurrentSiteId();
//   wikiUploadRequestModel.locale = apiUrlConfigurationProvider.getLocale();
//
//   DataResponseModel<String> response = await coCreateKnowledgeRepository.addCatalogContent(wikiUploadRequestModel: wikiUploadRequestModel);
//   MyPrint.printOnConsole("Add Content Response:${response.data}", tag: tag);
//   MyPrint.printOnConsole("Add Content Response Type:${response.data?.runtimeType}", tag: tag);
//
//   DataResponseModel<String> newResponse;
//
//   String data = response.data ?? "";
//   if (data.startsWith("failed") || data.startsWith("A content item already exists with this name.")) {
//     // MyPrint.printOnConsole("")
//     newResponse = DataResponseModel<String>(
//       data: response.data,
//       appErrorModel: AppErrorModel(
//         message: response.data!,
//       ),
//     );
//   } else {
//     newResponse = response;
//
//     BuildContext? context = NavigationController.mainNavigatorKey.currentContext;
//     if (context != null && context.mounted) {
//       GamificationController(provider: context!.read<GamificationProvider>()).UpdateContentGamification(
//         requestModel: UpdateContentGamificationRequestModel(
//           contentId: "",
//           scoId: -1,
//           objecttypeId: -1,
//           GameAction: GamificationActionType.AddedContent,
//         ),
//       );
//     }
//   }
//
//   return newResponse;
// }
}
