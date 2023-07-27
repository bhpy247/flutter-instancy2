import 'package:flutter/material.dart';

import 'configs/client_urls.dart';
import 'init.dart';
import 'views/app/myapp.dart';

void main() async {
  await runErrorSafeApp(
    () => runApp(
      MyApp(
        mainSiteUrl: ClientUrls.elearningStagingClientUrl,
        appAuthURL: ClientUrls.getAuthUrl(ClientUrls.elearningStagingClientUrl),
        splashScreenLogo: ClientUrls.getAppIconImageAssetPathFromSiteUrl(ClientUrls.elearningStagingClientUrl),
      ),
    ),
  );
}
