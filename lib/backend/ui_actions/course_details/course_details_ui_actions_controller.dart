import 'package:flutter_instancy_2/backend/Catalog/catalog_provider.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/backend/profile/profile_provider.dart';
import 'package:flutter_instancy_2/backend/ui_actions/catalog/catalog_ui_action_callback_model.dart';
import 'package:flutter_instancy_2/backend/ui_actions/catalog/catalog_ui_action_parameter_model.dart';
import 'package:flutter_instancy_2/backend/ui_actions/catalog/catalog_ui_actions_controller.dart';
import 'package:flutter_instancy_2/backend/ui_actions/course_details/course_details_ui_action_callback_model.dart';
import 'package:flutter_instancy_2/backend/ui_actions/my_learning/my_learning_ui_action_callback_model.dart';
import 'package:flutter_instancy_2/backend/ui_actions/my_learning/my_learning_ui_action_parameter_model.dart';
import 'package:flutter_instancy_2/backend/ui_actions/my_learning/my_learning_ui_actions_controller.dart';
import 'package:flutter_instancy_2/backend/ui_actions/primary_secondary_actions/primary_secondary_actions.dart';

import '../../../configs/app_constants.dart';
import '../../../models/app_configuration_models/data_models/local_str.dart';
import '../../../models/course/data_model/CourseDTOModel.dart';
import '../../../utils/my_print.dart';
import '../../../views/common/components/instancy_ui_actions/instancy_ui_actions.dart';
import '../../my_learning/my_learning_provider.dart';
import '../my_learning/my_learning_ui_action_configs.dart';
import 'course_details_ui_action_parameter_model.dart';

typedef CourseDetailsUIActionTypeDef = bool Function({required CourseDetailsUIActionParameterModel parameterModel});

class CourseDetailsUIActionsController {
  late final AppProvider _appProvider;
  late final ProfileProvider _profileProvider;
  late final MyLearningProvider _myLearningProvider;
  late final CatalogProvider _catalogProvider;

  CourseDetailsUIActionsController({
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

  Map<InstancyContentActionsEnum, CourseDetailsUIActionTypeDef> _actionsMap = <InstancyContentActionsEnum, CourseDetailsUIActionTypeDef>{};

  AppProvider get appProvider => _appProvider;

  ProfileProvider get profileProvider => _profileProvider;

  MyLearningProvider get myLearningProvider => _myLearningProvider;

  CatalogProvider get catalogProvider => _catalogProvider;

  void _initializeActionsMap() {
    _actionsMap = <InstancyContentActionsEnum, CourseDetailsUIActionTypeDef>{
      InstancyContentActionsEnum.Buy: showBuy,
      InstancyContentActionsEnum.AddToMyLearning: showAddToMyLearning,
      InstancyContentActionsEnum.Enroll: showEnroll,
      InstancyContentActionsEnum.Join: showJoin,
      InstancyContentActionsEnum.CancelEnrollment: showCancelEnrollment,
      InstancyContentActionsEnum.View: showView,
      InstancyContentActionsEnum.Play: showPlay,
    };
  }

  bool isShowAction({required InstancyContentActionsEnum actionType, required CourseDetailsUIActionParameterModel parameterModel}) {
    CourseDetailsUIActionTypeDef? type = _actionsMap[actionType];
    if (type != null) {
      return type(parameterModel: parameterModel);
    } else {
      return false;
    }
  }

  bool showBuy({required CourseDetailsUIActionParameterModel parameterModel}) {
    if (parameterModel.isContentEnrolled ||
        [ViewTypesForContent.View, ViewTypesForContent.Subscription, ViewTypesForContent.ViewAndAddToMyLearning].contains(parameterModel.viewType) ||
        parameterModel.objectTypeId == InstancyObjectTypes.events) {
      return false;
    }

    return true;
  }

  bool showAddToMyLearning({required CourseDetailsUIActionParameterModel parameterModel}) {
    if (parameterModel.isContentEnrolled ||
        [ViewTypesForContent.View, ViewTypesForContent.ECommerce, ViewTypesForContent.ViewAndAddToMyLearning].contains(parameterModel.viewType) ||
        parameterModel.objectTypeId == InstancyObjectTypes.events) {
      return false;
    }

    return true;
  }

  bool showEnroll({required CourseDetailsUIActionParameterModel parameterModel}) {
    /*if ((parameterModel.EnrollNowLink.isNotEmpty || (parameterModel.AddLink.isNotEmpty && parameterModel.objectTypeId == InstancyObjectTypes.events && parameterModel.TitleExpired.isEmpty))) {
      return true;
    }

    return false;*/

    bool isEventCompleted = (AppConfigurationOperations(appProvider: appProvider).isEventCompleted(
          parameterModel.eventEndDateTime,
          dateFormat: "MM/dd/yyyy HH:mm:ss aa",
        ) ??
        true);
    MyPrint.printOnConsole("isEventCompleted in showEnroll:$isEventCompleted");
    MyPrint.printOnConsole("eventScheduleType in showEnroll:${parameterModel.eventScheduleType}");
    MyPrint.printOnConsole("isContentEnrolled in showEnroll:${parameterModel.isContentEnrolled}");

    if (parameterModel.objectTypeId != InstancyObjectTypes.events ||
        isEventCompleted ||
        parameterModel.eventScheduleType == EventScheduleTypes.instance ||
        (parameterModel.eventScheduleType == EventScheduleTypes.regular && parameterModel.isContentEnrolled)) {
      return false;
    }

    return true;
  }

  bool showJoin({required CourseDetailsUIActionParameterModel parameterModel}) {
    bool isEventCompleted = (AppConfigurationOperations(appProvider: appProvider).isEventCompleted(
          parameterModel.eventEndDateTime,
          dateFormat: "MM/dd/yyyy HH:mm:ss aa",
        ) ??
        true);
    MyPrint.printOnConsole("isEventCompleted in showJoin:$isEventCompleted");

    if (parameterModel.objectTypeId != InstancyObjectTypes.events || parameterModel.mediaTypeId != InstancyMediaTypes.virtualClassroomEvent || isEventCompleted) {
      return false;
    }
    MyPrint.printOnConsole("Show in Join");

    return true;
  }

  bool showCancelEnrollment({required CourseDetailsUIActionParameterModel parameterModel}) {
    bool isEventCompleted = (AppConfigurationOperations(appProvider: appProvider).isEventCompleted(
          parameterModel.eventEndDateTime,
          dateFormat: "MM/dd/yyyy HH:mm:ss aa",
        ) ??
        true);
    MyPrint.printOnConsole("isEventCompleted in showCancelEnrollment:$isEventCompleted");

    if (parameterModel.objectTypeId != InstancyObjectTypes.events || isEventCompleted || parameterModel.eventScheduleType == EventScheduleTypes.parent || !parameterModel.isContentEnrolled) {
      return false;
    }

    return true;
  }

  bool showView({required CourseDetailsUIActionParameterModel parameterModel}) {
    bool isShow = true;

    if (([ViewTypesForContent.ECommerce, ViewTypesForContent.Subscription].contains(parameterModel.viewType) && !parameterModel.isContentEnrolled) ||
        parameterModel.objectTypeId == InstancyObjectTypes.events ||
        MyLearningUIActionConfigs.isPlayEnabled(objectTypeId: parameterModel.objectTypeId, mediaTypeId: parameterModel.mediaTypeId)) {
      isShow = false;
    }

    return isShow;
  }

  bool showPlay({required CourseDetailsUIActionParameterModel parameterModel}) {
    if (([ViewTypesForContent.ECommerce, ViewTypesForContent.Subscription].contains(parameterModel.viewType) && !parameterModel.isContentEnrolled) ||
        !MyLearningUIActionConfigs.isPlayEnabled(objectTypeId: parameterModel.objectTypeId, mediaTypeId: parameterModel.mediaTypeId)) {
      return false;
    }

    return true;
  }

  // Iterable<InstancyUIActionModel> getCourseDetailsPrimaryActions({
  //   required CourseDTOModel contentDetailsDTOModel,
  //   required InstancyContentScreenType screenType,
  //   required LocalStr localStr,
  //   required MyLearningUIActionCallbackModel myLearningUIActionCallbackModel,
  //   required CatalogUIActionCallbackModel catalogUIActionCallbackModel,
  // }) sync* {
  //   MyPrint.printOnConsole("getCourseDetailsSecondaryActions called with objectTypeId:${contentDetailsDTOModel.ContentTypeId},"
  //       " mediaTypeID:${contentDetailsDTOModel.MediaTypeID}, screenType:$screenType");
  //
  //   if(screenType == InstancyContentScreenType.MyLearning)  {
  //     yield* MyLearningUIActionsController(
  //       appProvider: appProvider,
  //       profileProvider: profileProvider,
  //       myLearningProvider: myLearningProvider,
  //     ).getMyLearningScreenPrimaryActionsFromMyLearningUIActionParameterModel(
  //       objectTypeId: contentDetailsDTOModel.ContentTypeId,
  //       mediaTypeId: contentDetailsDTOModel.MediaTypeID,
  //       viewType: contentDetailsDTOModel.ViewType,
  //       localStr: localStr,
  //       myLearningUIActionCallbackModel: myLearningUIActionCallbackModel,
  //       parameterModel: getMyLearningUIActionParameterModelFromCourseDTOModel(model: contentDetailsDTOModel),
  //     );
  //   }
  //   else if(screenType == InstancyContentScreenType.Catalog)  {
  //     yield* CatalogUIActionsController(appProvider: appProvider).getCatalogScreenPrimaryActionsFromCatalogUIActionParameterModel(
  //       objectTypeId: contentDetailsDTOModel.ContentTypeId,
  //       mediaTypeId: contentDetailsDTOModel.MediaTypeID,
  //       viewType: contentDetailsDTOModel.ViewType,
  //       isContentEnrolled: contentDetailsDTOModel.isContentEnrolled,
  //       localStr: localStr,
  //       catalogUIActionCallbackModel: catalogUIActionCallbackModel,
  //       parameterModel: getCatalogUIActionParameterModelFromCourseDTOModel(model: contentDetailsDTOModel),
  //     );
  //   }
  // }

  /*Iterable<InstancyUIActionModel> getCourseDetailsPrimaryActions({
    required CourseDTOModel contentDetailsDTOModel,
    required InstancyContentScreenType screenType,
    required LocalStr localStr,
    required CourseDetailsUIActionCallbackModel callBackModel,
  }) sync* {
    MyPrint.printOnConsole("getCourseDetailsPrimaryActions called with objectTypeId:${contentDetailsDTOModel.ContentTypeId},"
        " mediaTypeID:${contentDetailsDTOModel.MediaTypeID}, ViewType:${contentDetailsDTOModel.ViewType}, screenType:$screenType");
    List<InstancyContentActionsEnum> primaryActions = [
      InstancyContentActionsEnum.Buy,
      InstancyContentActionsEnum.Enroll,
      InstancyContentActionsEnum.Join,
      InstancyContentActionsEnum.CancelEnrollment,
      InstancyContentActionsEnum.AddToMyLearning,
      InstancyContentActionsEnum.View,
      InstancyContentActionsEnum.Play,
    ];

    Iterable<InstancyUIActionModel> actionsList = getInstancyUIActionModelListFromInstancyContentActionsEnumList(
      viewType: contentDetailsDTOModel.ViewType,
      objectTypeId: contentDetailsDTOModel.ContentTypeId,
      actions: primaryActions,
      localStr: localStr,
      parameterModel: CourseDetailsUIActionParameterModel(
        viewType: contentDetailsDTOModel.ViewType,
        eventEndDateTime: contentDetailsDTOModel.EventEndDateTimeTimeWithoutConvert,
        eventScheduleType: contentDetailsDTOModel.EventScheduleType,
        isContentEnrolled: contentDetailsDTOModel.isContentEnrolled.toLowerCase() == "1" || contentDetailsDTOModel.isContentEnrolled.toLowerCase() == "true",
        mediaTypeId: contentDetailsDTOModel.MediaTypeID,
        objectTypeId: contentDetailsDTOModel.ContentTypeId,
      ),
      callbackModel: callBackModel,
    );
    MyPrint.printOnConsole("actionsList:${actionsList.length}");

    if (actionsList.length > 1) {
      yield* actionsList.take(1);
    } else {
      yield* actionsList;
    }
  }*/

  Iterable<InstancyUIActionModel> getCourseDetailsPrimaryActions({
    required CourseDTOModel contentDetailsDTOModel,
    required InstancyContentScreenType screenType,
    required LocalStr localStr,
    required MyLearningUIActionCallbackModel myLearningUIActionCallbackModel,
    required CatalogUIActionCallbackModel catalogUIActionCallbackModel,
  }) sync* {
    MyPrint.printOnConsole(
        "getCourseDetailsPrimaryActions called with objectTypeId:${contentDetailsDTOModel.ContentTypeId}, mediaTypeID:${contentDetailsDTOModel.MediaTypeID}, screenType:$screenType");

    if (screenType == InstancyContentScreenType.MyLearning) {
      yield* MyLearningUIActionsController(
        appProvider: appProvider,
        profileProvider: profileProvider,
        myLearningProvider: myLearningProvider,
      ).getMyLearningScreenPrimaryActionsFromMyLearningUIActionParameterModel(
        objectTypeId: contentDetailsDTOModel.ContentTypeId,
        mediaTypeId: contentDetailsDTOModel.MediaTypeID,
        viewType: contentDetailsDTOModel.ViewType,
        localStr: localStr,
        myLearningUIActionCallbackModel: myLearningUIActionCallbackModel,
        parameterModel: getMyLearningUIActionParameterModelFromCourseDTOModel(model: contentDetailsDTOModel),
      );
    } else if (screenType == InstancyContentScreenType.Catalog) {
      // MyPrint.printOnConsole("contentDetailsDTOModel.isContentEnrolled:${contentDetailsDTOModel.isContentEnrolled}");
      yield* CatalogUIActionsController(appProvider: appProvider).getCatalogScreenPrimaryActionsFromCatalogUIActionParameterModel(
        objectTypeId: contentDetailsDTOModel.ContentTypeId,
        mediaTypeId: contentDetailsDTOModel.MediaTypeID,
        viewType: contentDetailsDTOModel.ViewType,
        isContentEnrolled: contentDetailsDTOModel.isContentEnrolled.toLowerCase() == "1" || contentDetailsDTOModel.isContentEnrolled.toLowerCase() == "true",
        localStr: localStr,
        catalogUIActionCallbackModel: catalogUIActionCallbackModel,
        parameterModel: getCatalogUIActionParameterModelFromCourseDTOModel(contentDetailsDTOModel: contentDetailsDTOModel),
      );
    }
  }

  Iterable<InstancyUIActionModel> getCourseDetailsSecondaryActions({
    required CourseDTOModel contentDetailsDTOModel,
    required InstancyContentScreenType screenType,
    required LocalStr localStr,
    required MyLearningUIActionCallbackModel myLearningUIActionCallbackModel,
    required CatalogUIActionCallbackModel catalogUIActionCallbackModel,
  }) sync* {
    MyPrint.printOnConsole("getCourseDetailsSecondaryActions called with objectTypeId:${contentDetailsDTOModel.ContentTypeId},"
        " mediaTypeID:${contentDetailsDTOModel.MediaTypeID}");

    if (screenType == InstancyContentScreenType.MyLearning) {
      yield* MyLearningUIActionsController(
        appProvider: appProvider,
        profileProvider: profileProvider,
        myLearningProvider: myLearningProvider,
      ).getMyLearningScreenSecondaryActionsFromMyLearningUIActionParameterModel(
        objectTypeId: contentDetailsDTOModel.ContentTypeId,
        mediaTypeId: contentDetailsDTOModel.MediaTypeID,
        viewType: contentDetailsDTOModel.ViewType,
        localStr: localStr,
        myLearningUIActionCallbackModel: myLearningUIActionCallbackModel,
        parameterModel: getMyLearningUIActionParameterModelFromCourseDTOModel(model: contentDetailsDTOModel),
      );
    } else if (screenType == InstancyContentScreenType.Catalog) {
      yield* CatalogUIActionsController(appProvider: appProvider).getCatalogScreenSecondaryActionsFromCatalogUIActionParameterModel(
        objectTypeId: contentDetailsDTOModel.ContentTypeId,
        mediaTypeId: contentDetailsDTOModel.MediaTypeID,
        viewType: contentDetailsDTOModel.ViewType,
        isContentEnrolled: contentDetailsDTOModel.isContentEnrolled.toLowerCase() == "1" || contentDetailsDTOModel.isContentEnrolled.toLowerCase() == "true",
        localStr: localStr,
        catalogUIActionCallbackModel: catalogUIActionCallbackModel,
        parameterModel: getCatalogUIActionParameterModelFromCourseDTOModel(contentDetailsDTOModel: contentDetailsDTOModel),
      );
    }
  }

  MyLearningUIActionParameterModel getMyLearningUIActionParameterModelFromCourseDTOModel({required CourseDTOModel model}) {
    return MyLearningUIActionParameterModel(
      objectTypeId: model.ContentTypeId,
      mediaTypeId: model.MediaTypeID,
      CancelEventLink: model.CancelEventlink,
      bit4: model.bit4,
      ViewLink: model.ViewLink,
      DetailsLink: model.DetailsLink,
      ViewSessionsLink: model.ViewSessionsLink,
      eventenddatetime: model.EventEndDateTime,
      EventType: model.EventType,
      eventScheduleType: model.EventScheduleType,
      RelatedContentLink: model.RelatedContentLink,
      IsRelatedcontent: model.IsRelatedcontent,
      actualStatus: model.ActualStatus,
      eventStartDatetime: model.EventStartDateTime,
      isArchived: model.IsArchived,
      removeLink: "",
      eventRecording: model.RecordingDetails,
      InstanceEventReSchedule: model.ReScheduleEvent,
      CertificateLink: model.CertificateLink,
      ActionViewQRcode: model.ActionViewQRcode,
      suggestToConnectionsLink: model.SuggesttoConnLink,
      suggestWithFriendLink: model.SuggestwithFriendLink,
      shareLink: model.Sharelink,
      ReEnrollmentHistoryLink: model.ReEnrollmentHistory,
      InstanceEventReclass: model.InstanceEventReclass,
      JWVideoKey: model.JWVideoKey,
    );
  }

  CatalogUIActionParameterModel getCatalogUIActionParameterModelFromCourseDTOModel({required CourseDTOModel contentDetailsDTOModel}) {
    return CatalogUIActionParameterModel(
      objectTypeId: contentDetailsDTOModel.ContentTypeId,
      mediaTypeId: contentDetailsDTOModel.MediaTypeID,
      ViewType: contentDetailsDTOModel.ViewType,
      eventScheduleType: contentDetailsDTOModel.EventScheduleType,
      isWishlistContent: 0,
      isWishlistMode: false,
      hasRelatedContents: contentDetailsDTOModel.AddLink.startsWith("addrecommenedrelatedcontent"),
      isContentEnrolled: contentDetailsDTOModel.isContentEnrolled.toLowerCase() == "1" || contentDetailsDTOModel.isContentEnrolled.toLowerCase() == "true",
      bit4: contentDetailsDTOModel.bit4 is bool ? contentDetailsDTOModel.bit4 : false,
      eventRecording: contentDetailsDTOModel.RecordingDetails != null,
      ViewLink: contentDetailsDTOModel.ViewLink,
      AddLink: contentDetailsDTOModel.AddLink,
      BuyNowLink: contentDetailsDTOModel.BuyNowLink,
      EnrollNowLink: contentDetailsDTOModel.EnrollNowLink,
      TitleExpired: "",
      DetailsLink: contentDetailsDTOModel.DetailsLink,
      cancelEventLink: contentDetailsDTOModel.CancelEventlink,
      eventStartDatetime: contentDetailsDTOModel.EventStartDateTime,
      eventenddatetime: contentDetailsDTOModel.EventEndDateTime,
      InstanceEventReSchedule: contentDetailsDTOModel.InstanceEventReSchedule,
      ReEnrollmentHistory: contentDetailsDTOModel.ReEnrollmentHistory,
      waitListLink: contentDetailsDTOModel.WaitListLink,
      RecommendedLink: "",
      suggestToConnectionsLink: contentDetailsDTOModel.SuggesttoConnLink,
      suggestWithFriendLink: contentDetailsDTOModel.SuggestwithFriendLink,
      shareLink: contentDetailsDTOModel.Sharelink,
      AddToWishlist: "",
      RemoveFromWishList: "",
      RelatedContentLink: contentDetailsDTOModel.RelatedContentLink,
      IsRelatedcontent: contentDetailsDTOModel.IsRelatedcontent,
      ShareToRecommend: contentDetailsDTOModel.SharetoRecommendedLink,
      InstanceEventReclass: contentDetailsDTOModel.InstanceEventReclass,
    );
  }

  Iterable<InstancyUIActionModel> getInstancyUIActionModelListFromInstancyContentActionsEnumList({
    required int viewType,
    required int objectTypeId,
    required List<InstancyContentActionsEnum> actions,
    required CourseDetailsUIActionParameterModel parameterModel,
    required LocalStr localStr,
    required CourseDetailsUIActionCallbackModel callbackModel,
  }) sync* {
    MyPrint.printOnConsole("getInstancyUIActionModelListFromInstancyContentActionsEnumList called with actions:$actions");

    for (InstancyContentActionsEnum action in actions) {
      InstancyUIActionModel? model;

      if (action == InstancyContentActionsEnum.Buy) {
        bool isShowJoin = isShowAction(actionType: InstancyContentActionsEnum.Buy, parameterModel: parameterModel);
        if (isShowJoin && callbackModel.onBuyTap != null) {
          model = InstancyUIActionModel(
            text: localStr.catalogActionsheetBuyoption,
            iconData: InstancyIcons.buy,
            onTap: callbackModel.onBuyTap,
            actionsEnum: InstancyContentActionsEnum.Buy,
          );
        }
      } else if (action == InstancyContentActionsEnum.AddToMyLearning) {
        bool isShowJoin = isShowAction(actionType: InstancyContentActionsEnum.AddToMyLearning, parameterModel: parameterModel);
        if (isShowJoin && callbackModel.onAddToMyLearningTap != null) {
          model = InstancyUIActionModel(
            text: localStr.catalogActionsheetAddtomylearningoption,
            iconData: InstancyIcons.addToMyLearning,
            onTap: callbackModel.onAddToMyLearningTap,
            actionsEnum: InstancyContentActionsEnum.AddToMyLearning,
          );
        }
      } else if (action == InstancyContentActionsEnum.Enroll) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Enroll, parameterModel: parameterModel) && callbackModel.onEnrollTap != null) {
          model = InstancyUIActionModel(
            text: localStr.eventsActionsheetEnrollNowOption,
            iconData: InstancyIcons.addToMyLearning,
            actionsEnum: InstancyContentActionsEnum.Enroll,
            onTap: callbackModel.onEnrollTap,
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
      } else if (action == InstancyContentActionsEnum.CancelEnrollment) {
        if (isShowAction(actionType: InstancyContentActionsEnum.CancelEnrollment, parameterModel: parameterModel) && callbackModel.onCancelEnrollmentTap != null) {
          model = InstancyUIActionModel(
            text: localStr.eventsActionsheetCancelenrollmentoption,
            iconData: InstancyIcons.cancelEnrollment,
            actionsEnum: InstancyContentActionsEnum.CancelEnrollment,
            onTap: callbackModel.onCancelEnrollmentTap,
          );
        }
      } else if (action == InstancyContentActionsEnum.View) {
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
      }

      if (model != null) yield model;
    }
  }
}
