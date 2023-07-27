import '../utils/my_print.dart';

class ClientUrls {
  //Staging Sites
  static const String elearningStagingClientUrl = "https://elearning.instancy.net/";
  static const String enterpriseDemoStagingClientUrl = "https://enterprisedemo.instancy.net/";

  //QA Sites
  static const String qaLearningClientUrl = "https://qalearning.instancy.com/";

  //Production Sites
  static const String elearningProductionClientUrl = "https://elearning.instancy.com/";
  static const String enterpriseDemoClientUrl = "https://enterprisedemo.instancy.com/";
  static const String franklinClientUrl = "https://tfr.franklincoveysa.co.za/";
  static const String instancyLearningClientUrl = "https://learning.instancy.com/";
  static const String upgradedEnterpriseClientUrl = "https://upgradedenterprise.instancy.com/";
  static const String gurruziClientUrl = "https://www.gurruzi.com/";

  //App Auth Urls
  static const String STAGING_APP_AUTH_URL = "https://masterapi.instancy.net/api/";
  static const String QA_APP_AUTH_URL = "https://newazureplatform.instancy.com/api/";
  static const String LIVE_APP_AUTH_URL = "https://masterapilive.instancy.com/api/";

  static const Map<String, String> siteAuthUrlMap = <String, String>{
    elearningStagingClientUrl: STAGING_APP_AUTH_URL,
    enterpriseDemoStagingClientUrl: STAGING_APP_AUTH_URL,

    qaLearningClientUrl: QA_APP_AUTH_URL,

    elearningProductionClientUrl: LIVE_APP_AUTH_URL,
    enterpriseDemoClientUrl: LIVE_APP_AUTH_URL,
    franklinClientUrl: LIVE_APP_AUTH_URL,
    instancyLearningClientUrl: LIVE_APP_AUTH_URL,
    upgradedEnterpriseClientUrl: LIVE_APP_AUTH_URL,
    gurruziClientUrl: LIVE_APP_AUTH_URL,
  };

  static String getAuthUrl(String clientUrl) {
    String authUrl = siteAuthUrlMap[clientUrl] ?? "";

    return authUrl;
  }

  static String getAppIconImageAssetPathFromSiteUrl(String siteUrl) {
    List<String> enterpriseSiteList = [
      enterpriseDemoStagingClientUrl,
      enterpriseDemoClientUrl,
      upgradedEnterpriseClientUrl,
    ];

    if(enterpriseSiteList.contains(siteUrl)) {
      return "assets/images/playgroundlogo.png";
    }
    else {
      return "assets/images/marketplacelogo.png";
    }
  }

  static String getChatBotTokenApiUrl(String siteUrl) {
    siteUrl = siteUrl.replaceFirst("http://", "https://");
    MyPrint.printOnConsole("siteUrl:$siteUrl");

    if(siteUrl == enterpriseDemoClientUrl) {
      return "https://inst-chatbot-webapp-dev.azurewebsites.net/api/DLToken";
    } else if(siteUrl == qaLearningClientUrl) {
      return "https://instancywebappbot.azurewebsites.net/api/DLToken";
    }
    else {
      return "";
    }
  }
}
