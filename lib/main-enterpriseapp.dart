import 'package:flutter/material.dart';

import 'configs/client_urls.dart';
import 'init.dart';
import 'views/app/myapp.dart';

void main() async {
  await runErrorSafeApp(
        () => runApp(
      MyApp(
        mainSiteUrl: ClientUrls.enterpriseDemoClientUrl,
        appAuthURL: ClientUrls.getAuthUrl(ClientUrls.enterpriseDemoClientUrl),
        splashScreenLogo: "assets/images/playgroundlogo.png",
      ),
    ),
  );
}
