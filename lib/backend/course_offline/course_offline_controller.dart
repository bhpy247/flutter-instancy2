import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/backend/app/app_controller.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_controller.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_provider.dart';
import 'package:flutter_instancy_2/backend/course_launch/course_launch_repository.dart';
import 'package:flutter_instancy_2/backend/course_offline/course_offline_provider.dart';
import 'package:flutter_instancy_2/backend/course_offline/course_offline_repository.dart';
import 'package:flutter_instancy_2/backend/event_track/event_track_hive_repository.dart';
import 'package:flutter_instancy_2/backend/network_connection/network_connection_controller.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/common/data_response_model.dart';
import 'package:flutter_instancy_2/models/course_launch/request_model/update_jw_video_progress_request_model.dart';
import 'package:flutter_instancy_2/models/course_launch/request_model/update_jw_video_time_details_request_model.dart';
import 'package:flutter_instancy_2/models/course_offline/data_model/cmi_model.dart';
import 'package:flutter_instancy_2/models/course_offline/data_model/learner_session_model.dart';
import 'package:flutter_instancy_2/models/course_offline/data_model/student_response_model.dart';
import 'package:flutter_instancy_2/models/course_offline/request_model/course_offline_launch_request_model.dart';
import 'package:flutter_instancy_2/models/course_offline/request_model/get_course_tracking_data_request_model.dart';
import 'package:flutter_instancy_2/models/course_offline/response_model/course_learner_session_response_model.dart';
import 'package:flutter_instancy_2/models/course_offline/response_model/get_course_tracking_data_response_model.dart';
import 'package:flutter_instancy_2/models/course_offline/response_model/student_course_response_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/related_track_data_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/track_course_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/track_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/response_model/resource_content_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/response_model/track_list_view_data_response_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/views/course_offline/request_model/update_offline_tracked_data_request_model.dart';
import 'package:provider/provider.dart';

class CourseOfflineController {
  static final CourseOfflineController _instance = CourseOfflineController._();

  factory CourseOfflineController() => _instance;

  CourseOfflineController._();

  final CourseOfflineProvider provider = CourseOfflineProvider();
  final CourseOfflineRepository repository = CourseOfflineRepository();

  //region Offline webview Operations
  Future<void> checkCourseTrackingInitialization({required CourseOfflineLaunchRequestModel requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineController().checkCourseTrackingInitialization() called with requestModel:$requestModel", tag: tag);

    CMIModel? cmiModel;
    CourseLearnerSessionResponseModel? courseLearnerSessionModel;
    StudentCourseResponseModel? studentCourseResponseModel;

    await Future.wait([
      getCmiModelFromRequestModel(requestModel: requestModel).then((CMIModel? model) {
        cmiModel = model;
      }),
      getLearnerSessionModelFromRequestModel(requestModel: requestModel).then((CourseLearnerSessionResponseModel? model) {
        courseLearnerSessionModel = model;
      }),
      getStudentResponseModelFromRequestModel(requestModel: requestModel).then((StudentCourseResponseModel? model) {
        studentCourseResponseModel = model;
      }),
    ]);

    List<Future> futures = [];
    String currentDateTime = getCurrentDateTime();
    int attempt = (courseLearnerSessionModel?.getLastLearnerAttempt() ?? 0) + 1;
    MyPrint.printOnConsole("Final Attempt Count:$attempt", tag: tag);

    if (cmiModel == null) {
      MyPrint.printOnConsole("CmiModel Not Exist, Creating", tag: tag);

      String cmiId = CMIModel.getCmiId(siteId: requestModel.SiteId, userId: requestModel.UserId, scoId: requestModel.ScoId);

      cmiModel = CMIModel(
        cmiId: cmiId,
        contentId: requestModel.ContentId,
        scoid: requestModel.ScoId,
        siteid: requestModel.SiteId,
        userid: requestModel.UserId,
        isupdate: "false",
        noofattempts: attempt,
        objecttypeid: requestModel.ContentTypeId.toString(),
        parentContentId: requestModel.ParentContentId,
        parentObjTypeId: requestModel.ParentContentTypeId.toString(),
        parentScoId: requestModel.ParentContentScoId.toString(),
        startdate: currentDateTime,
        corelessonstatus: ContentStatusTypes.incomplete,
        siteurl: ApiController().apiDataProvider.getCurrentSiteUrl(),
        isJWVideo: requestModel.isJWVideo,
      );
      futures.add(setCmiModelFromRequestModel(requestModel: requestModel, cmiModel: cmiModel));
    } else {
      MyPrint.printOnConsole("CmiModel Exist, Updating noofattempts", tag: tag);

      futures.add(
        updateCmiModel(
          requestModel: requestModel,
          onUpdate: ({required CMIModel cmiModel}) {
            cmiModel.noofattempts = attempt;
            if (cmiModel.startdate.isEmpty) cmiModel.startdate = currentDateTime;

            return cmiModel;
          },
        ),
      );
    }

    LearnerSessionModel learnerSessionModel = LearnerSessionModel(
      attemptnumber: attempt,
      scoid: requestModel.ScoId,
      siteid: requestModel.SiteId,
      userid: requestModel.UserId,
      sessiondatetime: currentDateTime,
    );

    if (courseLearnerSessionModel == null) {
      MyPrint.printOnConsole("LearnerSessionModel Not Exist, Creating", tag: tag);

      String learnerSessionId = CourseLearnerSessionResponseModel.getCourseLearnerSessionId(siteId: requestModel.SiteId, userId: requestModel.UserId, scoId: requestModel.ScoId);

      courseLearnerSessionModel = CourseLearnerSessionResponseModel(
        id: learnerSessionId,
        scoId: requestModel.ScoId,
        siteId: requestModel.SiteId,
        userId: requestModel.UserId,
        learnerSessionsResponseMap: {
          attempt: learnerSessionModel,
        },
      );

      futures.add(setLearnerSessionModelFromRequestModel(requestModel: requestModel, courseLearnerSessionModel: courseLearnerSessionModel));
    } else {
      MyPrint.printOnConsole("LearnerSessionModel Exist, Updating attemptnumber", tag: tag);

      futures.add(
        updateLearnerSession(
          requestModel: requestModel,
          onUpdate: ({required CourseLearnerSessionResponseModel courseLearnerSessionModel}) {
            courseLearnerSessionModel.learnerSessionsResponseMap[attempt] = learnerSessionModel;

            return courseLearnerSessionModel;
          },
        ),
      );
    }

    if (studentCourseResponseModel == null) {
      MyPrint.printOnConsole("StudentResponseModel Not Exist, Creating", tag: tag);

      String studentResponseId = StudentCourseResponseModel.getStudentCourseResponseId(siteId: requestModel.SiteId, userId: requestModel.UserId, scoId: requestModel.ScoId);

      studentCourseResponseModel = StudentCourseResponseModel(
        id: studentResponseId,
        scoId: requestModel.ScoId,
        siteId: requestModel.SiteId,
        userId: requestModel.UserId,
      );
      futures.add(setStudentResponseModelFromRequestModel(requestModel: requestModel, studentCourseResponseModel: studentCourseResponseModel));
    } else {
      MyPrint.printOnConsole("StudentResponseModel Exist", tag: tag);
    }

    if (futures.isNotEmpty) await Future.wait(futures);

    MyPrint.printOnConsole("Course Tracking Initializations Completed", tag: tag);
  }

  Future<String> generateQueryParametersForOfflineCourseLaunch({required CourseOfflineLaunchRequestModel requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineController().generateQueryParametersForOfflineCourseLaunch() called with requestModel:$requestModel", tag: tag);

    try {
      String quesdata = "";

      String lloc = "";
      String lstatus = "";
      String susdata = "";
      String score = "";

      CMIModel? cmiModel;
      StudentCourseResponseModel? studentCourseResponseModel;

      await Future.wait([
        getCmiModelFromRequestModel(requestModel: requestModel).then((value) {
          cmiModel = value;
        }),
        getStudentResponseModelFromRequestModel(requestModel: requestModel).then((value) {
          studentCourseResponseModel = value;
        }),
      ]);

      if (cmiModel != null) {
        lloc = cmiModel!.corelessonlocation;
        lstatus = cmiModel!.corelessonstatus;
        susdata = cmiModel!.suspenddata;
        score = cmiModel!.scoreraw;
      }

      // blank.html?IOSCourseClose=true&cid=24227&stid=1963&lloc=7&lstatus=incomplete&susdata=#pgvs_start#1%3B1%3B2%3B3%3B3%3B4%3B5%3B5%3B4%3B5%3B6%3B7%3B7%3B6%3B5%3B7%3B7;#pgvs_end#&timespent=00:00:39.34&quesdata=&score=0.0
      // start.html?cid=24227&stid=1963&lloc=7&lstatus=incomplete&susdata=%23pgvs_start%231%3B1%3B2%3B3%3B3%3B4%3B5%3B5%3B4%3B5%3B6%3B7%3B7%3B6%3B5%3B7%3B7%3B%23pgvs_end%23&quesdata=0%40%40%40%40%40%40%40%40%40%40&score=0.0&sname=Dishant+Agrawal&IsInstancyContent=true&nativeappURL=true

      //On Close: file:///storage/emulated/0/android/data/com.instancy.qalearning2/files/coursedownloads/qalearning.instancy.com/1963/2289ce2e-a3e3-4220-9526-4b612e400cc0/blank.html?ioscourseclose=true&cid=24225&stid=1963&lloc=3&lstatus=incomplete&susdata=%23pgvs_start%233;%23pgvs_end%23&timespent=00:00:07.91&quesdata=
      //On Launch:file:///storage/emulated/0/Android/data/com.instancy.qalearning2/files/CourseDownloads/qalearning.instancy.com/1963/2289ce2e-a3e3-4220-9526-4b612e400cc0/start.html?cid=24225&stid=1963&lloc=3&lstatus=incomplete&susdata=#pgvs_start#3;#pgvs_end#&quesdata=0@@@@@@@@@@@&sname=Dishant

      //On Close: file:///storage/emulated/0/android/data/com.instancy.qalearning2/files/coursedownloads/qalearning.instancy.com/1963/2289ce2e-a3e3-4220-9526-4b612e400cc0/blank.html?ioscourseclose=true&cid=24225&stid=1963&lloc=3&lstatus=incomplete&susdata=%23pgvs_start%233;2;1;%23pgvs_end%23&timespent=00:04:36.86&quesdata=
      //On Launch:file:///storage/emulated/0/Android/data/com.instancy.qalearning2/files/CourseDownloads/qalearning.instancy.com/1963/2289ce2e-a3e3-4220-9526-4b612e400cc0/start.html?cid=24225&stid=1963&lloc=3&lstatus=incomplete&susdata=#pgvs_start%233;2;1;%23pgvs_end%23&quesdata=0@@@@@@@@@@@&sname=Dishant%20Agrawal&IsInstancyContent=true&nativeappURL=true

      if (studentCourseResponseModel != null) {
        List<int> questionIds = studentCourseResponseModel!.questionResponseMap.keys.toList()..sort();

        for (int questionId in questionIds) {
          StudentResponseModel? studentResponseModel = studentCourseResponseModel?.questionResponseMap[questionId];
          MyPrint.printOnConsole("studentResponseModel:$studentResponseModel", tag: tag);

          if (studentResponseModel == null) continue;

          // quesdata=1@4@correct@$2@2@correct@$3@3@correct@$4@3@correct@$5@1@correct@&

          String questionData = "${studentResponseModel.questionid}@"
              "${AppConfigurationOperations.isValidString(studentResponseModel.studentresponses) ? "${studentResponseModel.studentresponses}@" : ""}"
              "${AppConfigurationOperations.isValidString(studentResponseModel.result) ? "${studentResponseModel.result}@" : ""}"
              "${AppConfigurationOperations.isValidString(studentResponseModel.optionalnotes) ? "${studentResponseModel.optionalnotes}@" : ""}"
              "${AppConfigurationOperations.isValidString(studentResponseModel.attachfilename) ? "${studentResponseModel.attachfilename}@" : ""}"
              "${AppConfigurationOperations.isValidString(studentResponseModel.attachfileid) ? "${studentResponseModel.attachfileid}@" : ""}"
              "${AppConfigurationOperations.isValidString(studentResponseModel.capturedvidfilename) ? "${studentResponseModel.capturedvidfilename}@" : ""}"
              "${AppConfigurationOperations.isValidString(studentResponseModel.capturedvidid) ? "${studentResponseModel.capturedvidid}@" : ""}"
              "${AppConfigurationOperations.isValidString(studentResponseModel.capturedimgfilename) ? "${studentResponseModel.capturedimgfilename}@" : ""}"
              "${AppConfigurationOperations.isValidString(studentResponseModel.capturedimgfilename) ? "${studentResponseModel.capturedimgfilename}@" : ""}"
              "${AppConfigurationOperations.isValidString(studentResponseModel.capturedimgid) ? "${studentResponseModel.capturedimgid}@" : ""}";

          quesdata += "$questionData\$";
        }
      }

      Map<String, String> queryParameters = <String, String>{
        "cid": requestModel.ScoId.toString(),
        "stid": requestModel.UserId.toString(),
        if (lloc.isNotEmpty) "lloc": lloc,
        if (lstatus.isNotEmpty) "lstatus": lstatus,
        if (susdata.isNotEmpty) "susdata": susdata,
        if (quesdata.isNotEmpty) "quesdata": quesdata,
        if (score.isNotEmpty) "score": score,
        // "LtSusdata" : "",
        // "LtStatus" : "",
        // "LtQuesData" : "",
        if (requestModel.UserName.isNotEmpty) "sname": requestModel.UserName,
        "IsInstancyContent": "${requestModel.ContentTypeId != InstancyObjectTypes.scorm1_2}",
        "nativeappURL": true.toString(),
      };
      String path = queryParameters.entries.map((e) => "${e.key}=${e.value}").join("&");

      return path;
    } catch (e) {
      MyPrint.printOnConsole('generateOfflinePathForCourseView failed: $e');
      return "";
    }
  }

  Future<bool> updateCmiModel({required CourseOfflineLaunchRequestModel requestModel, CMIModel Function({required CMIModel cmiModel})? onUpdate, bool isUpdatedOnline = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineController().updateCmiModel() called with requestModel:$requestModel", tag: tag);

    bool isSuccess = false;

    CMIModel? cmiModel = await getCmiModelFromRequestModel(requestModel: requestModel);

    if (cmiModel == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineController().updateCmiModel() because CmiModel not exist", tag: tag);
      return isSuccess;
    }

    if (onUpdate != null) {
      cmiModel = onUpdate(cmiModel: cmiModel);
      cmiModel.isupdate = isUpdatedOnline.toString();
      cmiModel.isJWVideo = requestModel.isJWVideo;
      MyPrint.printOnConsole("cmiModel:$cmiModel", tag: tag);
      await setCmiModelFromRequestModel(requestModel: requestModel, cmiModel: cmiModel);
      isSuccess = true;
    }

    MyPrint.printOnConsole("isSuccess:$isSuccess", tag: tag);
    return isSuccess;
  }

  Future<bool> updateLearnerSession({
    required CourseOfflineLaunchRequestModel requestModel,
    CourseLearnerSessionResponseModel Function({required CourseLearnerSessionResponseModel courseLearnerSessionModel})? onUpdate,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineController().updateLearnerSession() called with requestModel:$requestModel", tag: tag);

    bool isSuccess = false;

    CourseLearnerSessionResponseModel? courseLearnerSessionModel = await getLearnerSessionModelFromRequestModel(requestModel: requestModel);

    if (courseLearnerSessionModel == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineController().updateLearnerSession() because LearnerSessionModel not exist", tag: tag);
      return isSuccess;
    }

    if (onUpdate != null) {
      courseLearnerSessionModel = onUpdate(courseLearnerSessionModel: courseLearnerSessionModel);
      // MyPrint.printOnConsole("learnerSessionModel:$courseLearnerSessionModel", tag: tag);
      await setLearnerSessionModelFromRequestModel(requestModel: requestModel, courseLearnerSessionModel: courseLearnerSessionModel);
      isSuccess = true;
    }

    MyPrint.printOnConsole("isSuccess:$isSuccess", tag: tag);
    return isSuccess;
  }

  Future<bool> updateStudentResponse({
    required CourseOfflineLaunchRequestModel requestModel,
    StudentCourseResponseModel Function({required StudentCourseResponseModel studentCourseResponseModel})? onUpdate,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineController().updateStudentResponse() called with requestModel:$requestModel", tag: tag);

    bool isSuccess = false;

    StudentCourseResponseModel? studentCourseResponseModel = await getStudentResponseModelFromRequestModel(requestModel: requestModel);

    if (studentCourseResponseModel == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineController().updateStudentResponse() because StudentResponseModel not exist", tag: tag);
      return isSuccess;
    }

    if (onUpdate != null) {
      studentCourseResponseModel = onUpdate(studentCourseResponseModel: studentCourseResponseModel);
      // MyPrint.printOnConsole("studentCourseResponseModel:$studentCourseResponseModel", tag: tag);
      await setStudentResponseModelFromRequestModel(requestModel: requestModel, studentCourseResponseModel: studentCourseResponseModel);
      isSuccess = true;
    }

    MyPrint.printOnConsole("isSuccess:$isSuccess", tag: tag);
    return isSuccess;
  }

  //endregion

  //region CMI Operations
  Future<CMIModel?> getCmiModelFromRequestModel({required CourseOfflineLaunchRequestModel requestModel, bool isRefresh = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineController().getCmiModelFromRequestModel() called with requestModel:$requestModel, isRefresh:$isRefresh", tag: tag);

    String cmiId = CMIModel.getCmiId(siteId: requestModel.SiteId, userId: requestModel.UserId, scoId: requestModel.ScoId);
    CMIModel? cmiModel = provider.cmiData.getMap(isNewInstance: false)[cmiId];
    MyPrint.printOnConsole("CmiModel is not null from Provider:${cmiModel != null}", tag: tag);

    if (isRefresh || cmiModel == null) {
      MyPrint.printOnConsole("Getting CmiModel From Hive", tag: tag);
      cmiModel = (await repository.getCmiModelsById(cmiIds: [cmiId]))[cmiId];
      MyPrint.printOnConsole("CmiModel is not null from Hive:${cmiModel != null}", tag: tag);

      if (cmiModel != null) {
        provider.cmiData.setMap(map: {cmiId: cmiModel}, isClear: false, isNotify: false);
      } else {
        provider.cmiData.clearKey(key: cmiId, isNotify: false);
      }
    }

    return cmiModel != null ? CMIModel.fromMap(cmiModel.toMap()) : null;
  }

  Future<void> setCmiModelFromRequestModel({required CourseOfflineLaunchRequestModel requestModel, CMIModel? cmiModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineController().setCmiModelFromRequestModel() called with requestModel:$requestModel, cmiModel not null:${cmiModel != null}", tag: tag);
    MyPrint.logOnConsole("CmiModel:$cmiModel", tag: tag);

    String cmiId = CMIModel.getCmiId(siteId: requestModel.SiteId, userId: requestModel.UserId, scoId: requestModel.ScoId);
    if (cmiModel == null) {
      MyPrint.printOnConsole("Removing cmiModel From Hive and Provider", tag: tag);
      provider.cmiData.clearKey(key: cmiId, isNotify: false);
      await repository.removeRecordsFromCmiDataBoxById(cmiIds: [cmiId]);
    } else {
      cmiModel.scoid = requestModel.ScoId;
      cmiModel.siteid = requestModel.SiteId;
      cmiModel.userid = requestModel.UserId;
      cmiModel.objecttypeid = requestModel.ContentTypeId.toString();
      cmiModel.isJWVideo = requestModel.isJWVideo;

      MyPrint.printOnConsole("Adding cmiModel in Hive and Provider", tag: tag);
      MyPrint.printOnConsole("new cmiModel:$cmiModel", tag: tag);
      provider.cmiData.setMap(map: {cmiId: cmiModel}, isClear: false, isNotify: false);
      await repository.addCmiModelsInBox(cmiData: {cmiId: cmiModel}, isClear: false);
    }

    MyPrint.printOnConsole("Setted cmiModel in Hive and Provider Successfully", tag: tag);
  }

  Future<Map<String, CMIModel>> getAllCmiModels({bool isRefresh = true, bool isNewInstance = true}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineController().getAllCmiModels() called with isRefresh:$isRefresh, isNewInstance:$isNewInstance", tag: tag);

    if (isRefresh || provider.cmiData.length == 0) {
      Map<String, CMIModel> cmiData = await repository.getAllCmiModels();
      provider.cmiData.setMap(map: cmiData, isClear: true, isNotify: false);
    }

    return provider.cmiData.getMap(isNewInstance: isNewInstance);
  }

  //endregion

  //region Learner Session Operations
  Future<CourseLearnerSessionResponseModel?> getLearnerSessionModelFromRequestModel({required CourseOfflineLaunchRequestModel requestModel, bool isRefresh = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineController().getLearnerSessionModelFromRequestModel() called with requestModel:$requestModel, isRefresh:$isRefresh", tag: tag);

    String courseLearnerSessionId = CourseLearnerSessionResponseModel.getCourseLearnerSessionId(siteId: requestModel.SiteId, userId: requestModel.UserId, scoId: requestModel.ScoId);
    CourseLearnerSessionResponseModel? courseLearnerSessionModel = provider.courseLearnerSessionData.getMap(isNewInstance: false)[courseLearnerSessionId];
    MyPrint.printOnConsole("CourseLearnerSessionResponseModel is not null from Provider:${courseLearnerSessionModel != null}", tag: tag);

    if (isRefresh || courseLearnerSessionModel == null) {
      MyPrint.printOnConsole("Getting CourseLearnerSessionResponseModel From Hive", tag: tag);
      courseLearnerSessionModel = (await repository.getCourseLearnerSessionsDataByIds(courseLearnerSessionIds: [courseLearnerSessionId]))[courseLearnerSessionId];
      MyPrint.printOnConsole("CourseLearnerSessionResponseModel is not null from Hive:${courseLearnerSessionModel != null}", tag: tag);

      if (courseLearnerSessionModel != null) {
        provider.courseLearnerSessionData.setMap(map: {courseLearnerSessionId: courseLearnerSessionModel}, isClear: false, isNotify: false);
      } else {
        provider.courseLearnerSessionData.clearKey(key: courseLearnerSessionId, isNotify: false);
      }
    }

    return courseLearnerSessionModel != null ? CourseLearnerSessionResponseModel.fromMap(courseLearnerSessionModel.toMap()) : null;
  }

  Future<void> setLearnerSessionModelFromRequestModel({required CourseOfflineLaunchRequestModel requestModel, CourseLearnerSessionResponseModel? courseLearnerSessionModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
        "CourseOfflineController().setLearnerSessionModelFromRequestModel() called with requestModel:$requestModel, learnerSessionModel not null:${courseLearnerSessionModel != null}",
        tag: tag);

    String courseLearnerSessionId = CourseLearnerSessionResponseModel.getCourseLearnerSessionId(siteId: requestModel.SiteId, userId: requestModel.UserId, scoId: requestModel.ScoId);
    if (courseLearnerSessionModel == null) {
      MyPrint.printOnConsole("Removing CourseLearnerSessionResponseModel From Hive and Provider", tag: tag);
      provider.courseLearnerSessionData.clearKey(key: courseLearnerSessionId, isNotify: false);
      await repository.removeRecordsFromCourseLearnerSessionBoxById(learnerSessionIds: [courseLearnerSessionId]);
    } else {
      courseLearnerSessionModel.id = courseLearnerSessionId;
      courseLearnerSessionModel.scoId = requestModel.ScoId;
      courseLearnerSessionModel.siteId = requestModel.SiteId;
      courseLearnerSessionModel.userId = requestModel.UserId;

      MyPrint.printOnConsole("Adding CourseLearnerSessionResponseModel in Hive and Provider", tag: tag);
      provider.courseLearnerSessionData.setMap(map: {courseLearnerSessionId: courseLearnerSessionModel}, isClear: false, isNotify: false);
      await repository.addCourseLearnerSessionModelsInBox(courseLearnerSessionsData: {courseLearnerSessionId: courseLearnerSessionModel}, isClear: false);
    }

    MyPrint.printOnConsole("Setted LearnerSessionModel in Hive and Provider Successfully", tag: tag);
  }

  Future<Map<String, CourseLearnerSessionResponseModel>> getAllCourseLearnerSessionResponseModels({bool isRefresh = true, bool isNewInstance = true}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineController().getAllCourseLearnerSessionResponseModels() called with isRefresh:$isRefresh, isNewInstance:$isNewInstance", tag: tag);

    if (isRefresh || provider.courseLearnerSessionData.length == 0) {
      Map<String, CourseLearnerSessionResponseModel> learnerSessionData = await repository.getAllCourseLearnerSessionResponseModels();
      provider.courseLearnerSessionData.setMap(map: learnerSessionData, isClear: true, isNotify: false);
    }

    return provider.courseLearnerSessionData.getMap(isNewInstance: isNewInstance);
  }

  //endregion

  //region Student Response Operations
  Future<StudentCourseResponseModel?> getStudentResponseModelFromRequestModel({required CourseOfflineLaunchRequestModel requestModel, bool isRefresh = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineController().getStudentResponseModelFromRequestModel() called with requestModel:$requestModel, isRefresh:$isRefresh", tag: tag);

    String studentResponseId = StudentCourseResponseModel.getStudentCourseResponseId(siteId: requestModel.SiteId, userId: requestModel.UserId, scoId: requestModel.ScoId);
    StudentCourseResponseModel? studentCourseResponseModel = provider.studentResponseData.getMap(isNewInstance: false)[studentResponseId];
    MyPrint.printOnConsole("StudentResponseModel is not null from Provider:${studentCourseResponseModel != null}", tag: tag);

    if (isRefresh || studentCourseResponseModel == null) {
      MyPrint.printOnConsole("Getting StudentResponseModel From Hive", tag: tag);
      studentCourseResponseModel = (await repository.getStudentResponseModelsById(studentResponseIds: [studentResponseId]))[studentResponseId];
      MyPrint.printOnConsole("StudentResponseModel is not null from Hive:${studentCourseResponseModel != null}", tag: tag);

      if (studentCourseResponseModel != null) {
        provider.studentResponseData.setMap(map: {studentResponseId: studentCourseResponseModel}, isClear: false, isNotify: false);
      } else {
        provider.studentResponseData.clearKey(key: studentResponseId, isNotify: false);
      }
    }

    return studentCourseResponseModel != null ? StudentCourseResponseModel.fromMap(studentCourseResponseModel.toMap()) : null;
  }

  Future<void> setStudentResponseModelFromRequestModel({required CourseOfflineLaunchRequestModel requestModel, StudentCourseResponseModel? studentCourseResponseModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
        "CourseOfflineController().setStudentResponseModelFromRequestModel() called with requestModel:$requestModel, studentResponseModel not null:${studentCourseResponseModel != null}",
        tag: tag);

    String studentResponseId = StudentCourseResponseModel.getStudentCourseResponseId(siteId: requestModel.SiteId, userId: requestModel.UserId, scoId: requestModel.ScoId);
    if (studentCourseResponseModel == null) {
      MyPrint.printOnConsole("Removing StudentResponseModel From Hive and Provider", tag: tag);
      provider.studentResponseData.clearKey(key: studentResponseId, isNotify: false);
      await repository.removeRecordsFromStudentResponseBoxById(studentResponseIds: [studentResponseId]);
    } else {
      studentCourseResponseModel.scoId = requestModel.ScoId;
      studentCourseResponseModel.siteId = requestModel.SiteId;
      studentCourseResponseModel.userId = requestModel.UserId;

      MyPrint.printOnConsole("Adding StudentResponseModel in Hive and Provider", tag: tag);
      provider.studentResponseData.setMap(map: {studentResponseId: studentCourseResponseModel}, isClear: false, isNotify: false);
      await repository.addStudentResponseModelsInBox(studentResponseData: {studentResponseId: studentCourseResponseModel}, isClear: false);
    }

    MyPrint.printOnConsole("Setted StudentResponseModel in Hive and Provider Successfully", tag: tag);
  }

  Future<Map<String, StudentCourseResponseModel>> getAllStudentResponseModels({bool isRefresh = true, bool isNewInstance = true}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineController().getAllStudentResponseModels() called with isRefresh:$isRefresh, isNewInstance:$isNewInstance", tag: tag);

    if (isRefresh || provider.studentResponseData.length == 0) {
      Map<String, StudentCourseResponseModel> studentResponseData = await repository.getAllStudentResponseModels();
      provider.studentResponseData.setMap(map: studentResponseData, isClear: true, isNotify: false);
    }

    return provider.studentResponseData.getMap(isNewInstance: isNewInstance);
  }

  //endregion

  String getCurrentDateTime() {
    // return DatePresentation.getFormattedDate(dateFormat: "yyyy-MM-dd HH:mm:ss", dateTime: DateTime.now()) ?? "";
    return DateTime.now().toIso8601String();
  }

  Future<bool> setCompleteOffline({required CourseOfflineLaunchRequestModel requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineController().setCompleteOffline() called", tag: tag);

    bool isCompleted = false;

    CMIModel? cmiModel = await getCmiModelFromRequestModel(requestModel: requestModel);
    MyPrint.printOnConsole("cmiModel:$cmiModel", tag: tag);

    String currentDateTime = getCurrentDateTime();
    if (cmiModel == null) {
      String cmiId = CMIModel.getCmiId(siteId: requestModel.SiteId, userId: requestModel.UserId, scoId: requestModel.ScoId);

      await setCmiModelFromRequestModel(
        requestModel: requestModel,
        cmiModel: CMIModel(
          cmiId: cmiId,
          contentId: requestModel.ContentId,
          scoid: requestModel.ScoId,
          siteid: requestModel.SiteId,
          userid: requestModel.UserId,
          isupdate: "false",
          noofattempts: 1,
          objecttypeid: requestModel.ContentTypeId.toString(),
          parentContentId: requestModel.ParentContentId,
          parentObjTypeId: requestModel.ParentContentTypeId.toString(),
          parentScoId: requestModel.ParentContentScoId.toString(),
          startdate: currentDateTime,
          corelessonstatus: ContentStatusTypes.completed,
          percentageCompleted: "100",
          datecompleted: currentDateTime,
          siteurl: ApiController().apiDataProvider.getCurrentSiteUrl(),
          isJWVideo: requestModel.isJWVideo,
        ),
      );
      isCompleted = true;
    } else {
      isCompleted = await updateCmiModel(
        requestModel: requestModel,
        onUpdate: ({required CMIModel cmiModel}) {
          cmiModel.corelessonstatus = ContentStatusTypes.completed;
          cmiModel.percentageCompleted = "100";
          cmiModel.datecompleted = currentDateTime;

          return cmiModel;
        },
      );
    }

    CourseLearnerSessionResponseModel? learnerSessionResponseModel = await getLearnerSessionModelFromRequestModel(requestModel: requestModel);

    if (learnerSessionResponseModel == null) {
      String courseLearnerSessionId = CourseLearnerSessionResponseModel.getCourseLearnerSessionId(siteId: requestModel.SiteId, userId: requestModel.UserId, scoId: requestModel.ScoId);

      await setLearnerSessionModelFromRequestModel(
        requestModel: requestModel,
        courseLearnerSessionModel: CourseLearnerSessionResponseModel(
          id: courseLearnerSessionId,
          siteId: requestModel.SiteId,
          userId: requestModel.UserId,
          scoId: requestModel.ScoId,
          learnerSessionsResponseMap: {
            1: LearnerSessionModel(
              siteid: requestModel.SiteId,
              userid: requestModel.UserId,
              scoid: requestModel.ScoId,
              attemptnumber: 1,
              sessiondatetime: currentDateTime,
            ),
          },
        ),
      );
      isCompleted = true;
    } else {
      isCompleted = await updateLearnerSession(
        requestModel: requestModel,
        onUpdate: ({required CourseLearnerSessionResponseModel courseLearnerSessionModel}) {
          int newAttempt = courseLearnerSessionModel.getLastLearnerAttempt() + 1;
          courseLearnerSessionModel.learnerSessionsResponseMap[newAttempt] = LearnerSessionModel(
            siteid: requestModel.SiteId,
            userid: requestModel.UserId,
            scoid: requestModel.ScoId,
            attemptnumber: newAttempt,
            sessiondatetime: currentDateTime,
          );

          return courseLearnerSessionModel;
        },
      );
    }

    MyPrint.printOnConsole("isCompleted:$isCompleted", tag: tag);

    return isCompleted;
  }

  Future<bool> setContentToInProgress({required CourseOfflineLaunchRequestModel requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineController().setContentToInProgress() called", tag: tag);

    bool isCompleted = false;

    CMIModel? cmiModel = await getCmiModelFromRequestModel(requestModel: requestModel);

    String currentDateTime = getCurrentDateTime();
    if (cmiModel == null) {
      String cmiId = CMIModel.getCmiId(siteId: requestModel.SiteId, userId: requestModel.UserId, scoId: requestModel.ScoId);

      await setCmiModelFromRequestModel(
        requestModel: requestModel,
        cmiModel: CMIModel(
          cmiId: cmiId,
          contentId: requestModel.ContentId,
          scoid: requestModel.ScoId,
          siteid: requestModel.SiteId,
          userid: requestModel.UserId,
          isupdate: "false",
          noofattempts: 1,
          objecttypeid: requestModel.ContentTypeId.toString(),
          parentContentId: requestModel.ParentContentId,
          parentObjTypeId: requestModel.ParentContentTypeId.toString(),
          parentScoId: requestModel.ParentContentScoId.toString(),
          startdate: currentDateTime,
          corelessonstatus: ContentStatusTypes.incomplete,
          percentageCompleted: "50",
          siteurl: ApiController().apiDataProvider.getCurrentSiteUrl(),
          isJWVideo: requestModel.isJWVideo,
        ),
      );
      isCompleted = true;
    } else {
      isCompleted = await updateCmiModel(
        requestModel: requestModel,
        onUpdate: ({required CMIModel cmiModel}) {
          cmiModel.corelessonstatus = ContentStatusTypes.incomplete;
          cmiModel.percentageCompleted = "50";

          return cmiModel;
        },
      );
    }

    CourseLearnerSessionResponseModel? learnerSessionResponseModel = await getLearnerSessionModelFromRequestModel(requestModel: requestModel);

    if (learnerSessionResponseModel == null) {
      String courseLearnerSessionId = CourseLearnerSessionResponseModel.getCourseLearnerSessionId(siteId: requestModel.SiteId, userId: requestModel.UserId, scoId: requestModel.ScoId);

      await setLearnerSessionModelFromRequestModel(
        requestModel: requestModel,
        courseLearnerSessionModel: CourseLearnerSessionResponseModel(
          id: courseLearnerSessionId,
          siteId: requestModel.SiteId,
          userId: requestModel.UserId,
          scoId: requestModel.ScoId,
          learnerSessionsResponseMap: {
            1: LearnerSessionModel(
              siteid: requestModel.SiteId,
              userid: requestModel.UserId,
              scoid: requestModel.ScoId,
              attemptnumber: 1,
              sessiondatetime: currentDateTime,
            ),
          },
        ),
      );
      isCompleted = true;
    } else {
      isCompleted = await updateLearnerSession(
        requestModel: requestModel,
        onUpdate: ({required CourseLearnerSessionResponseModel courseLearnerSessionModel}) {
          int newAttempt = courseLearnerSessionModel.getLastLearnerAttempt() + 1;
          courseLearnerSessionModel.learnerSessionsResponseMap[newAttempt] = LearnerSessionModel(
            siteid: requestModel.SiteId,
            userid: requestModel.UserId,
            scoid: requestModel.ScoId,
            attemptnumber: newAttempt,
            sessiondatetime: currentDateTime,
          );

          return courseLearnerSessionModel;
        },
      );
    }

    MyPrint.printOnConsole("isCompleted:$isCompleted", tag: tag);

    return isCompleted;
  }

  //region Sync Data to Online
  Future<void> syncCourseDataOnline({void Function()? onSyncStarted, void Function()? onSyncCompleted}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineController().syncCourseDataOnline() called", tag: tag);

    if (!NetworkConnectionController().checkConnection()) {
      MyPrint.printOnConsole("Returning from CourseOfflineController().syncCourseDataOnline() because No Internet Connection Available", tag: tag);
      return;
    }

    onSyncStarted?.call();

    Map<String, CMIModel> cmiModels = await getAllCmiModels(isRefresh: true, isNewInstance: true);
    Map<String, CourseLearnerSessionResponseModel> courseLearnerSessionModels = await getAllCourseLearnerSessionResponseModels(isRefresh: true, isNewInstance: true);
    Map<String, StudentCourseResponseModel> studentCourseResponseModels = await getAllStudentResponseModels(isRefresh: true, isNewInstance: true);

    cmiModels.removeWhere((key, value) => value.isupdate != "false");

    MyPrint.printOnConsole("Final CmiModels To Update:${cmiModels.keys.toList()}", tag: tag);

    DateTime startDateTime = DateTime.now();

    for (MapEntry<String, CMIModel> entry in cmiModels.entries) {
      CMIModel cmiModel = entry.value;

      DateTime startDateTime = DateTime.now();
      MyPrint.printOnConsole("Syncing cmiId:${entry.key}", tag: tag);
      await syncDataForContent(
        cmiModel: cmiModel,
        courseLearnerSessionModel: courseLearnerSessionModels[CourseLearnerSessionResponseModel.getCourseLearnerSessionId(
          siteId: cmiModel.siteid,
          userId: cmiModel.userid,
          scoId: cmiModel.scoid,
        )],
        studentCourseResponseModel: studentCourseResponseModels[StudentCourseResponseModel.getStudentCourseResponseId(
          siteId: cmiModel.siteid,
          userId: cmiModel.userid,
          scoId: cmiModel.scoid,
        )],
      );
      DateTime endDateTime = DateTime.now();
      MyPrint.printOnConsole(
        "Syncing Completed for cmiId:${entry.key} in ${endDateTime.difference(startDateTime).inMilliseconds} Milliseconds",
        tag: tag,
      );
    }

    DateTime endDateTime = DateTime.now();
    MyPrint.printOnConsole(
      "Synced All Course Tracking Data To Online in ${endDateTime.difference(startDateTime).inMilliseconds} Milliseconds",
      tag: tag,
    );

    onSyncCompleted?.call();
  }

  Future<bool> syncDataForContent({required CMIModel cmiModel, required CourseLearnerSessionResponseModel? courseLearnerSessionModel, StudentCourseResponseModel? studentCourseResponseModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineController().syncDataForContent() called with cmiModel:$cmiModel", tag: tag);

    String userId = cmiModel.userid.toString();

    //region CMI Model Request String
    String cmiModelRequestString = """
    <CMI>
      <ID></ID>
      <UserID>$userId</UserID>
      <SCOID>${cmiModel.scoid}</SCOID>
      <CoreLessonStatus>${AppConfigurationOperations.isValidString(cmiModel.corelessonstatus) ? cmiModel.corelessonstatus : ""}</CoreLessonStatus>
      <CoreLessonLocation>${AppConfigurationOperations.isValidString(cmiModel.corelessonlocation) ? cmiModel.corelessonlocation : ""}</CoreLessonLocation>
      <SuspendData>${AppConfigurationOperations.isValidString(cmiModel.suspenddata) ? cmiModel.suspenddata.replaceAll("%23", "#") : ""}</SuspendData>
      <DateCompleted>${AppConfigurationOperations.isValidString(cmiModel.datecompleted) ? cmiModel.datecompleted : ""}</DateCompleted>
      <NoOfAttempts>${cmiModel.noofattempts}</NoOfAttempts>
      <TrackScoID>${cmiModel.parentScoId}</TrackScoID>
      <TrackContentID>${cmiModel.parentContentId}</TrackContentID>
      <TrackObjectTypeID>${cmiModel.parentObjTypeId}</TrackObjectTypeID>
      <OrgUnitID>${cmiModel.siteid}</OrgUnitID>
      <Score>${ParsingHelper.parseIntMethod(cmiModel.scoreraw)}</Score>
      <PercentCompleted>${AppConfigurationOperations.isValidString(cmiModel.percentageCompleted) ? cmiModel.percentageCompleted : ""}</PercentCompleted>
      <ObjectTypeId>${cmiModel.objecttypeid}</ObjectTypeId>
      <SequenceNumber>${cmiModel.sequencenumber}</SequenceNumber>
      <AttemptsLeft>${cmiModel.attemptsleft}</AttemptsLeft>
      <CoreLessonMode>${cmiModel.corelessonmode}</CoreLessonMode>
      <ScoreMin>${cmiModel.scoremin}</ScoreMin>
      <ScoreMax>${cmiModel.scoremax}</ScoreMax>
      <RandomQuestionNos>${cmiModel.randomquestionnos}</RandomQuestionNos>
      <TextResponses>${cmiModel.textresponses}</TextResponses>
      <PooledQuestionNos>${cmiModel.pooledquestionnos}</PooledQuestionNos>
    </CMI>
    """;
    //endregion

    //region Learner Session Request String
    String learnerSessionRequestString = """""";
    if ((courseLearnerSessionModel?.learnerSessionsResponseMap).checkNotEmpty) {
      courseLearnerSessionModel!.learnerSessionsResponseMap.forEach((int attempt, LearnerSessionModel learnerSessionModel) {
        learnerSessionRequestString += """
        <LearnerSession>
          <SessionID></SessionID>
          <UserID>$userId</UserID>
          <SCOID>${learnerSessionModel.scoid}</SCOID>
          <AttemptNumber>${learnerSessionModel.attemptnumber}</AttemptNumber>
          <SessionDateTime>${learnerSessionModel.sessiondatetime}</SessionDateTime>
          <TimeSpent>${AppConfigurationOperations.isValidString(learnerSessionModel.timespent) ? learnerSessionModel.timespent : ""}</TimeSpent>
        </LearnerSession>
        """;
      });
    }
    //endregion

    //region Student Response Request String
    String studentResponseRequestString = """""";
    studentCourseResponseModel?.questionResponseMap.forEach((int studentResponseId, StudentResponseModel studentResponseModel) {
      String sampleStudentResponse = studentResponseModel.studentresponses;
      sampleStudentResponse = sampleStudentResponse.replaceAll("\'", "\\\'");
      sampleStudentResponse = sampleStudentResponse.replaceAll("\"", "\\\"");
      sampleStudentResponse = sampleStudentResponse.replaceAll("%23", "#");
      sampleStudentResponse = sampleStudentResponse.replaceAll("%5E", "^");
      if (sampleStudentResponse.contains("#^#^")) {
        sampleStudentResponse = sampleStudentResponse.replaceAll("#^#^", "@");
      }
      if (sampleStudentResponse.contains("##^^##^^")) {
        sampleStudentResponse = sampleStudentResponse.replaceAll("##^^##^^", "&&**&&");
        sampleStudentResponse = "[CDATA[$sampleStudentResponse]]";
      }

      studentResponseRequestString += """
      <StudentResponse>
        <UserID>$userId</UserID>
        <SCOID>${studentResponseModel.scoid}</SCOID>
        <QuestionID>${studentResponseModel.questionid}</QuestionID>
        <AssessmentAttempt>${studentResponseModel.assessmentattempt}</AssessmentAttempt>
        <QuestionAttempt>${studentResponseModel.questionattempt}</QuestionAttempt>
        <AttemptDate>${studentResponseModel.attemptdate}</AttemptDate>
        <Response>$sampleStudentResponse</Response>
        <Result>${studentResponseModel.result}</Result>
        <OptionalNotes>${studentResponseModel.optionalnotes}</OptionalNotes>
        <AttachFileName>${AppConfigurationOperations.isValidString(studentResponseModel.attachfilename) ? studentResponseModel.attachfilename : ""}</AttachFileName>
        <AttachFileId>${AppConfigurationOperations.isValidString(studentResponseModel.attachfileid) ? studentResponseModel.attachfileid : ""}</AttachFileId>
        <CapturedVidFileName>${AppConfigurationOperations.isValidString(studentResponseModel.capturedvidfilename) ? studentResponseModel.capturedvidfilename : ""}</CapturedVidFileName>
        <CapturedVidId>${AppConfigurationOperations.isValidString(studentResponseModel.capturedvidid) ? studentResponseModel.capturedvidid : ""}</CapturedVidId>
        <CapturedImgFileName>${AppConfigurationOperations.isValidString(studentResponseModel.capturedimgfilename) ? studentResponseModel.capturedimgfilename : ""}</CapturedImgFileName>
        <CapturedImgId>${AppConfigurationOperations.isValidString(studentResponseModel.capturedimgid) ? studentResponseModel.capturedimgid : ""}</CapturedImgId>
      </StudentResponse>
      """;
    });
    // if(studentResponseRequestString.isEmpty) studentResponseRequestString = "<StudentResponse></StudentResponse>";
    //endregion

    String mainRequestString = """
    "<TrackedData>
      $cmiModelRequestString
      $learnerSessionRequestString
      $studentResponseRequestString
    </TrackedData>"
    """;
    // mainRequestString = mainRequestString.replaceAll(" ", "");
    // mainRequestString = mainRequestString.replaceAll("\n", "");

    MyPrint.logOnConsole("mainRequestString:$mainRequestString", tag: tag);

    DataResponseModel<String> dataResponseModel = await repository.UpdateOfflineTrackedData(
      requestModel: UpdateOfflineTrackedDataRequestModel(
        studId: cmiModel.userid.toString(),
        siteID: cmiModel.siteid.toString(),
        scoId: cmiModel.scoid.toString(),
        requestString: mainRequestString,
      ),
    );
    MyPrint.printOnConsole("UpdateOfflineTrackedData Response Status:${dataResponseModel.statusCode}", tag: tag);
    MyPrint.printOnConsole("UpdateOfflineTrackedData Response Data:${dataResponseModel.data}", tag: tag);

    if (dataResponseModel.statusCode != 200 || dataResponseModel.data == "failed") {
      MyPrint.printOnConsole("Course Tracing Update Failed for CmiId:${cmiModel.cmiId}", tag: tag);
      return false;
    }

    if (cmiModel.isJWVideo) {
      MyPrint.printOnConsole("Updating JW Video Time Details Progress", tag: tag);
      DataResponseModel<int> responseModel1 = await CourseLaunchRepository(apiController: repository.apiController).updateJWVideoTimeDetails(
        requestModel: UpdateJWVideoTimeDetailsRequestModel(
          videoID: cmiModel.contentId,
          parentContentID: cmiModel.parentContentId,
          time: "1:46.138005",
          userID: cmiModel.userid,
        ),
      );
      MyPrint.printOnConsole("Updated JW Video Time Details Progress", tag: tag);
      MyPrint.printOnConsole("Response Status Code:${responseModel1.statusCode}", tag: tag);
      MyPrint.printOnConsole("Response Body:${responseModel1.data}", tag: tag);

      MyPrint.printOnConsole("Updating JW Video Progress", tag: tag);
      DataResponseModel<String> responseModel2 = await CourseLaunchRepository(apiController: repository.apiController).updateJWVideoProgress(
        requestModel: UpdateJWVideoProgressRequestModel(
          SiteID: cmiModel.siteid,
          userId: cmiModel.userid,
          SCOID: cmiModel.scoid,
          timeProgress: ParsingHelper.parseIntMethod(cmiModel.percentageCompleted),
        ),
      );
      MyPrint.printOnConsole("Updated JW Video Progress", tag: tag);
      MyPrint.printOnConsole("Response Status Code:${responseModel2.statusCode}", tag: tag);
      MyPrint.printOnConsole("Response Body:${responseModel2.data}", tag: tag);
    }

    MyPrint.printOnConsole("Course Tracing Update Api Succeed", tag: tag);

    MyPrint.printOnConsole("Marking CMI As Updated in Hive", tag: tag);
    bool isUpdatedInOffline = await updateCmiModel(
      requestModel: CourseOfflineLaunchRequestModel(
        SiteId: cmiModel.siteid,
        UserId: cmiModel.userid,
        ScoId: cmiModel.scoid,
        isJWVideo: cmiModel.isJWVideo,
      ),
      onUpdate: ({required CMIModel cmiModel}) => cmiModel,
      isUpdatedOnline: true,
    );
    MyPrint.printOnConsole("isUpdatedInOffline:$isUpdatedInOffline", tag: tag);

    return isUpdatedInOffline;
  }

//endregion

  //region Sync Data to Offline
  Future<void> syncDataToOffline({required List<CourseOfflineLaunchRequestModel> requestModels}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineController().syncDataToOffline() called", tag: tag);

    if (requestModels.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseOfflineController().syncDataToOffline() because requestModels is empty", tag: tag);
      return;
    }

    Map<CourseOfflineLaunchRequestModel, GetCourseTrackingDataResponseModel> courseTrackingDataToUpdate = <CourseOfflineLaunchRequestModel, GetCourseTrackingDataResponseModel>{};

    List<Future> getTrackingDataFutures = <Future>[];

    List<String> keysToUpdate = <String>[];
    for (CourseOfflineLaunchRequestModel requestModel in requestModels) {
      String offlineContentId = CMIModel.getCmiId(siteId: requestModel.SiteId, userId: requestModel.UserId, scoId: requestModel.ScoId);
      keysToUpdate.add(offlineContentId);

      getTrackingDataFutures.add(repository
          .getCourseTrackingData(
        requestModel: GetCourseTrackingDataRequestModel(
          contentId: requestModel.ContentId,
          scoid: requestModel.ScoId,
          trackId: requestModel.ParentContentId,
        ),
      )
          .then((DataResponseModel<GetCourseTrackingDataResponseModel> responseModel) {
        GetCourseTrackingDataResponseModel? model = responseModel.data;

        MyPrint.printOnConsole("Api Success for offlineContentId:'$offlineContentId', Got Response:${model != null}", tag: tag);

        if (model != null) courseTrackingDataToUpdate[requestModel] = model;
      }).catchError((e, s) {
        MyPrint.printOnConsole("Api Failed for offlineContentId:'$offlineContentId', Error:$e", tag: tag);
        MyPrint.printOnConsole(s, tag: tag);
      }));
    }
    MyPrint.printOnConsole("courseTrackingDataToUpdate:$keysToUpdate", tag: tag);

    if (getTrackingDataFutures.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseOfflineController().syncDataToOffline() because getTrackingDataFutures is empty", tag: tag);
      return;
    }

    MyPrint.printOnConsole("Final getTrackingDataFutures length:${getTrackingDataFutures.length}", tag: tag);
    MyPrint.printOnConsole("Waiting for Api Calls to be Completed", tag: tag);
    if (getTrackingDataFutures.isNotEmpty) await Future.wait(getTrackingDataFutures);
    MyPrint.printOnConsole("Api Calls Completed", tag: tag);

    List<String> finalKeysToUpdate = courseTrackingDataToUpdate.keys.map((e) => CMIModel.getCmiId(siteId: e.SiteId, userId: e.UserId, scoId: e.ScoId)).toList();
    MyPrint.printOnConsole("Final courseTrackingDataToUpdate:$finalKeysToUpdate", tag: tag);

    if (finalKeysToUpdate.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseOfflineController().syncDataToOffline() because finalKeysToUpdate is empty", tag: tag);
      return;
    }

    List<Future> databaseUpdateFuture = <Future>[];

    courseTrackingDataToUpdate.forEach((CourseOfflineLaunchRequestModel requestModel, GetCourseTrackingDataResponseModel responseModel) {
      CMIModel? cmiModel = responseModel.cmi.firstElement;
      cmiModel?.isJWVideo = requestModel.isJWVideo;

      databaseUpdateFuture.addAll([
        setCmiModelFromRequestModel(requestModel: requestModel, cmiModel: cmiModel),
        setLearnerSessionModelFromRequestModel(
          requestModel: requestModel,
          courseLearnerSessionModel: CourseLearnerSessionResponseModel(
            id: CourseLearnerSessionResponseModel.getCourseLearnerSessionId(siteId: requestModel.SiteId, userId: requestModel.UserId, scoId: requestModel.ScoId),
            siteId: requestModel.SiteId,
            userId: requestModel.UserId,
            scoId: requestModel.ScoId,
            learnerSessionsResponseMap: Map<int, LearnerSessionModel>.fromEntries(responseModel.learnersession.map((e) => MapEntry(e.attemptnumber, e))),
          ),
        ),
        setStudentResponseModelFromRequestModel(
          requestModel: requestModel,
          studentCourseResponseModel: StudentCourseResponseModel(
            id: StudentCourseResponseModel.getStudentCourseResponseId(siteId: requestModel.SiteId, userId: requestModel.UserId, scoId: requestModel.ScoId),
            siteId: requestModel.SiteId,
            userId: requestModel.UserId,
            scoId: requestModel.ScoId,
            questionResponseMap: Map.fromEntries(responseModel.studentresponse.map((e) => MapEntry(e.questionid, e)).toList()),
          ),
        ),
      ]);
    });

    if (databaseUpdateFuture.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseOfflineController().syncDataToOffline() because databaseUpdateFuture is empty", tag: tag);
      return;
    }

    MyPrint.printOnConsole("Final databaseUpdateFuture length:${databaseUpdateFuture.length}", tag: tag);
    MyPrint.printOnConsole("Waiting for Database Calls to be Completed", tag: tag);
    if (databaseUpdateFuture.isNotEmpty) await Future.wait(databaseUpdateFuture);
    MyPrint.printOnConsole("Database Calls Completed", tag: tag);
  }

//endregion

  Future<void> updateContentProgressInOfflineAndDownloadWithTrackProgress({
    required String ContentId,
    required String CoreLessonStatus,
    required String ContentDisplayStatus,
    required double contentProgress,
    required String ParentContentId,
    required int ParentContentTypeId,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
        "CourseOfflineController().updateContentProgressInOfflineAndDownloadWithTrackProgress() called with ContentId:'$ContentId', CoreLessonStatus:'$CoreLessonStatus',"
        " ContentDisplayStatus:'$ContentDisplayStatus', contentProgress:$contentProgress, ParentContentId:'$ParentContentId', ParentContentTypeId:$ParentContentTypeId",
        tag: tag);

    BuildContext context = AppController.mainAppContext!;
    AppProvider appProvider = context.read<AppProvider>();
    CourseDownloadProvider courseDownloadProvider = context.read<CourseDownloadProvider>();
    CourseDownloadController courseDownloadController = CourseDownloadController(appProvider: appProvider, courseDownloadProvider: courseDownloadProvider);

    bool isUpdatedInDownload = await courseDownloadController.updateCourseDownloadTrackingProgress(
      contentId: ContentId,
      parentContentId: ParentContentId,
      coreLessonStatus: CoreLessonStatus,
      displayStatus: ContentDisplayStatus,
      contentProgress: contentProgress,
    );
    MyPrint.printOnConsole("isUpdatedInDownload:$isUpdatedInDownload", tag: tag);

    MyPrint.printOnConsole("Main Course Operations Done", tag: tag);

    if (ParentContentId.isNotEmpty && [InstancyObjectTypes.track, InstancyObjectTypes.events].contains(ParentContentTypeId)) {
      List<Future> futures = <Future>[];

      EventTrackHiveRepository eventTrackHiveRepository = EventTrackHiveRepository(apiController: ApiController());

      Map<String, TrackCourseDTOModel> trackContentsList = <String, TrackCourseDTOModel>{};
      Map<String, RelatedTrackDataDTOModel> eventRelatedContentsList = <String, RelatedTrackDataDTOModel>{};

      // region Update Course Progress Data in Event Track Contents Offline List
      //For Track Contents
      if (ParentContentTypeId == InstancyObjectTypes.track) {
        bool isCourseProgressUpdated = false;
        bool isAssignmentContent = false;

        TrackListViewDataResponseModel? trackListViewDataResponseModel = await eventTrackHiveRepository.getTrackContentDataForTrackId(trackId: ParentContentId);
        if (trackListViewDataResponseModel != null) {
          TrackCourseDTOModel? trackCourseDTOModel;
          for (TrackDTOModel trackDTOModel in trackListViewDataResponseModel.TrackListData) {
            for (TrackCourseDTOModel model in trackDTOModel.TrackList) {
              trackContentsList[model.ContentID] = model;

              if (model.ContentID == ContentId) {
                trackCourseDTOModel = model;
                isAssignmentContent = false;
              }
            }
          }

          if (trackCourseDTOModel != null) {
            trackCourseDTOModel.CoreLessonStatus = CoreLessonStatus;
            trackCourseDTOModel.ContentStatus = ContentDisplayStatus;
            trackCourseDTOModel.ContentProgress = contentProgress.toString();
            isCourseProgressUpdated = true;
          }
        }

        TrackListViewDataResponseModel? assignmentTrackListViewDataResponseModel = await eventTrackHiveRepository.getTrackAssignmentDataForTrackId(trackId: ParentContentId);
        if (assignmentTrackListViewDataResponseModel != null) {
          TrackCourseDTOModel? trackCourseDTOModel;
          for (TrackDTOModel trackDTOModel in assignmentTrackListViewDataResponseModel.TrackListData) {
            for (TrackCourseDTOModel model in trackDTOModel.TrackList) {
              trackContentsList[model.ContentID] = model;

              if (model.ContentID == ContentId) {
                trackCourseDTOModel = model;
                isAssignmentContent = true;
              }
            }
          }

          if (trackCourseDTOModel != null) {
            trackCourseDTOModel.CoreLessonStatus = CoreLessonStatus;
            trackCourseDTOModel.ContentStatus = ContentDisplayStatus;
            trackCourseDTOModel.ContentProgress = contentProgress.toString();
            isCourseProgressUpdated = true;
          }
        }

        if (isCourseProgressUpdated && (trackListViewDataResponseModel != null || assignmentTrackListViewDataResponseModel != null)) {
          if (isAssignmentContent) {
            futures.add(eventTrackHiveRepository.addTrackAssignmentDataInBox(trackContentData: {ParentContentId: assignmentTrackListViewDataResponseModel!}, isClear: false));
          } else {
            futures.add(eventTrackHiveRepository.addTrackContentsDataInBox(trackContentData: {ParentContentId: trackListViewDataResponseModel!}, isClear: false));
          }
        }
      }
      //For Event Related Contents
      else {
        bool isCourseProgressUpdated = false;
        bool isAssignmentContent = false;

        ResourceContentDTOModel? resourceContentDTOModel = await eventTrackHiveRepository.getEventRelatedContentDataForEventId(eventId: ParentContentId);
        if (resourceContentDTOModel != null) {
          RelatedTrackDataDTOModel? relatedTrackDataDTOModel;
          for (RelatedTrackDataDTOModel model in resourceContentDTOModel.ResouseList) {
            eventRelatedContentsList[model.ContentID] = model;

            if (model.ContentID == ContentId) {
              relatedTrackDataDTOModel = model;
              isAssignmentContent = false;
            }
          }

          if (relatedTrackDataDTOModel != null) {
            relatedTrackDataDTOModel.CoreLessonStatus = CoreLessonStatus;
            relatedTrackDataDTOModel.ContentDisplayStatus = ContentDisplayStatus;
            relatedTrackDataDTOModel.PercentCompleted = contentProgress;
            isCourseProgressUpdated = true;
          }
        }

        ResourceContentDTOModel? assignmentResourceContentDTOModel = await eventTrackHiveRepository.getEventRelatedContentDataForEventId(eventId: ParentContentId);
        if (assignmentResourceContentDTOModel != null) {
          RelatedTrackDataDTOModel? relatedTrackDataDTOModel;
          for (RelatedTrackDataDTOModel model in assignmentResourceContentDTOModel.ResouseList) {
            eventRelatedContentsList[model.ContentID] = model;

            if (model.ContentID == ContentId) {
              relatedTrackDataDTOModel = model;
              isAssignmentContent = true;
            }
          }

          if (relatedTrackDataDTOModel != null) {
            relatedTrackDataDTOModel.CoreLessonStatus = CoreLessonStatus;
            relatedTrackDataDTOModel.ContentDisplayStatus = ContentDisplayStatus;
            relatedTrackDataDTOModel.PercentCompleted = contentProgress;
            isCourseProgressUpdated = true;
          }
        }

        if (isCourseProgressUpdated && (resourceContentDTOModel != null || assignmentResourceContentDTOModel != null)) {
          if (isAssignmentContent) {
            futures.add(eventTrackHiveRepository.addEventRelatedAssignmentDataInBox(eventRelatedContentData: {ParentContentId: assignmentResourceContentDTOModel!}, isClear: false));
          } else {
            futures.add(eventTrackHiveRepository.addEventRelatedContentDataInBox(eventRelatedContentData: {ParentContentId: resourceContentDTOModel!}, isClear: false));
          }
        }
      }
      // endregion

      // region Update Main Event Track Progress
      if (trackContentsList.isNotEmpty) {
        double totalProgress = 0;
        double currentProgress = 0;

        if (trackContentsList.isNotEmpty) {
          for (TrackCourseDTOModel trackCourseDTOModel in trackContentsList.values) {
            totalProgress += 100;
            currentProgress += ParsingHelper.parseDoubleMethod(trackCourseDTOModel.ContentProgress);
          }
        }

        MyPrint.printOnConsole("currentProgress:$currentProgress", tag: tag);
        MyPrint.printOnConsole("totalProgress:$totalProgress", tag: tag);

        double percentageCompleted = (100 * currentProgress) / totalProgress;
        if (percentageCompleted == double.infinity) {
          percentageCompleted = 0;
        } else if (percentageCompleted < 0) {
          percentageCompleted = 0;
        } else if (percentageCompleted > 100) {
          percentageCompleted = 100;
        }

        String contentStatus = "";
        String actualStatus = "";
        if (percentageCompleted == 0) {
          contentStatus = "Not Started";
          actualStatus = ContentStatusTypes.notAttempted;
        } else if (percentageCompleted == 100) {
          contentStatus = "Completed";
          actualStatus = ContentStatusTypes.completed;
        } else {
          contentStatus = "In Progress";
          actualStatus = ContentStatusTypes.incomplete;
        }

        futures.add(courseDownloadController.updateEventTrackParentModelInDownloadsAndHeaderModel(
          eventTrackContentId: ParentContentId,
          PercentageCompleted: percentageCompleted,
          CoreLessonStatus: actualStatus,
          DisplayStatus: contentStatus,
        ));
      }
      // endregion

      if (futures.isNotEmpty) {
        await Future.wait(futures);
      }
    }
  }
}
