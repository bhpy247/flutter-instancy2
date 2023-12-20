import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/ui_actions/discussion_forum/topic/dicussion_topic_ui_action_constant.dart';
import 'package:flutter_instancy_2/backend/ui_actions/discussion_forum/topic/discussion_topic_ui_action_parameter_model.dart';
import 'package:flutter_instancy_2/models/discussion/data_model/forum_model.dart';
import 'package:flutter_instancy_2/models/discussion/data_model/topic_model.dart';

import '../../../../api/api_controller.dart';
import '../../../../configs/app_constants.dart';
import '../../../../models/app_configuration_models/data_models/local_str.dart';
import '../../../../views/common/components/instancy_ui_actions/instancy_ui_actions.dart';
import '../../primary_secondary_actions/primary_secondary_actions_constants.dart';
import 'discussion_topic_ui_action_callback_model.dart';

typedef DiscussionTopicUIActionTypeDef = bool Function({required DiscussionTopicUiActionParameterModel parameterModel});

class DiscussionTopicUiActionController {
  late final AppProvider _appProvider;

  DiscussionTopicUiActionController({
    required AppProvider? appProvider,
  }) {
    _appProvider = appProvider ?? AppProvider();
    _initializeActionsMap();
  }

  Map<InstancyContentActionsEnum, DiscussionTopicUIActionTypeDef> _actionsMap = <InstancyContentActionsEnum, DiscussionTopicUIActionTypeDef>{};

  AppProvider get appProvider => _appProvider;

  void _initializeActionsMap() {
    _actionsMap = <InstancyContentActionsEnum, DiscussionTopicUIActionTypeDef>{
      InstancyContentActionsEnum.AddComment: showAddComment,
      InstancyContentActionsEnum.Edit: showEdit,
      InstancyContentActionsEnum.Delete: showDelete,
      InstancyContentActionsEnum.Pin: showPin,
      InstancyContentActionsEnum.UnPin: showUnPin,
      InstancyContentActionsEnum.ViewLikes: showViewLikes,
      InstancyContentActionsEnum.ShareToConnections: showShareWithConnection,
      InstancyContentActionsEnum.ShareWithPeople: showShareWithPeople,
    };
  }

  bool isShowAction({required InstancyContentActionsEnum actionType, required DiscussionTopicUiActionParameterModel parameterModel}) {
    DiscussionTopicUIActionTypeDef? type = _actionsMap[actionType];

    if (type != null) {
      return type(parameterModel: parameterModel);
    } else {
      return false;
    }
  }

  bool showAddComment({required DiscussionTopicUiActionParameterModel parameterModel}) {
    return parameterModel.CreatedUserID == ApiController().apiDataProvider.getCurrentUserId() || parameterModel.CreateNewTopic;
  }

  bool showLike({required DiscussionTopicUiActionParameterModel parameterModel}) {
    return parameterModel.CreatedUserID == ApiController().apiDataProvider.getCurrentUserId() || parameterModel.LikePosts;
  }

  bool showEdit({required DiscussionTopicUiActionParameterModel parameterModel}) {
    return parameterModel.CreatedUserID == ApiController().apiDataProvider.getCurrentUserId();
  }

  bool showDelete({required DiscussionTopicUiActionParameterModel parameterModel}) {
    return parameterModel.CreatedUserID == ApiController().apiDataProvider.getCurrentUserId();
  }

  bool showPin({required DiscussionTopicUiActionParameterModel parameterModel}) {
    if (!parameterModel.AllowPinEditValue || parameterModel.isPin) {
      return false;
    }
    return true;
  }

  bool showUnPin({required DiscussionTopicUiActionParameterModel parameterModel}) {
    if (!parameterModel.AllowPinEditValue || !parameterModel.isPin) {
      return false;
    }
    return true;
  }

  bool showViewLikes({required DiscussionTopicUiActionParameterModel parameterModel}) {
    if (!parameterModel.LikePostsEditValue) {
      return false;
    }
    return true;
  }

  bool showShareWithConnection({required DiscussionTopicUiActionParameterModel parameterModel}) {
    if (!parameterModel.AllowShareEditValue) {
      return false;
    }
    return true;
  }

  bool showShareWithPeople({required DiscussionTopicUiActionParameterModel parameterModel}) {
    if (!parameterModel.AllowShareEditValue) {
      return false;
    }
    return true;
  }

  //region Secondary Actions
  Iterable<InstancyUIActionModel> getDiscussionTopicScreenSecondaryActions({
    required ForumModel forumModel,
    required TopicModel topicModel,
    required LocalStr localStr,
    required DiscussionTopicUIActionCallbackModel uiActionCallbackModel,
  }) sync* {
    DiscussionTopicUiActionParameterModel parameterModel = getParameterModelFromDataModel(
      forumModel: forumModel,
      topicModel: topicModel,
    );

    List<InstancyContentActionsEnum> secondaryActions = DiscussionTopicUiActionConstant.secondaryActionList;
    Set<InstancyContentActionsEnum> set = {};
    set.addAll(secondaryActions);

    yield* getInstancyUIActionModelListFromInstancyContentActionsEnumList(
      actions: set.toList(),
      localStr: localStr,
      parameterModel: parameterModel,
      catalogUIActionCallbackModel: uiActionCallbackModel,
    );
  }
  //endregion

  DiscussionTopicUiActionParameterModel getParameterModelFromDataModel({
    required ForumModel forumModel,
    required TopicModel topicModel,
  }) {
    return DiscussionTopicUiActionParameterModel(
      contentID: topicModel.ContentID,
      name: topicModel.Name,
      createdDate: topicModel.CreatedDate,
      CreatedUserID: topicModel.CreatedUserID,
      noOfReplies: topicModel.NoOfReplies,
      noOfViews: topicModel.NoOfViews,
      longDescription: topicModel.LongDescription,
      latestReplyBy: topicModel.LatestReplyBy,
      author: topicModel.Author,
      uploadFileName: topicModel.UploadFileName,
      updatedTime: topicModel.UpdatedTime,
      createdTime: topicModel.CreatedTime,
      modifiedUserName: topicModel.ModifiedUserName,
      uploadedImageName: topicModel.UploadedImageName,
      topicImageUploadName: topicModel.TopicImageUploadName,
      topicUploadIconPath: topicModel.TopicUploadIconPath,
      likes: topicModel.Likes,
      topicUserProfile: topicModel.TopicUserProfile,
      isPin: topicModel.IsPin,
      pinID: topicModel.PinID,
      comments: topicModel.Comments,
      likedUserList: topicModel.LikedUserList,
      likeState: topicModel.likeState,
      AllowPin: forumModel.AllowPin,
      AllowShare: forumModel.AllowShare,
      AttachFile: forumModel.AttachFile,
      LikePosts: forumModel.LikePosts,
      CreateNewTopic: forumModel.CreateNewTopic,
      CreateNewTopicEditValue: forumModel.CreateNewTopicEditValue,
      LikePostsEditValue: forumModel.LikePostsEditValue,
      AttachFileEditValue: forumModel.AttachFileEditValue,
      AllowShareEditValue: forumModel.AllowShareEditValue,
      AllowPinEditValue: forumModel.AllowPinEditValue,
    );
  }

  Iterable<InstancyUIActionModel> getInstancyUIActionModelListFromInstancyContentActionsEnumList({
    required List<InstancyContentActionsEnum> actions,
    required DiscussionTopicUiActionParameterModel parameterModel,
    required LocalStr localStr,
    required DiscussionTopicUIActionCallbackModel catalogUIActionCallbackModel,
  }) sync* {
    for (InstancyContentActionsEnum action in actions) {
      InstancyUIActionModel? model;

      //Primary Actions
      if (action == InstancyContentActionsEnum.AddComment) {
        if (isShowAction(actionType: InstancyContentActionsEnum.AddComment, parameterModel: parameterModel) && catalogUIActionCallbackModel.onAddCommentTap != null) {
          model = InstancyUIActionModel(
            text: localStr.discussionforumLabelCommentlabel,
            iconData: InstancyIcons.addComment,
            onTap: catalogUIActionCallbackModel.onAddCommentTap,
            actionsEnum: InstancyContentActionsEnum.AddTopic,
          );
        }
      } else if (action == InstancyContentActionsEnum.Edit) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Edit, parameterModel: parameterModel) && catalogUIActionCallbackModel.onEditTap != null) {
          model = InstancyUIActionModel(
            text: localStr.discussionforumActionsheetEdittopicoption,
            iconData: InstancyIcons.edit,
            onTap: catalogUIActionCallbackModel.onEditTap,
            actionsEnum: InstancyContentActionsEnum.Edit,
          );
        }
      } else if (action == InstancyContentActionsEnum.Delete) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Delete, parameterModel: parameterModel) && catalogUIActionCallbackModel.onDeleteTap != null) {
          model = InstancyUIActionModel(
            text: localStr.discussionforumActionsheetDeletetopicoption,
            iconData: InstancyIcons.delete,
            onTap: catalogUIActionCallbackModel.onDeleteTap,
            actionsEnum: InstancyContentActionsEnum.Delete,
          );
        }
      } else if (action == InstancyContentActionsEnum.Pin) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Pin, parameterModel: parameterModel) && catalogUIActionCallbackModel.onPinTap != null) {
          model = InstancyUIActionModel(
            text: "Pin",
            iconData: InstancyIcons.pin,
            onTap: catalogUIActionCallbackModel.onPinTap,
            actionsEnum: InstancyContentActionsEnum.Pin,
          );
        }
      } else if (action == InstancyContentActionsEnum.UnPin) {
        if (isShowAction(actionType: InstancyContentActionsEnum.UnPin, parameterModel: parameterModel) && catalogUIActionCallbackModel.onUnPinTap != null) {
          model = InstancyUIActionModel(
            text: "UnPin",
            // iconData: InstancyIcons.unpin,
            svgImageUrl: "assets/unpin.svg",
            onTap: catalogUIActionCallbackModel.onUnPinTap,
            actionsEnum: InstancyContentActionsEnum.UnPin,
          );
        }
      } else if (action == InstancyContentActionsEnum.ViewLikes) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ViewLikes, parameterModel: parameterModel) && catalogUIActionCallbackModel.onViewLikesTap != null) {
          model = InstancyUIActionModel(
            text: "View Likes",
            iconData: InstancyIcons.viewLikes,
            onTap: catalogUIActionCallbackModel.onViewLikesTap,
            actionsEnum: InstancyContentActionsEnum.ViewLikes,
          );
        }
      } else if (action == InstancyContentActionsEnum.ShareToConnections) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ShareToConnections, parameterModel: parameterModel) && catalogUIActionCallbackModel.onShareWithConnectionTap != null) {
          model = InstancyUIActionModel(
            text: localStr.discussionforumActionsheetSuggesttoconnectionsoption,
            iconData: InstancyIcons.shareWithConnection,
            onTap: catalogUIActionCallbackModel.onShareWithConnectionTap,
            actionsEnum: InstancyContentActionsEnum.ShareToConnections,
          );
        }
      } else if (action == InstancyContentActionsEnum.ShareWithPeople) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ShareWithPeople, parameterModel: parameterModel) && catalogUIActionCallbackModel.onShareWithPeopleTap != null) {
          model = InstancyUIActionModel(
            text: localStr.discussionforumActionsheetSharewithpeopleoption,
            iconData: InstancyIcons.shareWithPeople,
            onTap: catalogUIActionCallbackModel.onShareWithPeopleTap,
            actionsEnum: InstancyContentActionsEnum.ShareWithPeople,
          );
        }
      }

      if (model != null) yield model;
    }
  }
}
