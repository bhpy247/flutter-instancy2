import 'package:flutter_instancy_2/backend/common/common_provider.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/currency_model.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/native_menu_component_model.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/native_menu_model.dart';

import '../../models/app_configuration_models/data_models/app_ststem_configurations.dart';
import '../../models/app_configuration_models/data_models/local_str.dart';
import '../../models/app_configuration_models/data_models/site_configuration_model.dart';
import '../../models/app_configuration_models/data_models/tincan_data_model.dart';

class AppProvider extends CommonProvider {
  AppProvider() {
    currencyModel = CommonProviderPrimitiveParameter<CurrencyModel?>(
      value: null,
      notify: notify,
    );
    loginScreenBackgroundImage = CommonProviderPrimitiveParameter<String>(
      value: "",
      notify: notify,
    );
    loginScreenImages = CommonProviderListParameter<String>(
      list: <String>[],
      notify: notify,
    );
  }

  late CommonProviderPrimitiveParameter<CurrencyModel?> currencyModel;
  late CommonProviderPrimitiveParameter<String> loginScreenBackgroundImage;
  late CommonProviderListParameter<String> loginScreenImages;

  //region Site Url Configuration Model
  SiteUrlConfigurationModel _siteConfigurations = SiteUrlConfigurationModel();

  SiteUrlConfigurationModel get siteConfigurations => _siteConfigurations;

  void setSiteUrlConfigurationModel({required SiteUrlConfigurationModel value, bool isNotify = true}) {
    _siteConfigurations = value;
    if (isNotify) notifyListeners();
  }
  //endregion

  //region App System Configuration Model
  AppSystemConfigurationModel _appSystemConfigurationModel = AppSystemConfigurationModel();

  AppSystemConfigurationModel get appSystemConfigurationModel => _appSystemConfigurationModel;

  void setAppSystemConfigurationModel({required AppSystemConfigurationModel value, bool isNotify = true}) {
    _appSystemConfigurationModel = value;
    if(isNotify) notifyListeners();
  }
  //endregion

  //region LocalStr
  LocalStr _localStr = LocalStr();

  LocalStr get localStr => _localStr;

  void setLocalStr({required LocalStr value, bool isNotify = true}) {
    _localStr = value;
    if(isNotify) notifyListeners();
  }
  //endregion

  //region TinCanDataModel
  TinCanDataModel _tinCanDataModel = TinCanDataModel();

  TinCanDataModel get tinCanDataModel => _tinCanDataModel;

  void setTinCanDataModel({required TinCanDataModel value, bool isNotify = true}) {
    _tinCanDataModel = value;
    if(isNotify) notifyListeners();
  }
  //endregion

  //region Menus Model Data
  //region Menus Map
  final Map<int, NativeMenuModel> _menusMap = <int, NativeMenuModel>{};

  Map<int, NativeMenuModel> get menusMap => _menusMap;

  void setMenusMap({required Map<int, NativeMenuModel> menusMap, bool isClear = true, bool isNotify = true}) {
    if(isClear) _menusMap.clear();
    _menusMap.addAll(menusMap);
    if(isNotify) notifyListeners();
  }

  NativeMenuModel? getMenuModelFromMenuId({required int menuId}) {
    return menusMap[menuId];
  }
  //endregion

  //region Menus List
  final List<int> _menuIdsList = <int>[];

  List<int> get menuIdsList => _menuIdsList;

  void setMenuIdsList({required List<int> menusList, bool isClear = true, bool isNotify = true}) {
    if(isClear) _menuIdsList.clear();
    _menuIdsList.addAll(menusList);
    if(isNotify) notifyListeners();
  }
  //endregion

  List<NativeMenuModel> getMenuModelsList() {
    Map<int, NativeMenuModel> map = menusMap;
    List<int> list = menuIdsList;

    List<NativeMenuModel> menuModelsList = <NativeMenuModel>[];
    for (int menuId in list) {
      NativeMenuModel? model = map[menuId];
      if(model != null) {
        menuModelsList.add(model);
      }
    }

    return menuModelsList;
  }

  void setMenuModelsList({required List<NativeMenuModel> list, bool isClear = true, bool isNotify = true,}) {
    if(isClear) {
      setMenusMap(menusMap: {}, isNotify: false);
      setMenuIdsList(menusList: [], isNotify: false);
    }

    Map<int, NativeMenuModel> menuModelsMap = <int, NativeMenuModel>{};
    List<int> menuIdsList = <int>[];

    for (NativeMenuModel model in list) {
      menuModelsMap[model.menuid] = model;
      menuIdsList.add(model.menuid);
    }
    // menuIdsList = menuIdsList.toSet().toList();

    setMenusMap(menusMap: menuModelsMap, isClear: isClear, isNotify: false);
    setMenuIdsList(menusList: menuIdsList, isClear: isClear, isNotify: isNotify);
  }
  //endregion

  //region Menu Components Model Data
  //region Menu Components Map
  final Map<int, NativeMenuComponentModel> _menuComponentsMap = <int, NativeMenuComponentModel>{};

  Map<int, NativeMenuComponentModel> get menuComponentsMap => _menuComponentsMap;

  void setMenuComponentsMap({required Map<int, NativeMenuComponentModel> menuComponentsMap, bool isClear = true, bool isNotify = true}) {
    if(isClear) _menuComponentsMap.clear();
    _menuComponentsMap.addAll(menuComponentsMap);
    if(isNotify) notifyListeners();
  }

  NativeMenuComponentModel? getMenuComponentModelFromComponentId({required int componentId}) {
    return menuComponentsMap[componentId];
  }
  //endregion

  //region Menu Components List MenuWise Data
  final Map<int, List<int>> _menuComponentsListMenuWiseMap = <int, List<int>>{};

  Map<int, List<int>> get menuComponentsListMenuWiseMap => _menuComponentsListMenuWiseMap;

  void setMenuComponentsListMenuWiseMap({required Map<int, List<int>> menuComponentsListMenuWiseMap, bool isClear = true, bool isNotify = true}) {
    if(isClear) _menuComponentsListMenuWiseMap.clear();
    _menuComponentsListMenuWiseMap.addAll(menuComponentsListMenuWiseMap);
    if(isNotify) notifyListeners();
  }
  //endregion

  //If List Passed null, it will get all the items in the map, else will get only passed items
  List<NativeMenuComponentModel> getMenuComponentModelsList({List<int>? componentIds}) {
    Map<int, NativeMenuComponentModel> map = menuComponentsMap;
    List<int> list = componentIds ?? menuComponentsMap.keys.toList();

    List<NativeMenuComponentModel> menuComponentModelsList = <NativeMenuComponentModel>[];
    for (int componentId in list) {
      NativeMenuComponentModel? model = map[componentId];
      if(model != null) {
        menuComponentModelsList.add(model);
      }
    }

    return menuComponentModelsList;
  }

  void setMenuComponentModelsList({required List<NativeMenuComponentModel> list, bool isClear = true, bool isNotify = true,}) {
    Map<int, NativeMenuComponentModel> menuComponentModelsMap = <int, NativeMenuComponentModel>{};

    for (NativeMenuComponentModel model in list) {
      menuComponentModelsMap[model.componentid] = model;
    }

    setMenuComponentsMap(menuComponentsMap: menuComponentModelsMap, isClear: isClear, isNotify: false);
  }

  List<int> getMenuComponentIdsListFromMenuId({required int menuId}) {
    return menuComponentsListMenuWiseMap[menuId] ?? <int>[];
  }

  List<NativeMenuComponentModel> getMenuComponentModelsListFromMenuId({required int menuId}) {
    List<int> componentIds = getMenuComponentIdsListFromMenuId(menuId: menuId);
    List<NativeMenuComponentModel> modelsList = getMenuComponentModelsList(componentIds: componentIds);

    return modelsList;
  }

  void setMenuComponentModelsListForMenuId({required int menuId, required List<NativeMenuComponentModel>? list, bool isNotify = true}) {
    if (list != null) {
      setMenuComponentsListMenuWiseMap(menuComponentsListMenuWiseMap: {menuId: list.map((e) => e.componentid).toList()}, isClear: false, isNotify: false);
      setMenuComponentModelsList(list: list, isClear: false, isNotify: false);
    } else {
      _menuComponentsListMenuWiseMap.remove(menuId);
    }
    if (isNotify) notifyListeners();
  }

  //endregion

  void resetData() {
    currencyModel.set(value: null, isNotify: false);
    loginScreenBackgroundImage.set(value: "", isNotify: false);
    loginScreenImages.setList(list: [], isClear: true, isNotify: false);
  }
}