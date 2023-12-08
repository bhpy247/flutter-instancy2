import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';

import 'configs/client_urls.dart';
import 'init.dart';
import 'views/app/myapp.dart';

void main() async {
  runErrorSafeApp(
    () => runApp(
      MyApp(
        mainSiteUrl: ClientUrls.nestleClientUrl,
        appAuthURL: ClientUrls.getAuthUrl(ClientUrlTypes.PRODUCTION),
        splashScreenLogo: "assets/app-logo/nestle-logo.png",
        clientUrlType: ClientUrlTypes.PRODUCTION,
      ),
    ),
  );
}
