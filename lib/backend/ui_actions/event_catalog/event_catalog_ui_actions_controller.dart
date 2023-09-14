import 'package:flutter_chat_bot/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/backend/ui_actions/event_catalog/event_catalog_ui_action_parameter_model.dart';
import 'package:flutter_instancy_2/models/course/data_model/mobile_lms_course_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../configs/app_constants.dart';
import '../../../models/app_configuration_models/data_models/local_str.dart';
import '../../../models/classroom_events/data_model/event_recodting_mobile_lms_data_model.dart';
import '../../../utils/my_print.dart';
import '../../../views/common/components/instancy_ui_actions/instancy_ui_actions.dart';
import '../primary_secondary_actions/primary_secondary_actions.dart';
import 'event_catalog_ui_action_callback_model.dart';

typedef EventCatalogUIActionTypeDef = bool Function({required EventCatalogUIActionParameterModel parameterModel});

class EventCatalogUIActionsController {
  late final AppProvider _appProvider;

  EventCatalogUIActionsController({
    required AppProvider? appProvider,
  }) {
    _appProvider = appProvider ?? AppProvider();
    // _myLearningProvider = myLearningProvider ?? MyLearningProvider();
    _initializeActionsMap();
  }

  Map<InstancyContentActionsEnum, EventCatalogUIActionTypeDef> _actionsMap = <InstancyContentActionsEnum, EventCatalogUIActionTypeDef>{};

  AppProvider get appProvider => _appProvider;

  void _initializeActionsMap() {
    _actionsMap = <InstancyContentActionsEnum, EventCatalogUIActionTypeDef>{
      InstancyContentActionsEnum.Enroll: showEnroll,
      InstancyContentActionsEnum.Details: showDetails,
      InstancyContentActionsEnum.Reschedule: showReschedule,
      InstancyContentActionsEnum.AddToCalender: showAddToMyCalendar,
      InstancyContentActionsEnum.ReEnrollmentHistory: showReEnrollmentHistory,
      InstancyContentActionsEnum.ViewQRCode: showViewQRCode,
      InstancyContentActionsEnum.ViewResources: showViewResources,
      InstancyContentActionsEnum.AddToWishlist: showAddToWishlist,
      InstancyContentActionsEnum.RemoveFromWishlist: showRemoveFromWishlist,
      InstancyContentActionsEnum.AddToWaitList: showAddToWaitList,
      InstancyContentActionsEnum.CancelEnrollment: showCancelEnrollment,
      InstancyContentActionsEnum.RecommendTo: showRecommendTo,
      InstancyContentActionsEnum.ShareToConnections: showShareWithConnection,
      InstancyContentActionsEnum.ShareWithPeople: showShareWithPeople,
      InstancyContentActionsEnum.Share: showShare,
      InstancyContentActionsEnum.Join: showJoin,
      InstancyContentActionsEnum.ViewSessions: showViewSession,
    };
  }

  bool isShowAction({required InstancyContentActionsEnum actionType, required EventCatalogUIActionParameterModel parameterModel}) {
    EventCatalogUIActionTypeDef? type = _actionsMap[actionType];

    if (type != null) {
      return type(parameterModel: parameterModel);
    } else {
      return false;
    }
  }

  bool showDetails({required EventCatalogUIActionParameterModel parameterModel}) {
    return true;
  }

  bool showEnroll({required EventCatalogUIActionParameterModel parameterModel}) {
    bool isEventCompleted = (AppConfigurationOperations(appProvider: appProvider).isEventCompleted(parameterModel.eventEndDatetime) ?? true);
    // MyPrint.printOnConsole("EventStartDate in showEnroll:${parameterModel.eventStartDatetime}");
    // MyPrint.printOnConsole("isEventCompleted in showEnroll:$isEventCompleted");

    if (parameterModel.objectTypeId != InstancyObjectTypes.events || parameterModel.isAddToMyLearning || [EventScheduleTypes.parent].contains(parameterModel.eventScheduleType) || isEventCompleted) {
      return false;
    }

    return true;
  }

  bool showCancelEnrollment({required EventCatalogUIActionParameterModel parameterModel}) {
    bool isEventCompleted = (AppConfigurationOperations(appProvider: appProvider).isEventCompleted(parameterModel.eventEndDatetime) ?? true);
    // MyPrint.printOnConsole("isEventCompleted in showCancelEnrollment:$isEventCompleted");

    if (parameterModel.objectTypeId != InstancyObjectTypes.events || !parameterModel.isAddToMyLearning || parameterModel.eventScheduleType == EventScheduleTypes.parent || isEventCompleted) {
      return false;
    }

    return true;
  }

  bool showReschedule({required EventCatalogUIActionParameterModel parameterModel}) {
    bool isEventCompleted = (AppConfigurationOperations(appProvider: appProvider).isEventCompleted(parameterModel.eventEndDatetime) ?? true);
    // MyPrint.printOnConsole("isEventCompleted in showReschedule:$isEventCompleted");

    if (parameterModel.objectTypeId != InstancyObjectTypes.events || !parameterModel.isAddToMyLearning || parameterModel.eventScheduleType != EventScheduleTypes.instance || isEventCompleted) {
      return false;
    }

    return true;
  }

  bool showReEnrollmentHistory({required EventCatalogUIActionParameterModel parameterModel}) {
    // bool isEventCompleted = (AppConfigurationOperations(appProvider: appProvider).isEventCompleted(parameterModel.eventEndDatetime) ?? true);
    // MyPrint.printOnConsole("isEventCompleted in showCancelEnrollment:$isEventCompleted");
    // if (parameterModel.objectTypeId == InstancyObjectTypes.events && isEventCompleted) {
    //   return true;
    // }
    return false;
  }

  bool showAddToWishlist({required EventCatalogUIActionParameterModel parameterModel}) {
    if (appProvider.appSystemConfigurationModel.enableWishlist == true && parameterModel.isWishlistContent == 0) {
      return true;
    }
    return false;
  }

  bool showRemoveFromWishlist({required EventCatalogUIActionParameterModel parameterModel}) {
    if (appProvider.appSystemConfigurationModel.enableWishlist == true && parameterModel.isWishlistContent == 1) {
      return true;
    }
    return false;
  }

  bool showAddToWaitList({required EventCatalogUIActionParameterModel parameterModel}) {
    if (!parameterModel.actionWaitList || parameterModel.waitListLimit == parameterModel.waitListEnroll) {
      return false;
    }

    return true;
  }

  bool showAddToMyCalendar({required EventCatalogUIActionParameterModel parameterModel}) {
    bool isEventCompleted = (AppConfigurationOperations(appProvider: appProvider).isEventCompleted(parameterModel.eventEndDatetime) ?? true);
    if (parameterModel.objectTypeId != InstancyObjectTypes.events || isEventCompleted || !parameterModel.isAddToMyLearning) {
      return false;
    }

    return true;
  }

  bool showViewResources({required EventCatalogUIActionParameterModel parameterModel}) {
    if (parameterModel.objectTypeId != InstancyObjectTypes.events || !parameterModel.isAddToMyLearning || parameterModel.relatedConentCount <= 0) {
      return false;
    }

    return true;
  }

  bool showViewQRCode({required EventCatalogUIActionParameterModel parameterModel}) {
    if (parameterModel.objectTypeId != InstancyObjectTypes.events || !parameterModel.isAddToMyLearning || !AppConfigurationOperations.isValidString(parameterModel.actionviewqrcode)) {
      return false;
    }

    return true;
  }

  bool showJoin({required EventCatalogUIActionParameterModel parameterModel}) {
    bool isEventCompleted = (AppConfigurationOperations(appProvider: appProvider).isEventCompleted(parameterModel.eventEndDatetime) ?? true);
    // MyPrint.printOnConsole("isEventCompleted in showJoin:$isEventCompleted");

    if (parameterModel.objectTypeId != InstancyObjectTypes.events || parameterModel.mediaTypeId != InstancyMediaTypes.virtualClassroomEvent || !parameterModel.isAddToMyLearning || isEventCompleted) {
      return false;
    }

    return true;
  }

  bool showViewRecording({required EventCatalogUIActionParameterModel parameterModel}) {
    EventRecordingMobileLMSDataModel? recordingDetails = parameterModel.recordingDetails;

    if (recordingDetails == null) {
      MyPrint.printOnConsole("recordingDetails are null");
      return false;
    }

    if (recordingDetails.recordingtype == "URL") {
      if (recordingDetails.eventrecordingurl.isEmpty) {
        MyPrint.printOnConsole("eventrecordingurl is empty");
        return false;
      }
    } else if (recordingDetails.recordingtype == "video") {
    } else {
      MyPrint.printOnConsole("recordingtype is invalid");
      return false;
    }

    return true;
  }

  bool showViewSession({required EventCatalogUIActionParameterModel parameterModel}) {
    if (parameterModel.objectTypeId != InstancyObjectTypes.events || parameterModel.eventType != EventTypes.session) {
      return false;
    }

    return true;
  }

  bool showRecommendTo({required EventCatalogUIActionParameterModel parameterModel}) {
    return true;
    // return AppConfigurationOperations.isValidString(parameterModel.RecommendedLink);
  }

  bool showShareWithConnection({required EventCatalogUIActionParameterModel parameterModel}) {
    return AppConfigurationOperations.isValidString(parameterModel.suggestToConnectionsLink);
  }

  bool showShareWithPeople({required EventCatalogUIActionParameterModel parameterModel}) {
    return AppConfigurationOperations.isValidString(parameterModel.suggestWithFriendLink);
  }

  bool showShare({required EventCatalogUIActionParameterModel parameterModel}) {
    return AppConfigurationOperations.isValidString(parameterModel.shareLink);
  }

  //region Primary Actions
  Iterable<InstancyUIActionModel> getEventCatalogScreenPrimaryActions({
    required MobileLmsCourseModel mobileLmsCourseDTOModel,
    required LocalStr localStr,
    required EventCatalogUIActionCallbackModel catalogUIActionCallbackModel,
    required bool isWishlistMode,
  }) sync* {
    // MyPrint.printOnConsole("getCatalogScreenPrimaryActions called with objectTypeId:${catalogCourseDTOModel.ContentTypeId},"
    //     " mediaTypeID:${catalogCourseDTOModel.MediaTypeID}, ViewType:${catalogCourseDTOModel.ViewType}, isContentEnrolled:${catalogCourseDTOModel.isContentEnrolled}");

    EventCatalogUIActionParameterModel parameterModel = getEventCatalogUIActionParameterModelFromCatalogCourseDTOModel(
      model: mobileLmsCourseDTOModel,
      isWishlistMode: isWishlistMode,
    );

    yield* getEventCatalogScreenPrimaryActionsFromCatalogUIActionParameterModel(
      objectTypeId: mobileLmsCourseDTOModel.objecttypeid,
      mediaTypeId: mobileLmsCourseDTOModel.mediatypeid,
      viewType: mobileLmsCourseDTOModel.viewtype,
      isContentEnrolled: mobileLmsCourseDTOModel.iscontent,
      parameterModel: parameterModel,
      localStr: localStr,
      catalogUIActionCallbackModel: catalogUIActionCallbackModel,
    );
  }

  Iterable<InstancyUIActionModel> getEventCatalogScreenPrimaryActionsFromCatalogUIActionParameterModel({
    required int viewType,
    required int objectTypeId,
    required int mediaTypeId,
    required bool isContentEnrolled,
    required EventCatalogUIActionParameterModel parameterModel,
    required LocalStr localStr,
    required EventCatalogUIActionCallbackModel catalogUIActionCallbackModel,
  }) sync* {
    // MyPrint.printOnConsole("getCatalogScreenPrimaryActionsFromEventCatalogUIActionParameterModel called with parameterModel:$parameterModel");

    List<InstancyContentActionsEnum> primaryActions = PrimarySecondaryActionsController.getPrimaryActionForCatalogContent(
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
      isContentEnrolled: isContentEnrolled,
      localStr: localStr,
      catalogUIActionCallbackModel: catalogUIActionCallbackModel,
    );
  }

  //endregion

  //region Secondary Actions
  Iterable<InstancyUIActionModel> getEventCatalogScreenSecondaryActions({
    required MobileLmsCourseModel mobileLmsCourseModel,
    required LocalStr localStr,
    required EventCatalogUIActionCallbackModel eventCatalogUIActionCallbackModel,
    required bool isWishlistMode,
  }) sync* {
    MyPrint.printOnConsole("EventCatalogUIActionsController().getCatalogScreenSecondaryActions called with objectTypeId:${mobileLmsCourseModel.objecttypeid},"
        " mediaTypeID:${mobileLmsCourseModel.mediatypeid}, ViewType:${mobileLmsCourseModel.viewtype}");

    EventCatalogUIActionParameterModel parameterModel = getEventCatalogUIActionParameterModelFromCatalogCourseDTOModel(
      model: mobileLmsCourseModel,
      isWishlistMode: isWishlistMode,
    );

    List<InstancyContentActionsEnum> primaryActions = PrimarySecondaryActionsController.getPrimaryActionForCatalogContent(
      viewType: mobileLmsCourseModel.viewtype,
      objectTypeId: mobileLmsCourseModel.objecttypeid,
      mediaTypeId: mobileLmsCourseModel.mediatypeid,
    );
    List<InstancyContentActionsEnum> secondaryActions = PrimarySecondaryActionsController.getSecondaryActionForCatalogContent(
      viewType: mobileLmsCourseModel.viewtype,
      objectTypeId: mobileLmsCourseModel.objecttypeid,
      mediaTypeId: mobileLmsCourseModel.mediatypeid,
    );
    MyPrint.printOnConsole("primaryActions:$primaryActions");
    MyPrint.printOnConsole("secondaryActions:$secondaryActions");

    Set<InstancyContentActionsEnum> set = {};
    set.addAll(primaryActions);
    set.addAll(secondaryActions);

    MyPrint.printOnConsole("Final secondaryActions:$set");

    yield* getInstancyUIActionModelListFromInstancyContentActionsEnumList(
      viewType: mobileLmsCourseModel.viewtype,
      objectTypeId: mobileLmsCourseModel.objecttypeid,
      actions: set.toList(),
      parameterModel: parameterModel,
      isContentEnrolled: mobileLmsCourseModel.iscontent,
      localStr: localStr,
      catalogUIActionCallbackModel: eventCatalogUIActionCallbackModel,
    );
  }

  Iterable<InstancyUIActionModel> getCatalogScreenSecondaryActionsFromCatalogUIActionParameterModel({
    required int viewType,
    required int objectTypeId,
    required int mediaTypeId,
    required bool isContentEnrolled,
    required EventCatalogUIActionParameterModel parameterModel,
    required LocalStr localStr,
    required EventCatalogUIActionCallbackModel catalogUIActionCallbackModel,
  }) sync* {
    // MyPrint.printOnConsole("getCatalogScreenSecondaryActionsFromCatalogUIActionParameterModel called with parameterModel:$parameterModel");

    List<InstancyContentActionsEnum> secondaryActions = PrimarySecondaryActionsController.getSecondaryActionForCatalogContent(
      viewType: viewType,
      objectTypeId: objectTypeId,
      mediaTypeId: mediaTypeId,
    );

    yield* getInstancyUIActionModelListFromInstancyContentActionsEnumList(
      viewType: viewType,
      objectTypeId: objectTypeId,
      actions: secondaryActions,
      parameterModel: parameterModel,
      isContentEnrolled: isContentEnrolled,
      localStr: localStr,
      catalogUIActionCallbackModel: catalogUIActionCallbackModel,
    );
  }

  //endregion

  EventCatalogUIActionParameterModel getEventCatalogUIActionParameterModelFromCatalogCourseDTOModel({
    required MobileLmsCourseModel model,
    required bool isWishlistMode,
  }) {
    return EventCatalogUIActionParameterModel(
        objectTypeId: model.objecttypeid,
        mediaTypeId: model.mediatypeid,
        viewType: model.viewtype,
      waitListEnroll: model.waitlistenrolls,
      waitListLimit: ParsingHelper.parseIntMethod(model.waitlistlimit),
      actionWaitList: ParsingHelper.parseBoolMethod(model.actionwaitlist),
      relatedConentCount: model.relatedconentcount,
      eventScheduleType: model.eventscheduletype,
      reportaction: "",
      suggestToConnectionsLink: " ",
      suggestWithFriendLink: " ",
      shareLink: " ",
      actualStatus: model.actualstatus,
      eventStartDatetime: model.eventstartdatetime,
      eventEndDatetime: model.eventenddatetime,
      isAddToMyLearning: model.isaddedtomylearning == 1,
      eventRecording: model.eventrecording,
      eventType: model.eventtype,
      isWishlistContent: ParsingHelper.parseIntMethod(model.iswishlistcontent),
      parentId: model.instanceparentcontentid,
      // actionviewqrcode: model.actionviewqrcode,
        // recordingDetails: model.recordingModel,
        );
  }

  Iterable<InstancyUIActionModel> getInstancyUIActionModelListFromInstancyContentActionsEnumList({
    required int viewType,
    required int objectTypeId,
    required List<InstancyContentActionsEnum> actions,
    required EventCatalogUIActionParameterModel parameterModel,
    required bool isContentEnrolled,
    required LocalStr localStr,
    required EventCatalogUIActionCallbackModel catalogUIActionCallbackModel,
  }) sync* {
    // MyPrint.printOnConsole("getInstancyUIActionModelListFromInstancyContentActionsEnumList called with Actions:$actions");
    // MyPrint.printOnConsole("isContentEnrolled:$isContentEnrolled");

    for (InstancyContentActionsEnum action in actions) {
      InstancyUIActionModel? model;

      //Primary Actions
      if (action == InstancyContentActionsEnum.Enroll) {
        // MyPrint.printOnConsole("isShowAction(actionType: InstancyContentActionsEnum.AddToMyLearning, parameterModel: parameterModel):${isShowAction(actionType: InstancyContentActionsEnum.AddToMyLearning, parameterModel: parameterModel)}");
        // MyPrint.printOnConsole("showAddToMyLearning(parameterModel: parameterModel):${showAddToMyLearning(parameterModel: parameterModel)}");
        if (isShowAction(actionType: InstancyContentActionsEnum.Enroll, parameterModel: parameterModel)) {
          model = InstancyUIActionModel(
            text: localStr.eventsActionsheetEnrolloption,
            iconData: InstancyIcons.addToMyLearning,
            onTap: catalogUIActionCallbackModel.onEnrollTap,
            actionsEnum: InstancyContentActionsEnum.Enroll,
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
      }

      //Secondary Actions
      else if (action == InstancyContentActionsEnum.CancelEnrollment) {
        if (isShowAction(actionType: InstancyContentActionsEnum.CancelEnrollment, parameterModel: parameterModel) && catalogUIActionCallbackModel.onCancelEnrollmentTap != null) {
          model = InstancyUIActionModel(
            text: localStr.eventsActionsheetCancelenrollmentoption,
            iconData: InstancyIcons.cancelEnrollment,
            onTap: catalogUIActionCallbackModel.onCancelEnrollmentTap,
            actionsEnum: InstancyContentActionsEnum.CancelEnrollment,
          );
        }
      } else if (action == InstancyContentActionsEnum.Reschedule) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Reschedule, parameterModel: parameterModel) && catalogUIActionCallbackModel.onRescheduleTap != null) {
          model = InstancyUIActionModel(
            text: localStr.mylearningActionbuttonRescheduleactionbutton,
            iconData: InstancyIcons.reschedule,
            onTap: catalogUIActionCallbackModel.onRescheduleTap,
            actionsEnum: InstancyContentActionsEnum.Reschedule,
          );
        }
      } else if (action == InstancyContentActionsEnum.ReEnrollmentHistory) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ReEnrollmentHistory, parameterModel: parameterModel) && catalogUIActionCallbackModel.onReEnrollmentHistoryTap != null) {
          model = InstancyUIActionModel(
            text: localStr.mylearningActionbuttonRescheduleactionbutton,
            iconData: InstancyIcons.ReEnrollmentHistory,
            onTap: catalogUIActionCallbackModel.onReEnrollmentHistoryTap,
            actionsEnum: InstancyContentActionsEnum.ReEnrollmentHistory,
          );
        }
      } else if (action == InstancyContentActionsEnum.AddToWishlist) {
        if (isShowAction(actionType: InstancyContentActionsEnum.AddToWishlist, parameterModel: parameterModel) && catalogUIActionCallbackModel.onAddToWishlist != null) {
          model = InstancyUIActionModel(
            text: localStr.catalogActionsheetWishlistoption,
            iconData: InstancyIcons.addToWishlist,
            onTap: catalogUIActionCallbackModel.onAddToWishlist,
            actionsEnum: InstancyContentActionsEnum.AddToWishlist,
          );
        }
      } else if (action == InstancyContentActionsEnum.RemoveFromWishlist) {
        // MyPrint.printOnConsole("Checking RemoveFromWishlist:${parameterModel.RemoveFromWishList}");
        if (isShowAction(actionType: InstancyContentActionsEnum.RemoveFromWishlist, parameterModel: parameterModel) && catalogUIActionCallbackModel.onRemoveWishlist != null) {
          model = InstancyUIActionModel(
            text: localStr.catalogActionsheetRemovefromwishlistoption,
            iconData: InstancyIcons.removeFromWishlist,
            onTap: catalogUIActionCallbackModel.onRemoveWishlist,
            actionsEnum: InstancyContentActionsEnum.RemoveFromWishlist,
          );
        }
      } else if (action == InstancyContentActionsEnum.AddToWaitList) {
        if (isShowAction(actionType: InstancyContentActionsEnum.AddToWaitList, parameterModel: parameterModel) && catalogUIActionCallbackModel.onAddToWaitListTap != null) {
          model = InstancyUIActionModel(
            text: localStr.eventsActionsheetWaitlistoption,
            iconData: InstancyIcons.waitList,
            onTap: catalogUIActionCallbackModel.onAddToWaitListTap,
            actionsEnum: InstancyContentActionsEnum.AddToWaitList,
          );
        }
      } else if (action == InstancyContentActionsEnum.AddToCalender) {
        if (isShowAction(actionType: InstancyContentActionsEnum.AddToCalender, parameterModel: parameterModel) && catalogUIActionCallbackModel.onAddToCalenderTap != null) {
          model = InstancyUIActionModel(
            text: localStr.detailsButtonAddtocalendarbutton,
            iconData: InstancyIcons.addToCalender,
            onTap: catalogUIActionCallbackModel.onAddToCalenderTap,
            actionsEnum: InstancyContentActionsEnum.AddToCalender,
          );
        }
      } else if (action == InstancyContentActionsEnum.ViewResources) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ViewResources, parameterModel: parameterModel) && catalogUIActionCallbackModel.onViewResources != null) {
          model = InstancyUIActionModel(
            text: localStr.learningTrackLabelEventViewResources,
            iconData: InstancyIcons.viewResources,
            onTap: catalogUIActionCallbackModel.onViewResources,
            actionsEnum: InstancyContentActionsEnum.ViewResources,
          );
        }
      } else if (action == InstancyContentActionsEnum.ViewQRCode) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ViewQRCode, parameterModel: parameterModel) && catalogUIActionCallbackModel.onViewQRCodeTap != null) {
          model = InstancyUIActionModel(
            text: localStr.mylearningActionsheetViewqrcode,
            iconData: InstancyIcons.qrCode,
            onTap: catalogUIActionCallbackModel.onViewQRCodeTap,
            actionsEnum: InstancyContentActionsEnum.ViewQRCode,
          );
        }
      } else if (action == InstancyContentActionsEnum.Join) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Join, parameterModel: parameterModel) && catalogUIActionCallbackModel.onJoinTap != null) {
          model = InstancyUIActionModel(
            text: localStr.eventsActionsheetJoinoption,
            iconData: InstancyIcons.join,
            onTap: catalogUIActionCallbackModel.onJoinTap,
            actionsEnum: InstancyContentActionsEnum.Join,
          );
        }
      } else if (action == InstancyContentActionsEnum.ViewRecording) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ViewRecording, parameterModel: parameterModel) && catalogUIActionCallbackModel.onViewRecordingTap != null) {
          model = InstancyUIActionModel(
            text: localStr.learningtrackLabelEventviewrecording,
            iconData: InstancyIcons.viewRecording,
            onTap: catalogUIActionCallbackModel.onViewRecordingTap,
            actionsEnum: InstancyContentActionsEnum.ViewRecording,
          );
        }
      } else if (action == InstancyContentActionsEnum.ViewSessions) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ViewSessions, parameterModel: parameterModel) && catalogUIActionCallbackModel.onViewSessionsTap != null) {
          model = InstancyUIActionModel(
            text: localStr.viewSessionsLabel,
            iconData: InstancyIcons.viewSessions,
            onTap: catalogUIActionCallbackModel.onViewSessionsTap,
            actionsEnum: InstancyContentActionsEnum.ViewSessions,
          );
        }
      } else if (action == InstancyContentActionsEnum.RecommendTo) {
        if (isShowAction(actionType: InstancyContentActionsEnum.RecommendTo, parameterModel: parameterModel) && catalogUIActionCallbackModel.onRecommendToTap != null) {
          model = InstancyUIActionModel(
            text: "Recommend To",
            iconData: FontAwesomeIcons.share,
            onTap: catalogUIActionCallbackModel.onRecommendToTap,
            actionsEnum: InstancyContentActionsEnum.RecommendTo,
          );
        }
      } else if (action == InstancyContentActionsEnum.ShareToConnections) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ShareToConnections, parameterModel: parameterModel) && catalogUIActionCallbackModel.onShareWithConnectionTap != null) {
          model = InstancyUIActionModel(
            text: "Share with Connection",
            iconData: InstancyIcons.shareWithConnection,
            onTap: catalogUIActionCallbackModel.onShareWithConnectionTap,
            actionsEnum: InstancyContentActionsEnum.ShareToConnections,
          );
        }
      } else if (action == InstancyContentActionsEnum.ShareWithPeople) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ShareWithPeople, parameterModel: parameterModel) && catalogUIActionCallbackModel.onShareWithPeopleTap != null) {
          model = InstancyUIActionModel(
            text: "Share with People",
            iconData: InstancyIcons.shareWithPeople,
            onTap: catalogUIActionCallbackModel.onShareWithPeopleTap,
            actionsEnum: InstancyContentActionsEnum.ShareWithPeople,
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
      }
      if (model != null) yield model;
    }
  }
}