import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as inAppWebview;
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/backend/app/app_controller.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/authentication/authentication_provider.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/backend/gamification/gamification_controller.dart';
import 'package:flutter_instancy_2/backend/gamification/gamification_provider.dart';
import 'package:flutter_instancy_2/backend/my_learning/my_learning_controller.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/models/authentication/data_model/native_login_dto_model.dart';
import 'package:flutter_instancy_2/models/common/data_response_model.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/models/course_launch/data_model/content_status_model.dart';
import 'package:flutter_instancy_2/models/course_launch/data_model/course_launch_model.dart';
import 'package:flutter_instancy_2/models/course_launch/request_model/initial_course_tracking_request_model.dart';
import 'package:flutter_instancy_2/models/course_launch/request_model/insert_course_data_by_token_request_model.dart';
import 'package:flutter_instancy_2/models/course_launch/request_model/web_api_initialize_tracking_request_model.dart';
import 'package:flutter_instancy_2/models/course_launch/response_model/content_status_response_model.dart';
import 'package:flutter_instancy_2/models/gamification/request_model/update_content_gamification_request_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:provider/provider.dart';

import '../../api/api_call_model.dart';
import '../../api/api_url_configuration_provider.dart';
import '../../api/rest_client.dart';
import '../../configs/app_constants.dart';
import '../../models/ar_vr_module/response_model/ar_content_model.dart';
import '../../models/common/model_data_parser.dart';
import '../../models/course_launch/request_model/content_status_request_model.dart';
import '../../utils/my_print.dart';
import 'course_launch_repository.dart';
import 'gotoCourseLaunch.dart';
import 'gotoCourseLaunchContenisolation.dart';

class CourseLaunchController {
  late CourseLaunchRepository _courseLaunchRepository;
  late final AppProvider _appProvider;
  late final AuthenticationProvider _authenticationProvider;
  late final ApiUrlConfigurationProvider _apiDataProvider;
  late final int _componentId;
  late final int _componentInstanceId;

  CourseLaunchController({
    CourseLaunchRepository? courseLaunchRepository,
    AppProvider? appProvider,
    AuthenticationProvider? authenticationProvider,
    ApiUrlConfigurationProvider? apiDataProvider,
    ApiController? apiController,
    required int componentId,
    required int componentInstanceId,
  }) {
    _courseLaunchRepository = courseLaunchRepository ?? CourseLaunchRepository(apiController: apiController ?? ApiController());
    _appProvider = appProvider ?? AppProvider();
    _authenticationProvider = authenticationProvider ?? AuthenticationProvider();
    _apiDataProvider = apiDataProvider ?? _courseLaunchRepository.apiController.apiDataProvider;
    _componentId = componentId;
    _componentInstanceId = componentInstanceId;
  }

  CourseLaunchRepository get courseLaunchRepository => _courseLaunchRepository;

  AppProvider get appProvider => _appProvider;

  AuthenticationProvider get authenticationProvider => _authenticationProvider;

  ApiUrlConfigurationProvider get apiDataProvider => _apiDataProvider;

  Future<bool> viewCourse({
    required BuildContext context,
    required CourseLaunchModel model,
  }) async {
    MyPrint.printOnConsole("CourseLaunchController().viewCourse() called");

    if (![InstancyObjectTypes.track, InstancyObjectTypes.events].contains(model.ContentTypeId)) {
      await GamificationController(provider: context.read<GamificationProvider>()).UpdateContentGamification(
        requestModel: UpdateContentGamificationRequestModel(
          contentId: model.ContentID,
          scoId: model.ScoID,
          objecttypeId: model.ContentTypeId,
          GameAction: GamificationActionType.DirectLaunched,
          isCourseLaunch: true,
          CanTrack: true,
        ),
      );
    }

    bool result = false;

    if (![InstancyObjectTypes.events, InstancyObjectTypes.externalTraining, InstancyObjectTypes.physicalProduct].contains(model.ContentTypeId)) {
      result = await decideCourseLaunchMethod(
        context: context,
        model: model,
        isContentisolation: false,
      );
    }

    if (![InstancyObjectTypes.track, InstancyObjectTypes.events].contains(model.ContentTypeId)) {
      await GamificationController(provider: context.read<GamificationProvider>()).UpdateContentGamification(
        requestModel: UpdateContentGamificationRequestModel(
          contentId: model.ContentID,
          scoId: model.ScoID,
          objecttypeId: model.ContentTypeId,
          GameAction: GamificationActionType.Completed,
          isCourseLaunch: false,
          CanTrack: false,
        ),
      );
    }

    return result;
  }

  Future<bool> decideCourseLaunchMethod({required BuildContext context, required CourseLaunchModel model, bool isContentisolation = false}) async {
    MyPrint.printOnConsole("CourseLaunchController().decideCourseLaunchMethod() called with isContentisolation:$isContentisolation");

    bool networkAvailable = true, isCourseDownloaded = false;

    if (!kIsWeb) {
      networkAvailable = await AppController.checkInternetConnectivity();
      /*isCourseDownloaded = await checkIfContentIsAvailableOffline(
        context: context,
        table2: model,
      );*/
    }
    MyPrint.printOnConsole("networkAvailable:$networkAvailable");
    MyPrint.printOnConsole("isCourseDownloaded:$isCourseDownloaded");

    if (networkAvailable && isCourseDownloaded) {
      // launch offline
      // bool isLaunched = await launchCourseOffline(context: context, table2: model);
      // if(isLaunched) {
      //   await SyncData().syncData();
      // }
      // return isLaunched;
      return false;
    } else if (!networkAvailable && isCourseDownloaded) {
      // launch offline
      // return await launchCourseOffline(context: context, table2: model);
      return false;
    } else if (networkAvailable && !isCourseDownloaded) {
      // launch online
      bool isLaunched = false;
      if (context.mounted && context.checkMounted()) {
        isLaunched = await launchCourse(context: context, model: model, isContentisolation: isContentisolation);
        MyPrint.printOnConsole("isLaunched:$isLaunched");
      }
      return isLaunched;
    } else {
      // error dialog
      // AppBloc appBloc = BlocProvider.of<AppBloc>(context, listen: false);
      // await _courseNotDownloadedDialog(context, appBloc);
      return false;
    }
  }

  Future<bool> launchCourse({
    required BuildContext context,
    required CourseLaunchModel model,
    bool isContentisolation = false,
  }) async {
    MyPrint.printOnConsole("CourseLaunchController().launchCourse() called with isContentisolation:$isContentisolation");

    /*
    //TODO: This content for testing purpuse
    courseLaunch = GotoCourseLaunch(
        context, table2, false, appBloc.uiSettingModel, myLearningBloc.list);
    String url = await courseLaunch.getCourseUrl();

    print('urldataaaaa $url');
    if (url.isNotEmpty) {
      if (table2.ContentTypeId == 26) {
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AdvancedWebCourseLaunch(url, table2.name)));
      } else {
        //await FlutterWebBrowser.openWebPage(url: url, androidToolbarColor: Colors.deepPurple);

        //await launch(url);
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => InAppWebCourseLaunch(url, table2)));
      }

      logger.e('.....Refresh Me....$url');

      /// Refresh Content Of My Learning

    }
    return;
    */

    /// content isolation only for 8,9,10,11,26,27

    /// Need Some value
    /*if (table2.ContentTypeId == 102) {
      await executeXAPICourse(table2);
    }*/

    MyPrint.printOnConsole('Table2 Objet Id:${model.ContentTypeId}');
    MyPrint.printOnConsole('Table2 Media Id:${model.MediaTypeId}');
    MyPrint.printOnConsole('Table2 JWVideoKey:${model.JWVideoKey}');
    MyPrint.printOnConsole('Table2 Start Page:${model.startPage}');

    try {
      if (model.ContentTypeId == InstancyObjectTypes.track /* && model.bit5*/) {
        // Need to open EventTrackListTabsActivity
        MyPrint.printOnConsole('Navigation to EventTrackList called');

        await NavigationController.navigateToEventTrackScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: EventTrackScreenArguments(
            objectTypeId: model.ContentTypeId,
            isRelatedContent: false,
            parentContentId: model.ContentID,
            componentId: _componentId,
            scoId: model.ScoID,
            eventTrackTabType: model.ContentTypeId == InstancyObjectTypes.track ? EventTrackTabs.trackContents : EventTrackTabs.eventContents,
            componentInstanceId: _componentInstanceId,
            isContentEnrolled: true,
          ),
        );

        return true;
      } else if (model.ContentTypeId == InstancyObjectTypes.events) {
        MyPrint.printOnConsole('Navigation to Classroom Events');

        await NavigationController.navigateToEventTrackScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: EventTrackScreenArguments(
            eventTrackTabType: model.ContentTypeId == InstancyObjectTypes.track ? EventTrackTabs.trackContents : EventTrackTabs.eventContents,
            objectTypeId: model.ContentTypeId,
            isRelatedContent: true,
            parentContentId: model.ContentID,
            componentId: _componentId,
            scoId: model.ScoID,
            componentInstanceId: _componentInstanceId,
            isContentEnrolled: true,
          ),
        );

        return true;
      } else if (model.ContentTypeId == InstancyObjectTypes.assignment) {
        String assignmenturl = '${apiDataProvider.getCurrentSiteUrl()}assignmentdialog/ContentID/${model.ContentID}/SiteID/${model.SiteId}'
            '/ScoID/${model.ScoID}/UserID/${model.SiteUserID}/ismobilecontentview/true';
        MyPrint.printOnConsole('assignmenturl is : $assignmenturl');

        dynamic value = await navigateToLaunchScreen(
          context: context,
          model: model,
          launchUrl: assignmenturl,
        );

        return value == true;
      } else if ([
            InstancyObjectTypes.contentObject,
            InstancyObjectTypes.assessment,
            InstancyObjectTypes.scorm1_2,
            InstancyObjectTypes.reference,
            InstancyObjectTypes.xApi,
          ].contains(model.ContentTypeId) ||
          (model.ContentTypeId == InstancyObjectTypes.track && !model.bit5) ||
          (model.ContentTypeId == InstancyObjectTypes.mediaResource && model.MediaTypeId == InstancyMediaTypes.video && model.JWVideoKey.isNotEmpty)) {
        if (isContentisolation) {
          MyPrint.printOnConsole("Returning from CourseLaunchController().launchCourse() because isContentisolation is true");
          return false;
        }

        NativeLoginDTOModel? successfulUserLoginModel = authenticationProvider.getEmailLoginResponseModel();
        if (successfulUserLoginModel == null) {
          MyPrint.printOnConsole("Returning from CourseLaunchController().launchCourse() because successfulUserLoginModel is null");
          return false;
        }

        GotoCourseLaunchContentisolation courseLaunch = GotoCourseLaunchContentisolation(
          context: context,
          apiUrlConfigurationProvider: apiDataProvider,
          successfulUserLoginModel: successfulUserLoginModel,
          tinCanDataModel: appProvider.tinCanDataModel,
          appSystemConfigurationModel: appProvider.appSystemConfigurationModel,
          courseLaunchModel: model,
        );

        String courseUrl = await courseLaunch.getCourseUrl();
        MyPrint.printOnConsole("Course Url:'$courseUrl'");

        if (courseUrl.isEmpty) {
          MyPrint.printOnConsole("Returning from CourseLaunchController().launchCourse() because courseUrl is empty");
          return false;
        }

        if (model.ContentTypeId == InstancyObjectTypes.reference) {
          checkNonTrackableContentStatusUpdate(model: model);

          dynamic value = await navigateToLaunchScreen(
            context: context,
            model: model,
            launchUrl: courseUrl,
          );

          // return value == true;
          return value == true;
        } else {
          String courseTrackingToken = await getCourseTrackingToken(courseUrl: courseUrl, model: model);
          MyPrint.printOnConsole("Course Tracking Token:'$courseTrackingToken'");

          if (courseTrackingToken.isEmpty) {
            MyPrint.printOnConsole("Returning from CourseLaunchController().launchCourse() because courseTrackingToken is empty");
            return false;
          }

          String courseLaunchUrl;

          String azureRootPath = appProvider.appSystemConfigurationModel.azureRootPath;
          MyPrint.printOnConsole("Azure Path:'$azureRootPath'");
          if (AppConfigurationOperations.isValidString(azureRootPath)) {
            MyPrint.printOnConsole("Taking Azure Path");
            courseLaunchUrl = '${azureRootPath}content/index.html?coursetoken=$courseTrackingToken&TokenAPIURL=${apiDataProvider.getCurrentAuthUrl()}';

            // assignmenturl = await '${ApiEndpoints.strSiteUrl}assignmentdialog/ContentID/${table2.contentid}/SiteID/${table2.usersiteid}/ScoID/${table2.scoid}/UserID/${table2.userid}';
          } else {
            MyPrint.printOnConsole("Taking Site Url Path");

            String siteUrl = apiDataProvider.getCurrentSiteUrl();
            MyPrint.printOnConsole("siteUrl:$siteUrl");
            courseLaunchUrl = '${siteUrl}content/index.html?coursetoken=$courseTrackingToken&TokenAPIURL=${apiDataProvider.getCurrentAuthUrl()}';

            //assignmenturl = await '${ApiEndpoints.strSiteUrl}assignmentdialog/ContentID/${table2.contentid}/SiteID/${table2.usersiteid}/ScoID/${table2.scoid}/UserID/${table2.userid}';
          }

          checkNonTrackableContentStatusUpdate(model: model);

          dynamic value = await navigateToLaunchScreen(
            context: context,
            model: model,
            launchUrl: courseLaunchUrl,
          );
          return value == true;
        }

        /*ContentStatusModel? contentstatus = await getContentStatus(
        model: model,

      );

      if(contentstatus != null) {
        print('getcontentstatusvl ${contentstatus.name} ${contentstatus.progress} ${contentstatus.contentStatus}');
        model.actualstatus = contentstatus.name;
        model.percentcompleted = contentstatus.progress;
        if (contentstatus.progress != '0') {
          model.percentcompleted = contentstatus.progress;
        }
        model.corelessonstatus = contentstatus.contentStatus;
      }*/
      } else if (model.ContentTypeId == InstancyObjectTypes.courseBot) {
        return await NavigationController.navigateToInstaBotScreen2(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: InstaBotScreen2NavigationArguments(
            courseId: model.ContentID,
          ),
        );
      } else if (AppConfigurationOperations.isARContent(contentTypeId: model.ContentTypeId, mediaTypeId: model.MediaTypeId)) {
        String url = "";
        NativeLoginDTOModel? successfulUserLoginModel = authenticationProvider.getEmailLoginResponseModel();
        if (successfulUserLoginModel != null) {
          GotoCourseLaunch courseLaunch = GotoCourseLaunch(
            context: context,
            apiUrlConfigurationProvider: apiDataProvider,
            successfulUserLoginModel: successfulUserLoginModel,
            tinCanDataModel: appProvider.tinCanDataModel,
            appSystemConfigurationModel: appProvider.appSystemConfigurationModel,
            courseLaunchModel: model,
          );
          url = await courseLaunch.getCourseUrl();
        }

        MyPrint.printOnConsole('urldataaaaa $url');
        if (url.isNotEmpty) {
          // checkNonTrackableContentStatusUpdate(model: model);

          dynamic value = await navigateToLaunchScreen(
            context: context,
            model: model,
            launchUrl: url,
          );
          MyPrint.printOnConsole('CourseLaunchController().launchCourse() value $value');
          // return value == true;
          return true;
        }
      } else {
        String url = "";
        NativeLoginDTOModel? successfulUserLoginModel = authenticationProvider.getEmailLoginResponseModel();
        if (successfulUserLoginModel != null) {
          GotoCourseLaunch courseLaunch = GotoCourseLaunch(
            context: context,
            apiUrlConfigurationProvider: apiDataProvider,
            successfulUserLoginModel: successfulUserLoginModel,
            tinCanDataModel: appProvider.tinCanDataModel,
            appSystemConfigurationModel: appProvider.appSystemConfigurationModel,
            courseLaunchModel: model,
          );
          url = await courseLaunch.getCourseUrl();
        }

        MyPrint.printOnConsole('urldataaaaa $url');
        if (url.isNotEmpty) {
          checkNonTrackableContentStatusUpdate(model: model);

          dynamic value = await navigateToLaunchScreen(
            context: context,
            model: model,
            launchUrl: url,
          );
          MyPrint.printOnConsole('CourseLaunchController().launchCourse() value $value');
          // return value == true;
          return true;
        }
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseLaunchController().launchCourse():$e");
      MyPrint.printOnConsole(s);
    }

    return false;
  }

  Future<String> getCourseTrackingToken({required String courseUrl, required CourseLaunchModel model}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseLaunchController().getCourseTrackingToken() called", tag: tag);

    String token = "";

    String courseSessionId = await getCourseTrackingSessionId(model: model);

    if (courseSessionId.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseLaunchController().getCourseTrackingToken() because courseSessionId is empty", tag: tag);
      return token;
    }

    token = await getCourseLaunchTokenId(
      courseUrl: courseUrl,
      model: model,
      courseSessionId: courseSessionId,
    );

    MyPrint.printOnConsole("Final Token:$token", tag: tag);

    return token;
  }

  Future<String> getCourseTrackingSessionId({required CourseLaunchModel model}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseLaunchController().getCourseTrackingSessionId() called", tag: tag);

    String sessionId = "";

    DataResponseModel<String> courseApiResponse = await courseLaunchRepository.getCourseTrackingSessionId(
      requestModel: WebApiInitializeTrackingRequestModel(
        userId: model.SiteUserID,
        contentid: model.ContentID,
        objectTypeID: model.ContentTypeId,
        scoId: model.ScoID,
        siteid: model.SiteId,
      ),
    );

    MyPrint.printOnConsole("getCourseTrackingSessionId() response status:${courseApiResponse.statusCode}", tag: tag);
    MyPrint.printOnConsole("getCourseTrackingSessionId() response data:${courseApiResponse.data}", tag: tag);

    sessionId = courseApiResponse.data ?? "";

    return sessionId;
  }

  Future<String> getCourseLaunchTokenId({required String courseUrl, required CourseLaunchModel model, required String courseSessionId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseLaunchController().getCourseTrackingSessionId() called", tag: tag);

    String token = "";

    NativeLoginDTOModel? successfulUserLoginModel = authenticationProvider.getEmailLoginResponseModel();

    if (successfulUserLoginModel == null) {
      MyPrint.printOnConsole("Returning from CourseLaunchController().getCourseLaunchTokenId() because successfulUserLoginModel is null", tag: tag);
      return token;
    }

    DataResponseModel<String> tokenApiResponse = await courseLaunchRepository.insertCourseDataByToken(
      requestModel: InsertCourseDataByTokenRequestModel(
        CourseDetails: InsertCourseDataCourseDetailsModel(
          Course_URL: courseUrl,
          ContentID: model.ContentID,
          courseName: model.ContentName,
          Obj_Type_ID: model.ContentTypeId,
          learnerSCOID: model.ScoID,
          learnerSessionID: courseSessionId,
          UserID: model.SiteUserID,
          UserSessionID: successfulUserLoginModel.sessionid,
          LoginUserId: successfulUserLoginModel.userid,
          usermailid: successfulUserLoginModel.email,
          SaltKey: AppConstants.saltKey,
          siteid: apiDataProvider.getCurrentSiteId(),
          locale: apiDataProvider.getLocale(),
        ),
        APIData: InsertCourseAPIDataModel(
          UniqueID: apiDataProvider.getAuthToken(),
          WebAPIUrl: apiDataProvider.getCurrentBaseApiUrl(),
          LearnerURL: apiDataProvider.getCurrentSiteLearnerUrl(),
          LMSUrl: apiDataProvider.getCurrentSiteLMSUrl(),
          currentOrigin: "frommobile",
        ),
      ),
    );

    MyPrint.printOnConsole("insertCourseDataByToken() response status:${tokenApiResponse.statusCode}", tag: tag);
    MyPrint.printOnConsole("insertCourseDataByToken() response data:${tokenApiResponse.data}", tag: tag);

    if (tokenApiResponse.data.checkNotEmpty) {
      token = tokenApiResponse.data!;
    }

    return token;
  }

  Future<ContentStatusModel?> getContentStatus({
    required CourseDTOModel model,
    String? TrackContentID,
    int? TrackScoID,
    int? TrackObjectTypeID,
    String? isonexist,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseLaunchController().getContentStatus() called", tag: tag);

    DataResponseModel<ContentStatusResponseModel> responseModel = await courseLaunchRepository.getContentStatus(
      requestModel: ContentStatusRequestModel(
        userId: model.SiteUserID,
        scoId: model.ScoID,
        SiteID: model.SiteId,
        OrgUnitID: model.SiteId,
        TrackContentID: TrackContentID,
        TrackScoID: TrackScoID,
        TrackObjectTypeID: TrackObjectTypeID,
        isonexist: isonexist,
      ),
    );

    MyPrint.printOnConsole("getContentStatus() response status:${responseModel.statusCode}", tag: tag);
    MyPrint.printOnConsole("getContentStatus() response data:${responseModel.data}", tag: tag);

    return responseModel.data?.contentstatus.firstElement;
  }

  Future<void> checkNonTrackableContentStatusUpdate({required CourseLaunchModel model}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseLaunchController().checkNonTrackableContentStatusUpdate() called", tag: tag);

    MyPrint.printOnConsole("model.ContentTypeId:${model.ContentTypeId}", tag: tag);

    if (![
      InstancyObjectTypes.mediaResource,
      InstancyObjectTypes.reference,
      InstancyObjectTypes.document,
    ].contains(model.ContentTypeId)) {
      MyPrint.printOnConsole("Returning from CourseLaunchController().checkNonTrackableContentStatusUpdate() because Content Type is not valid", tag: tag);
      return;
    }

    //region Exceptional Media Type Validation
    if ([
      InstancyMediaTypes.corpAcademy,
      InstancyMediaTypes.psyTechAssessment,
      InstancyMediaTypes.dISCAssessment,
      InstancyMediaTypes.assessment24x7,
    ].contains(model.MediaTypeId)) {
      MyPrint.printOnConsole("Returning from CourseLaunchController().checkNonTrackableContentStatusUpdate() because Media Type is not valid", tag: tag);
      return;
    }
    //endregion

    /*//region JWKey Validation
    if (model.JWVideoKey.isNotEmpty) {
      MyPrint.printOnConsole("Returning from CourseLaunchController().checkNonTrackableContentStatusUpdate() because JWVideoKey is not empty", tag: tag);
      return;
    }
    //endregion*/

    bool autocompleteNonTrackableContent = appProvider.appSystemConfigurationModel.autocompleteNonTrackableContent;
    MyPrint.printOnConsole("autocompleteNonTrackableContent:$autocompleteNonTrackableContent", tag: tag);

    if (autocompleteNonTrackableContent) {
      MyPrint.printOnConsole("Have to update status to completed", tag: tag);

      //region Content Status Validation
      if (model.ActualStatus == ContentStatusTypes.completed) {
        MyPrint.printOnConsole("Returning from CourseLaunchController().checkNonTrackableContentStatusUpdate() because Content Status is Completed already", tag: tag);
        return;
      }
      //endregion

      await MyLearningController(provider: null).setComplete(
        contentId: model.ContentID,
        scoId: model.ScoID,
        contentTypeId: model.ContentTypeId,
      );
    } else {
      MyPrint.printOnConsole("Have to update status to In Progress", tag: tag);

      //region Content Status Validation
      if ([ContentStatusTypes.completed, ContentStatusTypes.incomplete, ContentStatusTypes.inProgress].contains(model.ActualStatus)) {
        MyPrint.printOnConsole("Returning from CourseLaunchController().checkNonTrackableContentStatusUpdate() because Content Status is Completed or In Progress", tag: tag);
        return;
      }
      //endregion

      await updateContentStatusToInProgressForNonTrackingContents(userId: model.SiteUserID, scoId: model.ScoID);
    }
  }

  Future<bool> updateContentStatusToInProgressForNonTrackingContents({required int userId, required int scoId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseLaunchController().updateContentStatusToInProgressForNonTrackingContents() called with userId:$userId, scoId:$scoId", tag: tag);

    bool isSuccess = false;

    DataResponseModel<String> initializeApiResponse = await courseLaunchRepository.initializeTrackingForMediaObjects(
      requestModel: InitialCourseTrackingRequestModel(
        UserID: userId,
        ScoID: scoId,
      ),
    );

    MyPrint.printOnConsole("initializeTrackingForMediaObjects() response status:${initializeApiResponse.statusCode}", tag: tag);
    MyPrint.printOnConsole("initializeTrackingForMediaObjects() response data:${initializeApiResponse.data}", tag: tag);

    if (initializeApiResponse.statusCode == 204) {
      isSuccess = true;
    }

    return isSuccess;
  }

  Future navigateToLaunchScreen({
    required BuildContext context,
    required CourseLaunchModel model,
    required String launchUrl,
  }) async {
    MyPrint.printOnConsole("navigateToLaunchScreen called with MediaTypeId:${model.MediaTypeId}");

    if (model.MediaTypeId == InstancyMediaTypes.pDF) {
      return NavigationController.navigateToPDFLaunchScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: PDFLaunchScreenNavigationArguments(
          contntName: model.ContentName,
          pdfUrl: launchUrl,
          isNetworkPDF: true,
        ),
      );
    } else if (AppConfigurationOperations.isARContent(contentTypeId: model.ContentTypeId, mediaTypeId: model.MediaTypeId)) {
      inAppWebview.ChromeSafariBrowser browser = inAppWebview.ChromeSafariBrowser();
      await browser.open(
        url: inAppWebview.WebUri(launchUrl),
      );
    }
    /*else if (model.MediaTypeId == InstancyMediaTypes.video && model.JWVideoKey.isEmpty) {
      return NavigationController.navigateToVideoLaunchScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: VideoLaunchScreenNavigationArguments(
          contntName: model.ContentName,
          videoUrl: launchUrl,
          isNetworkVideo: true,
        ),
      );
    }*/
    else {
      return NavigationController.navigateToCourseLaunchWebViewScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: CourseLaunchWebViewScreenNavigationArguments(
          courseUrl: launchUrl,
          courseName: model.ContentName,
          contentTypeId: model.ContentTypeId,
        ),
      );
    }
  }

  Future<String> getARContentUrl({required BuildContext context, required CourseDTOModel courseModel}) async {
    String url = "";

    NativeLoginDTOModel? successfulUserLoginModel = authenticationProvider.getEmailLoginResponseModel();
    if (successfulUserLoginModel == null) {
      return url;
    }

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiDataProvider;

    GotoCourseLaunch courseLaunch = GotoCourseLaunch(
      context: context,
      apiUrlConfigurationProvider: apiUrlConfigurationProvider,
      successfulUserLoginModel: successfulUserLoginModel,
      tinCanDataModel: appProvider.tinCanDataModel,
      appSystemConfigurationModel: appProvider.appSystemConfigurationModel,
      courseLaunchModel: CourseLaunchModel(
        ContentTypeId: courseModel.ContentTypeId,
        MediaTypeId: courseModel.MediaTypeID,
        ScoID: courseModel.ScoID,
        SiteUserID: apiUrlConfigurationProvider.getCurrentSiteId(),
        SiteId: apiUrlConfigurationProvider.getCurrentSiteId(),
        ContentID: courseModel.ContentID,
        locale: apiUrlConfigurationProvider.getLocale(),
        FolderPath: courseModel.FolderPath,
        startPage: courseModel.startpage,
      ),
    );
    url = courseLaunch.getARVRModuleContentModelUrl();

    return url;
  }

  static Future<DataResponseModel<ARContentModel>> getARContentModelFromUrl({required String contentUrl}) async {
    ApiCallModel apiCallModel = await ApiController().getApiCallModelFromData(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.arContentModel,
      url: contentUrl,
      isGetDataFromHive: false,
      isStoreDataInHive: false,
    );

    DataResponseModel<ARContentModel> apiResponseModel = await ApiController().callApi<ARContentModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }
}
