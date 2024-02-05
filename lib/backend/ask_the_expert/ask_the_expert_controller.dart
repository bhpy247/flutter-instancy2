import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/ask_the_expert/ask_the_expert_provider.dart';
import 'package:flutter_instancy_2/backend/ask_the_expert/ask_the_expert_repository.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/data_model/answer_comment_dto.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/data_model/ask_the_expert_dto.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/request_model/add_answer_request_model.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/request_model/add_comment_request_model.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/request_model/add_question_request_model.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/response_model/filter_user_skills_dto.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:provider/provider.dart';

import '../../api/api_controller.dart';
import '../../models/app_configuration_models/data_models/local_str.dart';
import '../../models/ask_the_expert/request_model/get_question_list_forum_model.dart';
import '../../models/ask_the_expert/request_model/send_mail_to_expert_request_model.dart';
import '../../models/ask_the_expert/response_model/QuestionListDtoResponseModel.dart';
import '../../models/ask_the_expert/response_model/add_question_response_model.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/pagination/pagination_model.dart';
import '../../models/filter/data_model/enabled_content_filter_by_type_model.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';
import '../../views/common/components/common_confirmation_dialog.dart';
import '../app/app_provider.dart';
import '../filter/filter_provider.dart';

class AskTheExpertController {
  late AskTheExpertProvider _askTheExpertProvider;
  late AskTheExpertRepository _askTheExpertRepository;

  AskTheExpertController({required AskTheExpertProvider? discussionProvider, AskTheExpertRepository? repository, ApiController? apiController}) {
    _askTheExpertProvider = discussionProvider ?? AskTheExpertProvider();
    _askTheExpertRepository = repository ?? AskTheExpertRepository(apiController: apiController ?? ApiController());
  }

  AskTheExpertProvider get askTheExpertProvider => _askTheExpertProvider;

  AskTheExpertRepository get askTheExpertRepositoryRepository => _askTheExpertRepository;

  //region Ask the expert
  //region Get Forums List with Pagination
  Future<bool> getQuestionsList({
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

    AskTheExpertProvider provider = askTheExpertProvider;
    AskTheExpertRepository repository = askTheExpertRepositoryRepository;
    PaginationModel paginationModel = provider.questionListPaginationModel.get();

    //region If Not refresh and Data available, return Cached Data
    if (!isRefresh && isGetFromCache && provider.questionList.length > 0) {
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
      provider.questionList.setList(list: <UserQuestionListDto>[], isClear: true, isNotify: isNotify);
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
    GetQuestionListRequestModel requestModel = getForumListRequestModelFromProviderData(
      provider: provider,
      paginationModel: paginationModel,
      componentId: componentId,
      componentInstanceId: componentInstanceId,
    );
    //endregion

    //region Make Api Call
    DataResponseModel<QuestionListDtoResponseModel> response = await repository.getQuestionList(
      requestModel: requestModel,
    );
    MyPrint.printOnConsole("Forum Response:$response", tag: tag);
    //endregion

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole("Forum Data got in ${endTime.difference(startTime).inMilliseconds} Milliseconds", tag: tag);

    List<UserQuestionListDto> questionList = response.data?.questionList ?? <UserQuestionListDto>[];
    MyPrint.printOnConsole("Forum List Length got in Api:${questionList.length}", tag: tag);

    List<UserQuestionListDto> newQuestionList = <UserQuestionListDto>[];
    Map<int, UserQuestionListDto> newQuestionMap = provider.questionListMap.getMap(isNewInstance: false);

    Map<int, UserQuestionListDto> questionMap = provider.questionListMap.getMap(isNewInstance: true);
    for (UserQuestionListDto questionModel in questionList) {
      UserQuestionListDto? existingModel = questionMap[questionModel.questionID];
      if (existingModel == null) {
        existingModel = questionModel;
        newQuestionMap[questionModel.questionID] = questionModel;
      } else {
        existingModel.updateFromJson(questionModel.toJson());
      }

      newQuestionList.add(existingModel);
    }

    //region Set Provider Data After Getting Data From Api
    // provider.maxQuestionListCount.set(value: response.data?.rowcount ?? 0, isNotify: false);
    provider.questionList.setList(list: newQuestionList, isClear: false, isNotify: false);
    provider.questionListMap.setMap(map: newQuestionMap, isClear: false, isNotify: false);
    PaginationModel.updatePaginationData(
      paginationModel: paginationModel,
      isFirstTimeLoading: false,
      pageIndex: paginationModel.pageIndex + 1,
      hasMore: questionList.length == provider.pageSize.get(),
      isLoading: false,
      notifier: provider.notify,
      notify: true,
    );
    //endregion

    return true;
  }

  GetQuestionListRequestModel getForumListRequestModelFromProviderData({
    required AskTheExpertProvider provider,
    required PaginationModel paginationModel,
    required int componentId,
    required int componentInstanceId,
  }) {
    FilterProvider filterProvider = provider.filterProvider;
    EnabledContentFilterByTypeModel? enabledContentFilterByTypeModel = filterProvider.getEnabledContentFilterByTypeModel(isNewInstance: false);

    return GetQuestionListRequestModel(
      intCompID: componentId,
      intCompInsID: componentInstanceId,
      strSearchText: provider.questionListSearchString.get(),

      // : provider.forumContentId.get(),
      // userID: "363",
      pageIndex: paginationModel.pageIndex,
      intSkillID: provider.filterCategoriesIds.get(),
      sortby: provider.sortingData.get(),
      pageSize: provider.pageSize.get(),
    );
  }

  //endRegion

  Future<bool> addQuestion({
    required AddQuestionRequestModel requestModel,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("DiscussionController().addTopic() called '", tag: tag);

    DataResponseModel<AddQuestionResponseModel> dataResponseModel = await _askTheExpertRepository.addQuestion(requestModel: requestModel);

    MyPrint.printOnConsole("addTopicComment response:${dataResponseModel.data}", tag: tag);

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from DiscussionController().addTopic() because addTopic had some error", tag: tag);
      return false;
    }

    bool isSuccess = dataResponseModel.data?.table.checkNotEmpty ?? false;

    if (isSuccess) {
      int questionId = dataResponseModel.data?.table?.first.column1 ?? 0;
      SendMailToExpertRequestModel mailToExpertRequestModel = SendMailToExpertRequestModel(
        intQuestionID: questionId,
        Questionskills: requestModel.skills,
        userQuestion: requestModel.UserQuestion,
      );
      askTheExpertRepositoryRepository.sendMailToExperts(requestModel: mailToExpertRequestModel);
    }

    if (!isSuccess) {
      return false;
    }

    // if (requestModel.strAttachFileBytes != null) {
    //   UploadForumAttachmentModel uploadForumAttachmentModel = UploadForumAttachmentModel(
    //     topicId: topicId,
    //     isTopic: true,
    //     fileUploads: [
    //       InstancyMultipartFileUploadModel(
    //         fieldName: "Image",
    //         fileName: requestModel.strAttachFile,
    //         bytes: requestModel.strAttachFileBytes,
    //       )
    //     ],
    //   );
    //   bool isSuccessUpload = await uploadForumAttachment(requestModel: uploadForumAttachmentModel);
    //   MyPrint.printOnConsole("isSuccessUpload:$isSuccessUpload", tag: tag);
    // }

    // BuildContext? context = NavigationController.mainNavigatorKey.currentContext;
    // if (context != null) {
    //   await GamificationController(provider: context.read<GamificationProvider>()).UpdateContentGamification(
    //     requestModel: UpdateContentGamificationRequestModel(
    //       contentId: "",
    //       scoId: 0,
    //       objecttypeId: 0,
    //       GameAction: GamificationActionType.AddedTopic,
    //     ),
    //   );
    // }

    return true;
  }

  Future<bool> likeDislikeComment({required QuestionAnswerResponse commentModel, void Function()? mySetState, bool? isLiked}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("DiscussionController().likeDislikeComment() called with commentid:'${commentModel.responseID}', liked:${commentModel.isLiked}", tag: tag);

    commentModel.isLiked = isLiked;
    MyPrint.printOnConsole("commentModel.likeState:${commentModel.isLiked}", tag: tag);

    if (isLiked ?? false) {
      commentModel.upvotesCount++;
    } else {
      commentModel.upvotesCount--;
    }
    mySetState?.call();

    DataResponseModel<String> dataResponseModel = await _askTheExpertRepository.updateVote(responseId: commentModel.responseID, isLikedOrDisliked: commentModel.isLiked);
    MyPrint.printOnConsole("dataResponseModel:$dataResponseModel", tag: tag);

    bool isSuccess = dataResponseModel.appErrorModel == null && dataResponseModel.data.checkNotEmpty;
    MyPrint.printOnConsole("isSuccess:$isSuccess", tag: tag);

    if (!isSuccess) {
      commentModel.isLiked = isLiked;
      if (commentModel.isLiked ?? false) {
        commentModel.upvotesCount++;
      } else {
        commentModel.upvotesCount--;
      }
      mySetState?.call();
    } else {
      // if (commentModel.likeState) {
      //   BuildContext? context = NavigationController.mainNavigatorKey.currentContext;
      //   if (context != null) {
      //     await GamificationController(provider: context.read<GamificationProvider>()).UpdateContentGamification(
      //       requestModel: UpdateContentGamificationRequestModel(
      //         contentId: "",
      //         scoId: 0,
      //         objecttypeId: 0,
      //         GameAction: GamificationActionType.Liked,
      //       ),
      //     );
      //   }
      // }
    }

    return isSuccess;
  }

  Future<bool> likeDislikeAnswerComment({required AnswerCommentsModel commentModel, void Function()? mySetState, bool? isLiked}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("DiscussionController().likeDislikeComment() called with commentid:'${commentModel.commentID}', liked:${commentModel.isLiked}", tag: tag);

    commentModel.isLiked = isLiked;
    MyPrint.printOnConsole("commentModel.likeState:${commentModel.isLiked}", tag: tag);

    // if (isLiked ?? false) {
    //   commentModel.upvotesCount++;
    // } else {
    //   commentModel.upvotesCount--;
    // // }
    mySetState?.call();

    DataResponseModel<String> dataResponseModel =
        await _askTheExpertRepository.updateVote(responseId: commentModel.commentID, isLikedOrDisliked: commentModel.isLiked, typeId: 4, isFromAnswerComment: true);
    MyPrint.printOnConsole("dataResponseModel:$dataResponseModel", tag: tag);

    bool isSuccess = dataResponseModel.appErrorModel == null && dataResponseModel.data.checkNotEmpty;
    MyPrint.printOnConsole("isSuccess:$isSuccess", tag: tag);

    if (!isSuccess) {
      commentModel.isLiked = isLiked;
      // if (commentModel.isLiked ?? false) {
      //   commentModel.upvotesCount++;
      // } else {
      //   commentModel.upvotesCount--;
      // }
      mySetState?.call();
    } else {
      // if (commentModel.likeState) {
      //   BuildContext? context = NavigationController.mainNavigatorKey.currentContext;
      //   if (context != null) {
      //     await GamificationController(provider: context.read<GamificationProvider>()).UpdateContentGamification(
      //       requestModel: UpdateContentGamificationRequestModel(
      //         contentId: "",
      //         scoId: 0,
      //         objecttypeId: 0,
      //         GameAction: GamificationActionType.Liked,
      //       ),
      //     );
      //   }
      // }
    }

    return isSuccess;
  }

  Future<bool> DeleteUserResponse({required QuestionAnswerResponse commentModel, void Function()? mySetState, bool? isLiked}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("DiscussionController().DeleteUserResponse() called with commentid:'${commentModel.responseID}', liked:${commentModel.isLiked}", tag: tag);

    commentModel.isLiked = isLiked;
    MyPrint.printOnConsole("commentModel.likeState:${commentModel.isLiked}", tag: tag);

    // if (isLiked ?? false) {
    //   commentModel.upvotesCount++;
    // } else {
    //   commentModel.upvotesCount--;
    // }
    mySetState?.call();

    DataResponseModel<String> dataResponseModel = await _askTheExpertRepository.DeleteResponseUpAndDownVoters(responseId: commentModel.responseID);
    MyPrint.printOnConsole("dataResponseModel:$dataResponseModel", tag: tag);

    bool isSuccess = dataResponseModel.appErrorModel == null && dataResponseModel.data == "1";
    MyPrint.printOnConsole("isSuccess:$isSuccess", tag: tag);

    // if (!isSuccess) {
    //   commentModel.isLiked = isLiked;
    //   if (commentModel.isLiked ?? false) {
    //     commentModel.upvotesCount++;
    //   } else {
    //     commentModel.upvotesCount--;
    //   }
    //   mySetState?.call();
    // } else {
    //   // if (commentModel.likeState) {
    //   //   BuildContext? context = NavigationController.mainNavigatorKey.currentContext;
    //   //   if (context != null) {
    //   //     await GamificationController(provider: context.read<GamificationProvider>()).UpdateContentGamification(
    //   //       requestModel: UpdateContentGamificationRequestModel(
    //   //         contentId: "",
    //   //         scoId: 0,
    //   //         objecttypeId: 0,
    //   //         GameAction: GamificationActionType.Liked,
    //   //       ),
    //   //     );
    //   //   }
    //   // }
    // }

    return isSuccess;
  }

  Future<bool> deleteAnswer({
    required BuildContext context,
    required UserQuestionListDto questionListDto,
    required QuestionAnswerResponse answerModel,
    void Function()? mySetState,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("DiscussionController().deleteComment() called with contentId:'${answerModel.responseID}'", tag: tag);

    dynamic value = await showDialog(
      context: context,
      builder: (BuildContext context) {
        LocalStr localStrNew = context.read<AppProvider>().localStr;

        return CommonConfirmationDialog(
          title: localStrNew.asktheexpertAlerttitleDeleteanswer,
          description: localStrNew.asktheexpertAlertsubtitleAreyousuretodeletetheanswer,
          confirmationText: localStrNew.asktheexpertAlertbuttonDeletebutton,
          cancelText: localStrNew.asktheexpertAlertbuttonCancelbutton,
        );
      },
    );

    if (value != true) {
      MyPrint.printOnConsole("Returning from DiscussionController().deleteComment() because couldn't get confirmation", tag: tag);
      return false;
    }

    int index = questionListDto.questionsAnswerList.indexOf(answerModel);
    questionListDto.questionsAnswerList.remove(answerModel);
    // questionListDto.answer--;
    mySetState?.call();

    DataResponseModel<String> dataResponseModel = await _askTheExpertRepository.deleteAnswer(responseId: answerModel.responseID);
    MyPrint.printOnConsole("deleteComment response:$dataResponseModel", tag: tag);

    bool isSuccess = dataResponseModel.appErrorModel == null && dataResponseModel.data == "2";
    MyPrint.printOnConsole("isSuccess:$isSuccess", tag: tag);

    if (!isSuccess) {
      if (index > -1) {
        // questionListDto.questionsAnswerList.remove(answerModel);
        questionListDto.questionsAnswerList.insert(index, answerModel);
        // topicModel.NoOfReplies++;
        mySetState?.call();
      }
    }

    return isSuccess;
  }

  Future<bool> addAnswer({
    required AddAnswerRequestModel requestModel,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("DiscussionController().addTopic() called '", tag: tag);

    DataResponseModel<AskTheExpertDto> dataResponseModel = await _askTheExpertRepository.addAnswer(requestModel: requestModel);

    MyPrint.printOnConsole("addTopicComment response:${dataResponseModel.data}", tag: tag);

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from DiscussionController().addTopic() because addTopic had some error", tag: tag);
      return false;
    }

    bool isSuccess = dataResponseModel.data?.userQuestionListDto.checkNotEmpty ?? false;

    if (!isSuccess) {
      return false;
    }

    // if (requestModel.strAttachFileBytes != null) {
    //   UploadForumAttachmentModel uploadForumAttachmentModel = UploadForumAttachmentModel(
    //     topicId: topicId,
    //     isTopic: true,
    //     fileUploads: [
    //       InstancyMultipartFileUploadModel(
    //         fieldName: "Image",
    //         fileName: requestModel.strAttachFile,
    //         bytes: requestModel.strAttachFileBytes,
    //       )
    //     ],
    //   );
    //   bool isSuccessUpload = await uploadForumAttachment(requestModel: uploadForumAttachmentModel);
    //   MyPrint.printOnConsole("isSuccessUpload:$isSuccessUpload", tag: tag);
    // }

    // BuildContext? context = NavigationController.mainNavigatorKey.currentContext;
    // if (context != null) {
    //   await GamificationController(provider: context.read<GamificationProvider>()).UpdateContentGamification(
    //     requestModel: UpdateContentGamificationRequestModel(
    //       contentId: "",
    //       scoId: 0,
    //       objecttypeId: 0,
    //       GameAction: GamificationActionType.AddedTopic,
    //     ),
    //   );
    // }

    return true;
  }

  Future<bool> deleteQuestion({
    required BuildContext context,
    required UserQuestionListDto model,
    void Function()? mySetState,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("DiscussionController().deleteQuestion() called with contentId:'${model.questionID}'", tag: tag);

    dynamic value = await showDialog(
      context: context,
      builder: (BuildContext context) {
        LocalStr localStrNew = context.read<AppProvider>().localStr;

        return CommonConfirmationDialog(
          title: localStrNew.asktheexpertAlerttitleDeleteanswer,
          description: localStrNew.asktheexpertAlertsubtitleAreyousurewanttopermanentlydeletequestion,
          confirmationText: localStrNew.discussionforumAlertbuttonDeletebutton,
          cancelText: localStrNew.discussionforumAlertbuttonCancelbutton,
        );
      },
    );

    if (value != true) {
      MyPrint.printOnConsole("Returning from DiscussionController().deleteComment() because couldn't get confirmation", tag: tag);
      return false;
    }

    // mySetState?.call();

    DataResponseModel<String> dataResponseModel = await _askTheExpertRepository.deleteQuestion(QuestionID: model.questionID);
    MyPrint.printOnConsole("deleteComment response:$dataResponseModel", tag: tag);

    bool isSuccess = dataResponseModel.appErrorModel == null && dataResponseModel.statusCode == 200;
    MyPrint.printOnConsole("isSuccess:$isSuccess", tag: tag);

    if (!isSuccess) {
      // if (index > -1) {
      //   // questionListDto.questionsAnswerList.remove(answerModel);
      //   questionListDtoResponseModel.questionList.remove(model);
      //   // topicModel.NoOfReplies++;
      //   mySetState?.call();
      // }
    }

    return isSuccess;
  }

  // Future<bool> editTopic({
  //   required String contentId,
  //   required int componentId,
  //   required int componentInstanceId,
  //   required AddAnswerRequestModel requestModel,
  // }) async {
  //   String tag = MyUtils.getNewId();
  //   MyPrint.printOnConsole("DiscussionController().editTopic() called with contentId:'$contentId'", tag: tag);
  //
  //   DataResponseModel<String> dataResponseModel = await _discussionRepository.addTopic(requestModel: requestModel, isEdit: true);
  //
  //   MyPrint.printOnConsole("addTopicComment response:$dataResponseModel", tag: tag);
  //
  //   if (dataResponseModel.appErrorModel != null) {
  //     MyPrint.printOnConsole("Returning from DiscussionController().editTopic() because editTopic had some error", tag: tag);
  //     return false;
  //   }
  //
  //   bool isSuccess = dataResponseModel.data == "success";
  //   MyPrint.printOnConsole("isSuccess $isSuccess", tag: tag);
  //
  //   if (!isSuccess) {
  //     return false;
  //   }
  //
  //   if (requestModel.strAttachFileBytes != null) {
  //     UploadForumAttachmentModel uploadForumAttachmentModel = UploadForumAttachmentModel(
  //       topicId: contentId,
  //       isTopic: true,
  //       fileUploads: [
  //         InstancyMultipartFileUploadModel(
  //           fieldName: "Image",
  //           fileName: requestModel.strAttachFile,
  //           bytes: requestModel.strAttachFileBytes,
  //         )
  //       ],
  //     );
  //     bool isSuccessUpload = await uploadForumAttachment(requestModel: uploadForumAttachmentModel);
  //     MyPrint.printOnConsole("isSuccessUpload:$isSuccessUpload", tag: tag);
  //   }
  //
  //   return true;
  // }

  Future<bool> addComment({
    required AddCommentRequestModel requestModel,
    void Function()? mySetState,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("DiscussionController().addComment() called with contentId:'${requestModel.ResponseID}'", tag: tag);

    DataResponseModel<String> dataResponseModel = await _askTheExpertRepository.addComment(requestModel: requestModel);
    MyPrint.printOnConsole("addComment response:$dataResponseModel", tag: tag);

    bool isSuccess = dataResponseModel.appErrorModel == null && dataResponseModel.data == "1";
    MyPrint.printOnConsole("isSuccess:$isSuccess", tag: tag);

    if (!isSuccess) {
      MyPrint.printOnConsole("Returning from DiscussionController().addComment() because couldn't Create Comment", tag: tag);
      return false;
    }

    // BuildContext? context = NavigationController.mainNavigatorKey.currentContext;
    // if (context != null) {
    //   await GamificationController(provider: context.read<GamificationProvider>()).UpdateContentGamification(
    //     requestModel: UpdateContentGamificationRequestModel(
    //       contentId: "",
    //       scoId: 0,
    //       objecttypeId: 0,
    //       GameAction: GamificationActionType.AddedComment,
    //     ),
    //   );
    // }

    return isSuccess;
  }

  Future<bool> getFilterSkills({required int componentId, required int componentInstanceId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("DiscussionController().getUserListBaseOnUserInfo() called '", tag: tag);

    DataResponseModel<FilterUserSkillsDtoResponseModel> dataResponseModel = await _askTheExpertRepository.getFilterSkills(componentId: componentId, componentInstanceId: componentInstanceId);

    MyPrint.printOnConsole("addTopicComment response:$dataResponseModel", tag: tag);

    if (dataResponseModel.data != null || dataResponseModel.data!.table.checkNotEmpty) {
      askTheExpertProvider.filterSkillsList.setList(list: dataResponseModel.data?.table ?? []);
    }

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from DiscussionController().getUserListBaseOnUserInfo() because addTopic had some error", tag: tag);
      return false;
    }

    return dataResponseModel.data?.table.checkNotEmpty ?? false;
  }

  Future<bool> getUserFilterSkills({required int componentId, required int componentInstanceId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("DiscussionController().getUserListBaseOnUserInfo() called '", tag: tag);

    DataResponseModel<FilterUserSkillsDtoResponseModel> dataResponseModel = await _askTheExpertRepository.getUserSkills(componentId: componentId, componentInstanceId: componentInstanceId);

    MyPrint.printOnConsole("addTopicComment response:$dataResponseModel", tag: tag);

    if (dataResponseModel.data != null || dataResponseModel.data!.table.checkNotEmpty) {
      askTheExpertProvider.userFilterSkillsList.setList(list: dataResponseModel.data?.userFilterSkills ?? []);
    }

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from DiscussionController().getUserListBaseOnUserInfo() because addTopic had some error", tag: tag);
      return false;
    }

    return dataResponseModel.data?.table.checkNotEmpty ?? false;
  }
}
