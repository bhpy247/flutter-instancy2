import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/data_model/ask_the_expert_dto.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';

import '../../../../api/api_controller.dart';
import '../../../../configs/app_constants.dart';
import '../../../../models/app_configuration_models/data_models/local_str.dart';
import '../../../../views/common/components/instancy_ui_actions/instancy_ui_actions.dart';
import '../../primary_secondary_actions/primary_secondary_actions_constants.dart';
import 'answer_comment_ui_action_callback_model.dart';
import 'answer_comment_ui_action_constant.dart';
import 'answer_ui_action_parameter_model.dart';

typedef AnswersUIActionTypeDef = bool Function({required AnswersUiActionParameterModel parameterModel});

class AnswersUiActionController {
  late final AppProvider _appProvider;

  AnswersUiActionController({
    required AppProvider? appProvider,
  }) {
    _appProvider = appProvider ?? AppProvider();
    _initializeActionsMap();
  }

  Map<InstancyContentActionsEnum, AnswersUIActionTypeDef> _actionsMap = <InstancyContentActionsEnum, AnswersUIActionTypeDef>{};

  AppProvider get appProvider => _appProvider;

  void _initializeActionsMap() {
    _actionsMap = <InstancyContentActionsEnum, AnswersUIActionTypeDef>{
      InstancyContentActionsEnum.AddComment: showAddComment,
      InstancyContentActionsEnum.Edit: showEdit,
      InstancyContentActionsEnum.Delete: showDelete,
      InstancyContentActionsEnum.ViewLikes: showViewLikes,
      InstancyContentActionsEnum.ShareToConnections: showShareWithConnection,
      InstancyContentActionsEnum.ShareWithPeople: showShareWithPeople,
    };
  }

  bool isShowAction({required InstancyContentActionsEnum actionType, required AnswersUiActionParameterModel parameterModel}) {
    AnswersUIActionTypeDef? type = _actionsMap[actionType];

    if (type != null) {
      return type(parameterModel: parameterModel);
    } else {
      return false;
    }
  }

  bool showAddComment({required AnswersUiActionParameterModel parameterModel}) {
    return true;
  }

  bool showEdit({required AnswersUiActionParameterModel parameterModel}) {
    return parameterModel.CreatedUserID == ApiController().apiDataProvider.getCurrentUserId();
  }

  bool showDelete({required AnswersUiActionParameterModel parameterModel}) {
    return parameterModel.CreatedUserID == ApiController().apiDataProvider.getCurrentUserId();
  }

  bool showViewLikes({required AnswersUiActionParameterModel parameterModel}) {
    return true;
  }

  bool showShareWithConnection({required AnswersUiActionParameterModel parameterModel}) {
    return parameterModel.actionSuggestConnection.checkNotEmpty;
  }

  bool showShareWithPeople({required AnswersUiActionParameterModel parameterModel}) {
    return parameterModel.actionSharewithFriends.checkNotEmpty;
  }

  //region Secondary Actions
  Iterable<InstancyUIActionModel> getSecondaryActions({
    required QuestionAnswerResponse commentModel,
    required LocalStr localStr,
    required AnswersUIActionCallbackModel uiActionCallbackModel,
  }) sync* {
    AnswersUiActionParameterModel parameterModel = getParameterModelFromDataModel(
      answerModel: commentModel,
    );

    List<InstancyContentActionsEnum> secondaryActions = AnswersUiActionConstant.secondaryActionList;
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

  AnswersUiActionParameterModel getParameterModelFromDataModel({
    required QuestionAnswerResponse answerModel,
  }) {
    return AnswersUiActionParameterModel(
      CreatedUserID: answerModel.respondedUserID,
      actionSharewithFriends: answerModel.actionSharewithFriends,
      actionSuggestConnection: answerModel.actionSuggestConnection,
    );
  }

  Iterable<InstancyUIActionModel> getInstancyUIActionModelListFromInstancyContentActionsEnumList({
    required List<InstancyContentActionsEnum> actions,
    required AnswersUiActionParameterModel parameterModel,
    required LocalStr localStr,
    required AnswersUIActionCallbackModel catalogUIActionCallbackModel,
  }) sync* {
    for (InstancyContentActionsEnum action in actions) {
      InstancyUIActionModel? model;

      //Primary Actions
      if (action == InstancyContentActionsEnum.AddComment) {
        if (isShowAction(actionType: InstancyContentActionsEnum.AddComment, parameterModel: parameterModel) && catalogUIActionCallbackModel.onAddCommentTap != null) {
          model = InstancyUIActionModel(
            text: localStr.discussionforumHeaderAddcommenttitlelabel,
            iconData: InstancyIcons.addComment,
            onTap: catalogUIActionCallbackModel.onAddCommentTap,
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
