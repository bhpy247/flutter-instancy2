import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../configs/app_configurations.dart';
import '../../../utils/parsing_helper.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_cached_network_image.dart';

class CourseComponent extends StatelessWidget {
  final CourseDTOModel model;

  const CourseComponent({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    // late ThemeData themeData = Theme.of(context);

    return Container(
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
    );
  }

  Widget imageWidget({required String url, required BuildContext context}) {
    // MyPrint.printOnConsole("catalog content image url:$url");

    // url = MyUtils.getSecureUrl(AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(imagePath: url));
    // MyPrint.printOnConsole("catalog content final image url:$url");

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: const SizedBox(
        height: 80,
        width: 80,
        child: CommonCachedNetworkImage(
          imageUrl: "https://picsum.photos/200/300",
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
                      mediaTypeId: 1,
                      objectTypeId: 2,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Augmented Reality",
                    style: themeData.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          model.Title,
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
              "Dr. Joseph Campbell",
              style: themeData.textTheme.bodySmall?.copyWith(
                fontSize: 11,
                // color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            ratingView(ParsingHelper.parseDoubleMethod(3)),
            getBottomViewInButton(themeData)
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

  Widget ratingView(double ratings) {
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

  Widget getBottomViewInButton(ThemeData themeData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          children: [
            CommonButton(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              backGroundColor: Colors.transparent,
              borderColor: themeData.primaryColor,
              borderWidth: 1,
              onPressed: () {},
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
            const SizedBox(width: 17),
            Expanded(
              child: CommonButton(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                backGroundColor: themeData.primaryColor,
                borderColor: themeData.primaryColor,
                borderWidth: 1,
                onPressed: () {},
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
                    Flexible(
                      child: Text(
                        "3D Environment",
                        style: themeData.textTheme.labelSmall?.copyWith(
                          color: themeData.colorScheme.onPrimary,
                          // fontSize: 12,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
