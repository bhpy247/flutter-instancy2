import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/views/common/components/common_cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:provider/provider.dart';

import '../../../models/gamification/data_model/user_over_all_data_model.dart';

class UserOverallDataWidget extends StatelessWidget {
  final UserOverAllDataModel userOverAllDataModel;

  const UserOverallDataWidget({
    super.key,
    required this.userOverAllDataModel,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    String userImageUrl = MyUtils.getSecureUrl(AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(
      imagePath: userOverAllDataModel.UserProfilePath,
    ));
    int totalPoints = userOverAllDataModel.OverAllPoints + userOverAllDataModel.NeededPoints;
    double progress = (userOverAllDataModel.OverAllPoints / totalPoints) * 100;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CommonCachedNetworkImage(
                  imageUrl: userImageUrl,
                  // imageUrl: "https://picsum.photos/200/300",
                  fit: BoxFit.cover,
                  height: 80,
                  width: 80,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userOverAllDataModel.UserDisplayName,
                      style: themeData.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    getPointAndSkillRowWidget(themeData: themeData),
                    const SizedBox(height: 11),
                    getLinearProgressBarWidget(
                      themeData: themeData,
                      progress: progress.toInt(),
                    ),
                  ],
                ),
              )
            ],
          ),
          if (userOverAllDataModel.NeededLevel.isNotEmpty) ...[
            const SizedBox(height: 10),
            getPointRemainingForNextLevel(
              themeData: themeData,
              remainingPoints: userOverAllDataModel.NeededPoints,
              pointsToReach: totalPoints,
              levelToReach: userOverAllDataModel.NeededLevel,
            ),
          ],
        ],
      ),
    );
  }

  Widget getPointAndSkillRowWidget({required ThemeData themeData}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            userOverAllDataModel.UserLevel,
            style: themeData.textTheme.bodySmall?.copyWith(
              color: themeData.textTheme.bodySmall?.color?.withAlpha(150),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 5),
        getPointWithBackgroundColorWidget(
          themeData: themeData,
          text: "Points ${userOverAllDataModel.OverAllPoints}",
          backgroundColor: Colors.green,
        ),
        const SizedBox(width: 5),
        getPointWithBackgroundColorWidget(
          themeData: themeData,
          text: "Badges ${userOverAllDataModel.Badges}",
          backgroundColor: Colors.blue,
        ),
      ],
    );
  }

  Widget getPointWithBackgroundColorWidget({required ThemeData themeData, required String text, required Color backgroundColor}) {
    if (text.checkEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(color: backgroundColor.withOpacity(.1), borderRadius: BorderRadius.circular(30)),
      child: Text(
        text,
        style: themeData.textTheme.bodySmall!.copyWith(color: backgroundColor, fontWeight: FontWeight.w600),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget getLinearProgressBarWidget({required ThemeData themeData, required int progress}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: LinearProgressBar(
            maxSteps: 100,
            currentStep: progress,
            progressColor: themeData.colorScheme.primary,
            backgroundColor: themeData.colorScheme.onBackground.withAlpha(50),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "$progress% Completed",
          style: themeData.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget getPointRemainingForNextLevel({required ThemeData themeData, required int remainingPoints, required int pointsToReach, required String levelToReach}) {
    return Row(
      children: [
        const Icon(
          FontAwesomeIcons.upLong,
          size: 15,
          color: Colors.green,
        ),
        Text(
          "$remainingPoints Points to next level :- $levelToReach ($pointsToReach Points)",
          style: themeData.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
