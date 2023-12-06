import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/classroom_events/data_model/event_recodting_mobile_lms_data_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/event_track_content_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/views/common/components/common_cached_network_image.dart';
import 'package:flutter_instancy_2/views/common/components/common_icon_button.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:provider/provider.dart';

import '../../../backend/ui_actions/primary_secondary_actions/primary_secondary_actions.dart';
import '../../../models/course/data_model/CourseDTOModel.dart';
import '../../../utils/my_print.dart';
import '../../common/components/common_button.dart';
import '../../common/components/instancy_ui_actions/instancy_ui_actions.dart';

class EventTrackContentCard extends StatefulWidget {
  final EventTrackContentModel eventTrackContentModel;
  final InstancyUIActionModel? primaryAction;
  final void Function()? onMoreButtonTap, onPrimaryActionTap;
  final bool isShowMoreOption;

  const EventTrackContentCard({
    Key? key,
    required this.eventTrackContentModel,
    this.primaryAction,
    this.onMoreButtonTap,
    this.onPrimaryActionTap,
    this.isShowMoreOption = true,
  }) : super(key: key);

  @override
  State<EventTrackContentCard> createState() => _EventTrackContentCardState();
}

class _EventTrackContentCardState extends State<EventTrackContentCard> {
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
            imageWidget(widget.eventTrackContentModel.thumbnailimagepath),
            const SizedBox(width: 10),
            Expanded(child: detailColumn(widget.eventTrackContentModel)),
          ],
        ),
      ),
    );
  }

  Widget imageWidget(String url) {
    String imageUrl = MyUtils.getSecureUrl(AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(imagePath: url));
    MyPrint.printOnConsole("Event Track Content Thumbnail Image Url:$imageUrl");

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

  Widget detailColumn(EventTrackContentModel model) {
    int percentageCompleted = ParsingHelper.parseIntMethod(model.percentcompleted);
    String contentStatus = model.corelessonstatus;
    String actualStatus = model.actualstatus;

    if (model.objecttypeid == InstancyObjectTypes.events && (model.recordingModel?.contentid).checkNotEmpty) {
      EventRecordingMobileLMSDataModel recordingMobileLMSDataModel = model.recordingModel!;
      percentageCompleted = ParsingHelper.parseIntMethod(recordingMobileLMSDataModel.contentprogress);
      actualStatus = recordingMobileLMSDataModel.eventrecordstatus;
    }

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
                      mediaTypeId: model.mediatypeid,
                      objectTypeId: model.objecttypeid,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    model.medianame,
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
          model.name,
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
                    model.author,
                    style: themeData.textTheme.bodySmall?.copyWith(
                      fontSize: 12,
                      color: const Color(0xff9AA0A6),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ratingView(model.ratingid.toDouble()),
                ],
              ),
            ),
            // downloadIcon()
          ],
        ),
        const SizedBox(height: 8),
        linearProgressBar(
          percentCompleted: percentageCompleted,
          contentStatus: contentStatus,
          actualStatus: actualStatus,
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

  Widget downloadIcon() {
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
