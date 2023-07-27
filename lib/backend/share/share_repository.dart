import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:intl/intl.dart';

import '../../api/api_call_model.dart';
import '../../api/api_controller.dart';
import '../../api/api_endpoints.dart';
import '../../api/api_url_configuration_provider.dart';
import '../../api/rest_client.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/model_data_parser.dart';
import '../../models/share/request_model/share_with_people_request_model.dart';
import '../../models/share/response_model/share_connection_list_response_model.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';

class ShareRepository {
  final ApiController apiController;

  const ShareRepository({required this.apiController});

  Future<DataResponseModel<String>> shareWithPeople({
    required ShareWithPeopleRequestModel peopleRequestModel,
  }) async {
    MyPrint.printOnConsole('ShareRepository().shareWithPeople() called with peopleRequestModel:$peopleRequestModel');

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    peopleRequestModel.userID = apiUrlConfigurationProvider.getCurrentUserId();
    peopleRequestModel.siteID = apiUrlConfigurationProvider.getCurrentSiteId();
    peopleRequestModel.locale = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.getSendMailToPeopleUrl(),
      requestBody: MyUtils.encodeJson(peopleRequestModel.toMap()),
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<ShareConnectionListResponseModel>> getConnectionsListForShare() async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.shareConnectionListResponseModel,
      url: apiEndpoints.getMyConnectionsListForShareContentUrl(),
      queryParameters: {
        "UserID": apiUrlConfigurationProvider.getCurrentUserId().toString(),
        "SiteID": apiUrlConfigurationProvider.getCurrentSiteId().toString(),
        "OUList": apiUrlConfigurationProvider.getCurrentSiteId().toString(),
        "SearchText": "",
        "Category": "MyConnections",
      },
    );

    DataResponseModel<ShareConnectionListResponseModel> apiResponseModel = await apiController.callApi<ShareConnectionListResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<ShareConnectionListResponseModel>> getRecommendToUserList({String contentId = ""}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.shareConnectionListResponseModel,
      url: apiEndpoints.getRecommendToContentUrl(),
      //  // intUserID=466&strSearchText=&strContentID=8427ab0f-8474-4a7d-aa2a-d8c73e0ecbe2
      queryParameters: {
        "intUserID": apiUrlConfigurationProvider.getCurrentUserId().toString(),
        "strSearchText": "",
        "strContentID": contentId,
      },
    );

    DataResponseModel<ShareConnectionListResponseModel> apiResponseModel = await apiController.callApi<ShareConnectionListResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> insertRecommendedContent({String contentId = "", String recommendedTo = "", String addToMyLearning = "", int componentId = 0}) async {
    MyPrint.printOnConsole('ShareRepository().insertRecommendedContent() called with insertRecommendedContent:');

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    //https://upgradedenterpriseapi.instancy.com/api/AsktheExpert/InsertRecommendContent?RecommendedTo=491&RecommendedBy=466&ContentIDlist=6dfaac2c-e7b3-46c0-87c4-107ff48bce12&addtomylear=0&Componentid=1&siteid=374

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.getInsertRecommendedContentUrl(),
      queryParameters: {
        "RecommendedTo": "$recommendedTo",
        "RecommendedBy": "${apiUrlConfigurationProvider.getCurrentUserId()}",
        "ContentIDlist": "$contentId",
        "addtomylear": "0",
        "Componentid": "$componentId",
        "siteid": "${apiUrlConfigurationProvider.getCurrentSiteId()}"
      },
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> insertRecommendedContentNotification({String contentId = "", String recommendedTo = "", String addToMyLearning = "", int componentId = 0}) async {
    MyPrint.printOnConsole('ShareRepository().insertRecommendedContent() called with insertRecommendedContent:');

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    //https://upgradedenterpriseapi.instancy.com/api/AsktheExpert/InsertRecommendContent?RecommendedTo=491&RecommendedBy=466&ContentIDlist=6dfaac2c-e7b3-46c0-87c4-107ff48bce12&addtomylear=0&Componentid=1&siteid=374
//https://upgradedenterpriseapi.instancy.com/api/AsktheExpert/InsertRecommendedContentNotifications?astrRecommendedTo=491&aintRecommendedBy=466&astrContentIDlist=6dfaac2c-e7b3-46c0-87c4-107ff48bce12&aintNotificationID=42&aintNotificationStartDate=2023-07-04%203:23:16%20PM&astrSubject=Recommended%20content&astrMessage=Recommended%20content&OrgUnitID=374
    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
        restCallType: RestCallType.simpleGetCall,
        parsingType: ModelDataParsingType.string,
        url: apiEndpoints.getInsertRecommendedContentNotificationUrl(),
        queryParameters: {
          "astrRecommendedTo": recommendedTo,
          "aintRecommendedBy": "${apiUrlConfigurationProvider.getCurrentUserId()}",
          "astrContentIDlist": contentId,
          "aintNotificationID": "${NotificationTypes.RecommendedContentNotification}",
          "aintNotificationStartDate": DateFormat("yyyy-mm-dd h:MM:ss a").format(DateTime.now()),
          "astrSubject": "Recommended content",
          "astrMessage": "Recommended content",
          "OrgUnitID": "${apiUrlConfigurationProvider.getCurrentSiteId()}"
        });

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> sendRecommendedUserMail({required String contentId, String selectedUser = "", int componentId = 0, String contentName = ""}) async {
    MyPrint.printOnConsole('ShareRepository().insertRecommendedContent() called with insertRecommendedContent:');

    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");
    String selectedUsers = selectedUser;
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
    String siteUrl = apiUrlConfigurationProvider.getCurrentSiteUrl();

    String requestBody = MyUtils.encodeJson({
      "intSiteID": "${apiUrlConfigurationProvider.getCurrentSiteId()}",
      "UserId": "${apiUrlConfigurationProvider.getCurrentUserId()}",
      "SelectedUsers": selectedUsers,
      "strRecommendedContentName": "<a target='_blank' style='word-break: break-all;' href='${siteUrl}InviteURLID/contentId/$contentId/ComponentId/$componentId'>$contentName</a><br /><br />",
      "ContentID": contentId
    });
    requestBody = requestBody.replaceAll("\\x27", "'");

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.getSendRecommendedUserMail(),
      requestBody: requestBody,
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }
}
