import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/Catalog/catalog_repository.dart';
import 'package:flutter_instancy_2/backend/app/app_controller.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/app/app_repository.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation_controller.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/app/data_model/dynamic_tabs_dto_model.dart';
import 'package:flutter_instancy_2/models/app/request_model/get_dynamic_tabs_request_model.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/local_str.dart';
import 'package:flutter_instancy_2/models/common/data_response_model.dart';
import 'package:flutter_instancy_2/models/event/response_model/event_session_data_response_model.dart';
import 'package:flutter_instancy_2/models/event/response_model/re_entrollment_history_response_model.dart';
import 'package:flutter_instancy_2/models/event_track/request_model/view_recording_request_model.dart';
import 'package:flutter_instancy_2/utils/date_representation.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/views/event/components/event_cancel_enrolment_dialog.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/api_controller.dart';
import '../../api/api_url_configuration_provider.dart';
import '../../configs/app_configurations.dart';
import '../../models/app_configuration_models/data_models/component_configurations_model.dart';
import '../../models/catalog/request_model/catalog_request_model.dart';
import '../../models/catalog/response_model/catalog_dto_response_model.dart';
import '../../models/common/pagination/pagination_model.dart';
import '../../models/course/data_model/CourseDTOModel.dart';
import '../../models/filter/data_model/enabled_content_filter_by_type_model.dart';
import '../../models/filter/data_model/filter_duration_value_model.dart';
import '../../utils/my_print.dart';
import '../../utils/my_toast.dart';
import '../../utils/parsing_helper.dart';
import '../configurations/app_configuration_operations.dart';
import '../filter/filter_provider.dart';
import '../navigation/navigation_arguments.dart';
import '../navigation/navigation_operation_parameters.dart';
import '../navigation/navigation_type.dart';
import 'event_provider.dart';
import 'event_repository.dart';

class EventController {
  late EventProvider _eventProvider;
  late EventRepository _eventRepository;

  EventController({required EventProvider? eventProvider, EventRepository? repository, ApiController? apiController}) {
    _eventProvider = eventProvider ?? EventProvider();
    _eventRepository = repository ?? EventRepository(apiController: apiController ?? ApiController());
  }

  EventProvider get eventProvider => _eventProvider;

  EventRepository get eventRepository => _eventRepository;

  void initializeCatalogConfigurationsFromComponentConfigurationsModel({required ComponentConfigurationsModel componentConfigurationsModel}) {
    //Initializations
    eventProvider.pageSize.set(value: componentConfigurationsModel.itemsPerPage, isNotify: false);
    initializeFilterData(model: componentConfigurationsModel);
  }

  void initializeFilterData({required ComponentConfigurationsModel model}) {
    EventProvider provider = eventProvider;

    provider.filterProvider.defaultSort.set(value: model.ddlSortList, isNotify: false);
    provider.filterProvider.selectedSort.set(value: model.ddlSortList, isNotify: false);
    provider.filterEnabled.set(value: AppConfigurations.getFilterEnabledFromShowIndexes(showIndexes: model.showIndexes), isNotify: false);
    provider.sortEnabled.set(value: AppConfigurations.getSortEnabledFromContentFilterBy(contentFilterBy: model.contentFilterBy), isNotify: false);
  }

  Future<List<CourseDTOModel>> getEventSessionsList({
    required String eventId,
    bool isNotify = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("EventController().getEventSessionsList() called with eventId:'$eventId'", tag: tag);

    EventProvider provider = eventProvider;

    if (eventId.isEmpty) {
      MyPrint.printOnConsole("Returning from EventController().getEventSessionsList() eventId is empty", tag: tag);
      provider.isLoadingEventSessionData.set(value: false, isNotify: isNotify);
      provider.eventSessionData.setList(list: [], isNotify: true);
      return [];
    }

    List<CourseDTOModel> courseList = <CourseDTOModel>[];

    provider.isLoadingEventSessionData.set(value: true, isNotify: isNotify);

    DataResponseModel<EventSessionDataResponseModel> response = await eventRepository.getEventSessionData(eventId: eventId);
    MyPrint.logOnConsole("getEventSessionData response:$response", tag: tag);

    provider.isLoadingEventSessionData.set(value: false, isNotify: true);

    if (response.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from EventController().getEventSessionsList() because getEventSessionData had some error", tag: tag);
      return courseList;
    }

    if (response.data != null) {
      courseList = response.data!.CourseList;
    }
    MyPrint.logOnConsole("final EventSessionData courseList:$courseList", tag: tag);

    provider.eventSessionData.setList(list: courseList, isNotify: true);

    return courseList;
  }

  Future<List<DynamicTabsDTOModel>> getTabs({required GetDynamicTabsRequestModel requestModel, bool isNotify = true}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("EventController().getTabs() called", tag: tag);

    EventProvider provider = eventProvider;

    List<DynamicTabsDTOModel> tabsList = <DynamicTabsDTOModel>[];

    provider.isLoadingTabsList.set(value: true, isNotify: isNotify);

    DataResponseModel<List<DynamicTabsDTOModel>> response = await AppRepository(apiController: eventRepository.apiController).getDynamicTabsList(requestModel: requestModel);
    MyPrint.logOnConsole("getTabs response:$response", tag: tag);

    provider.isLoadingTabsList.set(value: false, isNotify: true);

    if (response.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from EventController().getTabs() because getTabsList had some error", tag: tag);
      return tabsList;
    }

    if (response.data != null) {
      tabsList = response.data!;
    }
    MyPrint.logOnConsole("final tabsList:$tabsList", tag: tag);

    List<String> tabIdsList = <String>[];
    for (DynamicTabsDTOModel tabDataModel in tabsList) {
      tabIdsList.add(tabDataModel.TabID);
      provider.setTabModel(tabId: tabDataModel.TabID, tabDataModel: tabDataModel, isNotify: false);
    }
    provider.tabsList.setList(list: tabIdsList, isClear: true, isNotify: true);

    return tabsList;
  }

  // region Events Listing
  Future<List<CourseDTOModel>> getEventCatalogContentsListFromApi({
    bool isRefresh = true,
    bool isGetFromCache = false,
    bool isNotify = true,
    int? siteId,
    required String tabId,
    required int componentId,
    required int componentInstanceId,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
        "EventController().getEventCatalogContentsListFromApi() called with isRefresh:$isRefresh, isGetFromCache:$isGetFromCache, "
        "isNotify:$isNotify, componentId:$componentId, componentInstanceId:$componentInstanceId",
        tag: tag);

    EventProvider provider = eventProvider;
    PaginationModel paginationModel = provider.eventsPaginationModel.get();

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = eventRepository.apiController.apiDataProvider;

    //region If Not refresh and Data available, return Cached Data
    if (!isRefresh && isGetFromCache && provider.eventsListLength > 0) {
      MyPrint.printOnConsole("Returning Cached Data", tag: tag);
      return provider.eventsList.getList(isNewInstance: true);
    }
    //endregion

    provider.currentSearchId.set(value: tag, isNotify: false);

    //region If refresh, then reset provider data
    if (isRefresh) {
      MyPrint.printOnConsole("Refresh", tag: tag);
      PaginationModel.updatePaginationData(
        paginationModel: paginationModel,
        hasMore: true,
        pageIndex: 1,
        isFirstTimeLoading: true,
        isLoading: false,
        notifier: provider.notify,
        notify: isNotify,
      );
      provider.eventsList.setList(list: <CourseDTOModel>[], isClear: true, isNotify: isNotify);
    }
    //endregion

    //region If Not Has More Data, then return
    if (!paginationModel.hasMore) {
      MyPrint.printOnConsole('No More Event Catalog Contents', tag: tag);
      return provider.eventsList.getList(isNewInstance: true);
    }
    //endregion

    //region If Data already Loading, then return
    if (paginationModel.isLoading) return provider.eventsList.getList(isNewInstance: true);
    //endregion

    //region Set Loading True
    PaginationModel.updatePaginationData(
      paginationModel: paginationModel,
      isLoading: true,
      notifier: provider.notify,
      notify: isNotify,
    );
    //endregion

    DateTime startTime = DateTime.now();

    //region Get Request Model From Provider Data
    CatalogRequestModel catalogRequestModel = getCatalogRequestModelModelFromProviderData(
      provider: provider,
      tabId: tabId,
      paginationModel: provider.eventsPaginationModel.get(),
      componentId: componentId,
      componentInstanceId: componentInstanceId,
      apiUrlConfigurationProvider: apiUrlConfigurationProvider,
      isWishList: false,
      siteId: siteId,
    );
    //endregion

    //region Make Api Call
    DataResponseModel<CatalogResponseDTOModel> response = await CatalogRepository(apiController: eventRepository.apiController).getCatalogContentList(
      requestModel: catalogRequestModel,
      componentId: componentId,
      componentInstanceId: componentInstanceId,
      isStoreDataInHive: true,
      isFromOffline: false,
    );
    MyPrint.printOnConsole("Event Catalog Contents Length:${response.data?.CourseList.length ?? 0}", tag: tag);
    //endregion

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole("Event Catalog Data got in ${endTime.difference(startTime).inMilliseconds} Milliseconds", tag: tag);

    if (provider.currentSearchId.get() != tag) {
      MyPrint.printOnConsole('Returning from EventController().getEventCatalogContentsListFromApi() because it is not response of latest request', tag: tag);
      return provider.eventsList.getList(isNewInstance: true);
    }

    List<CourseDTOModel> contentsList = response.data?.CourseList ?? <CourseDTOModel>[];
    MyPrint.printOnConsole("Event Catalog Contents Length got in Api:${contentsList.length}", tag: tag);

    //region Set Provider Data After Getting Data From Api
    PaginationModel.updatePaginationData(
      paginationModel: paginationModel,
      isFirstTimeLoading: false,
      pageIndex: paginationModel.pageIndex + 1,
      hasMore: contentsList.length == provider.pageSize.get(),
      isLoading: false,
      notifier: provider.notify,
      notify: isNotify,
    );
    provider.eventsList.setList(list: contentsList, isClear: false, isNotify: true);
    updateEventListAccordingToCalendarDate();

    Map<String, int> eventDate = {};

    AppProvider? appProvider = AppController.mainAppContext?.read<AppProvider>();
    String dateFormat = appProvider?.appSystemConfigurationModel.eventDateTimeFormat ?? "MM/dd/yyyy hh:mm aa";

    for (CourseDTOModel event in contentsList) {
      MyPrint.printOnConsole("StartDateTime:${event.EventStartDateTime}, EndDateTime:${event.EventEndDateTime}", tag: tag);

      DateTime? startDate = ParsingHelper.parseDateTimeMethod(event.EventStartDateTime, dateFormat: dateFormat);
      DateTime? endDate = ParsingHelper.parseDateTimeMethod(event.EventEndDateTime, dateFormat: dateFormat);
      if (endDate != null && startDate != null) {
        List<DateTime> dates = MyUtils.getDaysInBetween(startDate, endDate);
        MyPrint.printOnConsole("dates:${dates.map((e) => e.toIso8601String())}", tag: tag);

        for (DateTime dateTime in dates) {
          eventDate.update(DateFormat("yyyy-MM-dd").format(dateTime), (value) => ++value, ifAbsent: () => 1);
        }
      }
    }
    MyPrint.printOnConsole("eventDate : $eventDate", tag: tag);

    eventProvider.calenderDatesHavingEventMap.setMap(map: eventDate, isClear: true, isNotify: false);

    //endregion

    return provider.eventsList.getList(isNewInstance: true);
  }

  void updateEventListAccordingToCalendarDate() {
    MyPrint.printOnConsole("EventController().updateEventListAccordingToCalendarDate() called");

    List<CourseDTOModel> eventList = eventProvider.eventsList.getList();

    DateTime selectedCalenderDate = eventProvider.selectedCalenderDate.get();
    MyPrint.printOnConsole("selectedCalenderDate: $selectedCalenderDate");

    AppProvider? appProvider = AppController.mainAppContext?.read<AppProvider>();
    String dateFormat = appProvider?.appSystemConfigurationModel.eventDateTimeFormat ?? "MM/dd/yyyy hh:mm aa";

    List<CourseDTOModel> selectedEventList = eventList.where(
      (element) {
        DateTime? eventStartDate = ParsingHelper.parseDateTimeMethod(element.EventStartDateTime, dateFormat: dateFormat);
        DateTime? eventEndDate = ParsingHelper.parseDateTimeMethod(element.EventEndDateTime, dateFormat: dateFormat);

        if (eventStartDate == null || eventEndDate == null) return false;

        return DatePresentation.isSameDay(eventStartDate, selectedCalenderDate) ||
            DatePresentation.isSameDay(eventEndDate, selectedCalenderDate) ||
            (DatePresentation.isDayAfter(selectedCalenderDate, eventStartDate) && DatePresentation.isDayBefore(selectedCalenderDate, eventEndDate));

        // DateTime? eventEndDate = ParsingHelper.parseDateTimeMethod(element.EventEndDateTime, dateFormat: "MM/dd/yyyy hh:mm aa");
        // return ((eventStartDate?.day == selectedCalenderDate.day && eventStartDate?.month == selectedCalenderDate.month && eventStartDate?.year == selectedCalenderDate.year) ||
        //     !DatePresentation.isSameDay(eventStartDate!, eventEndDate!));
      },
    ).toList();
    MyPrint.printOnConsole("selectedEventList: ${selectedEventList.length}");

    eventProvider.selectedCalendarDateEventList.setList(list: selectedEventList);
  }

  CatalogRequestModel getCatalogRequestModelModelFromProviderData(
      {required EventProvider provider,
      required String tabId,
      required PaginationModel paginationModel,
      required int componentId,
      required int componentInstanceId,
      required ApiUrlConfigurationProvider apiUrlConfigurationProvider,
      required bool isWishList,
      int? siteId}) {
    FilterProvider filterProvider = eventProvider.filterProvider;
    EnabledContentFilterByTypeModel? enabledContentFilterByTypeModel = !isWishList ? filterProvider.getEnabledContentFilterByTypeModel(isNewInstance: false) : null;

    String filtercredits = "";
    if (enabledContentFilterByTypeModel?.creditpoints ?? false) {
      FilterDurationValueModel? model = filterProvider.selectedFilterCredit.get();
      if (model != null) filtercredits = "${model.Minvalue},${model.Maxvalue}";
    }

    String eventType = getEventTypeFromTabValue(tabId);
    String additionalParameters = 'EventComponentID=$componentId~FilterContentType=${InstancyObjectTypes.events}~eventtype=$eventType~HideCompleteStatus=true';
    if (tabId == EventCatalogTabTypes.myEvents) {
      additionalParameters += "~EnableMyEvents=true";
    }

    int pageIndex = paginationModel.pageIndex;
    int pageSize = provider.pageSize.get();

    String eventdate = "";

    String? selectedStartEventDateTimeString;
    String? selectedEndEventDateTimeString;

    if (tabId == EventCatalogTabTypes.calendarView) {
      pageIndex = 1;
      pageSize = 1000;

      DateTime? calenderDate = provider.calenderDate.get();
      if (calenderDate != null) {
        int endDate = 0;
        if ([1, 3, 5, 7, 8, 10, 12].contains(calenderDate.month)) {
          endDate = 31;
        } else if ([2].contains(calenderDate.month)) {
          endDate = (calenderDate.year % 4) == 0 ? 29 : 28;
        } else {
          endDate = 30;
        }

        selectedStartEventDateTimeString = DatePresentation.getFormattedDate(dateFormat: "yyyy-MM-dd", dateTime: DateTime(calenderDate.year, calenderDate.month, 1));
        selectedEndEventDateTimeString = DatePresentation.getFormattedDate(dateFormat: "yyyy-MM-dd", dateTime: DateTime(calenderDate.year, calenderDate.month, endDate));
      }
    } else {
      selectedStartEventDateTimeString = DatePresentation.getFormattedDate(dateFormat: "yyyy-MM-dd", dateTime: filterProvider.selectedStartEventDateTime.get());
      selectedEndEventDateTimeString = DatePresentation.getFormattedDate(dateFormat: "yyyy-MM-dd", dateTime: filterProvider.selectedEndEventDateTime.get());
    }

    if (selectedStartEventDateTimeString != null && selectedEndEventDateTimeString != null) {
      eventdate = "$selectedStartEventDateTimeString ~ $selectedEndEventDateTimeString";
    }

    String additionalFilter = "";
    if (tabId == EventCatalogTabTypes.calendarSchedule) {
      DateTime? scheduleDate = provider.scheduleDate.get();
      if (scheduleDate != null) {
        scheduleDate = DateTime(scheduleDate.year, scheduleDate.month, scheduleDate.day);
      }
      additionalFilter = DatePresentation.getFormattedDate(dateFormat: "yyyy-MM-dd HH:mm:ss", dateTime: scheduleDate) ?? "";
    }

    return CatalogRequestModel(
      iswishlistcontent: isWishList ? 1 : 0,
      componentID: ParsingHelper.parseStringMethod(componentId),
      componentInsID: ParsingHelper.parseStringMethod(componentInstanceId),
      searchText: isWishList ? "" : provider.searchString.get(),
      // userID: "363",
      userID: ParsingHelper.parseStringMethod(apiUrlConfigurationProvider.getCurrentUserId()),
      siteID: ParsingHelper.parseStringMethod(apiUrlConfigurationProvider.getCurrentSiteId()),
      orgUnitID: ParsingHelper.parseStringMethod(apiUrlConfigurationProvider.getCurrentSiteId()),
      locale: apiUrlConfigurationProvider.getLocale().isNotEmpty ? apiUrlConfigurationProvider.getLocale() : "en-us",
      pageIndex: pageIndex,
      learningprotals: "${siteId ?? ""}",
      // pageSize: 500,
      pageSize: pageSize,
      contentID: "",
      keywords: "",
      sortBy: tabId == EventCatalogTabTypes.calendarSchedule
          ? "C.EventStartDateTime"
          : isWishList
              ? filterProvider.defaultSort.get()
              : filterProvider.selectedSort.get(),
      categories: (enabledContentFilterByTypeModel?.categories ?? false)
          ? AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
              list: filterProvider.selectedCategories.getList().map((e) => e.categoryId).toList(),
            )
          : "",
      objecttypes: (enabledContentFilterByTypeModel?.objecttypeid ?? false)
          ? AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
              list: filterProvider.selectedContentTypes.getList().map((e) => e.categoryId).toList(),
            )
          : "",
      skillcats: (enabledContentFilterByTypeModel?.skills ?? false)
          ? AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
              list: filterProvider.selectedSkills.getList().map((e) => e.categoryId).toList(),
            )
          : "",
      jobroles: (enabledContentFilterByTypeModel?.jobroles ?? false)
          ? AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
              list: filterProvider.selectedJobRoles.getList().map((e) => e.categoryId).toList(),
            )
          : "",
      solutions: (enabledContentFilterByTypeModel?.solutions ?? false)
          ? AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
              list: filterProvider.selectedSolutions.getList().map((e) => e.categoryId).toList(),
            )
          : "",
      ratings: (enabledContentFilterByTypeModel?.rating ?? false) ? ParsingHelper.parseStringMethod(filterProvider.selectedRating.get()) : "",
      pricerange: (enabledContentFilterByTypeModel?.ecommerceprice ?? false) && filterProvider.minPrice.get() != null && filterProvider.maxPrice.get() != null
          ? "${filterProvider.minPrice.get()},${filterProvider.maxPrice.get()}"
          : "",
      instructors: (enabledContentFilterByTypeModel?.instructor ?? false)
          ? AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
              list: filterProvider.selectedInstructor.getList().map((e) => e.UserID).toList(),
            )
          : "",
      filtercredits: filtercredits,
      additionalParams: additionalParameters,
      eventdate: eventdate,
      addtionalFilter: additionalFilter,
      // certification: "all",
    );
  }

  static String getEventTypeFromTabValue(String tabId) {
    String tabValue = 'upcoming';

    switch (tabId) {
      case EventCatalogTabTypes.upcomingCourses:
      case EventCatalogTabTypes.additionalProgramDetails:
        tabValue = "upcoming";

        break;
      case EventCatalogTabTypes.calendarSchedule:
        tabValue = "eventschedule";
        break;
      case EventCatalogTabTypes.calendarView:
        tabValue = "calendar";

        break;
      case EventCatalogTabTypes.pastCourses:
        tabValue = "past";
        break;
      case EventCatalogTabTypes.myEvents:
        tabValue = "myevents";
        break;
    }

    return tabValue;
  }

  // endregion

  // region Event Operations
  Future<bool> cancelEventEnrollment({
    required BuildContext context,
    required String eventId,
    required bool isBadCancellationEnabled,
    LocalStr? localStr,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("EventController().cancelEventEnrollment() called with eventId:'$eventId' and isBadCancellationEnabled:$isBadCancellationEnabled", tag: tag);

    EventRepository repository = eventRepository;

    bool isCancel = await checkCancelEnrollmentFromDialog(
      context: context,
      localStr: localStr,
    );
    MyPrint.printOnConsole("isCancel:$isCancel", tag: tag);

    if (!isCancel) {
      MyPrint.printOnConsole("Returning from EventController().cancelEventEnrollment() because user has opted to not cancel", tag: tag);
      return false;
    }

    bool isBadCancel = false;

    if (isBadCancellationEnabled) {
      DataResponseModel<String> dataResponseModel = await repository.checkIsFallUnderBadCancelEnrollment(eventId: eventId);
      MyPrint.printOnConsole("checkIsFallUnderBadCancelEnrollment response:$dataResponseModel", tag: tag);

      if (dataResponseModel.appErrorModel != null) {
        MyPrint.printOnConsole("Returning from EventController().cancelEventEnrollment() because checkIsFallUnderBadCancelEnrollment had some error", tag: tag);
        return false;
      }

      isBadCancel = dataResponseModel.data == "true";
    }
    MyPrint.printOnConsole("isBadCancel:$isBadCancel", tag: tag);

    DataResponseModel<String> dataResponseModel = await repository.cancelEnrolledEvent(
      eventId: eventId,
      isBadCancel: isBadCancel,
    );
    MyPrint.printOnConsole("cancelEnrolledEvent response:$dataResponseModel", tag: tag);

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from EventController().cancelEventEnrollment() because cancelEnrolledEvent had some error", tag: tag);
      return false;
    }

    return dataResponseModel.data == 'true';
  }

  Future<ReEnrollmentHistoryResponseModel?> getReEnrollmentHistory({
    required BuildContext context,
    required String eventId,
    required String instanceId,
    LocalStr? localStr,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("EventController().getReEnrollmentHistory() called with eventId:'$eventId' and instance Id: $instanceId", tag: tag);

    EventRepository repository = eventRepository;

    DataResponseModel<ReEnrollmentHistoryResponseModel> dataResponseModel = await repository.getReEnrollmentHistory(
      eventId: eventId,
      instanceId: instanceId,
    );
    MyPrint.printOnConsole("getReEnrollmentHistory response:$dataResponseModel", tag: tag);

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from EventController().getReEnrollmentHistory() because getReEnrollmentHistory had some error", tag: tag);
      return null;
    }

    return dataResponseModel.data;
  }

  Future<bool> checkCancelEnrollmentFromDialog({required BuildContext context, LocalStr? localStr}) async {
    dynamic value = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EventCancelEnrollmentDialog(
          localStr: localStr,
        );
      },
    );

    return value == true;
  }

  Future<void> joinVirtualEvent({required BuildContext? context, required String joinUrl}) async {
    MyPrint.printOnConsole("EventController().joinVirtualEvent() called with joinUrl:$joinUrl");

    if (joinUrl.isNotEmpty) {
      MyUtils.launchUrl(url: joinUrl, launchMode: LaunchMode.externalApplication);
    } else {
      if (context != null) MyToast.showError(context: context, msg: "No url found");
    }
  }

  Future<bool> addEventToCalender(
      {required BuildContext context,
      required String EventStartDateTime,
      required EventEndDateTime,
      required String eventDateTimeFormat,
      required String Title,
      required String ShortDescription,
      required String LocationName,
      bool isFromDetail = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("EventController().addEventToCalender() called", tag: tag);

    try {
      MyPrint.printOnConsole("eventDateTimeFormat:$eventDateTimeFormat", tag: tag);
      MyPrint.printOnConsole("eventStartDateTime:$EventStartDateTime", tag: tag);
      MyPrint.printOnConsole("eventEndDateTime:$EventEndDateTime", tag: tag);
      // if(isFromDetail){
      //   final startDateTime = DateFormat('dd MMM yyyy').parse(EventStartDateTime);
      //   final startNewFormat = DateFormat('dd/MM/yy hh:mm a');
      //   EventStartDateTime = startNewFormat.format(startDateTime);
      //
      //   final dateTime = DateFormat('dd MMM yyyy').parse(EventEndDateTime);
      //   final newFormat = DateFormat('dd/MM/yy hh:mm a');
      //   EventEndDateTime = newFormat.format(dateTime);
      // }
      MyPrint.printOnConsole('eventDateTimeFormat:$eventDateTimeFormat', tag: tag);

      DateTime? startDate = ParsingHelper.parseDateTimeMethod(
        EventStartDateTime,
        // dateFormat: isFromDetail ? "dd MMM yyyy" : eventDateTimeFormat,
        dateFormat: isFromDetail ? "MM/dd/yyyy hh:mm:ss a" : eventDateTimeFormat,
      );
      DateTime? endDate = ParsingHelper.parseDateTimeMethod(
        EventEndDateTime,
        // dateFormat: isFromDetail ? "dd MMM yyyy" : eventDateTimeFormat,
        dateFormat: isFromDetail ? "MM/dd/yyyy hh:mm:ss a" : eventDateTimeFormat,
      );
      MyPrint.printOnConsole('startDate:$startDate', tag: tag);
      MyPrint.printOnConsole('endDate:$endDate', tag: tag);

      if (startDate == null || endDate == null) {
        MyToast.showError(context: context, msg: "Couldn't Perform Operation");
        return false;
      }

      Event event = Event(
        title: Title,
        description: ShortDescription,
        location: LocationName,
        startDate: startDate,
        endDate: endDate,
        allDay: false,
      );
      MyPrint.printOnConsole("addEvent2Cal event.endDate:${event.endDate} event.startDate ${event.startDate}", tag: tag);

      bool isSuccess = await Add2Calendar.addEvent2Cal(event);
      MyPrint.printOnConsole("addEvent2Cal isSuccess:$isSuccess", tag: tag);

      return isSuccess;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in EventController().addEventToCalender():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    return false;
  }

  Future<void> viewRecordingForEvent({required ViewRecordingRequestModel model, required BuildContext context}) async {
    MyPrint.printOnConsole("EventController().viewRecordingForEvent() called with recordingUrl:${model.eventRecordingURL}");

    String recordingType = model.recordingType.toLowerCase();
    MyPrint.printOnConsole("recordingType:'$recordingType'");

    if (recordingType == EventRecordingType.url) {
      if (model.eventRecordingURL.isEmpty) {
        MyPrint.printOnConsole("Returning from EventController().viewRecordingForEvent() eventRecordingURL is empty");
        MyToast.showError(context: context, msg: "Recording URL Not Available");
        return;
      }

      MyUtils.launchUrl(url: model.eventRecordingURL, launchMode: LaunchMode.externalApplication);
    } else if (recordingType == EventRecordingType.video) {
      if (model.jwVideoPath.isEmpty) {
        MyPrint.printOnConsole("Returning from EventController().viewRecordingForEvent() jwVideoPath is empty");
        MyToast.showError(context: context, msg: "Recording File Not Available");
        return;
      }

      String siteUrl = ApiController().apiDataProvider.getCurrentSiteUrl();
      MyPrint.printOnConsole("SiteUrl : $siteUrl");

      if (siteUrl.isEmpty) {
        MyPrint.printOnConsole("Returning from EventController().viewRecordingForEvent() siteUrl is empty");
        return;
      }

      String launchUrl = "$siteUrl${model.jwVideoPath}";

      NavigationController.navigateToCourseLaunchWebViewScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: CourseLaunchWebViewScreenNavigationArguments(
          courseUrl: launchUrl,
          courseName: model.contentName,
          contentTypeId: model.contentTypeId,
        ),
      );
    }
  }
// endregion
}
