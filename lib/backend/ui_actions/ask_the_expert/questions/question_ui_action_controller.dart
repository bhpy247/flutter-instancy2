import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/ui_actions/ask_the_expert/questions/question_ui_action_constant.dart';
import 'package:flutter_instancy_2/backend/ui_actions/ask_the_expert/questions/question_ui_action_parameter_model.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/data_model/ask_the_expert_dto.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';

import '../../../../configs/app_constants.dart';
import '../../../../models/app_configuration_models/data_models/local_str.dart';
import '../../../../views/common/components/instancy_ui_actions/instancy_ui_actions.dart';
import '../../primary_secondary_actions/primary_secondary_actions_constants.dart';
import 'question_ui_action_callback_model.dart';

typedef QuestionsUIActionTypeDef = bool Function({required QuestionsUiActionParameterModel parameterModel});

class QuestionsUiActionController {
  late final AppProvider _appProvider;

  QuestionsUiActionController({
    required AppProvider? appProvider,
  }) {
    _appProvider = appProvider ?? AppProvider();
    _initializeActionsMap();
  }

  Map<InstancyContentActionsEnum, QuestionsUIActionTypeDef> _actionsMap = <InstancyContentActionsEnum, QuestionsUIActionTypeDef>{};

  AppProvider get appProvider => _appProvider;

  void _initializeActionsMap() {
    _actionsMap = <InstancyContentActionsEnum, QuestionsUIActionTypeDef>{
      InstancyContentActionsEnum.AddAnswer: showAddAnswer,
      InstancyContentActionsEnum.Edit: showEdit,
      InstancyContentActionsEnum.Delete: showDelete,
      // InstancyContentActionsEnum.ViewLikes: showViewLikes,
      InstancyContentActionsEnum.ShareToConnections: showShareWithConnection,
      InstancyContentActionsEnum.ShareWithPeople: showShareWithPeople,
    };
  }

  bool isShowAction({required InstancyContentActionsEnum actionType, required QuestionsUiActionParameterModel parameterModel}) {
    QuestionsUIActionTypeDef? type = _actionsMap[actionType];

    if (type != null) {
      return type(parameterModel: parameterModel);
    } else {
      return false;
    }
  }

  bool showAddAnswer({required QuestionsUiActionParameterModel parameterModel}) {
    return parameterModel.AnswerBtnWithLink.checkNotEmpty;
  }

  bool showEdit({required QuestionsUiActionParameterModel parameterModel}) {
    return parameterModel.UserId == ApiController().apiDataProvider.getCurrentUserId();
  }

  bool showDelete({required QuestionsUiActionParameterModel parameterModel}) {
    return parameterModel.UserId == ApiController().apiDataProvider.getCurrentUserId();
  }

  bool showViewLikes({required QuestionsUiActionParameterModel parameterModel}) {
    return parameterModel.UserId == ApiController().apiDataProvider.getCurrentUserId() || parameterModel.views != 0;
  }

  bool showShareWithConnection({required QuestionsUiActionParameterModel parameterModel}) {
    return parameterModel.actionSuggestConnection.checkNotEmpty;
  }

  bool showShareWithPeople({required QuestionsUiActionParameterModel parameterModel}) {
    return parameterModel.actionSharewithFriends.checkNotEmpty;
  }

  //region Secondary Actions
  Iterable<InstancyUIActionModel> getDiscussionForumScreenSecondaryActions({
    required UserQuestionListDto forumModel,
    required LocalStr localStr,
    required QuestionsUIActionCallbackModel discussionForumUIActionCallbackModel,
  }) sync* {
    QuestionsUiActionParameterModel parameterModel = getParameterModelFromDataModel(
      model: forumModel,
    );

    List<InstancyContentActionsEnum> secondaryActions = QuestionsUiActionConstant.secondaryActionList;

    Set<InstancyContentActionsEnum> set = {};
    set.addAll(secondaryActions);

    yield* getInstancyUIActionModelListFromInstancyContentActionsEnumList(
      parameterModel: parameterModel,
      actions: set.toList(),
      localStr: localStr,
      questionsUIActionCallbackModel: discussionForumUIActionCallbackModel,
    );
  }

  QuestionsUiActionParameterModel getParameterModelFromDataModel({
    required UserQuestionListDto model,
  }) {
    return QuestionsUiActionParameterModel(
        actionSharewithFriends: model.actionSharewithFriends,
        actionSuggestConnection: model.actionSuggestConnection,
        AnswerBtnWithLink: model.answerBtnWithLink,
        DeleteBtnWithLink: model.deleteBtnWithLink,
        UserId: model.userID,
        views: model.views);
  }

  //endregion

  Iterable<InstancyUIActionModel> getInstancyUIActionModelListFromInstancyContentActionsEnumList({
    required List<InstancyContentActionsEnum> actions,
    required QuestionsUiActionParameterModel parameterModel,
    required LocalStr localStr,
    required QuestionsUIActionCallbackModel questionsUIActionCallbackModel,
  }) sync* {
    for (InstancyContentActionsEnum action in actions) {
      InstancyUIActionModel? model;

      //Primary Actions
      if (action == InstancyContentActionsEnum.AddAnswer) {
        if (isShowAction(actionType: InstancyContentActionsEnum.AddAnswer, parameterModel: parameterModel) && questionsUIActionCallbackModel.onAddAnswer != null) {
          model = InstancyUIActionModel(
            text: localStr.asktheexpertAnswerheader,
            iconData: InstancyIcons.addToMyLearning,
            onTap: questionsUIActionCallbackModel.onAddAnswer,
            actionsEnum: InstancyContentActionsEnum.AddTopic,
          );
        }
      } else if (action == InstancyContentActionsEnum.Edit) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Edit, parameterModel: parameterModel) && questionsUIActionCallbackModel.onEdit != null) {
          model = InstancyUIActionModel(
            text: localStr.discussionforumActionsheetEditforumoption,
            iconData: InstancyIcons.edit,
            onTap: questionsUIActionCallbackModel.onEdit,
            actionsEnum: InstancyContentActionsEnum.Edit,
          );
        }
      } else if (action == InstancyContentActionsEnum.Delete) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Delete, parameterModel: parameterModel) && questionsUIActionCallbackModel.onDelete != null) {
          model = InstancyUIActionModel(
            text: localStr.discussionforumActionsheetDeletetopicoption,
            iconData: InstancyIcons.delete,
            onTap: questionsUIActionCallbackModel.onDelete,
            actionsEnum: InstancyContentActionsEnum.Delete,
          );
        }
      } else if (action == InstancyContentActionsEnum.ViewLikes) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ViewLikes, parameterModel: parameterModel) && questionsUIActionCallbackModel.onViewLikes != null) {
          model = InstancyUIActionModel(
            text: "View Likes",
            iconData: InstancyIcons.viewLikes,
            onTap: questionsUIActionCallbackModel.onViewLikes,
            actionsEnum: InstancyContentActionsEnum.ViewLikes,
          );
        }
      } else if (action == InstancyContentActionsEnum.ShareToConnections) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ShareToConnections, parameterModel: parameterModel) && questionsUIActionCallbackModel.onShareWithConnectionTap != null) {
          model = InstancyUIActionModel(
            text: localStr.discussionforumActionsheetSuggesttoconnectionsoption,
            iconData: InstancyIcons.shareWithConnection,
            onTap: questionsUIActionCallbackModel.onShareWithConnectionTap,
            actionsEnum: InstancyContentActionsEnum.ShareToConnections,
          );
        }
      } else if (action == InstancyContentActionsEnum.ShareWithPeople) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ShareWithPeople, parameterModel: parameterModel) && questionsUIActionCallbackModel.onShareWithPeopleTap != null) {
          model = InstancyUIActionModel(
            text: localStr.discussionforumActionsheetSharewithpeopleoption,
            iconData: InstancyIcons.shareWithPeople,
            onTap: questionsUIActionCallbackModel.onShareWithPeopleTap,
            actionsEnum: InstancyContentActionsEnum.ShareWithPeople,
          );
        }
      }

      if (model != null) yield model;
    }
  }
}
