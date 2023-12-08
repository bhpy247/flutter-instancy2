import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';

import 'configs/client_urls.dart';
import 'init.dart';
import 'views/app/myapp.dart';

void main() async {
  await runErrorSafeApp(
    () => runApp(
      MyApp(
        mainSiteUrl: ClientUrls.qaLearningClientUrl,
        appAuthURL: ClientUrls.getAuthUrl(ClientUrlTypes.QA),
        splashScreenLogo: "assets/images/playgroundlogo.png",
        clientUrlType: ClientUrlTypes.QA,
      ),
    ),
  );
}
