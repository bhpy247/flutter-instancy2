import 'package:hive/hive.dart';

import '../../configs/hive_keys.dart';
import '../../utils/hive_manager.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';

class MainHiveController {
  static final MainHiveController _instance = MainHiveController._();
  factory MainHiveController() => _instance;
  MainHiveController._();

  Box? _currentSiteBox, _appConfigurationBox;

  Future<void> initializeAllHiveBoxes({String currentSiteUrl = ""}) async {
    MyPrint.printOnConsole("MainHiveController.initializeAllHiveBoxes called");
    bool isHiveInitialized = await HiveManager().initializeHiveDatabase();
    if(isHiveInitialized) {
      await Future.wait([
        HiveManager().initializeDefaultBox(),
        initializeCurrentSiteBox(currentSiteUrl: currentSiteUrl, isForceInitialize: true),
        initializeAppConfigurationBox(),
      ]);
    }
  }

  Future<Box?> initializeCurrentSiteBox({String currentSiteUrl = "", bool isForceInitialize = false}) async {
    MyPrint.printOnConsole("initializeCurrentSiteBox called with currentSiteUrl:'$currentSiteUrl' and isForceInitialize:'$isForceInitialize'");

    if((isForceInitialize || _currentSiteBox == null) && currentSiteUrl.isNotEmpty) {
      String host = MyUtils.getHostNameFromSiteUrl(currentSiteUrl);
      MyPrint.printOnConsole("host:$host");

      if(host.isNotEmpty) {
        _currentSiteBox = await HiveManager().openBox(boxName: host);
      }
    }

    return _currentSiteBox;
  }

  Future<Box?> initializeAppConfigurationBox() async {
    _appConfigurationBox ??= await HiveManager().openBox(boxName: HiveKeys.appConfigurationBox);
    return _appConfigurationBox;
  }
}