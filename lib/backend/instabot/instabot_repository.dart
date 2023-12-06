import 'package:flutter_chat_bot/models/authorization/response_model/bot_details_model.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/api/api_url_configuration_provider.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/models/authentication/data_model/native_login_dto_model.dart';

import '../../api/api_call_model.dart';
import '../../api/api_endpoints.dart';
import '../../api/rest_client.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/model_data_parser.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';

class InstabotRepository {
  final ApiController apiController;

  const InstabotRepository({required this.apiController});

  Future<DataResponseModel<String>> insertBotData({required AppProvider appProvider, required NativeLoginDTOModel successfulUserLoginModel}) async {
    MyPrint.printOnConsole("InstabotRepository().insertBotData() called");

    // MyPrint.printOnConsole("appProvider.profilePic:${appProvider.profilePic}");
    String imagePath = '';
    if (successfulUserLoginModel.image.toLowerCase().contains("profileimages/")) {
      imagePath = successfulUserLoginModel.image.toLowerCase().substring(successfulUserLoginModel.image.toLowerCase().indexOf("profileimages/"));
    }
    MyPrint.printOnConsole("Final imagePath:$imagePath");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    String strUserID = apiUrlConfigurationProvider.getCurrentUserId().toString();
    String strSiteID = apiUrlConfigurationProvider.getCurrentSiteId().toString();
    String language = apiUrlConfigurationProvider.getLocale();
    String token = apiUrlConfigurationProvider.getAuthToken();
    String name = successfulUserLoginModel.username;
    String email = successfulUserLoginModel.email;

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    Map<String, String> data = {
      "authorizeToken": token,
      "strCategoryStyle": "true",
      "BotName": "InstaBot",
      "BotIcon": appProvider.appSystemConfigurationModel.botChatIcon,
      "BotChatIcon": "",
      "bubbleBackgroundColor": "#8ed52f",
      "userBubbleBackgroundColor": "",
      "clientUrl": apiUrlConfigurationProvider.getCurrentSiteUrl(),
      "apiEndPointURL": apiUrlConfigurationProvider.getCurrentBaseApiUrl(),
      "AzureRootPath": appProvider.appSystemConfigurationModel.azureRootPath,
      "UserID": strUserID,
      "userEmail": email,
      "userName": name,
      "userAvatarImage": imagePath,
      "SiteID": strSiteID,
      "Locale": language,
      "chatbottokenUrl": appProvider.appSystemConfigurationModel.instancyBotEndPointURL,
      "BotGreetingContent": appProvider.appSystemConfigurationModel.botGreetingContent,
      "_knowledgebaseId": appProvider.appSystemConfigurationModel.beforeLoginKnowledgeBaseID,
      "SiteConfigPath": "/content/siteconfiguration",
      "SiteFilesPath": "/content/sitefiles"
    };

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.GetInsertBotData(),
      requestBody: MyUtils.encodeJson(data),
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<BotDetailsModel>> getSiteBotDetails() async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    String strUserID = apiUrlConfigurationProvider.getCurrentUserId().toString();
    String strSiteID = apiUrlConfigurationProvider.getCurrentSiteId().toString();
    String apiUrl = apiUrlConfigurationProvider.getCurrentBaseApiUrl().replaceFirst("http://", "https://");
    // String token = apiUrlConfigurationProvider.getAuthToken();
    String name = apiUrlConfigurationProvider.getCurrentSiteLearnerUrl().replaceFirst("http://", "https://");
    List<String> trustedOrigins = [
      apiUrlConfigurationProvider.getCurrentSiteLearnerUrl().replaceFirst("http://", "https://"),
      apiUrlConfigurationProvider.getCurrentSiteLMSUrl().replaceFirst("http://", "https://"),
    ];
    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.botDetailsModel,
      url: apiEndpoints.apiGetSiteBotDetails(
        instancyApiUrl: apiUrl,
      ),
      queryParameters: {
        "intSiteID": strSiteID,
      },
      requestBody: MyUtils.encodeJson({
        "User": {
          "id": strUserID,
          "name": name,
        },
        "trustedOrigins": trustedOrigins,
      }),
      isAuthenticatedApiCall: false,
    );

    DataResponseModel<BotDetailsModel> apiResponseModel = await apiController.makeApiCallAndParseData<BotDetailsModel>(
      apiCallModel,
    );
    return apiResponseModel;
  }
}
