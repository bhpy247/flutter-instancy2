import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppConstants {
  static const String apiAllowFromExternalHostKey = "AllowWindowsandMobileApps";
  static const String saltKey = "gRBtUdz2KKLs7hFThDlxpQeKJeaSGouGP0epTeZEbrKsytseecDQxy3TItGpeGYuAegJATZALtvFNloYaAd2qopSVlzOAPatQKrCsKbACgb53cGam45bxafhLre1";
  static const String securityKey = "4512631236589784";
  static const String securityIv = '4512631236589784';
  static const kAppFlavour = AppFlavour.marketPlace;
  static const String fileServerLocation = '/Content/SiteConfiguration/Message/';

  static const int defaultSiteId = 374;
  static const String defaultLocale = "en-us";
  static const String defaultAuthorImageUrl =
      "https://image.shutterstock.com/z/stock-photo-high-angle-view-of-video-conference-with-teacher-on-laptop-at-home-top-view-of-girl-in-video-call-1676998303.jpg";
  static const String defaultVideoUrl = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
}

class SharedPreferenceVariables {
  static const String darkThemeModeEnabled = "darkThemeModeEnabled";
  static const String isUserLoggedIn = "isUserLoggedIn";

  //Site Url Configurations
  static const String currentSiteUrl = 'currentSiteUrl';
  static const String currentSiteApiUrl = 'currentSiteApiUrl';
  static const String currentSiteLearnerUrl = 'currentSiteLearnerUrl';
  static const String currentSiteLMSUrl = 'currentSiteLMSUrl';
  static const String currentAppLogoUrl = 'currentAppLogoUrl';
}

class LocaleType {
  static const String english = "en-us";
  static const String hindi = "hi";
}

class GCPCredentials {
  static const String apiKey = "AIzaSyDIGUE_xngxAGG4i22_RxWiNDQh7ZhtnxA";
}

class AppAssets {
  static const String surfaceDetection = "assets/lens_images/surface_detection.gif";
  static const String tapOnPlane = "assets/lens_images/tap_on_plane.gif";
}

class ProfileGroupType {
  static const int personalInfo = 1;
  static const int contactInfo = 2;
  static const int backOfficeInfo = 4;
}

class CoursesName {
  static const String classroom = "Classroom";
  static const String embedVideo = "Embed Video";
  static const String learningPath = "Learning Path";
  static const String learningModule = "Learning Module";
  static const String video = "Video";
  static const String microLearning = "MicroLearning";
  static const String pdf = "PDF";
  static const String word = "Word";
  static const String ppt = "PPT";
  static const String html = "Single HTML file";
  static const String assignment = "Assignment";
  static const String webPage = "Webpage";
  static const String audio = "Audio";
  static const String document = "Document";
  static const String excel = "Excel";
  static const String image = "Image";
  static const String test = "Test";
  static const String survey = "Survey";
  static const String url = "Url";
}

class UIControlTypes {
  static const List<int> textFieldTypeIds = <int>[
    singleLineTextField,
    emailTextField,
    uRLTextField,
    multiLineTextField,
    passwordField,
    phoneField,
    numericField,
  ];

  static const List<int> singleChoiceFromMultipleIds = <int>[
    dropDownList,
    checkBoxList,
    optionButtonList,
  ];

  static const List<int> dateFields = <int>[
    datePicker,
    customDateField,
    optionButtonList,
  ];

  static const int singleLineTextField = 1;
  static const int multiLineTextField = 2;
  static const int dropDownList = 3;
  static const int passwordField = 4;
  static const int simpleListBoxField = 5;
  static const int extendedListBoxField = 6;
  static const int fileInputField = 7;
  static const int datePicker = 8;
  static const int emailTextField = 9;
  static const int numericField = 10;
  static const int phoneField = 11;
  static const int checkBoxField = 12;
  static const int optionButtonField = 14;
  static const int uRLTextField = 15;
  static const int labelField = 16;
  static const int customDateField = 17;
  static const int checkBoxList = 18;
  static const int optionButtonList = 19;
  static const int certificationImage = 20;
  static const int radControl = 21;
  static const int timeField = 22;
  static const int windowProperties = 23;
  static const int decimalField = 24;
  static const int customUserControl = 25;
  static const int hiddenField = 26;
  static const int descriptionChoiceField = 27;
  static const int otherTextBox = 28;
  static const int radColorPicture = 29;
  static const int htmlTable = 30;
  static const int fileUploadControl = 31;
  static const int workHours = 33;
}

class InstancyObjectTypes {
  static const int none = 0;
  static const int user = 1;
  static const int cMGroup = 2;
  static const int organizationUnit = 3;
  static const int role = 4;
  static const int folder = 5;
  static const int userGroup = 6;
  static const int login = 7;
  static const int contentObject = 8;
  static const int assessment = 9;
  static const int track = 10;
  static const int mediaResource = 11;
  static const int textFile = 12;
  static const int fORM = 13;
  static const int document = 14;
  static const int links = 15;
  static const int announcements = 16;
  static const int discussionBoard = 17;
  static const int notifications = 19;
  static const int dictionaryGlossary = 20;
  static const int html = 21;
  static const int preferences = 22;
  static const int contentPreference = 22;
  static const int category = 23;
  static const int storyBoard = 24;
  static const int htmlModules = 25;
  static const int scorm1_2 = 26;
  static const int aICC = 27;
  static const int reference = 28;
  static const int usageReport = 29;
  static const int rankingReport = 30;
  static const int analysisReport = 31;
  static const int summaryReport = 32;
  static const int loginActivityReport = 33;
  static const int progressReport = 34;
  static const int siteActivityReport = 35;
  static const int webPage = 36;
  static const int webList = 37;
  static const int adminCatalog = 38;
  static const int workspace = 39;
  static const int folders = 40;
  static const int bookmark = 41;
  static const int profile = 42;
  static const int catalog = 43;
  static const int myCatalog = 44;
  static const int newsArticles = 45;
  static const int welcomeText = 46;
  static const int benefitsOfSubscription = 47;
  static const int myCart = 48;
  static const int categorizeComponent = 49;
  static const int knowledgeObject = 50;
  static const int skin = 51;
  static const int certificate = 52;
  static const int search = 53;
  static const int quickLinks = 63;
  static const int bannerAdd = 69;
  static const int events = 70;
  static const int productOffering = 79;
  static const int iltEvent = 89;
  static const int iltSession = 90;
  static const int location = 91;
  static const int affiliate = 92;
  static const int optin = 93;
  static const int contentItem = 101;
  static const int xApi = 102;
  static const int product = 500;
  static const int productGroup = 501;
  static const int zipCodes = 502;
  static const int sellingPoint = 600;
  static const int store = 601;
  static const int general = 614;
  static const int userAndContentAssignmentReport = 620;
  static const int eCommerce = 621;
  static const int tickers = 626;
  static const int catalogByTypes = 627;
  static const int tinCan = 102;
  static const int wiki = 640;
  static const int externalContent = 646;
  static const int forum = 652;
  static const int askTheExpert = 653;
  static const int questionResponses = 654;
  static const int externalTraining = 688;
  static const int physicalProduct = 689;
  static const int cmi5 = 693;
  static const int assignment = 694;
  static const int arModule = 695;
  static const int vrModule = 696;
  static const int courseBot = 697;
}

class InstancyMediaTypes {
  static const int none = 0;
  static const int image = 1;
  static const int flash = 2;
  static const int video = 3;
  static const int audio = 4;
  static const int onlineCourse = 5;
  static const int classroomCourse = 6;
  static const int virtualClassroom = 7;
  static const int word = 8;
  static const int pDF = 9;
  static const int excel = 10;
  static const int htmlObject = 11;
  static const int url = 13;
  static const int liveMeeting = 14;
  static const int recording = 15;
  static const int flashPackage = 16;
  static const int ppt = 17;
  static const int mpp = 18;
  static const int visioTypes = 19;
  static const int book = 20;
  static const int document = 21;
  static const int conference = 22;
  static const int videoReference = 23;
  static const int audioReference = 24;
  static const int webLink = 25;
  static const int blendedOnlineClassroom = 26;
  static const int test = 27;
  static const int survey = 28;
  static const int physicalProduct = 29;
  static const int scorm = 30;
  static const int scorm2004 = 31;
  static const int eBook = 32;
  static const int assessorService = 33;
  static const int externalSCORM = 34;
  static const int externalxAPI = 35;
  static const int externalDocument = 36;
  static const int externalMedia = 37;
  static const int externalTrackList = 38;
  static const int externalReference = 39;
  static const int htmlZIPFile = 40;
  static const int singleHTMLFile = 41;
  static const int imageReference = 42;
  static const int teachingSlidesReference = 43;
  static const int animationReference = 44;
  static const int cmi5 = 45;
  static const int classroomEvent = 46;
  static const int virtualClassroomEvent = 47;
  static const int networkingInPersonEvent = 48;
  static const int labInPersonEvent = 49;
  static const int projectInPersonEvent = 50;
  static const int fieldTripInPersonEvent = 51;
  static const int psyTechAssessment = 52;
  static const int dISCAssessment = 53;
  static const int corpAcademy = 54;
  static const int embedAudio = 57;
  static const int embedVideo = 58;
  static const int track = 59;
  static const int microLearning = 61;
  static const int learningModule = 62;
  static const int comingSoon = 63;
  static const int contactUs = 64;
  static const int assessment24x7 = 65;
  static const int threeDObject = 66;
  static const int threeDAvatar = 67;
}

/*
// For Mobile
class InstancyComponents {
  static const int MyLearning = 1;
  static const int Catalog = 2;
  static const int MyProfile = 3;
  static const int DiscussionForums = 4;
  static const int AskTheExpert = 5;
  static const int AppHome = 6;
  static const int WebPage = 7;
  static const int Events = 8;
  static const int LearningCommunities = 9;
  static const int People = 10;
  static const int MyCompetency = 11;
  static const int Leaderboard = 12;
  static const int MyAchievements = 13;
  static const int ProgressReport = 14;
  static const int Signup = 15;
  static const int HomeCategory = 16;
  static const int MyLearningPlus = 17;
  static const int DummyComponent = 18;
  static const int NewReleases = 19;
  static const int PopularContent = 20;
  static const int RecommendedLearningResources = 21;
  static const int RecentlyAcccessedContent = 22;
  static const int MyUpcomingEvents = 23;
  static const int SingleContentItem = 24;
  static const int Staticwebpage = 25;
  static const int NewsSlider = 26;
  static const int StaticHTMLContent = 51;
  static const int NewLearningResources = 301;
  static const int PopularLearningResources = 302;
  static const int PeopleList = 78;
  static const int PeopleListComponentInsId = 3473;
  static const int Details = 107;
  static const int DetailsComponentInsId = 3291;
}*/

class InstancyComponents {
  static const int Catalog = 1;
  static const int MyLearning = 3;
  static const int ContentManagementGroup = 4;
  static const int UserGroup = 5;
  static const int MyCart = 7;
  static const int Role = 11;
  static const int UserList = 12;
  static const int Links = 16;
  static const int Folders = 17;
  static const int AdminCatalog = 18;
  static const int Category = 19;
  static const int Bookmark = 20;
  static const int ReportByUser = 33;
  static const int ReportByContent = 34;
  static const int ReportByOU = 35;
  static const int DiscussionBoard = 38;
  static const int CMSReportByContent = 40;
  static const int CMSReportByUser = 41;
  static const int MostRecent = 42;
  static const int QuickLinks = 43;
  static const int KnowledgeObject = 43;
  static const int CMGroupUserList = 47;
  static const int NewSignUpForm = 47;
  static const int Events = 50;
  static const int StaticHTMLContent = 51;
  static const int supplier = 69;
  static const int UserMessages = 75;
  static const int Affiliates = 76;
  static const int PeopleList = 78;
  static const int Blog = 81;
  static const int ILTRegistrations = 82;
  static const int Subscription = 93;
  static const int LearningPortalsList = 97;
  static const int CreateLearningPortal = 98;
  static const int LPPendingRequests = 99;
  static const int MyProfilePhoto = 100;
  static const int MyProfileDetails = 101;
  static const int EditProfile = 102;
  static const int Details = 107;
  static const int JobRoles = 109;
  static const int EventCalender = 110;
  static const int UserAssignContent = 111;
  static const int Grade = 112;
  static const int CreateSite = 113;
  static const int SitesListing = 114;
  static const int ContactUs = 115;
  static const int FeaturedCategories = 116;
  static const int HomepageSearch = 117;
  static const int FeaturedContent = 118;
  static const int UserLicenseInformation = 119;
  static const int CustomSearch = 120;
  static const int ECommerce = 123;
  static const int EventWaitList = 132;
  static const int ContentManagement = 151;
  static const int CatalogEvents = 153;
  static const int MyProfile = 160;
  static const int AskTheExpert = 161;
  static const int LRSAllActivities = 179;
  static const int Wiki = 181;
  static const int SplashSearchForm = 187;
  static const int MiniCatalog = 188;
  static const int Communities = 189;
  static const int PopularTopics = 190;
  static const int RSSDisplay = 191;
  static const int News = 192;
  static const int SuggestedLearning = 199;
  static const int NewsSlider = 203;
  static const int NewsSliderLD = 208;
  static const int NewsSliderDiscover = 209;
  static const int SubSiteNewsSlider = 211;
  static const int GlobalSearchResults = 225;
  static const int ProgressReport = 238;
  static const int MyQuiz = 251;
  static const int FeaturedCourses = 265;
  static const int MultiWebPageRenderControl = 281;
  static const int Login = 24;
  static const int LeftNavigation = 1001;
  static const int UserMembership = 1002;
  static const int ProfileImageEditor = 1003;
  static const int userNotificationComponent = 1004;
  static const int myConnectionActivityComponent = 1005;
  static const int reviewProfileFieldsComponent = 1006;
  static const int DueDates = 234;
  static const int NewLearningResources = 301;
  static const int PopularLearningResources = 302;
  static const int RecommendedLearningResources = 303;
  static const int MyLearningPlus = 315;
  static const int siteOrientationComponent = 1007;
  static const int headerComponent = 1008;
  static const int myProfileComponent = 1009;
  static const int ajaxCourseComponent = 1010;
  static const int DetailsComponentInsId = 3291;
  static const int PeopleListComponentInsId = 3473;
  static const int EventCatalogTabsListComponentInsId = 3497;
}

class ViewTypesForContent {
  //Direct View
  static const int View = 1;

  //Add To MyLearning
  static const int Subscription = 2;

  //Add To Cart
  static const int ECommerce = 3;

  //We will show "view" to user,
  //But will first Add this content to myLearning and then Launch It
  static const int ViewAndAddToMyLearning = 5;
}

enum InstancyIconType { shareWithConnection, shareViaEmail, shareWithPeople, pause, archived }

class ContentFilterByTypes {
  static const String SortItems = "Sortitemsby";
  static const String sortItems = "sortitemsby";
  static const String categories = "categories";
  static const String skills = "skills";
  static const String objecttypeid = "objecttypeid";
  static const String job = "job";
  static const String jobroles = "jobroles";
  static const String locations = "locations";
  static const String userinfo = "userinfo";
  static const String company = "company";
  static const String solutions = "solutions";
  static const String learningprovider = "learningprovider";
  static const String ecommerceprice = "ecommerceprice";
  static const String rating = "rating";
  static const String locationname = "locationname";
  static const String eventduration = "eventduration";
  static const String instructor = "instructor";
  static const String eventdates = "eventdates";
  static const String creditpoints = "creditpoints";
}

class InstancyIcons {
  static final IconData view = IconDataSolid(int.parse('0xf06e'));
  static final IconData details = IconDataSolid(int.parse('0xf570'));
  static final IconData play = IconDataSolid(int.parse('0xf144'));
  static final IconData join = IconDataSolid(int.parse('0xf234'));
  static final IconData addToCalender = IconDataSolid(int.parse('0xf271'));
  static const IconData relatedContent = Icons.content_copy;
  static const IconData notes = Icons.note_add;
  static const IconData cancelEnrollment = Icons.cancel;
  static final IconData archieve = IconDataSolid(int.parse('0xf187'));
  static final IconData remove = IconDataSolid(int.parse('0xf056'));
  static final IconData qrCode = IconDataSolid(int.parse('0xf029'));
  static final IconData viewSessions = IconDataSolid(int.parse('0xf63d'));
  static final IconData viewRecording = IconDataSolid(int.parse('0xf8d9'));
  static final IconData reschedule = IconDataSolid(int.parse('0xf783'));
  static final IconData ReEnrollmentHistory = IconDataSolid(int.parse('0xf783'));
  static final IconData RecommendTo = IconDataSolid(int.parse('0xf1e0'));
  static final IconData shareWithConnection = IconDataSolid(int.parse('0xf1e0'));
  static final IconData shareWithPeople = IconDataSolid(int.parse('0xf079'));
  static final IconData waitList = IconDataSolid(int.parse('0xf144'));
  static final IconData download = IconDataSolid(int.parse('0xf144'));
  static final IconData delete = IconDataSolid(int.parse('0xf144'));
  static final IconData buy = IconDataSolid(int.parse('0xf144'));
  static const IconData share = Icons.share;
  static const IconData addToMyLearning = Icons.add_circle;
  static const IconData addToWishlist = Icons.favorite_border;
  static const IconData removeFromWishlist = Icons.favorite;
  static const IconData viewProfile = Icons.account_circle;
  static const IconData viewResources = Icons.content_copy;
}

class InstancySVGImages {
  static const String report = "assets/Report.svg";
  static const String setComplete = "assets/SetComplete.svg";
  static const String certificate = "assets/Certificate.svg";
}

enum ShareContentType {
  catalogCourse,
  discussionForum,
  askTheExpertQuestion,
}

class InstancyContentPrerequisiteType {
  static const int recommended = 1;
  static const int required = 2;
  static const int completion = 3;
}

enum InstancyImagePickSource {
  camera,
  gallery,
}

enum InstancyFilePickType {
  any,
  media,
  image,
  video,
  audio,
  custom,
}

class MyCatalogPrivileges {
  static int view = 386;
  static int viewByCategory = 503;
  static int viewByType = 504;
  static int viewByMostRecent = 505;
  static int showViewLink = 1070;
  static int showDetailsLink = 1071;
  static int showReportlink = 1072;
  static int showSetCompletedlink = 1073;
  static int showDiscussionFormlink = 1074;
  static int showNotelink = 1075;
  static int showRelatedContentlink = 1076;
  static int downloadCalender = 1169;
}

class EventTrackTabs {
  static const String overview = "TOverview";
  static const String trackContents = "TContent";
  static const String eventContents = "EContent";
  static const String trackAssignments = "TAssignment";
  static const String eventAssignments = "EAssignment";
  static const String discussions = "TDiscussion";
  static const String resources = "TResource";
  static const String people = "TPeople";
  static const String gloassary = "TGlossary";
  static const String session = "ESessions";
}

class ContentStatusTypes {
  static const String passed = "passed";
  static const String failed = "failed";
  static const String completed = "completed";
  static const String incomplete = "incomplete";
  static const String notAttempted = "not attempted";
  static const String registered = "registered";
  static const String notregistered = "notregistered";
  static const String notattended = "notattended";
  static const String attended = "attended";
  static const String testedOut = "tested out";
  static const String inProgress = "in progress";
  static const String grade = "grade";
}

class TrackResourceType {
  static const String url = "url";
  static const String mediaResource = "Media resource";
  static const String document = "Document";
}

class ContentAddLinkOperations {
  static const String redirecttodetails = "redirecttodetails";
  static const String addrecommenedrelatedcontent = "addrecommenedrelatedcontent";
}

class NotificationTypes {
  static const int Reminder1 = 1;
  static const int Reminder2 = 2;
  static const int Reminder3 = 3;
  static const int MissedDates = 4;
  static const int General = 5;
  static const int Approved = 6;
  static const int Rejected = 7;
  static const int Published = 8;
  static const int SubmitforApproval = 9;
  static const int AssignedToMyCatalog = 10;
  static const int NewInCatalog = 11;
  static const int UnassignFromMyCatalog = 12;
  static const int Recall = 13;
  static const int Rollback = 14;
  static const int CourseExpiry = 15;
  static const int SubscriptionExpiry = 16;
  static const int Announcements = 17;
  static const int NewsArticles = 18;
  static const int WelcomeMessage = 19;
  static const int BenifitsofSubscription = 20;
  static const int DirectPublish = 21;
  static const int NewInDiscussionThread = 22;
  static const int NewEventPresentationRequest = 23;
  static const int CancellationOFPresentation = 24;
  static const int PasswordExpiryReminder = 25;
  static const int UserLocked = 26;
  static const int NotifyAdministrativelyChanged = 27;
  static const int AccountExpiry = 28;
  static const int ForumNotification = 30;
  static const int NewConnectionRequest = 31;
  static const int MembershipRenewalReminder = 32;
  static const int EventReminder = 33;
  static const int UserRegistrationRequest = 34;
  static const int RetakeAssessment = 35;
  static const int GroupExiryNotification = 38;
  static const int GroupExiryReminder = 39;
  static const int GroupUserLimitExceededNotification = 40;
  static const int RecommendedContentNotification = 42;
  static const int ContentReAssignment = 43;
  static const int ForumCommentNotification = 44;
  static const int ApproveWaitlistedOnlineEventRegistration = 45;
  static const int ApproveWaitlistedOfflineEventRegistration = 46;
  static const int ConfirmingEnrollmentReminder = 47;
  static const int ContentRelease = 48;
  static const int AskTheExpertQueNotification = 60;
  static const int AskTHeExpertResponseNotification = 61;
  static const int TodaysLearning = 17;
}

class EventTypes {
  static const int regular = 1;
  static const int session = 2;
}

class EventScheduleTypes {
  static const int regular = 0;
  static const int parent = 1;
  static const int instance = 2;
}

class EventCatalogTabTypes {
  static const String upcomingCourses = "Upcoming-Courses";
  static const String calendarSchedule = "Calendar-Schedule";
  static const String calendarView = "Calendar-View";
  static const String pastCourses = "Past-Courses";
  static const String myEvents = "My-Events";
  static const String additionalProgramDetails = "Additional-Program-Details";

  static List<String> get values => [
        upcomingCourses,
        calendarSchedule,
        calendarView,
        pastCourses,
        myEvents,
        additionalProgramDetails,
      ];
}

abstract class AppFlavour {
  static const String marketPlace = 'MarketPlace';
  static const String playGround = 'PlayGround';
}

class MessageType {
  static const String Text = "Text";
  static const String Image = "Image";
  static const String Audio = "Audio";
  static const String Video = "Video";
  static const String Doc = "Doc";

  static List<String> get values => [
        MessageType.Text,
        MessageType.Image,
        MessageType.Audio,
        MessageType.Video,
        MessageType.Doc,
      ];
}

class ContentTypeCategoryId {
  static const String image = "M1";
  static const String video = "M3";
  static const String threeDObject = "M66";
  static const String threeDAvatar = "M67";
  static const String arModule = "695";
  static const String vrModule = "696";
}

class ARVRContentLaunchTypes {
  static const String launchInAR = "launchInAR";
  static const String launchInVR = "launchInVR";
}

class ARContentSceneTypes {
  static const int imageTracking = 1;
  static const int groundTracking = 2;
  static const int qrCode = 3;
}

class ARContentMeshTypes {
  static const String text = "text";
  static const String image = "image";
  static const String video = "video";
  static const String audio = "audio";
  static const String button = "button";
  static const String sphere = "sphere";
  static const String hotspot = "hotspot";
  static const String glb = "glb";
  static const String gltf = "gltf";
}

class ARContentBGVRType {
  static const String image_360 = "image_360";
  static const String video_360 = "video_360";
}


class MessageRoleTypes {
  static const int learner = 5;
  static const int admin = 8;
  static const int manager = 12;
  static const int groupAdmin = 16;
}

class RoleFilterType {
  static const String all = "All";
  static const String admin = "Admin";
  static const String groupAdmin = "Group Admin";
  static const String manager = "Manager";
  static const String learner = "Learner";

  static List<String> get values => [
        all,
        admin,
        groupAdmin,
        manager,
        learner,
      ];
}

// "Archive","All Message","Unread","My Connection"
class MessageFilterType {
  static const String all = "All Message";
  static const String archive = "Archive";
  static const String unRead = "Unread";
  static const String myConnection = "My Connection";

  static List<String> get values => [
        all,
        archive,
        unRead,
        myConnection,
      ];
}

class MessageStatusTypes {
  static const String typing = "Typing..";
  static const String online = "Online";
}
