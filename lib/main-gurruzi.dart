import 'package:flutter/material.dart';

import 'configs/client_urls.dart';
import 'init.dart';
import 'views/app/myapp.dart';

void main() async {
  runErrorSafeApp(
    () => runApp(
      MyApp(
        mainSiteUrl: ClientUrls.gurruziClientUrl,
        appAuthURL: ClientUrls.getAuthUrl(ClientUrls.gurruziClientUrl),
        splashScreenLogo: "assets/images/gurruzi_logo_2.png",
      ),
    ),
  );
}
