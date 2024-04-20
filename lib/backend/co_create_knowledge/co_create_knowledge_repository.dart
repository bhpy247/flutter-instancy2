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
            AuthorDisplayName: "David",
            ContentTypeId: InstancyObjectTypes.article,
            MediaTypeID: InstancyMediaTypes.video,
            ContentType: "Article"),
        CourseDTOModel(
            Title: "Generative AI and its Transformative Potential",
            AuthorDisplayName: "Richard Parker",
            ContentTypeId: InstancyObjectTypes.referenceUrl,
            MediaTypeID: InstancyMediaTypes.audio,
            ContentType: "Reference Link"),
        CourseDTOModel(
            Title: "Mastering Communication: Essential Skills for Success",
            AuthorDisplayName: "Abcd Cypress",
            ContentTypeId: InstancyObjectTypes.videos,
            MediaTypeID: InstancyMediaTypes.video,
            ContentType: "Video"),
        CourseDTOModel(
            Title: "Artificial intelligence (AI)",
            AuthorDisplayName: "Rana Pratap Jayadev DND",
            ContentTypeId: InstancyObjectTypes.flashCard,
            MediaTypeID: InstancyMediaTypes.audio,
            ContentType: "Flashcards"),
        CourseDTOModel(
            Title: "AI Note Taking",
            AuthorDisplayName: "pradeep sy flutter reddy",
            ContentTypeId: InstancyObjectTypes.podcastEpisode,
            MediaTypeID: InstancyMediaTypes.document,
            ContentType: "Podcast Episode"),
        CourseDTOModel(
            Title: "VR Module 202425", AuthorDisplayName: "pradeep sy flutter reddy", ContentTypeId: InstancyObjectTypes.quiz, MediaTypeID: InstancyMediaTypes.document, ContentType: "Quiz"),
        CourseDTOModel(
            Title: "Exploring the Intersection of Artificial Intelligence and Biotechnology",
            AuthorDisplayName: "pradeep sy flutter reddy",
            ContentTypeId: InstancyObjectTypes.document,
            MediaTypeID: InstancyMediaTypes.document,
            ContentType: "Documents"),
        CourseDTOModel(
            Title: "Assessment Progress Report",
            AuthorDisplayName: "pradeep sy flutter reddy",
            ContentTypeId: InstancyObjectTypes.rolePlay,
            MediaTypeID: InstancyMediaTypes.document,
            ContentType: "Roleplay"),
        CourseDTOModel(
            Title: "Junior Level Design 1",
            AuthorDisplayName: "pradeep sy flutter reddy",
            ContentTypeId: InstancyObjectTypes.learningMaps,
            MediaTypeID: InstancyMediaTypes.document,
            ContentType: "Learning Maps"),
        CourseDTOModel(
            Title: "AI Learning in instancy",
            AuthorDisplayName: "pradeep sy flutter reddy",
            ContentTypeId: InstancyObjectTypes.aiAgent,
            MediaTypeID: InstancyMediaTypes.document,
            ContentType: "AI Agents"),
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
