import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as in_app_webview;
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/backend/app/app_controller.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/authentication/authentication_provider.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_controller.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_provider.dart';
import 'package:flutter_instancy_2/backend/course_offline/course_offline_controller.dart';
import 'package:flutter_instancy_2/backend/gamification/gamification_controller.dart';
import 'package:flutter_instancy_2/backend/gamification/gamification_provider.dart';
import 'package:flutter_instancy_2/backend/my_learning/my_learning_controller.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/backend/network_connection/network_connection_controller.dart';
import 'package:flutter_instancy_2/models/authentication/data_model/native_login_dto_model.dart';
import 'package:flutter_instancy_2/models/common/data_response_model.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/models/course_download/data_model/course_download_data_model.dart';
import 'package:flutter_instancy_2/models/course_download/request_model/course_download_request_model.dart';
import 'package:flutter_instancy_2/models/course_launch/data_model/content_status_model.dart';
import 'package:flutter_instancy_2/models/course_launch/data_model/course_launch_model.dart';
import 'package:flutter_instancy_2/models/course_launch/request_model/initial_course_tracking_request_model.dart';
import 'package:flutter_instancy_2/models/course_launch/request_model/insert_course_data_by_token_request_model.dart';
import 'package:flutter_instancy_2/models/course_launch/request_model/web_api_initialize_tracking_request_model.dart';
import 'package:flutter_instancy_2/models/course_launch/response_model/content_status_response_model.dart';
import 'package:flutter_instancy_2/models/gamification/request_model/update_content_gamification_request_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/views/course_launch/components/course_not_downloaded_dialog.dart';
import 'package:open_file_plus/open_file_plus.dart';
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

  Future<void> viewCoCreateKnowledgeContent({required BuildContext context, required CourseDTOModel model}) async {
    MyPrint.printOnConsole("CourseLaunchController().viewCoCreateKnowledgeContent() called");

    int objectType = model.ContentTypeId;
    int mediaType = model.MediaTypeID;
    MyPrint.printOnConsole("objectType:$objectType, mediaType:$mediaType");

    if (objectType == InstancyObjectTypes.flashCard) {
      NavigationController.navigateToFlashCardScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: FlashCardScreenNavigationArguments(courseDTOModel: model),
      );
    } else if (objectType == InstancyObjectTypes.rolePlay) {
      NavigationController.navigateToRolePlayLaunchScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: RolePlayLaunchScreenNavigationArguments(
          courseDTOModel: model,
        ),
      );
    } else if (objectType == InstancyObjectTypes.mediaResource && mediaType == InstancyMediaTypes.image) {
      String imageUrl = AppConfigurationOperations(appProvider: appProvider).getInstancyImageUrlFromImagePath(imagePath: model.ViewLink);
      MyPrint.printOnConsole("Final imageUrl:$imageUrl");

      NavigationController.navigateToCommonViewImageScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: CommonViewImageScreenNavigationArguments(imageUrl: imageUrl),
      );
    } else if (objectType == InstancyObjectTypes.mediaResource && mediaType == InstancyMediaTypes.audio) {
      String documentUrl = AppConfigurationOperations(appProvider: appProvider).getInstancyImageUrlFromImagePath(imagePath: model.ViewLink);
      NavigationController.navigateToPodcastEpisodeScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        argument: PodcastScreenNavigationArguments(courseDTOModel: model, audioUrl: documentUrl),
      );
    } else if (objectType == InstancyObjectTypes.reference && mediaType == InstancyMediaTypes.url) {
      NavigationController.navigateToWebViewScreen(
        navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
        arguments: WebViewScreenNavigationArguments(
          title: model.Title,
          url: "https://smartbridge.com/introduction-generative-ai-transformative-potential-enterprises/",
        ),
      );
    } else if (objectType == InstancyObjectTypes.document && mediaType == InstancyMediaTypes.pDF) {
      String documentUrl = AppConfigurationOperations(appProvider: appProvider).getInstancyImageUrlFromImagePath(imagePath: model.ViewLink);
      MyPrint.printOnConsole("Final documentUrl:$documentUrl");

      NavigationController.navigateToPDFLaunchScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: PDFLaunchScreenNavigationArguments(
          contntName: model.ContentName,
          isNetworkPDF: true,
          pdfUrl: documentUrl,
          // pdfUrl: "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fdocuments%2Fai%20for%20biotechnology.pdf?alt=media&token=ab06fadc-ba08-4114-88e1-529213d117bf",
        ),
      );
    } else if (objectType == InstancyObjectTypes.mediaResource && mediaType == InstancyMediaTypes.video) {
      String videoUrl = AppConfigurationOperations(appProvider: appProvider).getInstancyImageUrlFromImagePath(imagePath: model.startpage);
      MyPrint.printOnConsole("Final videoUrl:$videoUrl");

      NavigationController.navigateToVideoWithTranscriptLaunchScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        argument: VideoWithTranscriptLaunchScreenNavigationArgument(
          title: model.ContentName,
          videoUrl: videoUrl,
          transcript: model.videoContentModel?.scriptText ?? "",
        ),
      );
    } else if (objectType == InstancyObjectTypes.assessment && mediaType == InstancyMediaTypes.test) {
      NavigationController.navigateToQuizScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: QuizScreenNavigationArguments(courseDTOModel: model),
      );
    } else if (objectType == InstancyObjectTypes.webPage) {
      NavigationController.navigateToArticleScreen(
        navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
        arguments: ArticleScreenNavigationArguments(courseDTOModel: model),
      );
      /*NavigationController.navigateToWebViewScreen(
        navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
        arguments: WebViewScreenNavigationArguments(
          title: model.Title,
          url: "https://enterprisedemo.instancy.com/content/publishfiles/1539fc5c-7bde-4d82-a0f6-9612f9e6c426/ins_content.html?fromNativeapp=true",
        ),
      );*/
    } else if (objectType == InstancyObjectTypes.track) {
      NavigationController.navigateToLearningPathScreen(
        navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
        argument: LearningPathScreenNavigationArgument(
          model: model,
          componentId: _componentId,
          componentInstanceId: _componentInstanceId,
        ),
      );
    } else if (objectType == InstancyObjectTypes.contentObject && mediaType == InstancyMediaTypes.microLearning) {
      NavigationController.navigateToMicroLearningScreen(
        navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
        argument: MicroLearningScreenNavigationArgument(
          model: model,
          componentId: _componentId,
          componentInstanceId: _componentInstanceId,
        ),
      );
    }
  }

  Future<bool> viewCourse({
    required BuildContext context,
    required CourseLaunchModel model,
  }) async {
    MyPrint.printOnConsole("CourseLaunchController().viewCourse() called");

    GamificationProvider gamificationProvider = context.read<GamificationProvider>();

    bool networkAvailable = NetworkConnectionController().checkConnection();
    if (![InstancyObjectTypes.track, InstancyObjectTypes.events].contains(model.ContentTypeId) && networkAvailable) {
      await GamificationController(provider: gamificationProvider).UpdateContentGamification(
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

    if (![InstancyObjectTypes.externalTraining, InstancyObjectTypes.physicalProduct].contains(model.ContentTypeId)) {
      if (context.mounted) {
        result = await decideCourseLaunchMethod(
          context: context,
          model: model,
          isContentisolation: false,
        );
      }
    }

    networkAvailable = NetworkConnectionController().checkConnection();
    if (![InstancyObjectTypes.track, InstancyObjectTypes.events].contains(model.ContentTypeId) && networkAvailable) {
      await GamificationController(provider: gamificationProvider).UpdateContentGamification(
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
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseLaunchController().decideCourseLaunchMethod() called with isContentisolation:$isContentisolation", tag: tag);

    CourseDownloadProvider courseDownloadProvider = context.read<CourseDownloadProvider>();

    bool networkAvailable = NetworkConnectionController().checkConnection();
    bool isCourseDownloaded = await CourseDownloadController(appProvider: appProvider, courseDownloadProvider: courseDownloadProvider).checkCourseDownloaded(
      contentId: model.ContentID,
      parentEventTrackContentId: model.ParentEventTrackContentID,
    );

    MyPrint.printOnConsole("networkAvailable:$networkAvailable", tag: tag);
    MyPrint.printOnConsole("isCourseDownloaded:$isCourseDownloaded", tag: tag);

    // launch In Web
    if (kIsWeb) {
      if (!networkAvailable) {
        return false;
      }

      bool isLaunched = false;
      if (context.mounted && context.checkMounted()) {
        isLaunched = await launchCourseOnline(context: context, model: model, isContentIsolation: isContentisolation);
        MyPrint.printOnConsole("isLaunched:$isLaunched", tag: tag);
      }
      return isLaunched;
    } else {
      // launch offline
      if (isCourseDownloaded) {
        bool isLaunched = false;
        if (context.mounted && context.checkMounted()) {
          isLaunched = await launchCourseOffline(context: context, model: model, isContentIsolation: isContentisolation);
          MyPrint.printOnConsole("isLaunched:$isLaunched", tag: tag);
        }
        if (isLaunched) {
          if (!NetworkConnectionController().checkConnection()) {
            MyLearningController.isGetMyLearningData = true;
          }
          await CourseOfflineController().syncCourseDataOnline();
        }
        return isLaunched;
      }
      // launch online
      else if (networkAvailable) {
        bool isLaunched = false;
        if (context.mounted && context.checkMounted()) {
          isLaunched = await launchCourseOnline(context: context, model: model, isContentIsolation: isContentisolation);
          MyPrint.printOnConsole("isLaunched:$isLaunched", tag: tag);
        }
        return isLaunched;
      }
      // launch failed
      else {
        if ([InstancyObjectTypes.track, InstancyObjectTypes.events].contains(model.ContentTypeId)) {
          bool isLaunched = false;
          if (context.mounted && context.checkMounted()) {
            isLaunched = await launchCourseOnline(context: context, model: model, isContentIsolation: isContentisolation);
            MyPrint.printOnConsole("isLaunched:$isLaunched", tag: tag);
          }
          return isLaunched;
        } else {
          if (context.mounted) await showCourseNotDownloadedDialog(context: context);
          return false;
        }
      }
    }
  }

  //region Online Course Launch
  Future<bool> launchCourseOnline({
    required BuildContext context,
    required CourseLaunchModel model,
    bool isContentIsolation = false,
  }) async {
    MyPrint.printOnConsole("CourseLaunchController().launchCourseOnline() called with isContentIsolation:$isContentIsolation");

    MyPrint.printOnConsole('Table2 Objet Id:${model.ContentTypeId}');
    MyPrint.printOnConsole('Table2 Media Id:${model.MediaTypeId}');
    MyPrint.printOnConsole('Table2 JWVideoKey:${model.JWVideoKey}');
    MyPrint.printOnConsole('Table2 Start Page:${model.startPage}');

    try {
      // For Track and Event
      if ([InstancyObjectTypes.track, InstancyObjectTypes.events].contains(model.ContentTypeId)) {
        MyPrint.printOnConsole('Navigation to EventTrackList called');

        await NavigationController.navigateToEventTrackScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: EventTrackScreenArguments(
            eventTrackTabType: model.ContentTypeId == InstancyObjectTypes.track ? EventTrackTabs.trackContents : EventTrackTabs.eventContents,
            objectTypeId: model.ContentTypeId,
            isRelatedContent: model.ContentTypeId == InstancyObjectTypes.events,
            parentContentId: model.ContentID,
            componentId: _componentId,
            scoId: model.ScoID,
            componentInstanceId: _componentInstanceId,
            isContentEnrolled: true,
            eventTrackContentModel: model.courseDTOModel,
            isLoadDataFromOffline: model.isLaunchEventTrackScreenFromOffline,
          ),
        );

        return true;
      }

      String courseSessionId = await getCourseTrackingSessionId(model: model);
      checkNonTrackableContentStatusUpdate(model: model);

      if (model.ContentTypeId == InstancyObjectTypes.assignment) {
        String assignmenturl = '${apiDataProvider.getCurrentSiteUrl()}assignmentdialog/ContentID/${model.ContentID}/SiteID/${model.SiteId}'
            '/ScoID/${model.ScoID}/UserID/${model.SiteUserID}/ismobilecontentview/true';
        MyPrint.printOnConsole('assignmenturl is : $assignmenturl');

        dynamic value = await navigateToLaunchScreen(
          context: context,
          model: model,
          launchUrl: assignmenturl,
        );

        return value == true;
      }
      // For Learning Modules
      else if ([
            InstancyObjectTypes.contentObject,
            InstancyObjectTypes.assessment,
            InstancyObjectTypes.scorm1_2,
            InstancyObjectTypes.reference,
            InstancyObjectTypes.xApi,
          ].contains(model.ContentTypeId) ||
          (model.ContentTypeId == InstancyObjectTypes.track) ||
          (model.ContentTypeId == InstancyObjectTypes.mediaResource && model.MediaTypeId == InstancyMediaTypes.video && model.JWVideoKey.isNotEmpty)) {
        if (isContentIsolation) {
          MyPrint.printOnConsole("Returning from CourseLaunchController().launchCourseOnline() because isContentisolation is true");
          return false;
        }

        NativeLoginDTOModel? successfulUserLoginModel = authenticationProvider.getEmailLoginResponseModel();
        if (successfulUserLoginModel == null) {
          MyPrint.printOnConsole("Returning from CourseLaunchController().launchCourseOnline() because successfulUserLoginModel is null");
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
          MyPrint.printOnConsole("Returning from CourseLaunchController().launchCourseOnline() because courseUrl is empty");
          return false;
        }

        if (model.ContentTypeId == InstancyObjectTypes.reference) {
          dynamic value = await navigateToLaunchScreen(
            context: context,
            model: model,
            launchUrl: courseUrl,
          );

          return value == true;
        } else {
          String courseTrackingToken = await getCourseLaunchTokenId(
            courseUrl: courseUrl,
            model: model,
            courseSessionId: courseSessionId,
          );

          MyPrint.printOnConsole("Course Tracking Token:'$courseTrackingToken'");

          if (courseTrackingToken.isEmpty) {
            MyPrint.printOnConsole("Returning from CourseLaunchController().launchCourseOnline() because courseTrackingToken is empty");
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

          if (!context.mounted) {
            return false;
          }
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
      }
      // For Coursebot
      else if (model.ContentTypeId == InstancyObjectTypes.courseBot) {
        return await NavigationController.navigateToInstaBotScreen2(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: InstaBotScreen2NavigationArguments(
            courseId: model.ContentID,
          ),
        );
      }
      // For AR Content
      else if (AppConfigurationOperations.isARContent(contentTypeId: model.ContentTypeId, mediaTypeId: model.MediaTypeId)) {
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
        if (url.isNotEmpty && context.mounted) {
          dynamic value = await navigateToLaunchScreen(
            context: context,
            model: model,
            launchUrl: url,
          );
          MyPrint.printOnConsole('CourseLaunchController().launchCourseOnline() value $value');
          // return value == true;
          return true;
        }
      }
      // For All the Other Content Types
      else {
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
        if (url.isNotEmpty && context.mounted) {
          dynamic value = await navigateToLaunchScreen(
            context: context,
            model: model,
            launchUrl: url,
          );
          MyPrint.printOnConsole('CourseLaunchController().launchCourseOnline() value $value');
          // return value == true;
          return true;
        }
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseLaunchController().launchCourseOnline():$e");
      MyPrint.printOnConsole(s);
    }

    return false;
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

  //endregion

  //region Offline Course Launch
  Future<bool> launchCourseOffline({
    required BuildContext context,
    required CourseLaunchModel model,
    bool isContentIsolation = false,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseLaunchController().launchCourseOffline() called with isContentIsolation:$isContentIsolation", tag: tag);

    MyPrint.printOnConsole('Table2 Objet Id:${model.ContentTypeId}', tag: tag);
    MyPrint.printOnConsole('Table2 Media Id:${model.MediaTypeId}', tag: tag);
    MyPrint.printOnConsole('Table2 JWVideoKey:${model.JWVideoKey}', tag: tag);
    MyPrint.printOnConsole('Table2 Start Page:${model.startPage}', tag: tag);

    try {
      // For Track and Event
      if ([InstancyObjectTypes.track, InstancyObjectTypes.events].contains(model.ContentTypeId)) {
        // Need to open EventTrackListTabsActivity
        MyPrint.printOnConsole('Navigation to EventTrackList called', tag: tag);

        /*await NavigationController.navigateToEventTrackScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: EventTrackScreenArguments(
            objectTypeId: model.ContentTypeId,
            isRelatedContent: model.ContentTypeId != InstancyObjectTypes.track,
            parentContentId: model.ContentID,
            componentId: _componentId,
            scoId: model.ScoID,
            eventTrackTabType: model.ContentTypeId == InstancyObjectTypes.track ? EventTrackTabs.trackContents : EventTrackTabs.eventContents,
            componentInstanceId: _componentInstanceId,
            isContentEnrolled: true,
          ),
        );*/

        return false;
      }

      Completer<void> checkNonTrackableContentStatusUpdateOfflineCompleter = Completer<void>();
      checkNonTrackableContentStatusUpdateOffline(model: model).whenComplete(() {
        checkNonTrackableContentStatusUpdateOfflineCompleter.complete();
      });

      // For Learning Modules
      if ([
            InstancyObjectTypes.contentObject,
            InstancyObjectTypes.assessment,
            InstancyObjectTypes.scorm1_2,
            InstancyObjectTypes.reference,
            InstancyObjectTypes.xApi,
            InstancyObjectTypes.webPage,
            InstancyObjectTypes.dictionaryGlossary,
          ].contains(model.ContentTypeId) ||
          (model.ContentTypeId == InstancyObjectTypes.mediaResource && model.MediaTypeId == InstancyMediaTypes.video && model.JWVideoKey.isNotEmpty)) {
        String folderPath = await CourseDownloadController(
          appProvider: appProvider,
          courseDownloadProvider: CourseDownloadProvider(),
        ).getCourseDownloadDirectoryPath(
          courseDownloadRequestModel: CourseDownloadRequestModel(
            ContentID: model.ContentID,
            FolderPath: model.FolderPath,
          ),
          parentEventTrackId: model.ParentEventTrackContentID,
        );

        MyPrint.printOnConsole("folderPath:'$folderPath'", tag: tag);

        if (folderPath.isEmpty) {
          MyPrint.printOnConsole("Returning from CourseLaunchController().launchCourseOffline() because folderPath is empty", tag: tag);
          return false;
        }

        String startPage = model.startPage;

        if (model.ContentTypeId == InstancyObjectTypes.dictionaryGlossary) {
          startPage = "glossary_english.html";
        }

        String finalFilePath = "$folderPath${AppController.getPathSeparator()}$startPage";
        MyPrint.printOnConsole("finalFilePath:'$finalFilePath'", tag: tag);

        bool isPathExist = await AppController.checkCourseFileDirectoryExist(path: finalFilePath, isFile: true);
        MyPrint.printOnConsole("isPathExist:$isPathExist", tag: tag);

        if (!isPathExist) {
          MyPrint.printOnConsole("Returning from CourseLaunchController().launchCourseOffline() because finalFilePath is not exist i file system", tag: tag);
          return false;
        }

        if (!checkNonTrackableContentStatusUpdateOfflineCompleter.isCompleted) await checkNonTrackableContentStatusUpdateOfflineCompleter.future;

        if (!context.mounted) {
          MyPrint.printOnConsole("Returning from CourseLaunchController().launchCourseOffline() because context not mounted", tag: tag);
          return false;
        }

        dynamic value = await navigateToOfflineLaunchScreen(
          context: context,
          model: model,
          launchPath: finalFilePath,
          courseDirectoryPath: folderPath,
        );
        return value == true;
      }

      CourseDownloadController courseDownloadController = CourseDownloadController(
        appProvider: appProvider,
        courseDownloadProvider: CourseDownloadProvider(),
      );
      CourseDownloadRequestModel courseDownloadRequestModel = CourseDownloadRequestModel(
        ContentID: model.ContentID,
        FolderPath: model.FolderPath,
        JWStartPage: model.jwstartpage,
        JWVideoKey: model.JWVideoKey,
        StartPage: model.startPage,
        ContentTypeId: model.ContentTypeId,
        MediaTypeID: model.MediaTypeId,
        SiteId: model.SiteId,
        UserID: model.SiteUserID,
        ScoId: model.ScoID,
      );

      String folderPath = await courseDownloadController.getCourseDownloadDirectoryPath(
        courseDownloadRequestModel: courseDownloadRequestModel,
        parentEventTrackId: model.ParentEventTrackContentID,
      );
      MyPrint.printOnConsole("folderPath:'$folderPath'", tag: tag);

      String fileName = courseDownloadController.getCourseDownloadFileName(courseDownloadRequestModel: courseDownloadRequestModel);
      MyPrint.printOnConsole("fileName:'$fileName'", tag: tag);

      if (folderPath.isEmpty) {
        MyPrint.printOnConsole("Returning from CourseLaunchController().launchCourseOffline() because downloadFolderPath is empty", tag: tag);
        return false;
      } else if (fileName.isEmpty) {
        MyPrint.printOnConsole("Returning from CourseLaunchController().launchCourseOffline() because downloadFileName is empty", tag: tag);
        return false;
      }

      String finalFilePath = "$folderPath${AppController.getPathSeparator()}$fileName";
      MyPrint.printOnConsole("finalFilePath:'$finalFilePath'", tag: tag);

      bool isPathExist = await AppController.checkCourseFileDirectoryExist(path: finalFilePath, isFile: true);
      MyPrint.printOnConsole("isPathExist:$isPathExist", tag: tag);

      if (!isPathExist) {
        MyPrint.printOnConsole("Returning from CourseLaunchController().launchCourseOffline() because finalFilePath is not exist i file system", tag: tag);
        return false;
      }

      if (!context.mounted) {
        MyPrint.printOnConsole("Returning from CourseLaunchController().launchCourseOffline() because context not mounted", tag: tag);
        return false;
      }

      //For Pdf
      if ([InstancyMediaTypes.pDF].contains(model.MediaTypeId) || finalFilePath.endsWith("pdf")) {
        dynamic value = await NavigationController.navigateToPDFLaunchScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: PDFLaunchScreenNavigationArguments(
            isNetworkPDF: false,
            pdfFilePath: finalFilePath,
            contntName: model.ContentName,
          ),
        );

        if (!checkNonTrackableContentStatusUpdateOfflineCompleter.isCompleted) await checkNonTrackableContentStatusUpdateOfflineCompleter.future;

        if (value is! bool) {
          return true;
        }

        return value;
      }
      //For Other Documents
      else if ([InstancyMediaTypes.word, InstancyMediaTypes.excel, InstancyMediaTypes.csv, InstancyMediaTypes.ppt].contains(model.MediaTypeId)) {
        OpenResult result = await OpenFile.open(finalFilePath);
        if (result.type != ResultType.done) {
          if (context.mounted) {
            SnackBar snackBar = SnackBar(content: Text(result.message));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
          return false;
        }

        // await Future.delayed(const Duration(seconds: 1));
        if (!checkNonTrackableContentStatusUpdateOfflineCompleter.isCompleted) await checkNonTrackableContentStatusUpdateOfflineCompleter.future;

        return true;
      }
      // For Coursebot
      else if (model.ContentTypeId == InstancyObjectTypes.courseBot) {
        if (!checkNonTrackableContentStatusUpdateOfflineCompleter.isCompleted) await checkNonTrackableContentStatusUpdateOfflineCompleter.future;

        return await NavigationController.navigateToInstaBotScreen2(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: InstaBotScreen2NavigationArguments(
            courseId: model.ContentID,
          ),
        );
      }
      // For AR Content
      else if (AppConfigurationOperations.isARContent(contentTypeId: model.ContentTypeId, mediaTypeId: model.MediaTypeId)) {}

      if (!checkNonTrackableContentStatusUpdateOfflineCompleter.isCompleted) await checkNonTrackableContentStatusUpdateOfflineCompleter.future;

      // For All the Other Content Types
      dynamic value = await navigateToOfflineLaunchScreen(
        context: context,
        model: model,
        launchPath: finalFilePath,
        courseDirectoryPath: folderPath,
      );
      return value == true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in CourseLaunchController().launchCourseOffline():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    return false;
  }

  //endregion

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
      InstancyObjectTypes.dictionaryGlossary,
      InstancyObjectTypes.html,
      InstancyObjectTypes.webPage,
      InstancyObjectTypes.mediaResource,
      InstancyObjectTypes.xApi,
      InstancyObjectTypes.cmi5,
      InstancyObjectTypes.scorm1_2,
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
        parentEventTrackContentId: model.ParentEventTrackContentID,
      );
    } else {
      MyPrint.printOnConsole("Have to update tracking status for MediaTypes", tag: tag);

      await updateContentStatusToInProgressForNonTrackingContents(userId: model.SiteUserID, scoId: model.ScoID);
    }
  }

  Future<void> checkNonTrackableContentStatusUpdateOffline({required CourseLaunchModel model}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseLaunchController().checkNonTrackableContentStatusUpdateOffline() called", tag: tag);

    MyPrint.printOnConsole("model.ContentTypeId:${model.ContentTypeId}", tag: tag);

    CourseDownloadProvider courseDownloadProvider = AppController.mainAppContext!.read<CourseDownloadProvider>();
    CourseDownloadController courseDownloadController = CourseDownloadController(appProvider: appProvider, courseDownloadProvider: courseDownloadProvider);

    CourseDownloadDataModel? courseDownloadDataModel = courseDownloadProvider.getCourseDownloadDataModelFromId(
      courseDownloadId: CourseDownloadDataModel.getDownloadId(
        contentId: model.ContentID,
        eventTrackContentId: model.ParentEventTrackContentID,
      ),
    );

    if (courseDownloadDataModel == null) {
      MyPrint.printOnConsole("Returning from CourseLaunchController().checkNonTrackableContentStatusUpdateOffline() because Course not downloaded", tag: tag);
      return;
    }

    if (![
      InstancyObjectTypes.dictionaryGlossary,
      InstancyObjectTypes.html,
      InstancyObjectTypes.webPage,
      InstancyObjectTypes.mediaResource,
      InstancyObjectTypes.xApi,
      InstancyObjectTypes.cmi5,
      InstancyObjectTypes.scorm1_2,
      InstancyObjectTypes.reference,
      InstancyObjectTypes.document,
    ].contains(model.ContentTypeId)) {
      MyPrint.printOnConsole("Returning from CourseLaunchController().checkNonTrackableContentStatusUpdateOffline() because Content Type is not valid", tag: tag);
      return;
    }

    //region Exceptional Media Type Validation
    if ([
      InstancyMediaTypes.corpAcademy,
      InstancyMediaTypes.psyTechAssessment,
      InstancyMediaTypes.dISCAssessment,
      InstancyMediaTypes.assessment24x7,
    ].contains(model.MediaTypeId)) {
      MyPrint.printOnConsole("Returning from CourseLaunchController().checkNonTrackableContentStatusUpdateOffline() because Media Type is not valid", tag: tag);
      return;
    }
    //endregion

    //region Content Status Validation
    MyPrint.printOnConsole("ActualStatus:${model.ActualStatus}", tag: tag);
    if (model.ActualStatus == ContentStatusTypes.completed) {
      MyPrint.printOnConsole("Returning from CourseLaunchController().checkNonTrackableContentStatusUpdateOffline() because Content Status is Completed already", tag: tag);
      return;
    }
    //endregion

    bool autocompleteNonTrackableContent = appProvider.appSystemConfigurationModel.autocompleteNonTrackableContent;
    MyPrint.printOnConsole("autocompleteNonTrackableContent:$autocompleteNonTrackableContent", tag: tag);

    if (autocompleteNonTrackableContent) {
      MyPrint.printOnConsole("Have to update status to completed", tag: tag);

      await courseDownloadController.setCompleteDownload(courseDownloadDataModel: courseDownloadDataModel);
    } else {
      MyPrint.printOnConsole("Have to update tracking status for MediaTypes", tag: tag);

      await courseDownloadController.setContentToInProgress(courseDownloadDataModel: courseDownloadDataModel);
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
    MyPrint.printOnConsole("CourseLaunchController().navigateToLaunchScreen() called with MediaTypeId:${model.MediaTypeId}");

    if (model.MediaTypeId == InstancyMediaTypes.pDF || launchUrl.contains(".pdf")) {
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
      in_app_webview.ChromeSafariBrowser browser = in_app_webview.ChromeSafariBrowser();
      await browser.open(
        url: in_app_webview.WebUri(launchUrl),
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

  Future navigateToOfflineLaunchScreen({
    required BuildContext context,
    required CourseLaunchModel model,
    required String launchPath,
    required String courseDirectoryPath,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseLaunchController().navigateToOfflineLaunchScreen() called with launchPath:'$launchPath'", tag: tag);

    if (launchPath.isEmpty) {
      MyPrint.printOnConsole("Returning from CourseLaunchController().navigateToOfflineLaunchScreen() because launchPath is empty", tag: tag);
      return;
    }

    if (model.MediaTypeId == InstancyMediaTypes.pDF || launchPath.contains(".pdf")) {
      return NavigationController.navigateToPDFLaunchScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: PDFLaunchScreenNavigationArguments(
          contntName: model.ContentName,
          pdfUrl: launchPath,
          isNetworkPDF: false,
        ),
      );
    } else if (AppConfigurationOperations.isARContent(contentTypeId: model.ContentTypeId, mediaTypeId: model.MediaTypeId)) {
    } else {
      return NavigationController.navigateToCourseOfflineLaunchWebViewScreen(
        navigationOperationParameters: NavigationOperationParameters(
          context: context,
          navigationType: NavigationType.pushNamed,
        ),
        arguments: CourseOfflineLaunchWebViewScreenNavigationArguments(
          coursePath: launchPath,
          courseDirectoryPath: courseDirectoryPath,
          courseName: model.ContentName,
          courseLaunchModel: model,
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
        SiteUserID: courseModel.SiteUserID,
        SiteId: courseModel.SiteId,
        ContentID: courseModel.ContentID,
        locale: apiUrlConfigurationProvider.getLocale(),
        FolderPath: courseModel.FolderPath,
        startPage: courseModel.startpage,
        courseDTOModel: courseModel,
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

  Future<void> showCourseNotDownloadedDialog({required BuildContext context}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("CourseLaunchController().showCourseNotDownloadedDialog() called", tag: tag);

    await showDialog(
      context: context,
      builder: (BuildContext context) => const CourseNotDownloadedDialog(),
    );

    MyPrint.printOnConsole("CourseLaunchController().showCourseNotDownloadedDialog() completed", tag: tag);
  }

  Future<bool> updateTrackListViewBookmark({required String scoId, required String trackId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("DiscussionController().createDiscussionForum() called '", tag: tag);

    DataResponseModel<String> dataResponseModel = await _courseLaunchRepository.updateTrackListViewBookmark(scoId: scoId, trackId: trackId);

    MyPrint.printOnConsole("createDiscussionForum response:$dataResponseModel", tag: tag);

    if (dataResponseModel.appErrorModel != null) {
      MyPrint.printOnConsole("Returning from DiscussionController().createDiscussionForum() because createDiscussionForum had some error", tag: tag);
      return false;
    }

    return dataResponseModel.data == "1";
  }
}
