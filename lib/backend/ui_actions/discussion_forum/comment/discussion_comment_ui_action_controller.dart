import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/ui_actions/discussion_forum/comment/dicussion_comment_ui_action_constant.dart';
import 'package:flutter_instancy_2/models/discussion/data_model/topic_comment_model.dart';

import '../../../../configs/app_constants.dart';
import '../../../../models/app_configuration_models/data_models/local_str.dart';
import '../../../../views/common/components/instancy_ui_actions/instancy_ui_actions.dart';
import '../../primary_secondary_actions/primary_secondary_actions_constants.dart';
import 'discussion_comment_ui_action_callback_model.dart';
import 'discussion_comment_ui_action_parameter_model.dart';

typedef DiscussionCommentUIActionTypeDef = bool Function({required DiscussionCommentUiActionParameterModel parameterModel});

class DiscussionCommentUiActionController {
  late final AppProvider _appProvider;

  DiscussionCommentUiActionController({
    required AppProvider? appProvider,
  }) {
    _appProvider = appProvider ?? AppProvider();
    _initializeActionsMap();
  }

  Map<InstancyContentActionsEnum, DiscussionCommentUIActionTypeDef> _actionsMap = <InstancyContentActionsEnum, DiscussionCommentUIActionTypeDef>{};

  AppProvider get appProvider => _appProvider;

  void _initializeActionsMap() {
    _actionsMap = <InstancyContentActionsEnum, DiscussionCommentUIActionTypeDef>{
      InstancyContentActionsEnum.AddReply: showAddReply,
      InstancyContentActionsEnum.Edit: showEdit,
      InstancyContentActionsEnum.Delete: showDelete,
      InstancyContentActionsEnum.ViewLikes: showViewLikes,
    };
  }

  bool isShowAction({required InstancyContentActionsEnum actionType, required DiscussionCommentUiActionParameterModel parameterModel}) {
    DiscussionCommentUIActionTypeDef? type = _actionsMap[actionType];

    if (type != null) {
      return type(parameterModel: parameterModel);
    } else {
      return false;
    }
  }

  bool showAddReply({required DiscussionCommentUiActionParameterModel parameterModel}) {
    return true;
  }

  bool showEdit({required DiscussionCommentUiActionParameterModel parameterModel}) {
    return true;
  }

  bool showDelete({required DiscussionCommentUiActionParameterModel parameterModel}) {
    return true;
  }

  bool showViewLikes({required DiscussionCommentUiActionParameterModel parameterModel}) {
    return true;
  }

  //region Secondary Actions
  Iterable<InstancyUIActionModel> getSecondaryActions({
    required TopicCommentModel commentModel,
    required LocalStr localStr,
    required DiscussionCommentUIActionCallbackModel uiActionCallbackModel,
  }) sync* {
    DiscussionCommentUiActionParameterModel parameterModel = getParameterModelFromDataModel(
      commentModel: commentModel,
    );

    List<InstancyContentActionsEnum> secondaryActions = DiscussionCommentUiActionConstant.secondaryActionList;
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

  DiscussionCommentUiActionParameterModel getParameterModelFromDataModel({
    required TopicCommentModel commentModel,
  }) {
    return const DiscussionCommentUiActionParameterModel();
  }

  Iterable<InstancyUIActionModel> getInstancyUIActionModelListFromInstancyContentActionsEnumList({
    required List<InstancyContentActionsEnum> actions,
    required DiscussionCommentUiActionParameterModel parameterModel,
    required LocalStr localStr,
    required DiscussionCommentUIActionCallbackModel catalogUIActionCallbackModel,
  }) sync* {
    for (InstancyContentActionsEnum action in actions) {
      InstancyUIActionModel? model;

      //Primary Actions
      if (action == InstancyContentActionsEnum.AddReply) {
        if (isShowAction(actionType: InstancyContentActionsEnum.AddReply, parameterModel: parameterModel) && catalogUIActionCallbackModel.onAddReplyTap != null) {
          model = InstancyUIActionModel(
            text: localStr.discussionforumLabelReplylabel,
            iconData: InstancyIcons.addReply,
            onTap: catalogUIActionCallbackModel.onAddReplyTap,
            actionsEnum: InstancyContentActionsEnum.AddReply,
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
      } else if (action == InstancyContentActionsEnum.ViewLikes) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ViewLikes, parameterModel: parameterModel) && catalogUIActionCallbackModel.onViewLikesTap != null) {
          model = InstancyUIActionModel(
            text: "View Likes",
            iconData: InstancyIcons.viewLikes,
            onTap: catalogUIActionCallbackModel.onViewLikesTap,
            actionsEnum: InstancyContentActionsEnum.ViewLikes,
          );
        }
      }

      if (model != null) yield model;
    }
  }
}
