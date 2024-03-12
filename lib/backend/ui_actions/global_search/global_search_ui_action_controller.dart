import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';

import '../../../../configs/app_constants.dart';
import '../../../../models/app_configuration_models/data_models/local_str.dart';
import '../../../../views/common/components/instancy_ui_actions/instancy_ui_actions.dart';
import '../../../models/dto/global_search_course_dto_model.dart';
import '../primary_secondary_actions/primary_secondary_actions_constants.dart';
import 'global_search_ui_action_callback_model.dart';
import 'global_search_ui_action_constant.dart';
import 'global_search_ui_action_parameter_model.dart';

typedef GlobalSearchUIActionTypeDef = bool Function({required GlobalSearchUiActionParameterModel parameterModel});

class GlobalSearchUiActionController {
  late final AppProvider _appProvider;

  GlobalSearchUiActionController({
    required AppProvider? appProvider,
  }) {
    _appProvider = appProvider ?? AppProvider();
    _initializeActionsMap();
  }

  Map<InstancyContentActionsEnum, GlobalSearchUIActionTypeDef> _actionsMap = <InstancyContentActionsEnum, GlobalSearchUIActionTypeDef>{};

  AppProvider get appProvider => _appProvider;

  void _initializeActionsMap() {
    _actionsMap = <InstancyContentActionsEnum, GlobalSearchUIActionTypeDef>{
      InstancyContentActionsEnum.AddToMyLearning: showAddToMyLearning,
      InstancyContentActionsEnum.ShareToConnections: showShareWithConnection,
      InstancyContentActionsEnum.ShareWithPeople: showShareWithPeople,
      InstancyContentActionsEnum.Share: showShare,
      InstancyContentActionsEnum.Details: showDetails,
      // InstancyContentActionsEnum.P: showV,
    };
  }

  bool isShowAction({required InstancyContentActionsEnum actionType, required GlobalSearchUiActionParameterModel parameterModel}) {
    GlobalSearchUIActionTypeDef? type = _actionsMap[actionType];

    if (type != null) {
      return type(parameterModel: parameterModel);
    } else {
      return false;
    }
  }

  bool showShareWithConnection({required GlobalSearchUiActionParameterModel parameterModel}) {
    return parameterModel.actionSuggestConnection.checkNotEmpty;
  }

  bool showShareWithPeople({required GlobalSearchUiActionParameterModel parameterModel}) {
    return parameterModel.actionSharewithFriends.checkNotEmpty;
  }

  bool showShare({required GlobalSearchUiActionParameterModel parameterModel}) {
    return parameterModel.actionSharewithFriends.checkNotEmpty;
  }

  bool showDetails({required GlobalSearchUiActionParameterModel parameterModel}) {
    return parameterModel.detailsLink.checkNotEmpty;
  }

  bool showAddToMyLearning({required GlobalSearchUiActionParameterModel parameterModel}) {
    return parameterModel.addLink.checkNotEmpty;
  }

  //region Secondary Actions
  Iterable<InstancyUIActionModel> getSecondaryActions({
    required GlobalSearchCourseDTOModel globalSearchCourseDtoModel,
    required LocalStr localStr,
    required GlobalSearchUIActionCallbackModel uiActionCallbackModel,
  }) sync* {
    GlobalSearchUiActionParameterModel parameterModel = getParameterModelFromDataModel(
      globalSearchCourseDtoModel: globalSearchCourseDtoModel,
    );

    List<InstancyContentActionsEnum> secondaryActions = GlobalSearchUiActionConstant.secondaryActionList;
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

  GlobalSearchUiActionParameterModel getParameterModelFromDataModel({
    required GlobalSearchCourseDTOModel globalSearchCourseDtoModel,
  }) {
    return GlobalSearchUiActionParameterModel(
        CreatedUserID: globalSearchCourseDtoModel.UserSiteId,
        actionSharewithFriends: globalSearchCourseDtoModel.Sharelink,
        actionSuggestConnection: globalSearchCourseDtoModel.ShareContentwithUser,
        ViewProfileLink: globalSearchCourseDtoModel.ViewProfileLink,
        addLink: globalSearchCourseDtoModel.AddLink,
        detailsLink: globalSearchCourseDtoModel.DetailsLink);
  }

  Iterable<InstancyUIActionModel> getInstancyUIActionModelListFromInstancyContentActionsEnumList({
    required List<InstancyContentActionsEnum> actions,
    required GlobalSearchUiActionParameterModel parameterModel,
    required LocalStr localStr,
    required GlobalSearchUIActionCallbackModel catalogUIActionCallbackModel,
  }) sync* {
    for (InstancyContentActionsEnum action in actions) {
      InstancyUIActionModel? model;

      //Primary Actions
      if (action == InstancyContentActionsEnum.AddToMyLearning) {
        if (isShowAction(actionType: InstancyContentActionsEnum.AddToMyLearning, parameterModel: parameterModel) && catalogUIActionCallbackModel.onAddToMyLearningTap != null) {
          model = InstancyUIActionModel(
            text: localStr.catalogActionsheetAddtomylearningoption,
            iconData: InstancyIcons.addToMyLearning,
            onTap: catalogUIActionCallbackModel.onAddToMyLearningTap,
            actionsEnum: InstancyContentActionsEnum.AddToMyLearning,
          );
        }
      } else if (action == InstancyContentActionsEnum.Details) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Details, parameterModel: parameterModel) && catalogUIActionCallbackModel.onDetailsTap != null) {
          model = InstancyUIActionModel(
            text: localStr.catalogActionsheetDetailsoption,
            iconData: InstancyIcons.details,
            onTap: catalogUIActionCallbackModel.onDetailsTap,
            actionsEnum: InstancyContentActionsEnum.Details,
          );
        }
      } else if (action == InstancyContentActionsEnum.Share) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Share, parameterModel: parameterModel) && catalogUIActionCallbackModel.onShareTap != null) {
          model = InstancyUIActionModel(
            text: localStr.catalogActionsheetShareoption,
            iconData: InstancyIcons.share,
            onTap: catalogUIActionCallbackModel.onShareTap,
            actionsEnum: InstancyContentActionsEnum.Share,
          );
        }
      } else if (action == InstancyContentActionsEnum.View) {
        if (isShowAction(actionType: InstancyContentActionsEnum.View, parameterModel: parameterModel) && catalogUIActionCallbackModel.onViewProfileTap != null) {
          model = InstancyUIActionModel(
            text: "View Profile",
            iconData: InstancyIcons.viewProfile,
            onTap: catalogUIActionCallbackModel.onViewProfileTap,
            actionsEnum: InstancyContentActionsEnum.View,
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
