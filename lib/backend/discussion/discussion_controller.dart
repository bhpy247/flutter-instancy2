import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/discussion/discussion_provider.dart';
import 'package:flutter_instancy_2/backend/discussion/discussion_repository.dart';
import 'package:flutter_instancy_2/backend/gamification/gamification_controller.dart';
import 'package:flutter_instancy_2/backend/gamification/gamification_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation_controller.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/discussion/data_model/comment_reply_model.dart';
import 'package:flutter_instancy_2/models/discussion/data_model/forum_info_user_model.dart';
import 'package:flutter_instancy_2/models/discussion/data_model/forum_model.dart';
import 'package:flutter_instancy_2/models/discussion/data_model/like_user_id_model.dart';
import 'package:flutter_instancy_2/models/discussion/data_model/topic_comment_model.dart';
import 'package:flutter_instancy_2/models/discussion/data_model/topic_model.dart';
import 'package:flutter_instancy_2/models/discussion/request_model/delete_forum_request_model.dart';
import 'package:flutter_instancy_2/models/discussion/request_model/get_create_discussion_forum_request_model.dart';
import 'package:flutter_instancy_2/models/discussion/request_model/get_delete_comment_request_model.dart';
import 'package:flutter_instancy_2/models/discussion/request_model/get_discussion_forum_list_request_model.dart';
import 'package:flutter_instancy_2/models/discussion/request_model/like_dislike_reply_request_model.dart';
import 'package:flutter_instancy_2/models/discussion/request_model/post_reply_request_model.dart';
import 'package:flutter_instancy_2/models/discussion/request_model/update_pin_topic_request_model.dart';
import 'package:flutter_instancy_2/models/discussion/response_model/forum_listing_dto_response_model.dart';
import 'package:flutter_instancy_2/models/gamification/request_model/update_content_gamification_request_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:provider/provider.dart';

import '../../api/api_controller.dart';
import '../../configs/app_configurations.dart';
import '../../models/app_configuration_models/data_models/component_configurations_model.dart';
import '../../models/app_configuration_models/data_models/local_str.dart';
import '../../models/common/Instancy_multipart_file_upload_model.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/pagination/pagination_model.dart';
import '../../models/discussion/request_model/delete_discussion_topic_request_model.dart';
import '../../models/discussion/request_model/get_add_topic_request_model.dart';
import '../../models/discussion/request_model/like_dislike_topic_and_comment_request_model.dart';
import '../../models/discussion/request_model/post_comment_request_model.dart';
import '../../models/discussion/response_model/replies_dto_model.dart';
import '../../models/filter/data_model/enabled_content_filter_by_type_model.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';
import '../../views/common/components/common_cached_network_image.dart';
import '../../views/common/components/common_confirmation_dialog.dart';
import '../../views/common/components/instancy_ui_actions/bottomsheet_drager.dart';
import '../app/app_provider.dart';
import '../configurations/app_configuration_operations.dart';
import '../filter/filter_provider.dart';

class DiscussionController {
  late DiscussionProvider _discussionProvider;
  late DiscussionRepository _discussionRepository;

  DiscussionController({required DiscussionProvider? discussionProvider, DiscussionRepository? repository, ApiController? apiController}) {
    _discussionProvider = discussionProvider ?? DiscussionProvider();
    _discussionRepository = repository ?? DiscussionRepository(apiController: apiController ?? ApiController());
  }

  DiscussionProvider get discussionProvider => _discussionProvider;

  DiscussionRepository get discussionRepository => _discussionRepository;

  //region Initializations
  void initializeConfigurationsFromComponentConfigurationsModel({required ComponentConfigurationsModel componentConfigurationsModel}) {
    discussionProvider.pageSize.set(value: componentConfigurationsModel.itemsPerPage, isNotify: false);
    initializeFilterData(model: componentConfigurationsModel);
  }

  void initializeFilterData({required ComponentConfigurationsModel model}) {
    DiscussionProvider provider = discussionProvider;

    provider.filterProvider
      ..defaultSort.set(value: model.ddlSortList, isNotify: false)
      ..selectedSort.set(value: model.ddlSortList, isNotify: false);
    provider.filterEnabled.set(value: AppConfigurations.getFilterEnabledFromShowIndexes(showIndexes: model.showIndexes), isNotify: false);
    provider.sortEnabled.set(value: AppConfigurations.getSortEnabledFromContentFilterBy(contentFilterBy: model.contentFilterBy), isNotify: false);
  }

  //endregion

  //region Get Forums List with Pagination
  Future<bool> getForumsList({
    bool isRefresh = true,
    bool isGetFromCache = false,
    bool isNotify = true,
    int componentId = -1,
    int componentInstanceId = -1,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
        "DiscussionController().getForumsList() called with isRefresh:$isRefresh, isGetFromCache:$isGetFromCache, "
        "isNotify:$isNotify, componentId:$componentId, componentInstanceId:$componentInstanceId",
        tag: tag);

    DiscussionProvider provider = discussionProvider;
    DiscussionRepository repository = discussionRepository;
    PaginationModel paginationModel = provider.forumListPaginationModel.get();

    //region If Not refresh and Data available, return Cached Data
    if (!isRefresh && isGetFromCache && provider.forumsList.length > 0) {
      MyPrint.printOnConsole("Returning Cached Data", tag: tag);
      return true;
    }
    //endregion

    //region If refresh, then reset provider data
    if (isRefresh) {
      MyPrint.printOnConsole("Refresh", tag: tag);
      PaginationModel.updatePaginationData(
        paginationModel: paginationModel,
        hasMore: true,
        pageIndex: 1,
        isFirstTimeLoading: true,
        isLoading: false,
        notifier: provider.notify,
        notify: false,
      );
      provider.forumsList.setList(list: <ForumModel>[], isClear: true, isNotify: isNotify);
    }
    //endregion

    //region If Not Has More Data, then return
    if (!paginationModel.hasMore) {
      MyPrint.printOnConsole('No More Forum Contents', tag: tag);
      return false;
    }
    //endregion

    //region If Data already Loading, then return
    if (paginationModel.isLoading) return false;
    //endregion

    //region Set Loading True
    PaginationModel.updatePaginationData(
      paginationModel: paginationModel,
      isLoading: true,
      notifier: provider.notify,
      notify: isNotify,
    );
    //endregion

    DateTime startTime = DateTime.now();

    //region Get Request Model From Provider Data
    GetDiscussionForumListRequestModel requestModel = getForumListRequestModelFromProviderData(
      provider: provider,
      paginationModel: paginationModel,
      componentId: componentId,
      componentInstanceId: componentInstanceId,
    );
    //endregion

    //region Make Api Call
    DataResponseModel<ForumListingDTOResponseModel> response = await repository.getForumsList(
      requestModel: requestModel,
    );
    MyPrint.printOnConsole("Forum Response:$response", tag: tag);
    //endregion

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole("Forum Data got in ${endTime.difference(startTime).inMilliseconds} Milliseconds", tag: tag);

    List<ForumModel> forumsList = response.data?.forumList ?? <ForumModel>[];
    MyPrint.printOnConsole("Forum List Length got in Api:${forumsList.length}", tag: tag);

    List<ForumModel> newForumsList = <ForumModel>[];
    Map<int, ForumModel> newForumsMap = provider.forumsMap.getMap(isNewInstance: false);

    Map<int, ForumModel> forumsMap = provider.forumsMap.getMap(isNewInstance: true);
    for (ForumModel forumModel in forumsList) {
      ForumModel? existingModel = forumsMap[forumModel.ForumID];
      if (existingModel == null) {
        existingModel = forumModel;
        newForumsMap[forumModel.ForumID] = forumModel;
      } else {
        existingModel.updateFromJson(forumModel.toJson());
      }

      existingModel.calculateLikeUserCount();
      existingModel.calculatePinnedTopics();
      newForumsList.add(existingModel);
    }

    //region Set Provider Data After Getting Data From Api
    provider.maxForumListCount.set(value: response.data?.TotalRecordCount ?? 0, isNotify: false);
    provider.forumsList.setList(list: newForumsList, isClear: false, isNotify: false);
    provider.forumsMap.setMap(map: newForumsMap, isClear: false, isNotify: false);
    PaginationModel.updatePaginationData(
      paginationModel: paginationModel,
      isFirstTimeLoading: false,
      pageIndex: paginationModel.pageIndex + 1,
      hasMore: provider.forumsList.length < provider.maxForumListCount.get(),
      isLoading: false,
      notifier: provider.notify,
      notify: true,
    );
    //endregion

    return true;
  }

  GetDiscussionForumListRequestModel getForumListRequestModelFromProviderData({
    required DiscussionProvider provider,
    required PaginationModel paginationModel,
    required int componentId,
    required int componentInstanceId,
  }) {
    FilterProvider filterProvider = provider.filterProvider;
    EnabledContentFilterByTypeModel? enabledContentFilterByTypeModel = filterProvider.getEnabledContentFilterByTypeModel(isNewInstance: false);

    return GetDiscussionForumListRequestModel(
      intCompID: componentId,
      intCompInsID: componentInstanceId,
      strSearchText: provider.forumListSearchString.get(),
      forumcontentId: provider.forumContentId.get(),
      // userID: "363",
      pageIndex: paginationModel.pageIndex,
      pageSize: provider.pageSize.get(),
      CategoryIds: enabledContentFilterByTypeModel.categories
          ? AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
              list: filterProvider.selectedCategories.getList().map((e) => e.categoryId).toList(),
            )
          : "",
    );
  }

  //endregion

  //region Get My Discussion Forums List with Pagination
  Future<bool> getMyDiscussionForumsList({
    bool isRefresh = true,
    bool isGetFromCache = false,
    bool isNotify = true,
    int componentId = -1,
    int componentInstanceId = -1,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
      "DiscussionController().getMyDiscussionForumsList() called with isRefresh:$isRefresh, isGetFromCache:$isGetFromCache, "
      "isNotify:$isNotify, componentId:$componentId, componentInstanceId:$componentInstanceId",
      tag: tag,
    );

    DiscussionProvider provider = discussionProvider;
    DiscussionRepository repository = discussionRepository;
    PaginationModel paginationModel = provider.myDiscussionForumListPaginationModel.get();

    //region If Not refresh and Data available, return Cached Data
    if (!isRefresh && isGetFromCache && provider.myDiscussionForumsList.length > 0) {
      MyPrint.printOnConsole("Returning Cached Data", tag: tag);
      return true;
    }
    //endregion

    //region If refresh, then reset provider data
    if (isRefresh) {
      MyPrint.printOnConsole("Refresh", tag: tag);
      PaginationModel.updatePaginationData(
        paginationModel: paginationModel,
        hasMore: true,
        pageIndex: 1,
        isFirstTimeLoading: true,
        isLoading: false,
        notifier: provider.notify,
        notify: false,
      );
      provider.myDiscussionForumsList.setList(list: <ForumModel>[], isClear: true, isNotify: isNotify);
    }
    //endregion

    //region If Not Has More Data, then return
    if (!paginationModel.hasMore) {
      MyPrint.printOnConsole('No More Forum Contents', tag: tag);
      return false;
    }
    //endregion

    //region If Data already Loading, then return
    if (paginationModel.isLoading) return false;
    //endregion

    //region Set Loading True
    PaginationModel.updatePaginationData(
      paginationModel: paginationModel,
      isLoading: true,
      notifier: provider.notify,
      notify: isNotify,
    );
    //endregion

    DateTime startTime = DateTime.now();

    //region Get Request Model From Provider Data
    GetDiscussionForumListRequestModel requestModel = getMyDiscussionForumListRequestModelFromProviderData(
      provider: provider,
      paginationModel: paginationModel,
      componentId: componentId,
      componentInstanceId: componentInstanceId,
    );
    //endregion

    //region Make Api Call
    DataResponseModel<ForumListingDTOResponseModel> response = await repository.getForumsList(
      requestModel: requestModel,
    );
    MyPrint.printOnConsole("My Forum Response:$response", tag: tag);
    //endregion

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole("My Forum Data got in ${endTime.difference(startTime).inMilliseconds} Milliseconds", tag: tag);

    List<ForumModel> forumsList = response.data?.forumList ?? <ForumModel>[];
    MyPrint.printOnConsole("My Forum List Length got in Api:${forumsList.length}", tag: tag);

    List<ForumModel> newForumsList = <ForumModel>[];
    Map<int, ForumModel> newForumsMap = provider.forumsMap.getMap(isNewInstance: false);

    Map<int, ForumModel> forumsMap = provider.forumsMap.getMap(isNewInstance: true);
    for (ForumModel forumModel in forumsList) {
      ForumModel? existingModel = forumsMap[forumModel.ForumID];
      if (existingModel == null) {
        existingModel = forumModel;
        newForumsMap[forumModel.ForumID] = forumModel;
      } else {
        existingModel.updateFromJson(forumModel.toJson());
      }

      newForumsList.add(existingModel);
    }

    //region Set Provider Data After Getting Data From Api
    provider.maxMyDiscussionForumListCount.set(value: response.data?.TotalRecordCount ?? 0, isNotify: false);
    provider.myDiscussionForumsList.setList(list: forumsList, isClear: false, isNotify: false);
    PaginationModel.updatePaginationData(
      paginationModel: paginationModel,
      isFirstTimeLoading: false,
      pageIndex: paginationModel.pageIndex + 1,
      hasMore: provider.myDiscussionForumsList.length < provider.maxMyDiscussionForumListCount.get(),
      isLoading: false,
      notifier: provider.notify,
      notify: true,
    );
    //endregion

    return true;
  }

  GetDiscussionForumListRequestModel getMyDiscussionForumListRequestModelFromProviderData({
    required DiscussionProvider provider,
    required PaginationModel paginationModel,
    required int componentId,
    required int componentInstanceId,
  }) {
    FilterProvider filterProvider = provider.filterProvider;
    EnabledContentFilterByTypeModel? enabledContentFilterByTypeModel = filterProvider.getEnabledContentFilterByTypeModel(isNewInstance: false);

    return GetDiscussionForumListRequestModel(
      intCompID: componentId,
      IsMydiscussion: true,
      intCompInsID: componentInstanceId,
      strSearchText: provider.forumListSearchString.get(),
      forumcontentId: provider.forumContentId.get(),
      // userID: "363",
      pageIndex: paginationModel.pageIndex,
      pageSize: provider.pageSize.get(),
      CategoryIds: enabledContentFilterByTypeModel.categories
          ? AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
              list: filterProvider.selectedCategories.getList().map((e) => e.categoryId).toList(),
            )
          : "",
    );
  }

  //endregion

  Future<bool> addTopic({
    required int componentId,
    required int componentInstanceId,
    required AddTopicRequestModel requestModel,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("DiscussionController().addTopic() called '", tag: tag);

    DataResponseModel<String> dataResponseModel = await _discussionRepository.addTopic(requestModel: requestModel);

    MyPrint.printOnConsole("addTopicComment response:$dataResponseModel", tag: tag);

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from DiscussionController().addTopic() because addTopic had some error", tag: tag);
      return false;
    }

    String response = dataResponseModel.data ?? "";

    List<String> splitResponse = response.split("#\$#");
    if (splitResponse.checkEmpty) {
      return false;
    }

    bool isSuccess = ParsingHelper.parseBoolMethod(splitResponse.firstOrNull == "success");
    String topicId = splitResponse.elementAtOrNull(1).checkNotEmpty ? splitResponse[1] : "";
    MyPrint.printOnConsole("topicId: $topicId, isSuccess $isSuccess", tag: tag);

    if (!isSuccess) {
      return false;
    }

    if (requestModel.strAttachFileBytes != null) {
      UploadForumAttachmentModel uploadForumAttachmentModel = UploadForumAttachmentModel(
        topicId: topicId,
        isTopic: true,
        fileUploads: [
          InstancyMultipartFileUploadModel(
            fieldName: "Image",
            fileName: requestModel.strAttachFile,
            bytes: requestModel.strAttachFileBytes,
          )
        ],
      );
      bool isSuccessUpload = await uploadForumAttachment(requestModel: uploadForumAttachmentModel);
      MyPrint.printOnConsole("isSuccessUpload:$isSuccessUpload", tag: tag);
    }

    BuildContext? context = NavigationController.mainNavigatorKey.currentContext;
    if (context != null) {
      await GamificationController(provider: context.read<GamificationProvider>()).UpdateContentGamification(
        requestModel: UpdateContentGamificationRequestModel(
          contentId: "",
          scoId: 0,
          objecttypeId: 0,
          GameAction: GamificationActionType.AddedTopic,
        ),
      );
    }

    return true;
  }

  Future<bool> editTopic({
    required String contentId,
    required int componentId,
    required int componentInstanceId,
    required AddTopicRequestModel requestModel,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("DiscussionController().editTopic() called with contentId:'$contentId'", tag: tag);

    DataResponseModel<String> dataResponseModel = await _discussionRepository.addTopic(requestModel: requestModel, isEdit: true);

    MyPrint.printOnConsole("addTopicComment response:$dataResponseModel", tag: tag);

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from DiscussionController().editTopic() because editTopic had some error", tag: tag);
      return false;
    }

    bool isSuccess = dataResponseModel.data == "success";
    MyPrint.printOnConsole("isSuccess $isSuccess", tag: tag);

    if (!isSuccess) {
      return false;
    }

    if (requestModel.strAttachFileBytes != null) {
      UploadForumAttachmentModel uploadForumAttachmentModel = UploadForumAttachmentModel(
        topicId: contentId,
        isTopic: true,
        fileUploads: [
          InstancyMultipartFileUploadModel(
            fieldName: "Image",
            fileName: requestModel.strAttachFile,
            bytes: requestModel.strAttachFileBytes,
          )
        ],
      );
      bool isSuccessUpload = await uploadForumAttachment(requestModel: uploadForumAttachmentModel);
      MyPrint.printOnConsole("isSuccessUpload:$isSuccessUpload", tag: tag);
    }

    return true;
  }

  Future<bool> createDiscussionForum({
    required CreateDiscussionForumRequestModel requestModel,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("DiscussionController().createDiscussionForum() called '", tag: tag);

    DataResponseModel<String> dataResponseModel = await _discussionRepository.createDiscussionForum(requestModel: requestModel);

    MyPrint.printOnConsole("createDiscussionForum response:$dataResponseModel", tag: tag);

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from DiscussionController().createDiscussionForum() because createDiscussionForum had some error", tag: tag);
      return false;
    }

    return dataResponseModel.data == "1";
  }

  Future<bool> editDiscussionForum({
    required CreateDiscussionForumRequestModel requestModel,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("DiscussionController().createDiscussionForum() called '", tag: tag);

    DataResponseModel<String> dataResponseModel = await _discussionRepository.createDiscussionForum(requestModel: requestModel, isEdit: true);

    MyPrint.printOnConsole("createDiscussionForum response:$dataResponseModel", tag: tag);

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from DiscussionController().createDiscussionForum() because createDiscussionForum had some error", tag: tag);
      return false;
    }

    return dataResponseModel.data == "1";
  }

  Future<bool> uploadForumAttachment({
    required UploadForumAttachmentModel requestModel,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("DiscussionController().UploadForumAttachment() called with contentId:'$requestModel'", tag: tag);

    DataResponseModel<String> dataResponseModel = await _discussionRepository.uploadForumAttachment(uploadForumAttachmentModel: requestModel);

    MyPrint.printOnConsole("addTopicComment response:$dataResponseModel", tag: tag);

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from DiscussionController().UploadForumAttachment() because addTopic had some error", tag: tag);
      return false;
    }

    return dataResponseModel.data == "success";
  }

  Future<bool> getUserListBaseOnUserInfo() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("DiscussionController().getUserListBaseOnUserInfo() called '", tag: tag);

    DataResponseModel<List<ForumUserInfoModel>> dataResponseModel = await _discussionRepository.getUserListBaseOnRoles();

    MyPrint.printOnConsole("addTopicComment response:$dataResponseModel", tag: tag);

    if (dataResponseModel.data != null || dataResponseModel.data.checkNotEmpty) {
      discussionProvider.moderatorsList.setList(list: dataResponseModel.data ?? []);
    }

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from DiscussionController().getUserListBaseOnUserInfo() because addTopic had some error", tag: tag);
      return false;
    }

    return dataResponseModel.data.checkNotEmpty;
  }

  Future<bool> addComment({
    required TopicModel topicModel,
    required PostCommentRequestModel requestModel,
    void Function()? mySetState,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("DiscussionController().addComment() called with contentId:'${topicModel.ContentID}'", tag: tag);

    DataResponseModel<String> dataResponseModel = await _discussionRepository.PostComment(requestModel: requestModel);
    MyPrint.printOnConsole("addComment response:$dataResponseModel", tag: tag);

    List<String> responseData = (dataResponseModel.data ?? "").split("#\$#");
    MyPrint.printOnConsole("responseData:$responseData", tag: tag);

    bool isSuccess = dataResponseModel.appErrorModel == null && responseData.firstOrNull == "success" && responseData.elementAtOrNull(1).checkNotEmpty;
    MyPrint.printOnConsole("isSuccess:$isSuccess", tag: tag);

    if (!isSuccess) {
      MyPrint.printOnConsole("Returning from DiscussionController().addComment() because couldn't Create Comment", tag: tag);
      return false;
    }

    String replyId = responseData.elementAtOrNull(1).checkNotEmpty ? responseData[1] : "";
    MyPrint.printOnConsole("replyId:$replyId", tag: tag);

    if (requestModel.fileBytes.checkNotEmpty) {
      UploadForumAttachmentModel uploadForumAttachmentModel = UploadForumAttachmentModel(
        topicId: topicModel.ContentID,
        isTopic: false,
        ReplyID: replyId.trim(),
        fileUploads: [
          InstancyMultipartFileUploadModel(
            fieldName: "Image",
            fileName: requestModel.strAttachFile.isEmpty ? null : requestModel.strAttachFile,
            bytes: requestModel.fileBytes,
          )
        ],
      );
      bool isUploadSuccess = await uploadForumAttachment(requestModel: uploadForumAttachmentModel);
      MyPrint.printOnConsole("isUploadSuccess:$isUploadSuccess", tag: tag);
    }

    BuildContext? context = NavigationController.mainNavigatorKey.currentContext;
    if (context != null) {
      await GamificationController(provider: context.read<GamificationProvider>()).UpdateContentGamification(
        requestModel: UpdateContentGamificationRequestModel(
          contentId: "",
          scoId: 0,
          objecttypeId: 0,
          GameAction: GamificationActionType.AddedComment,
        ),
      );
    }

    return isSuccess;
  }

  Future<bool> addReplyOnComment({
    required PostReplyRequestModel requestModel,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("DiscussionController().addReplyOnComment() called '", tag: tag);

    DataResponseModel<RepliesDTOModel> dataResponseModel = await _discussionRepository.PostReply(requestModel: requestModel);
    MyPrint.printOnConsole("PostReply response:$dataResponseModel", tag: tag);

    bool isSuccess = dataResponseModel.appErrorModel == null && (dataResponseModel.data?.Table).checkNotEmpty;
    MyPrint.printOnConsole("isSuccess:$isSuccess", tag: tag);

    return isSuccess;
  }

  Future<bool> deleteForum({
    required BuildContext context,
    required ForumModel forumModel,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("DiscussionController().deleteForum() called with contentId:'${forumModel.ForumID}'", tag: tag);

    dynamic value = await showDialog(
      context: context,
      builder: (BuildContext context) {
        LocalStr localStrNew = context.read<AppProvider>().localStr;

        return CommonConfirmationDialog(
          title: localStrNew.discussionforumActionsheetDeletetopicoption,
          description: localStrNew.discussionforumAlertsubtitleAreyousureyouwanttodeleteforum,
          confirmationText: localStrNew.discussionforumAlertbuttonDeletebutton,
          cancelText: localStrNew.discussionforumAlertbuttonCancelbutton,
        );
      },
    );

    if (value != true) {
      MyPrint.printOnConsole("Returning from DiscussionController().deleteForum() because couldn't get confirmation", tag: tag);
      return false;
    }

    DeleteForumRequestModel requestModel = DeleteForumRequestModel(
      ForumID: forumModel.ForumID,
      SiteID: forumModel.SiteID,
      UserID: forumModel.CreatedUserID,
    );

    DataResponseModel<String> dataResponseModel = await _discussionRepository.DeleteForum(requestModel: requestModel);
    MyPrint.printOnConsole("DeleteForum response:$dataResponseModel", tag: tag);

    bool isSuccess = dataResponseModel.appErrorModel == null && dataResponseModel.data == "success";
    MyPrint.printOnConsole("isSuccess:$isSuccess", tag: tag);

    return isSuccess;
  }

  Future<bool> deleteTopic({
    required BuildContext context,
    required ForumModel forumModel,
    required TopicModel topicModel,
    void Function()? mySetState,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("DiscussionController().deleteTopic() called with contentId:'${topicModel.ContentID}'", tag: tag);

    dynamic value = await showDialog(
      context: context,
      builder: (BuildContext context) {
        LocalStr localStrNew = context.read<AppProvider>().localStr;

        return CommonConfirmationDialog(
          title: localStrNew.discussionforumActionsheetDeletetopicoption,
          description: localStrNew.discussionforumAlertsubtitleAreyousuretodeletetopic,
          confirmationText: localStrNew.discussionforumAlertbuttonDeletebutton,
          cancelText: localStrNew.discussionforumAlertbuttonCancelbutton,
        );
      },
    );

    if (value != true) {
      MyPrint.printOnConsole("Returning from DiscussionController().deleteTopic() because couldn't get confirmation", tag: tag);
      return false;
    }

    int index = forumModel.MainTopicsList.indexOf(topicModel);
    forumModel.MainTopicsList.remove(topicModel);
    forumModel.calculatePinnedTopics();
    mySetState?.call();

    DeleteDiscussionTopicRequestModel requestModel = DeleteDiscussionTopicRequestModel(
      ForumID: forumModel.ForumID,
      ForumName: forumModel.Name,
      TopicID: topicModel.ContentID,
      SiteID: forumModel.SiteID,
      UserID: topicModel.CreatedUserID,
    );

    DataResponseModel<String> dataResponseModel = await _discussionRepository.DeleteForumTopic(requestModel: requestModel);
    MyPrint.printOnConsole("DeleteForumTopic response:$dataResponseModel", tag: tag);

    bool isSuccess = dataResponseModel.appErrorModel == null && dataResponseModel.data == "success";
    MyPrint.printOnConsole("isSuccess:$isSuccess", tag: tag);

    if (!isSuccess) {
      if (index > -1) {
        forumModel.MainTopicsList.insert(index, topicModel);
        forumModel.calculatePinnedTopics();
        mySetState?.call();
      }
    }

    return isSuccess;
  }

  Future<bool> deleteComment({
    required BuildContext context,
    required TopicModel topicModel,
    required TopicCommentModel commentModel,
    void Function()? mySetState,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("DiscussionController().deleteComment() called with contentId:'${commentModel.topicid}'", tag: tag);

    dynamic value = await showDialog(
      context: context,
      builder: (BuildContext context) {
        LocalStr localStrNew = context.read<AppProvider>().localStr;

        return CommonConfirmationDialog(
          title: localStrNew.discussionforumActionsheetDeletetopicoption,
          description: localStrNew.discussionforumAlertsubtitleAreyousuretodeletecomment,
          confirmationText: localStrNew.discussionforumAlertbuttonDeletebutton,
          cancelText: localStrNew.discussionforumAlertbuttonCancelbutton,
        );
      },
    );

    if (value != true) {
      MyPrint.printOnConsole("Returning from DiscussionController().deleteComment() because couldn't get confirmation", tag: tag);
      return false;
    }

    int index = topicModel.commentList.indexOf(commentModel);
    topicModel.commentList.remove(commentModel);
    topicModel.NoOfReplies--;
    mySetState?.call();

    DeleteCommentRequestModel requestModel = DeleteCommentRequestModel(
      topicID: topicModel.ContentID,
      topicName: topicModel.Name,
      forumID: commentModel.forumid,
      createdUserID: commentModel.postedby,
      lastPostedDate: commentModel.posteddate,
      noofReplies: commentModel.CommentRepliesCount,
      replyID: commentModel.ReplyID,
    );

    DataResponseModel<String> dataResponseModel = await _discussionRepository.deleteComment(requestModel: requestModel);
    MyPrint.printOnConsole("deleteComment response:$dataResponseModel", tag: tag);

    bool isSuccess = dataResponseModel.appErrorModel == null && dataResponseModel.data == "success";
    MyPrint.printOnConsole("isSuccess:$isSuccess", tag: tag);

    if (!isSuccess) {
      if (index > -1) {
        topicModel.commentList.insert(index, commentModel);
        topicModel.NoOfReplies++;
        mySetState?.call();
      }
    }

    return isSuccess;
  }

  Future<bool> deleteReply({
    required BuildContext context,
    required TopicCommentModel commentModel,
    required CommentReplyModel replyModel,
    void Function()? mySetState,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("DiscussionController().deleteReply() called with replyId ${replyModel.replyID}'", tag: tag);

    dynamic value = await showDialog(
      context: context,
      builder: (BuildContext context) {
        LocalStr localStrNew = context.read<AppProvider>().localStr;

        return CommonConfirmationDialog(
          title: localStrNew.discussionforumActionsheetDeletetopicoption,
          description: localStrNew.discussionforumAlertsubtitleAreyousuretodeletereply,
          confirmationText: localStrNew.discussionforumAlertbuttonDeletebutton,
          cancelText: localStrNew.discussionforumAlertbuttonCancelbutton,
        );
      },
    );

    if (value != true) {
      MyPrint.printOnConsole("Returning from DiscussionController().deleteReply() because couldn't get confirmation", tag: tag);
      return false;
    }

    int index = commentModel.repliesList.indexOf(replyModel);
    commentModel.repliesList.remove(replyModel);
    commentModel.CommentRepliesCount--;
    mySetState?.call();

    DataResponseModel<String> dataResponseModel = await _discussionRepository.DeleteForumReply(replyId: replyModel.replyID);
    MyPrint.printOnConsole("DeleteForumReply response:$dataResponseModel", tag: tag);

    bool isSuccess = dataResponseModel.appErrorModel == null && dataResponseModel.data == "success";
    MyPrint.printOnConsole("isSuccess:$isSuccess", tag: tag);

    if (!isSuccess) {
      if (index > -1) {
        commentModel.repliesList.insert(index, replyModel);
        commentModel.CommentRepliesCount++;
        mySetState?.call();
      }
    }

    return isSuccess;
  }

  Future<bool> pinUnpinTopic({
    required ForumModel forumModel,
    required TopicModel topicModel,
    void Function()? mySetState,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("DiscussionController().pinUnpinTopic() called with contentId:'${topicModel.ContentID}'", tag: tag);

    topicModel.IsPin = !topicModel.IsPin;
    forumModel.calculatePinnedTopics();
    mySetState?.call();

    UpdatePinTopicRequestModel requestModel = UpdatePinTopicRequestModel(
      forumID: forumModel.ForumID,
      strContentID: topicModel.ContentID,
      isPin: topicModel.IsPin,
    );

    DataResponseModel<String> dataResponseModel = await _discussionRepository.UpdatePinTopic(requestModel: requestModel);

    MyPrint.printOnConsole("UpdatePinTopic response:$dataResponseModel", tag: tag);

    bool isSuccess = dataResponseModel.appErrorModel != null && dataResponseModel.statusCode == 204;

    if (!isSuccess) {
      topicModel.IsPin = !topicModel.IsPin;
      forumModel.calculatePinnedTopics();

      mySetState?.call();
    }

    return isSuccess;
  }

  Future<bool> likeDislikeTopic({required TopicModel topicModel, ForumModel? forumModel, void Function()? mySetState}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("DiscussionController().likeDislikeTopic() called with contentId:'${topicModel.ContentID}', liked:${topicModel.likeState}", tag: tag);

    LikeDislikeTopicAndCommentRequestModel requestModel = LikeDislikeTopicAndCommentRequestModel(
      strObjectID: topicModel.ContentID,
      blnIsLiked: !topicModel.likeState,
      intTypeID: 1,
      intUserID: discussionRepository.apiController.apiDataProvider.getCurrentUserId(),
    );
    MyPrint.printOnConsole("requestModel:$requestModel", tag: tag);

    topicModel.likeState = !topicModel.likeState;
    MyPrint.printOnConsole("topicModel.likeState:${topicModel.likeState}", tag: tag);

    LikeUserIDModel? likeUserIDModel;
    if (topicModel.likeState) {
      topicModel.Likes++;

      likeUserIDModel = LikeUserIDModel(
        UserID: requestModel.intUserID,
        ObjectID: requestModel.strObjectID,
      );
      forumModel?.TotalLikes.add(likeUserIDModel);
      forumModel?.calculateLikeUserCount();
    } else {
      topicModel.Likes--;

      likeUserIDModel = forumModel?.TotalLikes.where((element) => element.UserID == requestModel.intUserID && element.ObjectID == requestModel.strObjectID).firstOrNull;
      if (likeUserIDModel != null) {
        forumModel?.TotalLikes.remove(likeUserIDModel);
        forumModel?.calculateLikeUserCount();
      }
    }
    mySetState?.call();

    DataResponseModel<List<ForumUserInfoModel>> dataResponseModel = await _discussionRepository.likeDislikeTopicAndComment(requestModel: requestModel);
    MyPrint.printOnConsole("dataResponseModel:$dataResponseModel", tag: tag);

    bool isSuccess = dataResponseModel.appErrorModel == null && (dataResponseModel.data?.where((element) => element.UserID == requestModel.intUserID)).checkNotEmpty;
    MyPrint.printOnConsole("isSuccess:$isSuccess", tag: tag);

    if (!isSuccess) {
      topicModel.likeState = !topicModel.likeState;
      if (topicModel.likeState) {
        topicModel.Likes++;
        if (likeUserIDModel != null) {
          forumModel?.TotalLikes.add(likeUserIDModel);
          forumModel?.calculateLikeUserCount();
        }
      } else {
        topicModel.Likes--;
        if (likeUserIDModel != null) {
          forumModel?.TotalLikes.remove(likeUserIDModel);
          forumModel?.calculateLikeUserCount();
        }
      }
      mySetState?.call();
    } else {
      if (topicModel.likeState) {
        BuildContext? context = NavigationController.mainNavigatorKey.currentContext;
        if (context != null) {
          await GamificationController(provider: context.read<GamificationProvider>()).UpdateContentGamification(
            requestModel: UpdateContentGamificationRequestModel(
              contentId: "",
              scoId: 0,
              objecttypeId: 0,
              GameAction: GamificationActionType.Liked,
            ),
          );
        }
      }
    }

    return isSuccess;
  }

  Future<bool> likeDislikeComment({required TopicCommentModel commentModel, void Function()? mySetState}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("DiscussionController().likeDislikeComment() called with commentid:'${commentModel.commentid}', liked:${commentModel.likeState}", tag: tag);

    LikeDislikeTopicAndCommentRequestModel requestModel = LikeDislikeTopicAndCommentRequestModel(
      strObjectID: commentModel.commentid.toString(),
      blnIsLiked: !commentModel.likeState,
      intTypeID: 2,
      intUserID: discussionRepository.apiController.apiDataProvider.getCurrentUserId(),
    );
    MyPrint.printOnConsole("requestModel:$requestModel", tag: tag);

    commentModel.likeState = !commentModel.likeState;
    MyPrint.printOnConsole("commentModel.likeState:${commentModel.likeState}", tag: tag);

    if (commentModel.likeState) {
      commentModel.CommentLikes++;
    } else {
      commentModel.CommentLikes--;
    }
    mySetState?.call();

    DataResponseModel<List<ForumUserInfoModel>> dataResponseModel = await _discussionRepository.likeDislikeTopicAndComment(requestModel: requestModel);
    MyPrint.printOnConsole("dataResponseModel:$dataResponseModel", tag: tag);

    bool isSuccess = dataResponseModel.appErrorModel == null && (dataResponseModel.data?.where((element) => element.UserID == requestModel.intUserID)).checkNotEmpty;
    MyPrint.printOnConsole("isSuccess:$isSuccess", tag: tag);

    if (!isSuccess) {
      commentModel.likeState = !commentModel.likeState;
      if (commentModel.likeState) {
        commentModel.CommentLikes++;
      } else {
        commentModel.CommentLikes--;
      }
      mySetState?.call();
    } else {
      if (commentModel.likeState) {
        BuildContext? context = NavigationController.mainNavigatorKey.currentContext;
        if (context != null) {
          await GamificationController(provider: context.read<GamificationProvider>()).UpdateContentGamification(
            requestModel: UpdateContentGamificationRequestModel(
              contentId: "",
              scoId: 0,
              objecttypeId: 0,
              GameAction: GamificationActionType.Liked,
            ),
          );
        }
      }
    }

    return isSuccess;
  }

  Future<bool> likeDislikeReply({required CommentReplyModel replyModel, void Function()? mySetState}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("DiscussionController().likeDislikeReply() called with replyID:'${replyModel.replyID}', liked:${replyModel.likeState}", tag: tag);

    LikeDislikeReplyRequestModel requestModel = LikeDislikeReplyRequestModel(
      strObjectID: replyModel.replyID.toString(),
      blnIsLiked: !replyModel.likeState,
      intTypeID: 5,
      intUserID: discussionRepository.apiController.apiDataProvider.getCurrentUserId(),
    );
    MyPrint.printOnConsole("requestModel:$requestModel", tag: tag);

    replyModel.likeState = !replyModel.likeState;
    MyPrint.printOnConsole("replyModel.likeState:${replyModel.likeState}", tag: tag);

    mySetState?.call();

    DataResponseModel<String> dataResponseModel = await _discussionRepository.likeDislikeReply(requestModel: requestModel);
    MyPrint.printOnConsole("dataResponseModel:$dataResponseModel", tag: tag);

    bool isSuccess = dataResponseModel.appErrorModel == null && dataResponseModel.statusCode == 200 && (dataResponseModel.data ?? "").startsWith("1");
    MyPrint.printOnConsole("isSuccess:$isSuccess", tag: tag);

    if (!isSuccess) {
      replyModel.likeState = !replyModel.likeState;
      mySetState?.call();
    } else {
      if (replyModel.likeState) {
        BuildContext? context = NavigationController.mainNavigatorKey.currentContext;
        if (context != null) {
          await GamificationController(provider: context.read<GamificationProvider>()).UpdateContentGamification(
            requestModel: UpdateContentGamificationRequestModel(
              contentId: "",
              scoId: 0,
              objecttypeId: 0,
              GameAction: GamificationActionType.Liked,
            ),
          );
        }
      }
    }

    return isSuccess;
  }

  Future<void> showForumLikedUserList({required BuildContext context, required ForumModel forumModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("DiscussionController().showLikedUserList() called with '", tag: tag);
    if (forumModel.totalLikeUserCount != forumModel.likeUserList.length) {
      DataResponseModel<List<ForumUserInfoModel>> dataResponseModel = await _discussionRepository.getForumLevelLikedUserList(forumId: forumModel.ForumID);

      forumModel.likeUserList = dataResponseModel.data ?? [];

      MyPrint.printOnConsole("deleteComment response:$dataResponseModel", tag: tag);

      if (dataResponseModel.appErrorModel != null) {
        MyPrint.printOnConsole("Returning from DiscussionController().showLikedUserList() because deleteComment had some error", tag: tag);
        return;
      }
    }

    if (forumModel.likeUserList.checkEmpty) return;

    if (context.mounted && context.checkMounted()) {
      showUserListView(context: context, userList: forumModel.likeUserList);
    }
  }

  Future<void> showTopicLikedUserList({required BuildContext context, required TopicModel topicModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("DiscussionController().showTopicLikedUserList() called with '", tag: tag);
    if (topicModel.Likes != topicModel.userLikeList.length) {
      DataResponseModel<List<ForumUserInfoModel>> dataResponseModel = await _discussionRepository.getTopicCommentLevelLikedUserList(topicId: topicModel.ContentID, intTypeID: 1);

      topicModel.userLikeList = dataResponseModel.data ?? [];
      MyPrint.printOnConsole("deleteComment response:$dataResponseModel", tag: tag);

      if (dataResponseModel.appErrorModel != null) {
        MyPrint.printOnConsole("Returning from DiscussionController().showLikedUserList() because deleteComment had some error", tag: tag);
        return;
      }
    }

    if (topicModel.userLikeList.checkEmpty) return;

    if (context.mounted && context.checkMounted()) {
      showUserListView(context: context, userList: topicModel.userLikeList);
    }
  }

  Future<void> showCommentLikedUserList({required BuildContext context, required TopicCommentModel topicCommentModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("DiscussionController().showCommentLikedUserList() called with '", tag: tag);
    if (topicCommentModel.CommentRepliesCount != topicCommentModel.userLikeList.length) {
      DataResponseModel<List<ForumUserInfoModel>> dataResponseModel = await _discussionRepository.getTopicCommentLevelLikedUserList(topicId: topicCommentModel.commentid.toString(), intTypeID: 2);
      topicCommentModel.userLikeList = dataResponseModel.data ?? [];
      MyPrint.printOnConsole("deleteComment response:$dataResponseModel", tag: tag);

      if (dataResponseModel.appErrorModel != null) {
        MyPrint.printOnConsole("Returning from DiscussionController().showLikedUserList() because deleteComment had some error", tag: tag);
        return;
      }
    }

    if (topicCommentModel.userLikeList.checkEmpty) return;

    if (context.mounted && context.checkMounted()) {
      showUserListView(context: context, userList: topicCommentModel.userLikeList);
    }
  }

  void showUserListView({required BuildContext context, required List<ForumUserInfoModel> userList}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BottomSheetDragger(),
            Text(
              "(${userList.length}) likes",
              style: const TextStyle(fontSize: 18),
            ),
            const Divider(thickness: .5),
            ListView.builder(
              shrinkWrap: true,
              itemCount: userList.length,
              itemBuilder: (BuildContext context, int index) {
                ForumUserInfoModel userModel = userList[index];
                String profileImageUrl = MyUtils.getSecureUrl(
                  AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(
                    imagePath: userModel.UserThumb,
                  ),
                );

                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CommonCachedNetworkImage(
                      imageUrl: profileImageUrl,
                      height: 30,
                      width: 30,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(userModel.UserName),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
