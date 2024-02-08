import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/backend/course_offline/course_offline_provider.dart';
import 'package:flutter_instancy_2/backend/course_offline/course_offline_repository.dart';
import 'package:flutter_instancy_2/backend/network_connection/network_connection_controller.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/common/data_response_model.dart';
import 'package:flutter_instancy_2/models/course_offline/data_model/cmi_model.dart';
import 'package:flutter_instancy_2/models/course_offline/data_model/learner_session_model.dart';
import 'package:flutter_instancy_2/models/course_offline/data_model/student_response_model.dart';
import 'package:flutter_instancy_2/models/course_offline/request_model/course_offline_launch_request_model.dart';
import 'package:flutter_instancy_2/models/course_offline/response_model/student_course_response_model.dart';
import 'package:flutter_instancy_2/utils/date_representation.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/views/course_offline/request_model/update_offline_tracked_data_request_model.dart';

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
    LearnerSessionModel? learnerSessionModel;
    StudentCourseResponseModel? studentCourseResponseModel;

    await Future.wait([
      getCmiModelFromRequestModel(requestModel: requestModel).then((CMIModel? model) {
        cmiModel = model;
      }),
      getLearnerSessionModelFromRequestModel(requestModel: requestModel).then((LearnerSessionModel? model) {
        learnerSessionModel = model;
      }),
      getStudentResponseModelFromRequestModel(requestModel: requestModel).then((StudentCourseResponseModel? model) {
        studentCourseResponseModel = model;
      }),
    ]);

    List<Future> futures = [];
    String currentDateTime = getCurrentDateTime();
    int attempt = learnerSessionModel == null ? 1 : (learnerSessionModel!.attemptnumber + 1);
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
        status: ContentStatusTypes.incomplete,
        siteurl: ApiController().apiDataProvider.getCurrentSiteUrl(),
      );
      futures.add(setCmiModelFromRequestModel(requestModel: requestModel, cmiModel: cmiModel));
    } else {
      MyPrint.printOnConsole("CmiModel Exist, Updating noofattempts", tag: tag);

      futures.add(updateCmiModel(
          requestModel: requestModel,
          onUpdate: ({required CMIModel cmiModel}) {
            cmiModel.noofattempts = attempt;
            return cmiModel;
          }));
    }

    if (learnerSessionModel == null) {
      MyPrint.printOnConsole("LearnerSessionModel Not Exist, Creating", tag: tag);

      String learnerSessionId = LearnerSessionModel.getLearnerSessionId(siteId: requestModel.SiteId, userId: requestModel.UserId, scoId: requestModel.ScoId);

      learnerSessionModel = LearnerSessionModel(
        learnerSessionID: learnerSessionId,
        scoid: requestModel.ScoId,
        siteid: requestModel.SiteId,
        userid: requestModel.UserId,
        attemptnumber: attempt,
        sessiondatetime: currentDateTime,
      );
      futures.add(setLearnerSessionModelFromRequestModel(requestModel: requestModel, learnerSessionModel: learnerSessionModel));
    } else {
      MyPrint.printOnConsole("LearnerSessionModel Exist, Updating attemptnumber", tag: tag);

      futures.add(updateLearnerSession(
          requestModel: requestModel,
          onUpdate: ({required LearnerSessionModel learnerSessionModel}) {
            learnerSessionModel.attemptnumber = attempt;
            return learnerSessionModel;
          }));
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
        lloc = cmiModel!.location;
        lstatus = cmiModel!.status;
        susdata = cmiModel!.suspenddata;
        score = cmiModel!.score;
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
              "${AppConfigurationOperations.isValidString(studentResponseModel.optionalNotes) ? "${studentResponseModel.optionalNotes}@" : ""}"
              "${AppConfigurationOperations.isValidString(studentResponseModel.attachfilename) ? "${studentResponseModel.attachfilename}@" : ""}"
              "${AppConfigurationOperations.isValidString(studentResponseModel.attachfileid) ? "${studentResponseModel.attachfileid}@" : ""}"
              "${AppConfigurationOperations.isValidString(studentResponseModel.capturedVidFileName) ? "${studentResponseModel.capturedVidFileName}@" : ""}"
              "${AppConfigurationOperations.isValidString(studentResponseModel.capturedVidId) ? "${studentResponseModel.capturedVidId}@" : ""}"
              "${AppConfigurationOperations.isValidString(studentResponseModel.capturedImgFileName) ? "${studentResponseModel.capturedImgFileName}@" : ""}"
              "${AppConfigurationOperations.isValidString(studentResponseModel.capturedImgFileName) ? "${studentResponseModel.capturedImgFileName}@" : ""}"
              "${AppConfigurationOperations.isValidString(studentResponseModel.capturedImgId) ? "${studentResponseModel.capturedImgId}@" : ""}";

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
      MyPrint.printOnConsole("cmiModel:$cmiModel", tag: tag);
      await setCmiModelFromRequestModel(requestModel: requestModel, cmiModel: cmiModel);
      isSuccess = true;
    }

    MyPrint.printOnConsole("isSuccess:$isSuccess", tag: tag);
    return isSuccess;
  }

  Future<bool> updateLearnerSession({required CourseOfflineLaunchRequestModel requestModel, LearnerSessionModel Function({required LearnerSessionModel learnerSessionModel})? onUpdate}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineController().updateLearnerSession() called with requestModel:$requestModel", tag: tag);

    bool isSuccess = false;

    LearnerSessionModel? learnerSessionModel = await getLearnerSessionModelFromRequestModel(requestModel: requestModel);

    if (learnerSessionModel == null) {
      MyPrint.printOnConsole("Returning from CourseOfflineController().updateLearnerSession() because LearnerSessionModel not exist", tag: tag);
      return isSuccess;
    }

    if (onUpdate != null) {
      learnerSessionModel = onUpdate(learnerSessionModel: learnerSessionModel);
      MyPrint.printOnConsole("learnerSessionModel:$learnerSessionModel", tag: tag);
      await setLearnerSessionModelFromRequestModel(requestModel: requestModel, learnerSessionModel: learnerSessionModel);
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

      MyPrint.printOnConsole("Adding cmiModel in Hive and Provider", tag: tag);
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
  Future<LearnerSessionModel?> getLearnerSessionModelFromRequestModel({required CourseOfflineLaunchRequestModel requestModel, bool isRefresh = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineController().getLearnerSessionModelFromRequestModel() called with requestModel:$requestModel, isRefresh:$isRefresh", tag: tag);

    String learnerSessionId = LearnerSessionModel.getLearnerSessionId(siteId: requestModel.SiteId, userId: requestModel.UserId, scoId: requestModel.ScoId);
    LearnerSessionModel? learnerSessionModel = provider.learnerSessionData.getMap(isNewInstance: false)[learnerSessionId];
    MyPrint.printOnConsole("LearnerSessionModel is not null from Provider:${learnerSessionModel != null}", tag: tag);

    if (isRefresh || learnerSessionModel == null) {
      MyPrint.printOnConsole("Getting LearnerSessionModel From Hive", tag: tag);
      learnerSessionModel = (await repository.getLearnerSessionsById(learnerSessionIds: [learnerSessionId]))[learnerSessionId];
      MyPrint.printOnConsole("LearnerSessionModel is not null from Hive:${learnerSessionModel != null}", tag: tag);

      if (learnerSessionModel != null) {
        provider.learnerSessionData.setMap(map: {learnerSessionId: learnerSessionModel}, isClear: false, isNotify: false);
      } else {
        provider.learnerSessionData.clearKey(key: learnerSessionId, isNotify: false);
      }
    }

    return learnerSessionModel != null ? LearnerSessionModel.fromMap(learnerSessionModel.toMap()) : null;
  }

  Future<void> setLearnerSessionModelFromRequestModel({required CourseOfflineLaunchRequestModel requestModel, LearnerSessionModel? learnerSessionModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineController().setLearnerSessionModelFromRequestModel() called with requestModel:$requestModel, learnerSessionModel not null:${learnerSessionModel != null}",
        tag: tag);

    String learnerSessionId = LearnerSessionModel.getLearnerSessionId(siteId: requestModel.SiteId, userId: requestModel.UserId, scoId: requestModel.ScoId);
    if (learnerSessionModel == null) {
      MyPrint.printOnConsole("Removing LearnerSessionModel From Hive and Provider", tag: tag);
      provider.learnerSessionData.clearKey(key: learnerSessionId, isNotify: false);
      await repository.removeRecordsFromLearnerSessionBoxById(learnerSessionIds: [learnerSessionId]);
    } else {
      learnerSessionModel.scoid = requestModel.ScoId;
      learnerSessionModel.siteid = requestModel.SiteId;
      learnerSessionModel.userid = requestModel.UserId;

      MyPrint.printOnConsole("Adding LearnerSessionModel in Hive and Provider", tag: tag);
      provider.learnerSessionData.setMap(map: {learnerSessionId: learnerSessionModel}, isClear: false, isNotify: false);
      await repository.addLearnerSessionModelsInBox(learnerSessionsData: {learnerSessionId: learnerSessionModel}, isClear: false);
    }

    MyPrint.printOnConsole("Setted LearnerSessionModel in Hive and Provider Successfully", tag: tag);
  }

  Future<Map<String, LearnerSessionModel>> getAllLearnerSessionModels({bool isRefresh = true, bool isNewInstance = true}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineController().getAllLearnerSessionModels() called with isRefresh:$isRefresh, isNewInstance:$isNewInstance", tag: tag);

    if (isRefresh || provider.learnerSessionData.length == 0) {
      Map<String, LearnerSessionModel> learnerSessionData = await repository.getAllLearnerSessionModels();
      provider.learnerSessionData.setMap(map: learnerSessionData, isClear: true, isNotify: false);
    }

    return provider.learnerSessionData.getMap(isNewInstance: isNewInstance);
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
    return DatePresentation.getFormattedDate(dateFormat: "yyyy-MM-dd HH:mm:ss", dateTime: DateTime.now()) ?? "";
  }

  //region Sync Data Online
  Future<void> syncCourseDataOnline() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineController().syncCourseDataOnline() called", tag: tag);

    if (!NetworkConnectionController().checkConnection()) {
      MyPrint.printOnConsole("Returning from CourseOfflineController().syncCourseDataOnline() because No Internet Connection Available", tag: tag);
      return;
    }

    Map<String, CMIModel> cmiModels = await getAllCmiModels(isRefresh: true, isNewInstance: true);
    Map<String, LearnerSessionModel> learnerSessionModels = await getAllLearnerSessionModels(isRefresh: true, isNewInstance: true);
    Map<String, StudentCourseResponseModel> studentCourseResponseModels = await getAllStudentResponseModels(isRefresh: true, isNewInstance: true);

    cmiModels.removeWhere((key, value) => value.isupdate != "false");

    MyPrint.printOnConsole("Final CmiModels To Update:${cmiModels.keys.toList()}", tag: tag);

    List<Future> future = <Future>[];

    cmiModels.forEach((String cmiId, CMIModel cmiModel) {
      syncDataForContent(
        cmiModel: cmiModel,
        learnerSessionModel: learnerSessionModels[LearnerSessionModel.getLearnerSessionId(
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
    });

    if (future.isNotEmpty) await Future.wait(future);

    MyPrint.printOnConsole("Synced All Course Tracking Data To Online", tag: tag);
  }

  Future<bool> syncDataForContent({required CMIModel cmiModel, required LearnerSessionModel? learnerSessionModel, StudentCourseResponseModel? studentCourseResponseModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineController().syncDataForContent() called with cmiModel:$cmiModel", tag: tag);

    String userId = cmiModel.userid.toString();

    //region CMI Model Request String
    String cmiModelRequestString = """
    <CMI>
      <ID></ID>
      <UserID>$userId</UserID>
      <SCOID>${cmiModel.scoid}</SCOID>
      <CoreLessonStatus>${AppConfigurationOperations.isValidString(cmiModel.status) ? cmiModel.status : ""}</CoreLessonStatus>
      <CoreLessonLocation>${AppConfigurationOperations.isValidString(cmiModel.location) ? cmiModel.location : ""}</CoreLessonLocation>
      <SuspendData>${AppConfigurationOperations.isValidString(cmiModel.suspenddata) ? cmiModel.suspenddata.replaceAll("%23", "#") : ""}</SuspendData>
      <DateCompleted>${AppConfigurationOperations.isValidString(cmiModel.datecompleted) ? cmiModel.datecompleted : ""}</DateCompleted>
      <NoOfAttempts>${cmiModel.noofattempts}</NoOfAttempts>
      <TrackScoID>${cmiModel.parentScoId}</TrackScoID>
      <TrackContentID>${cmiModel.parentContentId}</TrackContentID>
      <TrackObjectTypeID>${cmiModel.parentObjTypeId}</TrackObjectTypeID>
      <OrgUnitID>${cmiModel.siteid}</OrgUnitID>
      <Score>${ParsingHelper.parseIntMethod(cmiModel.score)}</Score>
      <PercentCompleted>${AppConfigurationOperations.isValidString(cmiModel.percentageCompleted) ? cmiModel.percentageCompleted : ""}</PercentCompleted>
      <ObjectTypeId>${cmiModel.objecttypeid}</ObjectTypeId>
      <SequenceNumber>${cmiModel.sequencenumber}</SequenceNumber>
      <AttemptsLeft>${cmiModel.attemptsleft}</AttemptsLeft>
      <CoreLessonMode>${cmiModel.coursemode}</CoreLessonMode>
      <ScoreMin>${cmiModel.scoremin}</ScoreMin>
      <ScoreMax>${cmiModel.scoremax}</ScoreMax>
      <RandomQuestionNos>${cmiModel.randomquesseq}</RandomQuestionNos>
      <TextResponses>${cmiModel.textResponses}</TextResponses>
      <PooledQuestionNos>${cmiModel.pooledquesseq}</PooledQuestionNos>
    </CMI>
    """;
    //endregion

    //region Learner Session Request String
    String learnerSessionRequestString = """""";
    if (learnerSessionModel != null) {
      learnerSessionRequestString = """
      <SessionID></SessionID>
      <UserID>$userId</UserID>
      <SCOID>${learnerSessionModel.scoid}</SCOID>
      <AttemptNumber>${learnerSessionModel.attemptnumber}</AttemptNumber>
      <SessionDateTime>${learnerSessionModel.sessiondatetime}</SessionDateTime>
      <TimeSpent>${AppConfigurationOperations.isValidString(learnerSessionModel.timespent) ? learnerSessionModel.timespent : ""}</TimeSpent>
      """;
    }
    learnerSessionRequestString = "<LearnerSession>$learnerSessionRequestString</LearnerSession>";
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
        <OptionalNotes>${studentResponseModel.optionalNotes}</OptionalNotes>
        <AttachFileName>${AppConfigurationOperations.isValidString(studentResponseModel.attachfilename) ? studentResponseModel.attachfilename : ""}</AttachFileName>
        <AttachFileId>${AppConfigurationOperations.isValidString(studentResponseModel.attachfileid) ? studentResponseModel.attachfileid : ""}</AttachFileId>
        <CapturedVidFileName>${AppConfigurationOperations.isValidString(studentResponseModel.capturedVidFileName) ? studentResponseModel.capturedVidFileName : ""}</CapturedVidFileName>
        <CapturedVidId>${AppConfigurationOperations.isValidString(studentResponseModel.capturedVidId) ? studentResponseModel.capturedVidId : ""}</CapturedVidId>
        <CapturedImgFileName>${AppConfigurationOperations.isValidString(studentResponseModel.capturedImgFileName) ? studentResponseModel.capturedImgFileName : ""}</CapturedImgFileName>
        <CapturedImgId>${AppConfigurationOperations.isValidString(studentResponseModel.capturedImgId) ? studentResponseModel.capturedImgId : ""}</CapturedImgId>
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

    MyPrint.printOnConsole("Course Tracing Update Api Succeed", tag: tag);

    MyPrint.printOnConsole("Marking CMI As Updated in Hive", tag: tag);
    bool isUpdatedInOffline = await updateCmiModel(
      requestModel: CourseOfflineLaunchRequestModel(
        SiteId: cmiModel.siteid,
        UserId: cmiModel.userid,
        ScoId: cmiModel.scoid,
      ),
      onUpdate: ({required CMIModel cmiModel}) => cmiModel,
      isUpdatedOnline: true,
    );
    MyPrint.printOnConsole("isUpdatedInOffline:$isUpdatedInOffline", tag: tag);

    return isUpdatedInOffline;
  }
//endregion
}
