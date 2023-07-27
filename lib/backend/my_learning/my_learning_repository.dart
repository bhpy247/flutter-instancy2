import 'package:flutter_instancy_2/models/common/app_error_model.dart';
import 'package:flutter_instancy_2/models/my_learning/request_model/my_learning_data_request_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';

import '../../api/api_call_model.dart';
import '../../api/api_controller.dart';
import '../../api/api_endpoints.dart';
import '../../api/api_url_configuration_provider.dart';
import '../../api/rest_client.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/model_data_parser.dart';
import '../../models/my_learning/request_model/get_completion_certificate_params_model.dart';
import '../../models/my_learning/response_model/my_learning_response_dto_model.dart';
import '../../models/my_learning/response_model/page_notes_response_model.dart';
import '../../utils/my_print.dart';

class MyLearningRepository {
  final ApiController apiController;

  const MyLearningRepository({required this.apiController});

  Future<DataResponseModel<MyLearningResponseDTOModel>> getMyLearningContentsListMain({
    required MyLearningDataRequestModel requestModel,
    required int componentId,
    required int componentInstanceId,
    bool isFromOffline = false,
    bool isStoreDataInHive = false,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.myLearningResponseDTOModel,
      url: apiEndpoints.apiGetMyLearningObjectsData(),
      requestBody: MyUtils.encodeJson(requestModel.toJson()),
      isGetDataFromHive: isFromOffline,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<MyLearningResponseDTOModel> apiResponseModel = await apiController.callApi<MyLearningResponseDTOModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> addRemoveFromArchieve({
    required String contentID,
    required bool isArchived,
  }) async {
    MyPrint.printOnConsole('MyLearningRepository().addRemoveFromArchieve() called with contentID:$contentID, isArchived:$isArchived');

    if(contentID.isEmpty) {
      return DataResponseModel(
        appErrorModel: AppErrorModel(
          message: "Content ID is empty",
        ),
      );
    }

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.apiGetUpdateMyLearningArchive(),
      requestBody: MyUtils.encodeJson({
        'ContentID': contentID,
        'IsArchived': isArchived ? 1 : 0,
        'UserID': apiUrlConfigurationProvider.getCurrentUserId(),
      }),
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> setCompleteStatus({
    required String contentID,
    required int scoId,
  }) async {
    MyPrint.printOnConsole('MyLearningRepository().setCompleteStatus() called with contentID:$contentID, scoId:$scoId');

    if(contentID.isEmpty) {
      return DataResponseModel(
        appErrorModel: AppErrorModel(
          message: "Content ID is empty",
        ),
      );
    }

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.apiGetSetStatusCompleted(),
      queryParameters: <String, String>{
        'ContentID': contentID,
        'ScoId': scoId.toString(),
        'UserID': apiUrlConfigurationProvider.getCurrentUserId().toString(),
        'SiteID': apiUrlConfigurationProvider.getCurrentSiteId().toString(),
      },
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }
  Future<DataResponseModel<String>> setCompleteStatusMyLearning({
    required String contentID,
    required int scoId,
  }) async {
    MyPrint.printOnConsole('MyLearningRepository().setCompleteStatus() called with contentID:$contentID, scoId:$scoId');

    if(contentID.isEmpty) {
      return DataResponseModel(
        appErrorModel: AppErrorModel(
          message: "Content ID is empty",
        ),
      );
    }

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
    Map<String,dynamic> requestBody = {
      'ContentID': contentID,
      'ScoId': scoId.toString(),
      'UserID': apiUrlConfigurationProvider.getCurrentUserId().toString(),
    };


    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.string,
      requestBody: MyUtils.encodeJson(requestBody),
      url: apiEndpoints.setCompleteStatusCatalog(),
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> getCompletionCertificatePath({
    required GetCompletionCertificateParamsModel paramsModel,
  }) async {
    MyPrint.printOnConsole('MyLearningRepository().getCompletionCertificatePath() called with paramsModel:$paramsModel');

    if(paramsModel.Content_ID.isEmpty) {
      return DataResponseModel(
        appErrorModel: AppErrorModel(
          message: "Content ID is empty",
        ),
      );
    }

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    paramsModel.UserID = apiUrlConfigurationProvider.getCurrentUserId();
    paramsModel.SiteID = apiUrlConfigurationProvider.getCurrentSiteId();
    paramsModel.siteURL = apiUrlConfigurationProvider.getCurrentSiteUrl();
    paramsModel.height = 530;
    paramsModel.width = 845;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.getMyLearningCompletionCertificate(),
      queryParameters: paramsModel.toMap(),
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<PageNotesResponseModel>> getPageNotes({
    required String contentId,
    required int componentId,
    required int componentInstanceId,
    bool isFromOffline = false,
    bool isStoreDataInHive = false,
  }) async {
    MyPrint.printOnConsole("repo getAssociatedContent");
    try {
      ApiEndpoints apiEndpoints = apiController.apiEndpoints;


      MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl} 2023-03-02 20:39:53 ${DateTime.now().toString()}");
      ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
      ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
        restCallType: RestCallType.simpleGetCall,
        parsingType: ModelDataParsingType.pageNoteResponseModel,
        url: apiEndpoints.getPageNotes(
            contentId: contentId,
            userId: apiUrlConfigurationProvider.getCurrentUserId(),
            componentId: componentId,
            componentInstanceId: componentInstanceId,
            siteId: apiUrlConfigurationProvider.getCurrentSiteId(),
            locale: apiUrlConfigurationProvider.getLocale()
        ),
        isGetDataFromHive: isFromOffline,
        isStoreDataInHive: isStoreDataInHive,
      );
      DataResponseModel<PageNotesResponseModel> apiResponseModel = await apiController.callApi<PageNotesResponseModel>(
        apiCallModel: apiCallModel,
      );
      MyPrint.printOnConsole("apiCallModel : ${apiResponseModel.data}");
      MyPrint.printOnConsole("Repo getAssociatedContent : ${apiResponseModel.data}");
      return apiResponseModel;

    } catch (e,s){
      MyPrint.printOnConsole("Error CatalogRepository.getAssociatedContent() :$e");
      MyPrint.printOnConsole(s);
      return const DataResponseModel();
    }
  }

  Future<DataResponseModel<String>> savePageNote({
    required String contentID,
    required int pageId,
    required String trackId,
    required int seqId,
    required int count,
    required String text,


  }) async {
    MyPrint.printOnConsole('MyLearningRepository().addRemoveFromArchieve() called with contentID:$contentID, isArchived:ived');

    if(contentID.isEmpty) {
      return DataResponseModel(
        appErrorModel: AppErrorModel(
          message: "Content ID is empty",
        ),
      );
    }

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.saveUserPageNote(),
      requestBody: MyUtils.encodeJson({
        'ContentID': contentID,
        'UserID': apiUrlConfigurationProvider.getCurrentUserId(),
        'PageID': pageId,
        'TrackID': trackId,
        'SeqID': seqId,
        'UserNotes': text,
      }),
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> deletePageNotes({
    required String contentID,
    required int pageId,
    required String trackId,
    required int seqId,
    required int count,


  }) async {
    MyPrint.printOnConsole('MyLearningRepository().addRemoveFromArchieve() called with contentID:$contentID, isArchived:ived');

    if(contentID.isEmpty) {
      return DataResponseModel(
        appErrorModel: AppErrorModel(
          message: "Content ID is empty",
        ),
      );
    }

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.deleteUserPageNote(
        count: count,pageId: pageId,seqId: seqId,trackId: "$trackId",contentId: contentID,siteId: apiUrlConfigurationProvider.getCurrentSiteId(),userId:apiUrlConfigurationProvider.getCurrentUserId()
      ),
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }
}
