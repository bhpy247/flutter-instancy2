import 'package:flutter/material.dart';

import '../../common/components/common_button.dart';

class CommonSaveExitButtonRow extends StatelessWidget {
  late ThemeData themeData;
  final Function()? onSaveAndExitPressed, onSaveAndViewPressed;

  CommonSaveExitButtonRow({super.key, this.onSaveAndExitPressed, this.onSaveAndViewPressed});

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: CommonButton(
            onPressed: () {
              if (onSaveAndExitPressed != null) {
                onSaveAndExitPressed!();
                return;
              }
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            text: "Save & Exit",
            fontColor: themeData.primaryColor,
            backGroundColor: themeData.colorScheme.onPrimary,
            borderColor: themeData.primaryColor,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: CommonButton(
            onPressed: () {
              if (onSaveAndViewPressed != null) {
                onSaveAndViewPressed!();
                return;
              }
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            text: "Save & View",
            fontColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
