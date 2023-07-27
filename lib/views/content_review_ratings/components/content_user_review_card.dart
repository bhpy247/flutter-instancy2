import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../backend/app/app_provider.dart';
import '../../../backend/configurations/app_configuration_operations.dart';
import '../../../configs/ui_configurations.dart';
import '../../../models/content_review_ratings/data_model/content_user_rating_model.dart';
import '../../common/components/common_cached_network_image.dart';
import '../../common/components/common_rating_bar.dart';

class ContentUserReviewCard extends StatelessWidget {
  final ContentUserRatingModel ratingModel;
  final bool isEditingEnabled;
  final void Function()? onEditingTap;

  const ContentUserReviewCard({
    Key? key,
    required this.ratingModel,
    this.isEditingEnabled = false,
    this.onEditingTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    AppProvider appProvider = context.read<AppProvider>();

    String imageUrl = AppConfigurationOperations(appProvider: appProvider).getInstancyImageUrlFromImagePath(imagePath: ratingModel.picture);
    // MyPrint.printOnConsole("imageUrl:$imageUrl");

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ClipOval(
          child: CommonCachedNetworkImage(
            imageUrl: imageUrl,
            width: 50,
            height: 50,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (ratingModel.description.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Text(
                    "",
                    style: themeData.textTheme.labelMedium,
                  ),
                ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      ratingModel.userName,
                      style: themeData.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 5),
                  CommonRatingBar(
                    rating: ratingModel.ratingId.toDouble(),
                    color: InstancyColors.starColor,
                    unratedColor: InstancyColors.starGreyColor,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: (ratingModel.description.isNotEmpty)
                     ? Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Text(
                        ratingModel.description,
                        style: themeData.textTheme.labelMedium,
                      ),
                    )
                    : const SizedBox(),
                  ),
                  if(isEditingEnabled) IconButton(
                    onPressed: () {
                      if(onEditingTap != null) {
                        onEditingTap!();
                      }
                    },
                    iconSize: 20,
                    icon: const Icon(
                      Icons.edit,
                      // color: Colors.black,
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
