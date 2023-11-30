import 'package:flutter/material.dart';

import 'configs/client_urls.dart';
import 'init.dart';
import 'views/app/myapp.dart';

// void main() async {
//   await runErrorSafeApp(
//     () => runApp(
//       MyApp(
//         mainSiteUrl: ClientUrls.qaLearningClientUrl,
//         appAuthURL: ClientUrls.getAuthUrl(ClientUrls.qaLearningClientUrl),
//         splashScreenLogo: "assets/images/playgroundlogo.png",
//       ),
//     ),
//   );
// }

void main() async {
  await runErrorSafeApp(
    () => runApp(
      MyApp(
        mainSiteUrl: ClientUrls.upgradedEnterpriseClientUrl,
        appAuthURL: ClientUrls.getAuthUrl(ClientUrls.upgradedEnterpriseClientUrl),
        splashScreenLogo: ClientUrls.getAppIconImageAssetPathFromSiteUrl(ClientUrls.upgradedEnterpriseClientUrl),
      ),
    ),
  );
}
