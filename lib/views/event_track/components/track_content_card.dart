import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_provider.dart';
import 'package:flutter_instancy_2/backend/ui_actions/my_learning/my_learning_ui_action_configs.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/classroom_events/data_model/EventRecordingDetailsModel.dart';
import 'package:flutter_instancy_2/models/course_download/data_model/course_download_data_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/track_course_dto_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/views/common/components/common_cached_network_image.dart';
import 'package:flutter_instancy_2/views/common/components/common_icon_button.dart';
import 'package:flutter_instancy_2/views/course_download/components/course_download_button.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:provider/provider.dart';

import '../../../backend/ui_actions/primary_secondary_actions/primary_secondary_actions.dart';
import '../../../models/course/data_model/CourseDTOModel.dart';
import '../../common/components/common_button.dart';
import '../../common/components/instancy_ui_actions/instancy_ui_actions.dart';

class TrackContentCard extends StatefulWidget {
  final TrackCourseDTOModel eventTrackContentModel;
  final String parentEventTrackContentId;
  final InstancyUIActionModel? primaryAction;
  final void Function()? onMoreButtonTap, onPrimaryActionTap, onDownloadTap;
  final bool isShowMoreOption;

  const TrackContentCard({
    Key? key,
    required this.eventTrackContentModel,
    required this.parentEventTrackContentId,
    this.primaryAction,
    this.onMoreButtonTap,
    this.onPrimaryActionTap,
    this.onDownloadTap,
    this.isShowMoreOption = true,
  }) : super(key: key);

  @override
  State<TrackContentCard> createState() => _TrackContentCardState();
}

class _TrackContentCardState extends State<TrackContentCard> {
  late ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return InkWell(
      onTap: () {
        if (widget.onPrimaryActionTap != null) {
          widget.onPrimaryActionTap!();
        }
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageWidget(widget.eventTrackContentModel.ThumbnailImagePath),
            const SizedBox(width: 10),
            Expanded(child: detailColumn(widget.eventTrackContentModel)),
          ],
        ),
      ),
    );
  }

  Widget imageWidget(String url) {
    String imageUrl = MyUtils.getSecureUrl(AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(imagePath: url));
    // MyPrint.printOnConsole("Event Track Content Thumbnail Image Url:$imageUrl");

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 80,
        width: 80,
        child: CommonCachedNetworkImage(
          imageUrl: imageUrl,
          height: 80,
          width: 80,
          shimmerIconSize: 60,
          errorIconSize: 60,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget detailColumn(TrackCourseDTOModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  coursesIcon(
                    assetName: AppConfigurations.getContentIconFromObjectAndMediaType(
                      mediaTypeId: model.MediaTypeID,
                      objectTypeId: model.ContentTypeId,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    model.ContentType,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Color(0xff757575),
                    ),
                  )
                ],
              ),
            ),
            getMoreOptionsButton()
          ],
        ),
        const SizedBox(height: 5),
        Text(
          model.ContentName,
          style: themeData.textTheme.titleSmall?.copyWith(
            color: const Color(0xff1D293F),
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.AuthorDisplayName,
                    style: themeData.textTheme.bodySmall?.copyWith(
                      fontSize: 12,
                      color: const Color(0xff9AA0A6),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ratingView(ParsingHelper.parseDoubleMethod(model.RatingID)),
                ],
              ),
            ),
            if (MyLearningUIActionConfigs.isContentTypeDownloadable(objectTypeId: model.ContentTypeId, mediaTypeId: model.MediaTypeID))
              CourseDownloadButton(
                contentId: model.ContentID,
                parentEventTrackId: widget.parentEventTrackContentId,
                onDownloadTap: widget.onDownloadTap,
              ),
          ],
        ),
        const SizedBox(height: 8),
        Consumer<CourseDownloadProvider>(
          builder: (BuildContext context, CourseDownloadProvider courseDownloadProvider, Widget? child) {
            double percentageCompleted = ParsingHelper.parseDoubleMethod(model.ContentProgress);
            String contentStatus = model.ContentStatus;
            String actualStatus = model.CoreLessonStatus;

            if (model.ContentTypeId == InstancyObjectTypes.events && (model.RecordingDetails?.ContentID).checkNotEmpty) {
              EventRecordingDetailsModel recordingDetailsModel = model.RecordingDetails!;
              percentageCompleted = ParsingHelper.parseDoubleMethod(recordingDetailsModel.ContentProgress);
              actualStatus = recordingDetailsModel.EventRecordStatus;
            }

            String courseDownloadId = CourseDownloadDataModel.getDownloadId(
              contentId: model.ContentID,
              eventTrackContentId: widget.parentEventTrackContentId,
            );
            CourseDownloadDataModel? downloadModel = courseDownloadProvider.getCourseDownloadDataModelFromId(
              courseDownloadId: courseDownloadId,
            );

            if (downloadModel?.isCourseDownloaded == true && downloadModel?.trackCourseDTOModel != null) {
              TrackCourseDTOModel newModel = downloadModel!.trackCourseDTOModel!;

              return linearProgressBar(
                percentCompleted: ParsingHelper.parseIntMethod(newModel.ContentProgress),
                contentStatus: newModel.ContentStatus,
                actualStatus: newModel.CoreLessonStatus,
              );
            }

            return linearProgressBar(
              percentCompleted: percentageCompleted.toInt(),
              contentStatus: contentStatus,
              actualStatus: actualStatus,
            );
          },
        ),
        /*getPrimaryActionButton(
          model: model,
          context: context,
          primaryAction: widget.primaryAction,
        ),*/
      ],
    );
  }

  Widget coursesIcon({String assetName = ""}) {
    return Image.asset(
      assetName,
      height: 13,
      width: 13,
      fit: BoxFit.cover,
    );
  }

  Widget ratingView(double ratings) {
    return RatingBarIndicator(
      rating: ratings,
      itemBuilder: (context, index) => const Icon(
        Icons.star,
        color: Colors.black,
      ),
      itemCount: 5,
      unratedColor: const Color(0xffCBCBD4),
      itemSize: 15.0,
      direction: Axis.horizontal,
    );
  }

  Widget linearProgressBar({
    required int percentCompleted,
    required String contentStatus,
    required String actualStatus,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressBar(
            maxSteps: 100,
            progressType: LinearProgressBar.progressTypeLinear,
            // Use Dots progress
            currentStep: percentCompleted,
            progressColor: AppConfigurations.getContentStatusColorFromActualStatus(status: actualStatus),
            backgroundColor: const Color(0xffDCDCDC),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "$percentCompleted% $contentStatus",
          style: themeData.textTheme.titleSmall?.copyWith(
            fontSize: 12,
          ),
        )
      ],
    );
  }

  Widget getMoreOptionsButton() {
    if (!widget.isShowMoreOption) return const SizedBox();

    return CommonIconButton(
      onTap: () {
        if (widget.onMoreButtonTap != null) {
          widget.onMoreButtonTap!();
        }
      },
      iconData: Icons.more_vert,
      iconSize: 22,
    );
  }

  Widget getPrimaryActionButton({
    required CourseDTOModel model,
    required BuildContext context,
    required InstancyUIActionModel? primaryAction,
  }) {
    ThemeData themeData = Theme.of(context);

    if (primaryAction == null) {
      return const SizedBox();
    }

    return Container(
      margin: primaryAction.actionsEnum == InstancyContentActionsEnum.Buy ? const EdgeInsets.symmetric(vertical: 5) : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 25,
            child: CommonButton(
              height: 25,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              onPressed: () {
                if (widget.onPrimaryActionTap != null) {
                  widget.onPrimaryActionTap!();
                }
              },
              backGroundColor: themeData.primaryColor,
              text: primaryAction.text,
              fontSize: 12,
            ),
          ),
          primaryAction.actionsEnum == InstancyContentActionsEnum.Buy
              ? Text(
                  "${model.Currency}${model.SalePrice}",
                  style: themeData.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
