import 'package:hive/hive.dart';

import '../../configs/hive_keys.dart';
import '../../utils/hive_manager.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';

class MainHiveController {
  static final MainHiveController _instance = MainHiveController._();

  factory MainHiveController() => _instance;

  MainHiveController._();

  Box? _currentSiteBox, _appConfigurationBox, _myCourseDownloadModelsBox, _myCourseDownloadIdsBox;

  Future<void> initializeAllHiveBoxes({String currentSiteUrl = ""}) async {
    MyPrint.printOnConsole("MainHiveController.initializeAllHiveBoxes called");
    bool isHiveInitialized = await HiveManager().initializeHiveDatabase();
    if (isHiveInitialized) {
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

      if (host.isNotEmpty) {
        _currentSiteBox = await HiveManager().openBox(boxName: host);
      }
    }

    return _currentSiteBox;
  }

  Future<void> clearCurrentSiteBox() async {
    MyPrint.printOnConsole("MainHiveController().clearCurrentSiteBox() called");

    await _currentSiteBox?.clear();
  }

  Future<Box?> initializeAppConfigurationBox() async {
    _appConfigurationBox ??= await HiveManager().openBox(boxName: HiveKeys.appConfigurationBox);
    return _appConfigurationBox;
  }

  Future<Box?> initializeMyCourseDownloadModelsBox({required String currentSiteUrl, required int userId, bool isForceInitialize = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MainHiveController().initializeMyCourseDownloadsBox() called with currentSiteUrl:'$currentSiteUrl', userId:$userId, isForceInitialize:$isForceInitialize", tag: tag);

    String host = MyUtils.getHostNameFromSiteUrl(currentSiteUrl);
    MyPrint.printOnConsole("host:$host", tag: tag);

    if (isForceInitialize || _myCourseDownloadModelsBox == null) {
      await closeMyCourseDownloadModelsBox();
      if (host.isNotEmpty && userId > 0) {
        String boxName = "${HiveKeys.myCourseDownloadModelsBox}_${host}_$userId";
        _myCourseDownloadModelsBox ??= await HiveManager().openBox(boxName: boxName);
      }
    }

    MyPrint.printOnConsole("BoxName:${_myCourseDownloadModelsBox?.name}", tag: tag);

    return _myCourseDownloadModelsBox;
  }

  Future<void> clearMyCourseDownloadModelsBox() async {
    MyPrint.printOnConsole("MainHiveController().clearMyCourseDownloadsBox() called");

    await _myCourseDownloadModelsBox?.clear();
  }

  Future<void> closeMyCourseDownloadModelsBox() async {
    MyPrint.printOnConsole("MainHiveController().closeMyCourseDownloadsBox() called");

    await _myCourseDownloadModelsBox?.close();
    _myCourseDownloadModelsBox = null;
  }

  Future<Box?> initializeMyCourseDownloadIdsBox({required String currentSiteUrl, required int userId, bool isForceInitialize = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MainHiveController().initializeMyCourseDownloadIdsBox() called with currentSiteUrl:'$currentSiteUrl', userId:$userId, isForceInitialize:$isForceInitialize", tag: tag);

    String host = MyUtils.getHostNameFromSiteUrl(currentSiteUrl);
    MyPrint.printOnConsole("host:$host", tag: tag);

    if (isForceInitialize || _myCourseDownloadIdsBox == null) {
      await closeMyCourseDownloadModelsBox();
      if (host.isNotEmpty && userId > 0) {
        String boxName = "${HiveKeys.myCourseDownloadIdsBox}_${host}_$userId";
        _myCourseDownloadIdsBox ??= await HiveManager().openBox(boxName: boxName);
      }
    }

    MyPrint.printOnConsole("BoxName:${_myCourseDownloadIdsBox?.name}", tag: tag);

    return _myCourseDownloadIdsBox;
  }

  Future<void> clearMyCourseDownloadIdsBox() async {
    MyPrint.printOnConsole("MainHiveController().clearMyCourseDownloadIdsBox() called");

    await _myCourseDownloadIdsBox?.clear();
  }

  Future<void> closeMyCourseDownloadIdsBox() async {
    MyPrint.printOnConsole("MainHiveController().closeMyCourseDownloadIdsBox() called");

    await _myCourseDownloadIdsBox?.close();
    _myCourseDownloadIdsBox = null;
  }
}