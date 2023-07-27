import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/local_str.dart';
import 'package:provider/provider.dart';

import 'common_button.dart';

class CommonConfirmationDialog extends StatelessWidget {
  final String title;
  final String description;
  final String cancelText;
  final String confirmationText;
  final GestureTapCallback? onCancelTap, onConfirmTap;
  final bool showCancel, showConfirm;

  const CommonConfirmationDialog({
    Key? key,
    required this.title,
    required this.description,
    this.cancelText = "",
    this.confirmationText = "",
    this.onCancelTap,
    this.onConfirmTap,
    this.showCancel = true,
    this.showConfirm = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalStr localStr = context.read<AppProvider>().localStr;
    ThemeData themeData = Theme.of(context);

    return AlertDialog(
      title: Text(
        title,
        style: themeData.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            description,
            style: themeData.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.normal,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                if(showCancel) CommonButton(
                  onPressed: () {
                    if (onCancelTap != null) {
                      onCancelTap!();
                    } else {
                      Navigator.of(context).pop(false);
                    }
                  },
                  backGroundColor: themeData.colorScheme.onPrimary,
                  borderColor: themeData.primaryColor,
                  fontColor: themeData.primaryColor,
                  fontWeight: FontWeight.w600,
                  text: cancelText.isNotEmpty ? cancelText : localStr.profileButtonExperiencecancelbutton,
                ),
                if(showConfirm) Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: CommonButton(
                    onPressed: () {
                      if (onConfirmTap != null) {
                        onConfirmTap!();
                      } else {
                        Navigator.of(context).pop(true);
                      }
                    },
                    backGroundColor: themeData.primaryColor,
                    borderColor: themeData.primaryColor,
                    fontColor: themeData.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                    text: confirmationText.isNotEmpty ? confirmationText : localStr.myskillAlerttitleStringconfirm,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
