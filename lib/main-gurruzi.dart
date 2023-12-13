import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';

import 'configs/client_urls.dart';
import 'init.dart';
import 'views/app/myapp.dart';

void main() async {
  runErrorSafeApp(
    () => runApp(
      const MyApp(
        mainSiteUrl: ClientUrls.gurruziClientUrl,
        clientUrlType: ClientUrlTypes.PRODUCTION,
      ),
    ),
  );
}
