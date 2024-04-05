import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_controller.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_provider.dart';
import 'package:flutter_instancy_2/backend/network_connection/network_connection_provider.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
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

    if (!CourseDownloadController.isDownloadModuleEnabled || kIsWeb) {
      return const SizedBox();
    }

    return Consumer2<CourseDownloadProvider, NetworkConnectionProvider>(
      builder: (BuildContext context, CourseDownloadProvider courseDownloadProvider, NetworkConnectionProvider networkConnectionProvider, Widget? child) {
        // MyPrint.printOnConsole("CourseDownloadProvider builder called");

        bool isNetworkConnected = networkConnectionProvider.isNetworkConnected.get();

        CourseDownloadDataModel? courseDownloadDataModel = courseDownloadProvider.getCourseDownloadDataModelFromId(
          courseDownloadId: CourseDownloadDataModel.getDownloadId(
            contentId: contentId,
            eventTrackContentId: parentEventTrackId,
          ),
          isNewInstance: false,
        );

        if (courseDownloadDataModel == null) {
          if (!isNetworkConnected) {
            return const SizedBox();
          }

          return getMainBody(
            themeData: themeData,
            courseDownloadDataModel: null,
          );
        }

        return MultiProvider(
          providers: [
            ChangeNotifierProvider<CourseDownloadDataModel>.value(value: courseDownloadDataModel),
          ],
          child: Consumer<CourseDownloadDataModel>(
            builder: (BuildContext context, CourseDownloadDataModel courseDownloadDataModel, Widget? child) {
              // MyPrint.printOnConsole("CourseDownloadDataModel builder called");

              return getMainBody(
                themeData: themeData,
                courseDownloadDataModel: courseDownloadDataModel,
              );
            },
          ),
        );
      },
    );
  }

  Widget getMainBody({required ThemeData themeData, required CourseDownloadDataModel? courseDownloadDataModel}) {
    IconData iconData = Icons.file_download_outlined;
    Color? iconColor;
    GestureTapCallback? onTap = onDownloadTap;
    double downloadProgress = 0;
    double? iconSize;
    bool isShowProgressIndicator = false;
    Color? progressColor = Colors.grey;

    if (courseDownloadDataModel != null) {
      downloadProgress = courseDownloadDataModel.totalDownloadPercentage / 100;
      isShowProgressIndicator = true;

      if (courseDownloadDataModel.isCourseDownloaded) {
        progressColor = Colors.green;
        iconData = Icons.download_done;
      } else if (courseDownloadDataModel.isFileDownloading) {
        progressColor = Colors.orangeAccent;
        iconData = Icons.pause;
      } else if (courseDownloadDataModel.isFileDownloadingPaused) {
        iconData = InstancyIcons.resumeDownload;
        iconSize = 16;
      } else if (courseDownloadDataModel.isFileExtracting) {
        iconData = InstancyIcons.extractDownload;
        progressColor = Colors.orangeAccent;
        // downloadProgress = courseDownloadDataModel.zipFileExtractionPercentage / 100;
        onTap = null;
        iconSize = 17;
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
            size: iconSize,
          ),
        ),
      ),
    );

    if (isShowProgressIndicator) {
      if (downloadProgress < 0) {
        downloadProgress = 0;
      } else if (downloadProgress > 1) {
        downloadProgress = 1;
      }

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
  }
}
