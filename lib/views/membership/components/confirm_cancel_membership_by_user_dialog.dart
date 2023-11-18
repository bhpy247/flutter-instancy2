import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/local_str.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';

import '../../../models/membership/data_model/user_active_membership_dto_model.dart';
import '../../common/components/common_button.dart';

class ConfirmCancelMembershipByUserDialog extends StatefulWidget {
  final UserActiveMembershipDTOModel model;
  final LocalStr? localStr;

  const ConfirmCancelMembershipByUserDialog({
    Key? key,
    required this.model,
    this.localStr,
  }) : super(key: key);

  @override
  State<ConfirmCancelMembershipByUserDialog> createState() => _ConfirmCancelMembershipByUserDialogState();
}

class _ConfirmCancelMembershipByUserDialogState extends State<ConfirmCancelMembershipByUserDialog> with MySafeState {
  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    // LocalStr localStrNew = localStr ?? context.read<AppProvider>().localStr;

    ThemeData themeData = Theme.of(context);

    return AlertDialog(
      title: Text(
        "Cancel Your Membership?",
        style: themeData.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Click ',
                ),
                TextSpan(
                  text: '"Finish Cancellation"',
                  style: themeData.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(
                  text: ' below to Cancel your Membership ',
                ),
              ],
              style: themeData.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 10),
          getInstructionsBulletPointsWidget(),
        ],
      ),
      actions: <Widget>[
        getActionButtons(),
      ],
    );
  }

  Widget getInstructionsBulletPointsWidget() {
    return Column(
      children: [
        getBulletPointsWidget(text: "Cancellation will be effective at the end of the current billing period on ${widget.model.ActualEndDateTimeString}"),
        getBulletPointsWidget(text: "Restart your membership anytime. Your viewing preferences will be saved for 3 months."),
      ],
    );
  }

  Widget getBulletPointsWidget({required String text}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: themeData.colorScheme.onBackground,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(3),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: themeData.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CommonButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          backGroundColor: themeData.colorScheme.onPrimary,
          borderColor: themeData.primaryColor,
          fontColor: themeData.primaryColor,
          fontWeight: FontWeight.w600,
          // isPrimary: false,
          text: "Go Back",
        ),
        const SizedBox(width: 10),
        CommonButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          backGroundColor: themeData.primaryColor,
          borderColor: themeData.primaryColor,
          fontColor: themeData.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
          // isPrimary: true,
          text: "Finish Cancellation",
        ),
      ],
    );
  }
}
