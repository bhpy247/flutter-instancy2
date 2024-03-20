import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_instancy_2/backend/app/app_controller.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/authentication/authentication_provider.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_controller.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_provider.dart';
import 'package:flutter_instancy_2/backend/course_offline/course_offline_controller.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/course_launch/data_model/course_launch_model.dart';
import 'package:flutter_instancy_2/models/course_offline/data_model/cmi_model.dart';
import 'package:flutter_instancy_2/models/course_offline/data_model/student_response_model.dart';
import 'package:flutter_instancy_2/models/course_offline/request_model/course_offline_launch_request_model.dart';
import 'package:flutter_instancy_2/models/course_offline/response_model/course_learner_session_response_model.dart';
import 'package:flutter_instancy_2/models/course_offline/response_model/student_course_response_model.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:flutter_instancy_2/views/common/components/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../../../../backend/navigation/navigation.dart';

class CourseOfflineLaunchWebViewScreen extends StatefulWidget {
  static const String routeName = "/CourseOfflineLaunchWebViewScreen";

  final CourseOfflineLaunchWebViewScreenNavigationArguments arguments;

  const CourseOfflineLaunchWebViewScreen({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  State<CourseOfflineLaunchWebViewScreen> createState() => _CourseOfflineLaunchWebViewScreenState();
}

class _CourseOfflineLaunchWebViewScreenState extends State<CourseOfflineLaunchWebViewScreen> with MySafeState {
  late CourseLaunchModel courseLaunchModel;
  late CourseOfflineLaunchRequestModel courseOfflineLaunchRequestModel;

  CourseOfflineController courseOfflineController = CourseOfflineController();

  late CourseDownloadProvider courseDownloadProvider;
  late CourseDownloadController courseDownloadController;

  InAppWebViewController? webViewController;

  late String coursePath;
  bool isPageLoaded = false;

  late Future<bool> initializationsFuture;

  bool isReloadedOnce = false;
  bool isCourseCloseCalled = false;

  Future<bool> initializations() async {
    bool isFileExist = await AppController.checkCourseFileDirectoryExist(path: coursePath);
    MyPrint.printOnConsole("isFileExist:$isFileExist");

    if (isFileExist) {
      List<Future> futures = <Future>[
        courseOfflineController.checkCourseTrackingInitialization(requestModel: courseOfflineLaunchRequestModel),
      ];

      if (defaultTargetPlatform == TargetPlatform.android) {
        futures.add(InAppWebViewController.setWebContentsDebuggingEnabled(true));
      }

      if (futures.isNotEmpty) await Future.wait(futures);

      String queryParams = await courseOfflineController.generateQueryParametersForOfflineCourseLaunch(requestModel: courseOfflineLaunchRequestModel);
      MyPrint.printOnConsole("queryParams:$queryParams");

      queryParams = queryParams.replaceAll("#", "%23");
      MyPrint.printOnConsole("updated queryParams:$queryParams");

      // file:///storage/emulated/0/Android/data/com.instancy.qalearning/files/.Mydownloads/Contentdownloads/990c0f7f-adc8-4a3c-bd13-a7de0cc41042-1945/start.html?cid=22300&stid=1947&lloc=4&lstatus=In progress&susdata=%23pgvs_start%231;2;3;4;%23pgvs_end%23&quesdata=1@4@correct@$2@1@correct@$3@1@correct@$4@2@correct@&sname=&IsInstancyContent=true&nativeappURL=true

      if (queryParams.isNotEmpty) coursePath = "file://$coursePath?$queryParams";
    }

    return isFileExist;
  }

  bool isFullScreen() {
    MyPrint.printOnConsole("contentTypeId:${widget.arguments.contentTypeId}");
    if (kIsWeb) {
      return false;
    }
    if ([InstancyObjectTypes.contentObject, InstancyObjectTypes.assessment, InstancyObjectTypes.track].contains(widget.arguments.contentTypeId)) {
      return true;
    } else {
      return false;
    }
  }

  void onLoadStartHandler(InAppWebViewController controller, WebUri? webUri) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("InApp Webview On Load Start:$webUri", tag: tag);
    // file:///storage/emulated/0/Android/data/com.instancy.qalearning2/files/CourseDownloads/qalearning.instancy.com/1962/fb07e160-065a-49ce-bd47-fa39fe7163fc/blank.html?IOSCourseClose=true&cid=25381&stid=1962&lloc=8&lstatus=passed&susdata=#pgvs_start%231;2;3;4;5;6;7;8;%23pgvs_end%23&timespent=00:00:23.66&quesdata=&score=100

    await controller.injectJavascriptFileFromAsset(assetFilePath: 'assets/js/main.js');

    String path = Uri.decodeFull(webUri?.toString() ?? "").toLowerCase();
    MyPrint.printOnConsole("path:$path", tag: tag);
    // file:///storage/emulated/0/android/data/com.instancy.qalearning2/files/coursedownloads/qalearning.instancy.com/1962/fb07e160-065a-49ce-bd47-fa39fe7163fc/blank.html?ioscourseclose=true&cid=25381&stid=1962&lloc=8&lstatus=passed&susdata=#pgvs_start#1;2;3;4;5;6;7;8;#pgvs_end#&timespent=00:00:23.66&quesdata=&score=100

    if (path.isNotEmpty && (path.contains("coursetracking/savecontenttrackeddata1") || path.contains("blank.html?ioscourseclose=true"))) {
      Map<String, String> queryParams = getQueryParameters(path);

      if (queryParams.isNotEmpty) {
        MyPrint.printOnConsole("queryParams in onLoadStartHandler:$queryParams", tag: tag);
        // {ioscourseclose: true, cid: 25381, stid: 1962, lloc: 8, lstatus: passed, susdata: #pgvs_start#1;2;3;4;5;6;7;8;#pgvs_end#, timespent: 00:00:23.66, quesdata: , score: 100}

        String timespent = ParsingHelper.parseStringMethod(queryParams['timespent'], defaultValue: "00:00:00");
        String status = ParsingHelper.parseStringMethod(queryParams['lstatus']);
        String suspenddata = ParsingHelper.parseStringMethod(queryParams['susdata']);
        String score = ParsingHelper.parseStringMethod(queryParams['score']);
        String lloc = ParsingHelper.parseStringMethod(queryParams['lloc']);
        String quesdata = ParsingHelper.parseStringMethod(queryParams['quesdata']);

        List<Future> futures = [
          courseOfflineController.updateCmiModel(
            requestModel: courseOfflineLaunchRequestModel,
            onUpdate: ({required CMIModel cmiModel}) {
              cmiModel.totalsessiontime = timespent;

              cmiModel.suspenddata = suspenddata;

              cmiModel.scoreraw = score;
              cmiModel.corelessonlocation = lloc;
              cmiModel.corelessonstatus = status;

              String dateCompleted = '';
              if ([ContentStatusTypes.completed, ContentStatusTypes.passed, ContentStatusTypes.failed].contains(status)) {
                dateCompleted = courseOfflineController.getCurrentDateTime();
                cmiModel.percentageCompleted = "100";
              }
              MyPrint.printOnConsole("dateCompleted:$dateCompleted", tag: tag);
              cmiModel.datecompleted = dateCompleted;

              return cmiModel;
            },
          ),
          courseOfflineController.updateLearnerSession(
            requestModel: courseOfflineLaunchRequestModel,
            onUpdate: ({required CourseLearnerSessionResponseModel courseLearnerSessionModel}) {
              courseLearnerSessionModel.getLastLearnerSessionModel()?.timespent = timespent;

              return courseLearnerSessionModel;
            },
          ),
          updateQuestionData(questionData: quesdata),
        ];

        await Future.wait(futures);
        await updateCourseProgress(coreLessonStatus: status);
      }

      if (!isCourseCloseCalled && context.mounted) {
        isCourseCloseCalled = true;
        Navigator.pop(context, true);
      }
    }
  }

  Map<String, String> getQueryParameters(String path) {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineLaunchWebViewScreen().getQueryParameters() called with path:'$path'", tag: tag);

    Map<String, String> queryParams = <String, String>{};
    if (path.contains("?")) {
      path = path.substring(path.indexOf("?"));
      path = path.replaceAll("?", "");

      List<String> parameters = path.split("&");
      for (String parameterString in parameters) {
        List<String> values = parameterString.split("=");
        if (values.isNotEmpty) {
          queryParams[values.first] = values.elementAtOrNull(1) ?? "";
        }
      }
    }
    MyPrint.printOnConsole("Final queryParams:$queryParams", tag: tag);

    return queryParams;
  }

  void addJSHandlers(InAppWebViewController controller) {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineLaunchWebViewScreen().addJSHandlers() called", tag: tag);

    controller.addJavaScriptHandler(
      handlerName: 'hideNativeContentLoader',
      callback: (args) {
        MyPrint.printOnConsole('hideNativeContentLoader called with args: $args', tag: tag);
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'OnLineCourseClose',
      callback: (args) async {
        MyPrint.printOnConsole('OnLineCourseClose called with args: $args', tag: tag);
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'LMSSetRandomQuestionNosWithRandomqusseq',
      callback: (args) {
        MyPrint.printOnConsole('LMSSetRandomQuestionNosWithRandomqusseq called with args: $args', tag: tag);
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'AddOfflineAttachementWithQuesid',
      callback: (args) {
        MyPrint.printOnConsole('AddOfflineAttachementWithQuesid called with args: $args', tag: tag);
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'LMSGetRandomQuestionNos',
      callback: (args) {
        MyPrint.printOnConsole('LMSGetRandomQuestionNos called with args: $args', tag: tag);
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'PlayAudioWithSrcStatus',
      callback: (args) {
        MyPrint.printOnConsole('PlayAudioWithSrcStatus called with args: $args', tag: tag);
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'saveUserPageNotesWithContentIDPageIDSequenceIDUserNotesTextNoteCountIsType',
      callback: (args) {
        MyPrint.printOnConsole('saveUserPageNotesWithContentIDPageIDSequenceIDUserNotesTextNoteCountIsType called with args: $args', tag: tag);
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'DeletePageNoteWithContentIDPageIDNoteCount',
      callback: (args) {
        MyPrint.printOnConsole('DeletePageNoteWithContentIDPageIDNoteCount called with args: $args', tag: tag);
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'GetUserPageNotesWithContentIDPageID',
      callback: (args) {
        MyPrint.printOnConsole('GetUserPageNotesWithContentIDPageID called with args: $args', tag: tag);
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'GetUserTextResponsesWithSeqIDUserID',
      callback: (args) {
        MyPrint.printOnConsole('GetUserTextResponsesWithSeqIDUserID called with args: $args', tag: tag);
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'getPercentCompleted',
      callback: (args) {
        MyPrint.printOnConsole('getPercentCompleted called with args: $args', tag: tag);
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'SaveLocationWithLocation',
      callback: (args) async {
        MyPrint.printOnConsole('SaveLocationWithLocation called with args: $args', tag: tag);

        courseOfflineController.updateCmiModel(
          requestModel: courseOfflineLaunchRequestModel,
          onUpdate: ({required CMIModel cmiModel}) {
            cmiModel.corelessonlocation = ParsingHelper.parseStringMethod(args.firstOrNull);

            return cmiModel;
          },
        );
      },
    );

    // SaveQuestionDataWithQuestionData called with args: 6@00:00:00@1@correct
    controller.addJavaScriptHandler(
      handlerName: 'SaveQuestionDataWithQuestionData',
      callback: (args) async {
        MyPrint.printOnConsole('SaveQuestionDataWithQuestionData called with args: ${args[0]}', tag: tag);

        String questionData = ParsingHelper.parseStringMethod(args.firstOrNull);
        updateQuestionData(questionData: questionData);
      },
    );

    // RetakeCourseWithIsRetake called with args: [true]
    controller.addJavaScriptHandler(
      handlerName: 'RetakeCourseWithIsRetake',
      callback: (args) {
        MyPrint.printOnConsole('RetakeCourseWithIsRetake called with args: $args', tag: tag);

        if (args.firstOrNull != true) {
          MyPrint.printOnConsole('Returning from RetakeCourseWithIsRetake handler because it is not called with true', tag: tag);
        }

        courseOfflineController.updateStudentResponse(
          requestModel: courseOfflineLaunchRequestModel,
          onUpdate: ({required StudentCourseResponseModel studentCourseResponseModel}) {
            studentCourseResponseModel.questionResponseMap.clear();

            return studentCourseResponseModel;
          },
        );
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'updatePercentCompletedWithProgressValue',
      callback: (args) async {
        MyPrint.printOnConsole('updatePercentCompletedWithProgressValue called with args: $args', tag: tag);

        courseOfflineController.updateCmiModel(
          requestModel: courseOfflineLaunchRequestModel,
          onUpdate: ({required CMIModel cmiModel}) {
            int percentageCompleted = ParsingHelper.parseIntMethod(args.firstOrNull);
            cmiModel.percentageCompleted = percentageCompleted.toString();

            return cmiModel;
          },
        );
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'UpdateUserTextResponsesWithSeqIDUserIDTextResponses',
      callback: (args) {
        MyPrint.printOnConsole('UpdateUserTextResponsesWithSeqIDUserIDTextResponses called with args: $args', tag: tag);
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'LMSGetPooledQuestionNos',
      callback: (args) {
        MyPrint.printOnConsole('LMSGetPooledQuestionNos called with args: $args', tag: tag);
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'LMSSetPooledQuestionNosWithStr',
      callback: (args) {
        MyPrint.printOnConsole('LMSSetPooledQuestionNosWithStr called with args: $args', tag: tag);
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'XHR_requestWithLrsUrlMethodDataAuthCallbackIgnore404',
      callback: (args) {
        MyPrint.printOnConsole('XHR_requestWithLrsUrlMethodDataAuthCallbackIgnore404 called with args: $args', tag: tag);
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'XHR_GetStateWithStateKey',
      callback: (args) {
        MyPrint.printOnConsole('XHR_GetStateWithStateKey called with args: $args', tag: tag);
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'widgetVideoRecordingWithFromSource',
      callback: (args) {
        MyPrint.printOnConsole('widgetVideoRecordingWithFromSource called with args: $args', tag: tag);
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'widgetVideoRecordingFromSource',
      callback: (args) {
        MyPrint.printOnConsole('widgetVideoRecordingFromSource called with args: $args', tag: tag);
      },
    );

    //region Workflow Rules Related Scripts
    controller.addJavaScriptHandler(
      handlerName: 'LMSGetTrackWorkflowResultsWithTrackID',
      callback: (args) async {
        MyPrint.printOnConsole('LMSGetTrackWorkflowResultsWithTrackID called with args: $args', tag: tag);

        // String trackId = "";
        // if (args.isNotEmpty && args.first is String) {
        //   trackId = args[0].toString();
        // }

        // String returnTrack = await CourseOfflineSQLDatabaseHandler().getTrackTemplateWorkflowResults(trackId, model);
        // MyPrint.printOnConsole("LMSGetTracWithTrackID:${returnTrack}");
        // return returnTrack;

        return "";
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'UpdateTrackWorkflowResultsWithTrackIDTrackItemIDTrackItemStateWmessageRuleIDStepID',
      callback: (args) async {
        MyPrint.printOnConsole('UpdateTrackWorkflowResultsWithTrackIDTrackItemIDTrackItemStateWmessageRuleIDStepID called with args: $args', tag: tag);

        // String trackID = args.length > 0 ? (args[0]?.toString() ?? "") : "";
        // String trackItemId = args.length > 1 ? (args[1]?.toString() ?? "") : "";
        // String trackIstate = args.length > 2 ? (args[2]?.toString() ?? "") : "";
        // String wMessage = args.length > 3 ? (args[3]?.toString() ?? "") : "";
        // String ruleId = args.length > 4 ? (args[4]?.toString() ?? "") : "";
        // String cStepId = args.length > 5 ? (args[5]?.toString() ?? "") : "";

        // CourseOfflineSQLDatabaseHandler().updateWorkFlowRulesInDBForTrackTemplate(trackID, trackItemId, trackIstate, wMessage, ruleId, cStepId, model.siteID, model.userID);
      },
    );
    //endregion

    controller.addJavaScriptHandler(
      handlerName: 'SCORM_LMSInitialize',
      callback: (args) {
        MyPrint.printOnConsole('SCORM_LMSInitialize called with args: $args', tag: tag);
        return "true";
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'SCORM_LMSGetValueWithGetValue',
      callback: (args) async {
        MyPrint.printOnConsole('SCORM_LMSGetValueWithGetValue called with args: $args', tag: tag);

        String returntring = "";
        /*String queryElement = "";

        if (args[0].contains("core.lesson_mode")) {
          queryElement = "coursemode";
        } else if (args[0].contains("lesson_status")) {
          queryElement = "status";
        } else if (args[0].contains("lesson_location")) {
          queryElement = "location";
        } else if (args[0].contains("suspend_data")) {
          queryElement = "suspenddata";
        } else if (args[0].contains("score.min")) {
          queryElement = "scoremin";
        } else if (args[0].contains("score.max")) {
          queryElement = "scoremax";
        }

        if (queryElement.isNotEmpty && courseLaunchModel.courseDTOModel != null) {
          returntring = await CourseOfflineSQLDatabaseHandler().checkCMIWithGivenQueryElement(queryElement: queryElement, courseDTOModel: courseLaunchModel.courseDTOModel!);
        }*/

        return returntring;
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'SCORM_LMSSetValueWithTotalValue',
      callback: (args) async {
        MyPrint.printOnConsole('SCORM_LMSSetValueWithTotalValue called with args: $args', tag: tag);
        String getname = "";
        String getvalue = "";

        args[0] = args[0].toString().replaceAll("#\$&", "=");

        List<String> array = args[0].toString().split("=");
        MyPrint.printOnConsole('array:$array', tag: tag);

        if (array.length < 2) {
          MyPrint.printOnConsole('Returning from SCORM_LMSSetValueWithTotalValue because arguments invalid', tag: tag);
          return "false";
        }

        getname = ParsingHelper.parseStringMethod(array[0]);
        getvalue = ParsingHelper.parseStringMethod(array[1]);

        CMIModel? cmiModel = await courseOfflineController.getCmiModelFromRequestModel(requestModel: courseOfflineLaunchRequestModel);

        if (cmiModel == null) {
          MyPrint.printOnConsole('Returning from SCORM_LMSSetValueWithTotalValue because cmiModel is null', tag: tag);
          return "false";
        }

        if (getname.contains("cmi.core.exit") && getvalue.isEmpty) {
          return "true";
        }

        courseOfflineController.updateCmiModel(
          requestModel: courseOfflineLaunchRequestModel,
          onUpdate: ({required CMIModel cmiModel}) {
            if (getname.contains("cmi.core.session_time")) {
              cmiModel.totalsessiontime = getvalue;
            } else if (getname.contains("cmi.core.lesson_status")) {
              cmiModel.corelessonstatus = getvalue;
            } else if (getname.contains("cmi.suspend_data")) {
              cmiModel.suspenddata = getvalue;
            } else if (getname.contains("cmi.core.lesson_location")) {
              cmiModel.corelessonlocation = getvalue;
            } else if (getname.contains("cmi.core.score.raw")) {
              cmiModel.scoreraw = getvalue;
            } else if (getname.contains("cmi.core.score.max")) {
              cmiModel.scoremax = getvalue;
            } else if (getname.contains("cmi.core.score.min")) {
              cmiModel.scoremin = getvalue;
            }

            return cmiModel;
          },
        );

        return "true";
      },
    );
  }

  Future<void> updateQuestionData({required String questionData}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineLaunchWebViewScreen().updateQuestionData() called with questionData:'$questionData'", tag: tag);

    questionData = questionData.replaceAll("undefined", "");

    if (questionData.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseOfflineLaunchWebViewScreen().updateQuestionData() because questionData not got", tag: tag);
      return;
    }

    List<String> list = questionData.split("@");

    if (list.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseOfflineLaunchWebViewScreen().updateQuestionData() because questionData not got", tag: tag);
      return;
    }

    CMIModel? cmiModel = await courseOfflineController.getCmiModelFromRequestModel(requestModel: courseOfflineLaunchRequestModel);

    String optionalNotes = "";

    String attachFileName = "";
    String attachFileId = "";
    String attachFilePath = "";

    String videoFileName = "";
    String videoFileId = "";
    String videoFilePath = "";

    String imageFileName = "";
    String imageFileId = "";
    String imageFilePath = "";

    String fifthValue = ParsingHelper.parseStringMethod(list.elementAtOrNull(4));
    String sixthValue = ParsingHelper.parseStringMethod(list.elementAtOrNull(5));
    String seventhValue = ParsingHelper.parseStringMethod(list.elementAtOrNull(6));
    String eighthValue = ParsingHelper.parseStringMethod(list.elementAtOrNull(7));
    String ninthValue = ParsingHelper.parseStringMethod(list.elementAtOrNull(8));
    String tenthValue = ParsingHelper.parseStringMethod(list.elementAtOrNull(9));

    if (fifthValue.isNotEmpty) {
      if (fifthValue.contains("^notes^")) {
        optionalNotes = fifthValue.replaceAll("^notes^", "");
      } else if (sixthValue.isNotEmpty) {
        attachFileName = fifthValue;
        attachFileId = sixthValue;
        String pathSeparator = AppController.getPathSeparator() ?? "/";
        attachFilePath = "${widget.arguments.courseDirectoryPath}$pathSeparator/Offline_Attachments/$attachFileId";
      }
    }

    if (seventhValue.isNotEmpty && eighthValue.isNotEmpty) {
      videoFileName = seventhValue;
      videoFileId = eighthValue;
      String pathSeparator = AppController.getPathSeparator() ?? "/";
      videoFilePath = "${widget.arguments.courseDirectoryPath}$pathSeparator/Offline_Attachments/$videoFileId";
    }

    if (ninthValue.isNotEmpty && tenthValue.isNotEmpty) {
      imageFileName = ninthValue;
      imageFileId = tenthValue;
      String pathSeparator = AppController.getPathSeparator() ?? "/";
      imageFilePath = "${widget.arguments.courseDirectoryPath}$pathSeparator/Offline_Attachments/$imageFileId";
    }

    await courseOfflineController.updateStudentResponse(
      requestModel: courseOfflineLaunchRequestModel,
      onUpdate: ({required StudentCourseResponseModel studentCourseResponseModel}) {
        StudentResponseModel studentResponseModel = StudentResponseModel(
          siteid: courseOfflineLaunchRequestModel.SiteId,
          userid: courseOfflineLaunchRequestModel.UserId,
          scoid: courseOfflineLaunchRequestModel.ScoId,
          assessmentattempt: cmiModel?.noofattempts ?? 1,
          questionid: ParsingHelper.parseIntMethod(list.elementAtOrNull(0)) + (courseOfflineLaunchRequestModel.ContentTypeId == InstancyObjectTypes.contentObject ? 1 : 0),
          studentresponses: ParsingHelper.parseStringMethod(list.elementAtOrNull(2)),
          result: ParsingHelper.parseStringMethod(list.elementAtOrNull(3)),
          attemptdate: courseOfflineController.getCurrentDateTime(),
          optionalnotes: optionalNotes,
          attachfilename: attachFileName,
          attachfileid: attachFileId,
          attachedfilepath: attachFilePath,
          capturedvidfilename: videoFileName,
          capturedvidid: videoFileId,
          capturedVidFilepath: videoFilePath,
          capturedimgfilename: imageFileName,
          capturedimgid: imageFileId,
          capturedImgFilepath: imageFilePath,
        );

        studentResponseModel.questionattempt = 1;

        studentCourseResponseModel.questionResponseMap[studentResponseModel.questionid] = studentResponseModel;

        MyPrint.printOnConsole("Saving studentResponseModel:$studentResponseModel", tag: tag);

        return studentCourseResponseModel;
      },
    );
  }

  Future<void> updateCourseProgress({
    required String coreLessonStatus,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseOfflineLaunchWebViewScreen().updateCourseProgress() called with coreLessonStatus:'$coreLessonStatus'", tag: tag);

    String ContentStatus = "";
    double contentProgress = 0;

    switch (coreLessonStatus) {
      case ContentStatusTypes.completed:
        {
          ContentStatus = "Completed";
          contentProgress = 100;
        }
      case ContentStatusTypes.passed:
        {
          ContentStatus = "Completed(Passed)";
          contentProgress = 100;
        }
      case ContentStatusTypes.failed:
        {
          ContentStatus = "Completed(Failed)";
          contentProgress = 100;
        }
      case ContentStatusTypes.notAttempted:
        {
          ContentStatus = "Not Started";
          contentProgress = ParsingHelper.parseDoubleMethod((await courseOfflineController.getCmiModelFromRequestModel(requestModel: courseOfflineLaunchRequestModel))?.percentageCompleted ?? 0);
        }
      default:
        {
          ContentStatus = "In Progress";
          contentProgress = ParsingHelper.parseDoubleMethod((await courseOfflineController.getCmiModelFromRequestModel(requestModel: courseOfflineLaunchRequestModel))?.percentageCompleted ?? 0);
        }
    }

    MyPrint.printOnConsole("Final ContentStatus:'$ContentStatus'", tag: tag);
    MyPrint.printOnConsole("Final contentProgress:'$contentProgress'", tag: tag);

    await courseOfflineController.updateContentProgressInOfflineAndDownloadWithTrackProgress(
      ContentId: courseLaunchModel.ContentID,
      CoreLessonStatus: coreLessonStatus,
      ContentDisplayStatus: ContentStatus,
      contentProgress: contentProgress,
      ParentContentId: courseLaunchModel.ParentEventTrackContentID,
      ParentContentTypeId: courseLaunchModel.ParentContentTypeId,
    );
  }

  @override
  void initState() {
    super.initState();

    courseLaunchModel = widget.arguments.courseLaunchModel;

    String UserName = context.read<AuthenticationProvider>().getEmailLoginResponseModel()?.username ?? "";

    AppProvider appProvider = context.read<AppProvider>();

    courseDownloadProvider = context.read<CourseDownloadProvider>();
    courseDownloadController = CourseDownloadController(appProvider: appProvider, courseDownloadProvider: courseDownloadProvider);

    courseOfflineLaunchRequestModel = CourseOfflineLaunchRequestModel(
      UserId: courseLaunchModel.SiteUserID,
      SiteId: courseLaunchModel.SiteId,
      ScoId: courseLaunchModel.ScoID,
      ContentTypeId: courseLaunchModel.ContentTypeId,
      MediaTypeId: courseLaunchModel.MediaTypeId,
      ParentContentTypeId: courseLaunchModel.ParentContentTypeId,
      ParentContentScoId: courseLaunchModel.ParentContentScoId,
      ContentId: courseLaunchModel.ContentID,
      ParentContentId: courseLaunchModel.ParentEventTrackContentID,
      UserName: UserName,
      isJWVideo: courseLaunchModel.JWVideoKey.isNotEmpty,
    );

    MyPrint.printOnConsole("CourseOfflineLaunchWebViewScreen init called for coursePath:'${widget.arguments.coursePath}'");
    coursePath = widget.arguments.coursePath;

    initializationsFuture = initializations();

    isPageLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        MyPrint.printOnConsole("onPopInvoked called with didPop:$didPop");
        if (didPop) return;

        bool isFS = isFullScreen();
        MyPrint.printOnConsole("isFS:$isFS");
        if (!isFS) {
          Navigator.pop(context, true);
        }
      },
      child: ModalProgressHUD(
        inAsyncCall: !isPageLoaded,
        child: Scaffold(
          appBar: getAppBar(),
          body: FutureBuilder<bool>(
            future: initializationsFuture,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const CommonLoader();
              }

              return SafeArea(
                child: getMainBody(coursePath: coursePath),
              );
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget? getAppBar() {
    if (isFullScreen()) {
      return null;
    }

    return AppBar(
      title: Text(
        widget.arguments.courseName.isNotEmpty ? widget.arguments.courseName : "Course",
      ),
    );
  }

  Widget getMainBody({required String coursePath}) {
    if (coursePath.isEmpty) {
      return const Center(
        child: Text("Course Couldn't loaded"),
      );
    }

    MyPrint.printOnConsole("Final coursePath:'$coursePath'");

    return InAppWebView(
      initialUrlRequest: URLRequest(
        url: WebUri(coursePath),
      ),
      initialSettings: InAppWebViewSettings(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        allowFileAccess: true,
        allowFileAccessFromFileURLs: true,
        allowUniversalAccessFromFileURLs: true,
        javaScriptEnabled: true,
        useHybridComposition: true,
        hardwareAcceleration: true,
        allowContentAccess: true,
        allowsInlineMediaPlayback: true,
        isInspectable: true,

        //In Course/scripts/CommonSkin_1.js/exitNewCourse(), they are checking userAgent in ["android", "iphone", "ipad", "symbianos"]
        //Without this, it won't work
        //In iPad, this value was not getting valid.
        userAgent: switch (defaultTargetPlatform) {
          TargetPlatform.android => "android",
          TargetPlatform.iOS => "iphone",
          TargetPlatform.macOS => "iphone",
          TargetPlatform.windows => "iphone",
          _ => null,
        },
      ),
      onWebViewCreated: (InAppWebViewController webViewController) async {
        MyPrint.printOnConsole("onWebViewCreated called with webViewController:$webViewController");

        this.webViewController = webViewController;

        //Because onProgressChanged not implemented for Web
        if (kIsWeb) {
          isPageLoaded = true;
          mySetState();
        } else {
          isPageLoaded = false;
          mySetState();
        }

        await InAppWebViewController.clearAllCache();
        await webViewController.injectJavascriptFileFromAsset(assetFilePath: 'assets/js/main.js');
      },
      shouldOverrideUrlLoading: (InAppWebViewController controller, NavigationAction navigationAction) async {
        return NavigationActionPolicy.ALLOW;
      },
      onReceivedError: (InAppWebViewController controller, WebResourceRequest request, WebResourceError error) {
        MyPrint.printOnConsole("InAppWebView onReceivedError called for:${request.url}, Type:${error.type}, Message:${error.description}");
      },
      onProgressChanged: (InAppWebViewController webViewController, int progress) {
        MyPrint.printOnConsole("onProgressChanged called with webViewController:$webViewController, progress:$progress");
        // this.webViewController = webViewController;

        if (!isPageLoaded && progress == 100) {
          isPageLoaded = true;
          mySetState();
        }
      },
      onConsoleMessage: (InAppWebViewController controller, ConsoleMessage consoleMessage) {
        MyPrint.printOnConsole("onConsoleMessage called with webViewController:$webViewController, consoleMessage:'$consoleMessage'");
      },
      onLoadStart: (InAppWebViewController webViewController, WebUri? webUri) async {
        onLoadStartHandler(webViewController, webUri);
      },
      onLoadStop: (InAppWebViewController webViewController, WebUri? webUri) async {
        MyPrint.printOnConsole("onLoadStop called with webViewController:$webViewController, webUri:$webUri");

        await webViewController.injectJavascriptFileFromAsset(assetFilePath: 'assets/js/main.js');
        addJSHandlers(webViewController);
        if (!isReloadedOnce) {
          isReloadedOnce = true;
          webViewController.reload();
        }
      },
      onLoadResource: (InAppWebViewController controller, LoadedResource resource) {
        MyPrint.printOnConsole("InAppWebView onLoadResource called for:${resource.url?.path}");
      },
      onReceivedServerTrustAuthRequest: (controller, URLAuthenticationChallenge challenge) async {
        MyPrint.printOnConsole("onReceivedServerTrustAuthRequest called with webViewController:$webViewController, challenge:$challenge");
        //Do some checks here to decide if CANCELS or PROCEEDS
        return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
      },
      onPermissionRequest: (InAppWebViewController controller, PermissionRequest request) async {
        MyPrint.printOnConsole("onPermissionRequest called for Request:${request.resources}");

        return PermissionResponse(
          action: PermissionResponseAction.PROMPT,
          resources: [
            PermissionResourceType.CAMERA_AND_MICROPHONE,
          ],
        );
      },
    );
  }
}
