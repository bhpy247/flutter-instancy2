import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/backend/ui_actions/catalog/catalog_ui_action_parameter_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../configs/app_constants.dart';
import '../../../models/app_configuration_models/data_models/local_str.dart';
import '../../../models/course/data_model/CourseDTOModel.dart';
import '../../../utils/my_print.dart';
import '../../../views/common/components/instancy_ui_actions/instancy_ui_actions.dart';
import '../primary_secondary_actions/primary_secondary_actions.dart';
import 'catalog_ui_action_callback_model.dart';

typedef CatalogUIActionTypeDef = bool Function({required CatalogUIActionParameterModel parameterModel});

class CatalogUIActionsController {
  late final AppProvider _appProvider;
  // late final MyLearningProvider _myLearningProvider;

  CatalogUIActionsController({
    required AppProvider? appProvider,
    // required MyLearningProvider? myLearningProvider,
  }) {
    _appProvider = appProvider ?? AppProvider();
    // _myLearningProvider = myLearningProvider ?? MyLearningProvider();
    _initializeActionsMap();
  }

  Map<InstancyContentActionsEnum, CatalogUIActionTypeDef> _actionsMap = <InstancyContentActionsEnum, CatalogUIActionTypeDef>{};

  AppProvider get appProvider => _appProvider;

  // MyLearningProvider get myLearningProvider => _myLearningProvider;

  void _initializeActionsMap() {
    _actionsMap = <InstancyContentActionsEnum, CatalogUIActionTypeDef>{
      InstancyContentActionsEnum.View: showView,
      InstancyContentActionsEnum.AddToMyLearning: showAddToMyLearning,
      InstancyContentActionsEnum.Buy: showBuy,
      InstancyContentActionsEnum.Enroll: showEnroll,
      InstancyContentActionsEnum.Details: showDetails,
      InstancyContentActionsEnum.IAmInterested: showIAmInterested,
      InstancyContentActionsEnum.ContactUs: showContactUs,
      InstancyContentActionsEnum.AddToWishlist:showAddToWishlist,
      InstancyContentActionsEnum.RemoveFromWishlist:showRemoveFromWishlist,
      InstancyContentActionsEnum.AddToWaitList: showAddToWaitList,
      InstancyContentActionsEnum.ViewResources: showViewResources,
      InstancyContentActionsEnum.CancelEnrollment: showCancelEnrollment,
      InstancyContentActionsEnum.RecommendTo: showRecommendTo,
      InstancyContentActionsEnum.ShareToConnections: showShareWithConnection,
      InstancyContentActionsEnum.ShareWithPeople: showShareWithPeople,
      InstancyContentActionsEnum.Share: showShare,
      InstancyContentActionsEnum.Download : showDownload,

    };
  }

  bool isShowAction({required InstancyContentActionsEnum actionType, required CatalogUIActionParameterModel parameterModel}) {
    CatalogUIActionTypeDef? type = _actionsMap[actionType];

    if (type != null) {
      return type(parameterModel: parameterModel);
    } else {
      return false;
    }
  }

  bool showView({required CatalogUIActionParameterModel parameterModel}) {
    if (parameterModel.ViewLink.isNotEmpty && parameterModel.objectTypeId != InstancyObjectTypes.events && !parameterModel.isWishlistMode) {
      return true;
    }

    return false;
  }

  bool showAddToMyLearning({required CatalogUIActionParameterModel parameterModel}) {
    if (parameterModel.objectTypeId != InstancyObjectTypes.events && parameterModel.AddLink.isNotEmpty && parameterModel.ViewType != ViewTypesForContent.ECommerce) {
      return true;
    }

    return false;
  }

  bool showBuy({required CatalogUIActionParameterModel parameterModel}) {
    if (parameterModel.BuyNowLink.isEmpty || parameterModel.ViewType != ViewTypesForContent.ECommerce) {
      return false;
    }

    return true;
  }

  bool showEnroll({required CatalogUIActionParameterModel parameterModel}) {
    if ((parameterModel.EnrollNowLink.isNotEmpty || (parameterModel.AddLink.isNotEmpty && parameterModel.objectTypeId == InstancyObjectTypes.events && parameterModel.TitleExpired.isEmpty))) {
      return true;
    }

    return false;
  }

  bool showDetails({required CatalogUIActionParameterModel parameterModel}) {
    if (parameterModel.DetailsLink.isNotEmpty) {
      return true;
    }

    return false;
  }

  bool showIAmInterested({required CatalogUIActionParameterModel parameterModel}) {
    if(parameterModel.AddLink.isNotEmpty && parameterModel.mediaTypeId == InstancyMediaTypes.comingSoon) {
      return true;
    }

    return false;
  }

  bool showContactUs({required CatalogUIActionParameterModel parameterModel}) {
    if(parameterModel.AddLink.isNotEmpty && parameterModel.mediaTypeId == InstancyMediaTypes.contactUs) {
      return true;
    }

    return false;
  }

  bool showAddToWishlist({required CatalogUIActionParameterModel parameterModel}) {
    // MyPrint.printOnConsole("is wishlisted content: ${appProvider.appSystemConfigurationModel.enableWishlist} ${parameterModel.isContentEnrolled}, ${parameterModel.isWishlistContent}, AddToWishlist:${parameterModel.AddToWishlist}");
    if(appProvider.appSystemConfigurationModel.enableWishlist == true && parameterModel.AddToWishlist.isNotEmpty && (parameterModel.AddLink.isNotEmpty || parameterModel.EnrollNowLink.isNotEmpty)) {
      return true;
    }
    return false;
  }

  bool showRemoveFromWishlist({required CatalogUIActionParameterModel parameterModel}) {
    if(appProvider.appSystemConfigurationModel.enableWishlist == true && parameterModel.RemoveFromWishList.isNotEmpty) {
      return true;
    }
    return false;
  }

  bool showAddToWaitList({required CatalogUIActionParameterModel parameterModel}) {
    if (parameterModel.waitListLink.isNotEmpty) {
      return true;
    }

    return false;
  }

  bool showCancelEnrollment({required CatalogUIActionParameterModel parameterModel}) {
    if (parameterModel.cancelEventLink.isNotEmpty) {
      return true;
    }

    return false;
  }

  bool showViewResources({required CatalogUIActionParameterModel parameterModel}) {
    if(parameterModel.RelatedContentLink.isNotEmpty) {
      return true;
    }

    return false;
  }

  bool showReschedule({required CatalogUIActionParameterModel parameterModel}) {
    if(parameterModel.InstanceEventReSchedule.isNotEmpty) {
      return true;
    }

    return false;
  }

  bool showReEnrollmentHistory({required CatalogUIActionParameterModel parameterModel}) {
    if(parameterModel.ReEnrollmentHistory.isNotEmpty) {
      return true;
    }

    return false;
  }

  bool showEventViewRecording({required CatalogUIActionParameterModel parameterModel}) {
    if (parameterModel.eventRecording == true && AppConfigurationOperations.isValidString(parameterModel.eventRecording.toString())) {
      if (parameterModel.isContentEnrolled) {
        return true;
      }
    }
    return false;
  }

  bool showRecommendTo({required CatalogUIActionParameterModel parameterModel}) {
    if(parameterModel.ShareToRecommend.isNotEmpty){
      return true;
    }
    return false;
    // return AppConfigurationOperations.isValidString(parameterModel.RecommendedLink);
  }

  bool showShareWithConnection({required CatalogUIActionParameterModel parameterModel}) {
    return AppConfigurationOperations.isValidString(parameterModel.suggestToConnectionsLink);
  }

  bool showShareWithPeople({required CatalogUIActionParameterModel parameterModel}) {
    return AppConfigurationOperations.isValidString(parameterModel.suggestWithFriendLink);
  }

  bool showShare({required CatalogUIActionParameterModel parameterModel}) {
    return AppConfigurationOperations.isValidString(parameterModel.shareLink);
  }

  bool showDownload({required CatalogUIActionParameterModel parameterModel}) {
    return false;

    /*if ([InstancyObjectTypes.mediaResource, InstancyObjectTypes.document].contains(parameterModel.objectTypeId)) {
      if([InstancyMediaTypes.image,InstancyMediaTypes.audio,InstancyMediaTypes.video].contains(parameterModel.mediaTypeId)){
        return true;
      }
    }
    return false;*/
  }


  //region Primary Actions
  Iterable<InstancyUIActionModel> getCatalogScreenPrimaryActions({
    required CourseDTOModel catalogCourseDTOModel,
    required LocalStr localStr,
    required CatalogUIActionCallbackModel catalogUIActionCallbackModel,
    required bool isWishlistMode,
  }) sync* {
    // MyPrint.printOnConsole("getCatalogScreenPrimaryActions called with objectTypeId:${catalogCourseDTOModel.ContentTypeId},"
    //     " mediaTypeID:${catalogCourseDTOModel.MediaTypeID}, ViewType:${catalogCourseDTOModel.ViewType}, isContentEnrolled:${catalogCourseDTOModel.isContentEnrolled}");

    CatalogUIActionParameterModel parameterModel = getCatalogUIActionParameterModelFromCatalogCourseDTOModel(
      catalogCourseDTOModel: catalogCourseDTOModel,
      isWishlistMode: isWishlistMode,
    );

    yield* getCatalogScreenPrimaryActionsFromCatalogUIActionParameterModel(
      objectTypeId: catalogCourseDTOModel.ContentTypeId,
      mediaTypeId: catalogCourseDTOModel.MediaTypeID,
      viewType: catalogCourseDTOModel.ViewType,
      isContentEnrolled: catalogCourseDTOModel.isContentEnrolled == "1" || catalogCourseDTOModel.isContentEnrolled.toLowerCase() == "true",
      parameterModel: parameterModel,
      localStr: localStr,
      catalogUIActionCallbackModel: catalogUIActionCallbackModel,
    );
  }

  Iterable<InstancyUIActionModel> getCatalogScreenPrimaryActionsFromCatalogUIActionParameterModel({
    required int viewType,
    required int objectTypeId,
    required int mediaTypeId,
    required bool isContentEnrolled,
    required CatalogUIActionParameterModel parameterModel,
    required LocalStr localStr,
    required CatalogUIActionCallbackModel catalogUIActionCallbackModel,
  }) sync* {
    // MyPrint.printOnConsole("getCatalogScreenPrimaryActionsFromCatalogUIActionParameterModel called with parameterModel:$parameterModel");

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
  Iterable<InstancyUIActionModel> getCatalogScreenSecondaryActions({
    required CourseDTOModel catalogCourseDTOModel,
    required LocalStr localStr,
    required CatalogUIActionCallbackModel catalogUIActionCallbackModel,
    required bool isWishlistMode,
  }) sync* {
    MyPrint.printOnConsole("getCatalogScreenSecondaryActions called with objectTypeId:${catalogCourseDTOModel.ContentTypeId},"
        " mediaTypeID:${catalogCourseDTOModel.MediaTypeID}, ViewType:${catalogCourseDTOModel.ViewType}");

    CatalogUIActionParameterModel parameterModel = getCatalogUIActionParameterModelFromCatalogCourseDTOModel(
      catalogCourseDTOModel: catalogCourseDTOModel,
      isWishlistMode: isWishlistMode,
    );

    List<InstancyContentActionsEnum> primaryActions = PrimarySecondaryActionsController.getPrimaryActionForCatalogContent(
      viewType:catalogCourseDTOModel.ViewType,
      objectTypeId:catalogCourseDTOModel.ContentTypeId,
      mediaTypeId: catalogCourseDTOModel.MediaTypeID,
    );
    List<InstancyContentActionsEnum> secondaryActions = PrimarySecondaryActionsController.getSecondaryActionForCatalogContent(
      viewType:catalogCourseDTOModel.ViewType,
      objectTypeId:catalogCourseDTOModel.ContentTypeId,
      mediaTypeId: catalogCourseDTOModel.MediaTypeID,
    );

    Set<InstancyContentActionsEnum> set = {};
    set.addAll(primaryActions);
    set.addAll(secondaryActions);

    yield* getInstancyUIActionModelListFromInstancyContentActionsEnumList(
      viewType:catalogCourseDTOModel.ViewType,
      objectTypeId:catalogCourseDTOModel.ContentTypeId,
      actions: set.toList(),
      parameterModel: parameterModel,
      isContentEnrolled: catalogCourseDTOModel.isContentEnrolled == "1" || catalogCourseDTOModel.isContentEnrolled.toLowerCase() == "true",
      localStr: localStr,
      catalogUIActionCallbackModel: catalogUIActionCallbackModel,
    );
  }

  Iterable<InstancyUIActionModel> getCatalogScreenSecondaryActionsFromCatalogUIActionParameterModel({
    required int viewType,
    required int objectTypeId,
    required int mediaTypeId,
    required bool isContentEnrolled,
    required CatalogUIActionParameterModel parameterModel,
    required LocalStr localStr,
    required CatalogUIActionCallbackModel catalogUIActionCallbackModel,
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

  CatalogUIActionParameterModel getCatalogUIActionParameterModelFromCatalogCourseDTOModel({
    required CourseDTOModel catalogCourseDTOModel,
    required bool isWishlistMode,
  }) {
    return CatalogUIActionParameterModel(
      ShareToRecommend: catalogCourseDTOModel.SharetoRecommendedLink,
      objectTypeId: catalogCourseDTOModel.ContentTypeId,
      mediaTypeId: catalogCourseDTOModel.MediaTypeID,
      ViewType: catalogCourseDTOModel.ViewType,
      eventScheduleType: catalogCourseDTOModel.EventScheduleType,
      isWishlistContent: catalogCourseDTOModel.isWishListContent,
      isWishlistMode: isWishlistMode,
      hasRelatedContents: catalogCourseDTOModel.AddLink.startsWith("addrecommenedrelatedcontent"),
      isContentEnrolled: catalogCourseDTOModel.isContentEnrolled == "1" || catalogCourseDTOModel.isContentEnrolled.toLowerCase() == "true",
      bit4: catalogCourseDTOModel.bit4,
      eventRecording: catalogCourseDTOModel.EventRecording,
      ViewLink: catalogCourseDTOModel.ViewLink,
      AddLink: catalogCourseDTOModel.AddLink,
      BuyNowLink: catalogCourseDTOModel.BuyNowLink,
      EnrollNowLink: catalogCourseDTOModel.EnrollNowLink,
      TitleExpired: catalogCourseDTOModel.TitleExpired,
      DetailsLink: catalogCourseDTOModel.DetailsLink,
      cancelEventLink: catalogCourseDTOModel.CancelEventLink,
      eventStartDatetime: catalogCourseDTOModel.EventStartDateTime,
      eventenddatetime: catalogCourseDTOModel.EventEndDateTime,
      InstanceEventReSchedule: catalogCourseDTOModel.InstanceEventReSchedule,
      ReEnrollmentHistory: catalogCourseDTOModel.ReEnrollmentHistory,
      waitListLink: catalogCourseDTOModel.WaitListLink,
      RecommendedLink: catalogCourseDTOModel.RecommendedLink,
      suggestToConnectionsLink: catalogCourseDTOModel.SuggesttoConnLink,
      suggestWithFriendLink: catalogCourseDTOModel.SuggestwithFriendLink,
      shareLink: catalogCourseDTOModel.Sharelink,
      AddToWishlist: catalogCourseDTOModel.AddtoWishList,
      RemoveFromWishList: catalogCourseDTOModel.RemoveFromWishList,
      RelatedContentLink: catalogCourseDTOModel.RelatedContentLink,
      IsRelatedcontent: catalogCourseDTOModel.IsRelatedcontent,
      ContentName: catalogCourseDTOModel.ContentName,
    );
  }

  Iterable<InstancyUIActionModel> getInstancyUIActionModelListFromInstancyContentActionsEnumList({
    required int viewType,
    required int objectTypeId,
    required List<InstancyContentActionsEnum> actions,
    required CatalogUIActionParameterModel parameterModel,
    required bool isContentEnrolled,
    required LocalStr localStr,
    required CatalogUIActionCallbackModel catalogUIActionCallbackModel,
  }) sync* {
    // MyPrint.printOnConsole("getInstancyUIActionModelListFromInstancyContentActionsEnumList called with Actions:$actions");
    // MyPrint.printOnConsole("isContentEnrolled:$isContentEnrolled");

    if (actions.contains(InstancyContentActionsEnum.View)) {
      if (!isContentEnrolled && [ViewTypesForContent.Subscription, ViewTypesForContent.ECommerce].contains(viewType)) {
        actions[actions.indexOf(InstancyContentActionsEnum.View)] = viewType == ViewTypesForContent.Subscription ? InstancyContentActionsEnum.AddToMyLearning : InstancyContentActionsEnum.Buy;
      }
    } else if (actions.contains(InstancyContentActionsEnum.AddToMyLearning) || actions.contains(InstancyContentActionsEnum.Buy) || actions.contains(InstancyContentActionsEnum.Enroll)) {
      if (isContentEnrolled) {
        if (actions.contains(InstancyContentActionsEnum.AddToMyLearning)) {
          if (!actions.contains(InstancyContentActionsEnum.View)) {
            actions[actions.indexOf(InstancyContentActionsEnum.AddToMyLearning)] = InstancyContentActionsEnum.View;
          } else {
            actions.remove(InstancyContentActionsEnum.AddToMyLearning);
          }
        }
        if (actions.contains(InstancyContentActionsEnum.Buy)) {
          if (!actions.contains(InstancyContentActionsEnum.View)) {
            actions[actions.indexOf(InstancyContentActionsEnum.Buy)] = InstancyContentActionsEnum.View;
          } else {
            actions.remove(InstancyContentActionsEnum.Buy);
          }
        }
        if (actions.contains(InstancyContentActionsEnum.Enroll)) {
          actions.remove(InstancyContentActionsEnum.Enroll);
        }
      }
    }
    // MyPrint.printOnConsole("final actions:$actions");

    for (InstancyContentActionsEnum action in actions) {
      InstancyUIActionModel? model;

      //Primary Actions
      if(action == InstancyContentActionsEnum.View) {
        // MyPrint.printOnConsole("isShowAction(actionType: InstancyContentActionsEnum.AddToMyLearning, parameterModel: parameterModel):${isShowAction(actionType: InstancyContentActionsEnum.AddToMyLearning, parameterModel: parameterModel)}");
        // MyPrint.printOnConsole("showView(parameterModel: parameterModel):${showView(parameterModel: parameterModel)}");
        if (isShowAction(actionType: InstancyContentActionsEnum.View, parameterModel: parameterModel) && catalogUIActionCallbackModel.onViewTap != null) {
          model = InstancyUIActionModel(
            text: localStr.catalogActionsheetViewoption,
            iconData: InstancyIcons.view,
            onTap: catalogUIActionCallbackModel.onViewTap,
            actionsEnum: InstancyContentActionsEnum.View,
          );
        }
      }
      else if(action == InstancyContentActionsEnum.AddToMyLearning) {
        // MyPrint.printOnConsole("Content Name:${parameterModel.ContentName}");
        // MyPrint.printOnConsole("isShowAction(actionType: InstancyContentActionsEnum.AddToMyLearning, parameterModel: parameterModel):${isShowAction(actionType: InstancyContentActionsEnum.AddToMyLearning, parameterModel: parameterModel)}");
        // MyPrint.printOnConsole("showAddToMyLearning(parameterModel: parameterModel):${showAddToMyLearning(parameterModel: parameterModel)}");
        if (isShowAction(actionType: InstancyContentActionsEnum.AddToMyLearning, parameterModel: parameterModel) && catalogUIActionCallbackModel.onAddToMyLearningTap != null) {
          model = InstancyUIActionModel(
            text: localStr.catalogActionsheetAddtomylearningoption,
            iconData: InstancyIcons.addToMyLearning,
            onTap: catalogUIActionCallbackModel.onAddToMyLearningTap,
            actionsEnum: InstancyContentActionsEnum.AddToMyLearning,
          );
        }
      }
      else if(action == InstancyContentActionsEnum.Buy) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Buy, parameterModel: parameterModel) && catalogUIActionCallbackModel.onBuyTap != null) {
          model = InstancyUIActionModel(
            text: localStr.catalogActionsheetBuyoption,
            iconData: InstancyIcons.buy,
            onTap: catalogUIActionCallbackModel.onBuyTap,
            actionsEnum: InstancyContentActionsEnum.Buy,
          );
        }
      }
      else if(action == InstancyContentActionsEnum.Enroll) {
        // MyPrint.printOnConsole("isShowAction(actionType: InstancyContentActionsEnum.AddToMyLearning, parameterModel: parameterModel):${isShowAction(actionType: InstancyContentActionsEnum.AddToMyLearning, parameterModel: parameterModel)}");
        // MyPrint.printOnConsole("showAddToMyLearning(parameterModel: parameterModel):${showAddToMyLearning(parameterModel: parameterModel)}");
        if (isShowAction(actionType: InstancyContentActionsEnum.Enroll, parameterModel: parameterModel) && catalogUIActionCallbackModel.onAddToMyLearningTap != null) {
          model = InstancyUIActionModel(
            text: localStr.eventsActionsheetEnrolloption,
            iconData: InstancyIcons.addToMyLearning,
            onTap: catalogUIActionCallbackModel.onEnrollTap,
            actionsEnum: InstancyContentActionsEnum.Enroll,
          );
        }
      }
      else if(action == InstancyContentActionsEnum.Details) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Details, parameterModel: parameterModel) && catalogUIActionCallbackModel.onDetailsTap != null) {
          model = InstancyUIActionModel(
            text: localStr.catalogActionsheetDetailsoption,
            iconData: InstancyIcons.details,
            onTap: catalogUIActionCallbackModel.onDetailsTap,
            actionsEnum: InstancyContentActionsEnum.Details,
          );
        }
      }
      else if(action == InstancyContentActionsEnum.IAmInterested) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Details, parameterModel: parameterModel) && catalogUIActionCallbackModel.onIAmInterestedTap != null) {
          model = InstancyUIActionModel(
            text: "I am Interested",
            iconData: InstancyIcons.details,
            onTap: catalogUIActionCallbackModel.onIAmInterestedTap,
            actionsEnum: InstancyContentActionsEnum.IAmInterested,
          );
        }
      }
      else if(action == InstancyContentActionsEnum.ContactUs) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ContactUs, parameterModel: parameterModel) && catalogUIActionCallbackModel.onContactTap != null) {
          model = InstancyUIActionModel(
            text: "Contact Us",
            iconData: InstancyIcons.details,
            onTap: catalogUIActionCallbackModel.onContactTap,
            actionsEnum: InstancyContentActionsEnum.ContactUs,
          );
        }
      }
      else if(action == InstancyContentActionsEnum.NA) {}

      //Secondary Actions
      else if(action == InstancyContentActionsEnum.AddToWishlist) {
        if (isShowAction(actionType: InstancyContentActionsEnum.AddToWishlist, parameterModel: parameterModel) && catalogUIActionCallbackModel.onAddToWishlist != null) {
          model = InstancyUIActionModel(
            text: localStr.catalogActionsheetWishlistoption,
            iconData: InstancyIcons.addToWishlist,
            onTap: catalogUIActionCallbackModel.onAddToWishlist,
            actionsEnum: InstancyContentActionsEnum.AddToWishlist,
          );
        }
      }
      else if(action == InstancyContentActionsEnum.RemoveFromWishlist) {
        // MyPrint.printOnConsole("Checking RemoveFromWishlist:${parameterModel.RemoveFromWishList}");
        if (isShowAction(actionType: InstancyContentActionsEnum.RemoveFromWishlist, parameterModel: parameterModel) && catalogUIActionCallbackModel.onRemoveWishlist != null) {
          model = InstancyUIActionModel(
            text: localStr.catalogActionsheetRemovefromwishlistoption,
            iconData: InstancyIcons.removeFromWishlist,
            onTap: catalogUIActionCallbackModel.onRemoveWishlist,
            actionsEnum: InstancyContentActionsEnum.RemoveFromWishlist,
          );
        }
      }
      else if(action == InstancyContentActionsEnum.AddToWaitList) {
        if (isShowAction(actionType: InstancyContentActionsEnum.AddToWaitList, parameterModel: parameterModel) && catalogUIActionCallbackModel.onAddToWaitListTap != null) {
          model = InstancyUIActionModel(
            text: localStr.eventsActionsheetWaitlistoption,
            iconData: InstancyIcons.waitList,
            onTap: catalogUIActionCallbackModel.onAddToWaitListTap,
            actionsEnum: InstancyContentActionsEnum.AddToWaitList,
          );
        }
      }
      else if(action == InstancyContentActionsEnum.CancelEnrollment) {
        if (isShowAction(actionType: InstancyContentActionsEnum.CancelEnrollment, parameterModel: parameterModel) && catalogUIActionCallbackModel.onCancelEnrollmentTap != null) {
          model = InstancyUIActionModel(
            text: localStr.eventsActionsheetCancelenrollmentoption,
            iconData: InstancyIcons.cancelEnrollment,
            onTap: catalogUIActionCallbackModel.onCancelEnrollmentTap,
            actionsEnum: InstancyContentActionsEnum.CancelEnrollment,
          );
        }
      }
      else if(action == InstancyContentActionsEnum.ViewResources) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ViewResources, parameterModel: parameterModel) && catalogUIActionCallbackModel.onViewResources != null) {
          model = InstancyUIActionModel(
            text: localStr.eventsActionsheetRelatedcontentoption,
            iconData: InstancyIcons.viewResources,
            onTap: catalogUIActionCallbackModel.onViewResources,
            actionsEnum: InstancyContentActionsEnum.ViewResources,
          );
        }
      }
      else if(action == InstancyContentActionsEnum.Reschedule) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Reschedule, parameterModel: parameterModel) && catalogUIActionCallbackModel.onRescheduleTap != null) {
          model = InstancyUIActionModel(
            text: localStr.mylearningActionbuttonRescheduleactionbutton,
            iconData: InstancyIcons.reschedule,
            onTap: catalogUIActionCallbackModel.onRescheduleTap,
            actionsEnum: InstancyContentActionsEnum.Reschedule,
          );
        }
      }
      else if(action == InstancyContentActionsEnum.ReEnrollmentHistory) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ReEnrollmentHistory, parameterModel: parameterModel) && catalogUIActionCallbackModel.onReEnrollmentHistoryTap != null) {
          model = InstancyUIActionModel(
            text: localStr.mylearningActionbuttonRescheduleactionbutton,
            iconData: InstancyIcons.ReEnrollmentHistory,
            onTap: catalogUIActionCallbackModel.onReEnrollmentHistoryTap,
            actionsEnum: InstancyContentActionsEnum.ReEnrollmentHistory,
          );
        }
      }
      else if(action == InstancyContentActionsEnum.RecommendTo) {
        if (isShowAction(actionType: InstancyContentActionsEnum.RecommendTo, parameterModel: parameterModel) && catalogUIActionCallbackModel.onRecommendToTap != null) {
          model = InstancyUIActionModel(
            text: "Recommend To",
            iconData:FontAwesomeIcons.share,
            onTap: catalogUIActionCallbackModel.onRecommendToTap,
            actionsEnum: InstancyContentActionsEnum.RecommendTo,
          );
        }
      }
      else if(action == InstancyContentActionsEnum.ShareToConnections) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ShareToConnections, parameterModel: parameterModel) && catalogUIActionCallbackModel.onShareWithConnectionTap != null) {
          model = InstancyUIActionModel(
            text: "Share with Connection",
            iconData: InstancyIcons.shareWithConnection,
            onTap: catalogUIActionCallbackModel.onShareWithConnectionTap,
            actionsEnum: InstancyContentActionsEnum.ShareToConnections,
          );
        }
      }
      else if(action == InstancyContentActionsEnum.ShareWithPeople) {
        if (isShowAction(actionType: InstancyContentActionsEnum.ShareWithPeople, parameterModel: parameterModel) && catalogUIActionCallbackModel.onShareWithPeopleTap != null) {
          model = InstancyUIActionModel(
            text: "Share with People",
            iconData: InstancyIcons.shareWithPeople,
            onTap: catalogUIActionCallbackModel.onShareWithPeopleTap,
            actionsEnum: InstancyContentActionsEnum.ShareWithPeople,
          );
        }
      }
      else if(action == InstancyContentActionsEnum.Share) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Share, parameterModel: parameterModel) && catalogUIActionCallbackModel.onShareTap != null) {
          model = InstancyUIActionModel(
            text: localStr.catalogActionsheetShareoption,
            iconData: InstancyIcons.share,
            onTap: catalogUIActionCallbackModel.onShareTap,
            actionsEnum: InstancyContentActionsEnum.Share,
          );
        }
      }  else if(action == InstancyContentActionsEnum.Download) {
        if (isShowAction(actionType: InstancyContentActionsEnum.Download, parameterModel: parameterModel) && catalogUIActionCallbackModel.onDownloadTap != null) {
          model = InstancyUIActionModel(
            text: "Download",
            iconData: InstancyIcons.download,
            onTap: catalogUIActionCallbackModel.onDownloadTap,
            actionsEnum: InstancyContentActionsEnum.Download,
          );
        }
      }

      if(model != null) yield model;
    }
  }
}
