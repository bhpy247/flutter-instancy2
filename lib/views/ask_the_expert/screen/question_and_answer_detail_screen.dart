import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/my_safe_state.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_instancy_2/backend/ask_the_expert/ask_the_expert_controller.dart';
import 'package:flutter_instancy_2/backend/ask_the_expert/ask_the_expert_provider.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/data_model/ask_the_expert_dto.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/views/ask_the_expert/component/questionAnswerCard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../backend/app/app_provider.dart';
import '../../../backend/app_theme/style.dart';
import '../../../backend/authentication/authentication_provider.dart';
import '../../../backend/configurations/app_configuration_operations.dart';
import '../../../backend/navigation/navigation_arguments.dart';
import '../../../backend/navigation/navigation_controller.dart';
import '../../../backend/navigation/navigation_operation_parameters.dart';
import '../../../backend/navigation/navigation_type.dart';
import '../../../backend/ui_actions/ask_the_expert/answer/answer_comment_ui_action_callback_model.dart';
import '../../../backend/ui_actions/ask_the_expert/answer/answer_comment_ui_action_controller.dart';
import '../../../backend/ui_actions/primary_secondary_actions/primary_secondary_actions_constants.dart';
import '../../../configs/app_configurations.dart';
import '../../../models/app_configuration_models/data_models/local_str.dart';
import '../../../models/ask_the_expert/data_model/answer_comment_dto.dart';
import '../../../models/common/data_response_model.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_toast.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/common_cached_network_image.dart';
import '../../common/components/common_loader.dart';
import '../../common/components/common_text_form_field.dart';
import '../../common/components/instancy_ui_actions/bottomsheet_drager.dart';
import '../../common/components/instancy_ui_actions/instancy_ui_actions.dart';
import '../../common/components/modal_progress_hud.dart';

class QuestionAndAnswerDetailsScreen extends StatefulWidget {
  static const String routeName = "/QuestionAndAnswerDetailsScreen";
  final QuestionAndAnswerDetailsScreenArguments arguments;

  const QuestionAndAnswerDetailsScreen({super.key, required this.arguments});

  @override
  State<QuestionAndAnswerDetailsScreen> createState() => _QuestionAndAnswerDetailsScreenState();
}

class _QuestionAndAnswerDetailsScreenState extends State<QuestionAndAnswerDetailsScreen> with MySafeState {
  late ThemeData themeData;
  Future? future;
  bool isLoading = false;
  FocusNode commentFocusNode = FocusNode(), replyFocusNode = FocusNode();
  late AskTheExpertController askTheExpertController;
  late AskTheExpertProvider askTheExpertProvider;
  late AppProvider appProvider;
  QuestionAnswerResponse? selectedAnswerForComment;
  List<UpVotesUsers> upVoteUsersList = const [];

  // TopicCommentModel? selectedCommentModelForReply, selectedCommentModelForEdit;
  // CommentReplyModel? selectedReplyModelForEdit;
  bool isCommentTextFormFieldVisible = false, isReplyTextFormFieldVisible = false;

  bool isLikeEnabled = false;
  bool isShowInAscendingOrder = false;

  // late DiscussionTopicUiActionController uiActionController;

  TextEditingController commentTextEditingController = TextEditingController(), replyTextEditingController = TextEditingController();

  UserQuestionListDto? userQuestion;

  FileType? fileType;

  bool isExpanded = false;
  String fileName = "";
  String getCurrentUserLoggedInImage = "";
  Uint8List? fileBytes;

  void showUserListView({required BuildContext context, required List<UpVotesUsers> userList}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
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
                  UpVotesUsers userModel = userList[index];
                  String profileImageUrl = MyUtils.getSecureUrl(
                    AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(
                      imagePath: userModel.picture ?? "",
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
                    title: Text(userModel.userName ?? ""),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String> openFileExplorer(FileType pickingType, bool multiPick) async {
    String fileName = "";
    List<PlatformFile> paths = await MyUtils.pickFiles(
      pickingType: pickingType,
      multiPick: multiPick,
      getBytes: true,
    );
    try {
      if (paths.isNotEmpty) {
        PlatformFile file = paths.first;
        if (!kIsWeb) {
          MyPrint.printOnConsole("File Path:${file.path}");
        }
        File fileNew = File(file.path!);
        if (fileNew.lengthSync() > 5 * 1024 * 1024) {
          // 5 MB in bytes
          if (context.mounted) {
            MyToast.showError(context: context, msg: "Maximum allowed file size : 5Mb");
          }
          return "";
        }
        // if (fileSizeInMb <= 5) {
        MyPrint.printOnConsole("Got file Name:${file.name}");
        MyPrint.printOnConsole("Got file bytes:${file.bytes?.length}");
        fileName = file.name;
        fileBytes = file.bytes;
      } else {
        fileName = "";
        fileBytes = null;
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in selecting the file: $e");
      MyPrint.printOnConsole(s);
    }
    mySetState();
    return fileName;
  }

  Future<void> initialization() async {
    if (widget.arguments.userQuestionListDto == null) {
      future = getQuestionAnswerDataList();
    } else {
      userQuestion = widget.arguments.userQuestionListDto;
    }

    if (future != null) {
      await future;
    }

    // if (forumModel != null && forumModel!.NoOfTopics != forumModel!.questionsAnswerList.length) {
    await loadAnswersForQuestion(userQuestionListDto: userQuestion!);
    // }
    // getCurrentUserLoggedInData();
  }

  void getCurrentUserLoggedInData() {
    AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();
    getCurrentUserLoggedInImage = authenticationProvider.getEmailLoginResponseModel()?.image ?? "";
    MyPrint.printOnConsole("getCurrentUserLoggedInImage: $getCurrentUserLoggedInImage");
    // mySetState();
  }

  Future<void> getQuestionAnswerDataList() async {
    // if (widget.arguments.ForumId == 0) return;
    DataResponseModel<AskTheExpertDto> dataResponseModel = await askTheExpertController.askTheExpertRepositoryRepository.getQuestionAndAnswerOfUser(
      componentInsId: widget.arguments.componentInsId,
      componentId: widget.arguments.componentId,
      intQuestionId: widget.arguments.questionId,
    );
    if (dataResponseModel.data?.userQuestionListDto.checkNotEmpty ?? false) {
      userQuestion = dataResponseModel.data?.userQuestionListDto.first ?? UserQuestionListDto();
    }
    List<UpVotesUsers> userList = (dataResponseModel.data?.upVotesUsers) ?? [];
    Set<UpVotesUsers> setUser = Set();

    userList.forEach((element) {
      setUser.add(element);
    });
    upVoteUsersList = setUser.toList();

    mySetState();
  }

  Future<void> showMoreActionsForAnswers({
    required QuestionAnswerResponse answerModel,
    InstancyContentActionsEnum? primaryAction,
  }) async {
    LocalStr localStr = appProvider.localStr;

    AnswersUiActionController uiActionController = AnswersUiActionController(appProvider: appProvider);
    List<InstancyUIActionModel> options = uiActionController
        .getSecondaryActions(
          commentModel: answerModel,
          localStr: localStr,
          uiActionCallbackModel: AnswersUIActionCallbackModel(
            onShareWithConnectionTap: () {},
            onShareWithPeopleTap: () {},
            onAddCommentTap: () {
              Navigator.pop(context);

              isCommentTextFormFieldVisible = false;
              isReplyTextFormFieldVisible = true;
              selectedAnswerForComment = null;
              replyFocusNode = FocusNode();
              replyFocusNode.requestFocus();
              mySetState();
            },
            onEditTap: () async {
              Navigator.pop(context);
              dynamic data = await NavigationController.navigateToAddEditAnswerScreen(
                navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
                arguments: AddEditAnswerScreenNavigationArguments(
                  questionId: answerModel.questionID,
                  // userQuestionListDto: userQuestionListDto,
                  questionAnswerResponse: answerModel,
                  isEdit: true,
                ),
              );

              if (data == null) return;

              if (data is bool) {
                if (data) {
                  await initialization();
                }
              }
              // isCommentTextFormFieldVisible = true;
              // isReplyTextFormFieldVisible = false;
              // selectedAnswerForComment = answerModel;
              // // selectedCommentModelForEdit = commentModel;
              // commentTextEditingController.text = answerModel.response;
              // replyTextEditingController.clear();
              // fileName = answerModel.responseImageUploadName;

              mySetState();
            },
            onDeleteTap: () async {
              Navigator.pop(context);

              await askTheExpertController.deleteAnswer(
                context: context,
                questionListDto: userQuestion ?? UserQuestionListDto(),
                answerModel: answerModel,
                mySetState: mySetState,
              );
            },
            onViewLikesTap: () async {
              Navigator.pop(context);
              MyPrint.printOnConsole("onViewLikesTap called");
              isLoading = true;
              mySetState();
              showUserListView(context: context, userList: upVoteUsersList);
              isLoading = false;
              mySetState();
            },
          ),
        )
        .toList();

    if (options.isEmpty) {
      return;
    }

    InstancyUIActions().showAction(
      context: context,
      actions: options,
    );
  }

  //
  // Future<void> showMoreActionsForReply({
  //   required CommentReplyModel replyModel,
  //   required TopicCommentModel commentModel,
  //   InstancyContentActionsEnum? primaryAction,
  // }) async {
  //   LocalStr localStr = appProvider.localStr;
  //
  //   DiscussionReplyUiActionController uiActionController = DiscussionReplyUiActionController(appProvider: appProvider);
  //   List<InstancyUIActionModel> options = uiActionController
  //       .getSecondaryActions(
  //         replyModel: replyModel,
  //         localStr: localStr,
  //         uiActionCallbackModel: DiscussionReplyUIActionCallbackModel(
  //           onAddReplyTap: () {
  //             Navigator.pop(context);
  //
  //             isCommentTextFormFieldVisible = false;
  //             isReplyTextFormFieldVisible = true;
  //             selectedAnswerForComment = null;
  //             selectedCommentModelForReply = commentModel;
  //             replyFocusNode = FocusNode();
  //             replyFocusNode.requestFocus();
  //             mySetState();
  //           },
  //           onEditTap: () {
  //             Navigator.pop(context);
  //
  //             isCommentTextFormFieldVisible = false;
  //             isReplyTextFormFieldVisible = true;
  //             selectedCommentModelForReply = commentModel;
  //             selectedAnswerForComment = null;
  //             selectedReplyModelForEdit = replyModel;
  //             commentTextEditingController.clear();
  //             replyTextEditingController.text = replyModel.message;
  //             mySetState();
  //           },
  //           onDeleteTap: () async {
  //             Navigator.pop(context);
  //
  //             await discussionController.deleteReply(
  //               context: context,
  //               replyModel: replyModel,
  //               commentModel: commentModel,
  //               mySetState: mySetState,
  //             );
  //           },
  //         ),
  //       )
  //       .toList();
  //
  //   if (options.isEmpty) {
  //     return;
  //   }
  //
  //   InstancyUIActions().showAction(
  //     context: context,
  //     actions: options,
  //   );
  // }

  Future<void> loadAnswersForQuestion({
    required UserQuestionListDto userQuestionListDto,
  }) async {
    if (userQuestionListDto.isLoadingTopics) return;

    userQuestionListDto.isLoadingTopics = true;
    mySetState();

    DataResponseModel<AskTheExpertDto> answerList = await askTheExpertController.askTheExpertRepositoryRepository.getQuestionAndAnswerOfUser(
      componentInsId: widget.arguments.componentInsId,
      componentId: widget.arguments.componentId,
      intQuestionId: userQuestionListDto.questionID,
    );
    userQuestionListDto.questionsAnswerList = answerList.data?.questionAnswerResponse ?? [];
    // forumModel.NoOfTopics = forumModel.MainTopicsList.length;
    // forumModel.calculatePinnedTopics();

    userQuestionListDto.isLoadingTopics = false;
    mySetState();
  }

  Future<void> loadCommentsForAnswers({
    required QuestionAnswerResponse topicModel,
  }) async {
    if (topicModel.isLoadingComments) return;

    topicModel.isLoadingComments = true;
    mySetState();

    DataResponseModel<AnswerCommentDTOModel> commentsList = await askTheExpertController.askTheExpertRepositoryRepository.getAnswersComments(intQuestionId: topicModel.questionID);
    List<AnswerCommentsModel> answerCommentList = commentsList.data?.table ?? [];
    if (answerCommentList.checkNotEmpty) {
      topicModel.answersCommentList = answerCommentList.where((element) => element.commentResponseID == topicModel.responseID).toList();
    }
    // topicModel.commentList = commentsList.data ?? [];
    // topicModel.NoOfReplies = topicModel.commentList.length;
    topicModel.isLoadingComments = false;
    mySetState();
  }

  //
  // Future<void> loadRepliesForComment({
  //   required TopicCommentModel topicCommentModel,
  // }) async {
  //   if (topicCommentModel.isLoadingReplies) return;
  //
  //   topicCommentModel.isLoadingReplies = true;
  //   mySetState();
  //
  //   DataResponseModel<RepliesDTOModel> commentsList = await discussionController.discussionRepository.getCommentReplies(commentId: topicCommentModel.commentid);
  //   MyPrint.printOnConsole("commentsList.data: ${commentsList.data?.Table}");
  //
  //   topicCommentModel.repliesList = commentsList.data?.Table ?? [];
  //   topicCommentModel.CommentRepliesCount = topicCommentModel.repliesList.length;
  //
  //   topicCommentModel.isLoadingReplies = false;
  //   mySetState();
  // }

  // Future<void> addTopic({required ForumModel forumModel}) async {
  //   await NavigationController.navigateToCreateEditTopicScreen(
  //     navigationOperationParameters: NavigationOperationParameters(
  //       context: context,
  //       navigationType: NavigationType.pushNamed,
  //     ),
  //     arguments: CreateEditTopicScreenNavigationArguments(
  //       componentId: widget.arguments.componentId,
  //       componentInsId: widget.arguments.componentInsId,
  //       forumModel: forumModel,
  //     ),
  //   );
  //   await loadAnswersForQuestion(forumModel: forumModel);
  // }
  //
  // Future<void> addComment({required TopicModel selectedTopicModel}) async {
  //   String message = commentTextEditingController.text.trim();
  //   if (message.isEmpty) return;
  //
  //   UserProfileDetailsModel? userProfileDetailsModel = context.read<ProfileProvider>().userProfileDetails.getList(isNewInstance: false).firstElement;
  //   MyPrint.printOnConsole("userProfileDetailsModel : $userProfileDetailsModel");
  //   if (userProfileDetailsModel == null) return;
  //
  //   isLoading = true;
  //   mySetState();
  //
  //   PostCommentRequestModel discussionTopicCommentRequestModel = PostCommentRequestModel(
  //     topicID: selectedTopicModel.ContentID,
  //     forumID: forumModel?.ForumID ?? 0,
  //     message: message,
  //     forumTitle: forumModel?.Name ?? "",
  //     topicName: selectedTopicModel.Name,
  //     commentedBy: userProfileDetailsModel.firstname + userProfileDetailsModel.lastname,
  //     strAttachFile: fileName,
  //     fileBytes: fileBytes,
  //     strReplyID: selectedCommentModelForEdit?.ReplyID ?? "",
  //   );
  //
  //   bool isSuccess = await discussionController.addComment(
  //     topicModel: selectedTopicModel,
  //     requestModel: discussionTopicCommentRequestModel,
  //     mySetState: mySetState,
  //   );
  //
  //   isLoading = false;
  //   if (isSuccess) {
  //     fileName = "";
  //     fileBytes = null;
  //     isCommentTextFormFieldVisible = false;
  //     isReplyTextFormFieldVisible = false;
  //     selectedAnswerForComment = null;
  //     selectedCommentModelForReply = null;
  //     commentTextEditingController.clear();
  //     replyTextEditingController.clear();
  //   }
  //   mySetState();
  //
  //   // loadCommentsForTopic(topicModel: selectedTopicModel);
  // }
  //
  // Future<void> addReply({required TopicCommentModel selectedCommentModel}) async {
  //   String message = replyTextEditingController.text.trim();
  //   if (message.isEmpty) return;
  //
  //   UserProfileDetailsModel? userProfileDetailsModel = context.read<ProfileProvider>().userProfileDetails.getList(isNewInstance: false).firstElement;
  //   MyPrint.printOnConsole("userProfileDetailsModel : ${"${ApiController().apiDataProvider.getCurrentBaseApiUrl().replaceAll("/api/", "")}${userProfileDetailsModel!.picture}"}");
  //
  //   isLoading = true;
  //   mySetState();
  //
  //   PostReplyRequestModel discussionTopicCommentRequestModel = PostReplyRequestModel(
  //     topicID: selectedCommentModel.topicid,
  //     forumID: forumModel?.ForumID ?? 0,
  //     message: message,
  //     forumTitle: forumModel?.Name ?? "",
  //     topicName: selectedAnswerForComment?.Name ?? "",
  //     strCommenttxt: selectedCommentModel.message,
  //     strCommentID: selectedCommentModel.commentid,
  //     strReplyID: selectedReplyModelForEdit?.replyID.toString() ?? "",
  //   );
  //   bool isSuccess = await discussionController.addReplyOnComment(requestModel: discussionTopicCommentRequestModel);
  //
  //   isLoading = false;
  //   if (isSuccess) {
  //     isCommentTextFormFieldVisible = false;
  //     isReplyTextFormFieldVisible = false;
  //     selectedAnswerForComment = null;
  //     selectedCommentModelForReply = null;
  //     commentTextEditingController.clear();
  //     replyTextEditingController.clear();
  //   }
  //   mySetState();
  //
  //   loadRepliesForComment(topicCommentModel: selectedCommentModel);
  // }
  //
  // Future<void> likeDislikeTopic({required TopicModel topicModel, ForumModel? forumModel}) async {
  //   bool isSuccess = await discussionController.likeDislikeTopic(
  //     topicModel: topicModel,
  //     forumModel: forumModel,
  //     mySetState: mySetState,
  //   );
  //   MyPrint.printOnConsole("like topic success:$isSuccess");
  // }
  //
  Future<void> likeDislikeComment({required QuestionAnswerResponse commentModel, bool? isLiked}) async {
    bool isSuccess = await askTheExpertController.likeDislikeComment(commentModel: commentModel, mySetState: mySetState, isLiked: isLiked);
    MyPrint.printOnConsole("like comment success:$isSuccess");
  }

  Future<void> DeleteUserResponse({required QuestionAnswerResponse commentModel, bool? isLiked}) async {
    bool isSuccess = await askTheExpertController.DeleteUserResponse(commentModel: commentModel, mySetState: mySetState, isLiked: isLiked);
    MyPrint.printOnConsole("DeleteUserResponse success:$isSuccess");
  }

  //
  // Future<void> likeDislikeReply({required CommentReplyModel replyModel}) async {
  //   bool isSuccess = await discussionController.likeDislikeReply(
  //     replyModel: replyModel,
  //     mySetState: mySetState,
  //   );
  //   MyPrint.printOnConsole("like reply success:$isSuccess");
  // }
  //
  // Future<void> editReply({required TopicCommentModel selectedCommentModel, required String replyId}) async {
  //   UserProfileDetailsModel? userProfileDetailsModel = context.read<ProfileProvider>().userProfileDetails.getList(isNewInstance: false).firstElement;
  //   MyPrint.printOnConsole("userProfileDetailsModel : ${"${ApiController().apiDataProvider.getCurrentBaseApiUrl().replaceAll("/api/", "")}${userProfileDetailsModel!.picture}"}");
  //
  //   isLoading = true;
  //   mySetState();
  //
  //   PostReplyRequestModel discussionTopicCommentRequestModel = PostReplyRequestModel(
  //     topicID: selectedCommentModel.topicid,
  //     forumID: forumModel?.ForumID ?? 0,
  //     strReplyID: replyId,
  //     message: replyTextEditingController.text.trim(),
  //     forumTitle: forumModel?.Name ?? "",
  //     topicName: selectedAnswerForComment?.Name ?? "",
  //     strCommenttxt: selectedCommentModel.message,
  //     strCommentID: selectedCommentModel.commentid,
  //   );
  //   bool isSuccess = await discussionController.addReplyOnComment(requestModel: discussionTopicCommentRequestModel);
  //
  //   isLoading = false;
  //   if (isSuccess) {
  //     isCommentTextFormFieldVisible = false;
  //     replyTextEditingController.clear();
  //   }
  //   mySetState();
  //
  //   loadRepliesForComment(topicCommentModel: selectedCommentModel);
  // }
  //
  // Future<void> editTopic({required ForumModel forumModel, required TopicModel topicModel}) async {
  //   await NavigationController.navigateToCreateEditTopicScreen(
  //     navigationOperationParameters: NavigationOperationParameters(
  //       context: context,
  //       navigationType: NavigationType.pushNamed,
  //     ),
  //     arguments: CreateEditTopicScreenNavigationArguments(
  //         componentId: widget.arguments.componentId, componentInsId: widget.arguments.componentInsId, forumModel: forumModel, isEdit: true, topicModel: topicModel),
  //   );
  //   await loadAnswersForQuestion(forumModel: forumModel);
  // }

  @override
  void initState() {
    super.initState();
    askTheExpertProvider = context.read<AskTheExpertProvider>();
    appProvider = context.read<AppProvider>();
    askTheExpertController = AskTheExpertController(discussionProvider: askTheExpertProvider);
    // uiActionController = DiscussionTopicUiActionController(appProvider: appProvider);
    initialization();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    themeData = Theme.of(context);
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: appBar(),
        body: AppUIComponents.getBackGroundBordersRounded(
          context: context,
          child: future != null
              ? FutureBuilder(
                  future: future,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const CommonLoader();
                    }

                    return mainWidget();
                  },
                )
              : mainWidget(),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(
            context,
          );
        },
        icon: const Icon(Icons.arrow_back),
      ),
      title: const Text(
        "View Answers",
      ),
    );
  }

  Widget mainWidget() {
    if (userQuestion == null) return Center(child: AppConfigurations.commonNoDataView());

    return Column(
      children: [
        getQuestionCardWidget(userQuestionListDto: userQuestion ?? UserQuestionListDto()),
        Expanded(
          child: getAnswerListWidget(),
        ),
        if (selectedAnswerForComment != null)
          commentTextFormField(
            selectedTopicModel: selectedAnswerForComment!,
          ),
        // if (selectedCommentModelForReply != null)
        //   replyTextFormField(
        //     selectedCommentModel: selectedCommentModelForReply,
        //   ),
      ],
    );
  }

  Widget getQuestionCardWidget({required UserQuestionListDto userQuestionListDto}) {
    return QuestionAnswerCard(
      isDetailScreen: true,
      userQuestionListDto: userQuestionListDto,
      onCardTap: () {},
      onAnswerButtonTap: () async {
        dynamic data = await NavigationController.navigateToAddEditAnswerScreen(
          navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
          arguments: AddEditAnswerScreenNavigationArguments(
            questionId: userQuestionListDto.questionID,
            userQuestionListDto: userQuestionListDto,
            isEdit: false,
          ),
        );

        if (data == null) return;

        if (data is bool) {
          if (data) {
            await initialization();
          }
        }
        // UserQuestionListDto userQuestionListDto = data.userQuestionListDto.first;
        // // future = getQuestionAnswerDataList();
        // userQuestion = userQuestionListDto;
        // mySetState();
        // // if (userQuestion != null) {
        // //   await loadAnswersForQuestion(userQuestionListDto: userQuestion!);
        // // }
        // }
      },
      answerListCount: (userQuestion?.questionsAnswerList ?? []).length,
    );
  }

  Widget getAnswerListWidget() {
    if (userQuestion?.isLoadingTopics ?? false) {
      return const CommonLoader(
        isCenter: true,
      );
    }

    List<QuestionAnswerResponse> list = userQuestion?.questionsAnswerList ?? [];
    if (list.checkEmpty) {
      return Center(
        child: AppConfigurations.commonNoDataView(),
      );
    }

    TextStyle? popupTextStyle = themeData.textTheme.labelMedium?.copyWith(
      fontWeight: FontWeight.w600,
    );

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
          child: Column(
            children: [
              ...List.generate(
                list.length,
                (index) {
                  QuestionAnswerResponse topicModel = list[index];

                  return getAnswerCardWidget(topicModel: topicModel);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getAnswerCardWidget({required QuestionAnswerResponse topicModel}) {
    return Container(
      padding: const EdgeInsets.only(bottom: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          profileRowWidget(answerModel: topicModel),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              if (topicModel.responseImageUploadName.checkNotEmpty)
                Container(
                  child: thumbNailWidget(
                    topicModel.responseImageUploadName,
                    uploadedImageName: topicModel.responseImageUploadName,
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 13.0),
                      child: Html(
                        data: topicModel.response,
                        style: {
                          "body": Style(
                            color: themeData.colorScheme.onBackground.withOpacity(0.65),
                            fontWeight: FontWeight.w400,
                            // fontFamily: "Roboto",
                            fontSize: FontSize(themeData.textTheme.labelMedium?.fontSize ?? 14),
                          ),
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              iconTextButton(
                onTap: () {
                  if (topicModel.isLiked == null || topicModel.isLiked == false) {
                    likeDislikeComment(commentModel: topicModel, isLiked: true);
                  } else {
                    DeleteUserResponse(commentModel: topicModel);
                  }

                  // likeDislikeTopic(topicModel: topicModel, forumModel: forumModel);
                },
                isVisible: true,
                iconData: (topicModel.isLiked ?? false) ? Icons.thumb_up_alt_rounded : Icons.thumb_up_alt_outlined,
                text: topicModel.upvotesCount.toString(),
              ),
              iconTextButton(
                onTap: () {
                  if (topicModel.isLiked == null || topicModel.isLiked == true) {
                    likeDislikeComment(commentModel: topicModel, isLiked: false);
                  } else {
                    DeleteUserResponse(commentModel: topicModel);
                  }
                  // likeDislikeComment(commentModel: topicModel);
                  // likeDislikeTopic(topicModel: topicModel, forumModel: forumModel);
                },
                isVisible: true,
                iconData: Icons.thumb_down_rounded,
                text: "",
              ),
              iconTextButton(
                onTap: () {
                  isCommentTextFormFieldVisible = true;
                  // isReplyTextFormFieldVisible = false;
                  selectedAnswerForComment = topicModel;
                  // selectedCommentModelForReply = null;
                  commentFocusNode = FocusNode();
                  commentFocusNode.requestFocus();

                  mySetState();
                },
                isVisible: true,
                iconData: FontAwesomeIcons.comment,
                text: topicModel.commentCount.toString(),
              ),
            ],
          ),
          if (topicModel.commentCount != 0)
            InkWell(
              onTap: () async {
                if (topicModel.answersCommentList.checkEmpty) {
                  await loadCommentsForAnswers(topicModel: topicModel);
                } else {
                  topicModel.answersCommentList.clear();
                  mySetState();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Container(
                      height: .8,
                      width: 50,
                      color: Styles.lightGreyTextColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "View ${topicModel.commentCount} Comments",
                      style: const TextStyle(color: Styles.lightGreyTextColor, fontSize: 10, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          getCommentList(topicModel: topicModel)
        ],
      ),
    );
  }

  Widget thumbNailWidget(String url, {double height = 45, double width = 45, String uploadedImageName = ""}) {
    url = MyUtils.getSecureUrl(AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(imagePath: url));
    // MyPrint.printOnConsole('thumbnailImageUrl:$url');
    if (url.checkEmpty || uploadedImageName.checkEmpty) return const SizedBox();
    String extension = uploadedImageName.split(".").last;
    MyPrint.printOnConsole("extension: ${extension}: Url ${url}");

    if (["jpeg", "png", "jpg"].contains(extension)) {
      return InkWell(
        onTap: () {
          NavigationController.navigateToCommonViewImageScreen(
            navigationOperationParameters: NavigationOperationParameters(
              context: context,
              navigationType: NavigationType.pushNamed,
            ),
            arguments: CommonViewImageScreenNavigationArguments(
              imageUrl: url,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: CommonCachedNetworkImage(
            imageUrl: url,
            height: height,
            width: width,
            fit: BoxFit.cover,
            placeholder: (_, __) {
              return const SizedBox();
            },
            errorWidget: (_, __, ___) {
              return const Icon(
                Icons.image,
                color: Colors.grey,
              );
            },
          ),
        ),
      );
    } else if (extension == "mp3") {
      return InkWell(
        onTap: () {
          MyUtils.launchUrl(url: url);
        },
        child: const Padding(
          padding: EdgeInsets.only(right: 15.0),
          child: Icon(FontAwesomeIcons.fileAudio, size: 30),
        ),
      );
    } else if (["doc", "pdf", "xlsx"].contains(extension)) {
      return InkWell(
        onTap: () {
          MyUtils.launchUrl(url: url);
        },
        child: const Padding(
          padding: EdgeInsets.only(right: 15.0),
          child: Icon(FontAwesomeIcons.fileLines, size: 30),
        ),
      );
    } else if (["mp4", "avi", "mov"].contains(extension)) {
      return InkWell(
        onTap: () {
          MyUtils.launchUrl(url: url);
        },
        child: const Padding(
          padding: EdgeInsets.only(right: 15.0),
          child: Icon(FontAwesomeIcons.fileVideo, size: 30),
        ),
      );
    } else {
      return const Padding(
        padding: EdgeInsets.only(right: 15.0),
        child: Icon(FontAwesomeIcons.file, size: 30),
      );
    }
    //for video thumbnail
    /*return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CommonCachedNetworkImage(
            imageUrl: url,
            height: 75,
            width: 75,
            fit: BoxFit.cover,

          ),
          Center(
            child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(Icons.play_arrow,size: 15,)),
          )
        ],
      ),
    );*/
  }

  Widget profileRowWidget({
    required QuestionAnswerResponse answerModel,
  }) {
    String topicThumbnailUrl = MyUtils.getSecureUrl(
      AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(
        imagePath: answerModel.picture,
      ),
    );
    // MyPrint.printOnConsole('topicThumbnailUrl:topicThumbnailUrl');

    return Row(
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), border: Border.all(color: Colors.black)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CommonCachedNetworkImage(
              imageUrl: topicThumbnailUrl,
              // imageUrl: imageUrl,
              height: 30,
              width: 30,
              fit: BoxFit.cover,
              errorIconSize: 30,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      answerModel.respondedUserName,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      "answered ${answerModel.days}",
                      style: const TextStyle(color: Color(0xff858585), fontSize: 10),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  showMoreActionsForAnswers(answerModel: answerModel);
                },
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.more_vert_outlined,
                    size: 18,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  //region Comment Section
  Widget getCommentList({required QuestionAnswerResponse topicModel}) {
    if (topicModel.isLoadingComments) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: CommonLoader(
          size: 40,
        ),
      );
    }

    if (topicModel.answersCommentList.checkEmpty) return const SizedBox();

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 40, top: 10),
      itemCount: topicModel.answersCommentList.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return getCommentCardWidget(commentModel: topicModel.answersCommentList[index], topicModel: topicModel);
      },
    );
  }

  Widget getCommentCardWidget({required AnswerCommentsModel commentModel, required QuestionAnswerResponse topicModel}) {
    String commentThumbnailUrl = MyUtils.getSecureUrl(
      AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(
        imagePath: commentModel.picture,
      ),
    );
    // MyPrint.printOnConsole('commentThumbnailUrl:commentThumbnailUrl');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // getCommentProfileWidget(commentModel),
          getCommonProfileWidget(
            days: commentModel.commentedDate,
            authorName: commentModel.commentedUserName,
            onMoreTap: () {
              showMoreActionsForAnswers(
                answerModel: topicModel,
                // topicModel: topicModel,
              );
            },
            profileUrl: commentThumbnailUrl,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Html(
                  data: commentModel.commentDescription,
                  style: {
                    "body": Style(
                      margin: Margins.all(0),
                      padding: HtmlPaddings.zero,
                    ),
                    "p": Style(padding: HtmlPaddings.zero, margin: Margins.zero),
                  },
                ),
                if (commentModel.commentUploadIconPath.checkNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: thumbNailWidget(commentModel.commentUploadIconPath, uploadedImageName: commentModel.commentImageUploadName),
                  ),
              ],
            ),
          ),
          Row(
            children: [
              iconTextButton(
                iconData: commentModel.isLiked ? Icons.thumb_up_alt_rounded : Icons.thumb_up_alt_outlined,
                // text: "10",
                text: "",
                onTap: () {
                  // likeDislikeComment(commentModel: commentModel);
                },
              ),
            ],
          ),
          // if (commentModel.CommentRepliesCount != 0)
          //   InkWell(
          //     onTap: () async {
          //       if (commentModel.repliesList.checkEmpty) {
          //         await loadRepliesForComment(topicCommentModel: commentModel);
          //       } else {
          //         commentModel.repliesList.clear();
          //         mySetState();
          //       }
          //     },
          //     child: Container(
          //       padding: const EdgeInsets.symmetric(vertical: 5),
          //       child: Row(
          //         children: [
          //           Container(
          //             height: .8,
          //             width: 50,
          //             color: Styles.lightGreyTextColor,
          //           ),
          //           const SizedBox(width: 5),
          //           Text(
          //             "View ${commentModel.CommentRepliesCount} Replies",
          //             style: const TextStyle(color: Styles.lightGreyTextColor, fontSize: 10, fontWeight: FontWeight.w600),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // getReplyList(topicCommentModel: commentModel),
        ],
      ),
    );
  }

  //endregion

  // //region Reply Section
  // Widget getReplyList({required TopicCommentModel topicCommentModel}) {
  //   if (topicCommentModel.isLoadingReplies) {
  //     return const Padding(
  //       padding: EdgeInsets.all(20.0),
  //       child: CommonLoader(
  //         size: 40,
  //       ),
  //     );
  //   }
  //   if (topicCommentModel.repliesList.checkEmpty) return const SizedBox();
  //   return ListView.builder(
  //     physics: const NeverScrollableScrollPhysics(),
  //     padding: const EdgeInsets.only(left: 40, top: 10),
  //     itemCount: topicCommentModel.repliesList.length,
  //     shrinkWrap: true,
  //     itemBuilder: (BuildContext context, int index) {
  //       return getReplyItem(replyModel: topicCommentModel.repliesList[index], commentModel: topicCommentModel);
  //     },
  //   );
  // }
  //
  // Widget getReplyItem({required CommentReplyModel replyModel, required TopicCommentModel commentModel}) {
  //   String replyThumbnailUrl = MyUtils.getSecureUrl(
  //     AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(
  //       imagePath: replyModel.replyProfile,
  //     ),
  //   );
  //   // MyPrint.printOnConsole('replyThumbnailUrl:replyThumbnailUrl');
  //
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 10.0),
  //     child: Column(
  //       children: [
  //         // getCommentProfileWidget(commentModel),
  //         getCommonProfileWidget(
  //           days: replyModel.dtPostedDate,
  //           authorName: replyModel.replyBy,
  //           onMoreTap: () {
  //             showMoreActionsForReply(
  //               replyModel: replyModel,
  //               commentModel: commentModel,
  //             );
  //           },
  //           profileUrl: replyThumbnailUrl,
  //         ),
  //         Html(
  //           data: replyModel.message,
  //           style: {
  //             "body": Style(
  //               color: themeData.textTheme.bodyMedium?.color,
  //               fontWeight: FontWeight.w400,
  //               fontSize: FontSize(themeData.textTheme.bodyMedium?.fontSize ?? 16),
  //             ),
  //             "p": Style(padding: HtmlPaddings.zero, margin: Margins.zero),
  //           },
  //         ),
  //         Row(
  //           children: [
  //             iconTextButton(
  //               onTap: () {
  //                 likeDislikeReply(replyModel: replyModel);
  //               },
  //               iconData: replyModel.likeState ? Icons.thumb_up_alt_rounded : Icons.thumb_up_alt_outlined,
  //               text: "",
  //             ),
  //             iconTextButton(
  //               iconData: Icons.turn_left_outlined,
  //               iconSize: 22,
  //               text: "Reply",
  //               onTap: () async {
  //                 isCommentTextFormFieldVisible = false;
  //                 isReplyTextFormFieldVisible = true;
  //                 selectedAnswerForComment = null;
  //                 selectedCommentModelForReply = commentModel;
  //                 replyFocusNode = FocusNode();
  //                 replyFocusNode.requestFocus();
  //                 mySetState();
  //               },
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // //endregion

  Widget getCommonProfileWidget({String profileUrl = "", String authorName = "", String days = "", Function()? onMoreTap}) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), border: Border.all(color: Colors.black)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CommonCachedNetworkImage(
              imageUrl: profileUrl,
              // imageUrl: imageUrl,
              height: 30,
              width: 30,
              fit: BoxFit.cover,
              errorIconSize: 30,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authorName,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      days,
                      style: const TextStyle(color: Color(0xff858585), fontSize: 10),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: onMoreTap,
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.more_vert_outlined,
                    size: 18,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  final formKey = GlobalKey<FormState>();

  Widget commentTextFormField({
    required QuestionAnswerResponse? selectedTopicModel,
  }) {
    if (!isCommentTextFormFieldVisible || selectedTopicModel == null) return const SizedBox();
    String url = MyUtils.getSecureUrl(AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(imagePath: getCurrentUserLoggedInImage));

    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            CommonTextFormField(
              node: commentFocusNode,
              controller: commentTextEditingController,
              borderColor: Colors.black54,
              hintText: "Add Comment",
              // validator: (String? val){
              //   if(val == null || val.checkEmpty){
              //     return "Please add a comment";
              //   }
              //   return null;
              // },
              contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              fillColor: Colors.grey,
              prefixWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CommonCachedNetworkImage(
                      imageUrl: url,
                      height: 30,
                      width: 30,
                      fit: BoxFit.cover,
                      errorIconSize: 20,
                    ),
                  ),
                ],
              ),
              suffixWidget: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () async {
                      fileName = await openFileExplorer(FileType.any, false);
                      mySetState();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        Icons.attach_file,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 0),
                  InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      if (commentTextEditingController.text.trim().checkEmpty) {
                        MyToast.showError(context: context, msg: "Please add comment");
                        commentTextEditingController.clear();
                        return;
                      }
                      // addComment(selectedTopicModel: selectedTopicModel);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Post",
                        style: themeData.textTheme.titleSmall!.copyWith(color: themeData.primaryColor),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      isCommentTextFormFieldVisible = false;
                      isReplyTextFormFieldVisible = false;
                      commentTextEditingController.clear();
                      replyTextEditingController.clear();
                      selectedAnswerForComment = null;
                      mySetState();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Icon(Icons.clear),
                    ),
                  ),
                ],
              ),
            ),
            if (fileName.checkNotEmpty)
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        fileName,
                        style: themeData.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      fileName = "";
                      fileBytes = null;
                      mySetState();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.clear,
                        size: 18,
                      ),
                    ),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }

  Widget iconTextButton({required IconData iconData, String text = " ", Function()? onTap, double iconSize = 18, bool isVisible = true}) {
    if (!isVisible) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Icon(iconData, color: Styles.iconColor, size: iconSize),
            ),
            Text(
              text,
              style: themeData.textTheme.bodySmall,
            )
          ],
        ),
      ),
    );
  }
}
