import 'package:flutter/material.dart';

import 'configs/client_urls.dart';
import 'init.dart';
import 'views/app/myapp.dart';

void main() async {
  runErrorSafeApp(
    () => runApp(
      MyApp(
        mainSiteUrl: ClientUrls.nestleClientUrl,
        appAuthURL: ClientUrls.getAuthUrl(ClientUrls.nestleClientUrl),
        splashScreenLogo: "assets/app-logo/nestle-logo.png",
      ),
    ),
  );
}
