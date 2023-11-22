import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String cancelActionText;
  final String defaultActionText;

  const PlatformAlertDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.cancelActionText,
    required this.defaultActionText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(kIsWeb || !Platform.isIOS) {
      return AlertDialog(
        // backgroundColor: Colors.white,
        // backgroundColor: Color(int.parse(
        //     "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
        title: Text(
          title,
          // style: TextStyle(color: themeData.onp),
        ),
        content: Text(
          content,
          // style: TextStyle(color: Colors.grey.shade600),
        ),
        actions: _buildActions(context),
      );
    }
    else {
      return CupertinoAlertDialog(
        title: Text(
          title,
        ),
        content: Text(
          content,
        ),
        actions: _buildActions(context),
      );
    }
  }

  List<Widget> _buildActions(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    final actions = <Widget>[];
    if(cancelActionText.isNotEmpty) {
      actions.add(
        getPlatformAlertDialogAction(
          child: Text(
            cancelActionText,
            style: TextStyle(color: themeData.colorScheme.onBackground),
            // style: TextStyle(color: Colors.red),
            // style: TextStyle(color: Colors.grey.shade600),
          ),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      );
    }
    actions.add(
      getPlatformAlertDialogAction(
        child: Text(
          defaultActionText,
          // style: TextStyle(color: Colors.grey.shade600),
          style: TextStyle(color: themeData.colorScheme.onBackground),
        ),
        onPressed: () => Navigator.of(context).pop(true),
      ),
    );
    return actions;
  }

  Widget getPlatformAlertDialogAction({required Widget child, required VoidCallback onPressed,}) {
    if(kIsWeb || !Platform.isIOS) {
      /*return FlatButton(
        child: child,
        onPressed: onPressed,
      );*/
      return ElevatedButton(
        onPressed: onPressed,
        child: child,
      );
    }
    else {
      return CupertinoDialogAction(
        onPressed: onPressed,
        child: child,
      );
    }
  }
}
