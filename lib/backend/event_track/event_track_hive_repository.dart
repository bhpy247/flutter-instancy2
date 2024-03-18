import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/api/api_url_configuration_provider.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/event_track_header_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/event_track_tab_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/related_track_data_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/track_course_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/track_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/response_model/resource_content_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/response_model/track_list_view_data_response_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/hive_manager.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:hive/hive.dart';

class EventTrackHiveRepository {
  final ApiController apiController;
  static EventTrackHiveRepository? _instance;

  factory EventTrackHiveRepository({required ApiController apiController}) {
    _instance ??= EventTrackHiveRepository._(apiController: apiController);
    return _instance!;
  }

  EventTrackHiveRepository._({required this.apiController});

  static const String eventTrackScreenHeaderDataBox = "eventTrackScreenHeaderDataBox";
  static const String eventTrackScreenTabDataBox = "eventTrackScreenTabDataBox";
  static const String trackContentModelsBox = "trackContentModelsBox";
  static const String trackAssignmentModelsBox = "trackAssignmentModelsBox";
  static const String eventRelatedContentModelsBox = "eventRelatedContentModelsBox";
  static const String eventRelatedAssignmentModelsBox = "eventRelatedAssignmentModelsBox";

  //Type: Map<String, EventTrackHeaderDTOModel>
  Box? _eventTrackScreenHeaderDataBox;

  //Type: Map<String, List<EventTrackTabDTOModel>>
  Box? _eventTrackScreenTabDataBox;

  //Type: Map<String, TrackListViewDataResponseModel>
  Box? _trackContentModelsBox;

  //Type: Map<String, TrackListViewDataResponseModel>
  Box? _trackAssignmentModelsBox;

  //Type: Map<String, ResourceContentDTOModel>
  Box? _eventRelatedContentModelsBox;

  //Type: Map<String, ResourceContentDTOModel>
  Box? _eventRelatedAssignmentModelsBox;

  //region Box Initialization Operations
  // region EventTrackScreenHeaderDataBox
  Future<Box?> initializeEventTrackScreenHeaderDataBox({required String currentSiteUrl, required int userId, bool isForceInitialize = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MainHiveController().initializeEventTrackScreenHeaderDataBox() called with currentSiteUrl:'$currentSiteUrl', userId:$userId, isForceInitialize:$isForceInitialize",
        tag: tag);

    String host = MyUtils.getHostNameFromSiteUrl(currentSiteUrl);
    MyPrint.printOnConsole("host:$host", tag: tag);

    if (isForceInitialize || _eventTrackScreenHeaderDataBox == null) {
      await closeEventTrackScreenHeaderDataBox();
      if (host.isNotEmpty && userId > 0) {
        String boxName = "${eventTrackScreenHeaderDataBox}_${host}_$userId";
        _eventTrackScreenHeaderDataBox ??= await HiveManager().openBox(boxName: boxName);
      }
    }

    MyPrint.printOnConsole("BoxName:${_eventTrackScreenHeaderDataBox?.name}", tag: tag);

    return _eventTrackScreenHeaderDataBox;
  }

  Future<void> clearEventTrackScreenHeaderDataBox() async {
    MyPrint.printOnConsole("MainHiveController().clearEventTrackScreenHeaderDataBox() called");

    await _eventTrackScreenHeaderDataBox?.clear();
  }

  Future<void> closeEventTrackScreenHeaderDataBox() async {
    MyPrint.printOnConsole("MainHiveController().closeEventTrackScreenHeaderDataBox() called");

    await _eventTrackScreenHeaderDataBox?.close();
    _eventTrackScreenHeaderDataBox = null;
  }

  // endregion

  // region EventTrackScreenTabDataBox
  Future<Box?> initializeEventTrackScreenTabDataBox({required String currentSiteUrl, required int userId, bool isForceInitialize = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MainHiveController().initializeEventTrackScreenTabDataBox() called with currentSiteUrl:'$currentSiteUrl', userId:$userId, isForceInitialize:$isForceInitialize", tag: tag);

    String host = MyUtils.getHostNameFromSiteUrl(currentSiteUrl);
    MyPrint.printOnConsole("host:$host", tag: tag);

    if (isForceInitialize || _eventTrackScreenTabDataBox == null) {
      await closeEventTrackScreenTabDataBox();
      if (host.isNotEmpty && userId > 0) {
        String boxName = "${eventTrackScreenTabDataBox}_${host}_$userId";
        _eventTrackScreenTabDataBox ??= await HiveManager().openBox(boxName: boxName);
      }
    }

    MyPrint.printOnConsole("BoxName:${_eventTrackScreenTabDataBox?.name}", tag: tag);

    return _eventTrackScreenTabDataBox;
  }

  Future<void> clearEventTrackScreenTabDataBox() async {
    MyPrint.printOnConsole("MainHiveController().clearEventTrackScreenTabDataBox() called");

    await _eventTrackScreenTabDataBox?.clear();
  }

  Future<void> closeEventTrackScreenTabDataBox() async {
    MyPrint.printOnConsole("MainHiveController().closeEventTrackScreenTabDataBox() called");

    await _eventTrackScreenTabDataBox?.close();
    _eventTrackScreenTabDataBox = null;
  }

  // endregion

  // region TrackContentModelsBox
  Future<Box?> initializeTrackContentModelsBox({required String currentSiteUrl, required int userId, bool isForceInitialize = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MainHiveController().initializeTrackContentModelsBox() called with currentSiteUrl:'$currentSiteUrl', userId:$userId, isForceInitialize:$isForceInitialize", tag: tag);

    String host = MyUtils.getHostNameFromSiteUrl(currentSiteUrl);
    MyPrint.printOnConsole("host:$host", tag: tag);

    if (isForceInitialize || _trackContentModelsBox == null) {
      await closeTrackContentModelsBox();
      if (host.isNotEmpty && userId > 0) {
        String boxName = "${trackContentModelsBox}_${host}_$userId";
        _trackContentModelsBox ??= await HiveManager().openBox(boxName: boxName);
      }
    }

    MyPrint.printOnConsole("BoxName:${_trackContentModelsBox?.name}", tag: tag);

    return _trackContentModelsBox;
  }

  Future<void> clearTrackContentModelsBox() async {
    MyPrint.printOnConsole("MainHiveController().clearTrackContentModelsBox() called");

    await _trackContentModelsBox?.clear();
  }

  Future<void> closeTrackContentModelsBox() async {
    MyPrint.printOnConsole("MainHiveController().closeTrackContentModelsBox() called");

    await _trackContentModelsBox?.close();
    _trackContentModelsBox = null;
  }

// endregion

  // region TrackAssignmentModelsBox
  Future<Box?> initializeTrackAssignmentModelsBox({required String currentSiteUrl, required int userId, bool isForceInitialize = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MainHiveController().initializeTrackAssignmentModelsBox() called with currentSiteUrl:'$currentSiteUrl', userId:$userId, isForceInitialize:$isForceInitialize", tag: tag);

    String host = MyUtils.getHostNameFromSiteUrl(currentSiteUrl);
    MyPrint.printOnConsole("host:$host", tag: tag);

    if (isForceInitialize || _trackAssignmentModelsBox == null) {
      await closeTrackAssignmentModelsBox();
      if (host.isNotEmpty && userId > 0) {
        String boxName = "${trackAssignmentModelsBox}_${host}_$userId";
        _trackAssignmentModelsBox ??= await HiveManager().openBox(boxName: boxName);
      }
    }

    MyPrint.printOnConsole("BoxName:${_trackAssignmentModelsBox?.name}", tag: tag);

    return _trackAssignmentModelsBox;
  }

  Future<void> clearTrackAssignmentModelsBox() async {
    MyPrint.printOnConsole("MainHiveController().clearTrackAssignmentModelsBox() called");

    await _trackAssignmentModelsBox?.clear();
  }

  Future<void> closeTrackAssignmentModelsBox() async {
    MyPrint.printOnConsole("MainHiveController().closeTrackAssignmentModelsBox() called");

    await _trackAssignmentModelsBox?.close();
    _trackAssignmentModelsBox = null;
  }

// endregion

  // region EventRelatedContentModelsBox
  Future<Box?> initializeEventRelatedContentModelsBox({required String currentSiteUrl, required int userId, bool isForceInitialize = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MainHiveController().initializeEventRelatedContentModelsBox() called with currentSiteUrl:'$currentSiteUrl', userId:$userId, isForceInitialize:$isForceInitialize",
        tag: tag);

    String host = MyUtils.getHostNameFromSiteUrl(currentSiteUrl);
    MyPrint.printOnConsole("host:$host", tag: tag);

    if (isForceInitialize || _eventRelatedContentModelsBox == null) {
      await closeEventRelatedContentModelsBox();
      if (host.isNotEmpty && userId > 0) {
        String boxName = "${eventRelatedContentModelsBox}_${host}_$userId";
        _eventRelatedContentModelsBox ??= await HiveManager().openBox(boxName: boxName);
      }
    }

    MyPrint.printOnConsole("BoxName:${_eventRelatedContentModelsBox?.name}", tag: tag);

    return _eventRelatedContentModelsBox;
  }

  Future<void> clearEventRelatedContentModelsBox() async {
    MyPrint.printOnConsole("MainHiveController().clearEventRelatedContentModelsBox() called");

    await _eventRelatedContentModelsBox?.clear();
  }

  Future<void> closeEventRelatedContentModelsBox() async {
    MyPrint.printOnConsole("MainHiveController().closeEventRelatedContentModelsBox() called");

    await _eventRelatedContentModelsBox?.close();
    _eventRelatedContentModelsBox = null;
  }

// endregion

  // region EventRelatedAssignmentModelsBox
  Future<Box?> initializeEventRelatedAssignmentModelsBox({required String currentSiteUrl, required int userId, bool isForceInitialize = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MainHiveController().initializeEventRelatedAssignmentModelsBox() called with currentSiteUrl:'$currentSiteUrl', userId:$userId, isForceInitialize:$isForceInitialize",
        tag: tag);

    String host = MyUtils.getHostNameFromSiteUrl(currentSiteUrl);
    MyPrint.printOnConsole("host:$host", tag: tag);

    if (isForceInitialize || _eventRelatedAssignmentModelsBox == null) {
      await closeEventRelatedAssignmentModelsBox();
      if (host.isNotEmpty && userId > 0) {
        String boxName = "${eventRelatedAssignmentModelsBox}_${host}_$userId";
        _eventRelatedAssignmentModelsBox ??= await HiveManager().openBox(boxName: boxName);
      }
    }

    MyPrint.printOnConsole("BoxName:${_eventRelatedAssignmentModelsBox?.name}", tag: tag);

    return _eventRelatedAssignmentModelsBox;
  }

  Future<void> clearEventRelatedAssignmentModelsBox() async {
    MyPrint.printOnConsole("MainHiveController().clearEventRelatedAssignmentModelsBox() called");

    await _eventRelatedAssignmentModelsBox?.clear();
  }

  Future<void> closeEventRelatedAssignmentModelsBox() async {
    MyPrint.printOnConsole("MainHiveController().closeEventRelatedAssignmentModelsBox() called");

    await _eventRelatedAssignmentModelsBox?.close();
    _eventRelatedAssignmentModelsBox = null;
  }

// endregion
// endregion

  //region EventTrackScreenHeaderData
  Future<EventTrackHeaderDTOModel?> getEventTrackHeaderDTOModelById({required String eventTrackContentId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineRepository().getEventTrackHeaderDTOModelById() called with eventTrackContentId:$eventTrackContentId", tag: tag);

    EventTrackHeaderDTOModel? eventTrackHeaderDTOModel;

    if (eventTrackContentId.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().getEventTrackHeaderDTOModelById() because eventTrackContentId is empty", tag: tag);
      return eventTrackHeaderDTOModel;
    }

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    Box<dynamic>? box = await initializeEventTrackScreenHeaderDataBox(
      currentSiteUrl: apiUrlConfigurationProvider.getCurrentSiteUrl(),
      userId: apiUrlConfigurationProvider.getCurrentUserId(),
    );

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().getEventTrackHeaderDTOModelById() because box is null", tag: tag);
      return eventTrackHeaderDTOModel;
    }

    try {
      Map<String, dynamic> headerDTOModelMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(box.get(eventTrackContentId));
      if (headerDTOModelMap.isNotEmpty) {
        eventTrackHeaderDTOModel = EventTrackHeaderDTOModel.fromJson(headerDTOModelMap);
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseOfflineRepository().getEventTrackHeaderDTOModelById():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    MyPrint.printOnConsole("Final eventTrackHeaderDTOModel is not null:${eventTrackHeaderDTOModel != null}", tag: tag);

    return eventTrackHeaderDTOModel;
  }

  Future<bool> addEventTrackHeaderDTOModelInBox({required Map<String, EventTrackHeaderDTOModel> headerData, bool isClear = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineRepository().addEventTrackHeaderDTOModelInBox() called with headerData of length:${headerData.length}", tag: tag);

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    Box<dynamic>? box = await initializeEventTrackScreenHeaderDataBox(
      currentSiteUrl: apiUrlConfigurationProvider.getCurrentSiteUrl(),
      userId: apiUrlConfigurationProvider.getCurrentUserId(),
    );

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().addEventTrackHeaderDTOModelInBox() because box is null", tag: tag);
      return false;
    }

    try {
      if (isClear) box.clear();
      await box.putAll(headerData.map((key, value) => MapEntry(key, value.toJson())));

      MyPrint.printOnConsole("Added EventTrackHeaderDTOModels Successfully In Hive", tag: tag);

      return true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseOfflineRepository().addEventTrackHeaderDTOModelInBox():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return false;
    }
  }

  Future<bool> removeRecordsFromEventTrackScreenHeaderDataBoxById({required List<String> eventTrackContentIds}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineRepository().removeRecordsFromEventTrackScreenHeaderDataBoxById() called with eventTrackContentIds:$eventTrackContentIds", tag: tag);

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    Box<dynamic>? box = await initializeEventTrackScreenHeaderDataBox(
      currentSiteUrl: apiUrlConfigurationProvider.getCurrentSiteUrl(),
      userId: apiUrlConfigurationProvider.getCurrentUserId(),
    );

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().removeRecordsFromEventTrackScreenHeaderDataBoxById() because box is null", tag: tag);
      return false;
    }

    try {
      await box.deleteAll(eventTrackContentIds);

      MyPrint.printOnConsole("Removed EventTrackHeaderDTOModels Successfully From Hive", tag: tag);

      return true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseOfflineRepository().removeRecordsFromEventTrackScreenHeaderDataBoxById():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return false;
    }
  }

//endregion

  //region EventTrackScreenTabData
  Future<List<EventTrackTabDTOModel>> getTabsListFromEventTrackContentId({required String eventTrackContentId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineRepository().getTabsListFromEventTrackContentId() called with eventTrackContentId:$eventTrackContentId", tag: tag);

    List<EventTrackTabDTOModel> tabsList = <EventTrackTabDTOModel>[];

    if (eventTrackContentId.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().getTabsListFromEventTrackContentId() because eventTrackContentId is empty", tag: tag);
      return tabsList;
    }

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    Box<dynamic>? box = await initializeEventTrackScreenTabDataBox(
      currentSiteUrl: apiUrlConfigurationProvider.getCurrentSiteUrl(),
      userId: apiUrlConfigurationProvider.getCurrentUserId(),
    );

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().getTabsListFromEventTrackContentId() because box is null", tag: tag);
      return tabsList;
    }

    try {
      List<Map<String, dynamic>> tabMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(box.get(eventTrackContentId));
      for (Map<String, dynamic> tabMap in tabMapsList) {
        if (tabMap.isNotEmpty) {
          tabsList.add(EventTrackTabDTOModel.fromJson(tabMap));
        }
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseOfflineRepository().getTabsListFromEventTrackContentId():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    MyPrint.printOnConsole("Final TabsList length:${tabsList.length}", tag: tag);

    return tabsList;
  }

  Future<bool> setTabListForEventTrackContentId({required String eventTrackContentId, required List<EventTrackTabDTOModel> tabsList}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineRepository().setTabListForEventTrackContentId() called with eventTrackContentId:'$eventTrackContentId', tabsList of length:${tabsList.length}", tag: tag);

    if (eventTrackContentId.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().setTabListForEventTrackContentId() because eventTrackContentId is empty", tag: tag);
      return false;
    }

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    Box<dynamic>? box = await initializeEventTrackScreenTabDataBox(
      currentSiteUrl: apiUrlConfigurationProvider.getCurrentSiteUrl(),
      userId: apiUrlConfigurationProvider.getCurrentUserId(),
    );

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().setTabListForEventTrackContentId() because box is null", tag: tag);
      return false;
    }

    try {
      await box.put(eventTrackContentId, tabsList.map((e) => e.toJson()).toList());

      MyPrint.printOnConsole("Added TabsList Successfully In Hive", tag: tag);

      return true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseOfflineRepository().setTabListForEventTrackContentId():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return false;
    }
  }

  Future<bool> removeTabListForEventTrackContentIds({required List<String> eventTrackContentIds}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineRepository().removeTabListForEventTrackContentIds() called with eventTrackContentIds:$eventTrackContentIds", tag: tag);

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    Box<dynamic>? box = await initializeEventTrackScreenTabDataBox(
      currentSiteUrl: apiUrlConfigurationProvider.getCurrentSiteUrl(),
      userId: apiUrlConfigurationProvider.getCurrentUserId(),
    );

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().removeTabListForEventTrackContentIds() because box is null", tag: tag);
      return false;
    }

    try {
      await box.deleteAll(eventTrackContentIds);

      MyPrint.printOnConsole("Removed EventTrackHeaderDTOModels Successfully From Hive", tag: tag);

      return true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseOfflineRepository().removeTabListForEventTrackContentIds():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return false;
    }
  }

//endregion

  //region TrackContentModelsBox
  Future<TrackListViewDataResponseModel?> getTrackContentDataForTrackId({required String trackId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineRepository().getTrackContentDataForTrackId() called with trackId:$trackId", tag: tag);

    if (trackId.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().getTrackContentDataForTrackId() because trackId is empty", tag: tag);
      return null;
    }

    TrackListViewDataResponseModel? trackListViewDTOModel;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    Box<dynamic>? box = await initializeTrackContentModelsBox(
      currentSiteUrl: apiUrlConfigurationProvider.getCurrentSiteUrl(),
      userId: apiUrlConfigurationProvider.getCurrentUserId(),
    );

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().getTrackContentDataForTrackId() because box is null", tag: tag);
      return trackListViewDTOModel;
    }

    try {
      Map<String, dynamic> trackContentModelMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(box.get(trackId));
      if (trackContentModelMap.isNotEmpty) {
        trackListViewDTOModel = TrackListViewDataResponseModel.fromMap(trackContentModelMap);
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseOfflineRepository().getTrackContentDataForTrackId():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    MyPrint.printOnConsole("Final trackListViewDTOModel not null:${trackListViewDTOModel != null}", tag: tag);

    return trackListViewDTOModel;
  }

  Future<bool> addTrackContentsDataInBox({required Map<String, TrackListViewDataResponseModel> trackContentData, bool isClear = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineRepository().addTrackContentsDataInBox() called with trackContentData of length:${trackContentData.length}", tag: tag);

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    Box<dynamic>? box = await initializeTrackContentModelsBox(
      currentSiteUrl: apiUrlConfigurationProvider.getCurrentSiteUrl(),
      userId: apiUrlConfigurationProvider.getCurrentUserId(),
    );

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().addTrackContentsDataInBox() because box is null", tag: tag);
      return false;
    }

    try {
      if (isClear) box.clear();
      await box.putAll(trackContentData.map((key, value) => MapEntry(key, value.toMap())));

      MyPrint.printOnConsole("Added TrackListViewDataResponseModels Successfully In Hive", tag: tag);

      return true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseOfflineRepository().addTrackContentsDataInBox():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return false;
    }
  }

  Future<bool> removeRecordsFromTrackContentsDataBoxById({required List<String> trackIds}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineRepository().removeRecordsFromTrackContentsDataBoxById() called with trackIds:$trackIds", tag: tag);

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    Box<dynamic>? box = await initializeTrackContentModelsBox(
      currentSiteUrl: apiUrlConfigurationProvider.getCurrentSiteUrl(),
      userId: apiUrlConfigurationProvider.getCurrentUserId(),
    );

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().removeRecordsFromTrackContentsDataBoxById() because box is null", tag: tag);
      return false;
    }

    try {
      await box.deleteAll(trackIds);

      MyPrint.printOnConsole("Removed TrackListViewDataResponseModels Successfully From Hive", tag: tag);

      return true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseOfflineRepository().removeRecordsFromTrackContentsDataBoxById():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return false;
    }
  }

//endregion

  //region TrackAssignmentModelsBox
  Future<TrackListViewDataResponseModel?> getTrackAssignmentDataForTrackId({required String trackId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineRepository().getTrackAssignmentDataForTrackId() called with trackId:$trackId", tag: tag);

    if (trackId.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().getTrackAssignmentDataForTrackId() because trackId is empty", tag: tag);
      return null;
    }

    TrackListViewDataResponseModel? trackListViewDTOModel;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    Box<dynamic>? box = await initializeTrackAssignmentModelsBox(
      currentSiteUrl: apiUrlConfigurationProvider.getCurrentSiteUrl(),
      userId: apiUrlConfigurationProvider.getCurrentUserId(),
    );

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().getTrackAssignmentDataForTrackId() because box is null", tag: tag);
      return trackListViewDTOModel;
    }

    try {
      Map<String, dynamic> trackContentModelMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(box.get(trackId));
      if (trackContentModelMap.isNotEmpty) {
        trackListViewDTOModel = TrackListViewDataResponseModel.fromMap(trackContentModelMap);
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseOfflineRepository().getTrackAssignmentDataForTrackId():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    MyPrint.printOnConsole("Final trackListViewDTOModel not null:${trackListViewDTOModel != null}", tag: tag);

    return trackListViewDTOModel;
  }

  Future<bool> addTrackAssignmentDataInBox({required Map<String, TrackListViewDataResponseModel> trackContentData, bool isClear = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineRepository().addTrackAssignmentDataInBox() called with trackContentData of length:${trackContentData.length}", tag: tag);

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    Box<dynamic>? box = await initializeTrackAssignmentModelsBox(
      currentSiteUrl: apiUrlConfigurationProvider.getCurrentSiteUrl(),
      userId: apiUrlConfigurationProvider.getCurrentUserId(),
    );

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().addTrackAssignmentDataInBox() because box is null", tag: tag);
      return false;
    }

    try {
      if (isClear) box.clear();
      await box.putAll(trackContentData.map((key, value) => MapEntry(key, value.toMap())));

      MyPrint.printOnConsole("Added TrackListViewDataResponseModels Successfully In Hive", tag: tag);

      return true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseOfflineRepository().addTrackAssignmentDataInBox():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return false;
    }
  }

  Future<bool> removeRecordsFromTrackAssignmentsDataBoxById({required List<String> trackIds}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineRepository().removeRecordsFromTrackAssignmentsDataBoxById() called with trackIds:$trackIds", tag: tag);

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    Box<dynamic>? box = await initializeTrackAssignmentModelsBox(
      currentSiteUrl: apiUrlConfigurationProvider.getCurrentSiteUrl(),
      userId: apiUrlConfigurationProvider.getCurrentUserId(),
    );

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().removeRecordsFromTrackAssignmentsDataBoxById() because box is null", tag: tag);
      return false;
    }

    try {
      await box.deleteAll(trackIds);

      MyPrint.printOnConsole("Removed TrackListViewDataResponseModels Successfully From Hive", tag: tag);

      return true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseOfflineRepository().removeRecordsFromTrackAssignmentsDataBoxById():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return false;
    }
  }

//endregion

  //region EventContentModelsBox
  Future<ResourceContentDTOModel?> getEventRelatedContentDataForEventId({required String eventId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineRepository().getEventRelatedContentDataForEventId() called with eventId:$eventId", tag: tag);

    if (eventId.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().getEventRelatedContentDataForEventId() because eventId is empty", tag: tag);
      return null;
    }

    ResourceContentDTOModel? resourceContentDTOModel;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    Box<dynamic>? box = await initializeEventRelatedContentModelsBox(
      currentSiteUrl: apiUrlConfigurationProvider.getCurrentSiteUrl(),
      userId: apiUrlConfigurationProvider.getCurrentUserId(),
    );

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().getEventRelatedContentDataForEventId() because box is null", tag: tag);
      return resourceContentDTOModel;
    }

    try {
      Map<String, dynamic> eventRelatedContentsModelMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(box.get(eventId));
      if (eventRelatedContentsModelMap.isNotEmpty) {
        resourceContentDTOModel = ResourceContentDTOModel.fromMap(eventRelatedContentsModelMap);
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseOfflineRepository().getEventRelatedContentDataForEventId():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    MyPrint.printOnConsole("Final ResourceContentDTOModelMap not null:${resourceContentDTOModel != null}", tag: tag);

    return resourceContentDTOModel;
  }

  Future<bool> addEventRelatedContentDataInBox({required Map<String, ResourceContentDTOModel> eventRelatedContentData, bool isClear = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineRepository().addEventRelatedContentDataInBox() called with eventRelatedContentData of length:${eventRelatedContentData.length}", tag: tag);

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    Box<dynamic>? box = await initializeEventRelatedContentModelsBox(
      currentSiteUrl: apiUrlConfigurationProvider.getCurrentSiteUrl(),
      userId: apiUrlConfigurationProvider.getCurrentUserId(),
    );

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().addEventRelatedContentDataInBox() because box is null", tag: tag);
      return false;
    }

    try {
      if (isClear) box.clear();
      await box.putAll(eventRelatedContentData.map((key, value) => MapEntry(key, value.toMap())));

      MyPrint.printOnConsole("Added ResourceContentDTOModels Successfully In Hive", tag: tag);

      return true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseOfflineRepository().addEventRelatedContentDataInBox():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return false;
    }
  }

  Future<bool> removeRecordsFromEventRelatedContentModelsBoxById({required List<String> eventIds}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineRepository().removeRecordsFromEventRelatedContentModelsBoxById() called with eventIds:$eventIds", tag: tag);

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    Box<dynamic>? box = await initializeEventRelatedContentModelsBox(
      currentSiteUrl: apiUrlConfigurationProvider.getCurrentSiteUrl(),
      userId: apiUrlConfigurationProvider.getCurrentUserId(),
    );

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().removeRecordsFromEventRelatedContentModelsBoxById() because box is null", tag: tag);
      return false;
    }

    try {
      await box.deleteAll(eventIds);

      MyPrint.printOnConsole("Removed ResourceContentDTOModels Successfully From Hive", tag: tag);

      return true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseOfflineRepository().removeRecordsFromEventRelatedContentModelsBoxById():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return false;
    }
  }

//endregion

  //region EventAssignmentModelsBox
  Future<ResourceContentDTOModel?> getEventRelatedAssignmentDataForEventId({required String eventId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineRepository().getEventRelatedAssignmentDataForEventId() called with eventId:$eventId", tag: tag);

    if (eventId.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().getEventRelatedAssignmentDataForEventId() because eventId is empty", tag: tag);
      return null;
    }

    ResourceContentDTOModel? resourceContentDTOModel;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    Box<dynamic>? box = await initializeEventRelatedAssignmentModelsBox(
      currentSiteUrl: apiUrlConfigurationProvider.getCurrentSiteUrl(),
      userId: apiUrlConfigurationProvider.getCurrentUserId(),
    );

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().getEventRelatedAssignmentDataForEventId() because box is null", tag: tag);
      return resourceContentDTOModel;
    }

    try {
      Map<String, dynamic> eventRelatedContentsModelMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(box.get(eventId));
      if (eventRelatedContentsModelMap.isNotEmpty) {
        resourceContentDTOModel = ResourceContentDTOModel.fromMap(eventRelatedContentsModelMap);
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseOfflineRepository().getEventRelatedAssignmentDataForEventId():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    MyPrint.printOnConsole("Final ResourceContentDTOModelMap not null:${resourceContentDTOModel != null}", tag: tag);

    return resourceContentDTOModel;
  }

  Future<bool> addEventRelatedAssignmentDataInBox({required Map<String, ResourceContentDTOModel> eventRelatedContentData, bool isClear = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineRepository().addEventRelatedAssignmentDataInBox() called with eventRelatedContentData of length:${eventRelatedContentData.length}", tag: tag);

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    Box<dynamic>? box = await initializeEventRelatedAssignmentModelsBox(
      currentSiteUrl: apiUrlConfigurationProvider.getCurrentSiteUrl(),
      userId: apiUrlConfigurationProvider.getCurrentUserId(),
    );

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().addEventRelatedAssignmentDataInBox() because box is null", tag: tag);
      return false;
    }

    try {
      if (isClear) box.clear();
      await box.putAll(eventRelatedContentData.map((key, value) => MapEntry(key, value.toMap())));

      MyPrint.printOnConsole("Added ResourceContentDTOModels Successfully In Hive", tag: tag);

      return true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseOfflineRepository().addEventRelatedAssignmentDataInBox():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return false;
    }
  }

  Future<bool> removeRecordsFromEventRelatedAssignmentModelsBoxById({required List<String> eventIds}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineRepository().removeRecordsFromEventRelatedAssignmentModelsBoxById() called with eventIds:$eventIds", tag: tag);

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    Box<dynamic>? box = await initializeEventRelatedAssignmentModelsBox(
      currentSiteUrl: apiUrlConfigurationProvider.getCurrentSiteUrl(),
      userId: apiUrlConfigurationProvider.getCurrentUserId(),
    );

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().removeRecordsFromEventRelatedAssignmentModelsBoxById() because box is null", tag: tag);
      return false;
    }

    try {
      await box.deleteAll(eventIds);

      MyPrint.printOnConsole("Removed ResourceContentDTOModels Successfully From Hive", tag: tag);

      return true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseOfflineRepository().removeRecordsFromEventRelatedAssignmentModelsBoxById():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return false;
    }
  }

//endregion

  // region Other Operations
  Future<bool> updateContentProgressDataForTrackEventRelatedContent({
    required String parentEventTrackContentId,
    required String childContentId,
    required bool isTrackContent,
    String? displayStatus,
    String? coreLessonStatus,
    double? courseProgress,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
      "CourseOfflineRepository().updateContentProgressDataForTrackEventRelatedContent() called with parentEventTrackContentId:$parentEventTrackContentId, childContentId:$childContentId, "
      "isTrackContent:$isTrackContent, displayStatus:'$displayStatus', coreLessonStatus:'$coreLessonStatus', courseProgress:'$courseProgress'",
      tag: tag,
    );

    bool isUpdatedTrackDownloadDataInHive = false;

    if (isTrackContent) {
      MyPrint.printOnConsole("Updating Content Progress in Track Tab Offline Data", tag: tag);

      TrackListViewDataResponseModel? responseModel = await getTrackContentDataForTrackId(trackId: parentEventTrackContentId);
      if (responseModel == null) {
        MyPrint.printOnConsole("Error in Updating Content Progress in Track Tab Offline Data because data not exist in Offline", tag: tag);
        return false;
      }

      List<TrackDTOModel> list = responseModel.TrackListData.where((element) {
        return element.TrackList.where((element) => element.ContentID == childContentId).toList().isNotEmpty;
      }).toList();
      TrackCourseDTOModel? finalTrackCourseDTOModel = list.firstElement?.TrackList.where((element) => element.ContentID == childContentId).toList().firstElement;

      if (finalTrackCourseDTOModel == null) {
        MyPrint.printOnConsole(
          "Error in Updating Content Progress in Track Tab Offline Data because content model with id ${childContentId} not exist in Track Data Offline",
          tag: tag,
        );
        return false;
      }

      MyPrint.printOnConsole("Got Content Model, Updating Content Progress in Track Tab Offline Data", tag: tag);

      if (coreLessonStatus != null) finalTrackCourseDTOModel.CoreLessonStatus = coreLessonStatus;
      if (displayStatus != null) finalTrackCourseDTOModel.ContentStatus = displayStatus;
      if (courseProgress != null) finalTrackCourseDTOModel.ContentProgress = courseProgress.toString();

      isUpdatedTrackDownloadDataInHive = await addTrackContentsDataInBox(trackContentData: {parentEventTrackContentId: responseModel}, isClear: false);

      MyPrint.printOnConsole("Updated Track Content Model in Track Tab Offline Data:$isUpdatedTrackDownloadDataInHive", tag: tag);
    } else {
      MyPrint.printOnConsole("Updating Content Progress in Event Tab Offline Data", tag: tag);

      ResourceContentDTOModel? responseModel = await getEventRelatedContentDataForEventId(eventId: parentEventTrackContentId);
      if (responseModel == null) {
        MyPrint.printOnConsole("Error in Updating Content Progress in Event Tab Offline Data because data not exist in Offline", tag: tag);
        return false;
      }

      RelatedTrackDataDTOModel? finalRelatedTrackDataDTOModel = responseModel.ResouseList.where((element) {
        return element.ContentID == childContentId;
      }).toList().firstElement;

      if (finalRelatedTrackDataDTOModel == null) {
        MyPrint.printOnConsole(
          "Error in Updating Content Progress in Event Tab Offline Data because content model with id ${childContentId} not exist in Event Data Offline",
          tag: tag,
        );
        return false;
      }

      MyPrint.printOnConsole("Got Content Model, Updating Content Progress in Event Tab Offline Data", tag: tag);

      if (coreLessonStatus != null) finalRelatedTrackDataDTOModel.CoreLessonStatus = coreLessonStatus;
      if (displayStatus != null) finalRelatedTrackDataDTOModel.ContentDisplayStatus = displayStatus;
      if (courseProgress != null) finalRelatedTrackDataDTOModel.PercentCompleted = courseProgress;

      isUpdatedTrackDownloadDataInHive = await addEventRelatedContentDataInBox(eventRelatedContentData: {parentEventTrackContentId: responseModel}, isClear: false);

      MyPrint.printOnConsole("Updated Track Content Model in Event Tab Offline Data:$isUpdatedTrackDownloadDataInHive", tag: tag);
    }

    return isUpdatedTrackDownloadDataInHive;
  }
// endregion
}
