import 'package:flutter/material.dart';

import '../../../models/membership/data_model/user_active_membership_dto_model.dart';
import '../../common/components/common_button.dart';

class UserActiveMembershipCard extends StatelessWidget {
  final UserActiveMembershipDTOModel model;
  final void Function({required UserActiveMembershipDTOModel model})? updateMembership, cancelMembership;

  const UserActiveMembershipCard({
    super.key,
    required this.model,
    this.updateMembership,
    this.cancelMembership,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Container(
      // color: Colors.red,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: themeData.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: themeData.colorScheme.onBackground.withAlpha(50),
            offset: const Offset(0, 2),
            spreadRadius: 1,
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: themeData.colorScheme.onBackground.withAlpha(20),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.star,
                        color: themeData.colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Current Plan",
                            style: themeData.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            model.UserMembership,
                            style: themeData.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: themeData.textTheme.labelSmall!.color?.withAlpha(100),
                            ),
                          ),
                        ],
                      ),
                    ),
                    /*const SizedBox(width: 10),
                    CommonButton(
                      onPressed: () {},
                      text: "Manage",
                      borderRadius: 100,
                      backGroundColor: themeData.scaffoldBackgroundColor,
                      borderColor: themeData.primaryColor,
                      borderWidth: 1,
                      fontColor: themeData.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),*/
                  ],
                ),
                const SizedBox(height: 10),
                if (model.DurationValue.isNotEmpty || model.DurationType.isNotEmpty) ...[
                  Row(
                    children: [
                      Text(
                        "Billing Period : ${model.DurationValue} ${model.DurationType}",
                        style: themeData.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
                if (model.DisplayStartDate.isNotEmpty) ...[
                  Row(
                    children: [
                      Text(
                        "Effective Date : ${model.DisplayStartDate}",
                        style: themeData.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
                if (model.DisplayExpirydate.isNotEmpty) ...[
                  Row(
                    children: [
                      Text(
                        "Expiry Date : ${model.DisplayExpirydate}",
                        style: themeData.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
          getActionButtonsWidget(themeData: themeData),
        ],
      ),
    );
  }

  Widget getActionButtonsWidget({required ThemeData themeData}) {
    Widget? cancelMembershipButton;
    if (model.RenewalType == "a") {
      cancelMembershipButton = CommonButton(
        onPressed: () {
          if (cancelMembership != null) cancelMembership!(model: model);
        },
        text: "Cancel Membership",
        backGroundColor: Colors.transparent,
        borderColor: themeData.primaryColor,
        borderWidth: 1,
        fontColor: themeData.primaryColor,
        fontWeight: FontWeight.bold,
      );
    }

    Widget? updateMembershipButton;
    if (model.IsChangePlan) {
      updateMembershipButton = CommonButton(
        onPressed: () {
          if (updateMembership != null) updateMembership!(model: model);
        },
        text: "Update Membership",
        backGroundColor: themeData.primaryColor,
        borderColor: themeData.primaryColor,
        borderWidth: 1,
        fontColor: themeData.colorScheme.onPrimary,
        fontWeight: FontWeight.bold,
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: themeData.primaryColor.withAlpha(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (cancelMembershipButton != null) Flexible(child: cancelMembershipButton),
          if (cancelMembershipButton != null && updateMembershipButton != null) const SizedBox(width: 5),
          if (updateMembershipButton != null) Flexible(child: updateMembershipButton),
        ],
      ),
    );
  }
}
