import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation_controller.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:provider/provider.dart';

import 'network_connection_provider.dart';

class NetworkConnectionController {
  static final NetworkConnectionController _instance = NetworkConnectionController._();

  factory NetworkConnectionController() => _instance;

  NetworkConnectionController._();

  final NetworkConnectionProvider networkConnectionProvider = NetworkConnectionProvider();

  Future<void> startNetworkConnectionSubscription() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("NetworkConnectionController().startNetworkConnectionSubscription() called", tag: tag);

    NetworkConnectionProvider provider = networkConnectionProvider;

    await stopNetworkConnectionSubscription(isNotify: false);

    provider.networkConnectedSubscription.set(value: StreamController<bool>.broadcast(), isNotify: false);

    try {
      Completer<ConnectivityResult> completer = Completer<ConnectivityResult>();

      if (kIsWeb) {
        _handleNetworkConnectionChange(result: ConnectivityResult.wifi);
        completer.complete(ConnectivityResult.wifi);
      }

      StreamSubscription<ConnectivityResult> connectionStatusSubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
        _handleNetworkConnectionChange(result: result);

        if (!completer.isCompleted) completer.complete(result);
      });
      provider.connectionStatusSubscription.set(value: connectionStatusSubscription, isNotify: false);

      await completer.future;

      MyPrint.printOnConsole("Connection Subscription Started", tag: tag);
    } catch (e, s) {
      MyPrint.printOnConsole("Error in NetworkConnectionController().startNetworkConnectionSubscription():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }
  }

  void _handleNetworkConnectionChange({required ConnectivityResult result}) {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("NetworkConnectionController()._handleNetworkConnectionChange() called with result:$result", tag: tag);

    NetworkConnectionProvider provider = networkConnectionProvider;

    MyPrint.printOnConsole("Connectivity Result:$result", tag: tag);
    MyPrint.printOnConsole("Previous Result:${provider.currentResult.get()}", tag: tag);

    bool isNetworkConnected = [
      ConnectivityResult.wifi,
      ConnectivityResult.ethernet,
      ConnectivityResult.mobile,
      ConnectivityResult.vpn,
      ConnectivityResult.other,
    ].contains(result);

    ConnectivityResult? currentResult = provider.currentResult.get();
    if (currentResult != result) {
      MyPrint.printOnConsole("Connection Status Changed:$isNetworkConnected", tag: tag);

      if (currentResult != null) {
        BuildContext? context = NavigationController.mainNavigatorKey.currentContext;
        if (context != null && context.mounted) {
          AppProvider appProvider = context.read<AppProvider>();

          if (isNetworkConnected) {
            MyToast.showCustomToast(
              context: context,
              msg: appProvider.localStr.networkConnectionAlertConnectionRestored,
              iconData: Icons.wifi,
            );
          } else {
            MyToast.showCustomToast(
              context: context,
              msg: appProvider.localStr.networkConnectionAlertYouAreOffline,
              iconData: Icons.wifi_off,
            );
          }
        }
      }
      provider.currentResult.set(value: result, isNotify: false);
      provider.isNetworkConnected.set(value: isNetworkConnected, isNotify: true);
      provider.networkConnectedSubscription.get()?.add(isNetworkConnected);
    }

    provider.currentResult.set(value: result, isNotify: false);
  }

  Future<void> stopNetworkConnectionSubscription({bool isNotify = true}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("NetworkConnectionController().stopNetworkConnectionSubscription() called", tag: tag);

    NetworkConnectionProvider provider = networkConnectionProvider;

    MyPrint.printOnConsole("Closing Subscriptions", tag: tag);
    await Future.wait([
      provider.connectionStatusSubscription.get()?.cancel() ?? Future(() {}),
      provider.networkConnectedSubscription.get()?.close() ?? Future(() {}),
    ]);
    MyPrint.printOnConsole("Closed Subscriptions", tag: tag);

    provider.isNetworkConnected.set(value: false, isNotify: false);
    provider.currentResult.set(value: null, isNotify: false);
    provider.connectionStatusSubscription.set(value: null, isNotify: false);
    provider.networkConnectedSubscription.set(value: null, isNotify: isNotify);
  }

  bool checkConnection({bool isShowErrorSnakbar = true, BuildContext? context}) {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("NetworkConnectionController().checkConnection() called with isShowErrorSnakbar:$isShowErrorSnakbar, context:$context", tag: tag);

    NetworkConnectionProvider provider = networkConnectionProvider;

    bool isNetworkConnected = provider.isNetworkConnected.get();
    MyPrint.printOnConsole("isNetworkConnected:$isNetworkConnected", tag: tag);

    if (!isNetworkConnected && isShowErrorSnakbar && context != null) {
      AppProvider appProvider = context.read<AppProvider>();

      MyToast.showCustomToast(
        context: context,
        msg: appProvider.localStr.networkConnectionAlertYouAreOffline,
        iconData: Icons.wifi_off,
      );
    }

    return isNetworkConnected;
  }
}
