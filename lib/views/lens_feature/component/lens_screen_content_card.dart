import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../../backend/app/app_provider.dart';
import '../../../backend/configurations/app_configuration_operations.dart';
import '../../../configs/app_configurations.dart';
import '../../../models/course/data_model/CourseDTOModel.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_cached_network_image.dart';
import '../../common/components/common_icon_button.dart';
import '../../common/components/instancy_ui_actions/instancy_ui_actions.dart';

class LensScreenContentCard extends StatelessWidget {
  final CourseDTOModel model;
  final bool isShowARVRLaunch;
  final InstancyUIActionModel? primaryAction;
  final void Function(CourseDTOModel model)? onLaunchVRTap;
  final void Function(CourseDTOModel model)? onLaunchARTap;
  final void Function(CourseDTOModel model)? onMoreButtonTap;
  final Function()? onPrimaryActionTap;

  const LensScreenContentCard({
    super.key,
    required this.model,
    this.isShowARVRLaunch = true,
    this.primaryAction,
    this.onLaunchVRTap,
    this.onLaunchARTap,
    this.onMoreButtonTap,
    this.onPrimaryActionTap,
  });

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
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.white,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageWidget(url: model.ThumbnailImagePath, context: context),
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
          // imageUrl: "https://picsum.photos/200/300",
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
                  coursesIcon(
                    assetName: AppConfigurations.getContentIconFromObjectAndMediaType(
                      mediaTypeId: model.MediaTypeID,
                      objectTypeId: model.ContentTypeId,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    model.ContentType,
                    style: themeData.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w500,
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
          model.ContentName,
          style: themeData.textTheme.titleSmall?.copyWith(
            // color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.AuthorDisplayName,
              style: themeData.textTheme.bodySmall?.copyWith(
                fontSize: 11,
                // color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            ratingView(model.RatingID),
            getBottomViewInButton(context: context, themeData: themeData)
          ],
        ),
      ],
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

  Widget getMoreOptionsButton() {
    return InkWell(
      onTap: () {
        if (onMoreButtonTap != null) {
          onMoreButtonTap!(model);
        }
      },
      child: const CommonIconButton(
        iconData: Icons.more_vert,
        iconSize: 22,
      ),
    );
  }

  Widget ratingView(double ratings) {
    if (ratings <= 0) return const SizedBox();

    return RatingBarIndicator(
      rating: ratings,
      itemBuilder: (context, index) => const Icon(
        Icons.star,
        color: Colors.black,
      ),
      itemCount: 5,
      unratedColor: Colors.white,
      itemSize: 15.0,
      direction: Axis.horizontal,
    );
  }

  Widget getBottomViewInButton({required ThemeData themeData, required BuildContext context}) {
    bool isArContent = AppConfigurationOperations.isARContent(contentTypeId: model.ContentTypeId, mediaTypeId: model.MediaTypeID);

    if (!isShowARVRLaunch || !isArContent) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Text(
          "View in:",
          style: themeData.textTheme.labelSmall?.copyWith(
            // color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            /*Container(
              margin: const EdgeInsets.only(right: 17),
              child: CommonButton(
                onPressed: () {
                  if (onLaunchVRTap != null) onLaunchVRTap!(model);
                },
                padding: const EdgeInsets.symmetric(horizontal: 16),
                backGroundColor: Colors.transparent,
                borderColor: themeData.primaryColor,
                borderWidth: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/cube.png",
                      height: 15,
                      width: 15,
                      color: themeData.primaryColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "3D Spaces",
                      style: themeData.textTheme.labelSmall?.copyWith(
                        color: themeData.primaryColor,
                        // fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),*/
            CommonButton(
              onPressed: () {
                if (onLaunchARTap != null) onLaunchARTap!(model);
              },
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              backGroundColor: themeData.primaryColor,
              borderColor: themeData.primaryColor,
              borderWidth: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/3dEnvi.png",
                    height: 15,
                    width: 15,
                    color: themeData.colorScheme.onPrimary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "3D Environment",
                    style: themeData.textTheme.labelSmall?.copyWith(
                      color: themeData.colorScheme.onPrimary,
                      // fontSize: 12,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
