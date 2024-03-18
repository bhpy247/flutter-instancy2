import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_controller.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation_controller.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/shared_pref_manager.dart';
import 'package:share_plus/share_plus.dart';

String _logData = "";
bool? _isRecordLog;

class MyPrint {

  static void printOnConsole(Object s, {String? tag}) {
    String logMessage = "${(tag?.isNotEmpty ?? false) ? "$tag " : ""}${s.toString()}";
    appendLogData(logMessage: logMessage);
    print(logMessage);
  }

  static void logOnConsole(Object s, {String? tag}) {
    String logMessage = "${(tag?.isNotEmpty ?? false) ? "$tag " : ""}${s.toString()}";
    appendLogData(logMessage: logMessage);
    developer.log(logMessage);
  }

  static void appendLogData({required String logMessage}) {
    if (_isRecordLog ?? false) _logData += "\n$logMessage";
  }

  static bool? get isRecordLog => _isRecordLog;

  static void setIsRecordLog(bool isRecord) => _isRecordLog = isRecord;

  static String getLog() {
    String log = _logData;
    developer.log("log length:${log.length}");

    _logData = "";

    return log;
  }

  static Future<void> exportLog() async {
    if (kIsWeb || !(_isRecordLog ?? true)) return;

    String log = getLog();

    if (log.isEmpty) return;

    String tag = MyUtils.getNewId();
    printOnConsole("MyPrint.exportLog() called", tag: tag);

    String downloadResPath = await AppController.getDocumentsDirectory();
    String fileName = "${DateTime.now().toIso8601String()}.txt";
    String filePath = "$downloadResPath${AppController.getPathSeparator()}$fileName";

    if (defaultTargetPlatform == TargetPlatform.android) {
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {}

    MyPrint.printOnConsole("downloadResPath:$downloadResPath", tag: tag);
    MyPrint.printOnConsole("fileName:$fileName", tag: tag);

    try {
      File file = File(filePath);

      MyPrint.printOnConsole("Creating Log File", tag: tag);
      await file.create();
      MyPrint.printOnConsole("Log File Created", tag: tag);

      MyPrint.printOnConsole("Writing in Log File", tag: tag);
      await file.writeAsString(log);
      MyPrint.printOnConsole("Log File Written", tag: tag);

      // OpenFile.open(filePath);
      Share.shareXFiles([XFile(filePath)]);
    } catch (e, s) {
      MyPrint.printOnConsole("Error in MyPrint.exportLog():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    getLog();
  }

  static Future<void> initializeRecordVlog() async {
    String tag = MyUtils.getNewId();
    print("$tag:MyPrint.initializeRecordVlog() called");

    String key = "_isRecordLog";
    bool? value = await SharedPrefManager().getBool(key);
    print("$tag:isRecordLog from SharedPreference:$value");

    if (value == null) {
      value = false;
      SharedPrefManager().setBool(key, value);
    }
    print("$tag:final isRecordLog:$value");

    _isRecordLog = value;
  }

  static void toggleRecordLog({bool? isRecord}) {
    _isRecordLog = isRecord ?? !(_isRecordLog ?? true);

    String key = "_isRecordLog";
    SharedPrefManager().setBool(key, _isRecordLog!);

    BuildContext? context = NavigationController.mainNavigatorKey.currentContext;
    if (context != null) MyToast.showSuccess(context: context, msg: _isRecordLog! ? "Log Recording On" : "Log Recording Off");
  }
}
