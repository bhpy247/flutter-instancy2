import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/ui_actions/discussion_forum/reply/dicussion_reply_ui_action_constant.dart';
import 'package:flutter_instancy_2/models/discussion/data_model/comment_reply_model.dart';

import '../../../../api/api_controller.dart';
import '../../../../configs/app_constants.dart';
import '../../../../models/app_configuration_models/data_models/local_str.dart';
import '../../../../views/common/components/instancy_ui_actions/instancy_ui_actions.dart';
import '../../primary_secondary_actions/primary_secondary_actions_constants.dart';
import 'discussion_reply_ui_action_callback_model.dart';
import 'discussion_reply_ui_action_parameter_model.dart';

typedef DiscussionReplyUIActionTypeDef = bool Function({required DiscussionReplyUiActionParameterModel parameterModel});

class DiscussionReplyUiActionController {
  late final AppProvider _appProvider;

  DiscussionReplyUiActionController({
    required AppProvider? appProvider,
  }) {
    _appProvider = appProvider ?? AppProvider();
    _initializeActionsMap();
  }

  Map<InstancyContentActionsEnum, DiscussionReplyUIActionTypeDef> _actionsMap = <InstancyContentActionsEnum, DiscussionReplyUIActionTypeDef>{};

  AppProvider get appProvider => _appProvider;

  void _initializeActionsMap() {
    _actionsMap = <InstancyContentActionsEnum, DiscussionReplyUIActionTypeDef>{
      InstancyContentActionsEnum.AddReply: showAddReply,
      InstancyContentActionsEnum.Edit: showEdit,
      InstancyContentActionsEnum.Delete: showDelete,
    };
  }

  bool isShowAction({required InstancyContentActionsEnum actionType, required DiscussionReplyUiActionParameterModel parameterModel}) {
    DiscussionReplyUIActionTypeDef? type = _actionsMap[actionType];

    if (type != null) {
      return type(parameterModel: parameterModel);
    } else {
      return false;
    }
  }

  bool showAddReply({required DiscussionReplyUiActionParameterModel parameterModel}) {
    return true;
  }

  bool showEdit({required DiscussionReplyUiActionParameterModel parameterModel}) {
    return parameterModel.CreatedUserID == ApiController().apiDataProvider.getCurrentUserId();
  }

  bool showDelete({required DiscussionReplyUiActionParameterModel parameterModel}) {
    return parameterModel.CreatedUserID == ApiController().apiDataProvider.getCurrentUserId();
  }

  //region Secondary Actions
  Iterable<InstancyUIActionModel> getSecondaryActions({
    required CommentReplyModel replyModel,
    required LocalStr localStr,
    required DiscussionReplyUIActionCallbackModel uiActionCallbackModel,
  }) sync* {
    DiscussionReplyUiActionParameterModel parameterModel = getParameterModelFromDataModel(
      replyModel: replyModel,
    );

    List<InstancyContentActionsEnum> secondaryActions = DiscussionReplyUiActionConstant.secondaryActionList;
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

  DiscussionReplyUiActionParameterModel getParameterModelFromDataModel({
    required CommentReplyModel replyModel,
  }) {
    return DiscussionReplyUiActionParameterModel(
      CreatedUserID: replyModel.postedBy,
    );
  }

  Iterable<InstancyUIActionModel> getInstancyUIActionModelListFromInstancyContentActionsEnumList({
    required List<InstancyContentActionsEnum> actions,
    required DiscussionReplyUiActionParameterModel parameterModel,
    required LocalStr localStr,
    required DiscussionReplyUIActionCallbackModel catalogUIActionCallbackModel,
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
      }

      if (model != null) yield model;
    }
  }
}
