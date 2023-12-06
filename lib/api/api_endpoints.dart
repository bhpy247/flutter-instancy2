class ApiEndpoints {
  final String siteUrl, authUrl, apiUrl;

  const ApiEndpoints({
    required this.siteUrl,
    required this.authUrl,
    required this.apiUrl,
  });

  String getAuthUrl() {
    return authUrl;
  }

  String getSiteUrl() {
    return siteUrl;
  }

  String getBaseApiUrl() {
    return apiUrl;
  }

  //region Splashscreen Api
  String apiSiteApiUrlConfiguration() {
    return "${getAuthUrl()}Authentication/GetMobileAPIAuth?AppURL=${getSiteUrl()}";
  }

  String apiMobileGetLearningPortalInfo() {
    return "${getBaseApiUrl()}MobileLMS/MobileGetLearningPortalInfo?SiteURL=${getSiteUrl()}";
  }

  String apiGetJsonFile({required String locale, required int siteid}) {
    return "${getBaseApiUrl()}MobileLMS/GetLocalizationFile?LocaleID=$locale&siteID=$siteid";
  }

  String apiMobileTinCanConfigurations({required String locale}) {
    return "${getBaseApiUrl()}MobileLMS/MobileTinCanConfigurations?SiteURL=${getSiteUrl()}&Locale=$locale";
  }

  String apiMobileGetNativeMenus({required int siteId, required String locale}) {
    return "${getBaseApiUrl()}MobileLMS/GetNativeAppMenusList?SiteID=$siteId&Locale=$locale";
  }

  String apiMobileGetNativeMenuComponents({required int siteId, required int menuId, required String locale}) {
    return "${getBaseApiUrl()}MobileLMS/GetNativeMenuComponents?SiteID=$siteId&MenuId=$menuId&Locale=$locale";
  }

  //endregion

  //region Generic Api
  String GetCurrencyData() => '${getBaseApiUrl()}Generic/GetCurrencyData';

  //endregion

  //region Authentication Api
  String apiPostLoginDetails() {
    return "${getBaseApiUrl()}MobileLMS/PostLoginDetails";
  }

  String apiSignUpUser({
    required String locale,
  }) =>
      '${getBaseApiUrl()}MobileLMS/MobileCreateSignUp?Locale=$locale&SiteURL=$siteUrl';

  //endregion

  //region Home Menu Api

  // static String GetNewLearningResource() => "$strBaseUrl/CourseList/GetNewCourses";

  String apiGetNewLearningResource({
    required int userId,
    required int siteID,
    required String language,
    required int componentId,
    required int componentInstanceId,
  }) =>
      '${getBaseApiUrl()}CourseList/GetNewCourses?UserID=$userId&SiteID=$siteID&Locale=$language&ComponentID=$componentId&ComponentInstanceID=$componentInstanceId&multiLocation=&CategoryCount=0&OrgUnitID=374';

  String apiGetRecommendedResource({
    required int userId,
    required int siteID,
    required String language,
    required int componentId,
    required int componentInstanceId,
  }) =>
      // '${strBaseUrl}Catalog/getRecomendationContent?UserID=$userId&SiteID=$siteID&Locale=$language&ComponentID=$componentId&ComponentInstanceID=$componentInstanceId&multiLocation=&CategoryCount=0&OrgUnitID=374';
      '${getBaseApiUrl()}Catalog/getRecomendationContent?siteId=$siteID&userId=$userId&componentInsId=$componentInstanceId&locale=$language&componentId=$componentId';

  String apiGetBannerSlider({
    required int userId,
    required int siteID,
    required String language,
    required int componentId,
    required int componentInstanceId,
  }) =>
      '${getBaseApiUrl()}WebList/GetWebListContent?ComponentID=$componentId&CompInsID=$componentInstanceId&TabTypeID=374&tabtype=1&PreferenceType=1&DeliveryModeID=1&aintUserID=$userId&aintSiteID=$siteID&astrLocale=$language&astrsorttype=2&externaluser=1&DataSource=1&groupId=-1';

  String apiGetStaticWebPages() => '${getBaseApiUrl()}Generic/staticWebPage';

  String apiGetWebListApi() => '${getBaseApiUrl()}WebList/GetWebListContent';

  //api/Catalog/getRecomendationContent?siteId=374&userId=467&componentInsId=50079&locale=en-us&componentId=303
  // endregion

  //region forgotPassword
  String apiGetUserStatusAPI({required String email}) => "${getBaseApiUrl()}MobileLMS/UserStatusForPasswordReset?Login=$email&SiteURL=$siteUrl";

  String resetUserDataAPI({required String userId, required String resetId}) => "${getBaseApiUrl()}MobileLMS/UsersPasswordResetDataFromMobile?Userid=$userId&ResetID=$resetId";

  String sendPwdResetAPI({required int siteId, required int userId, required String email, required String newguId}) =>
      "${getBaseApiUrl()}User/SendPasswordResetEmail?SiteID=$siteId&Userid=$userId&ToEmailID=$email&newguId=$newguId"; //&PublicContentURL=$contentURL/PasswordRecovery/Gid/$uuid";

  //endregion

  //region Signup
  String getSignUpFieldsURL({required int componentId, required int componentInstanceid, required String locale, required int siteId}) =>
      '${getBaseApiUrl()}MobileLMS/MobileGetSignUpDetails?ComponentID=$componentId&ComponentInstanceID=$componentInstanceid&Locale=$locale&SiteID=$siteId&SiteURL=${getSiteUrl()}';

//endregion

  //region Profile Menu Api
  String apiGetUserInfoV1({required int userId, required int siteId, required String locale}) {
    return '${getBaseApiUrl()}MobileLMS/MobileGetUserDetailsv1?UserID=$userId&siteURL=$siteUrl&SiteID=$siteId&strlocaleId=$locale';
  }

  String getUserDetails() => '${getBaseApiUrl()}/MobileLMS/MobileGetUserDetails';

  String apiGetProfileHeader() => '${getBaseApiUrl()}UserProfile/GetProfileHeaderData';

  String apiSaveProfile() => '${getBaseApiUrl()}UserProfile/SaveprofileData';

  String apiUpdatePersonalDetailsInProfile() => '${getBaseApiUrl()}/MobileLMS/MobileUpdateUserProfile';

  String createExperience() => '${getBaseApiUrl()}/MobileLMS/AddExperiencedata';

  String removeExperience() => '${getBaseApiUrl()}/MobileLMS/DeleteExperiencedata';

  String updateExperience() => '${getBaseApiUrl()}/MobileLMS/UpadteExperiencedata';

  String createEducation() => '${getBaseApiUrl()}/MobileLMS/AddEducationdata';

  String updateEducation() => '${getBaseApiUrl()}/MobileLMS/UpadteEducationdata';

  String removeEducation() => '${getBaseApiUrl()}/MobileLMS/DeleteEducationdata';

  String getEducationTitles() => '${getBaseApiUrl()}/MobileLMS/GeteducationTitleList';

  String uploadProfileImage() => '${getBaseApiUrl()}MobileLMS/MobileSyncProfileImage';

  String getUserProfileHeaderData() => '${getBaseApiUrl()}UserProfile/GetProfileHeaderData';

  //endregion

  //region My Learning Menu Api
  // String apiGetMyLearningContentsData() => '${getBaseApiUrl()}MobileLMS/MobileMyCatalogObjectsData';

  String apiGetMyLearningObjectsData() => '${getBaseApiUrl()}catalog/GetMyLearningObjects';

  String apiGetUpdateMyLearningArchive() => '${getBaseApiUrl()}catalog/UpdateMyLearningArchive';

  String apiGetSetStatusCompleted() => '${getBaseApiUrl()}MobileLMS/MobileSetStatusCompleted';

  String getRemoveFromMyLearning() => '${getBaseApiUrl()}catalog/RemoveFromMyCatalog';

  String getMyLearningCompletionCertificate() => '${getBaseApiUrl()}MobileLMS/MobiledownloadHTMLasPDF';

  //endregion

  //region Review and Rating
  String getGetUserRatingsURL() => '${getBaseApiUrl()}MobileLMS/GetUserRatings';

  String getDeleteUserRatingsURL() => '${getBaseApiUrl()}MobileLMS/DeleteRating';

  String getAddUserRatingsURL() => '${getBaseApiUrl()}MobileLMS/AddRatings';

  //endregion

  //region Wiki Section
  // https://upgradedenterpriseapi.instancy.com/api//SiteSettings/GetFileUploadControls?SiteId=374&LocaleId=en-us&compInsId=1&fromsiteedit=false&isFromNativeApp=true
  String apiGetFileUploadControl({required int siteId, required String locale, required String componentInstanceId}) {
    return '${getBaseApiUrl()}SiteSettings/GetFileUploadControls?SiteID=$siteId&LocaleId=$locale&compInsId=$componentInstanceId&fromsiteedit=false&isFromNativeApp=true';
  }

  String apiGetWikiCategories() {
    // curl --location --request POST 'https://upgradedenterpriseapi.instancy.com/api/Generic/GetWikiCategories?' --header 'content-type: application/json; charset=utf-8' --header 'ClientURL: https://upgradedenterprise.instancy.com/' --header 'Authorization: Bearer N2UzOGQzZTAtMDZiNC00NTcyLWI5NjgtMTBmMjA5MjgyNzQ4OjM4NTU1YTkyLWViOGMtNGFhMy1hZjYzLTEyMjUzNWVlMTRlMjoyLzYvMjAyMyA0OjI1OjU3IFBN' --header 'AllowWindowsandMobileApps: allow' --header 'UserID: 363' --header 'SiteID: 374' --header 'Locale: en-us' --data-raw '{"intUserID":"363","intSiteID":"374","intComponentID":1,"Locale":"en-us","strType":"cat"}'
    return "${getBaseApiUrl()}/Generic/GetWikiCategories?";
  }

  String apiUploadWikiData() {
    // curl --location --request POST 'https://upgradedenterpriseapi.instancy.com/api/Generic/GetWikiCategories?' --header 'content-type: application/json; charset=utf-8' --header 'ClientURL: https://upgradedenterprise.instancy.com/' --header 'Authorization: Bearer N2UzOGQzZTAtMDZiNC00NTcyLWI5NjgtMTBmMjA5MjgyNzQ4OjM4NTU1YTkyLWViOGMtNGFhMy1hZjYzLTEyMjUzNWVlMTRlMjoyLzYvMjAyMyA0OjI1OjU3IFBN' --header 'AllowWindowsandMobileApps: allow' --header 'UserID: 363' --header 'SiteID: 374' --header 'Locale: en-us' --data-raw '{"intUserID":"363","intSiteID":"374","intComponentID":1,"Locale":"en-us","strType":"cat"}'
    return "${getBaseApiUrl()}/UploadFiles/UploadFilesAction";
  }

  //endregion

  //region Catalog Section
  String apiGetCatalogCategoriesForBrowseModel({required int siteId, required String locale, required String componentInstanceId, required int userId}) {
    return "${getBaseApiUrl()}/Catalog/getCategoryForBrowse?strType=cat&intComponentID=$componentInstanceId&intSiteID=$siteId&intUserID=$userId&Locale=$locale";
  }

  String apiGetMobileCatalogObjectsData() {
    return "${getBaseApiUrl()}/MobileLMS/MobileCatalogObjectsData";
  }

  String getCatalogContents() => "${getBaseApiUrl()}catalog/getCatalogObjects";

  String getAddToMyLearning() => "${getBaseApiUrl()}/catalog/AddToMyLearning";

  String getAssociatedAddtoMyLearning() => '${getBaseApiUrl()}catalog/AssociatedAddtoMyLearning';

  String getEnrollWaitListEvent() => '${getBaseApiUrl()}/MobileLMS/EnrollWaitListEvent';

  String getExpiredContentAddToMyLearning() => '${getBaseApiUrl()}/Catalog/AddExpiredContentToMyLearning';

  String getAddToWishlist() => "${getBaseApiUrl()}/Catalog/AddToWishList";

  String getAddToWaitList() => "${getBaseApiUrl()}Catalog/EnrollWaitListEvent";

  String apiCreateUpdateUserComingSoonResponse() => "${getBaseApiUrl()}/ContentManagement/CreateUpdateUserComingSoonResponse";

  String getRemovedFromWishlist({required int userId, required String contentId}) => "${getBaseApiUrl()}/WishList/DeleteItemFromWishList?ContentID=$contentId&instUserID=$userId";

  //endregion

  //region Filter Section
  String getContentFilterCategoryTree() {
    return "${getBaseApiUrl()}/catalog/GetCategoriesTree";
  }

  String getLearningProviderForFilter() {
    return "${getBaseApiUrl()}/catalog/GetLearningProviderForFilter";
  }

  String getInstructorListForFilter() {
    return "${getBaseApiUrl()}/catalog/GetInstructorListForFilter";
  }

  String getFilterDurationValues() {
    return "${getBaseApiUrl()}/Catalog/Getfilterdurationvalues";
  }

  String getComponentSortOptions() => '${getBaseApiUrl()}/catalog/GetComponentSortOptions';

  //endregion

  //region Event Section
  String getCheckIsFallUnderBadCancelEnrollment() => '${getBaseApiUrl()}/EventSchedule/CheckIsFallUnderbadCancellation';

  String getCancelEnrolledEvent() => '${getBaseApiUrl()}/MobileLMS/CancelEnrolledEvent';

  String getReEnrollmentHistory() => '${getBaseApiUrl()}/Reports/GetSelfScheduleInstanceReport';

  String getEventSessionData() => '${getBaseApiUrl()}/EventTrackTabs/getEventSessionData';

  String getDynamicTabs() => '${getBaseApiUrl()}/DynamicTab/GetDynamicTabs';

  //endregion

  // region Share Section
  String getMyConnectionsListForShareContentUrl() => '${getBaseApiUrl()}/AsktheExpert/GetMyconnectionListForShareContent';

  String getRecommendToContentUrl() => '${getBaseApiUrl()}/AsktheExpert/GetRecommendedUsersList';

  String getSendMailToPeopleUrl() => '${getBaseApiUrl()}/Generic/SendMailToPeople';

  String getInsertRecommendedContentUrl() => '${getBaseApiUrl()}/AsktheExpert/InsertRecommendContent';

  String getInsertRecommendedContentNotificationUrl() => '${getBaseApiUrl()}/AsktheExpert/InsertRecommendedContentNotifications';

  String getSendRecommendedUserMail() => '${getBaseApiUrl()}/AsktheExpert/SendReccommendUserMail';

  String getSendMailToUserUrl() => '${getBaseApiUrl()}/Generic/SendMailToUser';

  //endregion

  // region Progress Report Section
  String getConsolidatedProgressReportUrl() => '${getBaseApiUrl()}/ConsolidatedProgressReport/GetConsolidateRPT';

  String getContentProgressSummaryDataUrl() => '${getBaseApiUrl()}/Progressummary/getsummarydata';

  String getContentProgressDetailDataUrl() => '${getBaseApiUrl()}/Progressummary/getprogressdatadetails';

  String getMyLearningContentProgressSummaryDataUrl() => '${getBaseApiUrl()}/MobileLMS/getsummarydata';

  String getProgressReportViewQuestionUrl() => '${getBaseApiUrl()}/Progressummary/getviewquestion';

  //endregion

  //region My Progress report

  String getMyProgressReportUrl() => '${getBaseApiUrl()}/ConsolidatedProgressReport/GetConsolidateRPT';

  //endregion

  //region preRequisiteDetails
  String getPrerequisiteDetails({String contentId = "", int userId = 0}) {
    return '${getBaseApiUrl()}catalog/GetPrequisiteDetails?ContentID=$contentId&UserID=$userId';
  }

  String getAssociatedContent(
          {String contentId = "",
          int userId = 0,
          int componentId = 0,
          int componentInstanceId = 0,
          int siteId = 0,
          String instanceData = "",
          int preRequisiteSequencePathId = 0,
          String locale = ""}) =>
      '${getBaseApiUrl()}AssociatedContent/GetAssociatedContent?ContentID=$contentId&ComponentID=$componentId&ComponentInstanceID=$componentInstanceId&UserID=$userId&SiteID=$siteId&Instancedata=$instanceData&PreRequisiteSequncePathID=$preRequisiteSequencePathId&Locale=$locale';

//endregion

  // region Content Details Section
  String getContentDetailsUrl() => '${getBaseApiUrl()}/ContentDetails/GetContentDetails';

  String getContentDetails1Url() => '${getBaseApiUrl()}/ContentDetails/getContentDetails1';

  String getContentDetailsScheduleDataUrl() => '${getBaseApiUrl()}/ContentDetails/getScheduleComponentScheduleData';

//endregion

  //region Learning Pathhttps://upgradedenterpriseapi.instancy.com/api/EventTrackTabs/GetEventTrackHeaderData?parentcontentID=2d14a88a-d74e-4893-abca-e8d3ce37dae1&siteID=374&userID=498&localeID=en-us&objecttypeid=10&iscontentenrolled=true&scoid=15337
  String getEventTrackHeaderData() => "${getBaseApiUrl()}EventTrackTabs/GetEventTrackHeaderData";

  String getEventTrackTabData() => "${getBaseApiUrl()}EventTrackTabs/GetEventTrackTabs";

  String getGetTrackListViewData() => "${getBaseApiUrl()}TrackListView/GetTrackListViewData";

  String getEventTrackOverview() => "${getBaseApiUrl()}EventTrackOverview/geteventtrackoverview";

  String getGlossaryJsonData() => "${getBaseApiUrl()}MobileLMS/GetglossaryJsonData";

  String getEventTrackResourcesData() => "${getBaseApiUrl()}MobileLMS/GetResourceJsonData";

  String getTrackContentsData() => "${getBaseApiUrl()}MobileLMS/MobileGetMobileContentMetaData";

  String getEventRelatedContentsData() => "${getBaseApiUrl()}MobileLMS/GetMobileEventRelatedContentMetadata";

  //endregion

  //region Instabot
  String GetInsertBotData() => '${getBaseApiUrl()}/Chatbot/InsertBotData';

  //endregion

  // region Course Launch
  String getWebAPIInitialiseTrackingApiCall() => '${getBaseApiUrl()}CourseTracking/webAPIInitialiseTracking';

  String getInsertCourseDataByTokenApiCall() => '${getBaseApiUrl()}CourseTracking/InsertCourseDataByToken';

  String getMobileGetContentStatusApiCall() => '${getBaseApiUrl()}MobileLMS/MobileGetContentStatus';

  String getInitializeTrackingforMediaObjectsApiCall() => '${getBaseApiUrl()}CourseTracking/InitializeTrackingforMediaObjects';

  //endregion

  // region Discussion
  String getDiscussionForumList() => '${getBaseApiUrl()}DiscussionForums/GetForumList';

  String getCreateDiscussionForum() => '${getBaseApiUrl()}DiscussionForums/CreateEditForum';

  //region addTopicComment
  String getPostCommentApi() => '${getBaseApiUrl()}DiscussionForums/PostComment';

  String getForumTopic() => '${getBaseApiUrl()}DiscussionForums/GetForumTopics';

  String getSingleForumDetails() => '${getBaseApiUrl()}DiscussionForums/GetSingleForumDetails';

  String getUploadForumAttachment() => '${getBaseApiUrl()}DiscussionForums/UploadForumAttachment';

  String getPostReply() => '${getBaseApiUrl()}DiscussionForums/PostReply';

  String apiAddTopic() => '${getBaseApiUrl()}DiscussionForums/CreateForumTopic';

  String apiGetModerator() => '${getBaseApiUrl()}DiscussionForums/GetUserListBasedOnRoles';

  String apiEditTopic() => '${getBaseApiUrl()}DiscussionForums/EditForumTopic';

  String DeleteForum() => '${getBaseApiUrl()}DiscussionForums/DeleteForum';

  String DeleteForumTopic() => '${getBaseApiUrl()}DiscussionForums/DeleteForumTopic';

  String DeleteForumReply() => '${getBaseApiUrl()}DiscussionForums/DeleteForumReply';

  String apiDeleteComment() => '${getBaseApiUrl()}DiscussionForums/DeleteForumComment';

  String UpdatePinTopic() => '${getBaseApiUrl()}DiscussionForums/UpdatePinTopic';

  String InsertAndGetContentLikes() => '${getBaseApiUrl()}DiscussionForums/InsertAndGetContentLikes';

  String InsertContentLikes() => '${getBaseApiUrl()}Generic/InsertContentLikes';

  String apiLikeCount() => '${getBaseApiUrl()}DiscussionForums/GetTopicCommentLevelLikeList';

  String GetReplies() => '${getBaseApiUrl()}DiscussionForums/GetReplies';

  String apiGetCommentList() => '${getBaseApiUrl()}DiscussionForums/GetCommentList';

  String apiGetForumLevelLikeList() => '${getBaseApiUrl()}DiscussionForums/GetForumLevelLikeList';

  String apiGetTopicCommentLevelLikeList() => '${getBaseApiUrl()}DiscussionForums/GetTopicCommentLevelLikeList';

  //endregion
  //endregion

  // region MyConnections
  String getPeopleList() => '${getBaseApiUrl()}PeopleListing/GetPeopleList';

  //endregion

  //region Message
  String getMessageUserList() => '${getBaseApiUrl()}Chat/GetChatConnectionUserList';

  String sendChatMessage() => '${getBaseApiUrl()}Chat/InsertUserChatData';

  String genericFileUpload() => '${getBaseApiUrl()}Generic/SaveFiles';

  String getUserChatHistory() => '${getBaseApiUrl()}Chat/GetUserChatHistory';

  String getArchiveAndUnarchive() => '${getBaseApiUrl()}Chat/UpdateArchivedUserForChat';

  //endregion

  // region MyConnections https://upgradedenterpriseapi.instancy.com/api/ContentManagement/GetUserComingSoonResponse?userID=363&contentId=d45436ba-aa0e-49ac-a15a-4d5d0c7c2e7c&savingtype=

  //endregion

  //region pageNotesResponseModel
  String getUserComingSoonResponse({String contentId = "", int userId = 0}) => '${getBaseApiUrl()}ContentManagement/GetUserComingSoonResponse?contentId=$contentId&userID=$userId&savingtype=';

//region pageNotesResponseModel
  String getPageNotes({String contentId = "", int userId = 0, int componentId = 0, int componentInstanceId = 0, int siteId = 0, int pageId = -1, int seqId = 0, String locale = ""}) =>
      '${getBaseApiUrl()}Notes/GetAllUserPageNotes?ContentID=$contentId&ComponentID=$componentId&ComponentInstanceID=$componentInstanceId&UserID=$userId&SiteID=$siteId&PageID=$pageId&SeqID=$seqId';

  String saveUserPageNote() => "${getBaseApiUrl()}Notes/SaveUserPageNotes";

  String deleteUserPageNote({
    String contentId = "",
    int userId = 0,
    int siteId = 0,
    int pageId = -1,
    int seqId = 0,
    String trackId = "",
    int count = 0,
  }) =>
      "${getBaseApiUrl()}Notes/Deleterow?strUserID=$userId&cntid=$contentId&pageid=$pageId&trackid=$trackId&seqid=$seqId&count=$count";

//endregion

  //region setComplete https://upgradedenterpriseapi.instancy.com/api/CourseTracking/UpdateCompleteStatus
  String setCompleteStatusCatalog() => "${getBaseApiUrl()}CourseTracking/UpdateCompleteStatus";

  //endregion

  //region In App Purchase
  String getMobileSaveInAppPurchaseDetails() => '${getBaseApiUrl()}MobileLMS/MobileSaveInAppPurchaseDetails';

  String getEcommerceProcessPayments() => '${getBaseApiUrl()}Ecommerce/ProcessPayments';

  String getEcommercePurchaseData() => '${getBaseApiUrl()}Ecommerce/PurchaseData';

  String getGetEcommerceOrderByUser() => '${getBaseApiUrl()}Ecommerce/GetEcommerceOrderByUser';

  //endregion

  //region Membership
  String getMemberShipDetails() => '${getBaseApiUrl()}MemberShip/GetMemberShipDetails';

  String GetUpdateMemberShipDetails() => '${getBaseApiUrl()}MemberShip/GetUpdateMemberShipDetails';

  String GetUserActiveMembership() => '${getBaseApiUrl()}MemberShip/GetUserActiveMembership';

  String CancelUserMembership() => '${getBaseApiUrl()}MemberShip/CancelUserMembership';

  //endregion

  //region Gamification
  String GetGameList() => '${getBaseApiUrl()}LeaderBoard/GetGameList';

  String GetUserAchievementData() => '${getBaseApiUrl()}UserAchievement/GetUserAchievementData';

  String GetLeaderboardData() => '${getBaseApiUrl()}LeaderBoard/GetLeaderboardData';

  String UpdateContentGamification() => '${getBaseApiUrl()}Game/UpdateContentGamification';

  //endregion

  String apiGetSiteBotDetails({required String instancyApiUrl}) {
    if (instancyApiUrl.endsWith("/")) {
      instancyApiUrl = instancyApiUrl.substring(0, instancyApiUrl.length - 1);
    }
    return "$instancyApiUrl/Bot/GetSiteBotDetails";
  }
}
