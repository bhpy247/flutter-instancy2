import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:provider/provider.dart';

class CourseNotDownloadedDialog extends StatefulWidget {
  const CourseNotDownloadedDialog({
    super.key,
  });

  @override
  State<CourseNotDownloadedDialog> createState() => _CourseNotDownloadedDialogState();
}

class _CourseNotDownloadedDialogState extends State<CourseNotDownloadedDialog> with MySafeState {
  late AppProvider appProvider;

  @override
  void initState() {
    super.initState();

    appProvider = context.read<AppProvider>();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: Text(
              appProvider.localStr.courseNotDownloadedDialogTitle,
              style: themeData.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              getDescriptionWidget(),
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.end,
      actionsOverflowDirection: VerticalDirection.up,
      actions: [
        MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: themeData.primaryColor,
          child: Text(
            appProvider.localStr.eventsAlertbuttonOkbutton,
            style: themeData.textTheme.bodyMedium?.copyWith(
              color: themeData.colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget getDescriptionWidget() {
    return Text(
      appProvider.localStr.courseNotDownloadedDialogDescription,
      style: themeData.textTheme.bodyMedium,
    );
  }
}
