import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_controller.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_provider.dart';
import 'package:flutter_instancy_2/backend/ui_actions/my_course_download/my_course_download_ui_action_callback_model.dart';
import 'package:flutter_instancy_2/backend/ui_actions/my_course_download/my_course_download_ui_actions_controller.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/local_str.dart';
import 'package:flutter_instancy_2/models/course_download/data_model/course_download_data_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:flutter_instancy_2/views/common/components/instancy_ui_actions/instancy_ui_actions.dart';
import 'package:flutter_instancy_2/views/course_download/components/my_course_download_card.dart';
import 'package:provider/provider.dart';

class MyCourseDownloadScreen extends StatefulWidget {
  const MyCourseDownloadScreen({super.key});

  @override
  State<MyCourseDownloadScreen> createState() => _MyCourseDownloadScreenState();
}

class _MyCourseDownloadScreenState extends State<MyCourseDownloadScreen> {
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CourseDownloadProvider>.value(value: courseDownloadProvider),
      ],
      child: Consumer<CourseDownloadProvider>(
        builder: (BuildContext context, CourseDownloadProvider courseDownloadProvider, Widget? child) {
          return Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: getMyDownloadsListView(),
                ),
              ],
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
        itemCount: downloadData.length,
        itemBuilder: (BuildContext context, int index) {
          String downloadId = downloadData[index];
          CourseDownloadDataModel? model = courseDownloadProvider.getCourseDownloadDataModelFromId(courseDownloadId: downloadId, isNewInstance: false);

          if (model == null || model.courseDTOModel == null) return const SizedBox();

          return getMyLearningContentWidget(model: model);
        },
      ),
    );
  }

  Widget getMyLearningContentWidget({
    required CourseDownloadDataModel model,
  }) {
    return MyCourseDownloadCard(
      courseDownloadDataModel: model,
      onMoreButtonTap: () {
        showMoreAction(model: model);
      },
      onDownloadTap: () async {
        onDownloadButtonTapped(courseDownloadDataModel: model);
      },
    );
  }
}
