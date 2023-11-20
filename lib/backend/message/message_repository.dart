import 'package:flutter_instancy_2/models/message/response_model/chat_users_list_response_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';

import '../../api/api_call_model.dart';
import '../../api/api_controller.dart';
import '../../api/api_endpoints.dart';
import '../../api/api_url_configuration_provider.dart';
import '../../api/rest_client.dart';
import '../../models/common/Instancy_multipart_file_upload_model.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/model_data_parser.dart';
import '../../models/message/request_model/send_chat_message_request_model.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';

class MessageRepository {
  final ApiController apiController;

  const MessageRepository({required this.apiController});

  Future<DataResponseModel<ChatUsersListResponseModel>> getMessageUserList({
    bool isFromOffline = false,
    bool isStoreDataInHive = false,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.chatUsersListResponseModel,
      url: apiEndpoints.getMessageUserList(),
      requestBody: MyUtils.encodeJson({
        "FromUserID": apiUrlConfigurationProvider.getCurrentUserId(),
        "intSiteiD": apiUrlConfigurationProvider.getCurrentSiteId(),
      }),
      isGetDataFromHive: isFromOffline,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<ChatUsersListResponseModel> apiResponseModel = await apiController.callApi<ChatUsersListResponseModel>(
      apiCallModel: apiCallModel,
    );
    MyPrint.printOnConsole("aspi call model: ${apiResponseModel.data}");

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> setArchiveAndUnArchive(
      {bool isFromOffline = false, bool isStoreDataInHive = false, bool isArchived = false, int intArchivedUserID = -1, int intDeleteUserID = 0}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.getArchiveAndUnarchive(),
      queryParameters: {
        "intUserID": "${apiUrlConfigurationProvider.getCurrentUserId()}",
        "intArchivedUserID": "${isArchived ? intArchivedUserID : "-1"}",
        "intDeleteUserID": "$intDeleteUserID",
      },
      isGetDataFromHive: isFromOffline,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );
    MyPrint.printOnConsole("aspi call model: ${apiResponseModel.data}");

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> uploadGenericFiles({required List<InstancyMultipartFileUploadModel> instancyMultipartFileUploadModels, String? filePath}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData(
      restCallType: RestCallType.saveGenericFilesCall,
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.genericFileUpload(),
      files: instancyMultipartFileUploadModels,
      fields: {
        if (filePath.checkNotEmpty) 'FilePath': filePath!,
      },
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> sendMessage({
    required SendChatMessageRequestModel requestModel,
    bool isFromOffline = false,
    bool isStoreDataInHive = false,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData(
      restCallType: RestCallType.multipartRequestCall,
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.sendChatMessage(),
      fields: requestModel.toJson(),
      isGetDataFromHive: isFromOffline,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );
    MyPrint.printOnConsole("aspi call model: ${apiResponseModel.data}");

    return apiResponseModel;
  }

  Future<DataResponseModel<ChatUsersListResponseModel>> getUserChatHistory({
    bool isFromOffline = false,
    bool isStoreDataInHive = false,
    required SendChatMessageRequestModel requestModel,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.chatUsersListResponseModel,
      url: apiEndpoints.getUserChatHistory(),
      requestBody: MyUtils.encodeJson({
        "FromUserID": requestModel.FromUserID,
        "ToUserID": requestModel.ToUserID,
        "MarkAsRead": requestModel.MarkAsRead,
      }),
      isGetDataFromHive: isFromOffline,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<ChatUsersListResponseModel> apiResponseModel = await apiController.callApi<ChatUsersListResponseModel>(
      apiCallModel: apiCallModel,
    );
    MyPrint.printOnConsole("aspi call model: ${apiResponseModel.data}");

    return apiResponseModel;
  }
}
