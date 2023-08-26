import 'package:flutter_instancy_2/models/message/response_model/chat_users_list_response_model.dart';

import '../../api/api_call_model.dart';
import '../../api/api_controller.dart';
import '../../api/api_endpoints.dart';
import '../../api/api_url_configuration_provider.dart';
import '../../api/rest_client.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/model_data_parser.dart';
import '../../models/message/request_model/attachment_upload_request_model.dart';
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

  Future<DataResponseModel<String>> uploadMessageFileData({required AttachmentUploadRequestModel attachmentUploadRequestModel}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData(
      restCallType: RestCallType.multipartRequestCall,
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.genericFileUpload(),
      fields: attachmentUploadRequestModel.toMap(),
      files: attachmentUploadRequestModel.fileUploads,
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
}
