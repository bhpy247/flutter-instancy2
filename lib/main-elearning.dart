import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';

import 'configs/client_urls.dart';
import 'init.dart';
import 'views/app/myapp.dart';

void main() async {
  await runErrorSafeApp(
    () => runApp(
      MyApp(
        mainSiteUrl: ClientUrls.elearningStagingClientUrl,
        appAuthURL: ClientUrls.getAuthUrl(ClientUrlTypes.STAGING),
        splashScreenLogo: ClientUrls.getAppIconImageAssetPathFromSiteUrl(ClientUrls.elearningStagingClientUrl),
        clientUrlType: ClientUrlTypes.STAGING,
      ),
    ),
  );
}
