import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/Catalog/catalog_controller.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/authentication/authentication_provider.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_controller.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_provider.dart';
import 'package:flutter_instancy_2/backend/course_launch/course_launch_controller.dart';
import 'package:flutter_instancy_2/backend/event/event_controller.dart';
import 'package:flutter_instancy_2/backend/filter/filter_controller.dart';
import 'package:flutter_instancy_2/backend/my_learning/my_learning_controller.dart';
import 'package:flutter_instancy_2/backend/my_learning/my_learning_provider.dart';
import 'package:flutter_instancy_2/backend/profile/profile_provider.dart';
import 'package:flutter_instancy_2/backend/share/share_provider.dart';
import 'package:flutter_instancy_2/backend/ui_actions/my_course_download/my_course_download_ui_action_callback_model.dart';
import 'package:flutter_instancy_2/backend/ui_actions/my_course_download/my_course_download_ui_actions_controller.dart';
import 'package:flutter_instancy_2/backend/ui_actions/my_learning/my_learning_ui_action_callback_model.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/classroom_events/data_model/EventRecordingDetailsModel.dart';
import 'package:flutter_instancy_2/models/common/pagination/pagination_model.dart';
import 'package:flutter_instancy_2/models/course_download/data_model/course_download_data_model.dart';
import 'package:flutter_instancy_2/models/my_learning/response_model/page_notes_response_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/views/common/components/common_text_form_field.dart';
import 'package:flutter_instancy_2/views/common/components/modal_progress_hud.dart';
import 'package:flutter_instancy_2/views/my_learning/component/my_learning_card.dart';
import 'package:provider/provider.dart';

import '../../../api/api_url_configuration_provider.dart';
import '../../../backend/filter/filter_provider.dart';
import '../../../backend/navigation/navigation.dart';
import '../../../backend/ui_actions/my_learning/my_learning_ui_actions_controller.dart';
import '../../../backend/ui_actions/primary_secondary_actions/primary_secondary_actions.dart';
import '../../../models/app_configuration_models/data_models/local_str.dart';
import '../../../models/app_configuration_models/data_models/native_menu_component_model.dart';
import '../../../models/course/data_model/CourseDTOModel.dart';
import '../../../models/course_launch/data_model/course_launch_model.dart';
import '../../../models/event_track/request_model/view_recording_request_model.dart';
import '../../../utils/parsing_helper.dart';
import '../../common/components/common_loader.dart';
import '../../common/components/instancy_ui_actions/instancy_ui_actions.dart';
import '../../filter/components/selected_filters_listview_component.dart';
import '../component/notes_dialog.dart';

class MyLearningScreen extends StatefulWidget {
  final int componentId, componentInstanceId;
  final MyLearningProvider? provider;

  const MyLearningScreen({
    Key? key,
    required this.componentId,
    required this.componentInstanceId,
    this.provider,
  }) : super(key: key);

  @override
  State<MyLearningScreen> createState() => _MyLearningScreenState();
}

class _MyLearningScreenState extends State<MyLearningScreen> with TickerProviderStateMixin, MySafeState {
  late MyLearningProvider myLearningProvider;
  late MyLearningController myLearningController;
  late AppProvider appProvider;
  late ProfileProvider profileProvider;

  late CourseDownloadProvider courseDownloadProvider;
  late CourseDownloadController courseDownloadController;

  bool isLoading = false;

  int componentId = 0, componentInstanceId = 0;

  ScrollController myLearningScrollController = ScrollController(), myLearningArchivedScrollController = ScrollController();

  TabController? tabController;

  TextEditingController searchController = TextEditingController();
  TextEditingController archivedSearchController = TextEditingController();

  void initializations() {
    myLearningProvider = widget.provider ?? MyLearningProvider();
    myLearningController = MyLearningController(provider: myLearningProvider);
    appProvider = Provider.of<AppProvider>(context, listen: false);
    profileProvider = context.read<ProfileProvider>();

    courseDownloadProvider = context.read<CourseDownloadProvider>();
    courseDownloadController = CourseDownloadController(appProvider: appProvider, courseDownloadProvider: courseDownloadProvider);

    searchController.text = myLearningProvider.myLearningSearchString;
    archivedSearchController.text = myLearningProvider.myLearningArchivedSearchString;

    componentId = widget.componentId;
    componentInstanceId = widget.componentInstanceId;

    NativeMenuComponentModel? componentModel = appProvider.getMenuComponentModelFromComponentId(componentId: componentId);
    if (componentModel != null) {
      myLearningController.initializeMyLearningConfigurationsFromComponentConfigurationsModel(
        componentConfigurationsModel: componentModel.componentConfigurationsModel,
      );
    }

    bool isGetMyLearningContents = false, isGetMyLearningArchivedContents = false;

    if (myLearningProvider.myLearningContentsLength == 0) {
      isGetMyLearningContents = true;
    }

    if (myLearningProvider.archieveEnabled.get() && myLearningProvider.myLearningArchivedContentsLength == 0) {
      isGetMyLearningArchivedContents = true;
    }

    if (CatalogController.isAddedContentToMyLearning) {
      CatalogController.isAddedContentToMyLearning = false;
      isGetMyLearningContents = true;
      isGetMyLearningArchivedContents = true;

      searchController.clear();
      archivedSearchController.clear();
      myLearningProvider.setMyLearningSearchString(value: "", isNotify: false);
      myLearningProvider.setMyLearningArchivedSearchString(value: "", isNotify: false);
      FilterController(filterProvider: myLearningProvider.filterProvider).resetFilterData();
    }

    if (isGetMyLearningContents) {
      getMyLearningContentsList(
        isArchive: false,
        isRefresh: true,
        isGetFromCache: false,
        isNotify: false,
      );
    }

    if (isGetMyLearningArchivedContents) {
      getMyLearningContentsList(
        isArchive: true,
        isRefresh: true,
        isGetFromCache: false,
        isNotify: false,
      );
    }

    tabController = TabController(vsync: this, length: myLearningProvider.archieveEnabled.get() ? 2 : 1);
  }

  Future<void> getMyLearningContentsList({bool isArchive = true, bool isRefresh = true, bool isGetFromCache = true, bool isNotify = true}) async {
    if (isArchive) {
      myLearningController.getMyLearningArchivedContentsListFromApi(
        isRefresh: isRefresh,
        isGetFromCache: isGetFromCache,
        isNotify: isNotify,
        componentId: componentId,
        componentInstanceId: componentInstanceId,
      );
    } else {
      myLearningController.getMyLearningContentsListFromApi(
        isRefresh: isRefresh,
        isGetFromCache: isGetFromCache,
        isNotify: isNotify,
        componentId: componentId,
        componentInstanceId: componentInstanceId,
      );
    }
  }

  Future<void> refreshMyLearningData({bool isMyLearning = true, bool isArchived = true}) async {
    if (isMyLearning) {
      getMyLearningContentsList(
        isRefresh: true,
        isGetFromCache: false,
        isArchive: false,
        isNotify: true,
      );
    }
    if (isArchived) {
      getMyLearningContentsList(
        isRefresh: true,
        isGetFromCache: false,
        isArchive: true,
        isNotify: true,
      );
    }
  }

  MyLearningUIActionCallbackModel getMyLearningUIActionCallbackModel({
    required CourseDTOModel model,
    InstancyContentActionsEnum? primaryAction,
    bool isSecondaryAction = true,
    required bool isArchived,
  }) {
    return MyLearningUIActionCallbackModel(
      onEnrollTap: primaryAction == InstancyContentActionsEnum.Enroll
          ? null
          : () {
              if (isSecondaryAction) Navigator.pop(context);

              onDetailsTap(model: model);
            },
      onReEnrollTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        onDetailsTap(model: model, isReEnroll: true);
      },
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

          refreshMyLearningData();
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

          refreshMyLearningData();
        }
      },
      onDetailsTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        onDetailsTap(model: model);
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
      onViewTap: primaryAction == InstancyContentActionsEnum.View
          ? null
          : () {
              if (isSecondaryAction) Navigator.pop(context);

              onContentLaunchTap(model: model, isArchived: isArchived);
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
                ),
              );

              if (value == true) {
                refreshMyLearningData();
              }
            },
      onAddToCalenderTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        bool isSuccess = await EventController(eventProvider: null).addEventToCalender(
          context: context,
          EventStartDateTime: model.EventStartDateTime,
          EventEndDateTime: model.EventEndDateTime,
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
        );
        MyPrint.printOnConsole("SetComplete isSuccess:$isSuccess");

        isLoading = false;
        mySetState();

        if (isSuccess) {
          if (pageMounted && context.mounted) MyToast.showSuccess(context: context, msg: "Set Complete was successful");

          refreshMyLearningData();
        }
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

          refreshMyLearningData();
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

          refreshMyLearningData();
        }
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
      onViewRecordingTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        EventRecordingDetailsModel? recordingDetails = model.RecordingDetails;

        if (recordingDetails == null) {
          MyPrint.printOnConsole("recordingDetails are null");
          return;
        }

        ViewRecordingRequestModel viewRecordingRequestModel = ViewRecordingRequestModel(
          contentName: recordingDetails.ContentName,
          contentID: recordingDetails.ContentID,
          contentTypeId: ParsingHelper.parseIntMethod(recordingDetails.ContentTypeId),
          eventRecordingURL: recordingDetails.EventRecordingURL,
          eventRecording: ParsingHelper.parseBoolMethod(recordingDetails.EventRecording),
          jWVideoKey: recordingDetails.JWVideoKey,
          language: recordingDetails.Language,
          recordingType: recordingDetails.RecordingType,
          scoID: recordingDetails.ScoID,
          jwVideoPath: recordingDetails.ViewLink,
          viewType: recordingDetails.ViewType,
        );

        EventController(eventProvider: null).viewRecordingForEvent(model: viewRecordingRequestModel, context: context);
      },
      onRescheduleTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        // String parentContentId = model.InstanceParentContentID;
        String parentContentId = model.InstanceEventReSchedule;
        int index = parentContentId.indexOf("/componentid");
        if (index > 0) {
          parentContentId = parentContentId.substring(0, index);
          index = parentContentId.lastIndexOf("/");
          if (index > 0) {
            parentContentId = parentContentId.substring(index + 1);
          }
        }

        if (parentContentId.isNotEmpty) {
          await NavigationController.navigateToCourseDetailScreen(
            navigationOperationParameters: NavigationOperationParameters(
              context: context,
              navigationType: NavigationType.pushNamed,
            ),
            arguments: CourseDetailScreenNavigationArguments(
              contentId: parentContentId,
              componentId: InstancyComponents.Catalog,
              isRescheduleEvent: true,
              componentInstanceId: componentInstanceId,
              userId: model.SiteUserID,
              screenType: InstancyContentScreenType.MyLearning,
              myLearningProvider: myLearningProvider,
            ),
          );

          refreshMyLearningData();
        }
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
          ),
        );

        // if (value == true) {
        //   refreshMyLearningData();
        // }
      },
      onReportTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        MyPrint.printOnConsole("contentIddddd : ${model.ContentID}, userId: ${model.SiteUserID} contentTypeId: ${model.ContentTypeId} componentId:$componentId");
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
      },
      onPlayTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        onContentLaunchTap(model: model, isArchived: isArchived);
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
      onShareWithPeopleTap: () async {
        if (isSecondaryAction) Navigator.pop(context);
        // MyPrint.printOnConsole("model.Title ${model.TitleName}");
        NavigationController.navigateToShareWithPeopleScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: ShareWithPeopleScreenNavigationArguments(
            shareContentType: ShareContentType.catalogCourse,
            contentId: model.ContentID,
            contentName: model.TitleName,
            scoId: model.ScoID,
            objecttypeId: model.ContentTypeId,
          ),
        );
      },
      onShareTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        MyPrint.printOnConsole("model.Sharelink:${model.Sharelink}");
        MyUtils.shareContent(content: model.Sharelink);
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
    );
  }

  Future<void> showMoreAction({
    required CourseDTOModel model,
    InstancyContentActionsEnum? primaryAction,
    required bool isArchived,
  }) async {
    LocalStr localStr = appProvider.localStr;

    List<InstancyUIActionModel> options = <InstancyUIActionModel>[];

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

    MyLearningUIActionsController myLearningUIActionsController = MyLearningUIActionsController(
      appProvider: appProvider,
      myLearningProvider: myLearningProvider,
      profileProvider: profileProvider,
    );

    options.addAll(myLearningUIActionsController
        .getMyLearningScreenSecondaryActions(
          myLearningCourseDTOModel: model,
          localStr: localStr,
          myLearningUIActionCallbackModel: getMyLearningUIActionCallbackModel(
            model: model,
            primaryAction: primaryAction,
            isSecondaryAction: true,
            isArchived: isArchived,
          ),
        )
        .toSet()
        .toList());

    if (options.isEmpty) {
      return;
    }

    InstancyUIActions().showAction(
      context: context,
      actions: options,
    );
  }

  Future<void> onDownloadButtonTapped({required CourseDTOModel model}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("onDownloadTap called", tag: tag);

    String downloadId = CourseDownloadDataModel.getDownloadId(contentId: model.ContentID);

    CourseDownloadDataModel? courseDownloadDataModel = courseDownloadProvider.getCourseDownloadDataModelFromId(courseDownloadId: downloadId);

    if (courseDownloadDataModel == null) {
      MyPrint.printOnConsole("Course Not Downloaded", tag: tag);
      courseDownloadController.downloadCourse(courseDTOModel: model);
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

  Future<void> onContentLaunchTap({
    required CourseDTOModel model,
    required bool isArchived,
  }) async {
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = myLearningController.myLearningRepository.apiController.apiDataProvider;

    isLoading = true;
    mySetState();

    bool isLaunched = await CourseLaunchController(
      appProvider: appProvider,
      authenticationProvider: context.read<AuthenticationProvider>(),
      componentId: componentId,
      componentInstanceId: componentInstanceId,
    ).viewCourse(
      context: context,
      model: CourseLaunchModel(
        ContentTypeId: model.ContentTypeId,
        MediaTypeId: model.MediaTypeID,
        ScoID: model.ScoID,
        SiteUserID: apiUrlConfigurationProvider.getCurrentUserId(),
        SiteId: apiUrlConfigurationProvider.getCurrentSiteId(),
        ContentID: model.ContentID,
        locale: apiUrlConfigurationProvider.getLocale(),
        ActivityId: model.ActivityId,
        ActualStatus: model.ActualStatus,
        ContentName: model.ContentName,
        FolderPath: model.FolderPath,
        JWVideoKey: model.JWVideoKey,
        jwstartpage: model.jwstartpage,
        startPage: model.startpage,
        bit5: model.bit5,
      ),
    );

    isLoading = false;
    mySetState();

    if (isLaunched) {
      getMyLearningContentsList(
        isRefresh: true,
        isNotify: true,
        isGetFromCache: false,
        isArchive: isArchived,
      );
    }
  }

  Future<void> onDetailsTap({required CourseDTOModel model, bool isReEnroll = false}) async {
    dynamic value = await NavigationController.navigateToCourseDetailScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      arguments: CourseDetailScreenNavigationArguments(
          contentId: isReEnroll ? model.InstanceParentContentID : model.ContentID,
          componentId: isReEnroll ? InstancyComponents.Catalog : componentId,
          componentInstanceId: componentInstanceId,
          userId: model.SiteUserID,
          screenType: InstancyContentScreenType.MyLearning,
          isReEnroll: isReEnroll),
    );
    MyPrint.printOnConsole("CourseDetailScreen return value:$value");

    refreshMyLearningData();
  }

  Future<PageNotesResponseModel>? getNotes;

  Future<PageNotesResponseModel> getNotesData({
    String contentId = "",
  }) async {
    PageNotesResponseModel pageNotesResponseModel = await myLearningController.getAllUserPageNotes(
      contentId: contentId,
      componentId: componentId,
      componentInstanceId: componentInstanceId,
    );
    return pageNotesResponseModel;
  }

  TextEditingController notesController = TextEditingController();

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
        });
  }

  Future<void> navigateToFilterScreen({String? contentFilterByTypes, required searchString, required TextEditingController searchController}) async {
    MyPrint.printOnConsole("navigateToFilterScreen called with contentFilterByTypes:$contentFilterByTypes");

    NativeMenuComponentModel? componentModel = appProvider.getMenuComponentModelFromComponentId(componentId: componentId);

    if (componentModel == null) {
      return;
    }

    dynamic value = await NavigationController.navigateToFiltersScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      arguments: FiltersScreenNavigationArguments(
        componentId: widget.componentId,
        filterProvider: myLearningProvider.filterProvider,
        componentConfigurationsModel: componentModel.componentConfigurationsModel,
        contentFilterByTypes: contentFilterByTypes,
      ),
    );

    if (value == true) {
      if (context.checkMounted() && context.mounted) {
        FocusScope.of(context).requestFocus(FocusNode());
      }

      if (searchString != searchController.text.trim()) {
        searchController.text = searchString;
      }

      getMyLearningContentsList(
        isRefresh: true,
        isArchive: false,
        isNotify: true,
        isGetFromCache: false,
      );

      getMyLearningContentsList(
        isRefresh: true,
        isArchive: true,
        isNotify: true,
        isGetFromCache: false,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    initializations();
  }

  @override
  void didUpdateWidget(covariant MyLearningScreen oldWidget) {
    if (widget.provider != oldWidget.provider || widget.componentId != oldWidget.componentId || widget.componentInstanceId != oldWidget.componentInstanceId) {
      initializations();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    // MyPrint.printOnConsole("showArchieve:${myLearningProvider.archieveEnabled.get()}");
    // MyPrint.printOnConsole("tab controller length:${tabController?.length}");

    return ChangeNotifierProvider<MyLearningProvider>.value(
      value: myLearningProvider,
      child: Consumer<MyLearningProvider>(
        builder: (BuildContext context, MyLearningProvider myLearningProvider, Widget? child) {
          int tabsLengthToKeep = myLearningProvider.archieveEnabled.get() ? 2 : 1;
          // MyPrint.printOnConsole("tabsLengthToKeep:$tabsLengthToKeep");
          if (tabController != null) {
            if (tabController!.length != tabsLengthToKeep) {
              MyPrint.printOnConsole("ReInitializing Tab Controller");
              // tabController!.dispose();
              tabController = TabController(length: tabsLengthToKeep, vsync: this);
            }
          }

          return getMainBody();
        },
      ),
    );
  }

  Widget getMainBody() {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: const CommonLoader(),
      child: Scaffold(
        appBar: getAppBar(),
        body: Container(
          color: Colors.white,
          child: TabBarView(
            controller: tabController,
            children: <Widget>[
              getMyLearningContentsListView(),
              if (myLearningProvider.archieveEnabled.get()) getMyLearningArchiveContentsListView(),
            ],
          ),
        ),
      ),
    );

    // return defaultTabBar();
  }

  PreferredSize? getAppBar() {
    if (!myLearningProvider.archieveEnabled.get()) {
      return null;
    }

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.5), width: 0.2)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(child: SizedBox()),
              TabBar(
                controller: tabController,
                padding: const EdgeInsets.symmetric(vertical: 0),
                labelPadding: const EdgeInsets.all(0),
                indicatorPadding: const EdgeInsets.only(top: 20),
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: themeData.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
                tabs: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("My Learning"),
                  ),
                  if (myLearningProvider.archieveEnabled.get())
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Archive"),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getMyLearningContentsListView() {
    return getContentsPageWithSearchbar(
      searchController: searchController,
      searchString: myLearningProvider.myLearningSearchString,
      scrollController: myLearningScrollController,
      contents: myLearningProvider.myLearningContentIds,
      contentsLength: myLearningProvider.myLearningContentsLength,
      paginationModel: myLearningProvider.myLearningPaginationModel,
      isArchived: false,
      onRefresh: () async {
        getMyLearningContentsList(
          isArchive: false,
          isRefresh: true,
          isGetFromCache: false,
          isNotify: true,
        );
      },
      onPagination: () async {
        getMyLearningContentsList(
          isArchive: false,
          isRefresh: false,
          isGetFromCache: false,
          isNotify: false,
        );
      },
      onSubmitted: (String text) {
        bool isSearch = false;
        if (text.isEmpty) {
          if (myLearningProvider.myLearningSearchString.isNotEmpty) {
            isSearch = true;
          }
        } else {
          if (text != myLearningProvider.myLearningSearchString) {
            isSearch = true;
          }
        }
        if (isSearch) {
          myLearningProvider.setMyLearningSearchString(value: text);
          refreshMyLearningData(isMyLearning: true, isArchived: false);
        }
      },
      isShowClearSearchButton: searchController.text.isNotEmpty || (myLearningProvider.myLearningSearchString.isNotEmpty && myLearningProvider.myLearningSearchString == searchController.text),
    );
  }

  Widget getMyLearningArchiveContentsListView() {
    return getContentsPageWithSearchbar(
      searchController: archivedSearchController,
      searchString: myLearningProvider.myLearningArchivedSearchString,
      scrollController: myLearningArchivedScrollController,
      contents: myLearningProvider.myLearningArchivedContentIds,
      contentsLength: myLearningProvider.myLearningArchivedContentsLength,
      paginationModel: myLearningProvider.myLearningArchivedPaginationModel,
      isArchived: true,
      onRefresh: () async {
        getMyLearningContentsList(
          isArchive: true,
          isRefresh: true,
          isGetFromCache: false,
          isNotify: true,
        );
      },
      onPagination: () async {
        getMyLearningContentsList(
          isArchive: true,
          isRefresh: false,
          isGetFromCache: false,
          isNotify: false,
        );
      },
      onSubmitted: (String text) {
        bool isSearch = false;
        if (text.isEmpty) {
          if (myLearningProvider.myLearningArchivedSearchString.isNotEmpty) {
            isSearch = true;
          }
        } else {
          if (text != myLearningProvider.myLearningArchivedSearchString) {
            isSearch = true;
          }
        }
        if (isSearch) {
          myLearningProvider.setMyLearningArchivedSearchString(value: text);
          refreshMyLearningData(isMyLearning: false, isArchived: true);
        }
      },
      isShowClearSearchButton: archivedSearchController.text.isNotEmpty ||
          (myLearningProvider.myLearningArchivedSearchString.isNotEmpty && myLearningProvider.myLearningArchivedSearchString == archivedSearchController.text),
    );
  }

  Widget getContentsPageWithSearchbar({
    required TextEditingController searchController,
    required String searchString,
    required ScrollController scrollController,
    ValueChanged<String>? onSubmitted,
    bool isShowClearSearchButton = false,
    required PaginationModel paginationModel,
    required int contentsLength,
    required List<String> contents,
    required Future<void> Function() onRefresh,
    required Future<void> Function() onPagination,
    required bool isArchived,
  }) {
    Widget child;

    if (paginationModel.isFirstTimeLoading) {
      child = const Center(
        child: CommonLoader(),
      );
    } else if (!paginationModel.isLoading && contentsLength == 0) {
      child = RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: context.sizeData.height * 0.2),
            AppConfigurations.commonNoDataView(),
          ],
        ),
      );
    } else {
      // MyPrint.printOnConsole("My Learning Contents length In MyLearningScreen().getMyLearningContentsListView():${contents.length}");

      child = RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView.builder(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: contents.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if ((index == 0 && contents.isEmpty) || index == contents.length) {
              if (paginationModel.isLoading) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: const Center(
                    child: CommonLoader(
                      size: 70,
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            }

            if (index > (contentsLength - paginationModel.refreshLimit)) {
              if (paginationModel.hasMore && !paginationModel.isLoading) {
                onPagination();
              }
            }

            String contentId = contents[index];
            CourseDTOModel? model = myLearningProvider.getMyLearningContentModelFromId(contentId: contentId);

            if (model == null) return const SizedBox();

            return getMyLearningContentWidget(model: model, isArchived: isArchived);
          },
        ),
      );
    }

    return Column(
      children: [
        searchTextFormField(
          searchController: searchController,
          searchString: searchString,
          onSubmitted: onSubmitted,
          isShowClearSearchButton: isShowClearSearchButton,
        ),
        getSelectedFiltersListviewWidget(
          searchController: searchController,
          searchString: searchString,
        ),
        Expanded(
          child: child,
        ),
      ],
    );
  }

  Widget getMyLearningContentWidget({
    required CourseDTOModel model,
    required bool isArchived,
  }) {
    LocalStr localStr = appProvider.localStr;

    MyLearningUIActionsController myLearningUIActionsController = MyLearningUIActionsController(
      appProvider: appProvider,
      myLearningProvider: myLearningProvider,
      profileProvider: profileProvider,
    );

    List<InstancyUIActionModel> options = myLearningUIActionsController
        .getMyLearningScreenPrimaryActions(
      model: model,
          myLearningUIActionCallbackModel: getMyLearningUIActionCallbackModel(
            model: model,
            isSecondaryAction: false,
            isArchived: isArchived,
          ),
          localStr: localStr,
        )
        .toList();

    InstancyUIActionModel? primaryAction = options.firstElement;
    InstancyContentActionsEnum? primaryActionEnum = primaryAction?.actionsEnum;
    // MyPrint.printOnConsole("primaryActionEnum:$primaryActionEnum");

    return MyLearningCard(
      courseDTOModel: model,
      primaryAction: primaryAction,
      onMoreButtonTap: () {
        showMoreAction(model: model, isArchived: isArchived);
      },
      onPrimaryActionTap: () async {
        MyPrint.printOnConsole("primaryActionsEnum:$primaryActionEnum");

        if (primaryAction?.onTap != null) primaryAction!.onTap!();
      },
      onThumbnailClick: () async {
        if (model.ContentTypeId == InstancyObjectTypes.events) {
          LocalStr localStr = appProvider.localStr;

          MyLearningUIActionsController myLearningUIActionsController = MyLearningUIActionsController(
            appProvider: appProvider,
            myLearningProvider: myLearningProvider,
            profileProvider: profileProvider,
          );

          List<InstancyUIActionModel> options = myLearningUIActionsController
              .getMyLearningScreenSecondaryActions(
                myLearningCourseDTOModel: model,
                localStr: localStr,
                myLearningUIActionCallbackModel: getMyLearningUIActionCallbackModel(
                  model: model,
                  isSecondaryAction: false,
                  isArchived: isArchived,
                ),
              )
              .toSet()
              .where((element) => element.actionsEnum == InstancyContentActionsEnum.ViewResources)
              .toList();

          if (options.isNotEmpty) {
            InstancyUIActionModel instancyUIActionModel = options.first;
            if (instancyUIActionModel.onTap != null) {
              instancyUIActionModel.onTap!();
              return;
            }
          }
        }

        if (primaryAction?.onTap != null) primaryAction!.onTap!();
      },
      onDownloadTap: () async {
        onDownloadButtonTapped(model: model);
      },
    );
  }

  Widget searchTextFormField({
    required TextEditingController searchController,
    required String searchString,
    ValueChanged<String>? onSubmitted,
    bool isShowClearSearchButton = false,
  }) {
    Widget? filterSuffixIcon;

    if (myLearningProvider.filterEnabled.get()) {
      int selectedFiltersCount = myLearningProvider.filterProvider.selectedFiltersCount();

      filterSuffixIcon = Stack(
        children: [
          Container(
            margin: selectedFiltersCount > 0 ? const EdgeInsets.only(top: 5, right: 5) : null,
            child: InkWell(
              onTap: () async {
                navigateToFilterScreen(searchString: searchString, searchController: searchController);
              },
              child: const Icon(
                Icons.tune,
              ),
            ),
          ),
          if (selectedFiltersCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: themeData.primaryColor,
                ),
                child: Text(
                  selectedFiltersCount.toString(),
                  style: themeData.textTheme.labelSmall?.copyWith(
                    color: themeData.colorScheme.onPrimary,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      );
    }

    Widget? sortSuffixIcon;

    if (myLearningProvider.sortEnabled.get()) {
      sortSuffixIcon = IconButton(
        onPressed: () async {
          dynamic value = await NavigationController.navigateToSortingScreen(
            navigationOperationParameters: NavigationOperationParameters(
              context: context,
              navigationType: NavigationType.pushNamed,
            ),
            arguments: SortingScreenNavigationArguments(
              componentId: widget.componentId,
              filterProvider: myLearningProvider.filterProvider,
            ),
          );

          if (value == true) {
            if (context.checkMounted() && context.mounted) {
              FocusScope.of(context).requestFocus(FocusNode());
            }

            if (searchString != searchController.text.trim()) {
              searchController.text = searchString;
            }

            getMyLearningContentsList(
              isRefresh: true,
              isArchive: false,
              isNotify: true,
              isGetFromCache: false,
            );

            getMyLearningContentsList(
              isRefresh: true,
              isArchive: true,
              isNotify: true,
              isGetFromCache: false,
            );
          }
        },
        icon: const Icon(
          Icons.sort,
        ),
      );
    }

    Widget? clearSearchSuffixIcon;

    if (isShowClearSearchButton) {
      clearSearchSuffixIcon = IconButton(
        onPressed: () async {
          searchController.clear();
          mySetState();
          if (onSubmitted != null) onSubmitted("");
        },
        icon: const Icon(
          Icons.close,
        ),
      );
    }

    List<Widget> actions = <Widget>[];
    if (clearSearchSuffixIcon != null) actions.add(clearSearchSuffixIcon);
    if (filterSuffixIcon != null) actions.add(filterSuffixIcon);
    if (sortSuffixIcon != null) actions.add(sortSuffixIcon);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
      child: CommonTextFormField(
        onSubmitted: onSubmitted,
        onChanged: (String text) {
          mySetState();
        },
        controller: searchController,
        isOutlineInputBorder: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        borderRadius: 25,
        hintText: "Search",
        textInputAction: TextInputAction.search,
        prefixWidget: const Icon(Icons.search),
        suffixWidget: actions.isNotEmpty
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: actions,
              )
            : null,
      ),
    );
  }

  Widget getSelectedFiltersListviewWidget({required searchString, required TextEditingController searchController}) {
    FilterProvider filterProvider = myLearningProvider.filterProvider;

    return SelectedFiltersListviewComponent(
      filterProvider: filterProvider,
      onResetFilter: () {
        FilterController(filterProvider: filterProvider).resetFilterData();
        refreshMyLearningData(
          isMyLearning: true,
          isArchived: true,
        );
      },
      onFilterChipTap: ({required String contentFilterByTypes}) {
        MyPrint.printOnConsole("onFilterChipTap called with contentFilterByTypes:$contentFilterByTypes");

        if (contentFilterByTypes.isEmpty) return;

        navigateToFilterScreen(
          contentFilterByTypes: contentFilterByTypes,
          searchString: searchString,
          searchController: searchController,
        );
      },
    );
  }
}
