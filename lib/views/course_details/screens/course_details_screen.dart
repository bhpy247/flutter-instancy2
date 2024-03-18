import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/parsing_helper.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/backend/Catalog/catalog_controller.dart';
import 'package:flutter_instancy_2/backend/Catalog/catalog_provider.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/backend/course_details/course_details_controller.dart';
import 'package:flutter_instancy_2/backend/course_details/course_details_provider.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_controller.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_provider.dart';
import 'package:flutter_instancy_2/backend/event/event_controller.dart';
import 'package:flutter_instancy_2/backend/event/event_provider.dart';
import 'package:flutter_instancy_2/backend/gamification/gamification_controller.dart';
import 'package:flutter_instancy_2/backend/gamification/gamification_provider.dart';
import 'package:flutter_instancy_2/backend/my_learning/my_learning_controller.dart';
import 'package:flutter_instancy_2/backend/my_learning/my_learning_provider.dart';
import 'package:flutter_instancy_2/backend/profile/profile_provider.dart';
import 'package:flutter_instancy_2/backend/ui_actions/catalog/catalog_ui_action_callback_model.dart';
import 'package:flutter_instancy_2/backend/ui_actions/course_details/course_details_ui_action_callback_model.dart';
import 'package:flutter_instancy_2/backend/ui_actions/my_course_download/my_course_download_ui_action_callback_model.dart';
import 'package:flutter_instancy_2/backend/ui_actions/my_course_download/my_course_download_ui_actions_controller.dart';
import 'package:flutter_instancy_2/backend/ui_actions/my_learning/my_learning_ui_action_callback_model.dart';
import 'package:flutter_instancy_2/backend/ui_actions/my_learning/my_learning_ui_action_configs.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/configs/ui_configurations.dart';
import 'package:flutter_instancy_2/models/catalog/request_model/add_content_to_my_learning_request_model.dart';
import 'package:flutter_instancy_2/models/classroom_events/data_model/EventRecordingDetailsModel.dart';
import 'package:flutter_instancy_2/models/common/pagination/pagination_model.dart';
import 'package:flutter_instancy_2/models/content_details/request_model/course_details_request_model.dart';
import 'package:flutter_instancy_2/models/content_details/request_model/course_details_schedule_data_request_model.dart';
import 'package:flutter_instancy_2/models/content_review_ratings/data_model/content_user_rating_model.dart';
import 'package:flutter_instancy_2/models/course_download/data_model/course_download_data_model.dart';
import 'package:flutter_instancy_2/models/course_download/request_model/course_download_request_model.dart';
import 'package:flutter_instancy_2/models/course_launch/data_model/course_launch_model.dart';
import 'package:flutter_instancy_2/models/gamification/request_model/update_content_gamification_request_model.dart';
import 'package:flutter_instancy_2/models/my_learning/response_model/page_notes_response_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/views/common/components/common_cached_network_image.dart';
import 'package:flutter_instancy_2/views/common/components/modal_progress_hud.dart';
import 'package:flutter_instancy_2/views/content_review_ratings/components/content_user_review_card.dart';
import 'package:flutter_instancy_2/views/course_download/components/course_download_button.dart';
import 'package:flutter_instancy_2/views/event/components/event_session_card.dart';
import 'package:flutter_instancy_2/views/my_learning/component/notes_dialog.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:provider/provider.dart';

import '../../../api/api_url_configuration_provider.dart';
import '../../../backend/app_theme/style.dart';
import '../../../backend/authentication/authentication_provider.dart';
import '../../../backend/content_review_ratings/content_review_ratings_controller.dart';
import '../../../backend/content_review_ratings/content_review_ratings_provider.dart';
import '../../../backend/course_launch/course_launch_controller.dart';
import '../../../backend/navigation/navigation.dart';
import '../../../backend/share/share_provider.dart';
import '../../../backend/ui_actions/course_details/course_details_ui_actions_controller.dart';
import '../../../backend/ui_actions/primary_secondary_actions/primary_secondary_actions.dart';
import '../../../models/app_configuration_models/data_models/local_str.dart';
import '../../../models/catalog/response_model/removeFromWishlistModel.dart';
import '../../../models/course/data_model/CourseDTOModel.dart';
import '../../../models/event_track/request_model/view_recording_request_model.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_loader.dart';
import '../../common/components/common_read_more_text.dart';
import '../../common/components/instancy_ui_actions/instancy_ui_actions.dart';
import '../components/schedule_event_card.dart';

class CourseDetailScreen extends StatefulWidget {
  static const String routeName = "/CourseDetailScreen";

  final CourseDetailScreenNavigationArguments arguments;

  const CourseDetailScreen({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> with MySafeState {
  bool isLoading = false;

  late String contentId;
  late int? userId;
  late int componentId;
  late int componentInstanceId;

  late AppProvider appProvider;

  late CourseDetailsProvider courseDetailsProvider;
  late CourseDetailsController courseDetailsController;

  late ProfileProvider profileProvider;

  late MyLearningProvider myLearningProvider;
  late MyLearningController myLearningController;

  late CatalogProvider catalogProvider;
  late CatalogController catalogController;

  late ContentReviewRatingsProvider contentReviewRatingsProvider;
  late ContentReviewRatingsController contentReviewRatingsController;

  late EventProvider eventProvider;
  late EventController eventController;

  late CourseDownloadProvider courseDownloadProvider;
  late CourseDownloadController courseDownloadController;

  Future<void>? futureGetData;

  List<String> skillsList = ["Network", "Planning", "Manage", "Leadership", "Problem Solving", "Delegation"];
  List<String> programOutlineList = [
    "How to design assesment?",
    "Objectives",
    "Quiz1",
  ];

  bool isConsolidated = false;

  bool isRefreshOtherPageWhenPop = false;

  Future<PageNotesResponseModel>? getNotes;

  Future<void> getContentDetailsData() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("_CourseDetailScreenState().getContentDetailsData() called", tag: tag);

    // await Future.delayed(const Duration(seconds: 5));

    contentReviewRatingsController.getReviewsList(
      contentId: contentId,
      componentId: componentId,
      isRefresh: true,
    );

    if (widget.arguments.courseDtoModel != null) {
      courseDetailsProvider.contentDetailsDTOModel.set(value: widget.arguments.courseDtoModel);
    } else {
      await courseDetailsController.getCourseDetailsData(
        siteId: widget.arguments.siteId,
        requestModel: CourseDetailsRequestModel(
          ContentID: contentId,
          intUserID: userId,
          metadata: 1,
          ComponentID: componentId,
          DetailsCompID: InstancyComponents.Details,
          DetailsCompInsID: InstancyComponents.DetailsComponentInsId,
          MultiInstanceEventEnroll: widget.arguments.isRescheduleEvent
              ? "rescheduleenroll"
              : widget.arguments.isReEnroll
                  ? "reenroll"
                  : "",
        ),
      );
    }

    CourseDTOModel? contentDetailsDTOModel = courseDetailsProvider.contentDetailsDTOModel.get();
    MyPrint.printOnConsole("contentDetailsDTOModel.ContentTypeId:${contentDetailsDTOModel?.ContentTypeId}");
    MyPrint.printOnConsole("contentDetailsDTOModel.EventScheduleType:${contentDetailsDTOModel?.EventScheduleType}");

    if (contentDetailsDTOModel != null && context.mounted) {
      GamificationController(provider: context.read<GamificationProvider>()).UpdateContentGamification(
        requestModel: UpdateContentGamificationRequestModel(
          contentId: contentDetailsDTOModel.ContentID,
          scoId: contentDetailsDTOModel.ScoID,
          objecttypeId: contentDetailsDTOModel.ContentTypeId,
          GameAction: GamificationActionType.Clicked,
        ),
      );
    }

    if (contentDetailsDTOModel?.ContentTypeId == InstancyObjectTypes.events && [EventTypes.regular].contains(contentDetailsDTOModel!.EventScheduleType)) {
      courseDetailsController.getCourseDetailsScheduleData(
        requestModel: CourseDetailsScheduleDataRequestModel(
          EventID: contentId,
        ),
      );
    }

    if (contentDetailsDTOModel?.ContentTypeId == InstancyObjectTypes.events && [EventTypes.session].contains(contentDetailsDTOModel!.EventType)) {
      eventController.getEventSessionsList(
        eventId: contentId,
      );
    }
  }

  CatalogUIActionCallbackModel getCatalogUIActionCallbackModel({
    required CourseDTOModel model,
    InstancyContentActionsEnum? primaryAction,
    bool isSecondaryAction = true,
  }) {
    return CatalogUIActionCallbackModel(
      onViewTap: primaryAction == InstancyContentActionsEnum.View
          ? null
          : () async {
              if (isSecondaryAction) Navigator.pop(context);

              if (model.ViewType == ViewTypesForContent.ViewAndAddToMyLearning && !ParsingHelper.parseBoolMethod(model.isContentEnrolled)) {
                await addContentToMyLearning(
                  courseDTOModel: model,
                  contentIdToLoadInScreen: model.ContentID,
                );
              }

              onContentLaunchTap(model: model);
            },
      onAddToMyLearningTap: primaryAction == InstancyContentActionsEnum.AddToMyLearning
          ? null
          : () async {
              if (isSecondaryAction) Navigator.pop(context);
              addContentToMyLearning(
                courseDTOModel: model,
                contentIdToLoadInScreen: model.ContentID,
              );
            },
      onBuyTap: primaryAction == InstancyContentActionsEnum.Buy
          ? null
          : () async {
              if (isSecondaryAction) Navigator.pop(context);

              buyCourse(model: model);
            },
      onEnrollTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        addContentToMyLearning(
          courseDTOModel: model,
          contentIdToLoadInScreen: model.ContentID,
        );
      },
      onIAmInterestedTap: () async {},
      onContactTap: () async {},
      onAddToWishlist: () async {
        if (isSecondaryAction) Navigator.pop(context);

        isLoading = true;
        mySetState();
        bool isSuccess = await catalogController.addContentToWishlist(
          contentId: model.ContentID,
          componentId: componentId,
          componentInstanceId: componentInstanceId,
        );
        MyPrint.printOnConsole("isSuccess: $isSuccess");
        isLoading = false;
        mySetState();

        if (isSuccess) {
          getContentDetailsData();
        }

        if (pageMounted && context.mounted) {
          if (isSuccess) {
            MyToast.showSuccess(context: context, msg: appProvider.localStr.catalogAlertsubtitleItemaddedtowishlistsuccesfully);
          } else {
            MyToast.showError(context: context, msg: 'Failed');
          }
        }
      },
      onRemoveWishlist: () async {
        if (isSecondaryAction) Navigator.pop(context);
        isLoading = true;
        mySetState();
        MyPrint.printOnConsole("Component instance id: $componentInstanceId");
        RemoveFromWishlistResponseModel removeFromWishlistResponseModel = await catalogController.removeContentFromWishlist(
          contentId: model.ContentID,
          componentId: componentId,
          componentInstanceId: componentInstanceId,
        );
        isLoading = false;
        mySetState();
        MyPrint.printOnConsole("valueeee: ${removeFromWishlistResponseModel.isSuccess}");
        if (removeFromWishlistResponseModel.isSuccess) {
          getContentDetailsData();
        }
        if (pageMounted && context.mounted) {
          if (removeFromWishlistResponseModel.isSuccess) {
            MyToast.showSuccess(context: context, msg: appProvider.localStr.catalogAlertsubtitleItemremovedtowishlistsuccesfully);
          } else {
            MyToast.showError(context: context, msg: 'Failed');
          }
        }
      },
      onAddToWaitListTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        //TODO: Implement onAddToWaitListTap
      },
      onCancelEnrollmentTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        isLoading = true;
        mySetState();

        bool isCancelled = await EventController(eventProvider: null).cancelEventEnrollment(
          context: context,
          eventId: model.ContentID,
          isBadCancellationEnabled: model.isBadCancellationEnabled == true,
        );
        MyPrint.printOnConsole("isCancelled:$isCancelled");

        isLoading = false;
        mySetState();

        if (isCancelled) {
          if (pageMounted && context.mounted) MyToast.showSuccess(context: context, msg: "Your enrollment for the course has been successfully canceled");
          futureGetData = getContentDetailsData();
          mySetState();
        }
      },
      onViewResources: primaryAction == InstancyContentActionsEnum.ViewResources
          ? null
          : () async {
              if (isSecondaryAction) Navigator.pop(context);

              dynamic value = await NavigationController.navigateToEventTrackScreen(
                navigationOperationParameters: NavigationOperationParameters(
                  context: context,
                  navigationType: NavigationType.pushNamed,
                ),
                arguments: EventTrackScreenArguments(
                  eventTrackTabType: model.ContentTypeId == InstancyObjectTypes.track ? EventTrackTabs.trackContents : EventTrackTabs.eventContents,
                  objectTypeId: model.ContentTypeId,
                  isRelatedContent: true,
                  parentContentId: model.ContentID,
                  componentId: componentId,
                  scoId: model.ScoID,
                  componentInstanceId: componentInstanceId,
                  isContentEnrolled: model.isCourseEnrolled(),
                  eventTrackContentModel: model,
                ),
              );

              if (value == true) {
                getContentDetailsData();
              }
            },
      onRescheduleTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        //TODO: Implement onRescheduleTap
      },
      onReEnrollmentHistoryTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        String parentEventId = "";
        String instanceEventId = "";

        if (model.EventScheduleType == EventScheduleTypes.parent) {
          parentEventId = model.ContentID;
          instanceEventId = "";
        } else if (model.EventScheduleType == EventScheduleTypes.instance) {
          // parentEventId = model.InstanceParentContentID;
          instanceEventId = model.ContentID;
        }

        await NavigationController.navigateToReEnrollmentHistoryScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: ReEnrollmentHistoryScreenNavigationArguments(
            parentEventId: parentEventId,
            instanceEventId: instanceEventId,
            ContentName: model.ContentName,
            AuthorDisplayName: model.AuthorDisplayName,
            ThumbnailImagePath: model.ThumbnailImagePath,
          ),
        );
      },
      onRecommendToTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        NavigationController.navigateToRecommendToScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: RecommendToScreenNavigationArguments(
            shareContentType: ShareContentType.catalogCourse,
            contentId: model.ContentID,
            contentName: model.Title,
            componentId: componentId,
          ),
        );
      },
      onShareWithConnectionTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        NavigationController.navigateToShareWithConnectionsScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: ShareWithConnectionsScreenNavigationArguments(
            shareContentType: ShareContentType.catalogCourse,
            contentId: model.ContentID,
            contentName: model.Title,
            shareProvider: context.read<ShareProvider>(),
            scoId: model.ScoID,
            objecttypeId: model.ContentTypeId,
          ),
        );
      },
      onShareWithPeopleTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        NavigationController.navigateToShareWithPeopleScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: ShareWithPeopleScreenNavigationArguments(
            shareContentType: ShareContentType.catalogCourse,
            contentId: model.ContentID,
            contentName: model.Title,
            scoId: model.ScoID,
            objecttypeId: model.ContentTypeId,
          ),
        );
      },
      onShareTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        MyUtils.shareContent(content: model.Sharelink);
      },
    );
  }

  MyLearningUIActionCallbackModel getMyLearningUIActionCallbackModel({
    required CourseDTOModel model,
    InstancyContentActionsEnum? primaryAction,
    bool isSecondaryAction = true,
  }) {
    return MyLearningUIActionCallbackModel(
      onArchiveTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        isLoading = true;
        mySetState();

        bool isSuccess = await myLearningController.addToArchive(contentId: model.ContentID);
        MyPrint.printOnConsole("Archieve isSuccess:$isSuccess");

        isLoading = false;
        mySetState();

        if (isSuccess) {
          if (pageMounted && context.mounted) MyToast.showSuccess(context: context, msg: "Content Archived");
          futureGetData = getContentDetailsData();
          // getContentDetailsData();
        }
      },
      onUnArchiveTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        isLoading = true;
        mySetState();

        bool isSuccess = await myLearningController.removeFromArchive(contentId: model.ContentID);
        MyPrint.printOnConsole("Archieve isSuccess:$isSuccess");

        isLoading = false;
        mySetState();

        if (isSuccess) {
          if (pageMounted && context.mounted) MyToast.showSuccess(context: context, msg: "Content Unarchived");
          futureGetData = getContentDetailsData();
          mySetState();
        }
      },
      onJoinTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        EventController(eventProvider: null).joinVirtualEvent(context: context, joinUrl: model.ViewLink);
      },
      onNoteTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        isLoading = true;
        mySetState();
        getNotes = getNotesData(contentId: model.ContentID);
        PageNotesResponseModel? pageNotesResponseModel = await getNotes;
        MyPrint.printOnConsole("pageNotesResponseModel name:: ${pageNotesResponseModel?.name}");

        onNoteTap(pageNotesResponseModel ?? PageNotesResponseModel(), model.ContentID);

        isLoading = false;
        mySetState();
      },
      onAddToCalenderTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        bool isSuccess = await EventController(eventProvider: null).addEventToCalender(
          context: context,
          isFromDetail: true,
          EventStartDateTime: model.EventStartDateTimeWithoutConvert,
          EventEndDateTime: model.EventEndDateTimeTimeWithoutConvert,
          eventDateTimeFormat: appProvider.appSystemConfigurationModel.eventDateTimeFormat,
          Title: model.Title,
          ShortDescription: model.ShortDescription,
          LocationName: model.LocationName,
        );
        if (pageMounted && context.mounted) {
          if (isSuccess) {
            MyToast.showSuccess(context: context, msg: 'Event added successfully');
          } else {
            MyToast.showError(context: context, msg: 'Error occured while adding event');
          }
        }
      },
      onSetCompleteTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        isLoading = true;
        mySetState();

        bool isSuccess = await myLearningController.setComplete(
          contentId: model.ContentID,
          scoId: model.ScoID,
          contentTypeId: model.ContentTypeId,
          parentEventTrackContentId: widget.arguments.parentEventId.isNotEmpty ? widget.arguments.parentEventId : widget.arguments.parentTrackId,
        );
        MyPrint.printOnConsole("SetComplete isSuccess:$isSuccess");

        isLoading = false;
        mySetState();

        if (isSuccess) {
          if (pageMounted && context.mounted) MyToast.showSuccess(context: context, msg: "Set Complete was successful");
          futureGetData = getContentDetailsData();
          mySetState();
        }
      },
      onCancelEnrollmentTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        isLoading = true;
        mySetState();

        bool isCancelled = await EventController(eventProvider: null).cancelEventEnrollment(
          context: context,
          eventId: model.ContentID,
          isBadCancellationEnabled: model.isBadCancellationEnabled,
        );
        MyPrint.printOnConsole("isCancelled:$isCancelled");

        isLoading = false;
        mySetState();

        if (isCancelled) {
          if (pageMounted && context.mounted) MyToast.showSuccess(context: context, msg: "Your enrollment for the course has been successfully canceled");
          futureGetData = getContentDetailsData();
          mySetState();
        }
      },
      onRemoveTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        isLoading = true;
        mySetState();

        bool isRemoved = await CatalogController(provider: null).removeContentFromMyLearning(
          context: context,
          contentId: model.ContentID,
        );
        MyPrint.printOnConsole("isRemoved:$isRemoved");

        isLoading = false;
        mySetState();

        if (isRemoved) {
          if (pageMounted && context.mounted) MyToast.showSuccess(context: context, msg: "Content has been removed successfully");

          // refreshMyLearningData();
        }
      },
      onCertificateTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        myLearningController.viewCompletionCertificate(
          context: context,
          contentId: model.ContentID,
          certificateLink: model.CertificateLink,
        );
      },
      onQRCodeTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        NavigationController.navigateToQRCodeImageScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: QRCodeImageScreenNavigationArguments(qrCodePath: model.ActionViewQRcode),
        );
      },
      onReEnrollmentHistoryTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        String parentEventId = "";
        String instanceEventId = "";

        if (model.EventScheduleType == EventScheduleTypes.parent) {
          parentEventId = model.ContentID;
          instanceEventId = "";
        } else if (model.EventScheduleType == EventScheduleTypes.instance) {
          parentEventId = model.InstanceParentContentID;
          instanceEventId = model.ContentID;
        }

        await NavigationController.navigateToReEnrollmentHistoryScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: ReEnrollmentHistoryScreenNavigationArguments(
            parentEventId: parentEventId,
            instanceEventId: instanceEventId,
            ContentName: model.ContentName,
            AuthorDisplayName: model.AuthorDisplayName,
            ThumbnailImagePath: model.ThumbnailImagePath,
          ),
        );
      },
      onViewRecordingTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        EventRecordingDetailsModel? recordingDetails = model.RecordingDetails;

        if (recordingDetails == null) {
          MyPrint.printOnConsole("recordingDetails are null");
          return;
        }

        ViewRecordingRequestModel viewRecordingRequestModel = ViewRecordingRequestModel(
          contentName: model.ContentName,
          contentID: model.ContentID,
          contentTypeId: model.ContentTypeId,
          eventRecordingURL: recordingDetails.EventRecordingURL,
          eventRecording: recordingDetails.EventRecording,
          jWVideoKey: recordingDetails.JWVideoKey,
          language: recordingDetails.Language,
          recordingType: recordingDetails.RecordingType,
          scoID: recordingDetails.ScoID,
          jwVideoPath: recordingDetails.ViewLink,
          viewType: recordingDetails.ViewType,
        );
        EventController(eventProvider: null).viewRecordingForEvent(model: viewRecordingRequestModel, context: context);
      },
      onViewTap: primaryAction == InstancyContentActionsEnum.View
          ? null
          : () {
              if (isSecondaryAction) Navigator.pop(context);

              onContentLaunchTap(model: model);
            },
      onRescheduleTap: () {
        if (isSecondaryAction) Navigator.pop(context);
        //TODO: Implement onRescheduleTap
      },
      onReportTap: () async {
        if (isSecondaryAction) Navigator.pop(context);
        // if (isSecondaryAction) Navigator.pop(context);
        //
        // NavigationController.navigateToMyLearningContentProgressScreen(
        //   navigationOperationParameters: NavigationOperationParameters(
        //     context: context,
        //     navigationType: NavigationType.pushNamed,
        //   ),
        //   arguments: MyLearningContentProgressScreenNavigationArguments(
        //     myLearningCourseDTOModel: model,
        //     contentId: model.ContentID,
        //     userId: model.SiteUserID,
        //     contentTypeId: model.ContentTypeId,
        //     componentId: componentId,
        //   ),
        // );
        MyPrint.printOnConsole("contentIdddddd : ${model.ContentID}, userId: ${model.SiteUserID} contentTypeId: ${model.ContentTypeId} componentId:$componentId");
        NavigationController.navigateToMyLearningContentProgressScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: MyLearningContentProgressScreenNavigationArguments(
            courseDTOModel: model,
            contentId: model.ContentID,
            userId: model.SiteUserID,
            contentTypeId: model.ContentTypeId,
            componentId: componentId,
          ),
        );

        /*NavigationController.navigateToMyLearningContentProgressScreen(
            navigationOperationParameters: NavigationOperationParameters(
              context: context,
              navigationType: NavigationType.pushNamed,
            ),
            arguments: MyLearningContentProgressScreenNavigationArguments(
              contentId: model.ContentID,
              myLearningCourseDTOModel: model,
              componentId: componentId,
            ),
          );*/
      },
      onPlayTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        onContentLaunchTap(model: model);
      },
      onShareTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        MyUtils.shareContent(content: model.Sharelink);
      },
      onShareWithPeopleTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        NavigationController.navigateToShareWithPeopleScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: ShareWithPeopleScreenNavigationArguments(
            shareContentType: ShareContentType.catalogCourse,
            contentId: model.ContentID,
            contentName: model.Title,
            scoId: model.ScoID,
            objecttypeId: model.ContentTypeId,
          ),
        );
      },
      onShareWithConnectionTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        NavigationController.navigateToShareWithConnectionsScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: ShareWithConnectionsScreenNavigationArguments(
            shareContentType: ShareContentType.catalogCourse,
            contentId: model.ContentID,
            contentName: model.Title,
            shareProvider: context.read<ShareProvider>(),
            scoId: model.ScoID,
            objecttypeId: model.ContentTypeId,
          ),
        );
      },
      onViewSessionsTap: () async {
        if (isSecondaryAction) Navigator.pop(context);
        NavigationController.navigateToEventTrackScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: EventTrackScreenArguments(
            objectTypeId: model.ContentTypeId,
            eventTrackTabType: EventTrackTabs.session,
            isRelatedContent: (model.RelatedContentLink.isNotEmpty || model.IsRelatedcontent.toLowerCase() == 'true') ? true : false,
            parentContentId: model.ContentID,
            componentId: componentId,
            scoId: model.ScoID,
            componentInstanceId: componentInstanceId,
            isContentEnrolled: model.isCourseEnrolled(),
            eventTrackContentModel: model,
          ),
        );

        // if (value == true) {
        //   refreshMyLearningData();
        // }
      },
      onViewResourcesTap: primaryAction == InstancyContentActionsEnum.ViewResources
          ? null
          : () async {
              if (isSecondaryAction) Navigator.pop(context);

              dynamic value = await NavigationController.navigateToEventTrackScreen(
                navigationOperationParameters: NavigationOperationParameters(
                  context: context,
                  navigationType: NavigationType.pushNamed,
                ),
                arguments: EventTrackScreenArguments(
                  eventTrackTabType: model.ContentTypeId == InstancyObjectTypes.track ? EventTrackTabs.trackContents : EventTrackTabs.eventContents,
                  objectTypeId: model.ContentTypeId,
                  isRelatedContent: true,
                  parentContentId: model.ContentID,
                  componentId: componentId,
                  scoId: model.ScoID,
                  componentInstanceId: componentInstanceId,
                  isContentEnrolled: model.isCourseEnrolled(),
                  eventTrackContentModel: model,
                ),
              );

              if (value == true) {
                getContentDetailsData();
              }
            },
    );
  }

  MyCourseDownloadUIActionCallbackModel getMyCourseDownloadUIActionCallbackModel({
    required CourseDownloadDataModel model,
    bool isSecondaryAction = true,
  }) {
    return MyCourseDownloadUIActionCallbackModel(
      onRemoveFromDownloadTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        courseDownloadController.removeFromDownload(downloadId: model.id);
      },
      onCancelDownloadTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        courseDownloadController.cancelDownload(downloadId: model.id);
      },
      onPauseDownloadTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        courseDownloadController.pauseDownload(downloadId: model.id);
      },
      onResumeDownloadTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        courseDownloadController.resumeDownload(downloadId: model.id);
      },
      onSetCompleteTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        isLoading = true;
        mySetState();

        await courseDownloadController.setCompleteDownload(courseDownloadDataModel: model);

        isLoading = false;
        mySetState();
      },
    );
  }

  CourseDetailsUIActionCallbackModel getCourseDetailsUIActionCallbackModel({
    required CourseDTOModel model,
  }) {
    return CourseDetailsUIActionCallbackModel(
      onBuyTap: () async {
        await buyCourse(model: model);
      },
      onAddToMyLearningTap: () async {
        await addContentToMyLearning(
          courseDTOModel: model,
          contentIdToLoadInScreen: model.ContentID,
        );
      },
      onEnrollTap: () async {
        await addContentToMyLearning(
          courseDTOModel: model,
          contentIdToLoadInScreen: model.ContentID,
        );
      },
      onJoinTap: () async {
        EventController(eventProvider: null).joinVirtualEvent(context: context, joinUrl: model.ViewLink);
      },
      onCancelEnrollmentTap: () async {
        isLoading = true;
        mySetState();

        bool isCancelled = await EventController(eventProvider: null).cancelEventEnrollment(
          context: context,
          eventId: model.ContentID,
          isBadCancellationEnabled: model.isBadCancellationEnabled,
        );
        MyPrint.printOnConsole("isCancelled:$isCancelled");

        isLoading = false;
        mySetState();

        if (isCancelled) {
          if (pageMounted && context.mounted) MyToast.showSuccess(context: context, msg: "Your enrollment for the course has been successfully canceled");
          futureGetData = getContentDetailsData();
          mySetState();
        }
      },
      onViewTap: () {
        onContentLaunchTap(model: model);
      },
      onPlayTap: () {
        onContentLaunchTap(model: model);
      },
    );
  }

  void showModalBottomSheetView({
    required CourseDTOModel model,
    required InstancyContentScreenType screenType,
    InstancyContentActionsEnum? primaryAction,
  }) {
    MyPrint.printOnConsole("showModalBottomSheetView called with screenType:$screenType, primaryAction:$primaryAction");

    LocalStr localStr = appProvider.localStr;

    List<InstancyUIActionModel> options = <InstancyUIActionModel>[];

    CourseDetailsUIActionsController courseDetailsUIActionsController = CourseDetailsUIActionsController(
      appProvider: appProvider,
      profileProvider: profileProvider,
      myLearningProvider: myLearningProvider,
      catalogProvider: catalogProvider,
    );

    if (MyLearningUIActionConfigs.isContentTypeDownloadable(objectTypeId: model.ContentTypeId, mediaTypeId: model.MediaTypeID)) {
      CourseDownloadDataModel? courseDownloadDataModel = courseDownloadProvider.getCourseDownloadDataModelFromId(courseDownloadId: CourseDownloadDataModel.getDownloadId(contentId: model.ContentID));
      if (courseDownloadDataModel != null) {
        MyCourseDownloadUIActionsController courseDownloadUIActionsController = MyCourseDownloadUIActionsController(appProvider: appProvider);

        List<InstancyUIActionModel> courseDownloadOptions = courseDownloadUIActionsController
            .getMyCourseDownloadsScreenSecondaryActions(
              courseDownloadDataModel: courseDownloadDataModel,
              localStr: localStr,
              myCourseDownloadUIActionCallbackModel: getMyCourseDownloadUIActionCallbackModel(
                model: courseDownloadDataModel,
                isSecondaryAction: true,
              ),
            )
            .toSet()
            .toList();
        // MyPrint.printOnConsole("courseDownloadOptions length:${courseDownloadOptions.length}");

        options.addAll(courseDownloadOptions);
      }
    }

    options.addAll(courseDetailsUIActionsController
        .getCourseDetailsSecondaryActions(
          contentDetailsDTOModel: model,
          screenType: screenType,
          localStr: localStr,
          myLearningUIActionCallbackModel: getMyLearningUIActionCallbackModel(
            model: model,
            primaryAction: primaryAction,
            isSecondaryAction: true,
          ),
          catalogUIActionCallbackModel: getCatalogUIActionCallbackModel(
            model: model,
            primaryAction: primaryAction,
            isSecondaryAction: true,
          ),
        )
        .toList());

    if (options.isEmpty) {
      return;
    }

    InstancyUIActions().showAction(
      context: context,
      actions: options,
    );
  }

  Future<void> onReviewTap({ContentUserRatingModel? userLastReviewModel}) async {
    await contentReviewRatingsController.showAddEditDeleteReviewDialog(
      context: context,
      contentId: contentId,
      scoId: courseDetailsProvider.contentDetailsDTOModel.get()?.ScoID ?? 0,
      userLastReviewModel: userLastReviewModel,
      onAddEditReview: ({required String contentId, required int scoId, required String description, required int rating}) async {
        isLoading = true;
        mySetState();

        bool isAdded = await contentReviewRatingsController.addEditReview(
          contentId: contentId,
          scoId: scoId,
          objecttypeId: courseDetailsProvider.contentDetailsDTOModel.get()?.ContentTypeId ?? 0,
          description: description,
          rating: rating,
        );
        MyPrint.printOnConsole('isAdded review:$isAdded');

        isLoading = false;
        mySetState();

        if (isAdded) {
          MyPrint.printOnConsole(userLastReviewModel != null ? "Review Updated" : "Review Added");
          if (pageMounted && context.mounted) MyToast.showSuccess(context: context, msg: userLastReviewModel != null ? "Review Updated" : "Review Added");

          futureGetData = getContentDetailsData();
          mySetState();
        } else {
          MyPrint.printOnConsole("Review Add Failed");
          if (pageMounted && context.mounted) {
            MyToast.showError(context: context, msg: userLastReviewModel != null ? "Couldn't Update Review Updated" : "Couldn't Add Review");
          }
        }
      },
      onDeleteReview: ({required String contentId, required int userId}) async {
        isLoading = true;
        mySetState();

        bool isDeleted = await contentReviewRatingsController.deleteReview(contentId: contentId, userId: userId);
        MyPrint.printOnConsole('isDeleted review:$isDeleted');

        isLoading = false;
        mySetState();

        if (isDeleted) {
          MyPrint.printOnConsole("Review Deleted");
          if (pageMounted && context.mounted) MyToast.showSuccess(context: context, msg: "Review Deleted");

          futureGetData = getContentDetailsData();
          mySetState();
        } else {
          MyPrint.printOnConsole("Review Delete Failed");
          if (pageMounted && context.mounted) MyToast.showError(context: context, msg: "Couldn't Delete Review");
        }
      },
    );
  }

  Future<void> addContentToMyLearning({
    required CourseDTOModel courseDTOModel,
    required String contentIdToLoadInScreen,
    String multiInstanceParentId = "",
    String MultiInstanceEventEnroll = "",
  }) async {
    isLoading = true;
    mySetState();

    bool isSuccess = await CatalogController(provider: null).addContentToMyLearning(
      requestModel: AddContentToMyLearningRequestModel(
        SelectedContent: courseDTOModel.ContentID,
        multiInstanceParentId: multiInstanceParentId,
        ERitems: "",
        HideAdd: "",
        AdditionalParams: "",
        TargetDate: "",
        MultiInstanceEventEnroll: MultiInstanceEventEnroll,
        ComponentID: InstancyComponents.Details,
        ComponentInsID: InstancyComponents.DetailsComponentInsId,
        objecttypeId: courseDTOModel.ContentTypeId,
        scoId: courseDTOModel.ScoID,
        courseDTOModel: courseDTOModel,
      ),
      context: context,
      onPrerequisiteDialogShowEnd: () {
        MyPrint.printOnConsole("onPrerequisiteDialogShowEnd called");

        isLoading = true;
        mySetState();
      },
      onPrerequisiteDialogShowStarted: () {
        MyPrint.printOnConsole("onPrerequisiteDialogShowStarted called");
        isLoading = false;
        mySetState();
      },
      hasPrerequisites: courseDTOModel.hasPrerequisiteContents(),
      isShowToast: true,
      isWaitForOtherProcesses: true,
    );

    isLoading = false;

    if (isSuccess) {
      if (multiInstanceParentId.isNotEmpty) {
        contentId = contentIdToLoadInScreen;
        futureGetData = getContentDetailsData();
      }
      isRefreshOtherPageWhenPop = true;
    }

    mySetState();
  }

  Future<void> buyCourse({
    required CourseDTOModel model,
  }) async {
    MyPrint.printOnConsole("CourseDetailScreen().buyCourse() called for content:${model.ContentID}");

    isLoading = true;
    mySetState();

    bool isBuySuccess = await catalogController.buyCourse(
      context: context,
      model: model,
      ComponentID: componentId,
      ComponentInsID: componentInstanceId,
      isWaitForPostPurchaseProcesses: true,
    );

    isLoading = false;

    if (isBuySuccess) {
      contentId = model.ContentID;
      futureGetData = getContentDetailsData();
      isRefreshOtherPageWhenPop = true;
    }

    mySetState();
  }

  Future<void> onContentLaunchTap({
    required CourseDTOModel model,
  }) async {
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = myLearningController.myLearningRepository.apiController.apiDataProvider;

    isLoading = true;
    mySetState();

    bool isLaunched = await CourseLaunchController(
      appProvider: appProvider,
      authenticationProvider: context.read<AuthenticationProvider>(),
      componentId: -1,
      componentInstanceId: -1,
    ).viewCourse(
      context: context,
      model: CourseLaunchModel(
        ContentTypeId: model.ContentTypeId,
        MediaTypeId: model.MediaTypeID,
        ScoID: model.ScoID,
        SiteUserID: model.SiteUserID,
        SiteId: model.SiteId,
        ContentID: model.ContentID,
        ParentEventTrackContentID: widget.arguments.parentEventId.isNotEmpty ? widget.arguments.parentEventId : widget.arguments.parentTrackId,
        locale: apiUrlConfigurationProvider.getLocale(),
        ActivityId: model.ActivityId,
        ActualStatus: model.ActualStatus,
        ContentName: model.ContentName,
        FolderPath: model.FolderPath,
        JWVideoKey: model.JWVideoKey,
        jwstartpage: model.jwstartpage,
        startPage: model.startpage,
        courseDTOModel: model,
      ),
    );

    isLoading = false;
    mySetState();

    if (isLaunched) {
      getContentDetailsData();
    }
  }

  Future<void> onDownloadButtonTapped({required CourseDTOModel model}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("onDownloadTap called", tag: tag);

    String downloadId = CourseDownloadDataModel.getDownloadId(
      contentId: model.ContentID,
      eventTrackContentId: widget.arguments.parentTrackId.isNotEmpty ? widget.arguments.parentTrackId : widget.arguments.parentEventId,
    );

    CourseDownloadDataModel? courseDownloadDataModel = courseDownloadProvider.getCourseDownloadDataModelFromId(courseDownloadId: downloadId);

    if (courseDownloadDataModel == null) {
      MyPrint.printOnConsole("Course Not Downloaded", tag: tag);
      courseDownloadController.downloadCourse(
        courseDownloadRequestModel: CourseDownloadRequestModel(
          ContentID: model.ContentID,
          FolderPath: model.FolderPath,
          JWStartPage: model.startpage,
          JWVideoKey: model.JWVideoKey,
          StartPage: model.startpage,
          ContentTypeId: model.ContentTypeId,
          MediaTypeID: model.MediaTypeID,
          SiteId: model.SiteId,
          UserID: model.SiteUserID,
          ScoId: model.ScoID,
        ),
        courseDTOModel: model,
      );
    } else if (courseDownloadDataModel.isFileDownloading) {
      MyPrint.printOnConsole("Course Downloading", tag: tag);
      courseDownloadController.pauseDownload(downloadId: downloadId);
    } else if (courseDownloadDataModel.isFileDownloadingPaused) {
      MyPrint.printOnConsole("Course Paused", tag: tag);
      courseDownloadController.resumeDownload(downloadId: downloadId);
    } else {
      MyPrint.printOnConsole("Invalid Download Command", tag: tag);
    }
  }

  Future<PageNotesResponseModel> getNotesData({String contentId = ""}) async {
    PageNotesResponseModel pageNotesResponseModel = await myLearningController.getAllUserPageNotes(
      contentId: contentId,
      componentId: componentId,
      componentInstanceId: componentInstanceId,
    );
    return pageNotesResponseModel;
  }

  Future<void> onNoteTap(PageNotesResponseModel pageNotesResponseModel, String contentId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NotesDialog(
          contentId: contentId,
          componentId: componentId,
          componentInsId: componentInstanceId,
          myLearningController: myLearningController,
          pageNotesResponseModel: pageNotesResponseModel,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    contentId = widget.arguments.contentId;
    userId = widget.arguments.userId;
    componentId = widget.arguments.componentId;
    componentInstanceId = widget.arguments.componentInstanceId;
    isConsolidated = widget.arguments.isConsolidated;

    appProvider = context.read<AppProvider>();

    courseDetailsProvider = CourseDetailsProvider();
    courseDetailsController = CourseDetailsController(courseDetailsProvider: courseDetailsProvider);

    catalogProvider = widget.arguments.catalogProvider ?? CatalogProvider();
    catalogController = CatalogController(provider: catalogProvider);

    profileProvider = context.read<ProfileProvider>();

    myLearningProvider = widget.arguments.myLearningProvider ?? MyLearningProvider();
    myLearningController = MyLearningController(provider: myLearningProvider);

    contentReviewRatingsProvider = ContentReviewRatingsProvider();
    contentReviewRatingsController = ContentReviewRatingsController(contentReviewRatingsProvider: contentReviewRatingsProvider);

    eventProvider = EventProvider();
    eventController = EventController(eventProvider: eventProvider);

    courseDownloadProvider = context.read<CourseDownloadProvider>();
    courseDownloadController = CourseDownloadController(appProvider: appProvider, courseDownloadProvider: courseDownloadProvider);

    futureGetData = getContentDetailsData();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CourseDetailsProvider>.value(value: courseDetailsProvider),
        ChangeNotifierProvider<ContentReviewRatingsProvider>.value(value: contentReviewRatingsProvider),
        ChangeNotifierProvider<EventProvider>.value(value: eventProvider),
        ChangeNotifierProvider<CourseDownloadProvider>.value(value: courseDownloadProvider),
      ],
      child: Consumer3<CourseDetailsProvider, ContentReviewRatingsProvider, EventProvider>(
        builder: (BuildContext context, CourseDetailsProvider courseDetailsProvider, ContentReviewRatingsProvider contentReviewRatingsProvider, EventProvider eventProvider, Widget? child) {
          Widget body;

          if (futureGetData != null) {
            body = FutureBuilder(
              future: futureGetData!,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return getMainBody(
                    contentReviewRatingsProvider: contentReviewRatingsProvider,
                    courseDetailsProvider: courseDetailsProvider,
                  );
                } else {
                  return const CommonLoader(
                    isCenter: true,
                  );
                }
              },
            );
          } else {
            body = getMainBody(
              contentReviewRatingsProvider: contentReviewRatingsProvider,
              courseDetailsProvider: courseDetailsProvider,
            );
          }

          return PopScope(
            canPop: !isLoading,
            onPopInvoked: (bool didPop) {
              if (didPop) return;

              Navigator.pop(context, isRefreshOtherPageWhenPop);
            },
            child: ModalProgressHUD(
              inAsyncCall: isLoading,
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: appBar(contentDetailsDTOModel: courseDetailsProvider.contentDetailsDTOModel.get()),
                body: body,
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar appBar({CourseDTOModel? contentDetailsDTOModel}) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context, isRefreshOtherPageWhenPop);
        },
        icon: const Icon(Icons.arrow_back),
      ),
      title: const Text(
        "Course Details",
      ),
      actions: [
        if (contentDetailsDTOModel != null)
          InkWell(
            onTap: () {
              showModalBottomSheetView(model: contentDetailsDTOModel, screenType: widget.arguments.screenType);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(Icons.more_vert),
            ),
          )
      ],
    );
  }

  Widget getMainBody({
    required CourseDetailsProvider courseDetailsProvider,
    required ContentReviewRatingsProvider contentReviewRatingsProvider,
  }) {
    CourseDTOModel? contentDetailsDTOModel = courseDetailsProvider.contentDetailsDTOModel.get();

    if (contentDetailsDTOModel == null) {
      return Center(
        child: Text(appProvider.localStr.commoncomponentLabelNodatalabel),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        futureGetData = getContentDetailsData();
        mySetState();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              children: [
                getThumbnailImageWidget(imagePath: contentDetailsDTOModel.ThumbnailImagePath),
                if (contentDetailsDTOModel.isCourseEnrolled() &&
                    MyLearningUIActionConfigs.isContentTypeDownloadable(objectTypeId: contentDetailsDTOModel.ContentTypeId, mediaTypeId: contentDetailsDTOModel.MediaTypeID))
                  Positioned(
                    bottom: 15,
                    right: 15,
                    child: CourseDownloadButton(
                      contentId: contentDetailsDTOModel.ContentID,
                      onDownloadTap: () {
                        onDownloadButtonTapped(model: contentDetailsDTOModel);
                      },
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0).copyWith(bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  getCourseInfoWidget(contentDetailsDTOModel: contentDetailsDTOModel),
                  // getCourseDuration(ParsingHelper.parseDoubleMethod(contentDetailsDTOModel.Duration)),
                  getPrimaryActionButton(contentDetailsDTOModel: contentDetailsDTOModel),
                  getKeywordsListWidget(tags: AppConfigurationOperations.getListFromSeparatorJoinedString(parameterString: contentDetailsDTOModel.Tags)),
                  getLearningObjectivesWidget(learningObjectives: contentDetailsDTOModel.LearningObjectives),
                  getTableOfContentsWidget(tableOfContents: contentDetailsDTOModel.TableofContent),
                  courseDurationView(contentDetailsDTOModel: contentDetailsDTOModel),
                  directionUrl(contentDetailsDTOModel: contentDetailsDTOModel),
                  // programOutlineView(),
                  getAuthorView(contentDetailsDTOModel: contentDetailsDTOModel),
                  getReviews(contentDetailsDTOModel: contentDetailsDTOModel),
                  getRatings(contentDetailsDTOModel: contentDetailsDTOModel),
                  getMultiInstanceEventScheduleListWidget(courseDetailsProvider: courseDetailsProvider),
                  getEventSessionsListWidget(
                    contentDetailsDTOModel: contentDetailsDTOModel,
                    eventProvider: eventProvider,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getThumbnailImageWidget({required String imagePath}) {
    String imageUrl = AppConfigurationOperations(appProvider: appProvider).getInstancyImageUrlFromImagePath(imagePath: imagePath);
    MyPrint.printOnConsole("imageUrl:$imagePath");

    return CommonCachedNetworkImage(
      imageUrl: imageUrl,
      width: double.infinity,
      fit: BoxFit.cover,
      errorHeight: 200,
    );
  }

  Widget getCourseDuration(double duration) {
    return Text("$duration total hours of video");
  }

  //region Course Info
  Widget getCourseInfoWidget({required CourseDTOModel contentDetailsDTOModel}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getContentTypeIconAndTextWidget(
            ContentTypeId: contentDetailsDTOModel.ContentTypeId,
            mediaTypeID: contentDetailsDTOModel.MediaTypeID,
            contentType: contentDetailsDTOModel.ContentType,
          ),
          const SizedBox(height: 11),
          Text(
            contentDetailsDTOModel.Title,
            style: themeData.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Consumer<CourseDownloadProvider>(
            builder: (BuildContext context, CourseDownloadProvider courseDownloadProvider, Widget? child) {
              String courseDownloadId = CourseDownloadDataModel.getDownloadId(contentId: contentDetailsDTOModel.ContentID);
              CourseDownloadDataModel? downloadModel = courseDownloadProvider.getCourseDownloadDataModelFromId(courseDownloadId: courseDownloadId);

              if (downloadModel?.isCourseDownloaded == true && downloadModel?.courseDTOModel != null) {
                CourseDTOModel newModel = downloadModel!.courseDTOModel!;

                return linearProgressBar(
                  // color: AppConfigurations.getContentStatusColor(status: contentDetailsDTOModel.ContentStatus),
                  // color: InstancyColors.progressBarFillColor,
                  color: AppConfigurations.getContentStatusColorFromActualStatus(status: newModel.ActualStatus),
                  percentCompleted: newModel.PercentCompleted,
                  objectTypeId: newModel.ContentTypeId,
                  contentStatus: newModel.ContentStatus,
                );
              }

              return linearProgressBar(
                // color: AppConfigurations.getContentStatusColor(status: contentDetailsDTOModel.ContentStatus),
                // color: InstancyColors.progressBarFillColor,
                color: AppConfigurations.getContentStatusColorFromActualStatus(status: contentDetailsDTOModel.ActualStatus),
                percentCompleted: contentDetailsDTOModel.percentagecompleted,
                objectTypeId: contentDetailsDTOModel.ContentTypeId,
                contentStatus: contentDetailsDTOModel.ContentStatus,
              );
            },
          ),
          getEventStartAndEndDateWidget(
            EventStartDateTime: contentDetailsDTOModel.EventStartDateTime,
            EventEndDateTime: contentDetailsDTOModel.EventEndDateTime,
            eventStartDateTimeWithoutConvert: contentDetailsDTOModel.EventStartDateTimeWithoutConvert,
            eventEndDateTimeTimeWithoutConvert: contentDetailsDTOModel.EventEndDateTimeTimeWithoutConvert,
          ),
          getDescriptionWidget(
            objectTypeId: contentDetailsDTOModel.ContentTypeId,
            longDescription: contentDetailsDTOModel.LongDescription,
            shortDescription: contentDetailsDTOModel.ShortDescription,
          ),
        ],
      ),
    );
  }

  Widget getContentTypeIconAndTextWidget({
    required int ContentTypeId,
    required int mediaTypeID,
    required String contentType,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        getCoursesIconWidget(
          assetName: AppConfigurations.getContentIconFromObjectAndMediaType(
            mediaTypeId: mediaTypeID,
            objectTypeId: ContentTypeId,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          contentType,
          style: themeData.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
            // color: Color(0xff757575),
            color: themeData.textTheme.labelMedium!.color?.withAlpha(150),
          ),
        )
      ],
    );
  }

  Widget getCoursesIconWidget({String assetName = ""}) {
    return Image.asset(
      assetName,
      height: 13,
      width: 13,
      fit: BoxFit.cover,
    );
  }

  Widget linearProgressBar({required double percentCompleted, required Color color, required int objectTypeId, required String contentStatus}) {
    if (widget.arguments.isFromCatalog || objectTypeId == InstancyObjectTypes.events) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "${percentCompleted.toInt()}% ${AppConfigurations().parseHtmlString(contentStatus)}",
          style: themeData.textTheme.labelSmall?.copyWith(
            fontSize: 10,
            color: color,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.end,
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressBar(
            maxSteps: 100,
            minHeight: 10,
            progressType: LinearProgressBar.progressTypeLinear,
            // Use Dots progress
            currentStep: percentCompleted.toInt(),
            progressColor: color,
            backgroundColor: InstancyColors.progressBarBackgroundColor,
          ),
        ),
      ],
    );
  }

  Widget getEventStartAndEndDateWidget({
    required String EventStartDateTime,
    required String EventEndDateTime,
    required String eventStartDateTimeWithoutConvert,
    required String eventEndDateTimeTimeWithoutConvert,
  }) {
    // MyPrint.printOnConsole("eventStartDateTimeWithoutConvert:$eventStartDateTimeWithoutConvert");
    // MyPrint.printOnConsole("eventEndDateTimeTimeWithoutConvert:$eventEndDateTimeTimeWithoutConvert");

    if (EventStartDateTime.isEmpty || EventEndDateTime.isEmpty || eventStartDateTimeWithoutConvert.isEmpty || eventEndDateTimeTimeWithoutConvert.isEmpty) {
      return const SizedBox();
    }

    AppConfigurationOperations appConfigurationOperations = AppConfigurationOperations(appProvider: appProvider);

    return Row(
      children: <Widget>[
        const Icon(
          Icons.timelapse,
          color: Colors.grey,
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            // 'From $eventStartDateTimeWithoutConvert to $eventEndDateTimeTimeWithoutConvert',
            'From $EventStartDateTime ${appConfigurationOperations.getConvertedEventDateTimeString(
              eventDate: eventStartDateTimeWithoutConvert,
              sourceDateFormat: "MM/dd/yyyy hh:mm:ss aa",
              destinationDateFormat: "hh:mm aa",
            )} '
            'To $EventEndDateTime ${appConfigurationOperations.getConvertedEventDateTimeString(
              eventDate: eventEndDateTimeTimeWithoutConvert,
              sourceDateFormat: "MM/dd/yyyy HH:mm:ss aa",
              destinationDateFormat: "hh:mm aa",
            )}',
            style: themeData.textTheme.bodyMedium,
          ),
        )
      ],
    );
  }

  Widget getDescriptionWidget({required int objectTypeId, required String longDescription, required String shortDescription}) {
    if (shortDescription.isEmpty && longDescription.isEmpty) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (shortDescription.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                AppConfigurationOperations.getStringRemovingAllHtmlTags(shortDescription),
                style: themeData.textTheme.titleSmall?.copyWith(
                  color: themeData.textTheme.titleSmall!.color?.withOpacity(0.8),
                ),
              ),
            ),
          if (longDescription.isNotEmpty)
            CommonReadMoreTextWidget(
              text: AppConfigurationOperations.getStringRemovingAllHtmlTags(longDescription),
              trimLines: 3,
              // text: objectTypeId != InstancyObjectTypes.events ? AppConfigurationOperations.getStringRemovingAllHtmlTags(description) : description,
              // text: 'Flutter is Google’s mobile UI open source framework to build high-quality native (super fast) interfaces for iOS and Android apps with the unified codebase.and Android apps with the unified codebase.and Android apps with the unified codebase.and Android apps with the unified codebase.and Android apps with the unified codebase.and Android apps with the unified codebase.and Android apps with the unified codebase.and Android apps with the unified codebase.and Android apps with the unified codebase.and Android apps with the unified codebase.and Android apps with the unified codebase.',
            ),
        ],
      ),
    );
  }

  //endregion

  Widget getPrimaryActionButton({required CourseDTOModel contentDetailsDTOModel}) {
    ThemeData themeData = Theme.of(context);

    LocalStr localStr = appProvider.localStr;

    CourseDetailsUIActionsController courseDetailsUIActionsController = CourseDetailsUIActionsController(
      appProvider: appProvider,
      myLearningProvider: myLearningProvider,
      catalogProvider: catalogProvider,
    );

    /*List<InstancyUIActionModel> options = courseDetailsUIActionsController
        .getCourseDetailsPrimaryActions(
          contentDetailsDTOModel: contentDetailsDTOModel,
          screenType: widget.arguments.screenType,
          localStr: localStr,
          callBackModel: getCourseDetailsUIActionCallbackModel(
            model: contentDetailsDTOModel,
          ),
        )
        .toList();*/
    List<InstancyUIActionModel> options = courseDetailsUIActionsController
        .getCourseDetailsPrimaryActions(
          contentDetailsDTOModel: contentDetailsDTOModel,
          screenType: widget.arguments.screenType,
          localStr: localStr,
          myLearningUIActionCallbackModel: getMyLearningUIActionCallbackModel(
            model: contentDetailsDTOModel,
            primaryAction: null,
            isSecondaryAction: false,
          ),
          catalogUIActionCallbackModel: getCatalogUIActionCallbackModel(
            model: contentDetailsDTOModel,
            primaryAction: null,
            isSecondaryAction: false,
          ),
        )
        .toList();
    MyPrint.printOnConsole("Primary options:${options.map((e) => e.actionsEnum).toList()}");

    InstancyUIActionModel? primaryAction = options.firstElement;
    InstancyContentActionsEnum? primaryActionEnum = primaryAction?.actionsEnum;

    if (primaryAction == null) {
      return const SizedBox();
    }

    MyPrint.printOnConsole("contentDetailsDTOModel.ViewType:${contentDetailsDTOModel.ViewType}");
    MyPrint.printOnConsole("contentDetailsDTOModel.isContentEnrolled:${contentDetailsDTOModel.isContentEnrolled}");
    MyPrint.printOnConsole("contentDetailsDTOModel.ContentTypeId:${contentDetailsDTOModel.ContentTypeId}");
    MyPrint.printOnConsole("contentDetailsDTOModel.MediaTypeID:${contentDetailsDTOModel.MediaTypeID}");
    MyPrint.printOnConsole("contentDetailsDTOModel.eventType:${contentDetailsDTOModel.EventType}");

    return Row(
      children: [
        Expanded(
          child: CommonButton(
            onPressed: () {
              MyPrint.printOnConsole("OnPrimaryButtonTap called for primaryActionEnum:$primaryActionEnum");
              if (primaryAction.onTap != null) {
                primaryAction.onTap!();
              }
            },
            backGroundColor: themeData.primaryColor,
            borderColor: themeData.primaryColor,
            fontColor: themeData.colorScheme.onPrimary,
            fontWeight: FontWeight.w500,
            text: primaryAction.text,
            fontSize: 14,
            padding: const EdgeInsets.symmetric(
              vertical: 12,
            ),
            borderRadius: InstancyUIConfigurations.buttonBorderRadius,
            iconData: primaryAction.iconData,
            iconColor: themeData.colorScheme.onPrimary,
            iconPadding: const EdgeInsets.only(right: 10),
            iconSize: 20,
          ),
        ),
      ],
    );
  }

  Widget getKeywordsListWidget({required List<String> tags}) {
    if (tags.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: getWidgetWithTitle(
        title: "Keywords",
        widget: Wrap(
          children: tags.map((e) {
            return Container(
              margin: const EdgeInsets.only(right: 12, top: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: Styles.chipBackgroundColor, borderRadius: BorderRadius.circular(12)),
              child: Text(e, style: themeData.textTheme.bodySmall),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget getLearningObjectivesWidget({required String learningObjectives}) {
    if (learningObjectives.isEmpty) {
      return const SizedBox();
    }

    double? fontSize = themeData.textTheme.labelSmall?.fontSize;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: getWidgetWithTitle(
        title: appProvider.localStr.detailsLabelLearningobjectiveslabel,
        widget: Html(
          data: learningObjectives,
          style: {
            "body": Style(
              color: Colors.black.withOpacity(0.65),
              fontFamily: "Roboto",
              fontSize: fontSize != null ? FontSize(15.2) : null,
            ),
            // "font-size": Style(),
          },
        ),
      ),
    );
  }

  Widget getTableOfContentsWidget({required String tableOfContents}) {
    if (tableOfContents.isEmpty) {
      return const SizedBox();
    }

    double? fontSize = themeData.textTheme.labelSmall?.fontSize;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: getWidgetWithTitle(
        title: appProvider.localStr.detailsLabelTableofcontentlabel,
        widget: Html(
          data: tableOfContents,
          style: {
            "body": Style(
              color: Colors.black.withOpacity(0.65),
              fontFamily: "Roboto",
              fontSize: fontSize != null ? FontSize(15.2) : null,
            ),
            // "font-size": Style(),
          },
        ),
      ),
    );
  }

  //region courseDurationView
  Widget courseDurationView({required CourseDTOModel contentDetailsDTOModel}) {
    if (contentDetailsDTOModel.Duration.isEmpty) {
      return const SizedBox();
    }
    MyPrint.printOnConsole("contentDetailsDTOModel.Duration : ${contentDetailsDTOModel.Duration}");
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: getWidgetWithTitle(
          title: "Course Duration",
          widget: Row(
            children: [
              const Icon(Icons.access_time_filled_rounded),
              const SizedBox(
                width: 10,
              ),
              Text(ParsingHelper.parseStringMethod(contentDetailsDTOModel.Duration))
            ],
          )),
    );
  }

  //endregion
  //
  // region courseDurationView
  Widget directionUrl({required CourseDTOModel contentDetailsDTOModel}) {
    if (contentDetailsDTOModel.DirectionURL.isEmpty) {
      return const SizedBox();
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: getWidgetWithTitle(
        title: "URL",
        widget: InkWell(
          onTap: () {
            MyUtils.launchUrl(url: ParsingHelper.parseStringMethod(contentDetailsDTOModel.DirectionURL));
          },
          child: Text(
            ParsingHelper.parseStringMethod(contentDetailsDTOModel.DirectionURL),
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }

  //endregion

  //region programOutline
  Widget programOutlineView() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: getWidgetWithTitle(
        title: "Program Outline",
        widget: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: programOutlineList.map((e) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Styles.borderColor), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 2)]),
              child: Theme(
                data: themeData.copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  backgroundColor: Styles.chipBackgroundColor.withOpacity(0.4),
                  // collapsedBackgroundColor: Styles.chipBackgroundColor,

                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  expandedAlignment: Alignment.centerLeft,
                  iconColor: Colors.black,
                  collapsedIconColor: Colors.black,
                  title: Text(
                    e,
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  children: [
                    Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 9),
                        color: Colors.white,
                        child: Text(
                          "ajhsabcjhsabchjasbcjhdscjhscjh\nsdccacsknvnlkn\ncbahcbvcghwvevcfghavsbcghasvgh",
                          style: themeData.textTheme.bodySmall?.copyWith(fontSize: 10),
                        ))
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  //endregion

  //region authorView
  Widget getAuthorView({required CourseDTOModel contentDetailsDTOModel}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: getWidgetWithTitle(
        title: "Author",
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getAuthorImageAndNameWidget(contentDetailsDTOModel: contentDetailsDTOModel),
            const SizedBox(
              height: 10,
            ),
            /*const CommonReadMoreTextWidget(
              text: 'Flutter is Google’s mobile UI open source framework to build high-quality native (super fast) interfaces for iOS and Android apps with the unified codebase.and Android apps with the unified codebase.and Android apps with the unified codebase.and Android apps with the unified codebase.and Android apps with the unified codebase.and Android apps with the unified codebase.and Android apps with the unified codebase.and Android apps with the unified codebase.and Android apps with the unified codebase.and Android apps with the unified codebase.and Android apps with the unified codebase.',
              trimLines: 5,
            ),*/
          ],
        ),
      ),
    );
  }

  Widget getAuthorImageAndNameWidget({required CourseDTOModel contentDetailsDTOModel}) {
    MyPrint.printOnConsole("contentDetailsDTOModel.authorWithLink:${contentDetailsDTOModel.UserProfileImagePath}");
    String imageUrl = AppConfigurationOperations(appProvider: appProvider).getInstancyImageUrlFromImagePath(imagePath: contentDetailsDTOModel.UserProfileImagePath);
    MyPrint.printOnConsole("final imageUrl:$imageUrl");
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), border: Border.all(color: Colors.black)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CommonCachedNetworkImage(
              // imageUrl: "https://picsum.photos/200/300",
              imageUrl: imageUrl,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
              errorIconSize: 30,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contentDetailsDTOModel.AuthorName,
                style: themeData.textTheme.bodyLarge,
              ),
              /*Row(
                children: [
                  Text(
                    "4",
                    style: themeData.textTheme.titleSmall,
                  ),
                  const Icon(
                    Icons.star,
                    size: 15,
                    color: Styles.starYellowColor,
                  )
                ],
              ),*/
            ],
          ),
        ),
        /*Row(
          children: [
            const Icon(
              Icons.play_circle_outline_outlined,
              size: 15,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              "250 Courses",
              style: themeData.textTheme.titleSmall?.copyWith(fontSize: 12, color: Styles().lightTextColor),
            ),
          ],
        ),*/
      ],
    );
  }

  //endregion

  //region reviews
  Widget getReviews({required CourseDTOModel contentDetailsDTOModel}) {
    /*AppConfigurationOperations appConfigurationOperations = AppConfigurationOperations(appProvider: appProvider);

    if (!appConfigurationOperations.showReviewAndRatingSection(averageRating: contentDetailsDTOModel.RatingID)) {
      return const SizedBox();
    }*/

    Widget child;

    PaginationModel paginationModel = contentReviewRatingsProvider.paginationModel.get();

    if (paginationModel.isFirstTimeLoading) {
      child = const CommonLoader(
        isCenter: true,
      );
    } else {
      List<ContentUserRatingModel> reviewsList = contentReviewRatingsProvider.userReviewsList.getList(isNewInstance: false);
      if (reviewsList.isEmpty) {
        child = Center(
          child: Text(appProvider.localStr.commoncomponentLabelNodatalabel),
        );
      } else {
        child = ListView.builder(
          shrinkWrap: true,
          itemCount: reviewsList.length + 1,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            if ((index == 0 && reviewsList.isEmpty) || index == reviewsList.length) {
              if (paginationModel.isLoading) {
                return const CommonLoader(
                  isCenter: true,
                );
              } else {
                return const SizedBox();
              }
            }

            ContentUserRatingModel contentUserRatingModel = reviewsList[index];

            return ContentUserReviewCard(
              ratingModel: contentUserRatingModel,
              isEditingEnabled: /*appConfigurationOperations.allowUserToRateCourse(actualContentStatus: contentDetailsDTOModel.ActualStatus) &&
                  */
                  contentUserRatingModel.ratingUserId == ApiController().apiDataProvider.getCurrentUserId(),
              onEditingTap: () async {
                onReviewTap(userLastReviewModel: contentUserRatingModel);
              },
            );
          },
        );
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: getWidgetWithTitle(
        title: "Reviews",
        trailingWidget: getReviewsSeeAllButton(),
        widget: child,
      ),
    );
  }

  Widget? getReviewsSeeAllButton() {
    PaginationModel paginationModel = contentReviewRatingsProvider.paginationModel.get();
    if (paginationModel.isFirstTimeLoading || paginationModel.isLoading || !paginationModel.hasMore) {
      return null;
    }

    return GestureDetector(
      onTap: () {
        contentReviewRatingsController.getReviewsList(
          contentId: contentId,
          componentId: componentId,
          isRefresh: false,
        );
      },
      child: Text(
        "See All",
        style: themeData.textTheme.titleMedium?.copyWith(color: themeData.primaryColor, fontSize: 12, fontWeight: FontWeight.w800),
      ),
    );
  }

  //endregion

  //region ratings
  Widget getRatings({required CourseDTOModel contentDetailsDTOModel}) {
    /*MyPrint.printOnConsole(
        "contentDetailsDTOModel.RatingID : ${contentDetailsDTOModel.RatingID} : appProvider.appSystemConfigurationModel.minimumRatingRequiredToShowRating: ${appProvider.appSystemConfigurationModel.minimumRatingRequiredToShowRating}");
    if (!AppConfigurationOperations(appProvider: appProvider).showReviewAndRatingSection(averageRating: contentDetailsDTOModel.RatingID)) {
      return const SizedBox();
    }*/

    ContentUserRatingModel? userLastReviewModel = contentReviewRatingsProvider.userLastReviewModel.get();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: getWidgetWithTitle(
        title: "Course Ratings",
        trailingWidget: !contentReviewRatingsProvider.paginationModel.get().isLoading &&
                userLastReviewModel == null &&
                AppConfigurationOperations(appProvider: appProvider).allowUserToRateCourse(actualContentStatus: contentDetailsDTOModel.ActualStatus)
            ? GestureDetector(
                onTap: () {
                  onReviewTap(userLastReviewModel: null);
                },
                child: Text(
                  "Add Review",
                  style: themeData.textTheme.bodySmall?.copyWith(
                    color: themeData.primaryColor,
                  ),
                ),
              )
            : null,
        widget: Row(
          children: [
            ratingGiver(rating: contentDetailsDTOModel.RatingID),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                "Rated ${contentDetailsDTOModel.RatingID} out of 5 of ${contentReviewRatingsProvider.maxReviewsCount.get()} ratings",
                style: themeData.textTheme.titleMedium?.copyWith(color: Styles.lightTextColor2.withOpacity(0.5), fontSize: 14),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget ratingGiver({required double rating}) {
    return RatingBar.builder(
      initialRating: rating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 30,
      unratedColor: Styles.chipBackgroundColor,
      glow: false,
      tapOnlyMode: true,
      itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Styles.starYellowColor,
        size: 15,
      ),
      ignoreGestures: true,
      onRatingUpdate: (rating) async {
        MyPrint.printOnConsole("rating:$rating");
        // totalRating = ParsingHelper.parseIntMethod(rating);
        // setState(() {});
      },
    );
  }

  //endregion

  Widget getMultiInstanceEventScheduleListWidget({required CourseDetailsProvider courseDetailsProvider}) {
    CourseDTOModel? contentDetailsDTOModel = courseDetailsProvider.contentDetailsDTOModel.get();

    if (contentDetailsDTOModel == null ||
        contentDetailsDTOModel.ContentTypeId != InstancyObjectTypes.events ||
        (contentDetailsDTOModel.EventScheduleType != 1 && contentDetailsDTOModel.EventScheduleType != 2) ||
        !contentDetailsDTOModel.showSchedule) {
      return const SizedBox();
    }

    if (courseDetailsProvider.isLoadingContentDetailsScheduleData.get()) {
      return const CommonLoader(
        isCenter: true,
      );
    }

    Widget child;

    List<CourseDTOModel> scheduleData = courseDetailsProvider.scheduleData.getList(isNewInstance: false);

    if (scheduleData.isEmpty) {
      child = Center(
        child: Text(appProvider.localStr.commoncomponentLabelNodatalabel),
      );
    } else {
      child = ListView.builder(
        shrinkWrap: true,
        itemCount: scheduleData.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          CourseDTOModel catalogCourseDtoModel = scheduleData[index];

          return ScheduleEventCard(
            catalogCourseDtoModel: catalogCourseDtoModel,
            onEnrollTap: () async {
              addContentToMyLearning(
                courseDTOModel: catalogCourseDtoModel,
                contentIdToLoadInScreen: catalogCourseDtoModel.ContentID,
                multiInstanceParentId: catalogCourseDtoModel.InstanceParentContentID,
                MultiInstanceEventEnroll: widget.arguments.isRescheduleEvent ? "rescheduleenroll" : "",
              );
            },
            onCancelEnrollmentTap: () async {
              isLoading = true;
              mySetState();

              bool isCancelled = await EventController(eventProvider: null).cancelEventEnrollment(
                context: context,
                eventId: catalogCourseDtoModel.ContentID,
                isBadCancellationEnabled: catalogCourseDtoModel.isBadCancellationEnabled,
              );
              MyPrint.printOnConsole("isCancelled:$isCancelled");

              isLoading = false;

              if (isCancelled) {
                futureGetData = getContentDetailsData();
              }

              mySetState();
            },
          );
        },
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: getWidgetWithTitle(
        title: "Teaching Schedule",
        widget: child,
      ),
    );
  }

  Widget getEventSessionsListWidget({
    CourseDTOModel? contentDetailsDTOModel,
    required EventProvider eventProvider,
  }) {
    if (contentDetailsDTOModel == null || contentDetailsDTOModel.ContentTypeId != InstancyObjectTypes.events || contentDetailsDTOModel.EventType != EventTypes.session) {
      return const SizedBox();
    }

    if (eventProvider.isLoadingEventSessionData.get()) {
      return const CommonLoader(
        isCenter: true,
      );
    }

    Widget child;

    List<CourseDTOModel> scheduleData = eventProvider.eventSessionData.getList(isNewInstance: false);

    if (scheduleData.isEmpty) {
      child = Center(
        child: Text(appProvider.localStr.commoncomponentLabelNodatalabel),
      );
    } else {
      child = ListView.builder(
        shrinkWrap: true,
        itemCount: scheduleData.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          CourseDTOModel courseDTOModel = scheduleData[index];

          return EventSessionCard(courseDTOModel: courseDTOModel);
        },
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: getWidgetWithTitle(
        title: appProvider.localStr.detailsLabelSessionstitlelable,
        widget: child,
      ),
    );
  }

  Widget getWidgetWithTitle({String title = "", Widget? widget, Widget? trailingWidget}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: Text(
              title,
              style: themeData.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.5),
            )),
            trailingWidget ?? Container()
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        widget ?? Container()
      ],
    );
  }
}
