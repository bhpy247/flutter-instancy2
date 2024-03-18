import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/app_theme/app_theme_provider.dart';
import 'package:flutter_instancy_2/backend/common/common_provider.dart';
import 'package:flutter_instancy_2/backend/splash/splash_controller.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/native_menu_component_model.dart';

import '../../models/app_configuration_models/data_models/native_menu_model.dart';
import '../../utils/my_print.dart';

class MainScreenProvider extends CommonProvider {
  MainScreenProvider() {
    isChatBotButtonCenterDocked = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    isChatBotButtonEnabled = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    isCourseOfflineTrackingDataSyncing = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
  }

  late CommonProviderPrimitiveParameter<bool> isChatBotButtonCenterDocked;
  late CommonProviderPrimitiveParameter<bool> isChatBotButtonEnabled;
  late CommonProviderPrimitiveParameter<bool> isCourseOfflineTrackingDataSyncing;

  //region Selected Menu Model
  NativeMenuModel? _selectedMenuModel;

  NativeMenuModel? get selectedMenuModel => _selectedMenuModel;

  void setSelectedMenuModel({required NativeMenuModel? value, bool isNotify = true}) {
    _selectedMenuModel = value;
    if (isNotify) notifyListeners();
  }
  //endregion

  //region Get Components Future
  Future<void>? _futureGetMenuComponentData;

  Future<void>? get futureGetMenuComponentData => _futureGetMenuComponentData;

  void setFutureGetMenuComponentData({required Future<void>? future, bool isNotify = true}) {
    _futureGetMenuComponentData = future;
    if(isNotify) notifyListeners();
  }
  //endregion

  //region Menus Api Called Map
  final Map<int, bool> _menusApiCalledMap = <int, bool>{};

  Map<int, bool> get menusApiCalledMap => _menusApiCalledMap;

  void setMenusApiCalledMap({required Map<int, bool> menusMap, bool isClear = true, bool isNotify = true}) {
    if(isClear) _menusApiCalledMap.clear();
    _menusApiCalledMap.addAll(menusMap);
    if(isNotify) notifyListeners();
  }

  bool getMenusApiCalledForMenuId({required int menuId}) {
    return menusApiCalledMap[menuId] ?? false;
  }
  //endregion

  void setSelectedMenu({required NativeMenuModel? menuModel, required AppProvider appProvider, required AppThemeProvider appThemeProvider, bool isNotify = true}) {
    MyPrint.printOnConsole("MainScreenProvider().setSelectedMenu() called with MenuId:${menuModel?.menuid}, isNotify:$isNotify");

    setSelectedMenuModel(value: menuModel, isNotify: false);

    SplashController splashController = SplashController(
      appProvider: appProvider,
      appThemeProvider: appThemeProvider,
    );

    List<NativeMenuComponentModel> components = menuModel != null ? appProvider.getMenuComponentModelsListFromMenuId(menuId: menuModel.menuid) : [];
    MyPrint.printOnConsole("components length:${components.length}");

    setFutureGetMenuComponentData(
      future: menuModel != null && components.isEmpty
          ? splashController.getAppMenuComponentsList(
              menuId: menuModel.menuid,
              isGetFromOnline: !getMenusApiCalledForMenuId(menuId: menuModel.menuid),
              isSaveInOffline: true,
              isGetFromOffline: true,
            )
          : null,
      isNotify: false,
    );
    setMenusApiCalledMap(menusMap: menuModel != null ? {menuModel.menuid : true} : {}, isClear: false, isNotify: isNotify);
  }

  String getAppBarTitle() {
    return selectedMenuModel?.displayname ?? "Instancy";
  }

  void resetData({required AppProvider appProvider, required AppThemeProvider appThemeProvider}) {
    isChatBotButtonCenterDocked.set(value: false, isNotify: false);
    isChatBotButtonEnabled.set(value: false, isNotify: false);
    isCourseOfflineTrackingDataSyncing.set(value: false, isNotify: false);
    setSelectedMenuModel(value: null, isNotify: false);
    setFutureGetMenuComponentData(future: null, isNotify: false);
    setMenusApiCalledMap(menusMap: {}, isClear: true, isNotify: false);
    setMenusApiCalledMap(menusMap: {}, isClear: true, isNotify: false);
    setSelectedMenu(menuModel: null, appProvider: appProvider, appThemeProvider: appThemeProvider, isNotify: true);
  }
}