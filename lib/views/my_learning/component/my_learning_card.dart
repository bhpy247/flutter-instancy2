import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_provider.dart';
import 'package:flutter_instancy_2/backend/ui_actions/my_learning/my_learning_ui_action_configs.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/course_download/data_model/course_download_data_model.dart';
import 'package:flutter_instancy_2/utils/date_representation.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/views/common/components/common_cached_network_image.dart';
import 'package:flutter_instancy_2/views/common/components/common_icon_button.dart';
import 'package:flutter_instancy_2/views/course_download/components/course_download_button.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:html/parser.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:provider/provider.dart';

import '../../../backend/app/app_provider.dart';
import '../../../backend/configurations/app_configuration_operations.dart';
import '../../../backend/ui_actions/primary_secondary_actions/primary_secondary_actions.dart';
import '../../../models/course/data_model/CourseDTOModel.dart';
import '../../common/components/common_button.dart';
import '../../common/components/instancy_ui_actions/instancy_ui_actions.dart';

class MyLearningCard extends StatefulWidget {
  final CourseDTOModel courseDTOModel;
  final InstancyUIActionModel? primaryAction;
  final void Function()? onMoreButtonTap, onPrimaryActionTap, onThumbnailClick, onDownloadTap;
  final bool isShowMoreOption;

  const MyLearningCard({
    Key? key,
    required this.courseDTOModel,
    this.primaryAction,
    this.onThumbnailClick,
    this.onDownloadTap,
    this.onMoreButtonTap,
    this.onPrimaryActionTap,
    this.isShowMoreOption = true,
  }) : super(key: key);

  @override
  State<MyLearningCard> createState() => _MyLearningCardState();
}

class _MyLearningCardState extends State<MyLearningCard> {
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
            InkWell(
              onTap: () {
                if (widget.onThumbnailClick != null) {
                  widget.onThumbnailClick!();
                }
              },
              child: imageWidget(widget.courseDTOModel.ThumbnailImagePath),
            ),
            const SizedBox(width: 10),
            Expanded(child: detailColumn(widget.courseDTOModel))
          ],
        ),
      ),
    );
  }

  Widget imageWidget(String url) {
    // MyPrint.printOnConsole("mylearning content image url:$url");

    url = MyUtils.getSecureUrl(AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(imagePath: url));
    // if(url.startsWith("https://")) url = url.replaceFirst("https://", "http://");
    // url = "https://enterprisedemo-admin.instancy.com/Content/SiteFiles/Images/elearning%20Courses.png";
    // url = "http://enterprisedemo.instancy.com/Content/SiteFiles/Images/elearning%20Courses.png";
    // url = "https://upgradedenterprise.instancy.com/content/onboarding/1_image.png";
    // url = "https://qacontent.blob.core.windows.net/qainstancycontent/content/sitefiles/images/media resource.jpg";
    // url = AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(imagePath: url);
    // MyPrint.printOnConsole("mylearning content final image url:$url");

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 80,
        width: 80,
        child: CommonCachedNetworkImage(
          imageUrl: url,
          height: 80,
          width: 80,
          shimmerIconSize: 60,
          errorIconSize: 60,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget detailColumn(CourseDTOModel model) {
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
          model.TitleName,
          style: themeData.textTheme.titleMedium?.copyWith(color: const Color(0xff1D293F), fontWeight: FontWeight.w600, fontSize: 14),
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
                  ratingView(model.RatingID),
                ],
              ),
            ),
            if (MyLearningUIActionConfigs.isContentTypeDownloadable(objectTypeId: model.ContentTypeId, mediaTypeId: model.MediaTypeID))
              CourseDownloadButton(
                contentId: model.ContentID,
                onDownloadTap: widget.onDownloadTap,
              ),
          ],
        ),
        eventStartDateAndTime(model),
        const SizedBox(height: 8),
        Consumer<CourseDownloadProvider>(
          builder: (BuildContext context, CourseDownloadProvider courseDownloadProvider, Widget? child) {
            String courseDownloadId = CourseDownloadDataModel.getDownloadId(contentId: model.ContentID);
            CourseDownloadDataModel? downloadModel = courseDownloadProvider.getCourseDownloadDataModelFromId(courseDownloadId: courseDownloadId, isNewInstance: false);

            if (downloadModel?.isCourseDownloaded == true && downloadModel?.courseDTOModel != null) {
              CourseDTOModel newModel = downloadModel!.courseDTOModel!;

              return linearProgressBar(
                ContentTypeId: newModel.ContentTypeId,
                actualStatus: newModel.ActualStatus,
                percentCompleted: newModel.PercentCompleted,
                contentStatus: newModel.ContentStatus,
              );
            }

            return linearProgressBar(
              ContentTypeId: model.ContentTypeId,
              actualStatus: model.ActualStatus,
              percentCompleted: model.PercentCompleted,
              contentStatus: model.ContentStatus,
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

  Widget eventStartDateAndTime(CourseDTOModel model) {
    if (model.EventStartDateTime.isEmpty || model.EventEndDateTime.isEmpty || model.ContentTypeId != InstancyObjectTypes.events) return const SizedBox();

    AppConfigurationOperations appConfigurationOperations = AppConfigurationOperations(appProvider: context.read<AppProvider>());

    DateTime? startDateTime = appConfigurationOperations.getEventDateTime(eventDate: model.EventStartDateTime);
    DateTime? endDateTime = appConfigurationOperations.getEventDateTime(eventDate: model.EventEndDateTime);

    if (startDateTime == null || endDateTime == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Date: ${DatePresentation.onlyDateFromString(model.EventStartDateTime)}",
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Time: ${DatePresentation.getFormattedDate(
              dateTime: startDateTime,
              dateFormat: "hh:mm aa",
            )} "
            "to ${DatePresentation.getFormattedDate(
              dateTime: endDateTime,
              dateFormat: "hh:mm aa",
            )}"
            " (${model.Duration})",
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }

// the parsing function to remove the html tags and maintain the text
  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    if (document.body?.text != null) {
      return parse(document.body!.text).documentElement!.text;
    }

    return "";
  }

  Widget coursesIcon({String assetName = ""}) {
    return Image.asset(
      assetName,
      height: 13,
      width: 13,
      fit: BoxFit.contain,
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
    required int ContentTypeId,
    required double percentCompleted,
    required String contentStatus,
    required String actualStatus,
  }) {
    if ([InstancyObjectTypes.aICC].contains(ContentTypeId)) {
      return const SizedBox();
    }
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
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (ContentTypeId != InstancyObjectTypes.events)
              Text(
                // "$percentCompleted% ",
                "${percentCompleted.getFormattedNumber(precision: 2)}% ",
                style: themeData.textTheme.titleSmall?.copyWith(
                  fontSize: 12,
                ),
              ),
            Text(
              _parseHtmlString(contentStatus),
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget getMoreOptionsButton() {
    if (!widget.isShowMoreOption) return const SizedBox();

    return InkWell(
      onTap: () {
        if (widget.onMoreButtonTap != null) {
          widget.onMoreButtonTap!();
        }
      },
      child: const CommonIconButton(
        // padding: 10,

        // onTap: () {
        //
        // },
        iconData: Icons.more_vert,
        iconSize: 22,
      ),
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
