import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/my_print.dart';
import 'package:flutter_chat_bot/utils/my_safe_state.dart';
import 'package:flutter_chat_bot/view/common/components/common_cached_network_image.dart';
import 'package:flutter_chat_bot/view/common/components/common_loader.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/discussion/discussion_controller.dart';
import 'package:flutter_instancy_2/backend/discussion/discussion_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/backend/profile/profile_provider.dart';
import 'package:flutter_instancy_2/backend/ui_actions/discussion_forum/comment/discussion_comment_ui_action_callback_model.dart';
import 'package:flutter_instancy_2/backend/ui_actions/discussion_forum/comment/discussion_comment_ui_action_controller.dart';
import 'package:flutter_instancy_2/backend/ui_actions/discussion_forum/reply/discussion_reply_ui_action_callback_model.dart';
import 'package:flutter_instancy_2/backend/ui_actions/discussion_forum/reply/discussion_reply_ui_action_controller.dart';
import 'package:flutter_instancy_2/models/discussion/data_model/comment_reply_model.dart';
import 'package:flutter_instancy_2/models/discussion/data_model/forum_model.dart';
import 'package:flutter_instancy_2/models/discussion/data_model/topic_comment_model.dart';
import 'package:flutter_instancy_2/models/discussion/data_model/topic_model.dart';
import 'package:flutter_instancy_2/models/discussion/request_model/post_comment_request_model.dart';
import 'package:flutter_instancy_2/models/discussion/request_model/post_reply_request_model.dart';
import 'package:flutter_instancy_2/models/profile/data_model/user_profile_details_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/views/common/components/common_text_form_field.dart';
import 'package:flutter_instancy_2/views/common/components/modal_progress_hud.dart';
import 'package:flutter_instancy_2/views/discussion_forum/component/dicussionCard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../api/api_controller.dart';
import '../../../backend/app_theme/style.dart';
import '../../../backend/configurations/app_configuration_operations.dart';
import '../../../backend/share/share_provider.dart';
import '../../../backend/ui_actions/discussion_forum/topic/discussion_topic_ui_action_callback_model.dart';
import '../../../backend/ui_actions/discussion_forum/topic/discussion_topic_ui_action_controller.dart';
import '../../../backend/ui_actions/primary_secondary_actions/primary_secondary_actions_constants.dart';
import '../../../configs/app_configurations.dart';
import '../../../configs/app_constants.dart';
import '../../../models/app_configuration_models/data_models/local_str.dart';
import '../../../models/common/data_response_model.dart';
import '../../../models/discussion/response_model/discussion_topic_dto_response_model.dart';
import '../../../models/discussion/response_model/replies_dto_model.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/instancy_ui_actions/instancy_ui_actions.dart';

class DiscussionDetailScreen extends StatefulWidget {
  final DiscussionDetailScreenNavigationArguments arguments;
  static const String routeName = "/discussionForum";

  const DiscussionDetailScreen({super.key, required this.arguments});

  @override
  State<DiscussionDetailScreen> createState() => _DiscussionDetailScreenState();
}

class _DiscussionDetailScreenState extends State<DiscussionDetailScreen> with MySafeState {
  late ThemeData themeData;
  Future? future;
  bool isLoading = false;
  FocusNode commentFocusNode = FocusNode(), replyFocusNode = FocusNode();
  late DiscussionController discussionController;
  late DiscussionProvider discussionProvider;
  late AppProvider appProvider;
  TopicModel? selectedTopicForComment;
  TopicCommentModel? selectedCommentModelForReply, selectedCommentModelForEdit;
  CommentReplyModel? selectedReplyModelForEdit;
  bool isCommentTextFormFieldVisible = false, isReplyTextFormFieldVisible = false;

  bool isLikeEnabled = false;
  bool isShowInAscendingOrder = false;

  late DiscussionTopicUiActionController uiActionController;

  TextEditingController commentTextEditingController = TextEditingController(), replyTextEditingController = TextEditingController();

  ForumModel? forumModel;

  FileType? fileType;

  bool isExpanded = false;
  String fileName = "";
  Uint8List? fileBytes;

  Future<String> openFileExplorer(FileType pickingType, bool multiPick) async {
    String fileName = "";
    List<PlatformFile> paths = await MyUtils.pickFiles(
      pickingType: pickingType,
      multiPick: multiPick,
      getBytes: true,
    );

    if (paths.isNotEmpty) {
      PlatformFile file = paths.first;
      if (!kIsWeb) {
        MyPrint.printOnConsole("File Path:${file.path}");
      }
      fileName = file.name;
      // fileName = file.name.replaceAll('(', ' ').replaceAll(')', '');
      // fileName = fileName.trim();
      // fileName = Uuid().v1() + fileName.substring(fileName.indexOf("."));

      MyPrint.printOnConsole("Got file Name:${file.name}");
      MyPrint.printOnConsole("Got file bytes:${file.bytes?.length}");
      fileBytes = file.bytes;
    } else {
      fileName = "";
      fileBytes = null;
    }
    mySetState();
    return fileName;
  }

  Future<void> initialization() async {
    if (widget.arguments.forumModel == null) {
      future = getForumDataList();
    } else {
      forumModel = widget.arguments.forumModel;
    }

    if (future != null) {
      await future;
    }

    if (forumModel != null && forumModel!.NoOfTopics != forumModel!.MainTopicsList.length) {
      await loadTopicForForum(forumModel: forumModel!);
    }
  }

  Future<void> getForumDataList() async {
    if (widget.arguments.ForumId == 0) return;
    DataResponseModel<ForumModel> dataResponseModel = await discussionController.discussionRepository.getSingleForumDetails(forumId: widget.arguments.ForumId);
    forumModel = dataResponseModel.data;

    mySetState();
  }

  DiscussionTopicUIActionCallbackModel getDiscussionTopicUIActionCallbackModel({
    required TopicModel model,
    InstancyContentActionsEnum? primaryAction,
    bool isSecondaryAction = true,
  }) {
    return DiscussionTopicUIActionCallbackModel(
      onAddCommentTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        isCommentTextFormFieldVisible = true;
        isReplyTextFormFieldVisible = false;
        selectedTopicForComment = model;
        selectedCommentModelForReply = null;
        commentFocusNode = FocusNode();
        commentFocusNode.requestFocus();

        mySetState();
      },
      onEditTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        editTopic(forumModel: forumModel ?? ForumModel(), topicModel: model);
      },
      onDeleteTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        if (forumModel != null) {
          await discussionController.deleteTopic(
            context: context,
            forumModel: forumModel!,
            topicModel: model,
            mySetState: mySetState,
          );
        }
      },
      onPinTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        if (forumModel != null) {
          discussionController.pinUnpinTopic(
            forumModel: forumModel!,
            topicModel: model,
            mySetState: mySetState,
          );
        }
      },
      onUnPinTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        if (forumModel != null) {
          discussionController.pinUnpinTopic(
            forumModel: forumModel!,
            topicModel: model,
            mySetState: mySetState,
          );
        }
      },
      onViewLikesTap: () async {
        Navigator.pop(context);

        isLoading = true;
        mySetState();

        await discussionController.showTopicLikedUserList(
          context: context,
          topicModel: model,
        );

        isLoading = false;
        mySetState();
      },
      onShareWithConnectionTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        NavigationController.navigateToShareWithConnectionsScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: ShareWithConnectionsScreenNavigationArguments(
            shareContentType: ShareContentType.discussionTopic,
            contentId: model.ContentID,
            contentName: model.Name,
            topicId: model.ContentID,
            forumId: forumModel?.ForumID ?? 0,
            shareProvider: context.read<ShareProvider>(),
          ),
        );
      },
      onShareWithPeopleTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        NavigationController.navigateToShareWithPeopleScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: ShareWithPeopleScreenNavigationArguments(
            shareContentType: ShareContentType.discussionTopic,
            contentId: model.ContentID,
            contentName: model.Name,
            topicId: model.ContentID,
            forumId: forumModel?.ForumID ?? 0,
          ),
        );
      },
    );
  }

  Future<void> showMoreActionsForTopic({
    required TopicModel model,
    InstancyContentActionsEnum? primaryAction,
  }) async {
    LocalStr localStr = appProvider.localStr;

    if (forumModel == null) return;

    List<InstancyUIActionModel> options = uiActionController
        .getDiscussionTopicScreenSecondaryActions(
          forumModel: forumModel!,
          topicModel: model,
          localStr: localStr,
          uiActionCallbackModel: getDiscussionTopicUIActionCallbackModel(
            model: model,
            primaryAction: primaryAction,
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

  Future<void> showMoreActionsForComment({
    required TopicCommentModel commentModel,
    required TopicModel topicModel,
    InstancyContentActionsEnum? primaryAction,
  }) async {
    LocalStr localStr = appProvider.localStr;

    DiscussionCommentUiActionController uiActionController = DiscussionCommentUiActionController(appProvider: appProvider);
    List<InstancyUIActionModel> options = uiActionController
        .getSecondaryActions(
          commentModel: commentModel,
          localStr: localStr,
          uiActionCallbackModel: DiscussionCommentUIActionCallbackModel(
            onAddReplyTap: () {
              Navigator.pop(context);

              isCommentTextFormFieldVisible = false;
              isReplyTextFormFieldVisible = true;
              selectedTopicForComment = null;
              selectedCommentModelForReply = commentModel;
              replyFocusNode = FocusNode();
              replyFocusNode.requestFocus();
              mySetState();
            },
            onEditTap: () {
              Navigator.pop(context);

              isCommentTextFormFieldVisible = true;
              isReplyTextFormFieldVisible = false;
              selectedCommentModelForReply = null;
              selectedTopicForComment = topicModel;
              selectedCommentModelForEdit = commentModel;
              commentTextEditingController.text = commentModel.message;
              replyTextEditingController.clear();
              fileName = commentModel.CommentFileUploadName;
              mySetState();
            },
            onDeleteTap: () async {
              Navigator.pop(context);

              await discussionController.deleteComment(
                context: context,
                commentModel: commentModel,
                topicModel: topicModel,
                mySetState: mySetState,
              );
            },
            onViewLikesTap: () async {
              Navigator.pop(context);

              isLoading = true;
              mySetState();

              await discussionController.showCommentLikedUserList(
                context: context,
                topicCommentModel: commentModel,
              );

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

  Future<void> showMoreActionsForReply({
    required CommentReplyModel replyModel,
    required TopicCommentModel commentModel,
    InstancyContentActionsEnum? primaryAction,
  }) async {
    LocalStr localStr = appProvider.localStr;

    DiscussionReplyUiActionController uiActionController = DiscussionReplyUiActionController(appProvider: appProvider);
    List<InstancyUIActionModel> options = uiActionController
        .getSecondaryActions(
          replyModel: replyModel,
          localStr: localStr,
          uiActionCallbackModel: DiscussionReplyUIActionCallbackModel(
            onAddReplyTap: () {
              Navigator.pop(context);

              isCommentTextFormFieldVisible = false;
              isReplyTextFormFieldVisible = true;
              selectedTopicForComment = null;
              selectedCommentModelForReply = commentModel;
              replyFocusNode = FocusNode();
              replyFocusNode.requestFocus();
              mySetState();
            },
            onEditTap: () {
              Navigator.pop(context);

              isCommentTextFormFieldVisible = false;
              isReplyTextFormFieldVisible = true;
              selectedCommentModelForReply = commentModel;
              selectedTopicForComment = null;
              selectedReplyModelForEdit = replyModel;
              commentTextEditingController.clear();
              replyTextEditingController.text = replyModel.message;
              mySetState();
            },
            onDeleteTap: () async {
              Navigator.pop(context);

              await discussionController.deleteReply(
                context: context,
                replyModel: replyModel,
                commentModel: commentModel,
                mySetState: mySetState,
              );
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

  Future<void> loadTopicForForum({
    required ForumModel forumModel,
  }) async {
    if (forumModel.isLoadingTopics) return;

    forumModel.isLoadingTopics = true;
    mySetState();

    DataResponseModel<DiscussionTopicDTOResponseModel> topicsList = await discussionController.discussionRepository.getForumTopic(
      forumId: forumModel.ForumID,
    );
    forumModel.MainTopicsList = topicsList.data?.topicList ?? [];
    forumModel.NoOfTopics = forumModel.MainTopicsList.length;
    forumModel.calculatePinnedTopics();

    forumModel.isLoadingTopics = false;
    mySetState();
  }

  Future<void> loadCommentsForTopic({
    required TopicModel topicModel,
  }) async {
    if (topicModel.isLoadingComments) return;

    topicModel.isLoadingComments = true;
    mySetState();

    DataResponseModel<List<TopicCommentModel>> commentsList = await discussionController.discussionRepository.getTopicComments(
      topicId: topicModel.ContentID,
      forumId: forumModel?.ForumID ?? 0,
    );

    topicModel.commentList = commentsList.data ?? [];
    topicModel.NoOfReplies = topicModel.commentList.length;
    topicModel.isLoadingComments = false;
    mySetState();
  }

  Future<void> loadRepliesForComment({
    required TopicCommentModel topicCommentModel,
  }) async {
    if (topicCommentModel.isLoadingReplies) return;

    topicCommentModel.isLoadingReplies = true;
    mySetState();

    DataResponseModel<RepliesDTOModel> commentsList = await discussionController.discussionRepository.getCommentReplies(commentId: topicCommentModel.commentid);
    MyPrint.printOnConsole("commentsList.data: ${commentsList.data?.Table}");

    topicCommentModel.repliesList = commentsList.data?.Table ?? [];
    topicCommentModel.CommentRepliesCount = topicCommentModel.repliesList.length;

    topicCommentModel.isLoadingReplies = false;
    mySetState();
  }

  Future<void> addTopic({required ForumModel forumModel}) async {
    await NavigationController.navigateToCreateEditTopicScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      arguments: CreateEditTopicScreenNavigationArguments(
        componentId: widget.arguments.componentId,
        componentInsId: widget.arguments.componentInsId,
        forumModel: forumModel,
      ),
    );
    await loadTopicForForum(forumModel: forumModel);
  }

  Future<void> addComment({required TopicModel selectedTopicModel}) async {
    String message = commentTextEditingController.text.trim();
    if (message.isEmpty) return;

    UserProfileDetailsModel? userProfileDetailsModel = context.read<ProfileProvider>().userProfileDetails.getList(isNewInstance: false).firstElement;
    MyPrint.printOnConsole("userProfileDetailsModel : $userProfileDetailsModel");
    if (userProfileDetailsModel == null) return;

    isLoading = true;
    mySetState();

    PostCommentRequestModel discussionTopicCommentRequestModel = PostCommentRequestModel(
      topicID: selectedTopicModel.ContentID,
      forumID: forumModel?.ForumID ?? 0,
      message: message,
      forumTitle: forumModel?.Name ?? "",
      topicName: selectedTopicModel.Name,
      commentedBy: userProfileDetailsModel.firstname + userProfileDetailsModel.lastname,
      strAttachFile: fileName,
      fileBytes: fileBytes,
      strReplyID: selectedCommentModelForEdit?.ReplyID ?? "",
    );

    bool isSuccess = await discussionController.addComment(
      topicModel: selectedTopicModel,
      requestModel: discussionTopicCommentRequestModel,
      mySetState: mySetState,
    );

    isLoading = false;
    if (isSuccess) {
      isCommentTextFormFieldVisible = false;
      isReplyTextFormFieldVisible = false;
      selectedTopicForComment = null;
      selectedCommentModelForReply = null;
      commentTextEditingController.clear();
      replyTextEditingController.clear();
    }
    mySetState();

    loadCommentsForTopic(topicModel: selectedTopicModel);
  }

  Future<void> addReply({required TopicCommentModel selectedCommentModel}) async {
    String message = replyTextEditingController.text.trim();
    if (message.isEmpty) return;

    UserProfileDetailsModel? userProfileDetailsModel = context.read<ProfileProvider>().userProfileDetails.getList(isNewInstance: false).firstElement;
    MyPrint.printOnConsole("userProfileDetailsModel : ${"${ApiController().apiDataProvider.getCurrentBaseApiUrl().replaceAll("/api/", "")}${userProfileDetailsModel!.picture}"}");

    isLoading = true;
    mySetState();

    PostReplyRequestModel discussionTopicCommentRequestModel = PostReplyRequestModel(
      topicID: selectedCommentModel.topicid,
      forumID: forumModel?.ForumID ?? 0,
      message: message,
      forumTitle: forumModel?.Name ?? "",
      topicName: selectedTopicForComment?.Name ?? "",
      strCommenttxt: selectedCommentModel.message,
      strCommentID: selectedCommentModel.commentid,
      strReplyID: selectedReplyModelForEdit?.replyID.toString() ?? "",
    );
    bool isSuccess = await discussionController.addReplyOnComment(requestModel: discussionTopicCommentRequestModel);

    isLoading = false;
    if (isSuccess) {
      isCommentTextFormFieldVisible = false;
      isReplyTextFormFieldVisible = false;
      selectedTopicForComment = null;
      selectedCommentModelForReply = null;
      commentTextEditingController.clear();
      replyTextEditingController.clear();
    }
    mySetState();

    loadRepliesForComment(topicCommentModel: selectedCommentModel);
  }

  Future<void> likeDislikeTopic({required TopicModel topicModel, ForumModel? forumModel}) async {
    bool isSuccess = await discussionController.likeDislikeTopic(
      topicModel: topicModel,
      forumModel: forumModel,
      mySetState: mySetState,
    );
    MyPrint.printOnConsole("like topic success:$isSuccess");
  }

  Future<void> likeDislikeComment({required TopicCommentModel commentModel}) async {
    bool isSuccess = await discussionController.likeDislikeComment(
      commentModel: commentModel,
      mySetState: mySetState,
    );
    MyPrint.printOnConsole("like comment success:$isSuccess");
  }

  Future<void> likeDislikeReply({required CommentReplyModel replyModel}) async {
    bool isSuccess = await discussionController.likeDislikeReply(
      replyModel: replyModel,
      mySetState: mySetState,
    );
    MyPrint.printOnConsole("like reply success:$isSuccess");
  }

  Future<void> editReply({required TopicCommentModel selectedCommentModel, required String replyId}) async {
    UserProfileDetailsModel? userProfileDetailsModel = context.read<ProfileProvider>().userProfileDetails.getList(isNewInstance: false).firstElement;
    MyPrint.printOnConsole("userProfileDetailsModel : ${"${ApiController().apiDataProvider.getCurrentBaseApiUrl().replaceAll("/api/", "")}${userProfileDetailsModel!.picture}"}");

    isLoading = true;
    mySetState();

    PostReplyRequestModel discussionTopicCommentRequestModel = PostReplyRequestModel(
      topicID: selectedCommentModel.topicid,
      forumID: forumModel?.ForumID ?? 0,
      strReplyID: replyId,
      message: replyTextEditingController.text.trim(),
      forumTitle: forumModel?.Name ?? "",
      topicName: selectedTopicForComment?.Name ?? "",
      strCommenttxt: selectedCommentModel.message,
      strCommentID: selectedCommentModel.commentid,
    );
    bool isSuccess = await discussionController.addReplyOnComment(requestModel: discussionTopicCommentRequestModel);

    isLoading = false;
    if (isSuccess) {
      isCommentTextFormFieldVisible = false;
      replyTextEditingController.clear();
    }
    mySetState();

    loadRepliesForComment(topicCommentModel: selectedCommentModel);
  }

  Future<void> editTopic({required ForumModel forumModel, required TopicModel topicModel}) async {
    await NavigationController.navigateToCreateEditTopicScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      arguments: CreateEditTopicScreenNavigationArguments(
          componentId: widget.arguments.componentId, componentInsId: widget.arguments.componentInsId, forumModel: forumModel, isEdit: true, topicModel: topicModel),
    );
    await loadTopicForForum(forumModel: forumModel);
  }

  @override
  void initState() {
    super.initState();
    discussionProvider = context.read<DiscussionProvider>();
    appProvider = context.read<AppProvider>();
    discussionController = DiscussionController(discussionProvider: discussionProvider);
    uiActionController = DiscussionTopicUiActionController(appProvider: appProvider);
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
        "Discussion",
      ),
    );
  }

  Widget mainWidget() {
    if (forumModel == null) return AppConfigurations.commonNoDataView();

    return Column(
      children: [
        getForumCardWidget(),
        Expanded(
          child: getTopicListWidget(),
        ),
        if (selectedTopicForComment != null)
          commentTextFormField(
            selectedTopicModel: selectedTopicForComment!,
          ),
        if (selectedCommentModelForReply != null)
          replyTextFormField(
            selectedCommentModel: selectedCommentModelForReply,
          ),
      ],
    );
  }

  Widget getForumCardWidget() {
    return DiscussionCard(
      isDiscussionDetail: true,
      onAddTopicTap: () {
        if (forumModel != null) addTopic(forumModel: forumModel!);
      },
      onLikeTap: () async {
        isLoading = true;
        mySetState();

        await discussionController.showForumLikedUserList(context: context, forumModel: forumModel ?? ForumModel());
        isLoading = false;
        mySetState();
      },
      forumModel: forumModel ?? ForumModel(),
    );
  }

  Widget getTopicListWidget() {
    if (forumModel?.isLoadingTopics ?? false) {
      return const CommonLoader(
        isCenter: true,
      );
    }

    List<TopicModel> list = forumModel?.MainTopicsList ?? [];
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
        if (forumModel!.PinnedTopicsList.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
            decoration: BoxDecoration(
              color: themeData.colorScheme.onBackground.withAlpha(30),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: List.generate(
                    forumModel!.PinnedTopicsList.length,
                    (index) {
                      TopicModel topicModel = forumModel!.PinnedTopicsList[index];

                      return getTopicCardWidget(topicModel: topicModel);
                    },
                  ),
                ),
              ],
            ),
          ),
        if (forumModel!.UnpinnedTopicsList.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PopupMenuButton<bool>(
                      child: Row(
                        children: [
                          Text(
                            isShowInAscendingOrder ? 'By Older' : "By Recent",
                            style: popupTextStyle,
                          ),
                          const Icon(
                            Icons.arrow_drop_down_outlined,
                          ),
                        ],
                      ),
                      onSelected: (value) {
                        MyPrint.printOnConsole('Selected item: $value');

                        isShowInAscendingOrder = value;
                        forumModel?.sortTopics(value);
                        mySetState();
                      },
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: false,
                            child: Text(
                              'By Recent',
                              style: popupTextStyle,
                            ),
                          ),
                          PopupMenuItem(
                            value: true,
                            child: Text(
                              'By Older',
                              style: popupTextStyle,
                            ),
                          ),
                        ];
                      },
                    ),
                  ],
                ),
                ...List.generate(
                  forumModel!.UnpinnedTopicsList.length,
                  (index) {
                    TopicModel topicModel = forumModel!.UnpinnedTopicsList[index];

                    return getTopicCardWidget(topicModel: topicModel);
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget getTopicCardWidget({required TopicModel topicModel}) {
    return Container(
      padding: const EdgeInsets.only(bottom: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          profileRowWidget(topicModel: topicModel),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              if (topicModel.UploadFileName.checkNotEmpty) Container(child: thumbNailWidget(topicModel.UploadFileName)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 13.0),
                      child: Text(
                        topicModel.Name,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (topicModel.LongDescription.checkNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 13.0),
                        child: Html(
                          data: topicModel.LongDescription,
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
                  likeDislikeTopic(topicModel: topicModel, forumModel: forumModel);
                },
                iconData: topicModel.likeState ? Icons.thumb_up_alt_rounded : Icons.thumb_up_alt_outlined,
                text: topicModel.Likes.toString(),
              ),
              const SizedBox(
                width: 10,
              ),
              iconTextButton(
                iconData: FontAwesomeIcons.comment,
                text: topicModel.NoOfReplies.toString(),
              ),
            ],
          ),
          if (topicModel.NoOfReplies != 0)
            InkWell(
              onTap: () async {
                if (topicModel.commentList.checkEmpty) {
                  await loadCommentsForTopic(topicModel: topicModel);
                } else {
                  topicModel.commentList.clear();
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
                      "View ${topicModel.NoOfReplies} Comments",
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

  Widget thumbNailWidget(String url, {double height = 45, double width = 45}) {
    url = MyUtils.getSecureUrl(AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(imagePath: url));
    // MyPrint.printOnConsole('thumbnailImageUrl:$url');

    if (url.checkEmpty) return const SizedBox();
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
    required TopicModel topicModel,
  }) {
    String topicThumbnailUrl = MyUtils.getSecureUrl(
      AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(
        imagePath: topicModel.TopicUserProfile,
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
                      topicModel.Author,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      topicModel.UpdatedTime,
                      style: const TextStyle(color: Color(0xff858585), fontSize: 10),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  showMoreActionsForTopic(model: topicModel);
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
  Widget getCommentList({required TopicModel topicModel}) {
    if (topicModel.isLoadingComments) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: CommonLoader(
          size: 40,
        ),
      );
    }

    if (topicModel.commentList.checkEmpty) return const SizedBox();

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 40, top: 10),
      itemCount: topicModel.commentList.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return getCommentCardWidget(commentModel: topicModel.commentList[index], topicModel: topicModel);
      },
    );
  }

  Widget getCommentCardWidget({required TopicCommentModel commentModel, required TopicModel topicModel}) {
    String commentThumbnailUrl = MyUtils.getSecureUrl(
      AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(
        imagePath: commentModel.CommentUserProfile,
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
            days: commentModel.CommentedFromDays,
            authorName: commentModel.CommentedBy,
            onMoreTap: () {
              showMoreActionsForComment(
                commentModel: commentModel,
                topicModel: topicModel,
              );
            },
            profileUrl: commentThumbnailUrl,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Html(data: commentModel.message, style: {
                  "body": Style(
                    margin: Margins.all(0),
                    padding: HtmlPaddings.zero,
                  ),
                  "p": Style(padding: HtmlPaddings.zero, margin: Margins.zero),
                }),
                if (commentModel.CommentFileUploadPath.checkNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: thumbNailWidget(commentModel.CommentFileUploadPath),
                  ),
              ],
            ),
          ),
          Row(
            children: [
              iconTextButton(
                iconData: commentModel.likeState ? Icons.thumb_up_alt_rounded : Icons.thumb_up_alt_outlined,
                // text: "10",
                text: commentModel.CommentLikes.toString(),
                onTap: () {
                  likeDislikeComment(commentModel: commentModel);
                },
              ),
              const SizedBox(width: 10),
              iconTextButton(
                iconData: Icons.turn_left_outlined,
                iconSize: 22,
                text: "Reply ${commentModel.CommentRepliesCount}",
              ),
            ],
          ),
          if (commentModel.CommentRepliesCount != 0)
            InkWell(
              onTap: () async {
                if (commentModel.repliesList.checkEmpty) {
                  await loadRepliesForComment(topicCommentModel: commentModel);
                } else {
                  commentModel.repliesList.clear();
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
                      "View ${commentModel.CommentRepliesCount} Replies",
                      style: const TextStyle(color: Styles.lightGreyTextColor, fontSize: 10, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          getReplyList(topicCommentModel: commentModel),
        ],
      ),
    );
  }

  //endregion

  //region Reply Section
  Widget getReplyList({required TopicCommentModel topicCommentModel}) {
    if (topicCommentModel.isLoadingReplies) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: CommonLoader(
          size: 40,
        ),
      );
    }
    if (topicCommentModel.repliesList.checkEmpty) return const SizedBox();
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 40, top: 10),
      itemCount: topicCommentModel.repliesList.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return getReplyItem(replyModel: topicCommentModel.repliesList[index], commentModel: topicCommentModel);
      },
    );
  }

  Widget getReplyItem({required CommentReplyModel replyModel, required TopicCommentModel commentModel}) {
    String replyThumbnailUrl = MyUtils.getSecureUrl(
      AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(
        imagePath: replyModel.replyProfile,
      ),
    );
    // MyPrint.printOnConsole('replyThumbnailUrl:replyThumbnailUrl');

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        children: [
          // getCommentProfileWidget(commentModel),
          getCommonProfileWidget(
            days: replyModel.dtPostedDate,
            authorName: replyModel.replyBy,
            onMoreTap: () {
              showMoreActionsForReply(
                replyModel: replyModel,
                commentModel: commentModel,
              );
            },
            profileUrl: replyThumbnailUrl,
          ),
          Html(
            data: replyModel.message,
            style: {
              "body": Style(
                color: themeData.textTheme.bodyMedium?.color,
                fontWeight: FontWeight.w400,
                fontSize: FontSize(themeData.textTheme.bodyMedium?.fontSize ?? 16),
              ),
            },
          ),
          Row(
            children: [
              iconTextButton(
                onTap: () {
                  likeDislikeReply(replyModel: replyModel);
                },
                iconData: replyModel.likeState ? Icons.thumb_up_alt_rounded : Icons.thumb_up_alt_outlined,
                text: "",
              ),
              iconTextButton(
                iconData: Icons.turn_left_outlined,
                iconSize: 22,
                text: "Reply",
                onTap: () async {
                  isCommentTextFormFieldVisible = false;
                  isReplyTextFormFieldVisible = true;
                  selectedTopicForComment = null;
                  selectedCommentModelForReply = commentModel;
                  replyFocusNode = FocusNode();
                  replyFocusNode.requestFocus();
                  mySetState();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  //endregion

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

  Widget commentTextFormField({
    required TopicModel? selectedTopicModel,
  }) {
    if (!isCommentTextFormFieldVisible || selectedTopicModel == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          CommonTextFormField(
            node: commentFocusNode,
            controller: commentTextEditingController,
            borderColor: Colors.black54,
            hintText: "Add Comment",
            contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            fillColor: Colors.grey,
            prefixWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CommonCachedNetworkImage(
                    imageUrl: selectedTopicModel.TopicUserProfile,
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
                    fileName = await openFileExplorer(FileType.image, false);
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
                    addComment(selectedTopicModel: selectedTopicModel);
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
                    selectedTopicForComment = null;
                    selectedCommentModelForReply = null;
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
    );
  }

  Widget replyTextFormField({
    required TopicCommentModel? selectedCommentModel,
  }) {
    if (!isReplyTextFormFieldVisible || selectedCommentModel == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: CommonTextFormField(
        node: replyFocusNode,
        controller: replyTextEditingController,
        borderColor: Colors.black54,
        hintText: "Add Reply",
        contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        fillColor: Colors.grey,
        prefixWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CommonCachedNetworkImage(
                imageUrl: selectedCommentModel.CommentUserProfile,
                height: 30,
                width: 30,
                fit: BoxFit.cover,
                errorIconSize: 20,
              ),
            ),
          ],
        ),
        suffixWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    addReply(selectedCommentModel: selectedCommentModel);
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
                    isReplyTextFormFieldVisible = false;
                    replyTextEditingController.clear();
                    selectedCommentModelForReply = null;
                    mySetState();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Icon(Icons.clear),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget iconTextButton({required IconData iconData, String text = " ", Function()? onTap, double iconSize = 18}) {
    return Row(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon(iconData, color: Styles.iconColor, size: iconSize),
          ),
        ),
        Text(
          text,
          style: themeData.textTheme.bodySmall,
        )
      ],
    );
  }
}
