import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/course_download/data_model/course_download_data_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/related_track_data_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/track_course_dto_model.dart';
import 'package:flutter_instancy_2/utils/date_representation.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
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

class MyCourseDownloadCard extends StatefulWidget {
  final CourseDownloadDataModel courseDownloadDataModel;
  final InstancyUIActionModel? primaryAction;
  final void Function()? onMoreButtonTap, onPrimaryActionTap, onThumbnailClick, onDownloadTap;
  final bool isShowMoreOption;

  const MyCourseDownloadCard({
    Key? key,
    required this.courseDownloadDataModel,
    this.primaryAction,
    this.onThumbnailClick,
    this.onMoreButtonTap,
    this.onPrimaryActionTap,
    this.onDownloadTap,
    this.isShowMoreOption = true,
  }) : super(key: key);

  @override
  State<MyCourseDownloadCard> createState() => _MyCourseDownloadCardState();
}

class _MyCourseDownloadCardState extends State<MyCourseDownloadCard> {
  late ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    MyCourseDownloadCardDataModel? myCourseDownloadDataModel;
    bool isEvent = false;

    if (widget.courseDownloadDataModel.parentCourseModel != null) {
      CourseDTOModel courseDTOModel = widget.courseDownloadDataModel.parentCourseModel!;

      isEvent = courseDTOModel.ContentTypeId == InstancyObjectTypes.events;
      myCourseDownloadDataModel = MyCourseDownloadCardDataModel(
        TitleName: courseDTOModel.ContentName,
        AuthorDisplayName: courseDTOModel.AuthorDisplayName,
        ContentType: courseDTOModel.ContentType,
        ThumbnailImagePath: courseDTOModel.ThumbnailImagePath,
        CoreLessonStatus: courseDTOModel.ActualStatus,
        ContentStatus: courseDTOModel.ContentStatus,
        Duration: courseDTOModel.Duration,
        EventStartDateTime: courseDTOModel.EventStartDateTime,
        EventEndDateTime: courseDTOModel.EventEndDateTime,
        ContentTypeId: courseDTOModel.ContentTypeId,
        MediaTypeId: courseDTOModel.MediaTypeID,
        RatingID: courseDTOModel.RatingID,
        PercentCompleted: courseDTOModel.PercentCompleted,
      );
    } else if (widget.courseDownloadDataModel.courseDTOModel != null) {
      CourseDTOModel courseDTOModel = widget.courseDownloadDataModel.courseDTOModel!;

      myCourseDownloadDataModel = MyCourseDownloadCardDataModel(
        TitleName: courseDTOModel.ContentName,
        AuthorDisplayName: courseDTOModel.AuthorDisplayName,
        ContentType: courseDTOModel.ContentType,
        ThumbnailImagePath: courseDTOModel.ThumbnailImagePath,
        CoreLessonStatus: courseDTOModel.ActualStatus,
        ContentStatus: courseDTOModel.ContentStatus,
        Duration: courseDTOModel.Duration,
        EventStartDateTime: courseDTOModel.EventStartDateTime,
        EventEndDateTime: courseDTOModel.EventEndDateTime,
        ContentTypeId: courseDTOModel.ContentTypeId,
        MediaTypeId: courseDTOModel.MediaTypeID,
        RatingID: courseDTOModel.RatingID,
        PercentCompleted: courseDTOModel.PercentCompleted,
      );
    } else if (widget.courseDownloadDataModel.trackCourseDTOModel != null) {
      TrackCourseDTOModel trackCourseDTOModel = widget.courseDownloadDataModel.trackCourseDTOModel!;

      myCourseDownloadDataModel = MyCourseDownloadCardDataModel(
        TitleName: trackCourseDTOModel.ContentName,
        AuthorDisplayName: trackCourseDTOModel.AuthorDisplayName,
        ContentType: trackCourseDTOModel.ContentType,
        ThumbnailImagePath: trackCourseDTOModel.ThumbnailImagePath,
        CoreLessonStatus: trackCourseDTOModel.CoreLessonStatus,
        ContentStatus: trackCourseDTOModel.ContentStatus,
        Duration: trackCourseDTOModel.Duration,
        EventStartDateTime: trackCourseDTOModel.EventStartDateTime,
        EventEndDateTime: trackCourseDTOModel.EventEndDateTime,
        ContentTypeId: trackCourseDTOModel.ContentTypeId,
        MediaTypeId: trackCourseDTOModel.MediaTypeID,
        RatingID: ParsingHelper.parseDoubleMethod(trackCourseDTOModel.RatingID),
        PercentCompleted: ParsingHelper.parseDoubleMethod(trackCourseDTOModel.ContentProgress),
      );
    } else if (widget.courseDownloadDataModel.relatedTrackDataDTOModel != null) {
      RelatedTrackDataDTOModel relatedTrackDataDTOModel = widget.courseDownloadDataModel.relatedTrackDataDTOModel!;

      myCourseDownloadDataModel = MyCourseDownloadCardDataModel(
        TitleName: relatedTrackDataDTOModel.Name,
        AuthorDisplayName: relatedTrackDataDTOModel.AuthorName,
        ContentType: relatedTrackDataDTOModel.ContentType,
        ThumbnailImagePath: relatedTrackDataDTOModel.ThumbnailImagePath,
        CoreLessonStatus: relatedTrackDataDTOModel.CoreLessonStatus,
        ContentStatus: relatedTrackDataDTOModel.ContentDisplayStatus,
        Duration: relatedTrackDataDTOModel.Duration,
        EventStartDateTime: relatedTrackDataDTOModel.EventStartDateTime,
        EventEndDateTime: relatedTrackDataDTOModel.EventEndDateTime,
        ContentTypeId: relatedTrackDataDTOModel.ContentTypeId,
        MediaTypeId: relatedTrackDataDTOModel.MediaTypeID,
        RatingID: ParsingHelper.parseDoubleMethod(relatedTrackDataDTOModel.TotalRatings),
        PercentCompleted: relatedTrackDataDTOModel.PercentCompleted,
      );
    }

    if (myCourseDownloadDataModel == null) {
      return const SizedBox();
    }

    return InkWell(
      onTap: () {
        if (widget.onPrimaryActionTap != null) {
          widget.onPrimaryActionTap!();
        }
      },
      child: Column(
        children: [
          /*if (widget.courseDownloadDataModel.parentContentName.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
              child: Center(
                child: Text(
                  widget.courseDownloadDataModel.parentContentName,
                  style: themeData.textTheme.labelMedium?.copyWith(
                    color: themeData.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),*/
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: themeData.colorScheme.onPrimary,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    if (widget.onThumbnailClick != null) {
                      widget.onThumbnailClick!();
                    }
                  },
                  child: imageWidget(myCourseDownloadDataModel.ThumbnailImagePath),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: detailColumn(
                    myCourseDownloadCardDataModel: myCourseDownloadDataModel,
                    isEvent: isEvent,
                  ),
                ),
              ],
            ),
          ),
        ],
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

  Widget detailColumn({required MyCourseDownloadCardDataModel myCourseDownloadCardDataModel, bool isEvent = false}) {
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
                      objectTypeId: myCourseDownloadCardDataModel.ContentTypeId,
                      mediaTypeId: myCourseDownloadCardDataModel.MediaTypeId,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    myCourseDownloadCardDataModel.ContentType,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Color(0xff757575),
                    ),
                  )
                ],
              ),
            ),
            getMoreOptionsButton(),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          myCourseDownloadCardDataModel.TitleName,
          style: themeData.textTheme.titleMedium?.copyWith(
            color: const Color(0xff1D293F),
            fontWeight: FontWeight.w600,
            fontSize: 14,
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
                    myCourseDownloadCardDataModel.AuthorDisplayName,
                    style: themeData.textTheme.bodySmall?.copyWith(
                      fontSize: 12,
                      color: const Color(0xff9AA0A6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ratingView(myCourseDownloadCardDataModel.RatingID),
                ],
              ),
            ),
            if (widget.courseDownloadDataModel.parentCourseModel == null)
              CourseDownloadButton(
                contentId: widget.courseDownloadDataModel.contentId,
                parentEventTrackId: widget.courseDownloadDataModel.parentContentId,
                onDownloadTap: widget.onDownloadTap,
              ),
          ],
        ),
        eventStartDateAndTime(myCourseDownloadCardDataModel: myCourseDownloadCardDataModel),
        if (!isEvent) ...[
          const SizedBox(height: 8),
          linearProgressBar(
            ContentTypeId: myCourseDownloadCardDataModel.ContentTypeId,
            actualStatus: myCourseDownloadCardDataModel.CoreLessonStatus,
            contentStatus: myCourseDownloadCardDataModel.ContentStatus,
            percentCompleted: myCourseDownloadCardDataModel.PercentCompleted,
          ),
        ],
      ],
    );
  }

  Widget eventStartDateAndTime({required MyCourseDownloadCardDataModel myCourseDownloadCardDataModel}) {
    if (myCourseDownloadCardDataModel.EventStartDateTime.isEmpty || myCourseDownloadCardDataModel.EventEndDateTime.isEmpty || myCourseDownloadCardDataModel.ContentTypeId != InstancyObjectTypes.events)
      return const SizedBox();

    AppConfigurationOperations appConfigurationOperations = AppConfigurationOperations(appProvider: context.read<AppProvider>());

    DateTime? startDateTime = appConfigurationOperations.getEventDateTime(eventDate: myCourseDownloadCardDataModel.EventStartDateTime);
    DateTime? endDateTime = appConfigurationOperations.getEventDateTime(eventDate: myCourseDownloadCardDataModel.EventEndDateTime);

    if (startDateTime == null || endDateTime == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Date: ${DatePresentation.onlyDateFromString(myCourseDownloadCardDataModel.EventStartDateTime)}",
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
            " (${myCourseDownloadCardDataModel.Duration})",
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
                "${percentCompleted.toInt()}% ",
              style: themeData.textTheme.titleSmall?.copyWith(
                fontSize: 12,
              ),
            ),
            Text(
              _parseHtmlString(contentStatus),
              style: const TextStyle(fontSize: 12),
            )

            // Expanded(
            //   child: Container(
            //     color: Colors.red,
            //     height: 20,
            //     child: Html(
            //       data: contentStatus,
            //       shrinkWrap: true,
            //       style: {
            //         "span": Style(
            //           textAlign: TextAlign.left,
            //           // backgroundColor: Colors.green,
            //           alignment: Alignment.centerLeft,
            //           verticalAlign: VerticalAlign.sup,
            //
            //           padding: EdgeInsets.zero,
            //           fontSize: FontSize(12),
            //
            //           margin: Margins.symmetric(vertical: 0),
            //           lineHeight: LineHeight.number(0),
            //         ),
            //       },
            //     ),
            //   ),
            // )
          ],
        )
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

class MyCourseDownloadCardDataModel {
  final String TitleName;
  final String AuthorDisplayName;
  final String ContentType;
  final String ThumbnailImagePath;
  final String CoreLessonStatus;
  final String ContentStatus;
  final String Duration;
  final String EventStartDateTime;
  final String EventEndDateTime;
  final int ContentTypeId;
  final int MediaTypeId;
  final double RatingID;
  final double PercentCompleted;

  MyCourseDownloadCardDataModel({
    required this.TitleName,
    required this.AuthorDisplayName,
    required this.ContentType,
    required this.ThumbnailImagePath,
    required this.CoreLessonStatus,
    required this.ContentStatus,
    required this.Duration,
    required this.EventStartDateTime,
    required this.EventEndDateTime,
    required this.ContentTypeId,
    required this.MediaTypeId,
    required this.RatingID,
    required this.PercentCompleted,
  });
}
