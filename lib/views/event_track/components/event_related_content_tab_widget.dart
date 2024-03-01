import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/api/api_url_configuration_provider.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_controller.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_provider.dart';
import 'package:flutter_instancy_2/backend/my_learning/my_learning_provider.dart';
import 'package:flutter_instancy_2/backend/ui_actions/event_track/event_track_ui_action_callback_model.dart';
import 'package:flutter_instancy_2/backend/ui_actions/my_course_download/my_course_download_ui_action_callback_model.dart';
import 'package:flutter_instancy_2/backend/ui_actions/my_course_download/my_course_download_ui_actions_controller.dart';
import 'package:flutter_instancy_2/backend/ui_actions/my_learning/my_learning_ui_action_configs.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/models/common/pagination/pagination_model.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/models/course_download/data_model/course_download_data_model.dart';
import 'package:flutter_instancy_2/models/course_download/request_model/course_download_request_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/related_track_data_dto_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:provider/provider.dart';

import '../../../backend/profile/profile_provider.dart';
import '../../../backend/ui_actions/event_track/event_track_ui_actions_controller.dart';
import '../../../backend/ui_actions/primary_secondary_actions/primary_secondary_actions.dart';
import '../../../models/app_configuration_models/data_models/local_str.dart';
import '../../../utils/my_print.dart';
import '../../common/components/instancy_ui_actions/instancy_ui_actions.dart';
import 'event_related_content_card.dart';

class EventRelatedContentTabWidget extends StatefulWidget {
  final List<RelatedTrackDataDTOModel> relatedContentsList;
  final PaginationModel paginationModel;
  final int contentsLength;
  final CourseDTOModel parentCourseModel;
  final int userId;
  final int componentId;
  final int componentInsId;
  final CourseDownloadProvider? courseDownloadProvider;
  final void Function()? onPulledTORefresh;
  final void Function()? onPagination;
  final void Function()? refreshParentAndChildContentsCallback;
  final void Function({required RelatedTrackDataDTOModel model})? onContentViewTap;
  final void Function({required RelatedTrackDataDTOModel model})? onSetCompleteTap;

  const EventRelatedContentTabWidget({
    super.key,
    required this.relatedContentsList,
    required this.paginationModel,
    required this.contentsLength,
    required this.parentCourseModel,
    required this.userId,
    required this.componentId,
    required this.componentInsId,
    required this.courseDownloadProvider,
    this.onPulledTORefresh,
    this.onPagination,
    this.refreshParentAndChildContentsCallback,
    this.onContentViewTap,
    this.onSetCompleteTap,
  });

  @override
  State<EventRelatedContentTabWidget> createState() => _EventRelatedContentTabWidgetState();
}

class _EventRelatedContentTabWidgetState extends State<EventRelatedContentTabWidget> {
  late AppProvider appProvider;

  late CourseDownloadProvider courseDownloadProvider;
  late CourseDownloadController courseDownloadController;

  EventTrackUIActionCallbackModel getUIActionCallbackModel({
    required RelatedTrackDataDTOModel model,
    InstancyContentActionsEnum? primaryAction,
    bool isSecondaryAction = true,
  }) {
    MyPrint.printOnConsole("In the content tab widget");
    return EventTrackUIActionCallbackModel(
      onSetCompleteTap: () {
        if (isSecondaryAction) Navigator.pop(context);
        if (widget.onSetCompleteTap != null) {
          widget.onSetCompleteTap!(model: model);
        }
      },
      onViewTap: primaryAction == InstancyContentActionsEnum.View
          ? null
          : () async {
              if (isSecondaryAction) Navigator.pop(context);

              if (widget.onContentViewTap != null) {
                widget.onContentViewTap!(model: model);
              }
            },
      onPlayTap: primaryAction == InstancyContentActionsEnum.Play
          ? null
          : () async {
              if (isSecondaryAction) Navigator.pop(context);

              if (widget.onContentViewTap != null) {
                widget.onContentViewTap!(model: model);
              }
            },
    );
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

        await courseDownloadController.setCompleteDownload(courseDownloadDataModel: model);

        if (widget.onPulledTORefresh != null) widget.onPulledTORefresh!();
      },
    );
  }

  Future<void> showMoreAction({required RelatedTrackDataDTOModel model}) async {
    MyPrint.printOnConsole("showMoreAction called for EventTrackContent:${model.ContentID}");

    LocalStr localStr = appProvider.localStr;

    ProfileProvider profileProvider = context.read<ProfileProvider>();

    List<InstancyUIActionModel> options = <InstancyUIActionModel>[];

    if (MyLearningUIActionConfigs.isContentTypeDownloadable(objectTypeId: model.ContentTypeId, mediaTypeId: model.MediaTypeID)) {
      CourseDownloadDataModel? courseDownloadDataModel = courseDownloadProvider.getCourseDownloadDataModelFromId(
        courseDownloadId: CourseDownloadDataModel.getDownloadId(
          contentId: model.ContentID,
          eventTrackContentId: widget.parentCourseModel.ContentID,
        ),
      );
      if (courseDownloadDataModel != null) {
        MyCourseDownloadUIActionsController courseDownloadUIActionsController = MyCourseDownloadUIActionsController(appProvider: appProvider);

        List<InstancyUIActionModel> courseDownloadOptions = courseDownloadUIActionsController
            .getMyCourseDownloadsScreenSecondaryActions(
              courseDownloadDataModel: courseDownloadDataModel,
              localStr: localStr,
              myCourseDownloadUIActionCallbackModel: getMyCourseDownloadUIActionCallbackModel(
                model: courseDownloadDataModel,
                isSecondaryAction: true,
              ),
            )
            .toSet()
            .toList();
        // MyPrint.printOnConsole("courseDownloadOptions length:${courseDownloadOptions.length}");

        options.addAll(courseDownloadOptions);
      }
    }

    EventTrackUIActionsController uiActionsController = EventTrackUIActionsController(
      appProvider: appProvider,
      myLearningProvider: MyLearningProvider(),
      profileProvider: profileProvider,
    );

    options.addAll(uiActionsController
        .getEventRelatedContentsSecondaryActions(
          contentModel: model,
          localStr: localStr,
          myLearningUIActionCallbackModel: getUIActionCallbackModel(
            model: model,
            // primaryAction: primaryAction,
            isSecondaryAction: true,
          ),
        )
        .toList());
    MyPrint.printOnConsole("secondary options:$options");

    if (options.isEmpty) {
      return;
    }

    InstancyUIActions().showAction(
      context: context,
      actions: options,
    );
  }

  Future<void> onDownloadButtonTapped({required RelatedTrackDataDTOModel model}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("onDownloadTap called", tag: tag);

    String downloadId = CourseDownloadDataModel.getDownloadId(
      contentId: model.ContentID,
      eventTrackContentId: widget.parentCourseModel.ContentID,
    );

    CourseDownloadDataModel? courseDownloadDataModel = courseDownloadProvider.getCourseDownloadDataModelFromId(courseDownloadId: downloadId);

    if (courseDownloadDataModel == null) {
      MyPrint.printOnConsole("Course Not Downloaded", tag: tag);

      ApiUrlConfigurationProvider apiUrlConfigurationProvider = ApiController().apiDataProvider;

      courseDownloadController.downloadCourse(
        courseDownloadRequestModel: CourseDownloadRequestModel(
          ContentID: model.ContentID,
          FolderPath: model.FolderPath,
          JWStartPage: model.jwstartpage,
          JWVideoKey: model.JWVideoKey,
          StartPage: model.startpage,
          ContentTypeId: model.ContentTypeId,
          MediaTypeID: model.MediaTypeID,
          SiteId: apiUrlConfigurationProvider.getCurrentSiteId(),
          UserID: apiUrlConfigurationProvider.getCurrentUserId(),
          ScoId: model.ScoID,
        ),
        relatedTrackDataDTOModel: model,
        parentEventTrackModel: widget.parentCourseModel,
      );
    } else if (courseDownloadDataModel.isFileDownloading) {
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

    courseDownloadProvider = widget.courseDownloadProvider ?? CourseDownloadProvider();
    courseDownloadController = CourseDownloadController(
      appProvider: appProvider,
      courseDownloadProvider: courseDownloadProvider,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.paginationModel.isFirstTimeLoading) {
      return const Center(
        child: CommonLoader(),
      );
    } else if (!widget.paginationModel.isLoading && widget.contentsLength == 0) {
      return RefreshIndicator(
        onRefresh: () async {
          widget.onPulledTORefresh?.call();
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            Center(
              child: AppConfigurations.commonNoDataView(),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        if (widget.onPulledTORefresh != null) {
          widget.onPulledTORefresh!();
        }
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: widget.relatedContentsList.length + 1,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          if ((index == 0 && widget.relatedContentsList.isEmpty) || index == widget.relatedContentsList.length) {
            if (widget.paginationModel.isLoading) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: const Center(
                  child: CommonLoader(
                    size: 70,
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          }

          if (index > (widget.contentsLength - widget.paginationModel.refreshLimit) && widget.paginationModel.hasMore && !widget.paginationModel.isLoading) {
            if (widget.onPagination != null) widget.onPagination!();
          }

          RelatedTrackDataDTOModel model = widget.relatedContentsList[index];

          return getContentsCard(model: model);
        },
      ),
    );
  }

  Widget getContentsCard({required RelatedTrackDataDTOModel model}) {
    AppProvider appProvider = context.read<AppProvider>();
    ProfileProvider profileProvider = context.read<ProfileProvider>();

    LocalStr localStr = appProvider.localStr;

    EventTrackUIActionsController uiActionsController = EventTrackUIActionsController(
      appProvider: appProvider,
      myLearningProvider: MyLearningProvider(),
      profileProvider: profileProvider,
    );

    List<InstancyUIActionModel> options = uiActionsController
        .getEventRelatedContentsPrimaryActions(
          contentModel: model,
          myLearningUIActionCallbackModel: getUIActionCallbackModel(
            model: model,
            isSecondaryAction: false,
            primaryAction: null,
          ),
          localStr: localStr,
        )
        .toList();

    InstancyUIActionModel? primaryAction = options.firstElement;
    InstancyContentActionsEnum? primaryActionEnum = primaryAction?.actionsEnum;

    return EventRelatedContentCard(
      contentModel: model,
      parentEventTrackId: widget.parentCourseModel.ContentID,
      primaryAction: primaryAction,
      onMoreButtonTap: () {
        showMoreAction(model: model);
      },
      onPrimaryActionTap: () {
        MyPrint.printOnConsole("primaryActionsEnum:$primaryActionEnum");

        if (primaryAction?.onTap != null) primaryAction!.onTap!();
      },
      onDownloadTap: () {
        onDownloadButtonTapped(model: model);
      },
    );
  }
}
