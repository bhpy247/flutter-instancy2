import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/firebase_options.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'utils/my_utils.dart';

/// Runs the app in [runZonedGuarded] to handle all types of errors, including [FlutterError]s.
/// Any error that is caught will be send to Sentry backend
Future<void>? runErrorSafeApp(VoidCallback appRunner) {
  return runZonedGuarded<Future<void>>(
    () async {
      usePathUrlStrategy();

      WidgetsFlutterBinding.ensureInitialized();

      await initApp();
      appRunner();
    },
    (e, s) {
      MyPrint.printOnConsole("Error in runZonedGuarded:$e");
      MyPrint.printOnConsole(s);
    },
  );
}

/// It provides initial initialisation the app and its global services
Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  List<Future> futures = [];

  if (kIsWeb) {
    FirebaseOptions options = DefaultFirebaseOptions.web;
    MyPrint.printOnConsole(options);

    futures.addAll([
      Firebase.initializeApp(
        options: options,
      ),
      /*SystemChrome.setPreferredOrientations(<DeviceOrientation>[
        DeviceOrientation.landscapeLeft,
      ]),*/
    ]);
  }
  else {
    if(Platform.isAndroid || Platform.isIOS) {
      MyUtils.initializeHttpOverrides();

      MyPrint.printOnConsole("Adding Firebase.initializeApp()");
      futures.addAll([
        Firebase.initializeApp(),
        /*SystemChrome.setPreferredOrientations(<DeviceOrientation>[
          DeviceOrientation.portraitUp,
        ]),*/
      ]);
    }
  }

  await Future.wait(futures);

  MyPrint.printOnConsole("Finished Firebase.initializeApp()");

  if(!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    await Future.wait([
      FirebaseMessaging.instance.requestPermission(),
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      ),
    ]);
  }
}
