import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/models/gamification/data_model/user_level_model.dart';

import '../../../backend/app_theme/style.dart';

class LevelTabScreen extends StatelessWidget {
  final List<UserLevelModel> levelData;

  const LevelTabScreen({
    super.key,
    required this.levelData,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return ListView.builder(
      itemCount: levelData.length,
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemBuilder: (BuildContext context, int index) {
        UserLevelModel levelModel = levelData[index];

        return getListSingleItem(levelModel: levelModel, themeData: themeData);
      },
    );
  }

  Widget getListSingleItem({required UserLevelModel levelModel, required ThemeData themeData}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
          border: Border.all(
            color: Styles.lightGreyTextColor.withOpacity(1),
            width: .5,
          ),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          /*ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: const CommonCachedNetworkImage(
              imageUrl: "https://picsum.photos/200/300",
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 7),*/
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  levelModel.LevelName,
                  style: themeData.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Achieved : ${levelModel.LevelRecivedDate.isNotEmpty ? levelModel.LevelRecivedDate : "Not Yet"}",
                  style: themeData.textTheme.labelSmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "${levelModel.LevelPoints} Points",
            style: themeData.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
