class HiveKeys {
  static const String appConfigurationBox = "appConfigurationBox";
  static const String myCourseDownloadModelsBox = "myCourseDownloadModelsBox";
  static const String myCourseDownloadIdsBox = "myCourseDownloadIdsBox";

  static const String mobileGetLearningPortalInfoResponseModelHiveKey = "mobileGetLearningPortalInfoResponseModelHiveKey";

  static String getMobileGetLearningPortalInfoResponseModelHiveKey() {
    return mobileGetLearningPortalInfoResponseModelHiveKey;
  }

  static const String languageJsonFileHiveKey = "languageJsonFileHiveKey";

  static String getLanguageJsonFileHiveKey({required String langCode}) {
    return "${languageJsonFileHiveKey}_$langCode";
  }

  static const String tinCanConfigurationsHiveKey  = "tinCanConfigurationsHiveKey";
  static String getTinCanConfigurationsHiveKey({required String langCode}) {
    return "${tinCanConfigurationsHiveKey}_$langCode";
  }

  static const String menusListHiveKey  = "menusListHiveKey";
  static String getMenusListHiveKey() {
    return menusListHiveKey;
  }

  static const String menuComponentsListHiveKey  = "menuComponentsListHiveKey";
  static String getMenuComponentsListHiveKey({required int menuId}) {
    return "${menuComponentsListHiveKey}_$menuId";
  }

  static const String successfulUserLoginModelHiveKey  = "successfulUserLoginModelHiveKey";
  static String getSuccessfulUserLoginModelHiveKey() {
    return successfulUserLoginModelHiveKey;
  }
}