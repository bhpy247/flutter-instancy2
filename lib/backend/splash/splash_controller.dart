import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/api/api_url_configuration_provider.dart';
import 'package:flutter_instancy_2/backend/app_theme/app_theme_controller.dart';
import 'package:flutter_instancy_2/backend/app_theme/app_theme_provider.dart';
import 'package:flutter_instancy_2/backend/authentication/authentication_controller.dart';
import 'package:flutter_instancy_2/backend/common/shared_preference_controller.dart';
import 'package:flutter_instancy_2/backend/splash/splash_hive_repository.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/app_ststem_configurations.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/instancy_theme_colors.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/local_str.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/native_menu_component_model.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/native_menu_model.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/site_configuration_model.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/tincan_data_model.dart';
import 'package:flutter_instancy_2/models/common/data_response_model.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../hive/hive_operation_controller.dart';
import '../../models/app_configuration_models/data_models/localization_selection_model.dart';
import '../../models/app_configuration_models/response_model/mobile_api_auth_response_model.dart';
import '../../models/app_configuration_models/response_model/mobile_get_learning_portal_info_response_model.dart';
import '../app/app_provider.dart';
import '../configurations/app_configuration_operations.dart';
import 'splash_repository.dart';

class SplashController {
  final AppProvider appProvider;
  final AppThemeProvider appThemeProvider;
  late SplashRepository splashRepository;
  late SplashHiveRepository splashHiveRepository;

  SplashController({
    required this.appProvider,
    required this.appThemeProvider,
    SplashRepository? repository,
    SplashHiveRepository? hiveRepository,
    ApiController? apiController,
  }) {
    splashRepository = repository ?? SplashRepository(apiController: apiController ?? ApiController());
    splashHiveRepository = hiveRepository ?? SplashHiveRepository(hiveOperationController: HiveOperationController());
  }

  Future<void> getAppData({required AuthenticationController authenticationController}) async {
    String newId = MyUtils.getNewId();
    MyPrint.printOnConsole("SplashController().getAppData() called", tag: newId);
    DateTime startTime = DateTime.now();

    bool isHavingSiteData = false;

    String apiUrl = splashRepository.apiController.apiDataProvider.getCurrentBaseApiUrl();
    String learnerUrl = splashRepository.apiController.apiDataProvider.getCurrentSiteLearnerUrl();
    String lmsUrl = splashRepository.apiController.apiDataProvider.getCurrentSiteLMSUrl();
    // String apiUrl = "";
    MyPrint.printOnConsole("apiUrl:$apiUrl", tag: newId);
    if (apiUrl.isNotEmpty && learnerUrl.isNotEmpty && lmsUrl.isNotEmpty) {
      isHavingSiteData = true;
    } else {
      isHavingSiteData = await getSiteApiUrlConfigurationData();
      MyPrint.printOnConsole("isHavingSiteData:$isHavingSiteData", tag: newId);
    }

    if (isHavingSiteData) {
      DateTime startTime = DateTime.now();
      await Future.wait([
        getLearningPlatformInfoData(),
        getSiteLocalizationStrings(),
        getTinCanConfigurations(),
        getAppMenusList(),
        authenticationController.getSignupFieldsData(),
      ]);
      DateTime endTime = DateTime.now();
      MyPrint.printOnConsole("All Splash Api Calls Finished after ${endTime.difference(startTime).inMilliseconds} milliseconds", tag: newId);
    }

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole("SplashController().getAppData() Finished after ${endTime.difference(startTime).inMilliseconds} milliseconds", tag: newId);
  }

  //region 1) CurrentSiteUrlData Section
  Future<void> getCurrentSiteUrlData() async {
    String uid = MyUtils.getNewId();
    MyPrint.printOnConsole('getCurrentSiteUrlData called', tag: uid);

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = splashRepository.apiController.apiDataProvider;

    String currentSiteUrl = apiUrlConfigurationProvider.getCurrentSiteUrl();
    MyPrint.printOnConsole("currentSiteUrl from apiUrlConfigurationProvider:'$currentSiteUrl'", tag: uid);

    if (currentSiteUrl.isEmpty) {
      currentSiteUrl = await SharedPreferenceController.getCurrentSiteUrlFromSharedPreference();
    }
    MyPrint.printOnConsole("currentSiteUrl from SharedPreference:'$currentSiteUrl'", tag: uid);

    if (currentSiteUrl.isNotEmpty) {
      String apiUrl = await SharedPreferenceController.getCurrentSiteApiUrlFromSharedPreference();
      MyPrint.printOnConsole("apiUrl:'$apiUrl'", tag: uid);
      apiUrlConfigurationProvider.setCurrentBaseApiUrl(apiUrl);

      String learnerUrl = await SharedPreferenceController.getCurrentSiteLearnerUrlFromSharedPreference();
      MyPrint.printOnConsole("learnerUrl:'$learnerUrl'", tag: uid);
      apiUrlConfigurationProvider.setCurrentSiteLearnerUrl(learnerUrl);

      String lmsUrl = await SharedPreferenceController.getCurrentSiteLMSUrlFromSharedPreference();
      MyPrint.printOnConsole("lmsUrl:'$lmsUrl'", tag: uid);
      apiUrlConfigurationProvider.setCurrentSiteLMSUrl(lmsUrl);
    }
    else {
      currentSiteUrl = apiUrlConfigurationProvider.getMainSiteUrl();
    }
    MyPrint.printOnConsole("final currentSiteUrl:'$currentSiteUrl'", tag: uid);

    apiUrlConfigurationProvider.setCurrentSiteUrl(currentSiteUrl);
  }

  //endregion

  //region 2) SiteApiUrlConfigurationData Section
  Future<bool> getSiteApiUrlConfigurationData() async {
    String newId = MyUtils.getNewId();
    MyPrint.printOnConsole("SplashController().getSiteApiUrlConfigurationData called", tag: newId);

    DateTime startTime = DateTime.now();

    DataResponseModel<MobileApiAuthResponseModel> responseModel = await splashRepository.getSiteApiUrlConfigurationData();
    MyPrint.printOnConsole(responseModel, tag: newId);

    bool isHavingSiteData = responseModel.data?.havingRequiredData ?? false;

    if (isHavingSiteData) {
      MobileApiAuthResponseModel siteApiUrlConfigurationModel = responseModel.data!;

      ApiUrlConfigurationProvider apiDataProvider = splashRepository.apiController.apiDataProvider;

      apiDataProvider.setCurrentBaseApiUrl(siteApiUrlConfigurationModel.webApiUrl);
      SharedPreferenceController.setCurrentSiteApiUrlInSharedPreference(siteApiUrlConfigurationModel.webApiUrl);
      SharedPreferenceController.setCurrentSiteLearnerUrlInSharedPreference(siteApiUrlConfigurationModel.learnerUrl);
      SharedPreferenceController.setCurrentSiteLMSUrlInSharedPreference(siteApiUrlConfigurationModel.lmsUrl);

      String currentSiteUrl = "${siteApiUrlConfigurationModel.learnerUrl}${siteApiUrlConfigurationModel.learnerUrl.endsWith("/") ? "" : "/"}";
      apiDataProvider.setCurrentSiteUrl(currentSiteUrl);
      apiDataProvider.setCurrentSiteLearnerUrl(siteApiUrlConfigurationModel.learnerUrl);
      apiDataProvider.setCurrentSiteLMSUrl(siteApiUrlConfigurationModel.lmsUrl);
      SharedPreferenceController.setCurrentSiteUrlInSharedPreference(currentSiteUrl);
    }

    DateTime endTime = DateTime.now();

    MyPrint.printOnConsole("SplashController().getSiteApiUrlConfigurationData Finished", tag: newId);
    MyPrint.printOnConsole("Time For getSiteApiUrlConfigurationData:${endTime.difference(startTime).inMilliseconds} milliseconds", tag: newId);

    return isHavingSiteData;
  }

  //endregion

  //region 3) Get App Configurations Section
  //region 3.1) LearningPlatformInfoData Section
  Future<MobileGetLearningPortalInfoResponseModel?> getLearningPlatformInfoData({
    bool isGetFromOffline = true,
    bool isSaveInOffline = true,
  }) async {
    String newId = MyUtils.getNewId();
    MyPrint.printOnConsole("SplashController().getLearningPlatformInfoData called", tag: newId);

    MobileGetLearningPortalInfoResponseModel? mobileGetLearningPortalInfoResponseModel;

    DateTime startTime = DateTime.now();
    if (isGetFromOffline) {
      DataResponseModel<MobileGetLearningPortalInfoResponseModel> hiveResponseModel = await splashRepository.getLearningPlatformInfoData(
        isFromOffline: true,
        isStoreDataInHive: false,
      );

      mobileGetLearningPortalInfoResponseModel = hiveResponseModel.data;
    }
    MyPrint.printOnConsole("mobileGetLearningPortalInfoResponseModel from hive:$mobileGetLearningPortalInfoResponseModel", tag: newId);
    MyPrint.printOnConsole("mobileGetLearningPortalInfoResponseModel not null:${mobileGetLearningPortalInfoResponseModel != null}", tag: newId);

    if (isGetFromOffline && mobileGetLearningPortalInfoResponseModel != null) {
      getLearningPlatformInfoDataAndStoreInHive(isSaveInOffline: isSaveInOffline);
      await initializeAppConfigurationsFromMobileGetLearningPortalInfoResponseModel(model: mobileGetLearningPortalInfoResponseModel);
    } else {
      mobileGetLearningPortalInfoResponseModel = await getLearningPlatformInfoDataAndStoreInHive(isSaveInOffline: isSaveInOffline);
    }

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole("SplashController().getLearningPlatformInfoData Finished after ${endTime.difference(startTime).inMilliseconds} Milliseconds",
        tag: newId);

    return mobileGetLearningPortalInfoResponseModel;
  }

  Future<MobileGetLearningPortalInfoResponseModel?> getLearningPlatformInfoDataAndStoreInHive({bool isSaveInOffline = true}) async {
    String newId = MyUtils.getNewId();
    MyPrint.printOnConsole("SplashController().getLearningPlatformInfoDataAndStoreInHive called", tag: newId);

    DateTime startTime = DateTime.now();
    DataResponseModel<MobileGetLearningPortalInfoResponseModel> mobileGetLearningPortalInfoResponse = await splashRepository.getLearningPlatformInfoData(
      isFromOffline: false,
      isStoreDataInHive: isSaveInOffline,
    );
    MyPrint.printOnConsole(mobileGetLearningPortalInfoResponse, tag: newId);

    if (mobileGetLearningPortalInfoResponse.data != null) {
      MobileGetLearningPortalInfoResponseModel data = mobileGetLearningPortalInfoResponse.data!;

      await initializeAppConfigurationsFromMobileGetLearningPortalInfoResponseModel(model: data);
    }

    // splashHiveRepository.setLearningPlatformInfoData(model: mobileGetLearningPortalInfoResponse.data);

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole(
        "SplashController().getLearningPlatformInfoDataAndStoreInHive Finished after ${endTime.difference(startTime).inMilliseconds} Milliseconds",
        tag: newId);

    return mobileGetLearningPortalInfoResponse.data;
  }

  Future<void> initializeAppConfigurationsFromMobileGetLearningPortalInfoResponseModel({required MobileGetLearningPortalInfoResponseModel model}) async {
    SiteUrlConfigurationModel? siteUrlConfigurationModel = getSiteUrlConfigurationModelFromLearningPortalInfoResponse(model.table);
    MyPrint.printOnConsole("siteUrlConfigurationModel in SplashController().initializeAppConfigurationsFromMobileGetLearningPortalInfoResponseModel():$siteUrlConfigurationModel");
    if (siteUrlConfigurationModel != null) {
      splashRepository.apiController.apiDataProvider.setCurrentSiteId(siteUrlConfigurationModel.siteId);
      siteUrlConfigurationModel.siteLMSUrl = splashRepository.apiController.apiDataProvider.getCurrentSiteLMSUrl();
      siteUrlConfigurationModel.siteApiUrl = splashRepository.apiController.apiDataProvider.getCurrentBaseApiUrl();
      appProvider.setSiteUrlConfigurationModel(value: siteUrlConfigurationModel, isNotify: false);
    }

    //Initializing App Colors
    InstancyThemeColors colors = getThemeColorsFromLearningPlatformData(model.table1);
    await AppThemeController(
      appThemeProvider: appThemeProvider,
    ).setInstancyThemeColors(instancyThemeColors: colors);

    AppSystemConfigurationModel appSystemConfigurationModel = getAppSystemConfigurationModelFromLearningPortalResponse(
      data: model,
      siteUrlConfigurationModel: siteUrlConfigurationModel,
    );
    appProvider.setAppSystemConfigurationModel(value: appSystemConfigurationModel, isNotify: true);
  }

  SiteUrlConfigurationModel? getSiteUrlConfigurationModelFromLearningPortalInfoResponse(List<Table> list) {
    SiteUrlConfigurationModel? model;

    if (list.isNotEmpty) {
      Table table = list.first;

      model = SiteUrlConfigurationModel();
      model.siteId = table.siteid;
      model.siteName = table.name;
      model.siteLMSUrl = table.siteurl;
    }

    return model;
  }

  InstancyThemeColors getThemeColorsFromLearningPlatformData(List<Table1> list) {
    /*eg.
    {
      "MENU SEPARATOR COLOR" : "#ffffff",
      "SELECTED MENU BACKGROUND" : "#ffffff",
    }

    Getting Bulow Configurations

    "LOGO BACKGROUND",
    "SITE BACKGROUND",
    "HEADER BACKGROUND",
    "MENU BACKGROUND",
    "MENU SEPARATOR COLOR",
    "SELECTED MENU BACKGROUND",
    "BUTTON BACKGROUND",
    "FOOTER BACKGROUND",
    "MENU ALTERNATE COLOR",
    "FOOTER TEXT COLOR",
    "BUTTON TEXT COLOR",
    "SELECTED MENU TEXT COLOR",
    "MENU TEXT COLOR",
    "HEADER TEXT COLOR",
    "SITE TEXT COLOR",

    */
    Map<String, String> colorsMap = <String, String>{};

    for (Table1 table1 in list) {
      String color = table1.bgcolor == "NA" ? table1.textcolor : table1.bgcolor;

      bool isValidColor = AppConfigurationOperations.isValidHexColorString(color);

      if (table1.csseditingpalceholderdisplayname.isNotEmpty && isValidColor) {
        colorsMap[table1.csseditingpalceholderdisplayname] = color;
      }
    }
    MyPrint.printOnConsole("colorsMap:$colorsMap");

    InstancyThemeColors instancyThemeColors = InstancyThemeColors();
    instancyThemeColors.appBGColor = ParsingHelper.parseStringMethod(colorsMap['SITE BACKGROUND']);
    instancyThemeColors.expiredBGColor = "";
    instancyThemeColors.appTextColor = ParsingHelper.parseStringMethod(colorsMap['SITE TEXT COLOR']);
    instancyThemeColors.appLoginBGColor = ParsingHelper.parseStringMethod(colorsMap['SITE BACKGROUND']);
    instancyThemeColors.appLoginTextolor = ParsingHelper.parseStringMethod(colorsMap['SITE TEXT COLOR']);
    instancyThemeColors.appButtonBgColor = ParsingHelper.parseStringMethod(colorsMap['BUTTON BACKGROUND']);
    instancyThemeColors.menuBGColor = ParsingHelper.parseStringMethod(colorsMap['MENU BACKGROUND']);
    instancyThemeColors.menuTextColor = ParsingHelper.parseStringMethod(colorsMap['MENU TEXT COLOR']);
    instancyThemeColors.selectedMenuBGColor = ParsingHelper.parseStringMethod(colorsMap['SELECTED MENU BACKGROUND']);
    instancyThemeColors.selectedMenuTextColor = ParsingHelper.parseStringMethod(colorsMap['SELECTED MENU TEXT COLOR']);
    instancyThemeColors.menuBGSelectTextColor = "";
    instancyThemeColors.appHeaderColor = ParsingHelper.parseStringMethod(colorsMap['HEADER BACKGROUND']);
    instancyThemeColors.menuHeaderBGColor = "";
    instancyThemeColors.appHeaderTextColor = ParsingHelper.parseStringMethod(colorsMap['HEADER TEXT COLOR']);
    instancyThemeColors.menuHeaderTextColor = "";
    instancyThemeColors.menuBGAlternativeColor = "";
    instancyThemeColors.fileUploadButtonColor = "";
    instancyThemeColors.appButtonTextColor = ParsingHelper.parseStringMethod(colorsMap['BUTTON TEXT COLOR']);
    instancyThemeColors.appLogoBackgroundColor = "";

    return instancyThemeColors;
  }

  AppSystemConfigurationModel getAppSystemConfigurationModelFromLearningPortalResponse({
    required MobileGetLearningPortalInfoResponseModel data,
    SiteUrlConfigurationModel? siteUrlConfigurationModel,
  }) {
    AppSystemConfigurationModel appSystemConfigurationModel = AppSystemConfigurationModel();

    //System Configuration
    Map<String, dynamic> systemConfigMap = <String, dynamic>{};
    for (Table2 element in data.table2) {
      systemConfigMap[element.name] = element.keyvalue;
    }
    appSystemConfigurationModel.updateFromMap(systemConfigMap);

    if (siteUrlConfigurationModel != null) {
      appSystemConfigurationModel.initializeAppLogoUrlFromSiteConfiguration(siteUrlConfigurationModel: siteUrlConfigurationModel);
      appSystemConfigurationModel.initializeAppDarkLogoUrlFromSiteConfiguration(siteUrlConfigurationModel: siteUrlConfigurationModel);
    }

    //Social Login
    for (Table4 element in data.table4) {
      MyPrint.printOnConsole('privilegeid${element.privilegeid}');
      if (element.privilegeid == 908) {
        appSystemConfigurationModel.setIsFaceBook(element.ismobileprivilege);
      } else if (element.privilegeid == 911) {
        appSystemConfigurationModel.setIsTwitter(element.ismobileprivilege);
      } else if (element.privilegeid == 909) {
        appSystemConfigurationModel.setIsLinkedIn(element.ismobileprivilege);
      } else if (element.privilegeid == 910) {
        appSystemConfigurationModel.setIsGoogle(element.ismobileprivilege);
      } else if (element.privilegeid == 910) {}
    }

    //App Locale
    List<LocalizationSelectionModel> localeList = [];
    for (Table5 element in data.table5) {
      LocalizationSelectionModel localizationSelectionModel = LocalizationSelectionModel();
      if (element.languagename.isNotEmpty) {
        localizationSelectionModel.languagename = element.languagename;
      }
      if (element.locale.isNotEmpty) {
        localizationSelectionModel.locale = element.locale;
      }
      if (element.description.isNotEmpty) {
        localizationSelectionModel.description = element.description;
      }
      if (element.status) {
        localizationSelectionModel.status = element.status;
      }
      if (element.id != 0) {
        localizationSelectionModel.id = element.id;
      }
      if (element.countryflag.isNotEmpty) {
        localizationSelectionModel.countryflag = element.countryflag;
      }
      if (element.jsonfile.isNotEmpty) {
        localizationSelectionModel.jsonfile = element.jsonfile;
      }
      localeList.add(localizationSelectionModel);
    }
    appSystemConfigurationModel.setLocaleList(localeList);

    return appSystemConfigurationModel;
  }

  //endregion

  //region 3.2) SiteLocalizationStrings Section
  Future<LocalStr?> getSiteLocalizationStrings({bool isGetFromOffline = true, bool isSaveInOffline = true}) async {
    String newId = MyUtils.getNewId();
    MyPrint.printOnConsole("SplashController().getSiteLocalizationStrings called with isGetFromOffline:$isGetFromOffline,"
        " isSaveInOfflineL$isSaveInOffline", tag: newId);

    LocalStr? localStr;

    DateTime startTime = DateTime.now();
    if (isGetFromOffline) {
      DataResponseModel<LocalStr> hiveResponseModel = await splashRepository.getLanguageJsonFile(
        langCode: splashRepository.apiController.apiDataProvider.getLocale(),
        isGetDataFromHive: true,
        isStoreDataInHive: false,
      );

      localStr = hiveResponseModel.data;
    }
    MyPrint.printOnConsole("localStr not null:${localStr != null}", tag: newId);

    if (isGetFromOffline && localStr != null) {
      appProvider.setLocalStr(value: localStr, isNotify: true);
      getSiteLocalizationStringsFromApiAndStoreInHive(isStoreDataInHive: isSaveInOffline);
    } else {
      localStr = await getSiteLocalizationStringsFromApiAndStoreInHive(isStoreDataInHive: isSaveInOffline);
    }

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole("SplashController().getSiteLocalizationStrings Finished after ${endTime.difference(startTime).inMilliseconds} Milliseconds",
        tag: newId);

    return localStr;
  }

  Future<LocalStr?> getSiteLocalizationStringsFromApiAndStoreInHive({bool isStoreDataInHive = true}) async {
    String newId = MyUtils.getNewId();
    MyPrint.printOnConsole("SplashController().getSiteLocalizationStringsFromApiAndStoreInHive called", tag: newId);

    DateTime startTime = DateTime.now();
    DataResponseModel<LocalStr> responseModel = await splashRepository.getLanguageJsonFile(
      langCode: splashRepository.apiController.apiDataProvider.getLocale(),
      isGetDataFromHive: false,
      isStoreDataInHive: isStoreDataInHive,
    );
    MyPrint.printOnConsole(responseModel, tag: newId);

    if (responseModel.data != null) {
      LocalStr data = responseModel.data!;

      appProvider.setLocalStr(value: data, isNotify: true);
    }

    // splashHiveRepository.setLanguageJsonFile(langCode: splashRepository.apiController.apiDataProvider.getLocale(), localStr: responseModel.data);

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole(
        "SplashController().getSiteLocalizationStringsFromApiAndStoreInHive Finished after ${endTime.difference(startTime).inMilliseconds} Milliseconds",
        tag: newId);

    return responseModel.data;
  }

  //endregion

  //region 3.3) TinCanConfigurations Section
  Future<TinCanDataModel?> getTinCanConfigurations({bool isGetFromOffline = true, bool isSaveInOffline = true}) async {
    String newId = MyUtils.getNewId();
    MyPrint.printOnConsole("SplashController().getTinCanConfigurations called", tag: newId);

    TinCanDataModel? tinCanDataModel;

    DateTime startTime = DateTime.now();
    if (isGetFromOffline) {
      DataResponseModel<TinCanDataModel> hiveResponseModel = await splashRepository.getTinCanConfigurations(
        langCode: splashRepository.apiController.apiDataProvider.getLocale(),
        isGetDataFromHive: true,
        isStoreDataInHive: false,
      );

      tinCanDataModel = hiveResponseModel.data;
    }
    MyPrint.printOnConsole("tinCanDataModel not null:${tinCanDataModel != null}", tag: newId);

    if (isGetFromOffline && tinCanDataModel != null) {
      appProvider.setTinCanDataModel(value: tinCanDataModel, isNotify: true);
      getTinCanConfigurationsFromApiAndStoreInHive(isStoreDataInHive: isSaveInOffline);
    } else {
      tinCanDataModel = await getTinCanConfigurationsFromApiAndStoreInHive(isStoreDataInHive: isSaveInOffline);
    }

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole("SplashController().getTinCanConfigurations Finished after ${endTime.difference(startTime).inMilliseconds} Milliseconds",
        tag: newId);

    return tinCanDataModel;
  }

  Future<TinCanDataModel?> getTinCanConfigurationsFromApiAndStoreInHive({bool isStoreDataInHive = true}) async {
    String newId = MyUtils.getNewId();
    MyPrint.printOnConsole("SplashController().getTinCanConfigurationsFromApiAndStoreInHive called", tag: newId);

    DateTime startTime = DateTime.now();
    DataResponseModel<TinCanDataModel> responseModel = await splashRepository.getTinCanConfigurations(
      langCode: splashRepository.apiController.apiDataProvider.getLocale(),
      isGetDataFromHive: false,
      isStoreDataInHive: isStoreDataInHive,
    );
    MyPrint.printOnConsole(responseModel, tag: newId);

    if (responseModel.data != null) {
      TinCanDataModel data = responseModel.data!;

      appProvider.setTinCanDataModel(value: data, isNotify: true);
    }

    // splashHiveRepository.setTinCanConfigurations(langCode: splashRepository.apiController.apiDataProvider.getLocale(), tinCanDataModel: responseModel.data);

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole(
        "SplashController().getTinCanConfigurationsFromApiAndStoreInHive Finished after ${endTime.difference(startTime).inMilliseconds} Milliseconds",
        tag: newId);

    return responseModel.data;
  }

  //endregion

  //region 3.4) Menu Section
  //region Menu Models List
  Future<List<NativeMenuModel>?> getAppMenusList({bool isGetFromOffline = true, bool isSaveInOffline = true}) async {
    String newId = MyUtils.getNewId();
    MyPrint.printOnConsole("SplashController().getAppMenusList called", tag: newId);

    List<NativeMenuModel>? nativeMenuModelsList;

    DateTime startTime = DateTime.now();
    if (isGetFromOffline) {
      DataResponseModel<List<NativeMenuModel>> hiveResponseModel =
          await splashRepository.getNativeMenuModelsList(isGetDataFromHive: true, isStoreDataInHive: false);

      nativeMenuModelsList = hiveResponseModel.data;
    }
    MyPrint.printOnConsole("nativeMenuModelsList not null:${nativeMenuModelsList != null}", tag: newId);

    if (isGetFromOffline && nativeMenuModelsList != null) {
      appProvider.setMenuModelsList(list: nativeMenuModelsList, isNotify: true);
      getAppMenusListFromApiAndStoreInHive(isStoreDataInHive: isSaveInOffline);
    } else {
      nativeMenuModelsList = await getAppMenusListFromApiAndStoreInHive(isStoreDataInHive: isSaveInOffline);
    }

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole("SplashController().getAppMenusList Finished after ${endTime.difference(startTime).inMilliseconds} Milliseconds", tag: newId);

    return nativeMenuModelsList;
  }

  Future<List<NativeMenuModel>?> getAppMenusListFromApiAndStoreInHive({bool isStoreDataInHive = true}) async {
    String newId = MyUtils.getNewId();
    MyPrint.printOnConsole("SplashController().getAppMenusListFromApiAndStoreInHive called", tag: newId);

    DateTime startTime = DateTime.now();
    DataResponseModel<List<NativeMenuModel>> responseModel = await splashRepository.getNativeMenuModelsList(
      isGetDataFromHive: false,
      isStoreDataInHive: isStoreDataInHive,
    );
    MyPrint.printOnConsole(responseModel, tag: newId);

    if (responseModel.data != null) {
      List<NativeMenuModel> data = responseModel.data!;

      appProvider.setMenuModelsList(list: data, isNotify: true);
    }

    // splashHiveRepository.setNativeMenuModelsList(list: responseModel.data);

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole(
        "SplashController().getAppMenusListFromApiAndStoreInHive Finished after ${endTime.difference(startTime).inMilliseconds} Milliseconds",
        tag: newId);

    return responseModel.data;
  }

  //endregion

  //region Menu Components Models List
  Future<List<NativeMenuComponentModel>?> getAppMenuComponentsList(
      {required int menuId, bool isGetFromOnline = true, bool isGetFromOffline = true, bool isSaveInOffline = true}) async {
    String newId = MyUtils.getNewId();
    MyPrint.printOnConsole(
        "SplashController().getAppMenuComponentsList called for menuId:$menuId, isGetFromOnline:$isGetFromOnline, "
        "isGetFromOffline:$isGetFromOffline, isSaveInOffline:$isSaveInOffline",
        tag: newId);

    List<NativeMenuComponentModel>? nativeMenuComponentModelsList;

    DateTime startTime = DateTime.now();
    if (isGetFromOffline) {
      DataResponseModel<List<NativeMenuComponentModel>> hiveResponseModel = await splashRepository.getNativeMenuComponentModelsList(
        menuId: menuId,
        isGetDataFromHive: true,
        isStoreDataInHive: false,
      );

      nativeMenuComponentModelsList = hiveResponseModel.data;
    }
    MyPrint.printOnConsole("nativeMenuComponentModelsList not null:${nativeMenuComponentModelsList != null}", tag: newId);

    if (isGetFromOffline && nativeMenuComponentModelsList != null) {
      appProvider.setMenuComponentModelsListForMenuId(menuId: menuId, list: nativeMenuComponentModelsList, isNotify: true);
      if (isGetFromOnline) getAppMenuComponentsListFromApiAndStoreInHive(menuId: menuId, isStoreDataInHive: isSaveInOffline);
    } else {
      if (isGetFromOnline)
        nativeMenuComponentModelsList = await getAppMenuComponentsListFromApiAndStoreInHive(menuId: menuId, isStoreDataInHive: isSaveInOffline);
    }

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole("SplashController().getAppMenuComponentsList Finished after ${endTime.difference(startTime).inMilliseconds} Milliseconds",
        tag: newId);

    return nativeMenuComponentModelsList;
  }

  Future<List<NativeMenuComponentModel>?> getAppMenuComponentsListFromApiAndStoreInHive({required int menuId, bool isStoreDataInHive = true}) async {
    String newId = MyUtils.getNewId();
    MyPrint.printOnConsole("SplashController().getAppMenuComponentsListFromApiAndStoreInHive called", tag: newId);

    DateTime startTime = DateTime.now();
    DataResponseModel<List<NativeMenuComponentModel>> responseModel = await splashRepository.getNativeMenuComponentModelsList(
      menuId: menuId,
      isGetDataFromHive: false,
      isStoreDataInHive: isStoreDataInHive,
    );
    MyPrint.printOnConsole(responseModel, tag: newId);

    if (responseModel.data != null) {
      List<NativeMenuComponentModel> data = responseModel.data!;

      appProvider.setMenuComponentModelsListForMenuId(menuId: menuId, list: data, isNotify: true);
    }

    // splashHiveRepository.setNativeMenuComponentModelsList(menuId: menuId, list: responseModel.data);

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole(
        "SplashController().getAppMenuComponentsListFromApiAndStoreInHive Finished after ${endTime.difference(startTime).inMilliseconds} Milliseconds",
        tag: newId);

    return responseModel.data;
  }
//endregion
//endregion
//endregion
}