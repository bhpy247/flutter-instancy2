import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_instancy_2/backend/common/common_provider.dart';

class NetworkConnectionProvider extends CommonProvider {
  NetworkConnectionProvider() {
    isNetworkConnected = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    currentResult = CommonProviderPrimitiveParameter<ConnectivityResult?>(
      value: null,
      notify: notify,
    );
    connectionStatusSubscription = CommonProviderPrimitiveParameter<StreamSubscription<ConnectivityResult>?>(
      value: null,
      notify: notify,
    );
    networkConnectedSubscription = CommonProviderPrimitiveParameter<StreamController<bool>?>(
      value: null,
      notify: notify,
    );
  }

  late CommonProviderPrimitiveParameter<bool> isNetworkConnected;
  late CommonProviderPrimitiveParameter<ConnectivityResult?> currentResult;
  late CommonProviderPrimitiveParameter<StreamSubscription<ConnectivityResult>?> connectionStatusSubscription;
  late CommonProviderPrimitiveParameter<StreamController<bool>?> networkConnectedSubscription;

  @override
  void dispose() {
    super.dispose();
    connectionStatusSubscription.get()?.cancel();
    networkConnectedSubscription.get()?.close();
  }
}
