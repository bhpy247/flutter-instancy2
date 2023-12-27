import 'package:flutter_instancy_2/models/discussion/data_model/forum_model.dart';
import 'package:flutter_instancy_2/models/discussion/data_model/topic_comment_model.dart';
import 'package:flutter_instancy_2/models/discussion/request_model/delete_discussion_topic_request_model.dart';
import 'package:flutter_instancy_2/models/discussion/request_model/get_add_topic_request_model.dart';
import 'package:flutter_instancy_2/models/discussion/request_model/get_delete_comment_request_model.dart';
import 'package:flutter_instancy_2/models/discussion/request_model/get_discussion_forum_list_request_model.dart';
import 'package:flutter_instancy_2/models/discussion/request_model/like_dislike_topic_and_comment_request_model.dart';
import 'package:flutter_instancy_2/models/discussion/request_model/post_comment_request_model.dart';
import 'package:flutter_instancy_2/models/discussion/request_model/update_pin_topic_request_model.dart';
import 'package:flutter_instancy_2/models/discussion/response_model/forum_listing_dto_response_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';

import '../../api/api_call_model.dart';
import '../../api/api_controller.dart';
import '../../api/api_endpoints.dart';
import '../../api/api_url_configuration_provider.dart';
import '../../api/rest_client.dart';
import '../../models/common/Instancy_multipart_file_upload_model.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/model_data_parser.dart';
import '../../models/discussion/data_model/category_model.dart';
import '../../models/discussion/data_model/forum_info_user_model.dart';
import '../../models/discussion/request_model/delete_forum_request_model.dart';
import '../../models/discussion/request_model/get_create_discussion_forum_request_model.dart';
import '../../models/discussion/request_model/like_dislike_reply_request_model.dart';
import '../../models/discussion/request_model/post_reply_request_model.dart';
import '../../models/discussion/response_model/discussion_topic_dto_response_model.dart';
import '../../models/discussion/response_model/replies_dto_model.dart';
import '../../utils/my_print.dart';

class DiscussionRepository {
  final ApiController apiController;

  const DiscussionRepository({required this.apiController});

  Future<DataResponseModel<ForumListingDTOResponseModel>> getForumsList({
    required GetDiscussionForumListRequestModel requestModel,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.intUserID = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.intSiteID = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.strLocale = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, String>>(
      restCallType: RestCallType.xxxUrlEncodedFormDataRequestCall,
      requestBody: requestModel.toJson(),
      parsingType: ModelDataParsingType.forumListingDTOResponseModel,
      url: apiEndpoints.getDiscussionForumList(),
    );

    DataResponseModel<ForumListingDTOResponseModel> apiResponseModel = await apiController.callApi<ForumListingDTOResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> addTopic({
    bool isEdit = false,
    required AddTopicRequestModel requestModel,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.userID = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.siteID = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.localeID = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      requestBody: MyUtils.encodeJson(requestModel.toJson()),
      parsingType: ModelDataParsingType.string,
      url: isEdit ? apiEndpoints.apiEditTopic() : apiEndpoints.apiAddTopic(),
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> createDiscussionForum({
    bool isEdit = false,
    required CreateDiscussionForumRequestModel requestModel,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.SiteID = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.UpdatedUserID = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.CreatedUserID = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.locale = apiUrlConfigurationProvider.getLocale();
    requestModel.ModeratorID = requestModel.ModeratorID;

    List<InstancyMultipartFileUploadModel> files = [];

    if (requestModel.fileUploads != null) {
      files.addAll(requestModel.fileUploads!);
    }

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData(
      restCallType: RestCallType.multipartRequestCall,
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.getCreateDiscussionForum(),
      fields: requestModel.toJson(),
      files: files,
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<List<ForumUserInfoModel>>> getUserListBaseOnRoles() async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    int userID = apiUrlConfigurationProvider.getCurrentUserId();
    int siteID = apiUrlConfigurationProvider.getCurrentSiteId();
    String localeID = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      queryParameters: {
        "intUserID": userID.toString(),
        "intSiteID": siteID.toString(),
        "strLocale": localeID,
      },
      // requestBody: MyUtils.encodeJson(requestModel.toJson()),
      parsingType: ModelDataParsingType.ForumUserInfoList,
      url: apiEndpoints.apiGetModerator(),
    );

    DataResponseModel<List<ForumUserInfoModel>> apiResponseModel = await apiController.callApi<List<ForumUserInfoModel>>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> uploadForumAttachment({required UploadForumAttachmentModel uploadForumAttachmentModel}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    uploadForumAttachmentModel.userID = apiUrlConfigurationProvider.getCurrentUserId();
    uploadForumAttachmentModel.siteID = apiUrlConfigurationProvider.getCurrentSiteId();
    uploadForumAttachmentModel.strLocale = apiUrlConfigurationProvider.getLocale();

    List<InstancyMultipartFileUploadModel> files = [];

    if (uploadForumAttachmentModel.fileUploads != null || uploadForumAttachmentModel.fileUploads.checkNotEmpty) {
      files.addAll(uploadForumAttachmentModel.fileUploads!);
    }

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData(
      restCallType: RestCallType.multipartRequestCall,
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.getUploadForumAttachment(),
      fields: uploadForumAttachmentModel.toJson(),
      files: files,
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<DiscussionTopicDTOResponseModel>> getForumTopic({
    required int forumId,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
    String userID = "", siteID = "", localeID = "";
    userID = apiUrlConfigurationProvider.getCurrentUserId().toString();
    siteID = apiUrlConfigurationProvider.getCurrentSiteId().toString();
    localeID = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, String>>(
      restCallType: RestCallType.simpleGetCall,
      // requestBody: requestModel.toJson(),
      queryParameters: {"intUserID": userID, "intSiteID": siteID, "strLocale": localeID, "ForumID": forumId.toString()},
      parsingType: ModelDataParsingType.discussionTopicResponseModel,
      url: apiEndpoints.getForumTopic(),
    );

    DataResponseModel<DiscussionTopicDTOResponseModel> apiResponseModel = await apiController.callApi<DiscussionTopicDTOResponseModel>(
      apiCallModel: apiCallModel,
    );
    MyPrint.printOnConsole("apiResponseModel : $apiResponseModel");

    return apiResponseModel;
  }

  Future<DataResponseModel<ForumModel>> getSingleForumDetails({
    required int forumId,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
    String userID = "", siteID = "", localeID = "";
    userID = apiUrlConfigurationProvider.getCurrentUserId().toString();
    siteID = apiUrlConfigurationProvider.getCurrentSiteId().toString();
    localeID = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, String>>(
      restCallType: RestCallType.simpleGetCall,
      // requestBody: requestModel.toJson(),
      queryParameters: {"intUserID": userID, "intSiteID": siteID, "strLocale": localeID, "ForumID": forumId.toString()},
      parsingType: ModelDataParsingType.forumResponseModel,
      url: apiEndpoints.getSingleForumDetails(),
    );

    DataResponseModel<ForumModel> apiResponseModel = await apiController.callApi<ForumModel>(
      apiCallModel: apiCallModel,
    );
    MyPrint.printOnConsole("apiResponseModel : $apiResponseModel");

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> PostComment({
    required PostCommentRequestModel requestModel,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.userID = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.siteID = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.localeID = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      requestBody: MyUtils.encodeJson(requestModel.toJson()),
      parsingType: ModelDataParsingType.string,
      url: apiEndpoints.getPostCommentApi(),
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<RepliesDTOModel>> PostReply({
    required PostReplyRequestModel requestModel,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.userID = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.siteID = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.localeID = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      url: apiEndpoints.getPostReply(),
      requestBody: MyUtils.encodeJson(requestModel.toJson()),
      parsingType: ModelDataParsingType.RepliesDTOModel,
    );

    DataResponseModel<RepliesDTOModel> apiResponseModel = await apiController.callApi<RepliesDTOModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> DeleteForum({
    required DeleteForumRequestModel requestModel,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.LocaleID = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      url: apiEndpoints.DeleteForum(),
      queryParameters: requestModel.toJson(),
      parsingType: ModelDataParsingType.string,
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> DeleteForumTopic({
    required DeleteDiscussionTopicRequestModel requestModel,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.LocaleID = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      url: apiEndpoints.DeleteForumTopic(),
      requestBody: MyUtils.encodeJson(requestModel.toJson()),
      parsingType: ModelDataParsingType.string,
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> deleteComment({
    required DeleteCommentRequestModel requestModel,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.userID = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.siteID = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.localeID = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      url: apiEndpoints.apiDeleteComment(),
      requestBody: MyUtils.encodeJson(requestModel.toJson()),
      parsingType: ModelDataParsingType.string,
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> DeleteForumReply({
    required int replyId,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      url: apiEndpoints.DeleteForumReply(),
      requestBody: MyUtils.encodeJson({"ReplyID": replyId}),
      parsingType: ModelDataParsingType.string,
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> UpdatePinTopic({
    required UpdatePinTopicRequestModel requestModel,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.userID = apiUrlConfigurationProvider.getCurrentUserId();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      url: apiEndpoints.UpdatePinTopic(),
      requestBody: MyUtils.encodeJson(requestModel.toJson()),
      parsingType: ModelDataParsingType.string,
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<List<ForumUserInfoModel>>> likeDislikeTopicAndComment({required LikeDislikeTopicAndCommentRequestModel requestModel}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.intUserID = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.intSiteID = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.strLocale = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      url: apiEndpoints.InsertAndGetContentLikes(),
      requestBody: MyUtils.encodeJson(requestModel.toJson()),
      parsingType: ModelDataParsingType.ForumUserInfoList,
    );

    DataResponseModel<List<ForumUserInfoModel>> apiResponseModel = await apiController.callApi<List<ForumUserInfoModel>>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<String>> likeDislikeReply({required LikeDislikeReplyRequestModel requestModel}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.intUserID = apiUrlConfigurationProvider.getCurrentUserId();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      url: apiEndpoints.InsertContentLikes(),
      requestBody: MyUtils.encodeJson(requestModel.toJson()),
      parsingType: ModelDataParsingType.string,
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<RepliesDTOModel>> getCommentReplies({required int commentId}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    int userID = apiUrlConfigurationProvider.getCurrentUserId();
    int siteID = apiUrlConfigurationProvider.getCurrentSiteId();
    String localeID = apiUrlConfigurationProvider.getLocale();
    Map<String, String> requestBody = {
      "strCommentID": commentId.toString(),
      "UserID": userID.toString(),
      "SiteID": siteID.toString(),
      "LocaleID": localeID,
    };
    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      requestBody: MyUtils.encodeJson(requestBody),
      parsingType: ModelDataParsingType.RepliesDTOModel,
      url: apiEndpoints.GetReplies(),
    );

    DataResponseModel<RepliesDTOModel> apiResponseModel = await apiController.callApi<RepliesDTOModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<List<TopicCommentModel>>> getTopicComments({required String topicId, required int forumId}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    int userID = apiUrlConfigurationProvider.getCurrentUserId();
    int siteID = apiUrlConfigurationProvider.getCurrentSiteId();
    String localeID = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      queryParameters: {
        "intUserID": userID.toString(),
        "intSiteID": siteID.toString(),
        "strLocale": localeID,
        "ForumID": forumId.toString(),
        "TopicID": topicId.toString(),
      },
      parsingType: ModelDataParsingType.topicCommentResponseModel,
      url: apiEndpoints.apiGetCommentList(),
    );

    DataResponseModel<List<TopicCommentModel>> apiResponseModel = await apiController.callApi<List<TopicCommentModel>>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<List<ForumUserInfoModel>>> getForumLevelLikedUserList({required int forumId}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    int userID = apiUrlConfigurationProvider.getCurrentUserId();
    int siteID = apiUrlConfigurationProvider.getCurrentSiteId();
    String localeID = apiUrlConfigurationProvider.getLocale();
    Map<String, String> request = {
      "strObjectID": forumId.toString(),
      "intUserID": userID.toString(),
      "intSiteID": siteID.toString(),
      "strLocale": localeID,
    };

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      queryParameters: request,
      parsingType: ModelDataParsingType.ForumUserInfoList,
      url: apiEndpoints.apiGetForumLevelLikeList(),
    );

    DataResponseModel<List<ForumUserInfoModel>> apiResponseModel = await apiController.callApi<List<ForumUserInfoModel>>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<List<ForumUserInfoModel>>> getTopicCommentLevelLikedUserList({required String topicId, required int intTypeID}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    int userID = apiUrlConfigurationProvider.getCurrentUserId();
    int siteID = apiUrlConfigurationProvider.getCurrentSiteId();
    String localeID = apiUrlConfigurationProvider.getLocale();
    Map<String, String> request = {
      "strObjectID": topicId.toString(),
      "intUserID": userID.toString(),
      "intSiteID": siteID.toString(),
      "strLocale": localeID,
      "intTypeID": intTypeID.toString(),
    };

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      queryParameters: request,
      parsingType: ModelDataParsingType.ForumUserInfoList,
      url: apiEndpoints.apiGetTopicCommentLevelLikeList(),
    );

    DataResponseModel<List<ForumUserInfoModel>> apiResponseModel = await apiController.callApi<List<ForumUserInfoModel>>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<CategoriesDtoModel>> getCategories({required int componentId, required int componentInstanceId, bool isFromOffline = false, bool isStoreDataInHive = false}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole(" getWikiCategories Site Url:${apiEndpoints.siteUrl}  ");
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
    // {"intUserID":"363","intSiteID":"374","intComponentID":1,"Locale":"en-us","strType":"cat"}
    int userID = apiUrlConfigurationProvider.getCurrentUserId();
    int siteID = apiUrlConfigurationProvider.getCurrentSiteId();
    String localeID = apiUrlConfigurationProvider.getLocale();
    Map<String, String> request = {
      "intUserID": userID.toString(),
      "intSiteID": siteID.toString(),
      "strLocale": localeID,
      "intCompID": componentId.toString(),
      "intCompInsID": componentInstanceId.toString(),
    };
    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simplePostCall,
      requestBody: MyUtils.encodeJson(request),
      parsingType: ModelDataParsingType.categoriesDtoModel,
      url: apiEndpoints.getCategoriesDiscussionForum(),
      isGetDataFromHive: isFromOffline,
      isStoreDataInHive: isStoreDataInHive,
    );

    DataResponseModel<CategoriesDtoModel> apiResponseModel = await apiController.callApi<CategoriesDtoModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }
}
