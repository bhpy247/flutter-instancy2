import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/api/api_url_configuration_provider.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/authentication/authentication_provider.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_controller.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_provider.dart';
import 'package:flutter_instancy_2/backend/course_launch/course_launch_controller.dart';
import 'package:flutter_instancy_2/backend/ui_actions/my_course_download/my_course_download_ui_action_callback_model.dart';
import 'package:flutter_instancy_2/backend/ui_actions/my_course_download/my_course_download_ui_actions_controller.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/local_str.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/models/course_download/data_model/course_download_data_model.dart';
import 'package:flutter_instancy_2/models/course_launch/data_model/course_launch_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/related_track_data_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/track_course_dto_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:flutter_instancy_2/views/common/components/instancy_ui_actions/instancy_ui_actions.dart';
import 'package:flutter_instancy_2/views/common/components/modal_progress_hud.dart';
import 'package:flutter_instancy_2/views/course_download/components/my_course_download_card.dart';
import 'package:provider/provider.dart';

class MyCourseDownloadScreen extends StatefulWidget {
  const MyCourseDownloadScreen({super.key});

  @override
  State<MyCourseDownloadScreen> createState() => _MyCourseDownloadScreenState();
}

class _MyCourseDownloadScreenState extends State<MyCourseDownloadScreen> with MySafeState {
  bool isLoading = false;

  late AppProvider appProvider;
  late CourseDownloadProvider courseDownloadProvider;
  late CourseDownloadController courseDownloadController;

  Future<void> getMyDownloads({bool isRefresh = true, bool isNotify = true}) async {
    await courseDownloadController.getAllMyCourseDownloadsAndSaveInProvider(isRefresh: isRefresh, isNotify: isNotify);
  }

  MyCourseDownloadUIActionCallbackModel getMyCourseDownloadUIActionCallbackModel({
    required CourseDownloadDataModel model,
    bool isSecondaryAction = true,
  }) {
    return MyCourseDownloadUIActionCallbackModel(
      onRemoveFromDownloadTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        courseDownloadController.removeFromDownload(downloadId: model.id);
      },
      onCancelDownloadTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        courseDownloadController.cancelDownload(downloadId: model.id);
      },
      onPauseDownloadTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        courseDownloadController.pauseDownload(downloadId: model.id);
      },
      onResumeDownloadTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        courseDownloadController.resumeDownload(downloadId: model.id);
      },
      onSetCompleteTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        isLoading = true;
        mySetState();

        await courseDownloadController.setCompleteDownload(courseDownloadDataModel: model);

        isLoading = false;
        mySetState();
      },
    );
  }

  Future<void> showMoreAction({required CourseDownloadDataModel model}) async {
    LocalStr localStr = appProvider.localStr;

    MyCourseDownloadUIActionsController courseDownloadUIActionsController = MyCourseDownloadUIActionsController(appProvider: appProvider);

    List<InstancyUIActionModel> options = courseDownloadUIActionsController
        .getMyCourseDownloadsScreenSecondaryActions(
          courseDownloadDataModel: model,
          localStr: localStr,
          myCourseDownloadUIActionCallbackModel: getMyCourseDownloadUIActionCallbackModel(
            model: model,
            isSecondaryAction: true,
          ),
        )
        .toSet()
        .toList();

    if (options.isEmpty) {
      return;
    }

    InstancyUIActions().showAction(
      context: context,
      actions: options,
    );
  }

  Future<void> onDownloadButtonTapped({required CourseDownloadDataModel courseDownloadDataModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("onDownloadTap called", tag: tag);

    String downloadId = courseDownloadDataModel.id;

    if (courseDownloadDataModel.isFileDownloading) {
      MyPrint.printOnConsole("Course Downloading", tag: tag);
      courseDownloadController.pauseDownload(downloadId: downloadId);
    } else if (courseDownloadDataModel.isFileDownloadingPaused) {
      MyPrint.printOnConsole("Course Paused", tag: tag);
      courseDownloadController.resumeDownload(downloadId: downloadId);
    } else {
      MyPrint.printOnConsole("Invalid Download Command", tag: tag);
    }
  }

  Future<void> onContentLaunchTap({required CourseDownloadDataModel model}) async {
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = courseDownloadController.courseDownloadRepository.apiController.apiDataProvider;

    CourseLaunchModel? courseLaunchModel;

    if (model.parentCourseModel != null) {
      CourseDTOModel courseDTOModel = model.parentCourseModel!;

      courseLaunchModel = CourseLaunchModel(
        ContentID: courseDTOModel.ContentID,
        ScoID: courseDTOModel.ScoID,
        ContentTypeId: courseDTOModel.ContentTypeId,
        MediaTypeId: courseDTOModel.MediaTypeID,
        SiteUserID: courseDTOModel.SiteUserID,
        SiteId: courseDTOModel.SiteId,
        locale: apiUrlConfigurationProvider.getLocale(),
        ActivityId: courseDTOModel.ActivityId,
        ActualStatus: courseDTOModel.ActualStatus,
        ContentName: courseDTOModel.ContentName,
        FolderPath: courseDTOModel.FolderPath,
        JWVideoKey: courseDTOModel.JWVideoKey,
        jwstartpage: courseDTOModel.jwstartpage,
        startPage: courseDTOModel.startpage,
        courseDTOModel: courseDTOModel,
        isLaunchEventTrackScreenFromOffline: true,
      );
    } else if (model.courseDTOModel != null) {
      CourseDTOModel courseDTOModel = model.courseDTOModel!;

      courseLaunchModel = CourseLaunchModel(
        ContentID: courseDTOModel.ContentID,
        ScoID: courseDTOModel.ScoID,
        ContentTypeId: courseDTOModel.ContentTypeId,
        MediaTypeId: courseDTOModel.MediaTypeID,
        SiteUserID: courseDTOModel.SiteUserID,
        SiteId: courseDTOModel.SiteId,
        locale: apiUrlConfigurationProvider.getLocale(),
        ActivityId: courseDTOModel.ActivityId,
        ActualStatus: courseDTOModel.ActualStatus,
        ContentName: courseDTOModel.ContentName,
        FolderPath: courseDTOModel.FolderPath,
        JWVideoKey: courseDTOModel.JWVideoKey,
        jwstartpage: courseDTOModel.jwstartpage,
        startPage: courseDTOModel.startpage,
        courseDTOModel: courseDTOModel,
      );
    } else if (model.trackCourseDTOModel != null) {
      TrackCourseDTOModel trackCourseDTOModel = model.trackCourseDTOModel!;

      courseLaunchModel = CourseLaunchModel(
        ContentTypeId: trackCourseDTOModel.ContentTypeId,
        MediaTypeId: trackCourseDTOModel.MediaTypeID,
        ScoID: trackCourseDTOModel.ScoID,
        SiteUserID: ApiController().apiDataProvider.getCurrentUserId(),
        SiteId: ApiController().apiDataProvider.getCurrentSiteId(),
        ContentID: trackCourseDTOModel.ContentID,
        ParentEventTrackContentID: model.parentContentId,
        ParentContentTypeId: model.parentContentTypeId,
        ParentContentScoId: model.parentContentScoId,
        locale: ApiController().apiDataProvider.getLocale(),
        ActivityId: trackCourseDTOModel.ActivityId,
        ActualStatus: trackCourseDTOModel.CoreLessonStatus,
        ContentName: trackCourseDTOModel.ContentName,
        FolderPath: trackCourseDTOModel.FolderPath,
        JWVideoKey: trackCourseDTOModel.JWVideoKey,
        jwstartpage: trackCourseDTOModel.jwstartpage,
        startPage: trackCourseDTOModel.startpage,
        trackCourseDTOModel: trackCourseDTOModel,
      );
    } else if (model.relatedTrackDataDTOModel != null) {
      RelatedTrackDataDTOModel relatedTrackDataDTOModel = model.relatedTrackDataDTOModel!;

      courseLaunchModel = CourseLaunchModel(
        ContentTypeId: relatedTrackDataDTOModel.ContentTypeId,
        MediaTypeId: relatedTrackDataDTOModel.MediaTypeID,
        ScoID: relatedTrackDataDTOModel.ScoID,
        SiteUserID: ApiController().apiDataProvider.getCurrentUserId(),
        SiteId: ApiController().apiDataProvider.getCurrentSiteId(),
        ContentID: relatedTrackDataDTOModel.ContentID,
        ParentEventTrackContentID: model.parentContentId,
        ParentContentTypeId: model.parentContentTypeId,
        ParentContentScoId: model.parentContentScoId,
        locale: ApiController().apiDataProvider.getLocale(),
        ActivityId: relatedTrackDataDTOModel.ActivityId,
        ActualStatus: relatedTrackDataDTOModel.CoreLessonStatus,
        ContentName: relatedTrackDataDTOModel.Name,
        FolderPath: relatedTrackDataDTOModel.FolderPath,
        JWVideoKey: relatedTrackDataDTOModel.JWVideoKey,
        jwstartpage: relatedTrackDataDTOModel.jwstartpage,
        startPage: relatedTrackDataDTOModel.startpage,
        relatedTrackDataDTOModel: relatedTrackDataDTOModel,
      );
    }

    if (courseLaunchModel == null) {
      return;
    }

    isLoading = true;
    mySetState();

    bool isLaunched = await CourseLaunchController(
      appProvider: appProvider,
      authenticationProvider: context.read<AuthenticationProvider>(),
      componentId: InstancyComponents.MyCourseDownloads,
      componentInstanceId: 0,
    ).viewCourse(
      context: context,
      model: courseLaunchModel,
    );

    isLoading = false;
    mySetState();

    if (isLaunched) {
      getMyDownloads(
        isRefresh: true,
        isNotify: true,
      );
    }
  }

  @override
  void initState() {
    super.initState();

    appProvider = context.read<AppProvider>();
    courseDownloadProvider = context.read<CourseDownloadProvider>();
    courseDownloadController = CourseDownloadController(appProvider: appProvider, courseDownloadProvider: courseDownloadProvider);

    getMyDownloads(isRefresh: false, isNotify: false);
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CourseDownloadProvider>.value(value: courseDownloadProvider),
      ],
      child: Consumer<CourseDownloadProvider>(
        builder: (BuildContext context, CourseDownloadProvider courseDownloadProvider, Widget? child) {
          return ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Scaffold(
              body: Column(
                children: [
                  Expanded(
                    child: getMyDownloadsListView(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget getMyDownloadsListView() {
    if (courseDownloadProvider.isLoadingCourseDownloadsData.get()) {
      return const CommonLoader(isCenter: true);
    } else if (courseDownloadProvider.courseDownloadList.length == 0) {
      return RefreshIndicator(
        onRefresh: () async {
          getMyDownloads(
            isRefresh: true,
            isNotify: true,
          );
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: context.sizeData.height * 0.2),
            AppConfigurations.commonNoDataView(),
          ],
        ),
      );
    }

    List<String> downloadData = courseDownloadProvider.courseDownloadList.getList(isNewInstance: false).toList();

    List<CourseDownloadDataModel> newList = <CourseDownloadDataModel>[];
    List<String> eventTrackContentId = <String>[];
    for (String downloadId in downloadData) {
      CourseDownloadDataModel? model = courseDownloadProvider.getCourseDownloadDataModelFromId(courseDownloadId: downloadId, isNewInstance: false);

      if (model != null && (model.courseDTOModel != null || model.trackCourseDTOModel != null || model.relatedTrackDataDTOModel != null)) {
        if (model.parentCourseModel == null) {
          newList.add(model);
        } else {
          if (!eventTrackContentId.contains(model.parentCourseModel!.ContentID)) {
            newList.add(model);
            eventTrackContentId.add(model.parentCourseModel!.ContentID);
          }
        }
      }
    }

    if (newList.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          getMyDownloads(
            isRefresh: true,
            isNotify: true,
          );
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: context.sizeData.height * 0.2),
            AppConfigurations.commonNoDataView(),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        getMyDownloads(
          isRefresh: true,
          isNotify: true,
        );
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: newList.length,
        itemBuilder: (BuildContext context, int index) {
          CourseDownloadDataModel model = newList[index];

          return getMyCourseDownloadCardWidget(model: model);
        },
      ),
    );
  }

  Widget getMyCourseDownloadCardWidget({required CourseDownloadDataModel model}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: MyCourseDownloadCard(
        courseDownloadDataModel: model,
        isShowMoreOption: model.parentCourseModel == null,
        onMoreButtonTap: () {
          showMoreAction(model: model);
        },
        onDownloadTap: () async {
          onDownloadButtonTapped(courseDownloadDataModel: model);
        },
        onPrimaryActionTap: () {
          onContentLaunchTap(model: model);
        },
      ),
    );
  }
}
