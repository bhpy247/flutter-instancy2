import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_controller.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_provider.dart';
import 'package:flutter_instancy_2/models/course_download/data_model/course_download_data_model.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class CourseDownloadButton extends StatelessWidget {
  final String contentId;
  final String parentEventTrackId;
  final void Function()? onDownloadTap;

  const CourseDownloadButton({
    super.key,
    required this.contentId,
    this.parentEventTrackId = "",
    this.onDownloadTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    if (!CourseDownloadController.isDownloadModuleEnabled) {
      return const SizedBox();
    }

    return Consumer<CourseDownloadProvider>(
      builder: (BuildContext context, CourseDownloadProvider courseDownloadProvider, Widget? child) {
        CourseDownloadDataModel? courseDownloadDataModel = courseDownloadProvider.getCourseDownloadDataModelFromId(
          courseDownloadId: CourseDownloadDataModel.getDownloadId(
            contentId: contentId,
            eventTrackContentId: parentEventTrackId,
          ),
        );

        IconData iconData = Icons.file_download_outlined;
        Color? iconColor;
        GestureTapCallback? onTap = onDownloadTap;
        double downloadProgress = 0;
        bool isShowProgressIndicator = false;
        Color? progressColor = Colors.grey;

        if (courseDownloadDataModel != null) {
          downloadProgress = courseDownloadDataModel.totalDownloadPercentage / 100;
          isShowProgressIndicator = true;

          if (courseDownloadDataModel.isCourseDownloaded) {
            progressColor = Colors.green;
            iconData = Icons.download_done;
          } else if (courseDownloadDataModel.isFileDownloading || courseDownloadDataModel.isFileExtracting) {
            progressColor = Colors.orangeAccent;
          } else if (courseDownloadDataModel.isFileDownloadingPaused) {
            iconData = Icons.pause;
          }
        }

        Widget child = InkWell(
          onTap: () {
            if (onTap != null) onTap();
          },
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: themeData.colorScheme.onPrimary,
              boxShadow: [
                BoxShadow(
                  color: themeData.colorScheme.onBackground.withOpacity(0.1),
                  blurRadius: 3,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                iconData,
                color: iconColor,
              ),
            ),
          ),
        );

        if (isShowProgressIndicator) {
          child = CircularPercentIndicator(
            radius: 22,
            lineWidth: 2,
            percent: downloadProgress,
            center: child,
            backgroundColor: Colors.grey.shade100,
            progressColor: progressColor,
          );
        }

        return child;
      },
    );
  }
}
