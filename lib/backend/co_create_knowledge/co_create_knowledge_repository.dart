import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/common/Instancy_multipart_file_upload_model.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/models/wiki_component/response_model/wikiCategoriesModel.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../api/api_call_model.dart';
import '../../api/api_controller.dart';
import '../../api/api_endpoints.dart';
import '../../api/api_url_configuration_provider.dart';
import '../../api/rest_client.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/model_data_parser.dart';
import '../../models/wiki_component/request_model/wiki_upload_request_model.dart';
import '../../utils/my_print.dart';

class CoCreateKnowledgeRepository {
  final ApiController apiController;

  const CoCreateKnowledgeRepository({required this.apiController});

  Future<DataResponseModel<List<CourseDTOModel>>> getMyKnowledgeList({required int componentId, required int componentInstanceId}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.fileUploadControlModel,
      url: apiEndpoints.apiGetFileUploadControl(
        componentInstanceId: ParsingHelper.parseStringMethod(componentInstanceId),
        siteId: apiUrlConfigurationProvider.getCurrentSiteId(),
        locale: apiUrlConfigurationProvider.getLocale(),
      ),
    );
    await Future.delayed(const Duration(seconds: 1));

    // DataResponseModel<List<CourseDTOModel>> apiResponseModel = await apiController.callApi<List<CourseDTOModel>>(
    //   apiCallModel: apiCallModel,
    // );
    DataResponseModel<List<CourseDTOModel>> apiResponseModel = DataResponseModel<List<CourseDTOModel>>(
      data: [
        CourseDTOModel(
          Title: "Large Language Models: A Deep Dive into Their Functionality and Impact",
          TitleName: "Large Language Models: A Deep Dive into Their Functionality and Impact",
          ContentName: "Large Language Models: A Deep Dive into Their Functionality and Impact",
          AuthorName: "Richard Parker",
          AuthorDisplayName: "Richard Parker",
          UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
          ContentTypeId: InstancyObjectTypes.article,
          MediaTypeID: InstancyMediaTypes.none,
          ContentType: "Article",
          ThumbnailImagePath: "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FLLM%20(1).jpg?alt=media&token=ea35d96c-029d-422e-918d-ddbb9d138a3f",
          ShortDescription: "Explore the inner workings and profound influence of these advanced linguistic systems, reshaping how we interact with information and technology.",
        ),
        CourseDTOModel(
          Title: "Generative AI and its Transformative Potential",
          TitleName: "Generative AI and its Transformative Potential",
          ContentName: "Generative AI and its Transformative Potential",
          AuthorName: "Richard Parker",
          AuthorDisplayName: "Richard Parker",
          UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
          ContentTypeId: InstancyObjectTypes.referenceUrl,
          MediaTypeID: InstancyMediaTypes.none,
          ContentType: "Reference Link",
          ThumbnailImagePath: "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FGenerative%20AI%20(1).jpg?alt=media&token=42d9004b-9dd8-4d30-a889-982996d6cd6d",
          ShortDescription: "Uncover the revolutionary capabilities of Generative AI, poised to reshape industries and creative expression with its innovative potential.",
        ),
        CourseDTOModel(
          Title: "AI agents memory and Personalize learning",
          TitleName: "AI agents memory and Personalize learning",
          ContentName: "AI agents memory and Personalize learning",
          AuthorName: "Richard Parker",
          AuthorDisplayName: "Richard Parker",
          UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
          ContentTypeId: InstancyObjectTypes.videos,
          MediaTypeID: InstancyMediaTypes.none,
          ContentType: "Video",
          ThumbnailImagePath:
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FMastering%20Communication%20(1).jpg?alt=media&token=a5031b2e-2f73-4270-b710-6373ede36b4e",
          ShortDescription:
              "Unlock the power of AI agents in personalized learning! This course explores the intricacies of memory systems in AI, guiding you through techniques to tailor learning experiences for individual students. Learn how AI agents adapt content delivery based on learner preferences, track progress, and create personalized pathways. Perfect for educators, AI enthusiasts, and developers looking to revolutionize education with AI.",
        ),
        CourseDTOModel(
          Title: "Artificial intelligence (AI)",
          TitleName: "Artificial intelligence (AI)",
          ContentName: "Artificial intelligence (AI)",
          AuthorName: "Richard Parker",
          AuthorDisplayName: "Richard Parker",
          UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
          ContentTypeId: InstancyObjectTypes.flashCard,
          MediaTypeID: InstancyMediaTypes.none,
          ContentType: "Flashcards",
          ThumbnailImagePath:
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FArtificial%20Intelligence%20(1).jpg?alt=media&token=eea140e2-20ec-4077-b42a-ccebd8046624",
          ShortDescription: "Delve into the realm of Artificial Intelligence, where machine learning and cognitive computing converge to redefine the boundaries of human innovation.",
        ),
        CourseDTOModel(
          Title: "AI Note Taker",
          TitleName: "AI Note Taker",
          ContentName: "AI Note Taker",
          AuthorName: "Richard Parker",
          AuthorDisplayName: "Richard Parker",
          UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
          ContentTypeId: InstancyObjectTypes.podcastEpisode,
          MediaTypeID: InstancyMediaTypes.none,
          ContentType: "Podcast Episode",
          ThumbnailImagePath:
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FAI%20Note%20Taker%20(1).jpg?alt=media&token=476bc0ba-3fe5-4558-8802-df3273621b83",
          ShortDescription:
              "Experience the future of productivity with an AI-powered note-taking assistant, revolutionizing how information is captured, organized, and accessed for enhanced efficiency and collaboration.",
        ),
        CourseDTOModel(
          Title: "Office Ergonomics",
          TitleName: "Office Ergonomics",
          ContentName: "Office Ergonomics",
          AuthorName: "Richard Parker",
          AuthorDisplayName: "Richard Parker",
          UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
          ContentTypeId: InstancyObjectTypes.quiz,
          MediaTypeID: InstancyMediaTypes.none,
          ContentType: "Quiz",
          ThumbnailImagePath:
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FOffice%20Ergonomics%20(1).jpg?alt=media&token=e8b61e56-79d8-4257-bd6e-fdad51d0b9f9",
          ShortDescription: "Discover the science of workplace comfort and efficiency, optimizing your workspace to enhance productivity and well-being through ergonomic principles.",
        ),
        CourseDTOModel(
          Title: "Exploring the Intersection of Artificial Intelligence and Biotechnology",
          TitleName: "Exploring the Intersection of Artificial Intelligence and Biotechnology",
          ContentName: "Exploring the Intersection of Artificial Intelligence and Biotechnology",
          AuthorName: "Richard Parker",
          AuthorDisplayName: "Richard Parker",
          UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
          ContentTypeId: InstancyObjectTypes.document,
          MediaTypeID: InstancyMediaTypes.none,
          ViewLink: "https://qalearning.instancy.com//content/publishfiles/d6caf328-6c9e-43b1-8ba0-eb8d4d065e66/en-us/41cea17c-728d-4c88-9cd8-1e0473fa6f21.pdf?fromNativeapp=true",
          ContentType: "Documents",
          ThumbnailImagePath:
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FExploring%20the%20Intersection%20of%20Artificial%20Intelligence%20and%20Biotechnology.jpg?alt=media&token=a840ca3c-73af-4def-8f2e-93aa26d75cb3",
          ShortDescription: "Delve into the dynamic synergy between AI and biotech, uncovering how cutting-edge technology revolutionizes healthcare, agriculture, and beyond.",
        ),
        CourseDTOModel(
          Title: "Customer Query Resolution",
          TitleName: "Customer Query Resolution",
          ContentName: "Customer Query Resolution",
          AuthorName: "Richard Parker",
          AuthorDisplayName: "Richard Parker",
          UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
          ContentTypeId: InstancyObjectTypes.rolePlay,
          MediaTypeID: InstancyMediaTypes.none,
          ContentType: "Roleplay",
          ThumbnailImagePath:
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FCustomer%20Query%20Resolution.jpg?alt=media&token=ad125e85-2d39-42cc-b5af-2107a1159f5c",
          ShortDescription:
              "Efficiently address customer inquiries and concerns with personalized assistance and comprehensive solutions, ensuring satisfaction and fostering positive relationships through prompt and effective communication.",
        ),
        CourseDTOModel(
          Title: "Mastering Coding Languages",
          TitleName: "Mastering Coding Languages",
          ContentName: "Mastering Coding Languages",
          AuthorName: "Richard Parker",
          AuthorDisplayName: "Richard Parker",
          UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
          ContentTypeId: InstancyObjectTypes.learningMaps,
          MediaTypeID: InstancyMediaTypes.none,
          ContentType: "Learning Maps",
          ThumbnailImagePath:
              "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FMasteringCoding%20Languages.jpg?alt=media&token=49e7113e-e4fe-4905-9c48-0c385e5423f7",
          ShortDescription:
              "Embark on a journey to programming proficiency, mastering the syntax and semantics of coding languages to unlock endless possibilities in software development and innovation.",
        ),
        CourseDTOModel(
          Title: "AI Learning",
          TitleName: "AI Learning",
          ContentName: "AI Learning",
          AuthorName: "Richard Parker",
          AuthorDisplayName: "Richard Parker",
          UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
          ContentTypeId: InstancyObjectTypes.aiAgent,
          MediaTypeID: InstancyMediaTypes.none,
          ContentType: "AI Agents",
          ThumbnailImagePath: "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fimages%2FAI%20Learning.jpg?alt=media&token=c9aff7c7-d860-4a84-8bc2-4900ffaf7b5e",
          ShortDescription:
              "Dive into the world of Artificial Intelligence (AI) with this comprehensive program. Explore key concepts, algorithms, and applications to develop the skills needed for success in this dynamic field.",
        ),
        CourseDTOModel(
          Title: "Certification in Economic Growth and development",
          TitleName: "Certification in Economic Growth and development",
          ContentName: "Certification in Economic Growth and development",
          AuthorName: "Richard Parker",
          AuthorDisplayName: "Richard Parker",
          UserProfileImagePath: "https://enterprisedemo.instancy.com/Content/SiteFiles/374/ProfileImages/298_1.jpg",
          ContentTypeId: InstancyObjectTypes.events,
          MediaTypeID: InstancyMediaTypes.none,
          ContentType: "Events",
          ThumbnailImagePath: "/Content/SiteFiles/Images/Event.jpg",
          ShortDescription: "Unleash the potential of nations through economic growth and development",
          EventStartDateTime: "30 May 2024",
          EventStartDateTimeWithoutConvert: "05/30/2024 05:30:00 PM",
          EventEndDateTime: "30 May 2024",
          EventEndDateTimeTimeWithoutConvert: "05/30/2024 06:00:00 PM",
          Duration: "30 Minutes",
          AvailableSeats: "10",
        ),
      ],
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<WikiCategoriesModel>> getWikiCategories({required int componentId, required int componentInstanceId, bool isFromOffline = false, bool isStoreDataInHive = false}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole(" getWikiCategories Site Url:${apiEndpoints.siteUrl}  ");
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
    // {"intUserID":"363","intSiteID":"374","intComponentID":1,"Locale":"en-us","strType":"cat"}
    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      requestBody:
          '''{"intUserID":"${apiUrlConfigurationProvider.getCurrentUserId()}","intSiteID":"${apiUrlConfigurationProvider.getCurrentSiteId()}","intComponentID":$componentId,"Locale":"${apiUrlConfigurationProvider.getLocale()}","strType":"cat"}''',
      parsingType: ModelDataParsingType.wikiCategoriesModel,
      url: apiEndpoints.apiGetWikiCategories(),
      isGetDataFromHive: isFromOffline,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<WikiCategoriesModel> apiResponseModel = await apiController.callApi<WikiCategoriesModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> addCatalogContent({required WikiUploadRequestModel wikiUploadRequestModel}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    List<InstancyMultipartFileUploadModel> files = [];

    if (wikiUploadRequestModel.fileUploads != null) {
      files.addAll(wikiUploadRequestModel.fileUploads!);
    }

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData(
      restCallType: RestCallType.multipartRequestCall,
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.apiUploadWikiData(),
      fields: wikiUploadRequestModel.toMap(),
      files: files,
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }
}
