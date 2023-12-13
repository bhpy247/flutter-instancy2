import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/event/event_controller.dart';
import 'package:flutter_instancy_2/backend/event/event_provider.dart';
import 'package:flutter_instancy_2/backend/ui_actions/event_catalog/event_catalog_ui_actions_controller.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/classroom_events/data_model/EventRecordingDetailsModel.dart';
import 'package:flutter_instancy_2/models/classroom_events/data_model/tab_data_model.dart';
import 'package:flutter_instancy_2/utils/date_representation.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../api/api_controller.dart';
import '../../../backend/Catalog/catalog_controller.dart';
import '../../../backend/app/app_provider.dart';
import '../../../backend/filter/filter_controller.dart';
import '../../../backend/filter/filter_provider.dart';
import '../../../backend/navigation/navigation.dart';
import '../../../backend/share/share_provider.dart';
import '../../../backend/ui_actions/event_catalog/event_catalog_ui_action_callback_model.dart';
import '../../../backend/ui_actions/primary_secondary_actions/primary_secondary_actions_constants.dart';
import '../../../configs/app_configurations.dart';
import '../../../models/app_configuration_models/data_models/local_str.dart';
import '../../../models/app_configuration_models/data_models/native_menu_component_model.dart';
import '../../../models/catalog/request_model/add_content_to_my_learning_request_model.dart';
import '../../../models/catalog/response_model/removeFromWishlistModel.dart';
import '../../../models/common/pagination/pagination_model.dart';
import '../../../models/course/data_model/CourseDTOModel.dart';
import '../../../models/event_track/request_model/view_recording_request_model.dart';
import '../../../models/waitlist/response_model/add_to_waitList_response_model.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_toast.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';
import '../../common/components/common_loader.dart';
import '../../common/components/common_text_form_field.dart';
import '../../common/components/instancy_ui_actions/instancy_ui_actions.dart';
import '../../common/components/modal_progress_hud.dart';
import '../../filter/components/selected_filters_listview_component.dart';
import '../components/event_list_card.dart';

class EventCatalogListScreen extends StatefulWidget {
  final EventCatalogListScreenNavigationArguments arguments;

  const EventCatalogListScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<EventCatalogListScreen> createState() => _EventCatalogListScreenState();
}

class _EventCatalogListScreenState extends State<EventCatalogListScreen> with MySafeState {
  late AppProvider appProvider;

  late String? tabId;
  late TabDataModel? tabDataModel;

  late EventProvider eventProvider;
  late EventController eventController;

  late int componentId;
  late int componentInsId;

  bool isLoading = false;

  late TextEditingController searchController;
  bool enableSearching = true;

  final ItemScrollController catalogContentScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController = ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener = ScrollOffsetListener.create();

  Future<void> getEventCatalogContentsList({bool isRefresh = true, bool isGetFromCache = true, bool isNotify = true}) async {
    await Future.wait([
      eventController.getEventCatalogContentsListFromApi(
        isRefresh: isRefresh,
        isGetFromCache: isGetFromCache,
        isNotify: isNotify,
        tabId: tabId ?? "",
        componentId: componentId,
        componentInstanceId: componentInsId,
      ),
      /*if (isRefresh)
        eventController.getWishListContentsListFromApi(
          isRefresh: true,
          componentId: componentId,
          componentInstanceId: componentInsId,
          isGetFromCache: false,
          isNotify: true,
        ),*/
    ]);
    // _events = _MeetingDataSource(_getAppointments());
  }

  Future<void> navigateToFilterScreen({String? contentFilterByTypes}) async {
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
        componentId: componentId,
        filterProvider: eventProvider.filterProvider,
        componentConfigurationsModel: componentModel.componentConfigurationsModel,
        contentFilterByTypes: contentFilterByTypes,
      ),
    );
    MyPrint.printOnConsole("Filter Value:$value");

    if (value == true) {
      getEventCatalogContentsList(
        isRefresh: true,
        isGetFromCache: false,
        isNotify: true,
      );
    }
  }

  Future<void> onCalenderDateChanged({required DateTime? newDate}) async {
    MyPrint.printOnConsole("onCalenderDateChanged called with newDate:$newDate");

    if (newDate == null) return;

    DateTime? existingDate = eventProvider.calenderDate.get();
    MyPrint.printOnConsole("existingDate:$existingDate");

    if (existingDate == null || (newDate.month != existingDate.month || newDate.year != existingDate.year)) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        eventProvider.calenderDate.set(value: newDate, isNotify: false);
        getEventCatalogContentsList(
          isRefresh: true,
          isGetFromCache: false,
          isNotify: true,
        );
      });
    }
  }

  Future<void> onScheduleBackTapped() async {
    MyPrint.printOnConsole("onScheduleBackTapped called");

    DateTime existingDate = eventProvider.scheduleDate.get() ?? DateTime.now();
    MyPrint.printOnConsole("existingDate:$existingDate");

    DateTime newDate = Jiffy.parseFromDateTime(existingDate).subtract(months: 1).dateTime;
    MyPrint.printOnConsole("newDate:$newDate");

    eventProvider.scheduleDate.set(value: newDate, isNotify: false);
    getEventCatalogContentsList(
      isRefresh: true,
      isGetFromCache: false,
      isNotify: true,
    );
  }

  Future<void> onScheduleNextTapped() async {
    MyPrint.printOnConsole("onScheduleNextTapped called");

    DateTime existingDate = eventProvider.scheduleDate.get() ?? DateTime.now();
    MyPrint.printOnConsole("existingDate:$existingDate");

    DateTime newDate = Jiffy.parseFromDateTime(existingDate).add(months: 1).dateTime;
    MyPrint.printOnConsole("newDate:$newDate");

    eventProvider.scheduleDate.set(value: newDate, isNotify: false);
    getEventCatalogContentsList(
      isRefresh: true,
      isGetFromCache: false,
      isNotify: true,
    );
  }

  Future<void> onScheduleDateTapped() async {
    MyPrint.printOnConsole("onScheduleDateTapped called");

    DateTime existingDate = eventProvider.scheduleDate.get() ?? DateTime.now();
    MyPrint.printOnConsole("existingDate:$existingDate");

    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: existingDate,
      firstDate: DateTime(existingDate.year - 100),
      lastDate: DateTime(existingDate.year + 100),
    );

    if (newDate == null) {
      return;
    }

    eventProvider.scheduleDate.set(value: newDate, isNotify: false);
    getEventCatalogContentsList(
      isRefresh: true,
      isGetFromCache: false,
      isNotify: true,
    );
  }

  EventCatalogUIActionCallbackModel getEventCatalogUIActionCallbackModel({
    required CourseDTOModel model,
    InstancyContentActionsEnum? primaryAction,
    bool isSecondaryAction = true,
    required int index,
  }) {
    return EventCatalogUIActionCallbackModel(
      onBuyTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        isLoading = true;
        mySetState();

        bool isBuySuccess = await CatalogController(provider: null).buyCourse(
          context: context,
          model: model,
          ComponentID: componentId,
          ComponentInsID: componentInsId,
          isWaitForPostPurchaseProcesses: true,
        );

        isLoading = false;
        mySetState();

        if (isBuySuccess) {
          await getEventCatalogContentsList(
            isRefresh: true,
            isGetFromCache: false,
            isNotify: true,
          );
        }
      },
      onEnrollTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        addContentToMyLearning(model: model, index: index);
      },
      onDetailsTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        await onDetailsTap(model: model);
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

          getEventCatalogContentsList(
            isRefresh: true,
            isGetFromCache: false,
            isNotify: true,
          );
        }
      },
      onRescheduleTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        onDetailsTap(model: model, isRescheduleEvent: true);
      },
      onReEnrollmentHistoryTap: () async {
        if (isSecondaryAction) Navigator.pop(context);
        await NavigationController.navigateToReEnrollmentHistoryScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: ReEnrollmentHistoryScreenNavigationArguments(model: model),
        );
      },
      onAddToWishlist: () async {
        if (isSecondaryAction) Navigator.pop(context);

        isLoading = true;
        mySetState();
        bool isSuccess = await CatalogController(provider: null).addContentToWishlist(
          contentId: model.ContentID,
          componentId: componentId,
          componentInstanceId: componentInsId,
        );
        MyPrint.printOnConsole("isSuccess: $isSuccess");
        isLoading = false;
        mySetState();

        if (isSuccess) {
          model.isWishListContent = 1;
          mySetState();
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
        MyPrint.printOnConsole("Component instance id: $componentInsId");
        RemoveFromWishlistResponseModel removeFromWishlistResponseModel = await CatalogController(provider: null).removeContentFromWishlist(
          contentId: model.ContentID,
          componentId: componentId,
          componentInstanceId: componentInsId,
        );
        isLoading = false;
        mySetState();
        MyPrint.printOnConsole("valueeee: ${removeFromWishlistResponseModel.isSuccess}");
        if (removeFromWishlistResponseModel.isSuccess) {
          model.isWishListContent = 0;
          mySetState();
        }
        if (pageMounted && context.mounted) {
          if (removeFromWishlistResponseModel.isSuccess) {
            MyToast.showSuccess(context: context, msg: appProvider.localStr.catalogAlertsubtitleItemremovedtowishlistsuccesfully);
          } else {
            MyToast.showError(context: context, msg: 'Failed');
          }
        }
      },
      onAddToWaitListTap: () async {
        if (isSecondaryAction) Navigator.pop(context);
        MyPrint.printOnConsole("Content id: ${model.ContentID}");
        isLoading = true;
        mySetState();
        AddToWaitListResponseModel addToWaitListResponseModel = await CatalogController(provider: null).addContentToWaitList(
          contentId: model.ContentID,
          componentId: componentId,
          componentInstanceId: componentInsId,
        );
        MyPrint.printOnConsole("isSuccess: ${addToWaitListResponseModel.isSuccess}");
        isLoading = false;
        mySetState();

        if (addToWaitListResponseModel.isSuccess) {
          getEventCatalogContentsList(
            isRefresh: true,
            isGetFromCache: false,
            isNotify: true,
          );
        }

        if (pageMounted && context.mounted) {
          if (addToWaitListResponseModel.isSuccess) {
            MyToast.showSuccess(context: context, msg: addToWaitListResponseModel.message);
          } else {
            MyToast.showError(context: context, msg: 'Failed');
          }
        }
      },
      onAddToCalenderTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        bool isSuccess = await EventController(eventProvider: null).addEventToCalender(
          context: context,
          EventStartDateTime: model.EventStartDateTime,
          EventEndDateTime: model.EventEndDateTime,
          eventDateTimeFormat: appProvider.appSystemConfigurationModel.eventDateTimeFormat,
          Title: model.ContentName,
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
      onViewResources: () async {
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
            componentInstanceId: componentInsId,
            isContentEnrolled: true,
          ),
        );

        if (value == true) {
          getEventCatalogContentsList(
            isRefresh: true,
            isGetFromCache: false,
            isNotify: true,
          );
        }
      },
      onViewQRCodeTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        //TODO: Find parameter to show QR Code
        /*NavigationController.navigateToQRCodeImageScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: QRCodeImageScreenNavigationArguments(qrCodePath: model.actionviewqrcode),
          // arguments: QRCodeImageScreenNavigationArguments(qrCodePath: model.ac),
        );*/
      },
      onJoinTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        EventController(eventProvider: null).joinVirtualEvent(context: context, joinUrl: model.JoinURL);
      },
      onViewRecordingTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        MyPrint.printOnConsole("onViewRecordingTap called for ObjectTypeId:${model.ContentTypeId} and contentId:${model.ContentID}");

        EventRecordingDetailsModel? recordingDetails = model.RecordingDetails;

        if (recordingDetails == null) {
          MyPrint.printOnConsole("recordingDetails are null");
          return;
        }
        ViewRecordingRequestModel viewRecordingRequestModel = ViewRecordingRequestModel(
          contentName: recordingDetails.ContentName,
          contentID: recordingDetails.ContentID,
          contentTypeId: ParsingHelper.parseIntMethod(recordingDetails.ContentID),
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
            isRelatedContent: false,
            parentContentId: model.ContentID,
            componentId: componentId,
            scoId: model.ScoID,
            componentInstanceId: componentInsId,
            isContentEnrolled: true,
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
            contentName: model.ContentName,
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
            contentName: model.ContentName,
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
            contentName: model.ContentName,
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

  Future<void> showMoreAction({
    required CourseDTOModel model,
    InstancyContentActionsEnum? primaryAction,
    required int index,
  }) async {
    LocalStr localStr = appProvider.localStr;

    EventCatalogUIActionsController catalogUIActionsController = EventCatalogUIActionsController(appProvider: appProvider);
    // CatalogUIActionsController catalogUIActionsController = CatalogUIActionsController(appProvider: appProvider);
    // MyPrint.printOnConsole("isWIshlishContent: ${model.isWishListContent}");
    List<InstancyUIActionModel> options = catalogUIActionsController
        .getEventCatalogScreenSecondaryActions(
      courseDTOModel: model,
          localStr: localStr,
          eventCatalogUIActionCallbackModel: getEventCatalogUIActionCallbackModel(
            model: model,
            primaryAction: primaryAction,
            index: index,
          ),
          isWishlistMode: false,
        )
        .toList();

    if (options.isEmpty) {
      return;
    }

    InstancyUIActions().showAction(
      context: context,
      actions: options,
    );
  }

  Future<void> onDetailsTap({required CourseDTOModel model, bool isRescheduleEvent = false}) async {
    String parentContentId = model.InstanceParentContentID;
    MyPrint.printOnConsole("parentContentId:'$parentContentId'");

    if (isRescheduleEvent && parentContentId.isEmpty) {
      MyPrint.printOnConsole("Returning from onRescheduleTap because parentContentId is empty");
      return;
    }

    dynamic value = await NavigationController.navigateToCourseDetailScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      arguments: CourseDetailScreenNavigationArguments(
        contentId: isRescheduleEvent ? parentContentId : model.ContentID,
        componentId: isRescheduleEvent ? InstancyComponents.Catalog : widget.arguments.componentId,
        componentInstanceId: widget.arguments.componentInsId,
        userId: ApiController().apiDataProvider.getCurrentUserId(),
        screenType: InstancyContentScreenType.Catalog,
        isRescheduleEvent: isRescheduleEvent,
      ),
    );
    MyPrint.printOnConsole("CourseDetailScreen return value:$value");

    getEventCatalogContentsList(
      isRefresh: true,
      isGetFromCache: false,
      isNotify: true,
    );
  }

  Future<void> addContentToMyLearning({required CourseDTOModel model, required int index, bool isShowToast = true}) async {
    /*if (model.AddLink == ContentAddLinkOperations.redirecttodetails) {
      onDetailsTap(model: model);
      return;
    }*/

    isLoading = true;
    mySetState();

    bool isSuccess = await CatalogController(provider: null).addContentToMyLearning(
      requestModel: AddContentToMyLearningRequestModel(
        SelectedContent: model.ContentID,
        multiInstanceParentId: model.InstanceParentContentID,
        ERitems: "",
        HideAdd: "",
        AdditionalParams: "",
        TargetDate: "",
        MultiInstanceEventEnroll: "",
        ComponentID: componentId,
        ComponentInsID: componentInsId,
        scoId: model.ScoID,
        objecttypeId: model.ContentTypeId,
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
      // hasPrerequisites: model.hasPrerequisiteContents(),
      isShowToast: isShowToast,
      isWaitForOtherProcesses: true,
    );
    MyPrint.printOnConsole("isSuccess $isSuccess");

    isLoading = false;
    mySetState();

    if (isSuccess) {
      await getEventCatalogContentsList(
        isRefresh: true,
        isGetFromCache: false,
        isNotify: true,
      );
    }
  }

  @override
  void initState() {
    super.initState();

    appProvider = context.read<AppProvider>();
    eventProvider = widget.arguments.eventProvider ?? EventProvider();
    eventController = EventController(eventProvider: eventProvider);

    componentId = widget.arguments.componentId;
    componentInsId = widget.arguments.componentInsId;

    tabId = widget.arguments.tabId;
    tabDataModel = widget.arguments.tabDataModel;

    searchController = TextEditingController(text: "");
    enableSearching = widget.arguments.enableSearching;

    NativeMenuComponentModel? componentModel = appProvider.getMenuComponentModelFromComponentId(componentId: componentId);
    if (componentModel != null) {
      eventController.initializeCatalogConfigurationsFromComponentConfigurationsModel(
        componentConfigurationsModel: componentModel.componentConfigurationsModel,
      );
    }

    if (tabId == EventCatalogTabTypes.calendarView) {
      if (eventProvider.calenderDate.get() == null) {
        eventProvider.calenderDate.set(value: DateTime.now(), isNotify: false);
      }
    } else if (tabId == EventCatalogTabTypes.calendarSchedule) {
      if (eventProvider.scheduleDate.get() == null) {
        eventProvider.scheduleDate.set(value: DateTime.now(), isNotify: false);
      }
    } else {
      eventProvider.calenderDate.set(value: null, isNotify: false);
      eventProvider.scheduleDate.set(value: null, isNotify: false);
    }

    if (eventProvider.eventsListLength == 0 && eventProvider.eventsPaginationModel.get().hasMore) {
      getEventCatalogContentsList(
        isRefresh: true,
        isGetFromCache: false,
        isNotify: true,
      );
    }

    searchController.text = eventProvider.searchString.get();
    // getEventCatalogContentsList(
    //   isRefresh: true,
    //   isGetFromCache: false,
    //   isNotify: true,
    // );
    eventController.updateEventListAccordingToCalendarDate();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<EventProvider>.value(value: eventProvider),
        ],
        child: Consumer<EventProvider>(
          builder: (BuildContext context, EventProvider eventProvider, Widget? child) {
            return ModalProgressHUD(
              inAsyncCall: isLoading,
              child: Scaffold(
                appBar: widget.arguments.isShowAppBar ? getAppBar() : null,
                body: getMainWidget(),
              ),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget getAppBar() {
    return AppConfigurations().commonAppBar(
      title: "Classroom Events",
      actions: [
        /*Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              InkWell(
                onTap: () async {
                  await NavigationController.navigateToWishlist(
                    navigationOperationParameters: NavigationOperationParameters(
                      context: context,
                      navigationType: NavigationType.pushNamed,
                    ),
                    arguments: WishListScreenNavigationArguments(
                      componentId: widget.arguments.componentId,
                      componentInstanceId: widget.arguments.componentInsId,
                      // eventProvider: eventProvider,
                    ),
                  );
                  getEventCatalogContentsList(
                    isRefresh: true,
                    isGetFromCache: false,
                    isNotify: true,
                  );
                },
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: const Icon(FontAwesomeIcons.heart),
                    ),
                    if (eventProvider.maxWishlistContentsCount.get() > 0)
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: themeData.primaryColor,
                          ),
                          child: Text(
                            "${eventProvider.maxWishlistContentsCount.get()}",
                            style: themeData.textTheme.labelSmall?.copyWith(
                              color: themeData.colorScheme.onPrimary,
                              fontSize: 8,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),*/
      ],
    );
  }

  Widget getMainWidget() {
    Widget? scheduleWidget = getScheduleDateWidget();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (scheduleWidget != null) ...[
          scheduleWidget,
          const SizedBox(height: 10),
        ],
        if (tabId != EventCatalogTabTypes.calendarView) getSearchTextFormField(),
        const SizedBox(height: 10),
        getSelectedFiltersListviewWidget(),
        Expanded(
          child: getCatalogContentsListView(),
        ),
      ],
    );
  }

  Widget getSearchTextFormField() {
    onSubmitted(String text) {
      bool isSearch = false;
      if (text.isEmpty) {
        if (eventProvider.searchString.get().isNotEmpty) {
          isSearch = true;
        }
      } else {
        if (text != eventProvider.searchString.get()) {
          isSearch = true;
        }
      }
      if (isSearch) {
        eventProvider.searchString.set(value: text);
        getEventCatalogContentsList(
          isRefresh: true,
          isGetFromCache: false,
          isNotify: true,
        );
      }
    }

    Widget? filterSuffixIcon;

    if (eventProvider.filterEnabled.get()) {
      int selectedFiltersCount = eventProvider.filterProvider.selectedFiltersCount();

      filterSuffixIcon = Stack(
        children: [
          Container(
            margin: selectedFiltersCount > 0 ? const EdgeInsets.only(top: 5, right: 5) : null,
            child: InkWell(
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                navigateToFilterScreen();
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

    if (eventProvider.sortEnabled.get()) {
      bool isSortingSelected = false;
      // MyPrint.printOnConsole("selected sort : ${eventProvider.filterProvider.selectedSort.get()}");
      // if(eventProvider.filterProvider.selectedSort.get().isNotEmpty){
      //   isSortingSelected = true;
      // }

      sortSuffixIcon = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Stack(
          children: [
            InkWell(
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());

                dynamic value = await NavigationController.navigateToSortingScreen(
                  navigationOperationParameters: NavigationOperationParameters(
                    context: context,
                    navigationType: NavigationType.pushNamed,
                  ),
                  arguments: SortingScreenNavigationArguments(
                    componentId: componentId,
                    filterProvider: eventProvider.filterProvider,
                  ),
                );
                MyPrint.printOnConsole("Sort Value:$value");

                if (value == true) {
                  getEventCatalogContentsList(
                    isRefresh: true,
                    isGetFromCache: false,
                    isNotify: true,
                  );
                }
              },
              child: const Icon(Icons.sort),
            ),
            Positioned(
              right: 0,
              child: Visibility(
                visible: isSortingSelected,
                child: Container(
                  height: 7,
                  width: 7,
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget? clearSearchSuffixIcon;
    if (searchController.text.isNotEmpty || (eventProvider.searchString.get().isNotEmpty && eventProvider.searchString.get() == searchController.text)) {
      clearSearchSuffixIcon = IconButton(
        onPressed: () async {
          searchController.clear();
          onSubmitted("");
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        height: 40,
        child: CommonTextFormField(
          borderRadius: 50,
          boxConstraints: const BoxConstraints(minWidth: 55),
          prefixWidget: const Icon(Icons.search),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          hintText: "Search",
          isOutlineInputBorder: true,
          controller: searchController,
          onSubmitted: onSubmitted,
          onChanged: (String text) {
            mySetState();
          },
          suffixWidget: actions.isNotEmpty
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions,
                )
              : null,
        ),
      ),
    );
  }

  Widget getSelectedFiltersListviewWidget() {
    FilterProvider filterProvider = eventProvider.filterProvider;

    return SelectedFiltersListviewComponent(
      filterProvider: filterProvider,
      onResetFilter: () {
        FilterController(filterProvider: filterProvider).resetFilterData();
        getEventCatalogContentsList(
          isRefresh: true,
          isGetFromCache: false,
          isNotify: true,
        );
      },
      onFilterChipTap: ({required String contentFilterByTypes}) {
        FocusScope.of(context).requestFocus(FocusNode());
        if (contentFilterByTypes.isEmpty) return;

        navigateToFilterScreen(contentFilterByTypes: contentFilterByTypes);
      },
    );
  }

  Widget getCatalogContentsListView() {
    return getContentsListViewWidget(
      scrollController: catalogContentScrollController,
      contentsLength: tabId == EventCatalogTabTypes.calendarView ? eventProvider.selectedCalendarDateEventList.getList().length : eventProvider.eventsListLength,
      paginationModel: eventProvider.eventsPaginationModel.get(),
      onRefresh: () async {
        getEventCatalogContentsList(
          isRefresh: true,
          isGetFromCache: false,
          isNotify: true,
        );
      },
      onPagination: () async {
        getEventCatalogContentsList(
          isRefresh: false,
          isGetFromCache: false,
          isNotify: false,
        );
      },
    );
  }

  Widget getContentsListViewWidget({
    required PaginationModel paginationModel,
    required int contentsLength,
    required ItemScrollController scrollController,
    required Future<void> Function() onRefresh,
    required Future<void> Function() onPagination,
  }) {
    Widget? calendarWidget = getCalenderWidget();

    if (paginationModel.isFirstTimeLoading) {
      if (calendarWidget != null) {
        return ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 00),
          children: [
            calendarWidget,
            const SizedBox(height: 30),
            const CommonLoader(
              isCenter: true,
            ),
          ],
        );
      } else {
        return const CommonLoader(
          isCenter: true,
        );
      }
    } else if (!paginationModel.isLoading && contentsLength == 0) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                if (calendarWidget != null) calendarWidget,
                SizedBox(height: calendarWidget != null ? 30 : constraints.maxHeight / 5),
                AppConfigurations.commonNoDataView(),
              ],
            ),
          );
        },
      );
    }

    List<CourseDTOModel> list = (tabId == EventCatalogTabTypes.calendarView) ? eventProvider.selectedCalendarDateEventList.getList() : eventProvider.eventsList.getList(isNewInstance: false);
    MyPrint.printOnConsole("List.length : ${list.length}");
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ScrollablePositionedList.builder(
        itemScrollController: scrollController,
        scrollOffsetController: scrollOffsetController,
        itemPositionsListener: itemPositionsListener,
        scrollOffsetListener: scrollOffsetListener,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 0),
        itemCount: 1 + list.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return calendarWidget ?? const SizedBox();
          }
          index--;

          if ((index == 0 && list.isEmpty) || index == list.length) {
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

          if (index > (contentsLength - paginationModel.refreshLimit) && paginationModel.hasMore && !paginationModel.isLoading) {
            onPagination();
          }
          MyPrint.printOnConsole("Indexxxx: $index");
          CourseDTOModel model = list[index];

          EventCatalogUIActionsController eventCatalogUIActionsController = EventCatalogUIActionsController(
            appProvider: appProvider,
          );
          LocalStr localStr = appProvider.localStr;

          List<InstancyUIActionModel> options = eventCatalogUIActionsController
              .getEventCatalogScreenPrimaryActions(
                courseDTOModel: model,
                localStr: localStr,
                catalogUIActionCallbackModel: getEventCatalogUIActionCallbackModel(
                  model: model,
                  isSecondaryAction: false,
                  index: index,
                ),
                isWishlistMode: false,
              )
              .toList();

          InstancyUIActionModel? primaryAction = options.firstElement;

          InstancyContentActionsEnum? primaryActionEnum = primaryAction?.actionsEnum;
          // MyPrint.printOnConsole("parameterModel.EventType: ${model.EventType}  title: ${model.Title}");

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            child: EventListCard(
              model: model,
              primaryAction: primaryAction,
              onPrimaryActionTap: () async {
                MyPrint.printOnConsole("primaryAction:$primaryActionEnum");

                if (primaryAction?.onTap != null) {
                  primaryAction!.onTap!();
                }
              },
              onMoreButtonTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                showMoreAction(model: model, primaryAction: primaryActionEnum, index: index);
              },
            ),
          );
        },
      ),
    );
  }

  Widget? getCalenderWidget() {
    if (tabId != EventCatalogTabTypes.calendarView) {
      return null;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: SfCalendar(
        initialDisplayDate: eventProvider.calenderDate.get(),
        cellEndPadding: 1,
        view: CalendarView.month,

        minDate: DateTime.now(),
        onSelectionChanged: (CalendarSelectionDetails ee) {
          MyPrint.printOnConsole("onSelectionChanged : ${ee.date}");
          // onCalenderDateChanged(newDate: ee.date);
          eventProvider.selectedCalenderDate.set(value: ee.date ?? DateTime.now());
          eventController.updateEventListAccordingToCalendarDate();
          mySetState();
        },
        // onTap: (calendarDetails){
        //   onCalenderDateChanged(newDate: calendarDetails.date);
        //   mySetState();
        // },
        showNavigationArrow: true,
        headerStyle: const CalendarHeaderStyle(textAlign: TextAlign.center, textStyle: TextStyle(fontWeight: FontWeight.bold)),
        showDatePickerButton: true,
        // dataSource: ,
        // monthCellBuilder: (BuildContext context, MonthCellDetails details) {
        //   final bool hasEvent = _appointments.any((appointment) =>
        //   appointment.startTime.day == details.date.day &&
        //       appointment.startTime.month == details.date.month &&
        //       appointment.startTime.year == details.date.year);
        //
        //   if (hasEvent) {
        //     return Container(
        //       height: 5,
        //       width: 5,
        //       decoration: BoxDecoration(
        //         // borderRadius: BorderRadius.circular(5),
        //         color: Colors.red,
        //         shape: BoxShape.circle
        //
        //       ),
        //       child: Text("${details.date.day}",textAlign: TextAlign.center),
        //       // child: ,
        //     );
        //   } else {
        //     return Text("${details.date.day}",textAlign: TextAlign.center);
        //   }
        // },
        cellBorderColor: Colors.transparent,

        monthCellBuilder: (BuildContext context, MonthCellDetails monthCellDetails) {
          int count = eventProvider.calenderDatesHavingEventMap.getMap()[DateFormat("yyyy-MM-dd").format(monthCellDetails.date)] ?? 0;
          bool isCurrentDate = DateFormat("yyyy-MM-dd").format(monthCellDetails.date) == DateFormat("yyyy-MM-dd").format(DateTime.now());
          bool pastEvent = monthCellDetails.date.isBefore(DateTime.now());

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: EdgeInsets.all(isCurrentDate ? 5 : 0),
                  decoration: BoxDecoration(color: isCurrentDate ? themeData.primaryColor : Colors.white, shape: BoxShape.circle),
                  child: Text(DatePresentation.getFormattedDate(dateFormat: "d", dateTime: monthCellDetails.date) ?? "",
                      style: TextStyle(
                          color: isCurrentDate
                              ? Colors.white
                              : pastEvent
                                  ? Colors.grey
                                  : Colors.black))),
              const SizedBox(
                height: 3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  count,
                  (index) => const Padding(
                    padding: EdgeInsets.only(left: 2.0),
                    child: Icon(Icons.circle, size: 5, color: Colors.green),
                  ),
                ),
              )
            ],
          );
        },
        monthViewSettings: MonthViewSettings(
          monthCellStyle: MonthCellStyle(
            textStyle: themeData.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        onViewChanged: (ViewChangedDetails ee) {
          MyPrint.printOnConsole("onViewChanged called:${ee.visibleDates}");

          onCalenderDateChanged(newDate: ee.visibleDates.elementAtOrNull(10));
        },
      ),
    );
  }

  //     child: SfCalendar(
  //       view: CalendarView.month,
  //       controller: _calendarController,
  //       showDatePickerButton: true,
  //       showNavigationArrow: true,
  //       // onViewChanged: onViewChanged,
  //       dataSource: _events,
  //       // monthViewSettings: MonthViewSettings(
  //       //     showAgenda: true, numberOfWeeksInView: 6),
  //       timeSlotViewSettings: const TimeSlotViewSettings(minimumAppointmentDuration: Duration(minutes: 60)),
  //     ),
  //   );
  // }

  Widget? getScheduleDateWidget() {
    if (tabId != EventCatalogTabTypes.calendarSchedule) {
      return null;
    }

    DateTime scheduleDate = eventProvider.scheduleDate.get() ?? DateTime.now();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: () {
                onScheduleBackTapped();
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: themeData.colorScheme.onBackground.withAlpha(50)),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_sharp,
                  size: 18,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              onScheduleDateTapped();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DatePresentation.ddMMMMyyyyTimeStamp(Timestamp.fromDate(scheduleDate)),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Icon(
                      Icons.arrow_drop_down_sharp,
                    ),
                  ],
                ),
                SizedBox(
                  width: 150,
                  child: Divider(
                    thickness: 1,
                    height: 0,
                    color: themeData.textTheme.labelMedium?.color,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: InkWell(
              onTap: () {
                onScheduleNextTapped();
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: themeData.colorScheme.onBackground.withAlpha(50)),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_sharp,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
// CalendarDataSource _getCalendarDataSource(List<Appointment> events) {
//   final List<Meeting> appointments = events.map((event) {
//     final DateTime date = event.startTime;
//     final Meeting meeting = Meeting(
//       eventName: event.subject,
//       from: date,
//       to: date.add(Duration(hours: 2)), // Adjust the duration as needed
//       background: Colors.blue, // Customize the dot color
//     );
//     return meeting;
//   }).toList();
//
//   return CalendarDataSource(appointments: appointments);
// }
}
