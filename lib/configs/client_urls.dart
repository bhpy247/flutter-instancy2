import 'package:flutter_instancy_2/configs/app_constants.dart';

class ClientUrls {
  //Staging Sites
  static const String elearningStagingClientUrl = "https://elearning.instancy.net/";
  static const String enterpriseDemoStagingClientUrl = "https://enterprisedemo.instancy.net/";

  //QA Sites
  static const String qaLearningClientUrl = "https://qalearning.instancy.com/";
  static const String shieldBaseClientUrl = "https://shieldbase.instancy.com/";

  //Production Sites
  static const String elearningProductionClientUrl = "https://elearning.instancy.com/";
  static const String enterpriseDemoClientUrl = "https://enterprisedemo.instancy.com/";
  static const String franklinClientUrl = "https://tfr.franklincoveysa.co.za/";
  static const String instancyLearningClientUrl = "https://learning.instancy.com/";
  static const String upgradedEnterpriseClientUrl = "https://upgradedenterprise.instancy.com/";
  static const String gurruziClientUrl = "https://www.gurruzi.com/";
  static const String nestleClientUrl = "https://nestle.instancy.com/";

  //App Auth Urls
  static const String STAGING_APP_AUTH_URL = "https://masterapi.instancy.net/api/";
  static const String QA_APP_AUTH_URL = "https://newazureplatform.instancy.com/api/";
  static const String LIVE_APP_AUTH_URL = "https://masterapilive.instancy.com/api/";

  static const Map<int, String> siteAuthUrlMap = <int, String>{
    ClientUrlTypes.STAGING: STAGING_APP_AUTH_URL,
    ClientUrlTypes.QA: QA_APP_AUTH_URL,
    ClientUrlTypes.PRODUCTION: LIVE_APP_AUTH_URL,
  };

  static const Map<int, String> chatBotTokenApiUrlMap = <int, String>{
    ClientUrlTypes.STAGING: "",
    ClientUrlTypes.QA: "https://instancywebappbot.azurewebsites.net/api/DLToken",
    ClientUrlTypes.PRODUCTION: "https://inst-chatbot-webapp-dev.azurewebsites.net/api/DLToken",
  };

  static String getAuthUrl(int clientUrlType) {
    String authUrl = siteAuthUrlMap[clientUrlType] ?? "";

    return authUrl;
  }

  static String getAppIconImageAssetPathFromSiteUrl(String siteUrl) {
    List<String> enterpriseSiteList = [
      enterpriseDemoStagingClientUrl,
      enterpriseDemoClientUrl,
      upgradedEnterpriseClientUrl,
    ];

    if (enterpriseSiteList.contains(siteUrl)) {
      return "assets/images/playgroundlogo.png";
    } else {
      return "assets/images/marketplacelogo.png";
    }
  }

  static String getChatBotTokenApiUrl(int clientUrlType) {
    String tokenApiUrl = chatBotTokenApiUrlMap[clientUrlType] ?? "";

    return tokenApiUrl;
  }
}
