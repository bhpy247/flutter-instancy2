import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_provider.dart';
import 'package:flutter_instancy_2/backend/ui_actions/my_learning/my_learning_ui_action_configs.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/models/course_download/data_model/course_download_data_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/related_track_data_dto_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/views/common/components/common_cached_network_image.dart';
import 'package:flutter_instancy_2/views/common/components/common_icon_button.dart';
import 'package:flutter_instancy_2/views/course_download/components/course_download_button.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:provider/provider.dart';

import '../../../backend/ui_actions/primary_secondary_actions/primary_secondary_actions.dart';
import '../../../models/course/data_model/CourseDTOModel.dart';
import '../../common/components/common_button.dart';
import '../../common/components/instancy_ui_actions/instancy_ui_actions.dart';

class EventRelatedContentCard extends StatefulWidget {
  final RelatedTrackDataDTOModel contentModel;
  final String parentEventTrackId;
  final InstancyUIActionModel? primaryAction;
  final void Function()? onMoreButtonTap, onPrimaryActionTap, onDownloadTap;
  final bool isShowMoreOption;

  const EventRelatedContentCard({
    Key? key,
    required this.contentModel,
    required this.parentEventTrackId,
    this.primaryAction,
    this.onMoreButtonTap,
    this.onPrimaryActionTap,
    this.onDownloadTap,
    this.isShowMoreOption = true,
  }) : super(key: key);

  @override
  State<EventRelatedContentCard> createState() => _EventRelatedContentCardState();
}

class _EventRelatedContentCardState extends State<EventRelatedContentCard> {
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
            imageWidget(widget.contentModel.ThumbnailImagePath),
            const SizedBox(width: 10),
            Expanded(child: detailColumn(widget.contentModel)),
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

  Widget detailColumn(RelatedTrackDataDTOModel model) {
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
                  const SizedBox(width: 10),
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
          model.Name,
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
                    model.AuthorName,
                    style: themeData.textTheme.bodySmall?.copyWith(
                      fontSize: 12,
                      color: const Color(0xff9AA0A6),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            if (MyLearningUIActionConfigs.isContentTypeDownloadable(objectTypeId: model.ContentTypeId, mediaTypeId: model.MediaTypeID) && widget.onDownloadTap != null)
              CourseDownloadButton(
                contentId: model.ContentID,
                parentEventTrackId: widget.parentEventTrackId,
                onDownloadTap: widget.onDownloadTap,
              ),
          ],
        ),
        const SizedBox(height: 8),
        Consumer<CourseDownloadProvider>(
          builder: (BuildContext context, CourseDownloadProvider courseDownloadProvider, Widget? child) {
            MyPrint.printOnConsole("EventRelatedContentCard  Consumer Called");

            double percentageCompleted = model.PercentCompleted;
            String actualStatus = model.CoreLessonStatus;
            String contentStatus = model.ContentDisplayStatus;

            String courseDownloadId = CourseDownloadDataModel.getDownloadId(
              contentId: model.ContentID,
              eventTrackContentId: widget.parentEventTrackId,
            );
            // MyPrint.printOnConsole("courseDownloadId:$courseDownloadId");
            CourseDownloadDataModel? downloadModel = courseDownloadProvider.getCourseDownloadDataModelFromId(
              courseDownloadId: courseDownloadId,
              isNewInstance: false,
            );

            if (downloadModel?.isCourseDownloaded == true && downloadModel?.relatedTrackDataDTOModel != null) {
              RelatedTrackDataDTOModel newModel = downloadModel!.relatedTrackDataDTOModel!;

              return linearProgressBar(
                percentCompleted: newModel.PercentCompleted,
                actualStatus: newModel.CoreLessonStatus,
                contentStatus: newModel.ContentDisplayStatus,
              );
            }

            return linearProgressBar(
              percentCompleted: percentageCompleted,
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

  Widget linearProgressBar({
    required double percentCompleted,
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
            currentStep: percentCompleted.toInt(),
            progressColor: AppConfigurations.getContentStatusColorFromActualStatus(status: actualStatus),
            backgroundColor: const Color(0xffDCDCDC),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "${percentCompleted.getFormattedNumber(precision: 2)}% $contentStatus",
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
