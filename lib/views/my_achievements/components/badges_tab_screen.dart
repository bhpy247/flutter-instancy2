import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/models/gamification/data_model/user_badges_model.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/views/common/components/common_cached_network_image.dart';
import 'package:provider/provider.dart';

import '../../../backend/app_theme/style.dart';

class BadgesTabScreen extends StatelessWidget {
  final List<UserBadgesModel> badgesData;

  const BadgesTabScreen({
    super.key,
    required this.badgesData,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: badgesData.length,
      itemBuilder: (BuildContext context, int index) {
        UserBadgesModel userBadgesModel = badgesData[index];

        return getListSingleItem(
          context: context,
          userBadgesModel: userBadgesModel,
        );
      },
    );
  }

  Widget getListSingleItem({required BuildContext context, required UserBadgesModel userBadgesModel}) {
    ThemeData themeData = Theme.of(context);

    String badgeImageUrl = MyUtils.getSecureUrl(AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(
      imagePath: userBadgesModel.BadgeImage,
    ));
    MyPrint.printOnConsole("badgeImageUrl:$badgeImageUrl");

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 5).copyWith(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Styles.lightGreyTextColor.withOpacity(.3),
          width: .5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            child: CommonCachedNetworkImage(
              imageUrl: badgeImageUrl,
              width: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userBadgesModel.BadgeName,
                  style: themeData.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  userBadgesModel.BadgeDescription,
                  style: themeData.textTheme.bodySmall,
                ),
                const SizedBox(height: 10),
                Text(
                  "Awarded on : ${userBadgesModel.BadgeReceivedDate}",
                  style: themeData.textTheme.bodySmall,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
