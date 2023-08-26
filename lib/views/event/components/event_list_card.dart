import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../../backend/ui_actions/primary_secondary_actions/primary_secondary_actions_constants.dart';
import '../../../configs/app_configurations.dart';
import '../../../models/course/data_model/mobile_lms_course_model.dart';
import '../../../utils/date_representation.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/common_cached_network_image.dart';
import '../../common/components/common_icon_button.dart';
import '../../common/components/instancy_ui_actions/instancy_ui_actions.dart';

class EventListCard extends StatelessWidget {
  final MobileLmsCourseModel model;
  final InstancyUIActionModel? primaryAction;
  final Function()? onPrimaryActionTap, onMoreButtonTap;

  const EventListCard({
    Key? key,
    required this.model,
    this.primaryAction,
    this.onPrimaryActionTap,
    this.onMoreButtonTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // late ThemeData themeData = Theme.of(context);

    return InkWell(
      onTap: () {
        if (onPrimaryActionTap != null) {
          onPrimaryActionTap!();
        }
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageWidget(url: model.thumbnailimagepath, context: context),
            const SizedBox(width: 20),
            Expanded(child: detailColumn(context: context)),
          ],
        ),
      ),
    );
  }

  Widget imageWidget({required String url, required BuildContext context}) {
    // MyPrint.printOnConsole("catalog content image url:$url");

    url = MyUtils.getSecureUrl(AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(imagePath: url));
    // MyPrint.printOnConsole("catalog content final image url:$url");

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 80,
        width: 80,
        child: CommonCachedNetworkImage(
          imageUrl: url,
          height: 80,
          width: 80,
          fit: BoxFit.cover,
          errorIconSize: 60,
        ),
      ),
    );
  }

  Widget detailColumn({required BuildContext context}) {
    ThemeData themeData = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  coursesIcon(assetName: AppConfigurations.getContentIconFromObjectAndMediaType(mediaTypeId: model.mediatypeid, objectTypeId: model.objecttypeid)),
                  const SizedBox(width: 10),
                  Text(
                    model.contenttype,
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
        const SizedBox(height: 0),
        Text(
          model.name,
          style: themeData.textTheme.titleSmall?.copyWith(color: const Color(0xff1D293F), fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.presenter,
              style: themeData.textTheme.bodySmall?.copyWith(
                fontSize: 12,
                color: const Color(0xff9AA0A6),
              ),
            ),
            const SizedBox(height: 8),
            ratingView(ParsingHelper.parseDoubleMethod(model.totalratings)),
            Container(
              child: eventStartDateAndTime(model: model, context: context),
            ),
            getPrimaryActionButton(
              model: model,
              context: context,
              primaryAction: primaryAction,
            ),
          ],
        ),
      ],
    );
  }

  Widget eventStartDateAndTime({required MobileLmsCourseModel model, required BuildContext context}) {
    // MyPrint.printOnConsole("model. endDateTime: '${model.EventEndDateTime} to ${model.EventEndDateTimeTimeWithoutConvert}'");

    AppProvider appProvider = context.read<AppProvider>();

    if (model.eventstartdatetime.isEmpty) return const SizedBox();

    DateTime? startDateTime = ParsingHelper.parseDateTimeMethod(model.eventstartdatetime);
    startDateTime ??= ParsingHelper.parseDateTimeMethod(model.eventstartdatetime, dateFormat: appProvider.appSystemConfigurationModel.dateTimeFormat);

    if (startDateTime == null) return const SizedBox();

    ThemeData themeData = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Date: ${DatePresentation.getFormattedDate(dateTime: startDateTime, dateFormat: "dd MMM yyyy")}",
            style: themeData.textTheme.labelSmall?.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: themeData.textTheme.labelSmall!.color?.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Time: ${DatePresentation.getFormattedDate(dateTime: startDateTime, dateFormat: "hh:mm aa")} (${model.duration})",
            // "Time: ${DatePresentation.getFormattedDate(dateTime: startDateTime, dateFormat: "hh:mm aa")}",
            style: themeData.textTheme.labelSmall?.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: themeData.textTheme.labelSmall!.color?.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Available seats : ${model.availableseats}",
            style: themeData.textTheme.labelSmall?.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: themeData.textTheme.labelSmall!.color?.withOpacity(0.7),
            ),
          )
        ],
      ),
    );
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

  Widget getMoreOptionsButton() {
    return InkWell(
      onTap: () {
        if (onMoreButtonTap != null) {
          onMoreButtonTap!();
        }
      },
      child: const CommonIconButton(
        iconData: Icons.more_vert,
        iconSize: 22,
      ),
    );
  }

  Widget getPrimaryActionButton({
    required MobileLmsCourseModel model,
    required BuildContext context,
    required InstancyUIActionModel? primaryAction,
  }) {
    ThemeData themeData = Theme.of(context);

    if (primaryAction == null) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 25,
            child: CommonButton(
              height: 25,
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              onPressed: () {
                if (onPrimaryActionTap != null) {
                  onPrimaryActionTap!();
                }
              },
              backGroundColor: themeData.primaryColor,
              child: Text(
                primaryAction.text,
                style: themeData.textTheme.labelSmall?.copyWith(
                  fontSize: 12,
                  color: themeData.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          primaryAction.actionsEnum == InstancyContentActionsEnum.Buy
              ? Text(
                  "${model.currency}${model.saleprice}",
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