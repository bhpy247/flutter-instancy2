import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../backend/app_theme/style.dart';

class AppUIComponents {
  static Future<dynamic> showMyPlatformDialog({
    required BuildContext context,
    required Widget dialog,
    bool barrierDismissible = true,
  }) {
    if(kIsWeb || !Platform.isIOS) {
      return showDialog(context: context, builder: (_) => dialog, barrierDismissible: barrierDismissible);
    }
    else {
      return showCupertinoDialog(context: context, builder: (_) => dialog, barrierDismissible: barrierDismissible);
    }
  }
  //region roundedBackgroundBorder
  static Widget getBackGroundBordersRounded({Widget? child, required BuildContext context}){
    return Scaffold(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      // backgroundColor: themeData.primaryColor,
      body: Container(
        // width: double.infinity,
        // height: MediaQuery.of(NavigationController.mainNavigatorKey.currentContext!).size.height,
        decoration: const BoxDecoration(
          color: Styles.backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            child: child),
      ),
    );
  }
//endregion
}