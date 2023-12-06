import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/models/gamification/data_model/users_leader_board_dto_model.dart';
import 'package:flutter_instancy_2/models/gamification/response_model/leader_board_dto_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/views/common/components/common_cached_network_image.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:provider/provider.dart';

import '../../../backend/app_theme/style.dart';

class LeadersTabScreen extends StatelessWidget {
  final bool isLoadingData;
  final LeaderBoardDTOModel? leaderBoardDTOModel;

  const LeadersTabScreen({
    super.key,
    this.isLoadingData = false,
    this.leaderBoardDTOModel,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    if (isLoadingData) {
      return const SizedBox(
        height: 200,
        child: CommonLoader(),
      );
    } else if ((leaderBoardDTOModel?.LeaderBoardList).checkEmpty) {
      return AppConfigurations.commonNoDataView();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        getHeaderRowWidget(themeData: themeData),
        getListViewWidget(
          themeData: themeData,
          leaders: leaderBoardDTOModel?.LeaderBoardList ?? <UsersLeaderBoardDTOModel>[],
        ),
      ],
    );
  }

  Widget getHeaderRowWidget({required ThemeData themeData}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Rank",
              style: themeData.textTheme.labelMedium?.copyWith(
                // fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              "Colleague",
              style: themeData.textTheme.labelMedium?.copyWith(
                // fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              "Points",
              style: themeData.textTheme.labelMedium?.copyWith(
                // fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              "Badges",
              style: themeData.textTheme.labelMedium?.copyWith(
                // fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget getListViewWidget({required ThemeData themeData, required List<UsersLeaderBoardDTOModel> leaders}) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: leaders.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        UsersLeaderBoardDTOModel leaderBoardDTOModel = leaders[index];

        return getListSingleItemView(
          context: context,
          leaderBoardDTOModel: leaderBoardDTOModel,
          seriesRank: index + 1,
        );
      },
    );
  }

  Widget getListSingleItemView({required BuildContext context, required UsersLeaderBoardDTOModel leaderBoardDTOModel, int seriesRank = 0}) {
    ThemeData themeData = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 5).copyWith(bottom: 10),
      decoration: BoxDecoration(
          border: Border.all(
            color: Styles.lightGreyTextColor.withOpacity(.3),
            width: .5,
          ),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Expanded(child: getRankWidget(rank: seriesRank)),
          Expanded(
            flex: 3,
            child: getProfileView(
              context: context,
              leaderBoardDTOModel: leaderBoardDTOModel,
            ),
          ),
          Expanded(
            child: Text(
              "${leaderBoardDTOModel.Points}",
              style: themeData.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              "${leaderBoardDTOModel.Badges}",
              style: themeData.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget getProfileView({required BuildContext context, required UsersLeaderBoardDTOModel leaderBoardDTOModel, bool isRankIncreased = false}) {
    ThemeData themeData = Theme.of(context);

    String userImageUrl = MyUtils.getSecureUrl(AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(
      imagePath: leaderBoardDTOModel.UserPicturePath,
    ));

    return Row(
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5.0, right: 5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CommonCachedNetworkImage(
                  imageUrl: userImageUrl,
                  // imageUrl: "https://picsum.photos/200",
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            /*Image.asset(
              "assets/my_dashboard/bubble_up.png",
              height: 25,
              width: 25,
            ),*/
          ],
        ),
        const SizedBox(width: 2),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                leaderBoardDTOModel.UserDisplayName,
                style: themeData.textTheme.bodyMedium,
              ),
              Text(
                leaderBoardDTOModel.LevelName,
                style: themeData.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: themeData.textTheme.bodyMedium?.color?.withAlpha(150),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget getRankWidget({required int rank}) {
    if (rank >= 1 && rank <= 3) {
      return Container(
        alignment: Alignment.topLeft,
        child: Image.asset(
          "assets/my_dashboard/$rank.png",
          height: 25,
          fit: BoxFit.contain,
        ),
      );
    }

    return Container(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.grey.withOpacity(.3), shape: BoxShape.circle),
        child: Text(
          "$rank",
          style: const TextStyle(color: Styles.lightGreyTextColor),
        ),
      ),
    );
  }
}
