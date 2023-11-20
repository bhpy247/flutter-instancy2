import 'package:flutter_chat_bot/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/backend/profile/profile_provider.dart';
import 'package:flutter_instancy_2/backend/ui_actions/my_learning/my_learning_ui_action_configs.dart';
import 'package:flutter_instancy_2/backend/ui_actions/primary_secondary_actions/primary_secondary_actions.dart';

import '../../../configs/app_constants.dart';
import '../../../models/app_configuration_models/data_models/local_str.dart';
import '../../../models/course/data_model/CourseDTOModel.dart';
import '../../../utils/my_print.dart';
import '../../../views/common/components/instancy_ui_actions/instancy_ui_actions.dart';
import '../../my_learning/my_learning_provider.dart';
import 'my_learning_ui_action_callback_model.dart';
import 'my_learning_ui_action_parameter_model.dart';

typedef MyLearningUIActionTypeDef = bool Function({required MyLearningUIActionParameterModel parameterModel});

class MyLearningUIActionsController {
  late final AppProvider _appProvider;
  late final ProfileProvider _profileProvider;
  late final MyLearningProvider _myLearningProvider;

  MyLearningUIActionsController({
    required AppProvider? appProvider,
    required ProfileProvider? profileProvider,
    required MyLearningProvider? myLearningProvider,
  }) {
    _appProvider = appProvider ?? AppProvider();
    _profileProvider = profileProvider ?? ProfileProvider();
    _myLearningProvider = myLearningProvider ?? MyLearningProvider();
    _initializeActionsMap();
  }

  Map<InstancyContentActionsEnum, MyLearningUIActionTypeDef> _actionsMap = <InstancyContentActionsEnum, MyLearningUIActionTypeDef>{};

  AppProvider get appProvider => _appProvider;

  ProfileProvider get profileProvider => _profileProvider;

  MyLearningProvider get myLearningProvider => _myLearningProvider;

  void _initializeActionsMap() {
    _actionsMap = <InstancyContentActionsEnum, MyLearningUIActionTypeDef>{
      InstancyContentActionsEnum.Enroll: showEnroll,
      InstancyContentActionsEnum.View: showView,
      InstancyContentActionsEnum.ViewResources: showViewResources,
      InstancyContentActionsEnum.Join: showJoin,
      InstancyContentActionsEnum.Play: showPlay,
      InstancyContentActionsEnum.Details: showDetails,
      InstancyContentActionsEnum.Report: showReport,
      InstancyContentActionsEnum.Notes: showNotes,
      InstancyContentActionsEnum.AddToCalender: showAddToCalender,
      InstancyContentActionsEnum.SetComplete: showSetComplete,
      InstancyContentActionsEnum.CancelEnrollment: showCancelEnrollment,
      InstancyContentActionsEnum.Archive: showArchieve,
      InstancyContentActionsEnum.Unarchive: showUnArchieve,
      InstancyContentActionsEnum.Delete: showDelete,
      InstancyContentActionsEnum.Reschedule: showReschedule,
      InstancyContentActionsEnum.ViewCertificate: showCertificate,
      InstancyContentActionsEnum.ViewQRCode: showQRCode,
      InstancyContentActionsEnum.ViewSessions: showViewSessions,
      InstancyContentActionsEnum.ViewRecording: showViewRecording,
      InstancyContentActionsEnum.ShareToConnections: showShareWithConnection,
      InstancyContentActionsEnum.ShareWithPeople: showShareWithPeople,
      InstancyContentActionsEnum.Share: showShare,
      InstancyContentActionsEnum.ReEnrollmentHistory: showReEnrollmentHistory,
    };
  }

  bool isShowAction({required InstancyContentActionsEnum actionType, required MyLearningUIActionParameterModel parameterModel}) {
    MyLearningUIActionTypeDef? type = _actionsMap[actionType];

    if (type != null) {
      return type(parameterModel: parameterModel);
    } else {
      return false;
    }
  }

  bool showEnroll({required MyLearningUIActionParameterModel parameterModel}) {
    if (parameterModel.objectTypeId != InstancyObjectTypes.events || parameterModel.eventScheduleType != EventScheduleTypes.parent) {
      return false;
    }

    return true;
  }

  bool showView({required MyLearningUIActionParameterModel parameterModel}) {
    if (parameterModel.ViewLink.isNotEmpty) {
      return true;
    }

    return false;
  }

  bool showViewResources({required MyLearningUIActionParameterModel parameterModel}) {
    if (parameterModel.RelatedContentLink.isNotEmpty || parameterModel.IsRelatedcontent.toLowerCase() == 'true') {
      return true;
    }

    return false;
  }

  bool showJoin({required MyLearningUIActionParameterModel parameterModel}) {
    MyPrint.printOnConsole("MyLearningUIActionParameterModel status : ${parameterModel.actualStatus}");

    MyPrint.printOnConsole("showJoin called with Endtime:${parameterModel.eventenddatetime}");
    bool? isEventCompleted = AppConfigurationOperations(appProvider: appProvider).isEventCompleted(
      parameterModel.eventenddatetime,
      dateFormat: appProvider.appSystemConfigurationModel.eventDateTimeFormat,
    );
    MyPrint.printOnConsole("isEventCompleted:$isEventCompleted");

    if (parameterModel.objectTypeId != InstancyObjectTypes.events || parameterModel.mediaTypeId != InstancyMediaTypes.virtualClassroomEvent || (isEventCompleted ?? true)) {
      return false;
    }

    return true;
  }

  bool showPlay({required MyLearningUIActionParameterModel parameterModel}) {
    return MyLearningUIActionConfigs.isPlayEnabled(
      objectTypeId: parameterModel.objectTypeId,
      mediaTypeId: parameterModel.mediaTypeId,
    );
  }

  bool showDetails({required MyLearningUIActionParameterModel parameterModel}) {
    if (parameterModel.DetailsLink.isNotEmpty) {
      return true;
    }

    return false;
  }

  bool showNotes({required MyLearningUIActionParameterModel parameterModel}) {
    if ([InstancyObjectTypes.track, InstancyObjectTypes.assessment, InstancyObjectTypes.contentObject].contains(parameterModel.objectTypeId)) {
      return true;
    }
    return false;
  }

  bool showReport({required MyLearningUIActionParameterModel parameterModel}) {
    if ([
      InstancyObjectTypes.mediaResource,
      InstancyObjectTypes.document,
      InstancyObjectTypes.dictionaryGlossary,
      InstancyObjectTypes.html,
      InstancyObjectTypes.aICC,
      InstancyObjectTypes.webPage,
      InstancyObjectTypes.certificate,
      // InstancyMediaTypes.microLearning,
      // InstancyObjectTypes.contentObject,
      InstancyObjectTypes.events,
      InstancyObjectTypes.externalTraining,
      InstancyObjectTypes.reference,
      // InstancyObjectTypes.scorm1_2,
      // InstancyObjectTypes.track,
      InstancyObjectTypes.assignment,
      // InstancyObjectTypes.cmi5,
    ].contains(parameterModel.objectTypeId)) {
      return false;
    }

    return true;
  }

  bool showReEnrollmentHistory({required MyLearningUIActionParameterModel parameterModel}) {
    // bool isEventCompleted = (AppConfigurationOperations(appProvider: appProvider).isEventCompleted(parameterModel.eventEndDatetime) ?? true);
    // MyPrint.printOnConsole("isEventCompleted in showCancelEnrollment:$isEventCompleted");
    // if (parameterModel.objectTypeId == InstancyObjectTypes.events && isEventCompleted) {
    //   return true;
    // }
    if (parameterModel.ReEnrollmentHistoryLink.isNotEmpty) {
      return true;
    }
    return false;
  }

  bool showAddToCalender({required MyLearningUIActionParameterModel parameterModel}) {
    bool? isEventCompleted = AppConfigurationOperations(appProvider: appProvider).isEventCompleted(
      parameterModel.eventenddatetime,
      dateFormat: appProvider.appSystemConfigurationModel.eventDateTimeFormat,
    );
    MyPrint.printOnConsole("isEventCompleted:$isEventCompleted");

    if (parameterModel.objectTypeId == InstancyObjectTypes.events && !(isEventCompleted ?? true)) {
      return true;
    }

    return false;
  }

  bool showSetComplete({required MyLearningUIActionParameterModel parameterModel}) {
    return AppConfigurationOperations(appProvider: appProvider).isShowSetComplete(
      objectTypeId: parameterModel.objectTypeId,
      mediaTypeId: parameterModel.mediaTypeId,
      contentStatus: parameterModel.actualStatus,
      profileProvider: profileProvider,
    );
  }

  bool showCancelEnrollment({required MyLearningUIActionParameterModel parameterModel}) {
    if (parameterModel.CancelEventLink.isNotEmpty && ([null, 0, false].contains(parameterModel.bit4))) {
      return true;
    }

    return false;
  }

  bool showArchieve({required MyLearningUIActionParameterModel parameterModel}) {
    return myLearningProvider.archieveEnabled.get() && !parameterModel.isArchived;
  }

  bool showUnArchieve({required MyLearningUIActionParameterModel parameterModel}) {
    return myLearningProvider.archieveEnabled.get() && parameterModel.isArchived;
  }

  bool showDelete({required MyLearningUIActionParameterModel parameterModel}) {
    return (parameterModel.objectTypeId == InstancyObjectTypes.events && parameterModel.bit4 == true) || parameterModel.removeLink.isNotEmpty;
  }

  bool showRemove({required MyLearningUIActionParameterModel parameterModel}) {
    return (parameterModel.objectTypeId == InstancyObjectTypes.events && parameterModel.bit4 == true) || parameterModel.removeLink.isNotEmpty;
  }

  bool showReschedule({required MyLearningUIActionParameterModel parameterModel}) {
    if (parameterModel.InstanceEventReSchedule.isNotEmpty) {
      return true;
    }

    return false;
  }

  bool showCertificate({required MyLearningUIActionParameterModel parameterModel}) {
    if (parameterModel.CertificateLink.isNotEmpty) {
      return true;
    }
    return false;
  }

  bool showQRCode({required MyLearningUIActionParameterModel parameterModel}) {
    return AppConfigurationOperations.isValidString(parameterModel.ActionViewQRcode);
  }

  bool showViewSessions({required MyLearningUIActionParameterModel parameterModel}) {
    return ParsingHelper.parseStringMethod(parameterModel.ViewSessionsLink) == "True" || (parameterModel.objectTypeId == InstancyObjectTypes.events && parameterModel.EventType == EventTypes.session);
    // return true;
  }

  bool showViewRecording({required MyLearningUIActionParameterModel parameterModel}) {
    MyPrint.printOnConsole("showViewRecording called with eventRecording:${parameterModel.eventRecording}");

    return parameterModel.eventRecording != null;
  }

  bool showShareWithConnection({required MyLearningUIActionParameterModel parameterModel}) {
    return AppConfigurationOperations.isValidString(parameterModel.suggestToConnectionsLink);
  }

  bool showShareWithPeople({required MyLearningUIActionParameterModel parameterModel}) {
    return AppConfigurationOperations.isValidString(parameterModel.suggestWithFriendLink);
  }

  bool showShare({required MyLearningUIActionParameterModel parameterModel}) {
    return AppConfigurationOperations.isValidString(parameterModel.shareLink);
  }

  //region Primary Actions
  Iterable<InstancyUIActionModel> getMyLearningScreenPrimaryActions({
    required CourseDTOModel model,
    required LocalStr localStr,
    required MyLearningUIActionCallbackModel myLearningUIActionCallbackModel,
  }) sync* {
    // MyPrint.printOnConsole("getMyLearningScreenPrimaryActions called with objectTypeId:${myLearningCourseDTOModel.ContentTypeId},"
    //     " mediaTypeID:${myLearningCourseDTOModel.MediaTypeID}, ViewType:${myLearningCourseDTOModel.ViewType}, Name:${myLearningCourseDTOModel.TitleName}");

    MyLearningUIActionParameterModel parameterModel = getMyLearningUIActionParameterModelFromCourseDTOModel(model: model);

    yield* getMyLearningScreenPrimaryActionsFromMyLearningUIActionParameterModel(
      objectTypeId: model.ContentTypeId,
      mediaTypeId: model.MediaTypeID,
      viewType: model.ViewType,
      parameterModel: parameterModel,
      localStr: localStr,
      myLearningUIActionCallbackModel: myLearningUIActionCallbackModel,
    );
  }

  Iterable<InstancyUIActionModel> getMyLearningScreenPrimaryActionsFromMyLearningUIActionParameterModel({
    required int viewType,
    required int objectTypeId,
    required int mediaTypeId,
    required MyLearningUIActionParameterModel parameterModel,
    required LocalStr localStr,
    required MyLearningUIActionCallbackModel myLearningUIActionCallbackModel,
  }) sync* {
    // MyPrint.printOnConsole("getMyLearningScreenPrimaryActionsFromMyLearningUIActionParameterModel called with parameterModel:$parameterModel");

    List<InstancyContentActionsEnum> primaryActions = PrimarySecondaryActionsController.getPrimaryActionForMyLearningContent(
      viewType: viewType,
      objectTypeId: objectTypeId,
      mediaTypeId: mediaTypeId,
    );
    // MyPrint.printOnConsole("primaryActions:$primaryActions");

    yield* getInstancyUIActionModelListFromInstancyContentActionsEnumList(
      viewType: viewType,
      objectTypeId: objectTypeId,
      actions: primaryActions,
      parameterModel: parameterModel,
      localStr: localStr,
      myLearningUIActionCallbackModel: myLearningUIActionCallbackModel,
    );
  }

  //endregion

  //region Secondary Actions
  Iterable<InstancyUIActionModel> getMyLearningScreenSecondaryActions({
    required CourseDTOModel myLearningCourseDTOModel,
    required LocalStr localStr,
    required MyLearningUIActionCallbackModel myLearningUIActionCallbackModel,
  }) sync* {
    MyPrint.printOnConsole("getMyLearningScreenSecondaryActions called with objectTypeId:${myLearningCourseDTOModel.ContentTypeId},"
        " mediaTypeID:${myLearningCourseDTOModel.MediaTypeID}");

    MyLearningUIActionParameterModel parameterModel = getMyLearningUIActionParameterModelFromCourseDTOModel(model: myLearningCourseDTOModel);

    List<InstancyContentActionsEnum> actions1 = PrimarySecondaryActionsController.getPrimaryActionForMyLearningContent(
      mediaTypeId: myLearningCourseDTOModel.MediaTypeID,
      objectTypeId: myLearningCourseDTOModel.ContentTypeId,
      viewType: myLearningCourseDTOModel.ViewType,
    );

    List<InstancyContentActionsEnum> actions2 = PrimarySecondaryActionsController.getSecondaryActionForMyLearningContent(
      mediaTypeId: myLearningCourseDTOModel.MediaTypeID,
      objectTypeId: myLearningCourseDTOModel.ContentTypeId,
      viewType: myLearningCourseDTOModel.ViewType,
    );
    Set<InstancyContentActionsEnum> set = {};
    set.addAll(actions1);
    set.addAll(actions2);

    MyPrint.printOnConsole("secondaryActions:$set");

    yield* getInstancyUIActionModelListFromInstancyContentActionsEnumList(
      objectTypeId: myLearningCourseDTOModel.ContentTypeId,
      viewType: myLearningCourseDTOModel.ViewType,
      actions: set.toList(),
      parameterModel: parameterModel,
      localStr: localStr,
      myLearningUIActionCallbackModel: myLearningUIActionCallbackModel,
    );
  }

  Iterable<InstancyUIActionModel> getMyLearningScreenSecondaryActionsFromMyLearningUIActionParameterModel({
    required int viewType,
    required int objectTypeId,
    required int mediaTypeId,
    required MyLearningUIActionParameterModel parameterModel,
    required LocalStr localStr,
    required MyLearningUIActionCallbackModel myLearningUIActionCallbackModel,
  }) sync* {
    // MyPrint.printOnConsole("getMyLearningScreenSecondaryActionsFromMyLearningUIActionParameterModel called with parameterModel:$parameterModel");

    List<InstancyContentActionsEnum> actions1 = PrimarySecondaryActionsController.getPrimaryActionForMyLearningContent(
      mediaTypeId: mediaTypeId,
      objectTypeId: objectTypeId,
      viewType: mediaTypeId,
    );

    List<InstancyContentActionsEnum> actions2 = PrimarySecondaryActionsController.getSecondaryActionForMyLearningContent(
      mediaTypeId: mediaTypeId,
      objectTypeId: objectTypeId,
      viewType: mediaTypeId,
    );
    Set<InstancyContentActionsEnum> set = {};
    set.addAll(actions1);
    set.addAll(actions2);

    MyPrint.printOnConsole("secondaryActions:$set");

    yield* getInstancyUIActionModelListFromInstancyContentActionsEnumList(
      viewType: viewType,
      objectTypeId: objectTypeId,
      actions: set.toList(),
      parameterModel: parameterModel,
      localStr: localStr,
      myLearningUIActionCallbackModel: myLearningUIActionCallbackModel,
    );
  }

  //endregion

  MyLearningUIActionParameterModel getMyLearningUIActionParameterModelFromCourseDTOModel({
    required CourseDTOModel model,
  }) {
    return MyLearningUIActionParameterModel(
      objectTypeId: model.ContentTypeId,
      mediaTypeId: model.MediaTypeID,
      CancelEventLink: model.CancelEventLink,
      bit4: model.bit4,
      ViewLink: model.ViewLink,
      DetailsLink: model.DetailsLink,
      eventenddatetime: model.EventEndDateTime,
      EventType: model.EventType,
      eventScheduleType: model.EventScheduleType,
      RelatedContentLink: model.RelatedContentLink,
      IsRelatedcontent: model.IsRelatedcontent,
      actualStatus: model.ActualStatus,
      eventStartDatetime: model.EventStartDateTime,
      isArchived: model.IsArchived,
      removeLink: model.RemoveLink,
      eventRecording: model.RecordingDetails,
      InstanceEventReSchedule: model.InstanceEventReSchedule,
      CertificateLink: model.CertificateLink,
      ActionViewQRcode: model.ActionViewQRcode,
      suggestToConnectionsLink: model.SuggesttoConnLink,
      suggestWithFriendLink: model.SuggestwithFriendLink,
      shareLink: model.Sharelink,
      ViewSessionsLink: model.ViewSessionsLink,
      ReEnrollmentHistoryLink: model.ReEnrollmentHistory,
    );
  }

  Iterable<InstancyUIActionModel> getInstancyUIActionModelListFromInstancyContentActionsEnumList({
    required int viewType,
    required int objectTypeId,
    required List<InstancyContentActionsEnum> actions,
    required MyLearningUIActionParameterModel parameterModel,
    required LocalStr localStr,
    required MyLearningUIActionCallbackModel myLearningUIActionCallbackModel,
  }) sync* {
    // MyPrint.printOnConsole("getInstancyUIActionModelListFromInstancyContentActionsEnumList called with actions:$actions");
    for (InstancyContentActionsEnum action in actions) {
      InstancyUIActionModel? model;

      //Primary Actions
      if (action == InstancyContentActionsEnum.Enroll) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Enroll, parameterModel: parameterModel) && myLearningUIActionCallbackModel.onEnrollTap != null) {
          model = InstancyUIActionModel(
            text: localStr.eventsActionsheetEnrollNowOption,
            iconData: InstancyIcons.addToMyLearning,
            actionsEnum: InstancyContentActionsEnum.Enroll,
            onTap: myLearningUIActionCallbackModel.onEnrollTap,
          );
        }
      } else if (action == InstancyContentActionsEnum.View) {
        if (isShowAction(actionType: InstancyContentActionsEnum.View, parameterModel: parameterModel) && myLearningUIActionCallbackModel.onViewTap != null) {
          model = InstancyUIActionModel(
            text: localStr.mylearningActionsheetViewoption,
            iconData: InstancyIcons.view,
            actionsEnum: InstancyContentActionsEnum.View,
            onTap: myLearningUIActionCallbackModel.onViewTap,
          );
        }
      } else if (action == InstancyContentActionsEnum.Details) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Details, parameterModel: parameterModel) && myLearningUIActionCallbackModel.onDetailsTap != null) {
          model = InstancyUIActionModel(
            text: localStr.mylearningActionsheetDetailsoption,
            iconData: InstancyIcons.details,
            onTap: myLearningUIActionCallbackModel.onDetailsTap,
            actionsEnum: InstancyContentActionsEnum.Details,
          );
        }
      } else if (action == InstancyContentActionsEnum.Join) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Join, parameterModel: parameterModel) && myLearningUIActionCallbackModel.onJoinTap != null) {
          model = InstancyUIActionModel(
            text: localStr.mylearningActionsheetJoinoption,
            iconData: InstancyIcons.join,
            onTap: myLearningUIActionCallbackModel.onJoinTap,
            actionsEnum: InstancyContentActionsEnum.Join,
          );
        }
      } else if (action == InstancyContentActionsEnum.NA) {
      }

      //Secondary Actions
      else if (action == InstancyContentActionsEnum.Play) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Play, parameterModel: parameterModel) && myLearningUIActionCallbackModel.onPlayTap != null) {
          model = InstancyUIActionModel(
            text: localStr.mylearningActionsheetPlayoption,
            iconData: InstancyIcons.play,
            onTap: myLearningUIActionCallbackModel.onPlayTap,
            actionsEnum: InstancyContentActionsEnum.Play,
          );
        }
      } else if (action == InstancyContentActionsEnum.Report) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Report, parameterModel: parameterModel) && myLearningUIActionCallbackModel.onReportTap != null) {
          model = InstancyUIActionModel(
            text: localStr.mylearningActionsheetReportoption,
            svgImageUrl: InstancySVGImages.report,
            onTap: myLearningUIActionCallbackModel.onReportTap,
            actionsEnum: InstancyContentActionsEnum.Report,
          );
        }
      }
      else if (action == InstancyContentActionsEnum.Notes) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Notes, parameterModel: parameterModel) && myLearningUIActionCallbackModel.onNoteTap != null) {
          model = InstancyUIActionModel(
            text: "Note",
            iconData: InstancyIcons.notes,
            onTap: myLearningUIActionCallbackModel.onNoteTap,
            actionsEnum: InstancyContentActionsEnum.Notes,
          );
        }
      } else if (action == InstancyContentActionsEnum.ViewResources) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ViewResources, parameterModel: parameterModel) && myLearningUIActionCallbackModel.onViewResourcesTap != null) {
          model = InstancyUIActionModel(
            text: localStr.eventsActionsheetRelatedcontentoption,
            iconData: InstancyIcons.relatedContent,
            actionsEnum: InstancyContentActionsEnum.ViewResources,
            onTap: myLearningUIActionCallbackModel.onViewResourcesTap,
          );
        }
      } else if (action == InstancyContentActionsEnum.AddToCalender) {
        if (isShowAction(actionType: InstancyContentActionsEnum.AddToCalender, parameterModel: parameterModel) && myLearningUIActionCallbackModel.onAddToCalenderTap != null) {
          model = InstancyUIActionModel(
            text: localStr.mylearningActionsheetAddtocalendaroption,
            iconData: InstancyIcons.addToCalender,
            onTap: myLearningUIActionCallbackModel.onAddToCalenderTap,
            actionsEnum: InstancyContentActionsEnum.AddToCalender,
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
      } else if (action == InstancyContentActionsEnum.CancelEnrollment) {
        if (isShowAction(actionType: InstancyContentActionsEnum.CancelEnrollment, parameterModel: parameterModel) && myLearningUIActionCallbackModel.onCancelEnrollmentTap != null) {
          model = InstancyUIActionModel(
            text: localStr.mylearningActionsheetCancelenrollmentoption,
            iconData: InstancyIcons.cancelEnrollment,
            onTap: myLearningUIActionCallbackModel.onCancelEnrollmentTap,
            actionsEnum: InstancyContentActionsEnum.CancelEnrollment,
          );
        }
      } else if (action == InstancyContentActionsEnum.Archive) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Archive, parameterModel: parameterModel) && myLearningUIActionCallbackModel.onArchiveTap != null) {
          model = InstancyUIActionModel(
            text: localStr.mylearningActionsheetArchiveoption,
            iconData: InstancyIcons.archieve,
            onTap: myLearningUIActionCallbackModel.onArchiveTap,
            actionsEnum: InstancyContentActionsEnum.Archive,
          );
        }
      } else if (action == InstancyContentActionsEnum.Unarchive) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Unarchive, parameterModel: parameterModel) && myLearningUIActionCallbackModel.onUnArchiveTap != null) {
          model = InstancyUIActionModel(
            text: localStr.mylearningActionsheetUnarchiveoption,
            iconData: InstancyIcons.archieve,
            onTap: myLearningUIActionCallbackModel.onUnArchiveTap,
            actionsEnum: InstancyContentActionsEnum.Unarchive,
          );
        }
      } else if (action == InstancyContentActionsEnum.Delete) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Delete, parameterModel: parameterModel) && myLearningUIActionCallbackModel.onRemoveTap != null) {
          model = InstancyUIActionModel(
            text: localStr.mylearningActionsheetRemovefrommylearning,
            iconData: InstancyIcons.remove,
            onTap: myLearningUIActionCallbackModel.onRemoveTap,
            actionsEnum: InstancyContentActionsEnum.Delete,
          );
        }
      } else if (action == InstancyContentActionsEnum.Reschedule) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Reschedule, parameterModel: parameterModel) && myLearningUIActionCallbackModel.onRescheduleTap != null) {
          model = InstancyUIActionModel(
            text: localStr.mylearningActionbuttonRescheduleactionbutton,
            iconData: InstancyIcons.reschedule,
            onTap: myLearningUIActionCallbackModel.onRescheduleTap,
            actionsEnum: InstancyContentActionsEnum.Reschedule,
          );
        }
      } else if (action == InstancyContentActionsEnum.ViewCertificate) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ViewCertificate, parameterModel: parameterModel) && myLearningUIActionCallbackModel.onCertificateTap != null) {
          model = InstancyUIActionModel(
            text: localStr.mylearningActionsheetViewcertificateoption,
            svgImageUrl: InstancySVGImages.certificate,
            onTap: myLearningUIActionCallbackModel.onCertificateTap,
            actionsEnum: InstancyContentActionsEnum.ViewCertificate,
          );
        }
      } else if (action == InstancyContentActionsEnum.ViewQRCode) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ViewQRCode, parameterModel: parameterModel) && myLearningUIActionCallbackModel.onQRCodeTap != null) {
          model = InstancyUIActionModel(
            text: localStr.mylearningActionsheetViewqrcode,
            iconData: InstancyIcons.qrCode,
            onTap: myLearningUIActionCallbackModel.onQRCodeTap,
            actionsEnum: InstancyContentActionsEnum.ViewQRCode,
          );
        }
      } else if (action == InstancyContentActionsEnum.ViewSessions) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ViewSessions, parameterModel: parameterModel) && myLearningUIActionCallbackModel.onViewSessionsTap != null) {
          model = InstancyUIActionModel(
            text: localStr.viewSessionsLabel,
            svgImageUrl: "assets/myLearning/viewSessionIcon.svg",
            iconSize: 20,
            onTap: myLearningUIActionCallbackModel.onViewSessionsTap,
            actionsEnum: InstancyContentActionsEnum.ViewSessions,
          );
        }
      } else if (action == InstancyContentActionsEnum.ReEnrollmentHistory) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ReEnrollmentHistory, parameterModel: parameterModel) && myLearningUIActionCallbackModel.onReEnrollmentHistoryTap != null) {
          model = InstancyUIActionModel(
            text: localStr.eventsActionSheetReEnrollmentHistoryOption,
            iconData: InstancyIcons.ReEnrollmentHistory,
            onTap: myLearningUIActionCallbackModel.onReEnrollmentHistoryTap,
            actionsEnum: InstancyContentActionsEnum.ReEnrollmentHistory,
          );
        }
      } else if (action == InstancyContentActionsEnum.ShareToConnections) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ShareToConnections, parameterModel: parameterModel) && myLearningUIActionCallbackModel.onShareWithConnectionTap != null) {
          model = InstancyUIActionModel(
            text: "Share with Connection",
            iconData: InstancyIcons.shareWithConnection,
            onTap: myLearningUIActionCallbackModel.onShareWithConnectionTap,
            actionsEnum: InstancyContentActionsEnum.ShareToConnections,
          );
        }
      } else if (action == InstancyContentActionsEnum.ShareWithPeople) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ShareWithPeople, parameterModel: parameterModel) && myLearningUIActionCallbackModel.onShareWithPeopleTap != null) {
          model = InstancyUIActionModel(
            text: "Share with People",
            iconData: InstancyIcons.shareWithPeople,
            onTap: myLearningUIActionCallbackModel.onShareWithPeopleTap,
            actionsEnum: InstancyContentActionsEnum.ShareWithPeople,
          );
        }
      } else if (action == InstancyContentActionsEnum.Share) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Share, parameterModel: parameterModel) && myLearningUIActionCallbackModel.onShareTap != null) {
          model = InstancyUIActionModel(
            text: localStr.mylearningActionsheetShareoption,
            iconData: InstancyIcons.share,
            onTap: myLearningUIActionCallbackModel.onShareTap,
            actionsEnum: InstancyContentActionsEnum.Share,
          );
        }
      } else if (action == InstancyContentActionsEnum.ViewRecording) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ViewRecording, parameterModel: parameterModel) && myLearningUIActionCallbackModel.onViewRecordingTap != null) {
          model = InstancyUIActionModel(
            text: localStr.learningtrackLabelEventviewrecording,
            iconData: InstancyIcons.viewRecording,
            onTap: myLearningUIActionCallbackModel.onViewRecordingTap,
            actionsEnum: InstancyContentActionsEnum.ViewRecording,
          );
        }
      }

      if (model != null) yield model;
    }
  }
}
