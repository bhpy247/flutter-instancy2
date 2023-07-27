import '../../configs/app_constants.dart';
import '../../utils/shared_pref_manager.dart';

class SharedPreferenceController {
  //region Site Url Configurations
  //region Current Site Url
  static Future<String> getCurrentSiteUrlFromSharedPreference() async {
    String url = (await SharedPrefManager().getString(SharedPreferenceVariables.currentSiteUrl)) ?? "";
    return url;
  }

  static Future<bool> setCurrentSiteUrlInSharedPreference(String url) async {
    bool isSuccess = await SharedPrefManager().setString(SharedPreferenceVariables.currentSiteUrl, url);
    return isSuccess;
  }
  //endregion

  //region Current Site Api Url
  static Future<String> getCurrentSiteApiUrlFromSharedPreference() async {
    String url = (await SharedPrefManager().getString(SharedPreferenceVariables.currentSiteApiUrl)) ?? "";
    return url;
  }

  static Future<bool> setCurrentSiteApiUrlInSharedPreference(String url) async {
    bool isSuccess = await SharedPrefManager().setString(SharedPreferenceVariables.currentSiteApiUrl, url);
    return isSuccess;
  }
  //endregion

  //region Current Site Learner Url
  static Future<String> getCurrentSiteLearnerUrlFromSharedPreference() async {
    String url = (await SharedPrefManager().getString(SharedPreferenceVariables.currentSiteLearnerUrl)) ?? "";
    return url;
  }

  static Future<bool> setCurrentSiteLearnerUrlInSharedPreference(String url) async {
    bool isSuccess = await SharedPrefManager().setString(SharedPreferenceVariables.currentSiteLearnerUrl, url);
    return isSuccess;
  }
  //endregion

  //region Current Site LMS Url
  static Future<String> getCurrentSiteLMSUrlFromSharedPreference() async {
    String url = (await SharedPrefManager().getString(SharedPreferenceVariables.currentSiteLMSUrl)) ?? "";
    return url;
  }

  static Future<bool> setCurrentSiteLMSUrlInSharedPreference(String url) async {
    bool isSuccess = await SharedPrefManager().setString(SharedPreferenceVariables.currentSiteLMSUrl, url);
    return isSuccess;
  }
//endregion
  //endregion
}