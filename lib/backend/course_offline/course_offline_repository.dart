import 'package:flutter_instancy_2/api/api_call_model.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/api/api_endpoints.dart';
import 'package:flutter_instancy_2/api/api_url_configuration_provider.dart';
import 'package:flutter_instancy_2/api/rest_client.dart';
import 'package:flutter_instancy_2/models/common/data_response_model.dart';
import 'package:flutter_instancy_2/models/common/model_data_parser.dart';
import 'package:flutter_instancy_2/models/course_offline/data_model/cmi_model.dart';
import 'package:flutter_instancy_2/models/course_offline/request_model/get_course_tracking_data_request_model.dart';
import 'package:flutter_instancy_2/models/course_offline/response_model/course_learner_session_response_model.dart';
import 'package:flutter_instancy_2/models/course_offline/response_model/get_course_tracking_data_response_model.dart';
import 'package:flutter_instancy_2/models/course_offline/response_model/student_course_response_model.dart';
import 'package:flutter_instancy_2/utils/hive_manager.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/views/course_offline/request_model/update_offline_tracked_data_request_model.dart';
import 'package:hive/hive.dart';

class CourseOfflineRepository {
  static final CourseOfflineRepository _instance = CourseOfflineRepository._();

  factory CourseOfflineRepository() => _instance;

  CourseOfflineRepository._();

  static const String cmiBox = "cmiBox";
  static const String learnerSessionBox = "learnerSessionBox";
  static const String studentResponseBox = "studentResponseBox";
  final ApiController apiController = ApiController();

  Box? _cmiDataBox;
  Box? _learnerSessionBox;
  Box? _studentResponseBox;

  //region Box Initialization Operations
  // region CmiDataBox
  Future<Box?> initializeCmiDataBox({bool isForceInitialize = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineRepository().initializeCmiDataBox() called with isForceInitialize:$isForceInitialize", tag: tag);

    if (isForceInitialize || _cmiDataBox == null) {
      await closeCmiDataBox();
      String boxName = cmiBox;
      _cmiDataBox ??= await HiveManager().openBox(boxName: boxName);
    }

    MyPrint.printOnConsole("BoxName:${_cmiDataBox?.name}", tag: tag);

    return _cmiDataBox;
  }

  Future<void> clearCmiDataBox() async {
    MyPrint.printOnConsole("CourseOfflineRepository().clearCmiDataBox() called");

    await _cmiDataBox?.clear();
  }

  Future<void> closeCmiDataBox() async {
    MyPrint.printOnConsole("CourseOfflineRepository().closeCmiDataBox() called");

    await _cmiDataBox?.close();
    _cmiDataBox = null;
  }

// endregion

  // region LearnerSessionBox
  Future<Box?> initializeLearnerSessionBox({bool isForceInitialize = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineRepository().initializeLearnerSessionBox() called with isForceInitialize:$isForceInitialize", tag: tag);

    if (isForceInitialize || _learnerSessionBox == null) {
      await closeLearnerSessionBox();
      String boxName = learnerSessionBox;
      _learnerSessionBox ??= await HiveManager().openBox(boxName: boxName);
    }

    MyPrint.printOnConsole("BoxName:${_learnerSessionBox?.name}", tag: tag);

    return _learnerSessionBox;
  }

  Future<void> clearLearnerSessionBox() async {
    MyPrint.printOnConsole("CourseOfflineRepository().clearLearnerSessionBox() called");

    await _learnerSessionBox?.clear();
  }

  Future<void> closeLearnerSessionBox() async {
    MyPrint.printOnConsole("CourseOfflineRepository().closeLearnerSessionBox() called");

    await _learnerSessionBox?.close();
    _learnerSessionBox = null;
  }

// endregion

  // region StudentResponseBox
  Future<Box?> initializeStudentResponseBox({bool isForceInitialize = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineRepository().initializeStudentResponseBox() called with isForceInitialize:$isForceInitialize", tag: tag);

    if (isForceInitialize || _studentResponseBox == null) {
      await closeStudentResponseBox();
      String boxName = studentResponseBox;
      _studentResponseBox ??= await HiveManager().openBox(boxName: boxName);
    }

    MyPrint.printOnConsole("BoxName:${_studentResponseBox?.name}", tag: tag);

    return _studentResponseBox;
  }

  Future<void> clearStudentResponseBox() async {
    MyPrint.printOnConsole("CourseOfflineRepository().clearStudentResponseBox() called");

    await _studentResponseBox?.clear();
  }

  Future<void> closeStudentResponseBox() async {
    MyPrint.printOnConsole("CourseOfflineRepository().closeStudentResponseBox() called");

    await _studentResponseBox?.close();
    _studentResponseBox = null;
  }

// endregion
//endregion

  //region Cmi
  Future<Map<String, CMIModel>> getAllCmiModels() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineRepository().getAllCmiModels() called", tag: tag);

    Map<String, CMIModel> cmiModelsMap = <String, CMIModel>{};

    Box<dynamic>? box = await initializeCmiDataBox();

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().getAllCmiModels() because box is null", tag: tag);
      return cmiModelsMap;
    }

    try {
      List<String> cmiModelsMapList = ParsingHelper.parseListMethod<dynamic, String>(box.keys.toList());

      for (String hiveKey in cmiModelsMapList) {
        Map<String, dynamic> cmiModelMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(box.get(hiveKey));
        if (cmiModelMap.isNotEmpty) {
          cmiModelsMap[hiveKey] = CMIModel.fromMap(cmiModelMap);
        }
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseOfflineRepository().getAllCmiModels():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    MyPrint.printOnConsole("Final CmiModels Length:${cmiModelsMap.length}", tag: tag);

    return cmiModelsMap;
  }

  Future<Map<String, CMIModel>> getCmiModelsById({required List<String> cmiIds}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineRepository().getCmiModelsById() called with cmiIds:$cmiIds", tag: tag);

    Map<String, CMIModel> cmiModelsMap = <String, CMIModel>{};

    Box<dynamic>? box = await initializeCmiDataBox();

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().getCmiModelsById() because box is null", tag: tag);
      return cmiModelsMap;
    }

    try {
      for (String cmiId in cmiIds) {
        Map<String, dynamic> cmiModelMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(box.get(cmiId));
        if (cmiModelMap.isNotEmpty) {
          cmiModelsMap[cmiId] = CMIModel.fromMap(cmiModelMap);
        }
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseOfflineRepository().getCmiModelsById():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    MyPrint.printOnConsole("Final CmiModels Length:${cmiModelsMap.length}", tag: tag);

    return cmiModelsMap;
  }

  Future<bool> addCmiModelsInBox({required Map<String, CMIModel> cmiData, bool isClear = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineRepository().addCmiModelsInBox() called with cmiData of length:${cmiData.length}", tag: tag);

    Box<dynamic>? box = await initializeCmiDataBox();

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().addCmiModelsInBox() because box is null", tag: tag);
      return false;
    }

    try {
      if (isClear) box.clear();
      await box.putAll(cmiData.map((key, value) => MapEntry(key, value.toMap())));

      MyPrint.printOnConsole("Added CmiModels Successfully In Hive", tag: tag);

      return true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseOfflineRepository().addCmiModelsInBox():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return false;
    }
  }

  Future<bool> removeRecordsFromCmiDataBoxById({required List<String> cmiIds}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineRepository().removeRecordsFromCmiDataBoxById() called with cmiIds:$cmiIds", tag: tag);

    Box<dynamic>? box = await initializeCmiDataBox();

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().removeRecordsFromCmiDataBoxById() because box is null", tag: tag);
      return false;
    }

    try {
      await box.deleteAll(cmiIds);

      MyPrint.printOnConsole("Removed CmiModels Successfully From Hive", tag: tag);

      return true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseOfflineRepository().removeRecordsFromCmiDataBoxById():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return false;
    }
  }

  //endregion

  //region Learner Session
  Future<Map<String, CourseLearnerSessionResponseModel>> getAllCourseLearnerSessionResponseModels() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineRepository().getAllCourseLearnerSessionResponseModels() called", tag: tag);

    Map<String, CourseLearnerSessionResponseModel> courseLearnerSessionModelsMap = <String, CourseLearnerSessionResponseModel>{};

    Box<dynamic>? box = await initializeLearnerSessionBox();

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().getAllCourseLearnerSessionResponseModels() because box is null", tag: tag);
      return courseLearnerSessionModelsMap;
    }

    try {
      List<String> learnerSessionModelsMapList = ParsingHelper.parseListMethod<dynamic, String>(box.keys.toList());

      for (String hiveKey in learnerSessionModelsMapList) {
        Map<String, dynamic> learnerSessionModelMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(box.get(hiveKey));
        if (learnerSessionModelMap.isNotEmpty) {
          courseLearnerSessionModelsMap[hiveKey] = CourseLearnerSessionResponseModel.fromMap(learnerSessionModelMap);
        }
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseOfflineRepository().getAllCourseLearnerSessionResponseModels():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    MyPrint.printOnConsole("Final CourseLearnerSessionModels Length:${courseLearnerSessionModelsMap.length}", tag: tag);

    return courseLearnerSessionModelsMap;
  }

  Future<Map<String, CourseLearnerSessionResponseModel>> getCourseLearnerSessionsDataByIds({required List<String> courseLearnerSessionIds}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineRepository().getCourseLearnerSessionsDataByIds() called with courseLearnerSessionIds:$courseLearnerSessionIds", tag: tag);

    Map<String, CourseLearnerSessionResponseModel> courseLearnerSessionModelsMap = <String, CourseLearnerSessionResponseModel>{};

    Box<dynamic>? box = await initializeLearnerSessionBox();

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().getCourseLearnerSessionsDataByIds() because box is null", tag: tag);
      return courseLearnerSessionModelsMap;
    }

    try {
      for (String courseLearnerSessionId in courseLearnerSessionIds) {
        Map<String, dynamic> learnerSessionModelMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(box.get(courseLearnerSessionId));
        if (learnerSessionModelMap.isNotEmpty) {
          courseLearnerSessionModelsMap[courseLearnerSessionId] = CourseLearnerSessionResponseModel.fromMap(learnerSessionModelMap);
        }
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseOfflineRepository().getCourseLearnerSessionsDataByIds():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    MyPrint.printOnConsole("Final CourseLearnerSessionResponseModels Length:${courseLearnerSessionModelsMap.length}", tag: tag);

    return courseLearnerSessionModelsMap;
  }

  Future<bool> addCourseLearnerSessionModelsInBox({required Map<String, CourseLearnerSessionResponseModel> courseLearnerSessionsData, bool isClear = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineRepository().addCourseLearnerSessionModelsInBox() called with courseLearnerSessionsData of length:${courseLearnerSessionsData.length}", tag: tag);

    Box<dynamic>? box = await initializeLearnerSessionBox();

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().addCourseLearnerSessionModelsInBox() because box is null", tag: tag);
      return false;
    }

    try {
      if (isClear) box.clear();
      await box.putAll(courseLearnerSessionsData.map((key, value) => MapEntry(key, value.toMap())));

      MyPrint.printOnConsole("Added CourseLearnerSessionResponseModels Successfully In Hive", tag: tag);

      return true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseOfflineRepository().addCourseLearnerSessionModelsInBox():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return false;
    }
  }

  Future<bool> removeRecordsFromCourseLearnerSessionBoxById({required List<String> learnerSessionIds}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineRepository().removeRecordsFromCourseLearnerSessionBoxById() called with learnerSessionIds:$learnerSessionIds", tag: tag);

    Box<dynamic>? box = await initializeLearnerSessionBox();

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().removeRecordsFromCourseLearnerSessionBoxById() because box is null", tag: tag);
      return false;
    }

    try {
      await box.deleteAll(learnerSessionIds);

      MyPrint.printOnConsole("Removed Learner Session Models Successfully From Hive", tag: tag);

      return true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseOfflineRepository().removeRecordsFromCourseLearnerSessionBoxById():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return false;
    }
  }

  //endregion

  //region Student Response
  Future<Map<String, StudentCourseResponseModel>> getAllStudentResponseModels() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineRepository().getAllStudentResponseModels() called", tag: tag);

    Map<String, StudentCourseResponseModel> studentResponseModelsMap = <String, StudentCourseResponseModel>{};

    Box<dynamic>? box = await initializeStudentResponseBox();

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().getAllStudentResponseModels() because box is null", tag: tag);
      return studentResponseModelsMap;
    }

    try {
      List<String> learnerSessionModelsMapList = ParsingHelper.parseListMethod<dynamic, String>(box.keys.toList());

      for (String hiveKey in learnerSessionModelsMapList) {
        Map<String, dynamic> learnerSessionModelMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(box.get(hiveKey));
        if (learnerSessionModelMap.isNotEmpty) {
          studentResponseModelsMap[hiveKey] = StudentCourseResponseModel.fromMap(learnerSessionModelMap);
        }
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseOfflineRepository().getAllStudentResponseModels():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    MyPrint.printOnConsole("Final StudentResponseModels Length:${studentResponseModelsMap.length}", tag: tag);

    return studentResponseModelsMap;
  }

  Future<Map<String, StudentCourseResponseModel>> getStudentResponseModelsById({required List<String> studentResponseIds}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineRepository().getStudentResponseModelsById() called with learnerSessionIds:$studentResponseIds", tag: tag);

    Map<String, StudentCourseResponseModel> studentResponseModelModelsMap = <String, StudentCourseResponseModel>{};

    Box<dynamic>? box = await initializeStudentResponseBox();

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().getStudentResponseModelsById() because box is null", tag: tag);
      return studentResponseModelModelsMap;
    }

    try {
      for (String learnerSessionId in studentResponseIds) {
        Map<String, dynamic> learnerSessionModelMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(box.get(learnerSessionId));
        if (learnerSessionModelMap.isNotEmpty) {
          studentResponseModelModelsMap[learnerSessionId] = StudentCourseResponseModel.fromMap(learnerSessionModelMap);
        }
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseOfflineRepository().getStudentResponseModelsById():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    MyPrint.printOnConsole("Final StudentResponseModels Length:${studentResponseModelModelsMap.length}", tag: tag);

    return studentResponseModelModelsMap;
  }

  Future<bool> addStudentResponseModelsInBox({required Map<String, StudentCourseResponseModel> studentResponseData, bool isClear = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineRepository().addStudentResponseModelsInBox() called with studentResponseData of length:${studentResponseData.length}", tag: tag);

    Box<dynamic>? box = await initializeStudentResponseBox();

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().addStudentResponseModelsInBox() because box is null", tag: tag);
      return false;
    }

    try {
      if (isClear) box.clear();
      await box.putAll(studentResponseData.map((key, value) => MapEntry(key, value.toMap())));

      MyPrint.printOnConsole("Added LearnerSessionModels Successfully In Hive", tag: tag);

      return true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseOfflineRepository().addStudentResponseModelsInBox():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return false;
    }
  }

  Future<bool> removeRecordsFromStudentResponseBoxById({required List<String> studentResponseIds}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineRepository().removeRecordsFromStudentResponseBoxById() called with studentResponseIds:$studentResponseIds", tag: tag);

    Box<dynamic>? box = await initializeStudentResponseBox();

    if (box == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineRepository().removeRecordsFromStudentResponseBoxById() because box is null", tag: tag);
      return false;
    }

    try {
      await box.deleteAll(studentResponseIds);

      MyPrint.printOnConsole("Removed Student Response Models Successfully From Hive", tag: tag);

      return true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseOfflineRepository().removeRecordsFromStudentResponseBoxById():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return false;
    }
  }

//endregion

  Future<DataResponseModel<String>> UpdateOfflineTrackedData({
    required UpdateOfflineTrackedDataRequestModel requestModel,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
    requestModel.siteURL = apiUrlConfigurationProvider.getCurrentSiteUrl();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      url: apiEndpoints.UpdateOfflineTrackedData(),
      restCallType: RestCallType.simplePostCall,
      queryParameters: requestModel.toMap(),
      requestBody: requestModel.requestString,
      parsingType: ModelDataParsingType.string,
    );

    DataResponseModel<String> apiResponseModel = await apiController.callApi<String>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<GetCourseTrackingDataResponseModel>> getCourseTrackingData({required GetCourseTrackingDataRequestModel requestModel}) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;
    requestModel.studid = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.SiteURL = apiUrlConfigurationProvider.getCurrentSiteUrl();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<Map<String, dynamic>>(
      url: apiEndpoints.GetCourseTrackingData(),
      restCallType: RestCallType.simpleGetCall,
      queryParameters: requestModel.toJson(),
      parsingType: ModelDataParsingType.GetCourseTrackingDataResponseModel,
    );

    DataResponseModel<GetCourseTrackingDataResponseModel> apiResponseModel = await apiController.callApi<GetCourseTrackingDataResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }
}
