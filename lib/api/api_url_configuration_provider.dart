class ApiUrlConfigurationProvider {
  //region Main Site Url
  String _mainSiteUrl = "";

  String getMainSiteUrl() => _mainSiteUrl;

  void setMainSiteUrl(String url) => _mainSiteUrl = url;
  //endregion

  //region Auth Url
  String _authUrl = "";

  String getAuthUrl() => _authUrl;

  void setAuthUrl(String token) => _authUrl = token;
  //endregion

  //region Splash Logo
  String _splashlogo = "";

  String getSplashLogo() => _splashlogo;

  void setSplashLogo(String logo) => _splashlogo = logo;
  //endregion

  //region App Name
  String _appName = "";

  String getAppName() => _appName;

  void setAppName(String name) => _appName = name;
  //endregion



  //region Current Base Api Url
  String _currentBaseApiUrl = "";

  String getCurrentBaseApiUrl() => _currentBaseApiUrl;

  void setCurrentBaseApiUrl(String url) => _currentBaseApiUrl = url;
  //endregion

  //region Current Site Url
  String _currentSiteUrl = "";

  String getCurrentSiteUrl() => _currentSiteUrl;

  void setCurrentSiteUrl(String url) => _currentSiteUrl = url;
  //endregion

  //region Current Site Learner Url
  String _currentSiteLearnerUrl = "";

  String getCurrentSiteLearnerUrl() => _currentSiteLearnerUrl;

  void setCurrentSiteLearnerUrl(String url) => _currentSiteLearnerUrl = url;
  //endregion

  //region Current Site LMS Url
  String _currentSiteLMSUrl = "";

  String getCurrentSiteLMSUrl() => _currentSiteLMSUrl;

  void setCurrentSiteLMSUrl(String url) => _currentSiteLMSUrl = url;
  //endregion

  //region UserId
  int _currentUserId = -1;

  int getCurrentUserId() => _currentUserId;

  void setCurrentUserId(int id) => _currentUserId = id;
  //endregion

  //region SiteId
  int _currentSiteId = -1;

  int getCurrentSiteId() => _currentSiteId;

  void setCurrentSiteId(int id) => _currentSiteId = id;
  //endregion

  //region Locale
  String _locale = "en-us";

  String getLocale() => _locale;

  void setLocale(String locale) => _locale = locale;
  //endregion

  //region Auth Token
  String _authToken = "";

  String getAuthToken() => _authToken;

  void setAuthToken(String token) => _authToken = token;
  //endregion
}