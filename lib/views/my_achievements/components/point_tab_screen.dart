import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/models/gamification/data_model/user_points_model.dart';

import '../../../backend/app_theme/style.dart';

class PointTabScreen extends StatelessWidget {
  final List<UserPointsModel> pointsData;

  const PointTabScreen({
    super.key,
    required this.pointsData,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    if (pointsData.isEmpty) {
      return AppConfigurations.commonNoDataView();
    }

    return Column(
      children: [
        const SizedBox(height: 10),
        getHeaderRowWidget(themeData: themeData),
        Expanded(child: getListPointList(themeData: themeData)),
      ],
    );
  }

  Widget getHeaderRowWidget({required ThemeData themeData}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "Activity",
              style: themeData.textTheme.bodyLarge?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            child: Text(
              "Points",
              style: themeData.textTheme.bodyLarge?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "Awarded on",
              style: themeData.textTheme.bodyLarge?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getListPointList({required ThemeData themeData}) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: pointsData.length,
      shrinkWrap: false,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        UserPointsModel userPointsModel = pointsData[index];

        return getListSingleItemView(
          themeData: themeData,
          userPointsModel: userPointsModel,
        );
      },
    );
  }

  Widget getListSingleItemView({required ThemeData themeData, required UserPointsModel userPointsModel}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Styles.lightGreyTextColor.withOpacity(1),
          width: .5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              userPointsModel.ActionName,
              style: themeData.textTheme.labelMedium?.copyWith(
                // fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              userPointsModel.Points.toString(),
              style: themeData.textTheme.bodyLarge?.copyWith(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            flex: 1,
            child: Text(
              userPointsModel.UserReceivedDate,
              style: themeData.textTheme.bodyLarge?.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
