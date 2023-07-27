import 'dart:math';

import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import 'localization_selection_model.dart';
import 'site_configuration_model.dart';

class AppSystemConfigurationModel {
  AppSystemConfigurationModel();

  String _appLogoURl = "";
  String get appLogoURl => _appLogoURl;
  void setappLogoURl(String value) {
    _appLogoURl = value;
  }

  String _appDarkLogoURl = '';
  String get appDarkLogoURl => _appDarkLogoURl;
  void setDarkLogoURl(String value) {
    _appDarkLogoURl = value;
  }

  String getAppLogoFromThemeMode({required bool isDarkThemeEnabled}) {
    return isDarkThemeEnabled ? appDarkLogoURl : appLogoURl;
  }

  bool _enableInAppPurchase = false;
  bool get enableInAppPurchase => _enableInAppPurchase;
  void setEnableInAppPurchase(bool value) {
    _enableInAppPurchase = value;
  }

  bool _enableNativeCatlog = false;
  bool get enableNativeCatlog => _enableNativeCatlog;
  void seEnableNativeCatlog(bool value) {
    _enableNativeCatlog = value;
  }

  bool _isGlobasearch = false;
  bool get isGlobasearch => _isGlobasearch;
  void seIsGlobasearch(bool value) {
    _isGlobasearch = value;
  }

  bool _enableMembership = false;
  bool get enableMembership => _enableMembership;
  void setEnableMembership(bool value) {
    _enableMembership = value;
  }

  bool _selfRegistrationAllowed = true;
  bool get selfRegistrationAllowed => _selfRegistrationAllowed;
  void setSelfRegistrationAllowed(bool value) {
    _selfRegistrationAllowed = value;
  }

  bool _enableEcommerce = false;
  bool get enableEcommerce => _enableEcommerce;
  void setEnableEcommerce(bool value) {
    _enableEcommerce = value;
  }

  String _dateFormat = "";
  String get dateFormat => _dateFormat;
  void setDateFormat(String value) {
    _dateFormat = value;
  }

  String _dateTimeFormat = "";
  String get dateTimeFormat => _dateTimeFormat;
  void setDateTimeFormat(String value) {
    _dateTimeFormat = value.replaceAll("tt", "aa");
  }

  String _eventDateTimeFormat = "";
  String get eventDateTimeFormat => _eventDateTimeFormat;
  void setEventDateTimeFormat(String value) {
    _eventDateTimeFormat = value;
  }

  String _siteLanguage = "";
  String get siteLanguage => _siteLanguage;
  void setSiteLanguage(String value) {
    _siteLanguage = value;
  }

  bool _enablePushNotification = false;
  bool get enablePushNotification => _enablePushNotification;
  void setEnablePushNotification(bool value) {
    _enablePushNotification = value;
  }

  String _commonPasswordValue = "";
  String get commonPasswordValue => _commonPasswordValue;
  void setCommonPasswordValue(String value) {
    _commonPasswordValue = value;
  }

  bool _autoLaunchFirstContentInMyLearning = false;
  bool get autoLaunchFirstContentInMyLearning => _autoLaunchFirstContentInMyLearning;
  void setAutoLaunchFirstContentInMyLearning(bool value) {
    _autoLaunchFirstContentInMyLearning = value;
  }

  String _discussionForumFileTypes = "";
  String get discussionForumFileTypes => _discussionForumFileTypes;
  void setDiscussionForumFileTypes(String value) {
    _discussionForumFileTypes = value;
  }

  bool _enableSkillsToBeMappedWithJobRoles = false;
  bool get enableSkillsToBeMappedWithJobRoles => _enableSkillsToBeMappedWithJobRoles;
  void setEnableSkillsToBeMappedWithJobRoles(bool value) {
    _enableSkillsToBeMappedWithJobRoles = value;
  }

  int _userUploadFileSize = 0;
  int get userUploadFileSize => _userUploadFileSize;
  void setUserUploadFileSize(int value) {
    _userUploadFileSize = value;
  }

  int _contentDownloadType = 0;
  int get contentDownloadType => _contentDownloadType;
  void setContentDownloadType(int value) {
    _contentDownloadType = value;
  }

  String _nativeAppType = "";
  String get nativeAppType => _nativeAppType;
  void setNativeAppType(String value) {
    _nativeAppType = value;
  }

  String _courseAppContent = "";
  String get courseAppContent => _courseAppContent;
  void setCourseAppContent(String value) {
    _courseAppContent = value;
  }

  bool _enableNativeCatalog = false;
  bool get enableNativeCatalog => _enableNativeCatalog;
  void setEnableNativeCatalog(bool value) {
    _enableNativeCatalog = value;
  }

  int _autoDownloadSizeLimit = 0;
  int get autoDownloadSizeLimit => _autoDownloadSizeLimit;
  void setAutoDownloadSizeLimit(int value) {
    _autoDownloadSizeLimit = value;
  }

  String _learnerDefaultMenu = "";
  String get learnerDefaultMenu => _learnerDefaultMenu;
  void setLearnerDefaultMenu(String value) {
    _learnerDefaultMenu = value;
  }

  String _ccEventStartdate = "";
  String get cCEventStartDate => _ccEventStartdate;
  void setCCEventStartDate(String value) {
    _ccEventStartdate = value;
  }

  bool _isGlobalsearch = false;
  bool get isGlobalSearch => _isGlobalsearch;
  void setIsGlobalSearch(bool value) {
    _isGlobalsearch = value;
  }

  bool _autocompleteNonTrackableContent = false;
  bool get autocompleteNonTrackableContent => _autocompleteNonTrackableContent;
  void setAutocompleteNonTrackableContent(bool value) {
    _autocompleteNonTrackableContent = value;
  }

  bool _setcompletehidefornotstarted = false;
  bool get setcompletehidefornotstarted => _setcompletehidefornotstarted;
  void setSetcompletehidefornotstarted(bool value) {
    _setcompletehidefornotstarted = value;
  }

  bool _enableAzureSSOForLearner = false;
  bool get enableAzureSSOForLearner => _enableAzureSSOForLearner;
  void setEnableAzureSSOForLearner(bool value) {
    _enableAzureSSOForLearner = value;
  }

  bool _enableContentEvaluation = false;
  bool get enableContentEvaluation => _enableContentEvaluation;
  void setEnableContentEvaluation(bool value) {
    _enableContentEvaluation = value;
  }

  bool _enableDownLoadAudioVideoCloud = false;
  bool get enableDownLoadAudioVideoCloud => _enableDownLoadAudioVideoCloud;
  void setEnableDownLoadAudioVideoCloud(bool value) {
    _enableDownLoadAudioVideoCloud = value;
  }

  int _catalogContentDownloadType = 0;
  int get catalogContentDownloadType => _catalogContentDownloadType;
  void setCatalogContentDownloadType(int value) {
    _catalogContentDownloadType = value;
  }

  bool _enableNativeAppLoginSetting = false;
  bool get enableNativeAppLoginSetting => _enableNativeAppLoginSetting;
  void setEnableNativeAppLoginSetting(bool value) {
    _enableNativeAppLoginSetting = value;
  }

  bool _enableNativeAppLoginSettingLogo = false;
  bool get enableNativeAppLoginSettingLogo => _enableNativeAppLoginSettingLogo;
  void setEnableNativeAppLoginSettingLogo(bool value) {
    _enableNativeAppLoginSettingLogo = value;
  }

  String _selfRegistrationDisplayName = "";
  String get selfRegistrationDisplayName => _selfRegistrationDisplayName;
  void setSelfRegistrationDisplayName(String value) {
    _selfRegistrationDisplayName = value;
  }

  String _nativeAppLoginLogo = "";
  String get nativeAppLoginLogo => _nativeAppLoginLogo;
  void setNativeAppLoginLogo(String value) {
    _nativeAppLoginLogo = value;
  }

  String _nativeAppDarkThemeLogo = "";
  String get nativeAppDarkThemeLogo => _nativeAppDarkThemeLogo;
  void setNativeAppDarkThemeLogo(String value) {
    _nativeAppDarkThemeLogo = value;
  }

  bool _enableNativeSplashImage = false;
  bool get enableNativeSplashImage => _enableNativeSplashImage;
  void setEnableNativeSplashImage(bool value) {
    _enableNativeSplashImage = value;
  }

  bool _allowExpiredEventsSubscription = false;
  bool get allowExpiredEventsSubscription => _allowExpiredEventsSubscription;
  void setAllowExpiredEventsSubscription(bool value) {
    _allowExpiredEventsSubscription = value;
  }

  int _numberOfRatingsRequiredToShowRating = 0;
  int get numberOfRatingsRequiredToShowRating => _numberOfRatingsRequiredToShowRating;

  void setNumberOfRatingsRequiredToShowRating(int value) {
    _numberOfRatingsRequiredToShowRating = value;
  }

  int _minimumRatingRequiredToShowRating = 0;
  int get minimumRatingRequiredToShowRating => _minimumRatingRequiredToShowRating;

  void setMinimumRatingRequiredToShowRating(int value) {
    _minimumRatingRequiredToShowRating = value;
  }

  int _noOfDaysForCourseTargetDate = 0;
  int get noOfDaysForCourseTargetDate => _noOfDaysForCourseTargetDate;
  void setNoOfDaysForCourseTargetDate(int value) {
    _noOfDaysForCourseTargetDate = value;
  }

  bool _enableMultipleInstancesForEvent = false;
  bool get enableMultipleInstancesForEvent => _enableMultipleInstancesForEvent;
  void setEnableMultipleInstancesForEvent(bool value) {
    _enableMultipleInstancesForEvent = value;
  }

  bool _showMembershipContentPriceByStrikeThrough = false;
  bool get showMembershipContentPriceByStrikeThrough => _showMembershipContentPriceByStrikeThrough;
  void setShowMembershipContentPriceByStrikeThrough(bool value) {
    _showMembershipContentPriceByStrikeThrough = value;
  }

  bool _dontallowPrerequitieDesiredContent = false;
  bool get dontallowPrerequitieDesiredContent => _dontallowPrerequitieDesiredContent;
  void setDontallowPrerequitieDesiredContent(bool value) {
    _dontallowPrerequitieDesiredContent = value;
  }

  String _showEventAvailableFewSeatsLeft = "";
  String get showEventAvailableFewSeatsLeft => _showEventAvailableFewSeatsLeft;
  void setShowEventAvailableFewSeatsLeft(String value) {
    _showEventAvailableFewSeatsLeft = value;
  }

  bool _enableWishlist = false;
  bool get enableWishlist => _enableWishlist;
  void setEnableWishlist(bool value) {
    _enableWishlist = value;
  }

  bool _doNotAllowPrerequisiteDesiredContent = false;
  bool get doNotAllowPrerequisiteDesiredContent =>
      _doNotAllowPrerequisiteDesiredContent;
  void setDoNotAllowPrerequisiteDesiredContent(bool value) {
    _doNotAllowPrerequisiteDesiredContent = value;
  }

  bool _membershipExpiryAlertMessage = false;
  bool get membershipExpiryAlertMessage => _membershipExpiryAlertMessage;
  void setMembershipExpiryAlertMessage(bool value) {
    _membershipExpiryAlertMessage = value;
  }

  bool _autocompleteDocumentionDownload = false;
  bool get AutocompleteDocumentionDownload => _autocompleteDocumentionDownload;
  void setAutocompleteDocumentionDownload(bool value) {
    _autocompleteDocumentionDownload = value;
  }

  int _daysBeforeMembershipExpiry = -1;
  int get daysBeforeMembershipExpiry => _daysBeforeMembershipExpiry;
  void setDaysBeforeMembershipExpiry(int value) {
    _daysBeforeMembershipExpiry = value;
  }

  String _mobileAppMenuPosition = "";
  String get mobileAppMenuPosition => _mobileAppMenuPosition;
  void setMobileAppMenuPosition(String value) {
    _mobileAppMenuPosition = value;
  }

  bool _showMoreActionForBottomMenu = false;
  bool get showMoreActionForBottomMenu => _showMoreActionForBottomMenu;
  void setShowMoreActionForBottomMenu(bool value) {
    _showMoreActionForBottomMenu = value;
  }

  bool _isCloudStorageEnabled = false;
  bool get isCloudStorageEnabled => _isCloudStorageEnabled;
  void setIsCloudStorageEnabled(bool value) {
    _isCloudStorageEnabled = value;
  }

  String _azureRootPath = "";
  String get azureRootPath => _azureRootPath;
  void setAzureRootPath(String value) {
    _azureRootPath = value;
  }

  String _isFeedbackRedirection = "";
  String get isFeedbackRedirection => _isFeedbackRedirection;
  void setIsFeedbackRedirection(String value) {
    _isFeedbackRedirection = value;
  }

  bool _enableGamification = false;
  bool get enableGamification => _enableGamification;
  void setEnableGamification(bool value) {
    _enableGamification = value;
  }

  String _addProfileAdditionalTab = "";
  String get addProfileAdditionalTab => _addProfileAdditionalTab;
  void setAddProfileAdditionalTab(String value) {
    _addProfileAdditionalTab = value;
  }

  bool _enableChatBot = false;
  bool get enableChatBot => _enableChatBot;
  void setEnableChatBot(bool value) {
    _enableChatBot = value;
  }

  String _beforeLoginKnowledgeBaseID = "";
  String get beforeLoginKnowledgeBaseID => _beforeLoginKnowledgeBaseID;
  void setBeforeLoginKnowledgeBaseID(String value) {
    _beforeLoginKnowledgeBaseID = value;
  }

  String _botChatIcon = "";
  String get botChatIcon => _botChatIcon;
  void setBotChatIcon(String value) {
    _botChatIcon = value;
  }

  String _instancyBotEndPointURL = "";
  String get instancyBotEndPointURL => _instancyBotEndPointURL;
  void setInstancyBotEndPointURL(String value) {
    _instancyBotEndPointURL = value;
  }

  String _botGreetingContent = "";
  String get botGreetingContent => _botGreetingContent;
  void setBotGreetingContent(String value) {
    _botGreetingContent = value;
  }

  bool _isFromPush = false;
  bool get isFromPush => _isFromPush;
  void setIsFromPush(bool value) {
    _isFromPush = value;
  }

  String _feedbackUrl = "";
  String get feedbackUrl => _feedbackUrl;
  void setFeedbackUrl(String value) {
    _feedbackUrl = value;
  }

  bool _isFaceBook = false;
  bool get isFaceBook => _isFaceBook;
  void setIsFaceBook(bool value) {
    _isFaceBook = value;
  }

  bool _isGoogle = false;
  bool get isGoogle => _isGoogle;
  void setIsGoogle(bool value) {
    _isGoogle = value;
  }

  bool _isTwitter = false;
  bool get isTwitter => _isTwitter;
  void setIsTwitter(bool value) {
    _isTwitter = value;
  }

  bool _isLinkedIn = false;
  bool get isLinkedIn => _isLinkedIn;
  void setIsLinkedIn(bool value) {
    _isLinkedIn = value;
  }

  List<LocalizationSelectionModel> _localeList = [];
  List<LocalizationSelectionModel> get localeList => _localeList;
  void setLocaleList(List<LocalizationSelectionModel> value) {
    _localeList = value;
  }

  bool _isMsgMenuExist = false;
  bool get isMsgMenuExist => _isMsgMenuExist;
  void setIsMsgMenuExist(bool value) {
    _isMsgMenuExist = value;
  }

  AppSystemConfigurationModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    setEnableMembership(ParsingHelper.parseBoolMethod(map['EnableMembership']));
    setSelfRegistrationAllowed(ParsingHelper.parseBoolMethod(map['SelfRegistrationAllowed']));
    setEnableEcommerce(ParsingHelper.parseBoolMethod(map['EnableEcommerce']));
    setEnableEcommerce(ParsingHelper.parseBoolMethod(map['EnableEcommerce']));
    setEnablePushNotification(ParsingHelper.parseBoolMethod(map['EnablePushNotification']));
    setAutoLaunchFirstContentInMyLearning(ParsingHelper.parseBoolMethod(map['AutoLaunchFirstContentInMyLearning']));
    setEnableSkillsToBeMappedWithJobRoles(ParsingHelper.parseBoolMethod(map['EnableSkillstobeMappedwithJobRoles']));
    setEnableInAppPurchase(ParsingHelper.parseBoolMethod(map['EnableInAppPurchase']));
    setIsGlobalSearch(ParsingHelper.parseBoolMethod(map['IsGlobasearch']));
    setAutocompleteNonTrackableContent(ParsingHelper.parseBoolMethod(map['Autocompletenontrackablecontent']));
    setSetcompletehidefornotstarted(ParsingHelper.parseBoolMethod(map['Setcompletehidefornotstarted']));
    setEnableAzureSSOForLearner(ParsingHelper.parseBoolMethod(map['EnableAzureSSOForLearner']));
    setEnableContentEvaluation(ParsingHelper.parseBoolMethod(map['EnableContentEvaluation']));
    setEnableDownLoadAudioVideoCloud(ParsingHelper.parseBoolMethod(map['EnableDownLoadAudioVideoCloud']));
    setEnableNativeAppLoginSetting(ParsingHelper.parseBoolMethod(map['EnableNativeAppLoginSetting']));
    setEnableNativeAppLoginSettingLogo(ParsingHelper.parseBoolMethod(map['EnableNativeAppLoginSettingLogo']));
    setEnableNativeSplashImage(ParsingHelper.parseBoolMethod(map['EnableNativeSplashImage']));
    setAllowExpiredEventsSubscription(ParsingHelper.parseBoolMethod(map['AllowExpiredEventsSubscription']));
    setEnableGamification(ParsingHelper.parseBoolMethod(map['EnableGamification']));
    setEnableMultipleInstancesForEvent(ParsingHelper.parseBoolMethod(map['EnableMultipleInstancesforEvent']));
    setEnableWishlist(ParsingHelper.parseBoolMethod(map['EnableWishlist']));
    setShowMembershipContentPriceByStrikeThrough(ParsingHelper.parseBoolMethod(map['ShowMembershipContentPricebyStrikeThrough']));
    setDoNotAllowPrerequisiteDesiredContent(ParsingHelper.parseBoolMethod(map['dontallowPrerequitieDesiredContent']));
    setMembershipExpiryAlertMessage(ParsingHelper.parseBoolMethod(map['MembershipExpiryAlertMessage']));
    setIsCloudStorageEnabled(ParsingHelper.parseBoolMethod(map['isCloudStorageEnabled']));
    setShowMoreActionForBottomMenu(ParsingHelper.parseBoolMethod(map['ShowMoreActionforBottommenu']));
    setEnableChatBot(ParsingHelper.parseBoolMethod(map['EnableChatBot']));
    setAutocompleteDocumentionDownload(ParsingHelper.parseBoolMethod(map['AutocompleteDocumentionDownload']));

    setDateFormat(ParsingHelper.parseStringMethod(map['DateFormat']).replaceAll("tt", "aa"));
    setDateTimeFormat(ParsingHelper.parseStringMethod(map['DateTimeFormat']).replaceAll("tt", "aa"));
    setEventDateTimeFormat(ParsingHelper.parseStringMethod(map['EventDateTimeFormat']).replaceAll("tt", "aa"));
    setCCEventStartDate(ParsingHelper.parseStringMethod(map['CCEventStartdate']));

    setSiteLanguage(ParsingHelper.parseStringMethod(map['SiteLanguage']));
    setCommonPasswordValue(ParsingHelper.parseStringMethod(map['CommonPasswordValue']));
    setDiscussionForumFileTypes(ParsingHelper.parseStringMethod(map['DiscussionForumFileTypes']));
    setNativeAppType(ParsingHelper.parseStringMethod(map['nativeapptype']));
    setCourseAppContent(ParsingHelper.parseStringMethod(map['courseappcontent']));
    setLearnerDefaultMenu(ParsingHelper.parseStringMethod(map['LearnerDefaultMenu']));
    setSelfRegistrationDisplayName(ParsingHelper.parseStringMethod(map['SelfRegistrationDisplayName']));
    setAddProfileAdditionalTab(ParsingHelper.parseStringMethod(map['AddProfileAdditionalTab']));
    setAzureRootPath(ParsingHelper.parseStringMethod(map['AzureRootPath']));
    setMobileAppMenuPosition(ParsingHelper.parseStringMethod(map['MobileAppMenuPosition']));
    setInstancyBotEndPointURL(ParsingHelper.parseStringMethod(map['InstancyBotEndPointURL']));

    setNativeAppLoginLogo(ParsingHelper.parseStringMethod(map['NativeAppLoginLogo']));
    setNativeAppDarkThemeLogo(ParsingHelper.parseStringMethod(map['NativeAppDarkThemeLogo']));

    setUserUploadFileSize(ParsingHelper.parseIntMethod(map['UserUploadFileSize']));
    setContentDownloadType(ParsingHelper.parseIntMethod(map['ContentDownloadType']));
    setAutoDownloadSizeLimit(ParsingHelper.parseIntMethod(map['autodownloadsizelimit']));
    setCatalogContentDownloadType(ParsingHelper.parseIntMethod(map['CatalogContentDownloadType']));
    setNumberOfRatingsRequiredToShowRating(ParsingHelper.parseIntMethod(map['NumberOfRatingsRequiredToShowRating']));
    setMinimumRatingRequiredToShowRating(ParsingHelper.parseIntMethod(map['MinimimRatingRequiredToShowRating']));
    setNoOfDaysForCourseTargetDate(ParsingHelper.parseIntMethod(map['NoOfDaysForCourseTargetDate']));
    setDaysBeforeMembershipExpiry(ParsingHelper.parseIntMethod(map['DaysBeforemembershipexpiry'], defaultValue: -1));
  }

  void initializeAppLogoUrlFromSiteConfiguration({required SiteUrlConfigurationModel siteUrlConfigurationModel}) {
    int min = 100; //min and max values act as your 3 digit range
    int max = 999;
    Random randomizer = Random();
    int rNum = min + randomizer.nextInt(max - min);

    String applogoURL = "${siteUrlConfigurationModel.siteLMSUrl}Content/SiteConfiguration/${siteUrlConfigurationModel.siteId}/LoginSettingLogo/$nativeAppLoginLogo?v=$rNum";
    MyPrint.printOnConsole("appLogoURl:$applogoURL");
    setappLogoURl(applogoURL);
  }

  void initializeAppDarkLogoUrlFromSiteConfiguration({required SiteUrlConfigurationModel siteUrlConfigurationModel}) {
    int min = 100; //min and max values act as your 3 digit range
    int max = 999;
    Random randomizer = Random();
    int rNum = min + randomizer.nextInt(max - min);

    String applogoURL = "${siteUrlConfigurationModel.siteLMSUrl}Content/SiteConfiguration/${siteUrlConfigurationModel.siteId}/LoginSettingLogo/$nativeAppDarkThemeLogo?v=$rNum";
    MyPrint.printOnConsole("appDarkLogoURl:$appDarkLogoURl");
    setDarkLogoURl(applogoURL);
  }
}