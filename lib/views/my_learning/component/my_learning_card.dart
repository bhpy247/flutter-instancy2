import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/utils/date_representation.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/views/common/components/common_cached_network_image.dart';
import 'package:flutter_instancy_2/views/common/components/common_icon_button.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:html/parser.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:provider/provider.dart';

import '../../../backend/app/app_provider.dart';
import '../../../backend/configurations/app_configuration_operations.dart';
import '../../../backend/ui_actions/primary_secondary_actions/primary_secondary_actions.dart';
import '../../../models/my_learning/data_model/my_learning_course_dto_model.dart';
import '../../../utils/my_print.dart';
import '../../common/components/common_button.dart';
import '../../common/components/instancy_ui_actions/instancy_ui_actions.dart';

class MyLearningCard extends StatefulWidget {
  final MyLearningCourseDTOModel myLearningCourseDTOModel;
  final InstancyUIActionModel? primaryAction;
  final void Function()? onMoreButtonTap, onPrimaryActionTap, onThumbnailClick;
  final bool isShowMoreOption;

  const MyLearningCard({
    Key? key,
    required this.myLearningCourseDTOModel,
    this.primaryAction,
    this.onThumbnailClick,
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
              child: imageWidget(widget.myLearningCourseDTOModel.ThumbnailImagePath),
            ),
            const SizedBox(width: 10),
            Expanded(child: detailColumn(widget.myLearningCourseDTOModel))
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
    MyPrint.printOnConsole("mylearning content final image url:$url");

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

  Widget detailColumn(MyLearningCourseDTOModel model) {
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
            // downloadIcon(model)
          ],
        ),
        eventStartDateAndTime(model),
        const SizedBox(height: 8),
        // if (model.ContentTypeId != InstancyObjectTypes.events)
        linearProgressBar(
          actualStatus: model.ActualStatus,
          percentCompleted: model.PercentCompleted,
          contentStatus: model.ContentStatus,
        ),
        /*getPrimaryActionButton(
          model: model,
          context: context,
          primaryAction: widget.primaryAction,
        ),*/
      ],
    );
  }

  Widget eventStartDateAndTime(MyLearningCourseDTOModel model) {
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
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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

  Widget downloadIcon(MyLearningCourseDTOModel model) {
    if ((model.ContentTypeId == 10 && model.bit5) || [20, 27, 28, 36, 70, 102, 688, 693].contains(model.ContentTypeId)) {
      return const SizedBox();
    }
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3,
            spreadRadius: 1,
          ),
        ],
      ),
      child: InkWell(
        onTap: () {},
        child: const Padding(
          padding: EdgeInsets.all(3.0),
          child: Icon(
            Icons.file_download_outlined,
            color: Color(0xff242424),
          ),
        ),
      ),
    );
  }

  Widget getPrimaryActionButton({
    required MyLearningCourseDTOModel model,
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
              child: Text(
                primaryAction.text,
                style: themeData.textTheme.bodySmall?.copyWith(fontSize: 12),
              ),
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