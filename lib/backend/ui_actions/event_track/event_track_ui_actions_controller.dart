import 'package:flutter_instancy_2/backend/Catalog/catalog_provider.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/backend/profile/profile_provider.dart';
import 'package:flutter_instancy_2/backend/ui_actions/primary_secondary_actions/primary_secondary_actions.dart';
import 'package:flutter_instancy_2/models/classroom_events/data_model/EventRecordingDetailsModel.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/related_track_data_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/track_course_dto_model.dart';

import '../../../configs/app_constants.dart';
import '../../../models/app_configuration_models/data_models/local_str.dart';
import '../../../utils/my_print.dart';
import '../../../views/common/components/instancy_ui_actions/instancy_ui_actions.dart';
import '../../my_learning/my_learning_provider.dart';
import '../my_learning/my_learning_ui_action_configs.dart';
import 'event_track_ui_action_callback_model.dart';
import 'event_track_ui_action_parameter_model.dart';

typedef EventTrackUIActionTypeDef = bool Function({required EventTrackUIActionParameterModel parameterModel});

class EventTrackUIActionsController {
  late final AppProvider _appProvider;
  late final ProfileProvider _profileProvider;
  late final MyLearningProvider _myLearningProvider;
  late final CatalogProvider _catalogProvider;

  EventTrackUIActionsController({
    required AppProvider? appProvider,
    ProfileProvider? profileProvider,
    MyLearningProvider? myLearningProvider,
    CatalogProvider? catalogProvider,
  }) {
    _appProvider = appProvider ?? AppProvider();
    _profileProvider = profileProvider ?? ProfileProvider();
    _myLearningProvider = myLearningProvider ?? MyLearningProvider();
    _catalogProvider = catalogProvider ?? CatalogProvider();
    _initializeActionsMap();
  }

  Map<InstancyContentActionsEnum, EventTrackUIActionTypeDef> _actionsMap = <InstancyContentActionsEnum, EventTrackUIActionTypeDef>{};

  AppProvider get appProvider => _appProvider;

  ProfileProvider get profileProvider => _profileProvider;

  MyLearningProvider get myLearningProvider => _myLearningProvider;

  CatalogProvider get catalogProvider => _catalogProvider;

  void _initializeActionsMap() {
    _actionsMap = <InstancyContentActionsEnum, EventTrackUIActionTypeDef>{
      InstancyContentActionsEnum.Enroll: showEnroll,
      InstancyContentActionsEnum.CancelEnrollment: showCancelEnrollment,
      InstancyContentActionsEnum.Reschedule: showReschedule,
      InstancyContentActionsEnum.View: showView,
      InstancyContentActionsEnum.Play: showPlay,
      InstancyContentActionsEnum.Report: showReport,
      InstancyContentActionsEnum.Join: showJoin,
      InstancyContentActionsEnum.ViewResources: showViewResources,
      InstancyContentActionsEnum.ViewQRCode: showViewQRCode,
      InstancyContentActionsEnum.ViewRecording: showViewRecording,
      InstancyContentActionsEnum.SetComplete: showSetComplete,
    };
  }

  bool showSetComplete({required EventTrackUIActionParameterModel parameterModel}) {
    return AppConfigurationOperations(appProvider: appProvider).isShowSetComplete(
      objectTypeId: parameterModel.objectTypeId,
      mediaTypeId: parameterModel.mediaTypeId,
      contentStatus: parameterModel.actualStatus,
      profileProvider: profileProvider,
    );
  }

  bool isShowAction({required InstancyContentActionsEnum actionType, required EventTrackUIActionParameterModel parameterModel}) {
    EventTrackUIActionTypeDef? type = _actionsMap[actionType];

    if (type != null) {
      return type(parameterModel: parameterModel);
    } else {
      return false;
    }
  }

  bool showEnroll({required EventTrackUIActionParameterModel parameterModel}) {
    if (parameterModel.objectTypeId != InstancyObjectTypes.events || parameterModel.eventScheduleType != EventScheduleTypes.parent) {
      return false;
    }

    return true;
  }

  bool showCancelEnrollment({required EventTrackUIActionParameterModel parameterModel}) {
    bool isEventCompleted = (AppConfigurationOperations(appProvider: appProvider).isEventCompleted(parameterModel.eventEndDatetime) ?? true);
    MyPrint.printOnConsole("isEventCompleted in showCancelEnrollment:$isEventCompleted");

    if (parameterModel.objectTypeId != InstancyObjectTypes.events || parameterModel.eventScheduleType != EventScheduleTypes.instance || isEventCompleted) {
      return false;
    }

    return true;
  }

  bool showReschedule({required EventTrackUIActionParameterModel parameterModel}) {
    bool isEventCompleted = (AppConfigurationOperations(appProvider: appProvider).isEventCompleted(parameterModel.eventEndDatetime) ?? true);
    MyPrint.printOnConsole("isEventCompleted in showReschedule:$isEventCompleted");

    if (parameterModel.objectTypeId != InstancyObjectTypes.events || parameterModel.eventScheduleType != EventScheduleTypes.instance || isEventCompleted) {
      return false;
    }

    return true;
  }

  bool showView({required EventTrackUIActionParameterModel parameterModel}) {
    bool isShow = false;

    if ([
      InstancyObjectTypes.mediaResource,
      InstancyObjectTypes.document,
      InstancyObjectTypes.dictionaryGlossary,
      InstancyObjectTypes.html,
      InstancyObjectTypes.reference,
      InstancyObjectTypes.webPage,
      InstancyObjectTypes.certificate,
    ].contains(parameterModel.objectTypeId)) {
      if (parameterModel.objectTypeId == InstancyObjectTypes.mediaResource && (parameterModel.mediaTypeId == InstancyMediaTypes.video || parameterModel.mediaTypeId == InstancyMediaTypes.audio)) {
        isShow = false;
      } else {
        isShow = true;
      }
    } else if ([InstancyObjectTypes.externalTraining, InstancyObjectTypes.events].contains(parameterModel.objectTypeId)) {
      isShow = false;
    } else {
      isShow = true;
    }

    return isShow;
  }

  bool showPlay({required EventTrackUIActionParameterModel parameterModel}) {
    return MyLearningUIActionConfigs.isPlayEnabled(
      objectTypeId: parameterModel.objectTypeId,
      mediaTypeId: parameterModel.mediaTypeId,
    );
  }

  bool showReport({required EventTrackUIActionParameterModel parameterModel}) {
    return parameterModel.showReportAction;
  }

  bool showJoin({required EventTrackUIActionParameterModel parameterModel}) {
    bool isShow = true;

    bool isEventCompleted = (AppConfigurationOperations(appProvider: appProvider).isEventCompleted(parameterModel.eventEndDatetime) ?? true);
    MyPrint.printOnConsole("isEventCompleted in showJoin:$isEventCompleted");

    if (parameterModel.objectTypeId != InstancyObjectTypes.events || parameterModel.mediaTypeId != InstancyMediaTypes.virtualClassroomEvent || isEventCompleted) {
      isShow = false;
    }

    return isShow;
  }

  bool showViewResources({required EventTrackUIActionParameterModel parameterModel}) {
    bool isShow = true;

    if (parameterModel.objectTypeId != InstancyObjectTypes.events || !parameterModel.showRelatedContents) {
      isShow = false;
    }

    return isShow;
  }

  bool showViewQRCode({required EventTrackUIActionParameterModel parameterModel}) {
    bool isShow = true;

    if (parameterModel.objectTypeId != InstancyObjectTypes.events || !AppConfigurationOperations.isValidString(parameterModel.actionviewqrcode)) {
      isShow = false;
    }

    return isShow;
  }

  bool showViewRecording({required EventTrackUIActionParameterModel parameterModel}) {
    EventRecordingDetailsModel? recordingDetails = parameterModel.recordingDetails;

    if (recordingDetails == null) {
      MyPrint.printOnConsole("recordingDetails are null");
      return false;
    }

    bool isShowRecordingButton = true;

    if (recordingDetails.RecordingType == "URL") {
      if (recordingDetails.EventRecordingURL.isEmpty) {
        MyPrint.printOnConsole("eventrecordingurl is empty");
        isShowRecordingButton = false;
      }
    } else if (recordingDetails.RecordingType == "video") {
    } else {
      MyPrint.printOnConsole("recordingtype is invalid");
      isShowRecordingButton = false;
    }

    return isShowRecordingButton;
  }

  // region Track Contents Actions
  Iterable<InstancyUIActionModel> getTrackContentsPrimaryActions({
    required TrackCourseDTOModel contentModel,
    required LocalStr localStr,
    required EventTrackUIActionCallbackModel myLearningUIActionCallbackModel,
  }) sync* {
    // MyPrint.printOnConsole("getTrackContentsPrimaryActions called with parameterModel:$parameterModel");

    List<InstancyContentActionsEnum> primaryActions = [
      InstancyContentActionsEnum.Enroll,
      InstancyContentActionsEnum.CancelEnrollment,
      InstancyContentActionsEnum.View,
      InstancyContentActionsEnum.Play,
      InstancyContentActionsEnum.Join,
      InstancyContentActionsEnum.ViewResources,
      InstancyContentActionsEnum.ViewQRCode,
      InstancyContentActionsEnum.ViewRecording,
    ];
    // MyPrint.printOnConsole("primaryActions:$primaryActions");

    Iterable<InstancyUIActionModel> actionsList = getInstancyUIActionModelListFromInstancyContentActionsEnumList(
      viewType: contentModel.ViewTypeValue,
      objectTypeId: contentModel.ContentTypeId,
      actions: primaryActions,
      localStr: localStr,
      parameterModel: getParameterModelFromTrackCourseDTOModel(model: contentModel),
      callbackModel: myLearningUIActionCallbackModel,
    );

    if (actionsList.length > 1) {
      yield* actionsList.take(1);
    } else {
      yield* actionsList;
    }
  }

  Iterable<InstancyUIActionModel> getTrackContentsSecondaryActions({
    required TrackCourseDTOModel contentModel,
    required LocalStr localStr,
    required EventTrackUIActionCallbackModel myLearningUIActionCallbackModel,
  }) sync* {
    // MyPrint.printOnConsole("getTrackContentsSecondaryActions called with parameterModel:$parameterModel");

    List<InstancyContentActionsEnum> secondaryActions = [
      InstancyContentActionsEnum.Enroll,
      InstancyContentActionsEnum.CancelEnrollment,
      InstancyContentActionsEnum.Reschedule,
      InstancyContentActionsEnum.View,
      InstancyContentActionsEnum.Play,
      InstancyContentActionsEnum.Join,
      InstancyContentActionsEnum.Report,
      InstancyContentActionsEnum.ViewResources,
      InstancyContentActionsEnum.ViewQRCode,
      InstancyContentActionsEnum.ViewRecording,
      InstancyContentActionsEnum.SetComplete,
    ];
    // MyPrint.printOnConsole("primaryActions:$primaryActions");

    Iterable<InstancyUIActionModel> actionModels = getInstancyUIActionModelListFromInstancyContentActionsEnumList(
      viewType: contentModel.ViewTypeValue,
      objectTypeId: contentModel.ContentTypeId,
      actions: secondaryActions,
      localStr: localStr,
      parameterModel: getParameterModelFromTrackCourseDTOModel(model: contentModel),
      callbackModel: myLearningUIActionCallbackModel,
    );

    yield* actionModels;
  }

  EventTrackUIActionParameterModel getParameterModelFromTrackCourseDTOModel({required TrackCourseDTOModel model}) {
    MyPrint.printOnConsole("EventTrackContentModel status: ${model.ContentStatus} actual status : ${model.CoreLessonStatus}");
    return EventTrackUIActionParameterModel(
      objectTypeId: model.ContentTypeId,
      mediaTypeId: model.MediaTypeID,
      viewType: model.ViewTypeValue,
      eventScheduleType: model.EventScheduleType,
      actualStatus: model.CoreLessonStatus,
      eventEndDatetime: model.EventEndDateTime,
      actionviewqrcode: model.ActionViewQRcode,
      showRelatedContents: ["true", "1"].contains(model.RelatedContentLink.toLowerCase()),
      showReportAction: ["true", "1"].contains(model.ReportLink.toLowerCase()),
      recordingDetails: model.RecordingDetails,
    );
  }

  // endregion

  // region Event Related Contents Actions
  Iterable<InstancyUIActionModel> getEventRelatedContentsPrimaryActions({
    required RelatedTrackDataDTOModel contentModel,
    required LocalStr localStr,
    required EventTrackUIActionCallbackModel myLearningUIActionCallbackModel,
  }) sync* {
    // MyPrint.printOnConsole("getTrackContentsPrimaryActions called with parameterModel:$parameterModel");

    List<InstancyContentActionsEnum> primaryActions = [
      InstancyContentActionsEnum.View,
      InstancyContentActionsEnum.Play,
    ];
    // MyPrint.printOnConsole("primaryActions:$primaryActions");

    Iterable<InstancyUIActionModel> actionsList = getInstancyUIActionModelListFromInstancyContentActionsEnumList(
      viewType: contentModel.ViewType,
      objectTypeId: contentModel.ContentTypeId,
      actions: primaryActions,
      localStr: localStr,
      parameterModel: getParameterModelFromRelatedTrackDataDTOModel(model: contentModel),
      callbackModel: myLearningUIActionCallbackModel,
    );

    if (actionsList.length > 1) {
      yield* actionsList.take(1);
    } else {
      yield* actionsList;
    }
  }

  Iterable<InstancyUIActionModel> getEventRelatedContentsSecondaryActions({
    required RelatedTrackDataDTOModel contentModel,
    required LocalStr localStr,
    required EventTrackUIActionCallbackModel myLearningUIActionCallbackModel,
  }) sync* {
    // MyPrint.printOnConsole("getTrackContentsSecondaryActions called with parameterModel:$parameterModel");

    List<InstancyContentActionsEnum> secondaryActions = [
      InstancyContentActionsEnum.View,
      InstancyContentActionsEnum.Play,
      InstancyContentActionsEnum.SetComplete,
    ];
    // MyPrint.printOnConsole("primaryActions:$primaryActions");

    Iterable<InstancyUIActionModel> actionModels = getInstancyUIActionModelListFromInstancyContentActionsEnumList(
      viewType: contentModel.ViewType,
      objectTypeId: contentModel.ContentTypeId,
      actions: secondaryActions,
      localStr: localStr,
      parameterModel: getParameterModelFromRelatedTrackDataDTOModel(model: contentModel),
      callbackModel: myLearningUIActionCallbackModel,
    );

    yield* actionModels;
  }

  EventTrackUIActionParameterModel getParameterModelFromRelatedTrackDataDTOModel({required RelatedTrackDataDTOModel model}) {
    MyPrint.printOnConsole("RelatedTrackDataDTOModel status: ${model.ContentDisplayStatus} actual status : ${model.CoreLessonStatus}");
    return EventTrackUIActionParameterModel(
      objectTypeId: model.ContentTypeId,
      mediaTypeId: model.MediaTypeID,
      viewType: model.ViewType,
      actualStatus: model.CoreLessonStatus,
    );
  }

  // endregion

  Iterable<InstancyUIActionModel> getInstancyUIActionModelListFromInstancyContentActionsEnumList({
    required int viewType,
    required int objectTypeId,
    required List<InstancyContentActionsEnum> actions,
    required EventTrackUIActionParameterModel parameterModel,
    required LocalStr localStr,
    required EventTrackUIActionCallbackModel callbackModel,
  }) sync* {
    // MyPrint.printOnConsole("getInstancyUIActionModelListFromInstancyContentActionsEnumList called with actions:$actions");

    for (InstancyContentActionsEnum action in actions) {
      InstancyUIActionModel? model;

      if (action == InstancyContentActionsEnum.Enroll) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Enroll, parameterModel: parameterModel) && callbackModel.onEnrollTap != null) {
          model = InstancyUIActionModel(
            text: localStr.eventsActionsheetEnrollNowOption,
            iconData: InstancyIcons.addToMyLearning,
            actionsEnum: InstancyContentActionsEnum.Enroll,
            onTap: callbackModel.onEnrollTap,
          );
        }
      }
      else if (action == InstancyContentActionsEnum.CancelEnrollment) {
        if (isShowAction(actionType: InstancyContentActionsEnum.CancelEnrollment, parameterModel: parameterModel) && callbackModel.onCancelEnrollmentTap != null) {
          model = InstancyUIActionModel(
            text: localStr.eventsActionsheetCancelenrollmentoption,
            iconData: InstancyIcons.cancelEnrollment,
            actionsEnum: InstancyContentActionsEnum.CancelEnrollment,
            onTap: callbackModel.onCancelEnrollmentTap,
          );
        }
      }
      else if (action == InstancyContentActionsEnum.Reschedule) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Reschedule, parameterModel: parameterModel) && callbackModel.onRescheduleTap != null) {
          model = InstancyUIActionModel(
            text: localStr.mylearningActionbuttonRescheduleactionbutton,
            iconData: InstancyIcons.reschedule,
            onTap: callbackModel.onRescheduleTap,
            actionsEnum: InstancyContentActionsEnum.Reschedule,
          );
        }
      }
      else if (action == InstancyContentActionsEnum.View) {
        if (isShowAction(actionType: InstancyContentActionsEnum.View, parameterModel: parameterModel) && callbackModel.onViewTap != null) {
          model = InstancyUIActionModel(
            text: localStr.mylearningActionsheetViewoption,
            iconData: InstancyIcons.view,
            actionsEnum: InstancyContentActionsEnum.View,
            onTap: callbackModel.onViewTap,
          );
        }
      } else if (action == InstancyContentActionsEnum.Play) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Play, parameterModel: parameterModel) && callbackModel.onPlayTap != null) {
          model = InstancyUIActionModel(
            text: localStr.mylearningActionsheetPlayoption,
            iconData: InstancyIcons.play,
            onTap: callbackModel.onPlayTap,
            actionsEnum: InstancyContentActionsEnum.Play,
          );
        }
      } else if (action == InstancyContentActionsEnum.Report) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Report, parameterModel: parameterModel) && callbackModel.onReportTap != null) {
          model = InstancyUIActionModel(
            text: localStr.mylearningActionsheetReportoption,
            svgImageUrl: InstancySVGImages.report,
            onTap: callbackModel.onReportTap,
            actionsEnum: InstancyContentActionsEnum.Report,
          );
        }
      } else if (action == InstancyContentActionsEnum.Join) {
        bool isShowJoin = isShowAction(actionType: InstancyContentActionsEnum.Join, parameterModel: parameterModel);
        if (isShowJoin && callbackModel.onJoinTap != null) {
          model = InstancyUIActionModel(
            text: localStr.mylearningActionsheetJoinoption,
            iconData: InstancyIcons.join,
            onTap: callbackModel.onJoinTap,
            actionsEnum: InstancyContentActionsEnum.Join,
          );
        }
      } else if (action == InstancyContentActionsEnum.ViewResources) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ViewResources, parameterModel: parameterModel) && callbackModel.onViewResourcesTap != null) {
          model = InstancyUIActionModel(
            text: localStr.learningTrackLabelEventViewResources,
            iconData: InstancyIcons.viewResources,
            onTap: callbackModel.onViewResourcesTap,
            actionsEnum: InstancyContentActionsEnum.ViewResources,
          );
        }
      } else if (action == InstancyContentActionsEnum.ViewQRCode) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ViewQRCode, parameterModel: parameterModel) && callbackModel.onViewQRCodeTap != null) {
          model = InstancyUIActionModel(
            text: localStr.mylearningActionsheetViewqrcode,
            iconData: InstancyIcons.qrCode,
            onTap: callbackModel.onViewQRCodeTap,
            actionsEnum: InstancyContentActionsEnum.ViewQRCode,
          );
        }
      } else if (action == InstancyContentActionsEnum.ViewRecording) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ViewRecording, parameterModel: parameterModel) && callbackModel.onViewRecordingTap != null) {
          model = InstancyUIActionModel(
            text: localStr.learningtrackLabelEventviewrecording,
            iconData: InstancyIcons.viewRecording,
            onTap: callbackModel.onViewRecordingTap,
            actionsEnum: InstancyContentActionsEnum.ViewRecording,
          );
        }
      }
      else if (action == InstancyContentActionsEnum.SetComplete) {
        if (isShowAction(actionType: InstancyContentActionsEnum.SetComplete, parameterModel: parameterModel) && callbackModel.onSetCompleteTap != null) {
          model = InstancyUIActionModel(
            text: localStr.mylearningActionsheetSetcompleteoption,
            svgImageUrl: InstancySVGImages.setComplete,
            onTap: callbackModel.onSetCompleteTap,
            actionsEnum: InstancyContentActionsEnum.SetComplete,
          );
        }
      }

      if (model != null) yield model;
    }
  }
}
