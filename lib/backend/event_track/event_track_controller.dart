import 'dart:io';

import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_controller.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_controller.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_provider.dart';
import 'package:flutter_instancy_2/backend/event_track/event_track_hive_repository.dart';
import 'package:flutter_instancy_2/backend/network_connection/network_connection_controller.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/common/app_error_model.dart';
import 'package:flutter_instancy_2/models/common/pagination/pagination_model.dart';
import 'package:flutter_instancy_2/models/course/data_model/gloassary_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/event_track_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/event_track_reference_item_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/related_track_data_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/track_course_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/track_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/request_model/event_related_contents_data_request_model.dart';
import 'package:flutter_instancy_2/models/event_track/request_model/event_track_tab_request_model.dart';
import 'package:flutter_instancy_2/models/event_track/request_model/track_list_view_data_request_model.dart';
import 'package:flutter_instancy_2/models/event_track/response_model/event_track_resourse_response_model.dart';
import 'package:flutter_instancy_2/models/event_track/response_model/resource_content_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/response_model/track_list_view_data_response_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:http/http.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../api/api_controller.dart';
import '../../models/common/data_response_model.dart';
import '../../models/event_track/data_model/event_track_header_dto_model.dart';
import '../../models/event_track/data_model/event_track_tab_dto_model.dart';
import '../../models/event_track/request_model/event_track_headers_request_model.dart';
import '../../models/event_track/request_model/event_track_overview_request_model.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';
import 'event_track_provider.dart';
import 'event_track_repository.dart';

class EventTrackController {
  late EventTrackProvider _eventTrackProvider;
  late EventTrackRepository _eventTrackRepository;
  late EventTrackHiveRepository _eventTrackHiveRepository;

  EventTrackController({required EventTrackProvider? learningPathProvider, EventTrackRepository? repository, EventTrackHiveRepository? hiveRepository, ApiController? apiController}) {
    _eventTrackProvider = learningPathProvider ?? EventTrackProvider();
    _eventTrackRepository = repository ?? EventTrackRepository(apiController: apiController ?? ApiController());
    _eventTrackHiveRepository = hiveRepository ?? EventTrackHiveRepository(apiController: apiController ?? ApiController());
  }

  EventTrackProvider get eventTrackProvider => _eventTrackProvider;

  EventTrackRepository get eventTrackRepository => _eventTrackRepository;

  EventTrackHiveRepository get eventTrackHiveRepository => _eventTrackHiveRepository;

  Future<bool> getEventTrackHeaderData({
    required EventTrackHeadersRequestModel requestModel,
    bool isGetDataFromOffline = false,
    bool isNotify = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("EventTrackController().getEventTrackHeaderData() called with requestModel:'$requestModel'", tag: tag);

    EventTrackProvider provider = eventTrackProvider;
    provider.isHeaderDataLoading.set(value: true, isNotify: isNotify);

    EventTrackHeaderDTOModel? eventTrackHeaderDTOModel;

    bool isInternetAvailable = NetworkConnectionController().checkConnection();
    MyPrint.printOnConsole("isInternetAvailable:$isInternetAvailable", tag: tag);

    if (isInternetAvailable && !isGetDataFromOffline) {
      DataResponseModel<EventTrackHeaderDTOModel> dataResponseModel = await eventTrackRepository.getEventTrackTrackHeader(requestModel: requestModel);
      MyPrint.printOnConsole("getEventTrackTrackHeader response:$dataResponseModel", tag: tag);

      eventTrackHeaderDTOModel = dataResponseModel.data;

      if (eventTrackHeaderDTOModel != null) {
        eventTrackHiveRepository.addEventTrackHeaderDTOModelInBox(headerData: {requestModel.parentcontentID: eventTrackHeaderDTOModel});
      } else {
        eventTrackHiveRepository.removeRecordsFromEventTrackScreenHeaderDataBoxById(eventTrackContentIds: [requestModel.parentcontentID]);
      }

      if (dataResponseModel.appErrorModel != null) {
        MyPrint.printOnConsole("Returning from EventTrackController().getEventTrackHeaderData() because getEventTrackTrackHeader had some error", tag: tag);

        provider.eventTrackHeaderData.set(value: eventTrackHeaderDTOModel ?? EventTrackHeaderDTOModel(), isNotify: false);
        provider.isHeaderDataLoading.set(value: false, isNotify: true);

        return false;
      }
    } else {
      eventTrackHeaderDTOModel = await eventTrackHiveRepository.getEventTrackHeaderDTOModelById(eventTrackContentId: requestModel.parentcontentID);
    }

    provider.eventTrackHeaderData.set(value: eventTrackHeaderDTOModel ?? EventTrackHeaderDTOModel(), isNotify: false);
    provider.isHeaderDataLoading.set(value: false, isNotify: true);

    BuildContext? context = AppController.mainAppContext;
    if (context != null && eventTrackHeaderDTOModel != null) {
      AppProvider appProvider = context.read<AppProvider>();
      CourseDownloadProvider courseDownloadProvider = context.read<CourseDownloadProvider>();
      CourseDownloadController courseDownloadController = CourseDownloadController(
        appProvider: appProvider,
        courseDownloadProvider: courseDownloadProvider,
      );

      courseDownloadController.updateEventTrackParentModelInDownloadsAndHeaderModel(
        eventTrackContentId: eventTrackHeaderDTOModel.ContentID,
        PercentageCompleted: ParsingHelper.parseDoubleNullableMethod(eventTrackHeaderDTOModel.percentagecompleted),
        CoreLessonStatus: eventTrackHeaderDTOModel.ContentStatus,
        DisplayStatus: eventTrackHeaderDTOModel.DisplayStatus,
      );
    }

    return true;
  }

  Future<bool> getEventTrackTabsData({
    required EventTrackTabRequestModel requestModel,
    bool isGetDataFromOffline = false,
    bool isNotify = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("EventTrackController().getLEventTrackTabsData() called with requestModel:'$requestModel'", tag: tag);

    EventTrackProvider provider = eventTrackProvider;
    provider.isTabListLoading.set(value: true, isNotify: isNotify);

    List<EventTrackTabDTOModel> tabsList = <EventTrackTabDTOModel>[];

    bool isInternetAvailable = NetworkConnectionController().checkConnection();
    MyPrint.printOnConsole("isInternetAvailable:$isInternetAvailable", tag: tag);

    bool isGetFromOnline = false;

    if (isGetDataFromOffline) {
      tabsList = await eventTrackHiveRepository.getTabsListFromEventTrackContentId(eventTrackContentId: requestModel.parentcontentID);

      if (tabsList.isEmpty) isGetFromOnline = isInternetAvailable;
    } else {
      isGetFromOnline = isInternetAvailable;
    }

    if (isGetFromOnline) {
      DataResponseModel<List<EventTrackTabDTOModel>> dataResponseModel = await eventTrackRepository.getEventTrackTabList(
        requestModel: requestModel,
      );

      MyPrint.printOnConsole("EventTrackTabDTOModelList response:$dataResponseModel", tag: tag);

      tabsList = dataResponseModel.data ?? tabsList;

      if (dataResponseModel.appErrorModel != null) {
        MyPrint.printOnConsole("Returning from EventTrackController().getLEventTrackTabsData() because getEventTrackTabList had some error", tag: tag);
        provider.isTabListLoading.set(value: false, isNotify: true);

        return false;
      }

      eventTrackHiveRepository.setTabListForEventTrackContentId(
        eventTrackContentId: requestModel.parentcontentID,
        tabsList: tabsList,
      );
    }

    if (!isInternetAvailable) {
      tabsList = tabsList.where((element) {
        return [
          EventTrackTabs.trackContents,
          EventTrackTabs.eventContents,
        ].contains(element.tabidName);
      }).toList();
    }

    MyPrint.printOnConsole("Final TabsList length:${tabsList.length}", tag: tag);

    provider.eventTrackTabList.setList(list: tabsList, isNotify: false);
    provider.isTabListLoading.set(value: false, isNotify: true);

    return true;
  }

  Future<bool> getOverviewData({
    required EventTrackOverviewRequestModel requestModel,
    bool isNotify = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("EventTrackController().getOverviewData() called with requestModel:'$requestModel'", tag: tag);

    EventTrackProvider provider = eventTrackProvider;
    provider.isOverviewDataLoading.set(value: true, isNotify: isNotify);

    DataResponseModel<List<EventTrackDTOModel>> dataResponseModel = await eventTrackRepository.getEventTrackOverviewData(
      requestModel: requestModel,
    );

    MyPrint.printOnConsole("EventTrackDTOModel response:$dataResponseModel", tag: tag);

    provider.overviewData.set(value: dataResponseModel.data?.firstElement, isNotify: false);
    provider.isOverviewDataLoading.set(value: false, isNotify: true);

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from EventTrackController().getOverviewData() because getEventTrackOverviewData had some error", tag: tag);
      return false;
    }

    return true;
  }

  Future<bool> getGlossaryData({
    required String contentId,
    bool isNotify = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("EventTrackController().getGlossaryData() called with contentId:'$contentId'", tag: tag);

    EventTrackProvider provider = eventTrackProvider;
    provider.isGlossaryDataLoading.set(value: true, isNotify: isNotify);

    DataResponseModel<List<GlossaryModel>> dataResponseModel = await eventTrackRepository.getGlossaryData(
      contentid: contentId,
    );

    MyPrint.printOnConsole("GlossaryModelList response:$dataResponseModel", tag: tag);

    provider.glossaryData.setList(list: dataResponseModel.data ?? <GlossaryModel>[], isNotify: false);
    provider.isGlossaryDataLoading.set(value: false, isNotify: true);

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from EventTrackController().getGlossaryData() because getGlossaryData had some error", tag: tag);
      return false;
    }

    return true;
  }

  Future<bool> getResourcesData({
    required String contentId,
    bool isNotify = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("EventTrackController().getResourcesData() called with contentId:'$contentId'", tag: tag);

    EventTrackProvider provider = eventTrackProvider;
    provider.isResourcesDataLoading.set(value: true, isNotify: isNotify);

    DataResponseModel<EventTrackResourceResponseModel> dataResponseModel = await eventTrackRepository.getResourcesData(
      contentid: contentId,
    );

    MyPrint.printOnConsole("EventTrackResourceResponseModel response:$dataResponseModel", tag: tag);

    provider.resourcesData.setList(list: dataResponseModel.data?.references?.referenceItem ?? <EventTrackReferenceItemModel>[], isNotify: false);
    provider.isResourcesDataLoading.set(value: false, isNotify: true);

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from EventTrackController().getResourcesData() because getResourcesData had some error", tag: tag);
      return false;
    }

    return true;
  }

  Future<bool> getTrackContentsData({
    bool isRefresh = true,
    required String contentId,
    required int objectTypeId,
    required int componentId,
    required int componentInsId,
    required int trackScoId,
    bool isAssignmentTabEnabled = false,
    bool isGetDataFromOffline = false,
    bool isNotify = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("EventTrackController().getTrackContentsData() called with isRefresh:$isRefresh, contentId:'$contentId'", tag: tag);

    EventTrackProvider provider = eventTrackProvider;

    if (!isRefresh && provider.trackContentsData.length > 0) {
      MyPrint.printOnConsole("Returning from EventTrackController().getTrackContentsData() already having data", tag: tag);
      return true;
    }

    provider.isTrackContentsDataLoading.set(value: true, isNotify: isNotify);

    List<TrackDTOModel> contentsBlocksList = <TrackDTOModel>[];
    String bookmarkId = "";
    AppErrorModel? appErrorModel;

    bool isInternetAvailable = NetworkConnectionController().checkConnection();
    MyPrint.printOnConsole("isInternetAvailable:$isInternetAvailable", tag: tag);

    if (isInternetAvailable && !isGetDataFromOffline) {
      DataResponseModel<TrackListViewDataResponseModel> dataResponseModel = await eventTrackRepository.getTrackListViewData(
        requestModel: TrackListViewDataRequestModel(
          parentcontentID: contentId,
          compID: componentId,
          compInsID: componentInsId,
          objecttypeId: objectTypeId,
          Trackscoid: trackScoId,
          isAssignmentTab: false,
          isAssignmentTabEnabled: isAssignmentTabEnabled,
          wLaunchType: "onlaunch",
        ),
      );

      MyPrint.printOnConsole("TrackListViewDataResponseModel response:$dataResponseModel", tag: tag);

      appErrorModel = dataResponseModel.appErrorModel;
      if (dataResponseModel.appErrorModel != null) {
        MyPrint.printOnConsole("Returning from EventTrackController().getTrackContentsData() because getTrackListViewData had some error", tag: tag);
      }

      if (dataResponseModel.data != null) {
        TrackListViewDataResponseModel responseModel = dataResponseModel.data!;
        if (responseModel.BookMarkData.checkNotEmpty) {
          bookmarkId = responseModel.BookMarkData.firstOrNull?.BookMarkID ?? "";
        }
        contentsBlocksList = responseModel.TrackListData;
        eventTrackHiveRepository.addTrackContentsDataInBox(trackContentData: {contentId: responseModel}, isClear: false);

        List<Future> futures = [];

        AppProvider? appProvider = AppController.mainAppContext?.read<AppProvider>();
        CourseDownloadProvider? courseDownloadProvider = AppController.mainAppContext?.read<CourseDownloadProvider>();
        if (appProvider != null && courseDownloadProvider != null) {
          CourseDownloadController courseDownloadController = CourseDownloadController(appProvider: appProvider, courseDownloadProvider: courseDownloadProvider);

          Map<String, TrackCourseDTOModel> contentsList = <String, TrackCourseDTOModel>{};
          for (TrackDTOModel trackDTOModel in contentsBlocksList) {
            for (TrackCourseDTOModel trackCourseDTOModel in trackDTOModel.TrackList) {
              contentsList[trackCourseDTOModel.ContentID] = trackCourseDTOModel;
            }
          }

          if (contentsList.isNotEmpty) futures.add(courseDownloadController.updateTrackContentsInDownloadsAndSyncDataOffline(contentsList: contentsList.values.toList(), parentCourseId: contentId));
        }

        if (futures.isNotEmpty) await Future.wait(futures);
      } else {
        eventTrackHiveRepository.removeRecordsFromTrackContentsDataBoxById(trackIds: [contentId]);
      }
    } else {
      TrackListViewDataResponseModel? responseModel = await eventTrackHiveRepository.getTrackContentDataForTrackId(trackId: contentId);
      MyPrint.printOnConsole("GetTrackContentDataForTrackId response not null:${responseModel != null}", tag: tag);

      if ((responseModel?.BookMarkData).checkNotEmpty) {
        bookmarkId = responseModel?.BookMarkData.firstOrNull?.BookMarkID ?? "";
      }
      contentsBlocksList = responseModel?.TrackListData ?? <TrackDTOModel>[];
    }

    MyPrint.printOnConsole("Final contentsBlocksList length:${contentsBlocksList.length}");

    provider.trackContentsData.setList(list: contentsBlocksList, isClear: true, isNotify: false);
    provider.bookmarkId.set(value: bookmarkId, isNotify: false);
    provider.isTrackContentsDataLoading.set(value: false, isNotify: true);

    if (appErrorModel != null) {
      return false;
    }

    return true;
  }

  Future<bool> getTrackAssignmentsData({
    bool isRefresh = true,
    required String contentId,
    required int objectTypeId,
    required int componentId,
    required int componentInsId,
    required int trackScoId,
    bool isAssignmentTabEnabled = false,
    bool isGetDataFromOffline = false,
    bool isNotify = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("EventTrackController().getTrackAssignmentsData() called with isRefresh:$isRefresh, contentId:'$contentId'", tag: tag);

    EventTrackProvider provider = eventTrackProvider;

    if (!isRefresh && provider.trackContentsData.length > 0) {
      MyPrint.printOnConsole("Returning from EventTrackController().getTrackAssignmentsData() already having data", tag: tag);
      return true;
    }

    provider.isTrackAssignmentsDataLoading.set(value: true, isNotify: isNotify);

    List<TrackDTOModel> contentsBlocksList = <TrackDTOModel>[];
    String bookmarkId = "";
    AppErrorModel? appErrorModel;

    bool isInternetAvailable = NetworkConnectionController().checkConnection();
    MyPrint.printOnConsole("isInternetAvailable:$isInternetAvailable", tag: tag);

    if (isInternetAvailable && !isGetDataFromOffline) {
      DataResponseModel<TrackListViewDataResponseModel> dataResponseModel = await eventTrackRepository.getTrackListViewData(
        requestModel: TrackListViewDataRequestModel(
          parentcontentID: contentId,
          compID: componentId,
          compInsID: componentInsId,
          objecttypeId: objectTypeId,
          Trackscoid: trackScoId,
          isAssignmentTab: true,
          isAssignmentTabEnabled: isAssignmentTabEnabled,
          wLaunchType: "onlaunch",
        ),
      );

      MyPrint.printOnConsole("TrackListViewDataResponseModel response:$dataResponseModel", tag: tag);

      appErrorModel = dataResponseModel.appErrorModel;
      if (dataResponseModel.appErrorModel != null) {
        MyPrint.printOnConsole("Returning from EventTrackController().getTrackContentsData() because getTrackListViewData had some error", tag: tag);
      }

      if (dataResponseModel.data != null) {
        TrackListViewDataResponseModel responseModel = dataResponseModel.data!;
        if (responseModel.BookMarkData.checkNotEmpty) {
          bookmarkId = responseModel.BookMarkData.firstOrNull?.BookMarkID ?? "";
        }
        contentsBlocksList = responseModel.TrackListData;
        eventTrackHiveRepository.addTrackAssignmentDataInBox(trackContentData: {contentId: responseModel}, isClear: false);

        List<Future> futures = [];

        AppProvider? appProvider = AppController.mainAppContext?.read<AppProvider>();
        CourseDownloadProvider? courseDownloadProvider = AppController.mainAppContext?.read<CourseDownloadProvider>();
        if (appProvider != null && courseDownloadProvider != null) {
          CourseDownloadController courseDownloadController = CourseDownloadController(appProvider: appProvider, courseDownloadProvider: courseDownloadProvider);

          Map<String, TrackCourseDTOModel> contentsList = <String, TrackCourseDTOModel>{};
          for (TrackDTOModel trackDTOModel in contentsBlocksList) {
            for (TrackCourseDTOModel trackCourseDTOModel in trackDTOModel.TrackList) {
              contentsList[trackCourseDTOModel.ContentID] = trackCourseDTOModel;
            }
          }

          if (contentsList.isNotEmpty) futures.add(courseDownloadController.updateTrackContentsInDownloadsAndSyncDataOffline(contentsList: contentsList.values.toList(), parentCourseId: contentId));
        }

        if (futures.isNotEmpty) await Future.wait(futures);
      } else {
        eventTrackHiveRepository.removeRecordsFromTrackAssignmentsDataBoxById(trackIds: [contentId]);
      }
    } else {
      TrackListViewDataResponseModel? responseModel = await eventTrackHiveRepository.getTrackAssignmentDataForTrackId(trackId: contentId);
      MyPrint.printOnConsole("GetTrackContentDataForTrackId response not null:${responseModel != null}", tag: tag);

      if ((responseModel?.BookMarkData).checkNotEmpty) {
        bookmarkId = responseModel?.BookMarkData.firstOrNull?.BookMarkID ?? "";
      }
      contentsBlocksList = responseModel?.TrackListData ?? <TrackDTOModel>[];
    }

    MyPrint.printOnConsole("Final contentsBlocksList length:${contentsBlocksList.length}");

    provider.trackAssignmentsData.setList(list: contentsBlocksList, isClear: true, isNotify: false);
    provider.bookmarkId.set(value: bookmarkId, isNotify: false);
    provider.isTrackAssignmentsDataLoading.set(value: false, isNotify: true);

    if (appErrorModel != null) {
      return false;
    }

    return true;
  }

  Future<List<RelatedTrackDataDTOModel>> getEventRelatedContentsData({
    bool isRefresh = true,
    bool isGetFromCache = false,
    required String contentId,
    required int componentId,
    required int componentInstanceId,
    bool isAssignmentTabEnabled = false,
    bool isGetDataFromOffline = false,
    bool isNotify = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
      "EventTrackController().getEventRelatedContentsData() called with isRefresh:$isRefresh, isGetFromCache:$isGetFromCache, "
      "isNotify:$isNotify, componentId:$componentId, componentInstanceId:$componentInstanceId",
      tag: tag,
    );

    EventTrackProvider provider = eventTrackProvider;
    PaginationModel paginationModel = provider.eventRelatedContentsDataPaginationModel.get();

    //region If Not refresh and Data available, return Cached Data
    if (!isRefresh && isGetFromCache && provider.eventRelatedContentsData.length > 0) {
      MyPrint.printOnConsole("Returning Cached Data", tag: tag);
      return provider.eventRelatedContentsData.getList(isNewInstance: true);
    }
    //endregion

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
      provider.eventRelatedContentsData.setList(list: <RelatedTrackDataDTOModel>[], isClear: true, isNotify: isNotify);
    }
    //endregion

    //region If Not Has More Data, then return
    if (!paginationModel.hasMore) {
      MyPrint.printOnConsole('No More Event Related Contents', tag: tag);
      return provider.eventRelatedContentsData.getList(isNewInstance: true);
    }
    //endregion

    //region If Data already Loading, then return
    if (paginationModel.isLoading) return provider.eventRelatedContentsData.getList(isNewInstance: true);
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
    EventRelatedContentsDataRequestModel requestModel = EventRelatedContentsDataRequestModel(
      ContentID: contentId,
      ComponentID: componentId,
      ComponentInsID: componentInstanceId,
      isAssignmentTabEnabled: isAssignmentTabEnabled,
      isAssignmentTab: false,
      pageIndex: paginationModel.pageIndex,
      pageSize: paginationModel.pageSize,
    );
    //endregion

    //region Make Api Call
    List<RelatedTrackDataDTOModel> contentsList;

    bool isInternetAvailable = NetworkConnectionController().checkConnection();
    MyPrint.printOnConsole("isInternetAvailable:$isInternetAvailable", tag: tag);

    if (isInternetAvailable && !isGetDataFromOffline) {
      DataResponseModel<ResourceContentDTOModel> response = await eventTrackRepository.getEventRelatedContentsData(requestModel: requestModel);
      MyPrint.printOnConsole("Event Related Contents Length:${response.data?.ResouseList.length ?? 0}", tag: tag);

      contentsList = response.data?.ResouseList ?? <RelatedTrackDataDTOModel>[];

      if (response.data != null) {
        ResourceContentDTOModel responseModel = response.data!;
        contentsList = responseModel.ResouseList;
        eventTrackHiveRepository.addEventRelatedContentDataInBox(eventRelatedContentData: {contentId: responseModel}, isClear: false);
      } else {
        eventTrackHiveRepository.removeRecordsFromEventRelatedContentModelsBoxById(eventIds: [contentId]);
      }

      List<Future> futures = [];

      AppProvider? appProvider = AppController.mainAppContext?.read<AppProvider>();
      CourseDownloadProvider? courseDownloadProvider = AppController.mainAppContext?.read<CourseDownloadProvider>();
      if (appProvider != null && courseDownloadProvider != null) {
        CourseDownloadController courseDownloadController = CourseDownloadController(appProvider: appProvider, courseDownloadProvider: courseDownloadProvider);

        if (contentsList.isNotEmpty) futures.add(courseDownloadController.updateEventRelatedContentsInDownloadsAndSyncDataOffline(contentsList: contentsList, parentCourseId: contentId));
      }

      if (futures.isNotEmpty) await Future.wait(futures);
    } else {
      ResourceContentDTOModel? resourceContentDTOModel = await eventTrackHiveRepository.getEventRelatedContentDataForEventId(eventId: contentId);
      MyPrint.printOnConsole("getEventRelatedContentDataForEventId response not null:${resourceContentDTOModel != null}", tag: tag);

      contentsList = resourceContentDTOModel?.ResouseList ?? <RelatedTrackDataDTOModel>[];
    }
    //endregion

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole("Event Related Contents Data got in ${endTime.difference(startTime).inMilliseconds} Milliseconds", tag: tag);

    MyPrint.printOnConsole("Event Related Contents Length got in Api:${contentsList.length}", tag: tag);

    //region Set Provider Data After Getting Data From Api
    PaginationModel.updatePaginationData(
      paginationModel: paginationModel,
      isFirstTimeLoading: false,
      pageIndex: paginationModel.pageIndex + 1,
      hasMore: contentsList.length == paginationModel.pageSize,
      isLoading: false,
      notifier: provider.notify,
      notify: isNotify,
    );
    provider.eventRelatedContentsData.setList(list: contentsList, isClear: false, isNotify: true);
    //endregion

    return provider.eventRelatedContentsData.getList(isNewInstance: true);
  }

  Future<List<RelatedTrackDataDTOModel>> getEventRelatedAssignmentsData({
    bool isRefresh = true,
    bool isGetFromCache = false,
    required String contentId,
    required int componentId,
    required int componentInstanceId,
    bool isAssignmentTabEnabled = false,
    bool isGetDataFromOffline = false,
    bool isNotify = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
      "EventTrackController().getEventRelatedAssignmentsData() called with isRefresh:$isRefresh, isGetFromCache:$isGetFromCache, "
      "isNotify:$isNotify, componentId:$componentId, componentInstanceId:$componentInstanceId",
      tag: tag,
    );

    EventTrackProvider provider = eventTrackProvider;
    PaginationModel paginationModel = provider.eventRelatedAssignmentsDataPaginationModel.get();

    //region If Not refresh and Data available, return Cached Data
    if (!isRefresh && isGetFromCache && provider.eventRelatedAssignmentsData.length > 0) {
      MyPrint.printOnConsole("Returning Cached Data", tag: tag);
      return provider.eventRelatedAssignmentsData.getList(isNewInstance: true);
    }
    //endregion

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
      provider.eventRelatedAssignmentsData.setList(list: <RelatedTrackDataDTOModel>[], isClear: true, isNotify: isNotify);
    }
    //endregion

    //region If Not Has More Data, then return
    if (!paginationModel.hasMore) {
      MyPrint.printOnConsole('No More Event Related Contents', tag: tag);
      return provider.eventRelatedAssignmentsData.getList(isNewInstance: true);
    }
    //endregion

    //region If Data already Loading, then return
    if (paginationModel.isLoading) return provider.eventRelatedAssignmentsData.getList(isNewInstance: true);
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
    EventRelatedContentsDataRequestModel requestModel = EventRelatedContentsDataRequestModel(
      ContentID: contentId,
      ComponentID: componentId,
      ComponentInsID: componentInstanceId,
      isAssignmentTabEnabled: isAssignmentTabEnabled,
      isAssignmentTab: true,
      pageIndex: paginationModel.pageIndex,
      pageSize: paginationModel.pageSize,
    );
    //endregion

    //region Make Api Call
    List<RelatedTrackDataDTOModel> contentsList;

    bool isInternetAvailable = NetworkConnectionController().checkConnection();
    MyPrint.printOnConsole("isInternetAvailable:$isInternetAvailable", tag: tag);

    if (isInternetAvailable && !isGetDataFromOffline) {
      DataResponseModel<ResourceContentDTOModel> response = await eventTrackRepository.getEventRelatedContentsData(requestModel: requestModel);
      MyPrint.printOnConsole("Event Related Contents Length:${response.data?.ResouseList.length ?? 0}", tag: tag);

      contentsList = response.data?.ResouseList ?? <RelatedTrackDataDTOModel>[];

      if (response.data != null) {
        ResourceContentDTOModel responseModel = response.data!;
        contentsList = responseModel.ResouseList;
        eventTrackHiveRepository.addEventRelatedAssignmentDataInBox(eventRelatedContentData: {contentId: responseModel}, isClear: false);
      } else {
        eventTrackHiveRepository.removeRecordsFromEventRelatedAssignmentModelsBoxById(eventIds: [contentId]);
      }

      List<Future> futures = [];

      AppProvider? appProvider = AppController.mainAppContext?.read<AppProvider>();
      CourseDownloadProvider? courseDownloadProvider = AppController.mainAppContext?.read<CourseDownloadProvider>();
      if (appProvider != null && courseDownloadProvider != null) {
        CourseDownloadController courseDownloadController = CourseDownloadController(appProvider: appProvider, courseDownloadProvider: courseDownloadProvider);

        if (contentsList.isNotEmpty) futures.add(courseDownloadController.updateEventRelatedContentsInDownloadsAndSyncDataOffline(contentsList: contentsList, parentCourseId: contentId));
      }

      if (futures.isNotEmpty) await Future.wait(futures);
    } else {
      ResourceContentDTOModel? resourceContentDTOModel = await eventTrackHiveRepository.getEventRelatedContentDataForEventId(eventId: contentId);
      MyPrint.printOnConsole("getEventRelatedContentDataForEventId response not null:${resourceContentDTOModel != null}", tag: tag);

      contentsList = resourceContentDTOModel?.ResouseList ?? <RelatedTrackDataDTOModel>[];
    }
    //endregion

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole("Event Related Assignments Data got in ${endTime.difference(startTime).inMilliseconds} Milliseconds", tag: tag);

    MyPrint.printOnConsole("Event Related Assignments Length got in Api:${contentsList.length}", tag: tag);

    //region Set Provider Data After Getting Data From Api
    PaginationModel.updatePaginationData(
      paginationModel: paginationModel,
      isFirstTimeLoading: false,
      pageIndex: paginationModel.pageIndex + 1,
      hasMore: contentsList.length == paginationModel.pageSize,
      isLoading: false,
      notifier: provider.notify,
      notify: isNotify,
    );
    provider.eventRelatedAssignmentsData.setList(list: contentsList, isClear: false, isNotify: true);
    //endregion

    return provider.eventRelatedAssignmentsData.getList(isNewInstance: true);
  }

  //region Simple File Download
  Future<bool> simpleDownloadFileAndSave({required String downloadUrl, required String downloadFileName, String downloadFolderPath = ""}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
      "EventTrackController().simpleDownloadFileAndSave() called with downloadUrl:'$downloadUrl', "
      "downloadFileName:'$downloadFileName', downloadFolderPath:'$downloadFolderPath'",
      tag: tag,
    );

    try {
      if (kIsWeb) {
        MyPrint.printOnConsole("Returning from EventTrackController().simpleDownloadFileAndSave() because running on web platform.", tag: tag);
        return false;
      }

      if (downloadUrl.isEmpty) {
        MyPrint.printOnConsole("Returning from EventTrackController().simpleDownloadFileAndSave() because downloadUrl is empty", tag: tag);
        return false;
      }

      if (downloadFileName.isEmpty) {
        MyPrint.printOnConsole("Returning from EventTrackController().simpleDownloadFileAndSave() because downloadFileName is empty", tag: tag);
        return false;
      }

      String pathSeparator = Platform.pathSeparator;
      MyPrint.printOnConsole("pathSeparator:'$pathSeparator'", tag: tag);
      if (pathSeparator.isEmpty) {
        MyPrint.printOnConsole("Returning from EventTrackController().simpleDownloadFileAndSave() because pathSeparator is empty", tag: tag);
        return false;
      }

      Uint8List? bytes = await downloadFile(url: downloadUrl);
      MyPrint.printOnConsole("bytes:'${bytes?.length}'", tag: tag);
      if (bytes == null) {
        MyPrint.printOnConsole("Returning from EventTrackController().simpleDownloadFileAndSave() because bytes are null", tag: tag);
        return false;
      }

      bool isDownloaded = await downloadFileFromBytes(bytes: bytes, downloadFileName: downloadFileName);
      MyPrint.printOnConsole("isDownloaded:'$isDownloaded'", tag: tag);

      return isDownloaded;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in EventTrackController().simpleDownloadFileAndSave():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return false;
    }
  }

  static Future<Uint8List?> downloadFile({required String url}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("EventTrackController().downloadFile() called with url:'$url'", tag: tag);

    Response? response;

    try {
      response = await get(Uri.parse(url));

      return response.bodyBytes;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in EventTrackController().downloadFile():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return null;
    }
  }

  static Future<String> getDownloadsDirectoryPath() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("EventTrackController().getDownloadsDirectoryPath() called", tag: tag);

    if (kIsWeb) {
      MyPrint.printOnConsole("Returning from EventTrackController().getDownloadsDirectoryPath() because running on web platform.", tag: tag);
      return "";
    }

    //region Download Directory Path Initialization
    String downloadDirectoryPath = "";

    if (Platform.isAndroid) {
      downloadDirectoryPath = "/storage/emulated/0/Download";
    } else if (Platform.isIOS) {
      try {
        downloadDirectoryPath = (await getApplicationDocumentsDirectory()).path;
      } catch (e, s) {
        MyPrint.printOnConsole("Error in EventTrackController().getDownloadsDirectoryPath():$e", tag: tag);
        MyPrint.printOnConsole(s, tag: tag);
      }
    }

    if (downloadDirectoryPath.isEmpty) {
      MyPrint.printOnConsole("Returning from EventTrackController().getDownloadsDirectoryPath() because downloadDirectoryPath is empty", tag: tag);
      return "";
    }
    //endregion

    //region Download Directory Existance Verification
    MyPrint.printOnConsole("downloadDirectoryPath checking for existance:'$downloadDirectoryPath'", tag: tag);
    try {
      Directory savedDir = Directory(downloadDirectoryPath);
      bool directoryExist = await savedDir.exists();
      MyPrint.printOnConsole("directoryExist:$directoryExist", tag: tag);

      if (!directoryExist) {
        MyPrint.printOnConsole("Creating Directory", tag: tag);
        savedDir = await savedDir.create(recursive: true);

        directoryExist = await savedDir.exists();
        MyPrint.printOnConsole("directoryExist after creation:$directoryExist", tag: tag);
        if (!directoryExist) {
          MyPrint.printOnConsole("Returning from EventTrackController().getDownloadsDirectoryPath() because couldn't create download directory", tag: tag);
          return "";
        }
      }

      MyPrint.printOnConsole("Final downloadDirectoryPath:'$downloadDirectoryPath'", tag: tag);
      return downloadDirectoryPath;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in Checking Directory Exist in EventTrackController().getDownloadsDirectoryPath():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return "";
    }
    //endregion
  }

  static Future<bool> downloadFileFromBytes({required Uint8List bytes, String downloadFileName = ""}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("EventTrackController().downloadFileFromBytes() called with bytes:'${bytes.length}'", tag: tag);

    if (kIsWeb) {
      MyPrint.printOnConsole("Returning from EventTrackController().downloadFileFromBytes() because running on web platform.", tag: tag);
      return false;
    }

    if (downloadFileName.isEmpty) {
      MyPrint.printOnConsole("Returning from EventTrackController().downloadFileFromBytes() because downloadFileName is empty", tag: tag);
      return false;
    }

    //region Permission Validation
    List<Permission> permissions = [Permission.storage];

    for (Permission permission in permissions) {
      PermissionStatus permissionStatus = await permission.status;
      MyPrint.printOnConsole("Permission Status For $permission:$permissionStatus", tag: tag);

      if ([PermissionStatus.denied].contains(permissionStatus)) {
        permissionStatus = await permission.request();
      }
      MyPrint.printOnConsole("Final Permission Status For $permission:$permissionStatus", tag: tag);
      /*if (![PermissionStatus.granted, PermissionStatus.restricted].contains(permissionStatus)) {
        MyPrint.printOnConsole("Returning from EventTrackController().downloadFileFromBytes() because $permission not granted", tag: tag);
        MyPrint.printOnConsole("$permission Permission Not Granted", tag: tag);
        return false;
      }*/
    }
    //endregion

    try {
      //Save single text file
      String mimeType = lookupMimeType(downloadFileName) ?? "application/octet-stream";
      MyPrint.printOnConsole("mimeTypeL:'$mimeType'", tag: tag);
      await DocumentFileSavePlus().saveFile(bytes, downloadFileName, mimeType);
      return true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in EventTrackController().downloadFileFromBytes():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return false;
    }
  }

  static Future<bool> saveBytesInFile2({required Uint8List bytes, String downloadFilePath = "", String downloadFileName = "", bool askForDirectory = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("EventTrackController().saveBytesInFile2() called with bytes:'${bytes.length}', downloadFilePath:'$downloadFilePath'", tag: tag);

    if (kIsWeb) {
      MyPrint.printOnConsole("Returning from EventTrackController().saveBytesInFile2() because running on web platform.", tag: tag);
      return false;
    }

    if (downloadFileName.isEmpty) {
      MyPrint.printOnConsole("Returning from EventTrackController().saveBytesInFile2() because downloadFileName is empty", tag: tag);
      return false;
    }

    if (!askForDirectory) {
      if (downloadFilePath.isEmpty) {
        MyPrint.printOnConsole("Returning from EventTrackController().saveBytesInFile2() because downloadFilePath is empty", tag: tag);
        return false;
      }
    } else {
      if (downloadFileName.isEmpty) {
        MyPrint.printOnConsole("Returning from EventTrackController().saveBytesInFile2() because downloadFileName is empty", tag: tag);
        return false;
      }
    }

    //region Permission Validation
    List<Permission> permissions = [Permission.storage];
    if (Platform.isAndroid) {
      permissions.addAll([Permission.accessMediaLocation, Permission.manageExternalStorage]);
    } else if (Platform.isIOS) {
      permissions.add(Permission.mediaLibrary);
    }

    for (Permission permission in permissions) {
      PermissionStatus permissionStatus = await permission.status;
      MyPrint.printOnConsole("Permission Status For $permission:$permissionStatus", tag: tag);

      if (![PermissionStatus.granted, PermissionStatus.restricted].contains(permissionStatus)) {
        permissionStatus = await permission.request();
      }
      MyPrint.printOnConsole("Final Permission Status For $permission:$permissionStatus", tag: tag);
      /*if (![PermissionStatus.granted, PermissionStatus.restricted].contains(permissionStatus)) {
        MyPrint.printOnConsole("Returning from EventTrackController().saveBytesInFile2() because $permission not granted", tag: tag);
        MyPrint.printOnConsole("$permission Permission Not Granted", tag: tag);
        return false;
      }*/
    }
    //endregion

    try {
      String pathSeparator = Platform.pathSeparator;
      MyPrint.printOnConsole("pathSeparator:'$pathSeparator'", tag: tag);
      if (pathSeparator.isEmpty) {
        MyPrint.printOnConsole("Returning from saveBytesInFile2() because pathSeparator is empty", tag: tag);
        return false;
      }

      if (askForDirectory) {
        String? directoryPath = await FilePicker.platform.getDirectoryPath(
          dialogTitle: "Save",
        );
        if (directoryPath.checkEmpty) {
          MyPrint.printOnConsole("Returning from EventTrackController().saveBytesInFile2() because Save Directory Path is empty", tag: tag);
          return false;
        }
        downloadFilePath = "$directoryPath$pathSeparator$downloadFileName";
      }

      MyPrint.printOnConsole("Final downloadFilePath:'$downloadFilePath'");

      File file = File(downloadFilePath);

      bool fileExist = await file.exists();
      MyPrint.printOnConsole("fileExist:$fileExist", tag: tag);

      if (fileExist) {
        MyPrint.printOnConsole("Deleting File", tag: tag);
        try {
          await file.delete(recursive: true);
          MyPrint.printOnConsole("File Deleted", tag: tag);
        } catch (e, s) {
          MyPrint.printOnConsole("Error in Deleting File in EventTrackController().saveBytesInFile2():$e", tag: tag);
          MyPrint.printOnConsole(s, tag: tag);
        }
      }

      if (!fileExist) {
        MyPrint.printOnConsole("Creating File", tag: tag);
        try {
          file = await file.create(recursive: true);
          MyPrint.printOnConsole("File Created", tag: tag);
        } catch (e, s) {
          MyPrint.printOnConsole("Error in Creating File in EventTrackController().saveBytesInFile2():$e", tag: tag);
          MyPrint.printOnConsole(s, tag: tag);
        }

        /*fileExist = await file.exists();
        MyPrint.printOnConsole("fileExist after creation:$fileExist", tag: tag);
        if (!fileExist) {
          MyPrint.printOnConsole("Returning from EventTrackController().getDownloadsDirectoryPath() because couldn't create download file", tag: tag);
          return false;
        }*/
      }

      MyPrint.printOnConsole("Writing in File", tag: tag);
      await file.open(mode: FileMode.write);
      file = await file.writeAsBytes(bytes);

      return true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in EventTrackController().saveBytesInFile2():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return false;
    }
  }
//endregion
}
