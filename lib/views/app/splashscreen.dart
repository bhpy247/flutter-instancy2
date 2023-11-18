import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_controller.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/app_theme/app_theme_provider.dart';
import 'package:flutter_instancy_2/backend/authentication/authentication_controller.dart';
import 'package:flutter_instancy_2/backend/authentication/authentication_provider.dart';
import 'package:flutter_instancy_2/backend/splash/splash_controller.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/views/main_screen/screens/main_screen.dart';
import 'package:provider/provider.dart';

import '../../backend/common/main_hive_controller.dart';
import '../../backend/navigation/navigation_controller.dart';
import '../authentication/screens/login_signup_selection_screen.dart';
import '../common/components/common_cached_network_image.dart';
import '../common/components/common_loader.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/SplashScreen";

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late ThemeData themeData;

  bool isFirst = true;

  late AppProvider appProvider;
  late AppThemeProvider appThemeProvider;
  late SplashController splashController;
  late AuthenticationController authenticationController;

  String logoUrl = "assets/images/playgroundlogo.png";

  Future<void> getData() async {
    await splashController.getCurrentSiteUrlData();
    await MainHiveController().initializeAllHiveBoxes(
      currentSiteUrl: splashController.splashRepository.apiController.apiDataProvider.getCurrentSiteUrl(),
    );

    await Future.wait([
      splashController.getAppData(authenticationController: authenticationController),
    ]);

    bool isUserLoggedIn = await authenticationController.isUserLoggedIn();

    await AppController(provider: appProvider).getCurrencyModel(
      isRefresh: true,
      isGetFromCache: true,
      isNotify: true,
    );

    if (isUserLoggedIn) {
      Navigator.pushNamedAndRemoveUntil(NavigationController.mainNavigatorKey.currentContext!, MainScreen.routeName, (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(NavigationController.mainNavigatorKey.currentContext!, LoginSignUpSelectionScreen.routeName, (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    NavigationController.isFirst = false;

    appProvider = Provider.of<AppProvider>(context, listen: false);
    appThemeProvider = Provider.of<AppThemeProvider>(context, listen: false);

    splashController = SplashController(appProvider: appProvider, appThemeProvider: appThemeProvider);

    authenticationController = AuthenticationController(provider: Provider.of<AuthenticationProvider>(context, listen: false));

    getData();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    if (isFirst) {
      isFirst = false;
      MyUtils.hideShowKeyboard();
    }

    return Consumer<AppProvider>(
      builder: (BuildContext context, AppProvider appProvider, Widget? child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  themeData.primaryColor.withOpacity(0.9),
                  themeData.primaryColor.withOpacity(0.4),
                  themeData.primaryColor.withOpacity(0.1),
                ],
              ),
            ),
            child: const CommonLoader(
              size: 50,
              isCenter: true,
            ),
          ),
        );
      },
    );
  }

  Widget getAppLogo({required String logoUrl}) {
    if (logoUrl.isNotEmpty) {
      return CommonCachedNetworkImage(
        imageUrl: logoUrl,
        height: 80,
        width: 250,
        errorIconSize: 60,
        placeholder: (_, __) => const CommonLoader(),
      );
    } else {
      return const CommonLoader(size: 50);
    }
    // return Image.asset(logoUrl,height: 86, width: 276,);
  }
}
