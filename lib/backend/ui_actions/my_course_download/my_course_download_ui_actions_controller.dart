import 'package:flutter_instancy_2/backend/app/app_controller.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/backend/network_connection/network_connection_controller.dart';
import 'package:flutter_instancy_2/backend/profile/profile_provider.dart';
import 'package:flutter_instancy_2/backend/ui_actions/primary_secondary_actions/primary_secondary_actions.dart';
import 'package:flutter_instancy_2/models/course_download/data_model/course_download_data_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:provider/provider.dart';

import '../../../configs/app_constants.dart';
import '../../../models/app_configuration_models/data_models/local_str.dart';
import '../../../utils/my_print.dart';
import '../../../views/common/components/instancy_ui_actions/instancy_ui_actions.dart';
import 'my_course_download_ui_action_callback_model.dart';
import 'my_course_download_ui_action_parameter_model.dart';

typedef MyCourseDownloadUIActionTypeDef = bool Function({required MyCourseDownloadUIActionParameterModel parameterModel});

class MyCourseDownloadUIActionsController {
  MyCourseDownloadUIActionsController({
    required AppProvider? appProvider,
  }) {
    _initializeActionsMap();
  }

  Map<InstancyContentActionsEnum, MyCourseDownloadUIActionTypeDef> _actionsMap = <InstancyContentActionsEnum, MyCourseDownloadUIActionTypeDef>{};

  void _initializeActionsMap() {
    _actionsMap = <InstancyContentActionsEnum, MyCourseDownloadUIActionTypeDef>{
      InstancyContentActionsEnum.RemoveFromDownloads: showRemoveFromDownloads,
      InstancyContentActionsEnum.CancelDownload: showCancelDownload,
      InstancyContentActionsEnum.PauseDownload: showPauseDownload,
      InstancyContentActionsEnum.ResumeDownload: showResumeDownload,
      InstancyContentActionsEnum.SetComplete: showSetComplete,
    };
  }

  bool isShowAction({required InstancyContentActionsEnum actionType, required MyCourseDownloadUIActionParameterModel parameterModel}) {
    MyCourseDownloadUIActionTypeDef? type = _actionsMap[actionType];

    if (type != null) {
      return type(parameterModel: parameterModel);
    } else {
      return false;
    }
  }

  bool showRemoveFromDownloads({required MyCourseDownloadUIActionParameterModel parameterModel}) {
    if (parameterModel.isCourseDownloaded) {
      return true;
    }

    return false;
  }

  bool showCancelDownload({required MyCourseDownloadUIActionParameterModel parameterModel}) {
    if (parameterModel.isFileDownloading || parameterModel.isFileDownloadingPaused) {
      return true;
    }

    return false;
  }

  bool showPauseDownload({required MyCourseDownloadUIActionParameterModel parameterModel}) {
    if (parameterModel.isFileDownloading && !parameterModel.isFileDownloadingPaused) {
      return true;
    }

    return false;
  }

  bool showResumeDownload({required MyCourseDownloadUIActionParameterModel parameterModel}) {
    if (parameterModel.isFileDownloadingPaused) {
      return true;
    }

    return false;
  }

  bool showSetComplete({required MyCourseDownloadUIActionParameterModel parameterModel}) {
    MyPrint.printOnConsole("showSetComplete called");

    bool isHavingNetworkConnection = NetworkConnectionController().checkConnection();

    return !isHavingNetworkConnection &&
        AppConfigurationOperations(appProvider: AppController.mainAppContext?.read<AppProvider>() ?? AppProvider()).isShowSetComplete(
          objectTypeId: parameterModel.ContentTypeId,
          mediaTypeId: parameterModel.MediaTypeId,
          actualContentStatus: parameterModel.CoreLessonStatus,
          profileProvider: AppController.mainAppContext?.read<ProfileProvider>() ?? ProfileProvider(),
          jwVideoKey: parameterModel.JWVideoKey,
        );
  }

  //region Secondary Actions
  Iterable<InstancyUIActionModel> getMyCourseDownloadsScreenSecondaryActions({
    required CourseDownloadDataModel courseDownloadDataModel,
    required LocalStr localStr,
    required MyCourseDownloadUIActionCallbackModel myCourseDownloadUIActionCallbackModel,
  }) sync* {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
        "MyCourseDownloadUIActionsController().getMyCourseDownloadsScreenSecondaryActions() called with downloadId:${courseDownloadDataModel.id}, "
        "contentId:${courseDownloadDataModel.contentId}",
        tag: tag);

    MyCourseDownloadUIActionParameterModel parameterModel = getMyLearningUIActionParameterModelFromCourseDTOModel(model: courseDownloadDataModel);

    Set<InstancyContentActionsEnum> set = {
      InstancyContentActionsEnum.RemoveFromDownloads,
      InstancyContentActionsEnum.CancelDownload,
      InstancyContentActionsEnum.PauseDownload,
      InstancyContentActionsEnum.ResumeDownload,
      InstancyContentActionsEnum.SetComplete,
    };

    // MyPrint.printOnConsole("secondaryActions:$set", tag: tag);

    yield* getInstancyUIActionModelListFromInstancyContentActionsEnumList(
      actions: set.toList(),
      parameterModel: parameterModel,
      localStr: localStr,
      myLearningUIActionCallbackModel: myCourseDownloadUIActionCallbackModel,
    );
  }

  //endregion

  MyCourseDownloadUIActionParameterModel getMyLearningUIActionParameterModelFromCourseDTOModel({
    required CourseDownloadDataModel model,
  }) {
    return MyCourseDownloadUIActionParameterModel(
      CoreLessonStatus: model.courseDTOModel?.ActualStatus ?? model.trackCourseDTOModel?.CoreLessonStatus ?? model.relatedTrackDataDTOModel?.CoreLessonStatus ?? "",
      ContentTypeId: model.contentTypeId,
      MediaTypeId: model.mediaTypeId,
      isFileDownloading: model.isFileDownloading,
      isFileDownloadingPaused: model.isFileDownloadingPaused,
      isFileDownloaded: model.isFileDownloaded,
      isFileExtracting: model.isFileExtracting,
      isFileExtracted: model.isFileExtracted,
      isCourseDownloading: model.isCourseDownloading,
      isCourseDownloaded: model.isCourseDownloaded,
      JWVideoKey: model.courseDTOModel?.JWVideoKey ?? model.trackCourseDTOModel?.JWVideoKey ?? model.relatedTrackDataDTOModel?.JWVideoKey ?? "",
    );
  }

  Iterable<InstancyUIActionModel> getInstancyUIActionModelListFromInstancyContentActionsEnumList({
    required List<InstancyContentActionsEnum> actions,
    required MyCourseDownloadUIActionParameterModel parameterModel,
    required LocalStr localStr,
    required MyCourseDownloadUIActionCallbackModel myLearningUIActionCallbackModel,
  }) sync* {
    // MyPrint.printOnConsole("getInstancyUIActionModelListFromInstancyContentActionsEnumList called with actions:$actions");
    for (InstancyContentActionsEnum action in actions) {
      // MyPrint.printOnConsole("action:$action");
      InstancyUIActionModel? model;

      //Secondary Actions
      if (action == InstancyContentActionsEnum.RemoveFromDownloads) {
        if (isShowAction(actionType: InstancyContentActionsEnum.RemoveFromDownloads, parameterModel: parameterModel) && myLearningUIActionCallbackModel.onRemoveFromDownloadTap != null) {
          model = InstancyUIActionModel(
            text: localStr.courseDownloadActionSheetRemoveFromDownloadAction,
            iconData: InstancyIcons.removeFromDownload,
            onTap: myLearningUIActionCallbackModel.onRemoveFromDownloadTap,
            actionsEnum: InstancyContentActionsEnum.RemoveFromDownloads,
          );
        }
      } else if (action == InstancyContentActionsEnum.CancelDownload) {
        if (isShowAction(actionType: InstancyContentActionsEnum.CancelDownload, parameterModel: parameterModel) && myLearningUIActionCallbackModel.onCancelDownloadTap != null) {
          model = InstancyUIActionModel(
            text: localStr.courseDownloadActionSheetCancelDownloadAction,
            iconData: InstancyIcons.cancelDownload,
            onTap: myLearningUIActionCallbackModel.onCancelDownloadTap,
            actionsEnum: InstancyContentActionsEnum.CancelDownload,
          );
          MyPrint.printOnConsole("cancel model:$model");
        }
      } else if (action == InstancyContentActionsEnum.PauseDownload) {
        if (isShowAction(actionType: InstancyContentActionsEnum.PauseDownload, parameterModel: parameterModel) && myLearningUIActionCallbackModel.onPauseDownloadTap != null) {
          model = InstancyUIActionModel(
            text: localStr.courseDownloadActionSheetPauseDownloadAction,
            iconData: InstancyIcons.pauseDownload,
            onTap: myLearningUIActionCallbackModel.onPauseDownloadTap,
            actionsEnum: InstancyContentActionsEnum.PauseDownload,
          );
        }
      } else if (action == InstancyContentActionsEnum.ResumeDownload) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ResumeDownload, parameterModel: parameterModel) && myLearningUIActionCallbackModel.onResumeDownloadTap != null) {
          model = InstancyUIActionModel(
            text: localStr.courseDownloadActionSheetResumeDownloadAction,
            iconData: InstancyIcons.resumeDownload,
            onTap: myLearningUIActionCallbackModel.onResumeDownloadTap,
            actionsEnum: InstancyContentActionsEnum.ResumeDownload,
          );
        }
      } else if (action == InstancyContentActionsEnum.SetComplete) {
        if (isShowAction(actionType: InstancyContentActionsEnum.SetComplete, parameterModel: parameterModel) && myLearningUIActionCallbackModel.onSetCompleteTap != null) {
          model = InstancyUIActionModel(
            text: localStr.mylearningActionsheetSetcompleteoption,
            svgImageUrl: InstancySVGImages.setComplete,
            onTap: myLearningUIActionCallbackModel.onSetCompleteTap,
            actionsEnum: InstancyContentActionsEnum.SetComplete,
          );
        }
      }

      if (model != null) yield model;
    }
  }
}
