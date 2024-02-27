import 'package:flutter_chat_bot/utils/my_print.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';

import '../../../../api/api_controller.dart';
import '../../../../configs/app_constants.dart';
import '../../../../models/app_configuration_models/data_models/local_str.dart';
import '../../../../models/ask_the_expert/data_model/answer_comment_dto.dart';
import '../../../../views/common/components/instancy_ui_actions/instancy_ui_actions.dart';
import '../../primary_secondary_actions/primary_secondary_actions_constants.dart';
import 'answer_comment_ui_action_callback_model.dart';
import 'answer_comment_ui_action_constant.dart';
import 'answer_ui_action_parameter_model.dart';

typedef AnswersCommentUIActionTypeDef = bool Function({required AnswersCommentUiActionParameterModel parameterModel});

class AnswersCommentUiActionController {
  late final AppProvider _appProvider;

  AnswersCommentUiActionController({
    required AppProvider? appProvider,
  }) {
    _appProvider = appProvider ?? AppProvider();
    _initializeActionsMap();
  }

  Map<InstancyContentActionsEnum, AnswersCommentUIActionTypeDef> _actionsMap = <InstancyContentActionsEnum, AnswersCommentUIActionTypeDef>{};

  AppProvider get appProvider => _appProvider;

  void _initializeActionsMap() {
    _actionsMap = <InstancyContentActionsEnum, AnswersCommentUIActionTypeDef>{
      InstancyContentActionsEnum.Edit: showEdit,
      InstancyContentActionsEnum.Delete: showDelete,
    };
  }

  bool isShowAction({required InstancyContentActionsEnum actionType, required AnswersCommentUiActionParameterModel parameterModel}) {
    AnswersCommentUIActionTypeDef? type = _actionsMap[actionType];

    if (type != null) {
      return type(parameterModel: parameterModel);
    } else {
      return false;
    }
  }

  bool showEdit({required AnswersCommentUiActionParameterModel parameterModel}) {
    return parameterModel.CreatedUserID == ApiController().apiDataProvider.getCurrentUserId();
  }

  bool showDelete({required AnswersCommentUiActionParameterModel parameterModel}) {
    return parameterModel.CreatedUserID == ApiController().apiDataProvider.getCurrentUserId();
  }

  //region Secondary Actions
  Iterable<InstancyUIActionModel> getSecondaryActions({
    required AnswerCommentsModel commentModel,
    required LocalStr localStr,
    required AnswersCommentUIActionCallbackModel uiActionCallbackModel,
  }) sync* {
    AnswersCommentUiActionParameterModel parameterModel = getParameterModelFromDataModel(
      answerModel: commentModel,
    );

    List<InstancyContentActionsEnum> secondaryActions = AnswersCommentUiActionConstant.secondaryActionList;
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

  AnswersCommentUiActionParameterModel getParameterModelFromDataModel({
    required AnswerCommentsModel answerModel,
  }) {
    return AnswersCommentUiActionParameterModel(
      CreatedUserID: answerModel.commentUserID,
    );
  }

  Iterable<InstancyUIActionModel> getInstancyUIActionModelListFromInstancyContentActionsEnumList({
    required List<InstancyContentActionsEnum> actions,
    required AnswersCommentUiActionParameterModel parameterModel,
    required LocalStr localStr,
    required AnswersCommentUIActionCallbackModel catalogUIActionCallbackModel,
  }) sync* {
    for (InstancyContentActionsEnum action in actions) {
      InstancyUIActionModel? model;

      //Primary Actions
      MyPrint.printOnConsole("AddCommentAddCommentAddComment : $action");
      // if (action == InstancyContentActionsEnum.AddComment) {
      if (action == InstancyContentActionsEnum.Edit) {
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
