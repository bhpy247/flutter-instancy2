import 'package:flutter_instancy_2/models/ask_the_expert/data_model/ask_the_expert_dto.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/request_model/add_answer_request_model.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/request_model/add_comment_request_model.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/request_model/add_question_request_model.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/request_model/get_question_list_forum_model.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/response_model/QuestionListDtoResponseModel.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/response_model/filter_user_skills_dto.dart';

import '../../api/api_call_model.dart';
import '../../api/api_controller.dart';
import '../../api/api_endpoints.dart';
import '../../api/api_url_configuration_provider.dart';
import '../../api/rest_client.dart';
import '../../models/ask_the_expert/data_model/answer_comment_dto.dart';
import '../../models/ask_the_expert/request_model/send_mail_to_expert_request_model.dart';
import '../../models/ask_the_expert/response_model/add_question_response_model.dart';
import '../../models/common/Instancy_multipart_file_upload_model.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/model_data_parser.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';

class AskTheExpertRepository {
  final ApiController apiController;

  const AskTheExpertRepository({required this.apiController});

  Future<DataResponseModel<QuestionListDtoResponseModel>> getQuestionList({
    required GetQuestionListRequestModel requestModel,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.intUserID = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.intSiteID = apiUrlConfigurationProvider.getCurrentSiteId();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, String>>(
      restCallType: RestCallType.simpleGetCall,
      queryParameters: requestModel.toJson(),
      parsingType: ModelDataParsingType.QuestionListDtoModel,
      url: apiEndpoints.GetQuestionList(),
    );

    DataResponseModel<QuestionListDtoResponseModel> apiResponseModel = await apiController.callApi<QuestionListDtoResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<AskTheExpertDto>> getQuestionAndAnswerOfUser({required int intQuestionId, required int componentId, required int componentInsId}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
    String userID = "", siteID = "";
    userID = apiUrlConfigurationProvider.getCurrentUserId().toString();
    siteID = apiUrlConfigurationProvider.getCurrentSiteId().toString();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, String>>(
      restCallType: RestCallType.simpleGetCall,
      // requestBody: requestModel.toJson(),
      queryParameters: {"UserID": userID, "intSiteID": siteID, "ComponentInsID": "$componentInsId", "ComponentID": "$componentId", "intQuestionID": "$intQuestionId"},
      parsingType: ModelDataParsingType.AskTheExpertDtoModel,
      url: apiEndpoints.GetUserQuestionAnswerResponse(),
    );

    DataResponseModel<AskTheExpertDto> apiResponseModel = await apiController.callApi<AskTheExpertDto>(
      apiCallModel: apiCallModel,
    );
    MyPrint.printOnConsole("apiResponseModel : $apiResponseModel");

    return apiResponseModel;
  }

  Future<DataResponseModel<AnswerCommentDTOModel>> getAnswersComments({
    required int intQuestionId,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
    String userID = "", siteID = "";
    userID = apiUrlConfigurationProvider.getCurrentUserId().toString();
    siteID = apiUrlConfigurationProvider.getCurrentSiteId().toString();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, String>>(
      restCallType: RestCallType.simpleGetCall,
      // requestBody: requestModel.toJson(),
      queryParameters: {"UserID": userID, "intSiteID": siteID, "intQuestionID": "$intQuestionId"},
      parsingType: ModelDataParsingType.AnswerCommentDtoModel,
      url: apiEndpoints.GetAnswerCommentResponse(),
    );

    DataResponseModel<AnswerCommentDTOModel> apiResponseModel = await apiController.callApi<AnswerCommentDTOModel>(
      apiCallModel: apiCallModel,
    );
    MyPrint.printOnConsole("apiResponseModel : $apiResponseModel");

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> updateVote({bool? isLikedOrDisliked, required int responseId, int typeId = 3, bool isFromAnswerComment = false}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
    String userID = "", siteID = "";
    userID = apiUrlConfigurationProvider.getCurrentUserId().toString();
    siteID = apiUrlConfigurationProvider.getCurrentSiteId().toString();
    Map<String, String> requestBody = {
      "intUserID": userID,
      "intSiteID": siteID,
      "intTypeID": "$typeId",
      "blnIsLiked": "$isLikedOrDisliked",
      "strObjectID": "$responseId",
    };
    if (isFromAnswerComment) {
      requestBody = {
        "intUserID": userID,
        "intTypeID": "$typeId",
        "blnIsLiked": "$isLikedOrDisliked",
        "strObjectID": "$responseId",
      };
    }

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      // requestBody: requestModel.toJson(),
      requestBody: MyUtils.encodeJson(requestBody),
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.GetLikeDislikeAnswer(),
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );
    MyPrint.printOnConsole("apiResponseModel : $apiResponseModel");

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> DeleteResponseUpAndDownVoters({required int responseId}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
    String userID = "";
    userID = apiUrlConfigurationProvider.getCurrentUserId().toString();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      // requestBody: requestModel.toJson(),
      queryParameters: {
        "intUserID": userID,
        "strObjectID": "$responseId",
      },
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.DeleteResponseUpAndDownVoters(),
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );
    MyPrint.printOnConsole("apiResponseModel : $apiResponseModel");

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> deleteAnswer({required int responseId}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      url: apiEndpoints.apiDeleteAnswer(),
      queryParameters: {"ResponseID": "$responseId", "UserResponseImage": ""},
      parsingType: ModelDataParsingType.string,
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> deleteComment({required int commentId}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      url: apiEndpoints.apiDeleteAnswerComment(),
      queryParameters: {"commentId": "$commentId", "Commentedimage": ""},
      parsingType: ModelDataParsingType.string,
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> deleteQuestion({required int QuestionID}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      url: apiEndpoints.apiDeleteQuestion(),
      queryParameters: {"QuestionID": "$QuestionID", "UserUploadimage": ""},
      parsingType: ModelDataParsingType.string,
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<AskTheExpertDto>> addAnswer({
    bool isEdit = false,
    required AddAnswerRequestModel requestModel,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.userID = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.siteID = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.Locale = apiUrlConfigurationProvider.getLocale();

    List<InstancyMultipartFileUploadModel> files = [];

    if (requestModel.fileUploads != null) {
      files.addAll(requestModel.fileUploads!);
    }

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.multipartRequestCall,
      // requestBody: MyUtils.encodeJson(requestModel.toJson()),
      parsingType: ModelDataParsingType.AskTheExpertDtoModel,
      url: apiEndpoints.apiAddEditAnswer(),
      fields: requestModel.toJson(),
      files: files,
    );

    DataResponseModel<AskTheExpertDto> apiResponseModel = await apiController.callApi<AskTheExpertDto>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<AddQuestionResponseModel>> addQuestion({
    bool isEdit = false,
    required AddQuestionRequestModel requestModel,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.userID = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.siteID = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.Locale = apiUrlConfigurationProvider.getLocale();

    List<InstancyMultipartFileUploadModel> files = [];

    if (requestModel.fileUploads != null) {
      files.addAll(requestModel.fileUploads!);
    }

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.multipartRequestCall,
      // requestBody: MyUtils.encodeJson(requestModel.toJson()),
      parsingType: ModelDataParsingType.AddQuestionResponseModel,
      url: apiEndpoints.apiAddEditQuestion(),
      fields: requestModel.toJson(),
      files: files,
    );

    DataResponseModel<AddQuestionResponseModel> apiResponseModel = await apiController.callApi<AddQuestionResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<FilterUserSkillsDtoResponseModel>> getFilterSkills(
      {required int componentId, required int componentInstanceId, bool isFromOffline = false, bool isStoreDataInHive = false}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole(" getWikiCategories Site Url:${apiEndpoints.siteUrl}  ");
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
    // {"intUserID":"363","intSiteID":"374","intComponentID":1,"Locale":"en-us","strType":"cat"}
    apiUrlConfigurationProvider.getCurrentUserId();
    int siteID = apiUrlConfigurationProvider.getCurrentSiteId();
    apiUrlConfigurationProvider.getLocale();
    Map<String, String> request = {
      "intSiteID": siteID.toString(),
    };
    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      queryParameters: request,
      parsingType: ModelDataParsingType.FilterUserSkillsDtoResponseModel,
      url: apiEndpoints.GetFilterSkills(),
    );

    DataResponseModel<FilterUserSkillsDtoResponseModel> apiResponseModel = await apiController.callApi<FilterUserSkillsDtoResponseModel>(
      apiCallModel: apiCallModel,
    );
    return apiResponseModel;
  }

  Future<DataResponseModel<FilterUserSkillsDtoResponseModel>> getUserSkills(
      {required int componentId, required int componentInstanceId, bool isFromOffline = false, bool isStoreDataInHive = false}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole(" getUserSkills: ${apiEndpoints.siteUrl}  ");
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
    // {"intUserID":"363","intSiteID":"374","intComponentID":1,"Locale":"en-us","strType":"cat"}
    apiUrlConfigurationProvider.getCurrentUserId();
    int siteID = apiUrlConfigurationProvider.getCurrentSiteId();
    apiUrlConfigurationProvider.getLocale();
    Map<String, String> request = {
      "aintSiteID": siteID.toString(),
      "astrType": "all",
    };
    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      queryParameters: request,
      parsingType: ModelDataParsingType.FilterUserSkillsDtoResponseModel,
      url: apiEndpoints.GetUserSkills(),
    );

    DataResponseModel<FilterUserSkillsDtoResponseModel> apiResponseModel = await apiController.callApi<FilterUserSkillsDtoResponseModel>(
      apiCallModel: apiCallModel,
    );
    return apiResponseModel;
  }

  Future<DataResponseModel<String>> sendMailToExperts({required SendMailToExpertRequestModel requestModel}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole(" getWikiCategories Site Url:${apiEndpoints.siteUrl}  ");
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
    // {"intUserID":"363","intSiteID":"374","intComponentID":1,"Locale":"en-us","strType":"cat"}
    requestModel.intUserID = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.intSiteID = apiUrlConfigurationProvider.getCurrentSiteId();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      queryParameters: requestModel.toJson(),
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.SendMailToExpert(),
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> setTheUserQuestionView({required int questionId}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole(" getWikiCategories Site Url:${apiEndpoints.siteUrl}  ");
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
    // {"intUserID":"363","intSiteID":"374","intComponentID":1,"Locale":"en-us","strType":"cat"}
    int intUserID = apiUrlConfigurationProvider.getCurrentUserId();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      queryParameters: {"UserID": "$intUserID", "intQuestionID": "$questionId"},
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.SetUserQuestionviews(),
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> addComment({
    bool isEdit = false,
    required AddCommentRequestModel requestModel,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.userID = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.siteID = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.Locale = apiUrlConfigurationProvider.getLocale();

    List<InstancyMultipartFileUploadModel> files = [];

    if (requestModel.fileUploads != null) {
      files.addAll(requestModel.fileUploads!);
    }

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.multipartRequestCall,
      // requestBody: MyUtils.encodeJson(requestModel.toJson()),
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.postComment(),
      fields: requestModel.toJson(),
      files: files,
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }
}
