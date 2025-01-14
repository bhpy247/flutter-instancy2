import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/api/api_url_configuration_provider.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_controller.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_provider.dart';
import 'package:flutter_instancy_2/backend/event_track/event_track_provider.dart';
import 'package:flutter_instancy_2/backend/network_connection/network_connection_provider.dart';
import 'package:flutter_instancy_2/backend/ui_actions/my_learning/my_learning_ui_action_configs.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/models/course_download/data_model/course_download_data_model.dart';
import 'package:flutter_instancy_2/models/course_download/request_model/course_download_request_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/related_track_data_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/track_course_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/track_dto_model.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:provider/provider.dart';

typedef DownloadContentIdsResponse = ({
  List<String> downloadbleContentIds,
  Map<String, TrackCourseDTOModel> downloadableTrackContents,
  Map<String, RelatedTrackDataDTOModel> downloadableEventRelatedContents
});

class EventTrackCoursesDownloadButtonWidget extends StatelessWidget {
  final CourseDTOModel? parentEventTrackModel;
  final EventTrackProvider eventTrackProvider;

  const EventTrackCoursesDownloadButtonWidget({
    super.key,
    required this.parentEventTrackModel,
    required this.eventTrackProvider,
  });

  DownloadContentIdsResponse getDownloadableContentIds() {
    List<String> downloadableContentIds = <String>[];
    Map<String, TrackCourseDTOModel> downloadableTrackContents = <String, TrackCourseDTOModel>{};
    Map<String, RelatedTrackDataDTOModel> downloadableEventRelatedContents = <String, RelatedTrackDataDTOModel>{};

    eventTrackProvider.trackContentsData.getList(isNewInstance: false).forEach((TrackDTOModel trackDTOModel) {
      for (TrackCourseDTOModel model in trackDTOModel.TrackList) {
        if (MyLearningUIActionConfigs.isContentTypeDownloadable(objectTypeId: model.ContentTypeId, mediaTypeId: model.MediaTypeID)) {
          downloadableContentIds.add(model.ContentID);
          downloadableTrackContents[model.ContentID] = model;
        }
      }
    });
    eventTrackProvider.trackAssignmentsData.getList(isNewInstance: false).forEach((TrackDTOModel trackDTOModel) {
      for (TrackCourseDTOModel model in trackDTOModel.TrackList) {
        if (MyLearningUIActionConfigs.isContentTypeDownloadable(objectTypeId: model.ContentTypeId, mediaTypeId: model.MediaTypeID)) {
          downloadableContentIds.add(model.ContentID);
          downloadableTrackContents[model.ContentID] = model;
        }
      }
    });
    eventTrackProvider.eventRelatedContentsData.getList(isNewInstance: false).forEach((RelatedTrackDataDTOModel relatedTrackDataDTOModel) {
      if (MyLearningUIActionConfigs.isContentTypeDownloadable(objectTypeId: relatedTrackDataDTOModel.ContentTypeId, mediaTypeId: relatedTrackDataDTOModel.MediaTypeID)) {
        downloadableContentIds.add(relatedTrackDataDTOModel.ContentID);
        downloadableEventRelatedContents[relatedTrackDataDTOModel.ContentID] = relatedTrackDataDTOModel;
      }
    });
    eventTrackProvider.eventRelatedAssignmentsData.getList(isNewInstance: false).forEach((RelatedTrackDataDTOModel relatedTrackDataDTOModel) {
      if (MyLearningUIActionConfigs.isContentTypeDownloadable(objectTypeId: relatedTrackDataDTOModel.ContentTypeId, mediaTypeId: relatedTrackDataDTOModel.MediaTypeID)) {
        downloadableContentIds.add(relatedTrackDataDTOModel.ContentID);
        downloadableEventRelatedContents[relatedTrackDataDTOModel.ContentID] = relatedTrackDataDTOModel;
      }
    });

    DownloadContentIdsResponse response =
        (downloadbleContentIds: downloadableContentIds, downloadableTrackContents: downloadableTrackContents, downloadableEventRelatedContents: downloadableEventRelatedContents);

    return response;
  }

  Future<void> downloadEventTrackContents({
    required DownloadContentIdsResponse downloadableContentResponse,
    required CourseDownloadProvider courseDownloadProvider,
    required AppProvider appProvider,
  }) async {
    for (String contentId in downloadableContentResponse.downloadbleContentIds) {
      String downloadId = CourseDownloadDataModel.getDownloadId(contentId: contentId, eventTrackContentId: parentEventTrackModel?.ContentID ?? "");
      CourseDownloadDataModel? courseDownloadDataModel = courseDownloadProvider.getCourseDownloadDataModelFromId(courseDownloadId: downloadId);

      if (courseDownloadDataModel != null) {
        continue;
      }

      TrackCourseDTOModel? trackCourseDtoModel = downloadableContentResponse.downloadableTrackContents[contentId];
      RelatedTrackDataDTOModel? relatedTrackDataDTOModel = downloadableContentResponse.downloadableEventRelatedContents[contentId];

      CourseDownloadController courseDownloadController = CourseDownloadController(
        appProvider: appProvider,
        courseDownloadProvider: courseDownloadProvider,
      );

      ApiUrlConfigurationProvider apiUrlConfigurationProvider = ApiController().apiDataProvider;

      if (trackCourseDtoModel != null) {
        courseDownloadController.downloadCourse(
          courseDownloadRequestModel: CourseDownloadRequestModel(
            ContentID: trackCourseDtoModel.ContentID,
            FolderPath: trackCourseDtoModel.FolderPath,
            JWStartPage: trackCourseDtoModel.jwstartpage,
            JWVideoKey: trackCourseDtoModel.JWVideoKey,
            StartPage: trackCourseDtoModel.startpage,
            ContentTypeId: trackCourseDtoModel.ContentTypeId,
            MediaTypeID: trackCourseDtoModel.MediaTypeID,
            SiteId: apiUrlConfigurationProvider.getCurrentSiteId(),
            UserID: apiUrlConfigurationProvider.getCurrentUserId(),
            ScoId: trackCourseDtoModel.ScoID,
          ),
          trackCourseDTOModel: trackCourseDtoModel,
          parentEventTrackModel: parentEventTrackModel,
        );
      } else if (relatedTrackDataDTOModel != null) {
        courseDownloadController.downloadCourse(
          courseDownloadRequestModel: CourseDownloadRequestModel(
            ContentID: relatedTrackDataDTOModel.ContentID,
            FolderPath: relatedTrackDataDTOModel.FolderPath,
            JWStartPage: relatedTrackDataDTOModel.jwstartpage,
            JWVideoKey: relatedTrackDataDTOModel.JWVideoKey,
            StartPage: relatedTrackDataDTOModel.startpage,
            ContentTypeId: relatedTrackDataDTOModel.ContentTypeId,
            MediaTypeID: relatedTrackDataDTOModel.MediaTypeID,
            SiteId: apiUrlConfigurationProvider.getCurrentSiteId(),
            UserID: apiUrlConfigurationProvider.getCurrentUserId(),
            ScoId: relatedTrackDataDTOModel.ScoID,
          ),
          relatedTrackDataDTOModel: relatedTrackDataDTOModel,
          parentEventTrackModel: parentEventTrackModel,
        );
      }
    }
  }

  Future<void> pauseDownloadEventTrackContents({
    required DownloadContentIdsResponse downloadableContentResponse,
    required CourseDownloadProvider courseDownloadProvider,
    required AppProvider appProvider,
  }) async {
    CourseDownloadController courseDownloadController = CourseDownloadController(appProvider: appProvider, courseDownloadProvider: courseDownloadProvider);

    for (String contentId in downloadableContentResponse.downloadbleContentIds) {
      String downloadId = CourseDownloadDataModel.getDownloadId(contentId: contentId, eventTrackContentId: parentEventTrackModel?.ContentID ?? "");
      CourseDownloadDataModel? courseDownloadDataModel = courseDownloadProvider.getCourseDownloadDataModelFromId(courseDownloadId: downloadId);

      if (courseDownloadDataModel == null ||
          courseDownloadDataModel.isCourseDownloaded ||
          !courseDownloadDataModel.isCourseDownloading ||
          courseDownloadDataModel.isFileDownloaded ||
          !courseDownloadDataModel.isFileDownloading ||
          courseDownloadDataModel.isFileDownloadCanceled ||
          courseDownloadDataModel.isFileExtracting ||
          courseDownloadDataModel.isFileExtracted ||
          courseDownloadDataModel.isFileDownloadingPaused) {
        continue;
      }

      courseDownloadController.pauseDownload(downloadId: downloadId);
    }
  }

  Future<void> resumeDownloadEventTrackContents({
    required DownloadContentIdsResponse downloadableContentResponse,
    required CourseDownloadProvider courseDownloadProvider,
    required AppProvider appProvider,
  }) async {
    CourseDownloadController courseDownloadController = CourseDownloadController(appProvider: appProvider, courseDownloadProvider: courseDownloadProvider);

    for (String contentId in downloadableContentResponse.downloadbleContentIds) {
      String downloadId = CourseDownloadDataModel.getDownloadId(contentId: contentId, eventTrackContentId: parentEventTrackModel?.ContentID ?? "");
      CourseDownloadDataModel? courseDownloadDataModel = courseDownloadProvider.getCourseDownloadDataModelFromId(courseDownloadId: downloadId);

      if (courseDownloadDataModel == null ||
          courseDownloadDataModel.isCourseDownloaded ||
          !courseDownloadDataModel.isCourseDownloading ||
          courseDownloadDataModel.isFileDownloaded ||
          courseDownloadDataModel.isFileDownloading ||
          courseDownloadDataModel.isFileDownloadCanceled ||
          courseDownloadDataModel.isFileExtracting ||
          courseDownloadDataModel.isFileExtracted ||
          !courseDownloadDataModel.isFileDownloadingPaused) {
        continue;
      }

      courseDownloadController.resumeDownload(downloadId: downloadId);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Consumer2<NetworkConnectionProvider, CourseDownloadProvider>(
      builder: (BuildContext context, NetworkConnectionProvider networkConnectionProvider, CourseDownloadProvider courseDownloadProvider, Widget? child) {
        if (!CourseDownloadController.isDownloadModuleEnabled || kIsWeb) {
          return const SizedBox();
        }

        if ((eventTrackProvider.trackContentsData.length == 0 &&
                eventTrackProvider.trackAssignmentsData.length == 0 &&
                eventTrackProvider.eventRelatedContentsData.length == 0 &&
                eventTrackProvider.eventRelatedAssignmentsData.length == 0) ||
            kIsWeb ||
            !networkConnectionProvider.isNetworkConnected.get()) {
          return const SizedBox();
        }

        DownloadContentIdsResponse downloadableContentResponse = getDownloadableContentIds();

        if (downloadableContentResponse.downloadbleContentIds.isEmpty) {
          return const SizedBox();
        }

        //region Defining of icon from list download status
        IconData icon = Icons.file_download_outlined;
        Color? progressColor = Colors.grey;
        bool isDownloading = false, isDownloadPaused = false, isAllDownloaded = false, isExtracting = false;
        int downloadedCount = 0;
        double? iconSize;

        // MyPrint.printOnConsole("Downloads:${myLearningDownloadProvider.downloads.map((e) => "Name:${e.table2.name}, Track:${e.trackContentName}\n").join(",")}");
        for (String contentId in downloadableContentResponse.downloadbleContentIds) {
          String downloadId = CourseDownloadDataModel.getDownloadId(contentId: contentId, eventTrackContentId: parentEventTrackModel?.ContentID ?? "");
          CourseDownloadDataModel? courseDownloadDataModel = courseDownloadProvider.getCourseDownloadDataModelFromId(courseDownloadId: downloadId, isNewInstance: false);

          if (courseDownloadDataModel == null) {
          } else {
            if (courseDownloadDataModel.isCourseDownloaded) {
              downloadedCount++;
            } else {
              if (courseDownloadDataModel.isFileDownloading) {
                isDownloading = true;
              }
              if (courseDownloadDataModel.isFileDownloadingPaused) {
                isDownloadPaused = true;
              }
              if (courseDownloadDataModel.isFileExtracting) {
                isExtracting = true;
              }
            }
          }
        }

        // isAllDownloaded = true;
        isAllDownloaded = downloadableContentResponse.downloadbleContentIds.length == downloadedCount;

        // MyPrint.printOnConsole("downloadbleContentIds.length:${downloadableContentResponse.downloadbleContentIds.length}");
        // MyPrint.printOnConsole("downloadedCount:$downloadedCount");
        // MyPrint.printOnConsole("isDownloading:$isDownloading, isDownloadPasued:$isDownloadPasued, isAllDownloaded:$isAllDownloaded, isAllDownloaded:$isAllDownloaded");

        if (isAllDownloaded) {
          icon = Icons.check;
          progressColor = Colors.green;
        } else if (isDownloadPaused) {
          icon = Icons.play_arrow;
          progressColor = Colors.orangeAccent;
        } else if (isDownloading) {
          icon = Icons.pause;
          progressColor = Colors.orangeAccent;
        } else if (isExtracting) {
          icon = InstancyIcons.extractDownload;
          progressColor = Colors.orangeAccent;
          iconSize = 23;
        }
        //endregion

        MyPrint.printOnConsole("isExtracting in EventTrackCoursesDownloadButtonWidget:$isExtracting");

        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: themeData.colorScheme.onPrimary,
            border: Border.all(color: progressColor, width: 2),
          ),
          child: InkWell(
            onTap: () {
              if (isAllDownloaded) {
              } else if (isDownloadPaused) {
                resumeDownloadEventTrackContents(
                  downloadableContentResponse: downloadableContentResponse,
                  courseDownloadProvider: courseDownloadProvider,
                  appProvider: context.read<AppProvider>(),
                );
              } else if (isDownloading) {
                pauseDownloadEventTrackContents(
                  downloadableContentResponse: downloadableContentResponse,
                  courseDownloadProvider: courseDownloadProvider,
                  appProvider: context.read<AppProvider>(),
                );
              } else if (isExtracting) {
              } else {
                downloadEventTrackContents(
                  downloadableContentResponse: downloadableContentResponse,
                  courseDownloadProvider: courseDownloadProvider,
                  appProvider: context.read<AppProvider>(),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(7),
              child: Icon(
                icon,
                size: iconSize,
              ),
            ),
          ),
        );
      },
    );
  }
}
