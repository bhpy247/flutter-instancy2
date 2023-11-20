import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/ui_actions/discussion_forum/forum/dicussion_forum_ui_action_constant.dart';
import 'package:flutter_instancy_2/backend/ui_actions/discussion_forum/forum/discussion_forum_ui_action_parameter_model.dart';
import 'package:flutter_instancy_2/models/discussion/data_model/forum_model.dart';

import '../../../../configs/app_constants.dart';
import '../../../../models/app_configuration_models/data_models/local_str.dart';
import '../../../../views/common/components/instancy_ui_actions/instancy_ui_actions.dart';
import '../../primary_secondary_actions/primary_secondary_actions_constants.dart';
import 'discussion_forum_ui_action_callback_model.dart';

typedef DiscussionForumUIActionTypeDef = bool Function({required DiscussionForumUiActionParameterModel parameterModel});

class DiscussionForumUiActionController {
  late final AppProvider _appProvider;

  DiscussionForumUiActionController({
    required AppProvider? appProvider,
  }) {
    _appProvider = appProvider ?? AppProvider();
    _initializeActionsMap();
  }

  Map<InstancyContentActionsEnum, DiscussionForumUIActionTypeDef> _actionsMap = <InstancyContentActionsEnum, DiscussionForumUIActionTypeDef>{};

  AppProvider get appProvider => _appProvider;

  void _initializeActionsMap() {
    _actionsMap = <InstancyContentActionsEnum, DiscussionForumUIActionTypeDef>{
      InstancyContentActionsEnum.AddTopic: showAddToTopic,
      InstancyContentActionsEnum.Edit: showEdit,
      InstancyContentActionsEnum.Delete: showDelete,
      InstancyContentActionsEnum.ViewLikes: showViewLikes,
      InstancyContentActionsEnum.ShareToConnections: showShareWithConnection,
      InstancyContentActionsEnum.ShareWithPeople: showShareWithPeople,
    };
  }

  bool isShowAction({required InstancyContentActionsEnum actionType, required DiscussionForumUiActionParameterModel parameterModel}) {
    DiscussionForumUIActionTypeDef? type = _actionsMap[actionType];

    if (type != null) {
      return type(parameterModel: parameterModel);
    } else {
      return false;
    }
  }

  bool showAddToTopic({required DiscussionForumUiActionParameterModel parameterModel}) {
    return parameterModel.CreatedUserID == ApiController().apiDataProvider.getCurrentUserId() || parameterModel.CreateNewTopic;
  }

  bool showEdit({required DiscussionForumUiActionParameterModel parameterModel}) {
    return parameterModel.CreatedUserID == ApiController().apiDataProvider.getCurrentUserId();
  }

  bool showDelete({required DiscussionForumUiActionParameterModel parameterModel}) {
    return parameterModel.CreatedUserID == ApiController().apiDataProvider.getCurrentUserId();
  }

  bool showViewLikes({required DiscussionForumUiActionParameterModel parameterModel}) {
    return parameterModel.CreatedUserID == ApiController().apiDataProvider.getCurrentUserId() || parameterModel.LikePosts;
  }

  bool showShareWithConnection({required DiscussionForumUiActionParameterModel parameterModel}) {
    return parameterModel.CreatedUserID == ApiController().apiDataProvider.getCurrentUserId() || parameterModel.AllowShare;
  }

  bool showShareWithPeople({required DiscussionForumUiActionParameterModel parameterModel}) {
    return parameterModel.CreatedUserID == ApiController().apiDataProvider.getCurrentUserId() || parameterModel.AllowShare;
  }

  //region Secondary Actions
  Iterable<InstancyUIActionModel> getDiscussionForumScreenSecondaryActions({
    required ForumModel forumModel,
    required LocalStr localStr,
    required DiscussionForumUIActionCallbackModel discussionForumUIActionCallbackModel,
  }) sync* {
    DiscussionForumUiActionParameterModel parameterModel = getParameterModelFromDataModel(
      model: forumModel,
    );

    List<InstancyContentActionsEnum> secondaryActions = DiscussionForumUiActionConstant.secondaryActionList;

    Set<InstancyContentActionsEnum> set = {};
    set.addAll(secondaryActions);

    yield* getInstancyUIActionModelListFromInstancyContentActionsEnumList(
      parameterModel: parameterModel,
      actions: set.toList(),
      localStr: localStr,
      catalogUIActionCallbackModel: discussionForumUIActionCallbackModel,
    );
  }

  DiscussionForumUiActionParameterModel getParameterModelFromDataModel({
    required ForumModel model,
  }) {
    return DiscussionForumUiActionParameterModel(
      CreatedUserID: model.CreatedUserID,
      CreateNewTopic: model.CreateNewTopic,
      LikePosts: model.LikePosts,
      AllowShare: model.AllowShare,
    );
  }

  //endregion

  Iterable<InstancyUIActionModel> getInstancyUIActionModelListFromInstancyContentActionsEnumList({
    required List<InstancyContentActionsEnum> actions,
    required DiscussionForumUiActionParameterModel parameterModel,
    required LocalStr localStr,
    required DiscussionForumUIActionCallbackModel catalogUIActionCallbackModel,
  }) sync* {
    for (InstancyContentActionsEnum action in actions) {
      InstancyUIActionModel? model;

      //Primary Actions
      if (action == InstancyContentActionsEnum.AddTopic) {
        if (isShowAction(actionType: InstancyContentActionsEnum.AddTopic, parameterModel: parameterModel) && catalogUIActionCallbackModel.onAddToTopic != null) {
          model = InstancyUIActionModel(
            text: localStr.discussionforumHeaderAddtopictitlelabel,
            iconData: InstancyIcons.addToMyLearning,
            onTap: catalogUIActionCallbackModel.onAddToTopic,
            actionsEnum: InstancyContentActionsEnum.AddTopic,
          );
        }
      } else if (action == InstancyContentActionsEnum.Edit) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Edit, parameterModel: parameterModel) && catalogUIActionCallbackModel.onEdit != null) {
          model = InstancyUIActionModel(
            text: localStr.discussionforumActionsheetEditforumoption,
            iconData: InstancyIcons.edit,
            onTap: catalogUIActionCallbackModel.onEdit,
            actionsEnum: InstancyContentActionsEnum.Edit,
          );
        }
      } else if (action == InstancyContentActionsEnum.Delete) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Delete, parameterModel: parameterModel) && catalogUIActionCallbackModel.onDelete != null) {
          model = InstancyUIActionModel(
            text: localStr.discussionforumActionsheetDeletetopicoption,
            iconData: InstancyIcons.delete,
            onTap: catalogUIActionCallbackModel.onDelete,
            actionsEnum: InstancyContentActionsEnum.Delete,
          );
        }
      } else if (action == InstancyContentActionsEnum.ViewLikes) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ViewLikes, parameterModel: parameterModel) && catalogUIActionCallbackModel.onViewLikes != null) {
          model = InstancyUIActionModel(
            text: "View Likes",
            iconData: InstancyIcons.viewLikes,
            onTap: catalogUIActionCallbackModel.onViewLikes,
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
