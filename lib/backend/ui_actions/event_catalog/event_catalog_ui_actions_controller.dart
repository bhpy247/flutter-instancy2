import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/backend/ui_actions/event_catalog/event_catalog_ui_action_parameter_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../configs/app_constants.dart';
import '../../../models/app_configuration_models/data_models/local_str.dart';
import '../../../models/classroom_events/data_model/event_recodting_mobile_lms_data_model.dart';
import '../../../models/course/data_model/CourseDTOModel.dart';
import '../../../utils/my_print.dart';
import '../../../utils/parsing_helper.dart';
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
      InstancyContentActionsEnum.Buy: showBuy,
      InstancyContentActionsEnum.Enroll: showEnroll,
      InstancyContentActionsEnum.Details: showDetails,
      InstancyContentActionsEnum.Reschedule: showReschedule,
      InstancyContentActionsEnum.AddToCalender: showAddToMyCalendar,
      InstancyContentActionsEnum.ReEnrollmentHistory: showReEnrollmentHistory,
      InstancyContentActionsEnum.ViewQRCode: showViewQRCode,
      InstancyContentActionsEnum.ViewResources: showViewResources,
      InstancyContentActionsEnum.AddToWishlist: showAddToWishlist,
      InstancyContentActionsEnum.RemoveFromWishlist: showRemoveFromWishlist,
      InstancyContentActionsEnum.CancelEnrollment: showCancelEnrollment,
      InstancyContentActionsEnum.RecommendTo: showRecommendTo,
      InstancyContentActionsEnum.ShareToConnections: showShareWithConnection,
      InstancyContentActionsEnum.ShareWithPeople: showShareWithPeople,
      InstancyContentActionsEnum.Share: showShare,
      InstancyContentActionsEnum.Join: showJoin,
      InstancyContentActionsEnum.ReEnroll: showReEnroll,
      InstancyContentActionsEnum.ViewSessions: showViewSeries,
      InstancyContentActionsEnum.AddToWaitList: showAddToWaitList,
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

  bool showBuy({required EventCatalogUIActionParameterModel parameterModel}) {
    if (parameterModel.BuyNowLink.isEmpty || parameterModel.ViewType != ViewTypesForContent.ECommerce) {
      return false;
    }

    return true;
  }

  bool showEnroll({required EventCatalogUIActionParameterModel parameterModel}) {
    if ((parameterModel.EnrollNowLink.isNotEmpty || (parameterModel.AddLink.isNotEmpty && parameterModel.objectTypeId == InstancyObjectTypes.events && parameterModel.TitleExpired.isEmpty))) {
      return true;
    }

    return false;
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
    // (course.InstanceEventReSchedule != undefined && course.InstanceEventReSchedule != null) && course.InstanceEventReSchedule.length>0
    if (parameterModel.InstanceEventReSchedule.isNotEmpty) {
      return true;
    }

    return false;
  }

  bool showReEnroll({required EventCatalogUIActionParameterModel parameterModel}) {
    // (course.InstanceEventReSchedule != undefined && course.InstanceEventReSchedule != null) && course.InstanceEventReSchedule.length>0
    if (parameterModel.InstanceEventReclass.isNotEmpty) {
      return true;
    }

    return false;
  }

  bool showReEnrollmentHistory({required EventCatalogUIActionParameterModel parameterModel}) {
    // bool isEventCompleted = (AppConfigurationOperations(appProvider: appProvider).isEventCompleted(parameterModel.eventEndDatetime) ?? true);
    // MyPrint.printOnConsole("isEventCompleted in showCancelEnrollment:$isEventCompleted");
    // if (parameterModel.objectTypeId == InstancyObjectTypes.events && isEventCompleted) {
    //   return true;
    // }
    if (parameterModel.ReEnrollmentHistory.isNotEmpty) {
      return true;
    }
    return false;
  }

  bool showAddToWishlist({required EventCatalogUIActionParameterModel parameterModel}) {
    // bool isEnrolled = showEnroll(parameterModel: parameterModel);

    if (appProvider.appSystemConfigurationModel.enableWishlist == true && parameterModel.isWishlistContent == 0 && showEnroll(parameterModel: parameterModel)) {
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
    if (parameterModel.WaitListLink.isEmpty || parameterModel.waitListLimit == parameterModel.waitListEnroll) {
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
    if (parameterModel.RelatedContentLink.isNotEmpty) {
      return true;
    }

    return false;
  }

  bool showViewQRCode({required EventCatalogUIActionParameterModel parameterModel}) {
    if (parameterModel.objectTypeId != InstancyObjectTypes.events || !parameterModel.isAddToMyLearning || !AppConfigurationOperations.isValidString(parameterModel.actionviewqrcode)) {
      return false;
    }

    return true;
  }

  bool showJoin({required EventCatalogUIActionParameterModel parameterModel}) {
    bool isShow = true;

    bool isEventCompleted = (AppConfigurationOperations(appProvider: appProvider).isEventCompleted(parameterModel.eventEndDatetime) ?? true);
    MyPrint.printOnConsole("isEventCompleted in showJoin:$isEventCompleted");

    if (parameterModel.objectTypeId != InstancyObjectTypes.events || parameterModel.mediaTypeId != InstancyMediaTypes.virtualClassroomEvent || isEventCompleted) {
      isShow = false;
    }

    return isShow;
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

  // bool showViewSession({required EventCatalogUIActionParameterModel parameterModel}) {
  //   if (parameterModel.objectTypeId != InstancyObjectTypes.events || parameterModel.eventType != EventTypes.session) {
  //     return false;
  //   }
  //
  //   return true;
  // }
  bool showViewSessions({required EventCatalogUIActionParameterModel parameterModel}) {
    return ParsingHelper.parseStringMethod(parameterModel.ViewSessionsLink) == "True" || (parameterModel.objectTypeId == InstancyObjectTypes.events && parameterModel.EventType == EventTypes.session);
  }

  bool showViewSeries({required EventCatalogUIActionParameterModel parameterModel}) {
    // MyPrint.printOnConsole("parameterModel.EventType: showViewSeries${parameterModel.EventType}");
    return (parameterModel.EventType == EventTypes.session);
    // return true;
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
    MyPrint.printOnConsole("parameterModel.shareLink : ${parameterModel.shareLink}");
    return AppConfigurationOperations.isValidString(parameterModel.shareLink);
  }

  //region Primary Actions
  Iterable<InstancyUIActionModel> getEventCatalogScreenPrimaryActions({
    required CourseDTOModel courseDTOModel,
    required LocalStr localStr,
    required EventCatalogUIActionCallbackModel catalogUIActionCallbackModel,
    required bool isWishlistMode,
  }) sync* {
    // MyPrint.printOnConsole("getCatalogScreenPrimaryActions called with objectTypeId:${catalogCourseDTOModel.ContentTypeId},"
    //     " mediaTypeID:${catalogCourseDTOModel.MediaTypeID}, ViewType:${catalogCourseDTOModel.ViewType}, isContentEnrolled:${catalogCourseDTOModel.isContentEnrolled}");

    EventCatalogUIActionParameterModel parameterModel = getEventCatalogUIActionParameterModelFromCatalogCourseDTOModel(
      model: courseDTOModel,
      isWishlistMode: isWishlistMode,
    );

    yield* getEventCatalogScreenPrimaryActionsFromCatalogUIActionParameterModel(
      objectTypeId: courseDTOModel.ContentTypeId,
      mediaTypeId: courseDTOModel.MediaTypeID,
      viewType: courseDTOModel.ViewType,
      isContentEnrolled: ["true", "1"].contains(courseDTOModel.isContentEnrolled.toLowerCase()),
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
    required CourseDTOModel courseDTOModel,
    required LocalStr localStr,
    required EventCatalogUIActionCallbackModel eventCatalogUIActionCallbackModel,
    required bool isWishlistMode,
  }) sync* {
    MyPrint.printOnConsole("EventCatalogUIActionsController().getCatalogScreenSecondaryActions called with objectTypeId:${courseDTOModel.ContentTypeId},"
        " mediaTypeID:${courseDTOModel.MediaTypeID}, ViewType:${courseDTOModel.ViewType}");

    EventCatalogUIActionParameterModel parameterModel = getEventCatalogUIActionParameterModelFromCatalogCourseDTOModel(
      model: courseDTOModel,
      isWishlistMode: isWishlistMode,
    );

    List<InstancyContentActionsEnum> primaryActions = PrimarySecondaryActionsController.getPrimaryActionForCatalogContent(
      objectTypeId: courseDTOModel.ContentTypeId,
      mediaTypeId: courseDTOModel.MediaTypeID,
      viewType: courseDTOModel.ViewType,
    );
    List<InstancyContentActionsEnum> secondaryActions = PrimarySecondaryActionsController.getSecondaryActionForCatalogContent(
      objectTypeId: courseDTOModel.ContentTypeId,
      mediaTypeId: courseDTOModel.MediaTypeID,
      viewType: courseDTOModel.ViewType,
    );
    MyPrint.printOnConsole("primaryActions:$primaryActions");

    Set<InstancyContentActionsEnum> set = {};
    set.addAll(primaryActions);
    set.addAll(secondaryActions);

    MyPrint.printOnConsole("Final secondaryActions:$set");

    yield* getInstancyUIActionModelListFromInstancyContentActionsEnumList(
      objectTypeId: courseDTOModel.ContentTypeId,
      viewType: courseDTOModel.ViewType,
      actions: set.toList(),
      parameterModel: parameterModel,
      isContentEnrolled: ["true", "1"].contains(courseDTOModel.isContentEnrolled.toLowerCase()),
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
    required CourseDTOModel model,
    required bool isWishlistMode,
  }) {
    return EventCatalogUIActionParameterModel(
      objectTypeId: model.ContentTypeId,
      mediaTypeId: model.MediaTypeID,
      viewType: model.ViewType,
      waitListEnroll: model.WaitListEnrolls,
      waitListLimit: model.WaitListLimit,
      WaitListLink: model.WaitListLink,
      RelatedContentLink: model.RelatedContentLink,
      eventScheduleType: model.EventScheduleType,
      ViewSessionsLink: model.ViewSessionsLink,
      EventType: model.EventType,
      reportaction: "",
      suggestToConnectionsLink: model.SuggesttoConnLink,
      suggestWithFriendLink: model.SuggestwithFriendLink,
      shareLink: model.Sharelink,
      actualStatus: model.ActualStatus,
      eventStartDatetime: model.EventStartDateTime,
      eventEndDatetime: model.EventEndDateTime,
      isAddToMyLearning: ["true", "1"].contains(model.isContentEnrolled.toLowerCase()),
      eventRecording: model.EventRecording,
      eventType: model.EventType,
      isWishlistContent: model.isWishListContent,
      parentId: model.InstanceParentContentID,
      ViewType: model.ViewType,
      isWishlistMode: false,
      hasRelatedContents: model.AddLink.startsWith("addrecommenedrelatedcontent"),
      isContentEnrolled: model.isContentEnrolled.toLowerCase() == "1" || model.isContentEnrolled.toLowerCase() == "true",
      bit4: model.bit4,
      ViewLink: model.ViewLink,
      AddLink: model.AddLink,
      BuyNowLink: model.BuyNowLink,
      EnrollNowLink: model.EnrollNowLink,
      TitleExpired: "",
      DetailsLink: model.DetailsLink,
      cancelEventLink: model.CancelEventlink,
      eventenddatetime: model.EventEndDateTime,
      InstanceEventReSchedule: model.InstanceEventReSchedule,
      InstanceEventReclass: model.InstanceEventReclass,
      ReEnrollmentHistory: model.ReEnrollmentHistory,
      waitListLink: model.WaitListLink,
      RecommendedLink: "",
      AddToWishlist: "",
      RemoveFromWishList: "",
      IsRelatedcontent: model.IsRelatedcontent,
      ShareToRecommend: model.SharetoRecommendedLink,
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
      if (action == InstancyContentActionsEnum.Buy) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Buy, parameterModel: parameterModel) && catalogUIActionCallbackModel.onBuyTap != null) {
          model = InstancyUIActionModel(
            text: localStr.catalogActionsheetBuyoption,
            iconData: InstancyIcons.buy,
            onTap: catalogUIActionCallbackModel.onBuyTap,
            actionsEnum: InstancyContentActionsEnum.Buy,
          );
        }
      } else if (action == InstancyContentActionsEnum.Enroll) {
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
      } else if (action == InstancyContentActionsEnum.ReEnroll) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ReEnroll, parameterModel: parameterModel) && catalogUIActionCallbackModel.onReEnrollTap != null) {
          model = InstancyUIActionModel(
            text: localStr.eventsActionSheetReEnrollOption,
            iconData: InstancyIcons.reEnroll,
            onTap: catalogUIActionCallbackModel.onRescheduleTap,
            actionsEnum: InstancyContentActionsEnum.Reschedule,
          );
        }
      } else if (action == InstancyContentActionsEnum.ReEnrollmentHistory) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ReEnrollmentHistory, parameterModel: parameterModel) && catalogUIActionCallbackModel.onReEnrollmentHistoryTap != null) {
          model = InstancyUIActionModel(
            text: localStr.eventsActionSheetReEnrollmentHistoryOption,
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
            text: localStr.eventsActionsheetRelatedcontentoption,
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
            text: localStr.eventsActionSheetViewSeriesOption,
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
