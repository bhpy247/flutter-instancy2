import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../../backend/configurations/app_configuration_operations.dart';
import '../../classroom_events/data_model/EventRecordingDetailsModel.dart';

class CourseDTOModel {
  String SiteName = "";
  String ContentID = "";
  String Title = "";
  String ContentName = "";
  String ShortDescription = "";
  String ThumbnailImagePath = "";
  String InstanceParentContentID = "";
  String ImageWithLink = "";
  String AuthorWithLink = "";
  String DurationEndDate = "";
  String EventStartDateTime = "";
  String EventEndDateTime = "";
  String EventStartDateTimeWithoutConvert = "";
  String EventEndDateTimeTimeWithoutConvert = "";
  String expandiconpath = "";
  String AuthorDisplayName = "";
  String ContentType = "";
  String CreatedOn = "";
  String TimeZone = "";
  String Tags = "";
  String SalePrice = "";
  String Currency = "";
  String ViewLink = "";
  String DetailsLink = "";
  String RelatedContentLink = "";
  String ViewSessionsLink = "";
  String SuggesttoConnLink = "";
  String SuggestwithFriendLink = "";
  String SharetoRecommendedLink = "";
  String IsCoursePackage = "";
  String IsRelatedcontent = "";
  String isaddtomylearninglogo = "";
  String LocationName = "";
  String BuildingName = "";
  String JoinURL = "";
  String Categorycolor = "";
  String InvitationURL = "";
  String HeaderLocationName = "";
  String SubSiteUserID = "";
  String PresenterDisplayName = "";
  String PresenterWithLink = "";
  String AuthorName = "";
  String FreePrice = "";
  String BuyNowLink = "";
  String ThumbnailIconPath = "";
  String salepricestrikeoff = "";
  String Sharelink = "";
  String CreditScoreWithCreditTypes = "";
  String CreditScoreFirstPrefix = "";
  String isEnrollFutureInstance = "";
  String InstanceEventReclass = "";
  String InstanceEventReclassStatus = "";
  String InstanceEventReSchedule = "";
  String InstanceEventEnroll = "";
  String ReEnrollmentHistory = "";
  String BackGroundColor = "";
  String FontColor = "";
  String ExpiredContentExpiryDate = "";
  String ExpiredContentAvailableUntill = "";
  String Gradient1 = "";
  String Gradient2 = "";
  String GradientColor = "";
  String ShareContentwithUser = "";
  String startpage = "";
  String jwstartpage = "";
  String AddLinkTitle = "";
  String ContentStatus = "";
  String PercentCompletedClass = "";
  String JWVideoKey = "";
  String ActualStatus = "";
  String CoreLessonStatus = "";
  String FolderPath = "";
  String ActivityId = "";
  String Titlewithlink = "";
  String rcaction = "";
  String Categories = "";
  String IsSubSite = "";
  String MembershipName = "";
  String EventAvailableSeats = "";
  String EventCompletedProgress = "";
  String EventContentProgress = "";
  String PreviewLink = "";
  String ApproveLink = "";
  String RejectLink = "";
  String ReadLink = "";
  String AddLink = "";
  String EnrollNowLink = "";
  String CancelEventLink = "";
  String WaitListLink = "";
  String InapppurchageLink = "";
  String AlredyinmylearnigLink = "";
  String RecommendedLink = "";
  String EditMetadataLink = "";
  String ReplaceLink = "";
  String EditLink = "";
  String DeleteLink = "";
  String SampleContentLink = "";
  String TitleExpired = "";
  String PracticeAssessmentsAction = "";
  String CreateAssessmentAction = "";
  String OverallProgressReportAction = "";
  String ContentScoID = "";
  String ContentViewType = "";
  String WindowProperties = "";
  String AddtoWishList = "";
  String RemoveFromWishList = "";
  String Duration = "";
  String Credits = "";
  String DetailspopupTags = "";
  String Modules = "";
  String EnrollmentLimit = "";
  String AvailableSeats = "";
  String NoofUsersEnrolled = "";
  String EventStartDateforEnroll = "";
  String DownLoadLink = "";
  String PrerequisiteDateConflictName = "";
  String PrerequisiteDateConflictDateTime = "";
  String isContentEnrolled = "";
  String Expired = "";
  String ReportLink = "";
  String DiscussionsLink = "";
  String CertificateLink = "";
  String NotesLink = "";
  String RepurchaseLink = "";
  String SetcompleteLink = "";
  String ViewRecordingLink = "";
  String InstructorCommentsLink = "";
  String DownloadCalender = "";
  String EventScheduleLink = "";
  String EventScheduleStatus = "";
  String EventScheduleConfirmLink = "";
  String EventScheduleCancelLink = "";
  String EventScheduleReserveTime = "";
  String EventScheduleReserveStatus = "";
  String ReScheduleEvent = "";
  String Addorremoveattendees = "";
  String CancelScheduleEvent = "";
  String SurveyLink = "";
  String RemoveLink = "";
  String RatingLink = "";
  String TitleName = "";
  String CancelOrderData = "";
  String ActionViewQRcode = "";
  String SkinID = "";
  String Location = "";
  String strCatalogContentRemoved = "";
  String Presentername = "";
  String PresenterLink = "";
  String DirectionURL = "";
  String LongDescription = "";
  String ErrorMesage = "";
  String CancelEventlink = "";
  String AddPastLink = "";
  String ShowReadMore = "";
  String SetCompleteAction = "";
  String TitleWithlink = "";
  String ImageWithlink = "";
  String ShowThumbnailImagePath = "";
  String AutolaunchViewLink = "";
  String TitleViewlink = "";
  String NotifyMessage = "";
  String LearningObjectives = "";
  String TableofContent = "";
  String ThumbnailVideoPath = "";
  String SubTitleTag = "";
  String islearningcontent = "";
  String RedirectinstanceID = "";
  String DownloadLink = "";
  String QRImageName = "";
  String UserProfileImagePath = "";
  String GoogleProductId = "";
  String ItunesProductId = "";
  int WaitListLimit = 0;
  int WaitListEnrolls = 0;
  int FilterId = 0;
  int SiteId = 0;
  int UserSiteId = 0;
  int ContentTypeId = 0;
  int SiteUserID = 0;
  int ScoID = 0;
  int MediaTypeID = -1;
  int EventType = 0;
  int EventScheduleType = 0;
  int ViewType = 0;
  int CategoryID = 0;
  int TotalRatings = 0;
  int Count = 0;
  int isWishListContent = 0;
  int PresenterID = 0;
  int Prerequisites = 0;
  int AttemptsLeft = 0;
  int Required = 0;
  int TypeofEvent = 0;
  double PercentCompleted = 0;
  double RatingID = 0;
  bool ShowMembershipExpiryAlert = false;
  bool bit5 = false;
  bool OpenNewBrowserWindow = false;
  bool bit1 = false;
  bool isBadCancellationEnabled = false;
  bool isBookingOpened = false;
  bool EventRecording = false;
  bool ShowParentPrerequisiteEventDate = false;
  bool ShowPrerequisiteEventDate = false;
  bool IsLearnerContent = false;
  bool CombinedTransaction = false;
  bool IsViewReview = false;
  bool IsArchived = false;
  bool SubSiteMemberShipExpiried = false;
  bool ShowLearnerActions = false;
  bool isShowEventFullStatus = false;
  bool IsSuccess = false;
  bool NoRecord = false;
  bool showSchedule = false;
  EventRecordingDetailsModel? RecordingDetails;
  dynamic bit4;

  CourseDTOModel({
    this.SiteName = "",
    this.ContentID = "",
    this.Title = "",
    this.ContentName = "",
    this.ShortDescription = "",
    this.ThumbnailImagePath = "",
    this.InstanceParentContentID = "",
    this.ImageWithLink = "",
    this.AuthorWithLink = "",
    this.DurationEndDate = "",
    this.EventStartDateTime = "",
    this.EventEndDateTime = "",
    this.EventStartDateTimeWithoutConvert = "",
    this.EventEndDateTimeTimeWithoutConvert = "",
    this.expandiconpath = "",
    this.AuthorDisplayName = "",
    this.ContentType = "",
    this.CreatedOn = "",
    this.TimeZone = "",
    this.Tags = "",
    this.SalePrice = "",
    this.Currency = "",
    this.ViewLink = "",
    this.DetailsLink = "",
    this.RelatedContentLink = "",
    this.ViewSessionsLink = "",
    this.SuggesttoConnLink = "",
    this.SuggestwithFriendLink = "",
    this.SharetoRecommendedLink = "",
    this.IsCoursePackage = "",
    this.IsRelatedcontent = "",
    this.isaddtomylearninglogo = "",
    this.LocationName = "",
    this.BuildingName = "",
    this.JoinURL = "",
    this.Categorycolor = "",
    this.InvitationURL = "",
    this.HeaderLocationName = "",
    this.SubSiteUserID = "",
    this.PresenterDisplayName = "",
    this.PresenterWithLink = "",
    this.AuthorName = "",
    this.FreePrice = "",
    this.BuyNowLink = "",
    this.ThumbnailIconPath = "",
    this.salepricestrikeoff = "",
    this.Sharelink = "",
    this.CreditScoreWithCreditTypes = "",
    this.CreditScoreFirstPrefix = "",
    this.isEnrollFutureInstance = "",
    this.InstanceEventReclass = "",
    this.InstanceEventReclassStatus = "",
    this.InstanceEventReSchedule = "",
    this.InstanceEventEnroll = "",
    this.ReEnrollmentHistory = "",
    this.BackGroundColor = "",
    this.FontColor = "",
    this.ExpiredContentExpiryDate = "",
    this.ExpiredContentAvailableUntill = "",
    this.Gradient1 = "",
    this.Gradient2 = "",
    this.GradientColor = "",
    this.ShareContentwithUser = "",
    this.startpage = "",
    this.jwstartpage = "",
    this.AddLinkTitle = "",
    this.ContentStatus = "",
    this.PercentCompletedClass = "",
    this.JWVideoKey = "",
    this.ActualStatus = "",
    this.CoreLessonStatus = "",
    this.FolderPath = "",
    this.ActivityId = "",
    this.Titlewithlink = "",
    this.rcaction = "",
    this.Categories = "",
    this.IsSubSite = "",
    this.MembershipName = "",
    this.EventAvailableSeats = "",
    this.EventCompletedProgress = "",
    this.EventContentProgress = "",
    this.PreviewLink = "",
    this.ApproveLink = "",
    this.RejectLink = "",
    this.ReadLink = "",
    this.AddLink = "",
    this.EnrollNowLink = "",
    this.CancelEventLink = "",
    this.WaitListLink = "",
    this.InapppurchageLink = "",
    this.AlredyinmylearnigLink = "",
    this.RecommendedLink = "",
    this.EditMetadataLink = "",
    this.ReplaceLink = "",
    this.EditLink = "",
    this.DeleteLink = "",
    this.SampleContentLink = "",
    this.TitleExpired = "",
    this.PracticeAssessmentsAction = "",
    this.CreateAssessmentAction = "",
    this.OverallProgressReportAction = "",
    this.ContentScoID = "",
    this.ContentViewType = "",
    this.WindowProperties = "",
    this.AddtoWishList = "",
    this.RemoveFromWishList = "",
    this.Duration = "",
    this.Credits = "",
    this.DetailspopupTags = "",
    this.Modules = "",
    this.EnrollmentLimit = "",
    this.AvailableSeats = "",
    this.NoofUsersEnrolled = "",
    this.EventStartDateforEnroll = "",
    this.DownLoadLink = "",
    this.PrerequisiteDateConflictName = "",
    this.PrerequisiteDateConflictDateTime = "",
    this.SkinID = "",
    this.Location = "",
    this.isContentEnrolled = "",
    this.Expired = "",
    this.ReportLink = "",
    this.DiscussionsLink = "",
    this.CertificateLink = "",
    this.NotesLink = "",
    this.RepurchaseLink = "",
    this.SetcompleteLink = "",
    this.ViewRecordingLink = "",
    this.InstructorCommentsLink = "",
    this.DownloadCalender = "",
    this.EventScheduleLink = "",
    this.EventScheduleStatus = "",
    this.EventScheduleConfirmLink = "",
    this.EventScheduleCancelLink = "",
    this.EventScheduleReserveTime = "",
    this.EventScheduleReserveStatus = "",
    this.ReScheduleEvent = "",
    this.Addorremoveattendees = "",
    this.CancelScheduleEvent = "",
    this.SurveyLink = "",
    this.RemoveLink = "",
    this.RatingLink = "",
    this.TitleName = "",
    this.CancelOrderData = "",
    this.ActionViewQRcode = "",
    this.strCatalogContentRemoved = "",
    this.Presentername = "",
    this.PresenterLink = "",
    this.DirectionURL = "",
    this.LongDescription = "",
    this.ErrorMesage = "",
    this.CancelEventlink = "",
    this.AddPastLink = "",
    this.ShowReadMore = "",
    this.SetCompleteAction = "",
    this.TitleWithlink = "",
    this.ImageWithlink = "",
    this.ShowThumbnailImagePath = "",
    this.UserProfileImagePath = "",
    this.AutolaunchViewLink = "",
    this.TitleViewlink = "",
    this.NotifyMessage = "",
    this.LearningObjectives = "",
    this.TableofContent = "",
    this.ThumbnailVideoPath = "",
    this.SubTitleTag = "",
    this.islearningcontent = "",
    this.RedirectinstanceID = "",
    this.DownloadLink = "",
    this.QRImageName = "",
    this.GoogleProductId = "",
    this.ItunesProductId = "",
    this.WaitListLimit = 0,
    this.WaitListEnrolls = 0,
    this.FilterId = 0,
    this.SiteId = 0,
    this.UserSiteId = 0,
    this.ContentTypeId = 0,
    this.SiteUserID = 0,
    this.ScoID = 0,
    this.MediaTypeID = -1,
    this.EventType = 0,
    this.EventScheduleType = 0,
    this.ViewType = 0,
    this.CategoryID = 0,
    this.TotalRatings = 0,
    this.PercentCompleted = 0,
    this.RatingID = 0,
    this.Count = 0,
    this.isWishListContent = 0,
    this.PresenterID = 0,
    this.Prerequisites = 0,
    this.AttemptsLeft = 0,
    this.Required = 0,
    this.TypeofEvent = 0,
    this.ShowMembershipExpiryAlert = false,
    this.bit5 = false,
    this.OpenNewBrowserWindow = false,
    this.bit1 = false,
    this.isBadCancellationEnabled = false,
    this.isBookingOpened = false,
    this.EventRecording = false,
    this.ShowParentPrerequisiteEventDate = false,
    this.ShowPrerequisiteEventDate = false,
    this.IsLearnerContent = false,
    this.CombinedTransaction = false,
    this.IsViewReview = false,
    this.IsArchived = false,
    this.SubSiteMemberShipExpiried = false,
    this.ShowLearnerActions = false,
    this.isShowEventFullStatus = false,
    this.IsSuccess = false,
    this.NoRecord = false,
    this.showSchedule = false,
    this.RecordingDetails,
    this.bit4,
  });

  CourseDTOModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    SiteName = ParsingHelper.parseStringMethod(map["SiteName"]);
    ContentID = ParsingHelper.parseStringMethod(map["ContentID"]);
    Title = ParsingHelper.parseStringMethod(map["Title"]);
    ContentName = ParsingHelper.parseStringMethod(map["ContentName"]);
    TotalRatings = ParsingHelper.parseIntMethod(["TotalRatings"]);
    ShortDescription = ParsingHelper.parseStringMethod(map["ShortDescription"]);
    ThumbnailImagePath = ParsingHelper.parseStringMethod(map["ThumbnailImagePath"]);
    InstanceParentContentID = ParsingHelper.parseStringMethod(map["InstanceParentContentID"]);
    ImageWithLink = ParsingHelper.parseStringMethod(map["ImageWithLink"]);
    AuthorWithLink = ParsingHelper.parseStringMethod(map["AuthorWithLink"]);
    DurationEndDate = ParsingHelper.parseStringMethod(map["DurationEndDate"]);
    EventStartDateTime = ParsingHelper.parseStringMethod(map["EventStartDateTime"]);
    EventEndDateTime = ParsingHelper.parseStringMethod(map["EventEndDateTime"]);
    EventStartDateTimeWithoutConvert = ParsingHelper.parseStringMethod(map["EventStartDateTimeWithoutConvert"]);
    EventEndDateTimeTimeWithoutConvert = ParsingHelper.parseStringMethod(map["EventEndDateTimeTimeWithoutConvert"]);
    expandiconpath = ParsingHelper.parseStringMethod(map["expandiconpath"]);
    AuthorDisplayName = ParsingHelper.parseStringMethod(map["AuthorDisplayName"]);
    ContentType = ParsingHelper.parseStringMethod(map["ContentType"]);
    CreatedOn = ParsingHelper.parseStringMethod(map["CreatedOn"]);
    TimeZone = ParsingHelper.parseStringMethod(map["TimeZone"]);
    Tags = ParsingHelper.parseStringMethod(map["Tags"]);
    SalePrice = ParsingHelper.parseStringMethod(map["SalePrice"]);
    Currency = ParsingHelper.parseStringMethod(map["Currency"]);
    ViewLink = ParsingHelper.parseStringMethod(map["ViewLink"]);
    DetailsLink = ParsingHelper.parseStringMethod(map["DetailsLink"]);
    RelatedContentLink = ParsingHelper.parseStringMethod(map["RelatedContentLink"]);
    ViewSessionsLink = ParsingHelper.parseStringMethod(map["ViewSessionsLink"]);
    SuggesttoConnLink = ParsingHelper.parseStringMethod(map["SuggesttoConnLink"]);
    SuggestwithFriendLink = ParsingHelper.parseStringMethod(map["SuggestwithFriendLink"]);
    SharetoRecommendedLink = ParsingHelper.parseStringMethod(map["SharetoRecommendedLink"]);
    IsCoursePackage = ParsingHelper.parseStringMethod(map["IsCoursePackage"]);
    IsRelatedcontent = ParsingHelper.parseStringMethod(map["IsRelatedcontent"]);
    isaddtomylearninglogo = ParsingHelper.parseStringMethod(map["isaddtomylearninglogo"]);
    LocationName = ParsingHelper.parseStringMethod(map["LocationName"]);
    BuildingName = ParsingHelper.parseStringMethod(map["BuildingName"]);
    JoinURL = ParsingHelper.parseStringMethod(map["JoinURL"]);
    Categorycolor = ParsingHelper.parseStringMethod(map["Categorycolor"]);
    InvitationURL = ParsingHelper.parseStringMethod(map["InvitationURL"]);
    HeaderLocationName = ParsingHelper.parseStringMethod(map["HeaderLocationName"]);
    SubSiteUserID = ParsingHelper.parseStringMethod(map["SubSiteUserID"]);
    PresenterDisplayName = ParsingHelper.parseStringMethod(map["PresenterDisplayName"]);
    PresenterWithLink = ParsingHelper.parseStringMethod(map["PresenterWithLink"]);
    AuthorName = ParsingHelper.parseStringMethod(map["AuthorName"]);
    FreePrice = ParsingHelper.parseStringMethod(map["FreePrice"]);
    BuyNowLink = ParsingHelper.parseStringMethod(map["BuyNowLink"]);
    ThumbnailIconPath = ParsingHelper.parseStringMethod(map["ThumbnailIconPath"]);
    salepricestrikeoff = ParsingHelper.parseStringMethod(map["salepricestrikeoff"]);
    Sharelink = ParsingHelper.parseStringMethod(map["Sharelink"]);
    CreditScoreWithCreditTypes = ParsingHelper.parseStringMethod(map["CreditScoreWithCreditTypes"]);
    CreditScoreFirstPrefix = ParsingHelper.parseStringMethod(map["CreditScoreFirstPrefix"]);
    isEnrollFutureInstance = ParsingHelper.parseStringMethod(map["isEnrollFutureInstance"]);
    InstanceEventReclass = ParsingHelper.parseStringMethod(map["InstanceEventReclass"]);
    InstanceEventReclassStatus = ParsingHelper.parseStringMethod(map["InstanceEventReclassStatus"]);
    InstanceEventReSchedule = ParsingHelper.parseStringMethod(map["InstanceEventReSchedule"]);
    InstanceEventEnroll = ParsingHelper.parseStringMethod(map["InstanceEventEnroll"]);
    ReEnrollmentHistory = ParsingHelper.parseStringMethod(map["ReEnrollmentHistory"]);
    BackGroundColor = ParsingHelper.parseStringMethod(map["BackGroundColor"]);
    FontColor = ParsingHelper.parseStringMethod(map["FontColor"]);
    ExpiredContentExpiryDate = ParsingHelper.parseStringMethod(map["ExpiredContentExpiryDate"]);
    ExpiredContentAvailableUntill = ParsingHelper.parseStringMethod(map["ExpiredContentAvailableUntill"]);
    Gradient1 = ParsingHelper.parseStringMethod(map["Gradient1"]);
    Gradient2 = ParsingHelper.parseStringMethod(map["Gradient2"]);
    GradientColor = ParsingHelper.parseStringMethod(map["GradientColor"]);
    ShareContentwithUser = ParsingHelper.parseStringMethod(map["ShareContentwithUser"]);
    startpage = ParsingHelper.parseStringMethod(map["startpage"]);
    jwstartpage = ParsingHelper.parseStringMethod(map["jwstartpage"]);
    AddLinkTitle = ParsingHelper.parseStringMethod(map["AddLinkTitle"]);
    ContentStatus = ParsingHelper.parseStringMethod(map["ContentStatus"]);
    PercentCompletedClass = ParsingHelper.parseStringMethod(map["PercentCompletedClass"]);
    JWVideoKey = ParsingHelper.parseStringMethod(map["JWVideoKey"]);
    ActualStatus = ParsingHelper.parseStringMethod(map["ActualStatus"]);
    CoreLessonStatus = ParsingHelper.parseStringMethod(map["CoreLessonStatus"]);
    FolderPath = ParsingHelper.parseStringMethod(map["FolderPath"]);
    ActivityId = ParsingHelper.parseStringMethod(map["ActivityId"]);
    Titlewithlink = ParsingHelper.parseStringMethod(map['Titlewithlink']);
    rcaction = ParsingHelper.parseStringMethod(map['rcaction']);
    Categories = ParsingHelper.parseStringMethod(map['Categories']);
    IsSubSite = ParsingHelper.parseStringMethod(map['IsSubSite']);
    MembershipName = ParsingHelper.parseStringMethod(map['MembershipName']);
    EventAvailableSeats = ParsingHelper.parseStringMethod(map['EventAvailableSeats']);
    EventCompletedProgress = ParsingHelper.parseStringMethod(map['EventCompletedProgress']);
    EventContentProgress = ParsingHelper.parseStringMethod(map['EventContentProgress']);
    PreviewLink = ParsingHelper.parseStringMethod(map['PreviewLink']);
    ApproveLink = ParsingHelper.parseStringMethod(map['ApproveLink']);
    RejectLink = ParsingHelper.parseStringMethod(map['RejectLink']);
    ReadLink = ParsingHelper.parseStringMethod(map['ReadLink']);
    AddLink = ParsingHelper.parseStringMethod(map['AddLink']);
    EnrollNowLink = ParsingHelper.parseStringMethod(map['EnrollNowLink']);
    CancelEventLink = ParsingHelper.parseStringMethod(map['CancelEventLink']);
    WaitListLink = ParsingHelper.parseStringMethod(map['WaitListLink']);
    InapppurchageLink = ParsingHelper.parseStringMethod(map['InapppurchageLink']);
    AlredyinmylearnigLink = ParsingHelper.parseStringMethod(map['AlredyinmylearnigLink']);
    RecommendedLink = ParsingHelper.parseStringMethod(map['RecommendedLink']);
    EditMetadataLink = ParsingHelper.parseStringMethod(map['EditMetadataLink']);
    ReplaceLink = ParsingHelper.parseStringMethod(map['ReplaceLink']);
    EditLink = ParsingHelper.parseStringMethod(map['EditLink']);
    DeleteLink = ParsingHelper.parseStringMethod(map['DeleteLink']);
    SampleContentLink = ParsingHelper.parseStringMethod(map['SampleContentLink']);
    TitleExpired = ParsingHelper.parseStringMethod(map['TitleExpired']);
    PracticeAssessmentsAction = ParsingHelper.parseStringMethod(map['PracticeAssessmentsAction']);
    CreateAssessmentAction = ParsingHelper.parseStringMethod(map['CreateAssessmentAction']);
    OverallProgressReportAction = ParsingHelper.parseStringMethod(map['OverallProgressReportAction']);
    ContentScoID = ParsingHelper.parseStringMethod(map['ContentScoID']);
    ContentViewType = ParsingHelper.parseStringMethod(map['ContentViewType']);
    WindowProperties = ParsingHelper.parseStringMethod(map['WindowProperties']);
    AddtoWishList = ParsingHelper.parseStringMethod(map['AddtoWishList']);
    RemoveFromWishList = ParsingHelper.parseStringMethod(map['RemoveFromWishList']);
    Duration = ParsingHelper.parseStringMethod(map['Duration']);
    Credits = ParsingHelper.parseStringMethod(map['Credits']);
    DetailspopupTags = ParsingHelper.parseStringMethod(map['DetailspopupTags']);
    Modules = ParsingHelper.parseStringMethod(map['Modules']);
    EnrollmentLimit = ParsingHelper.parseStringMethod(map['EnrollmentLimit']);
    AvailableSeats = ParsingHelper.parseStringMethod(map['AvailableSeats']);
    NoofUsersEnrolled = ParsingHelper.parseStringMethod(map['NoofUsersEnrolled']);
    EventStartDateforEnroll = ParsingHelper.parseStringMethod(map['EventStartDateforEnroll']);
    DownLoadLink = ParsingHelper.parseStringMethod(map['DownLoadLink']);
    PrerequisiteDateConflictName = ParsingHelper.parseStringMethod(map['PrerequisiteDateConflictName']);
    PrerequisiteDateConflictDateTime = ParsingHelper.parseStringMethod(map['PrerequisiteDateConflictDateTime']);
    SkinID = ParsingHelper.parseStringMethod(map['SkinID']);
    Location = ParsingHelper.parseStringMethod(map['Location']);
    isContentEnrolled = ParsingHelper.parseStringMethod(map['isContentEnrolled']);
    Expired = ParsingHelper.parseStringMethod(map["Expired"]);
    ReportLink = ParsingHelper.parseStringMethod(map["ReportLink"]);
    DiscussionsLink = ParsingHelper.parseStringMethod(map["DiscussionsLink"]);
    CertificateLink = ParsingHelper.parseStringMethod(map["CertificateLink"]);
    NotesLink = ParsingHelper.parseStringMethod(map["NotesLink"]);
    RepurchaseLink = ParsingHelper.parseStringMethod(map["RepurchaseLink"]);
    SetcompleteLink = ParsingHelper.parseStringMethod(map["SetcompleteLink"]);
    ViewRecordingLink = ParsingHelper.parseStringMethod(map["ViewRecordingLink"]);
    InstructorCommentsLink = ParsingHelper.parseStringMethod(map["InstructorCommentsLink"]);
    DownloadCalender = ParsingHelper.parseStringMethod(map["DownloadCalender"]);
    EventScheduleLink = ParsingHelper.parseStringMethod(map["EventScheduleLink"]);
    EventScheduleStatus = ParsingHelper.parseStringMethod(map["EventScheduleStatus"]);
    EventScheduleConfirmLink = ParsingHelper.parseStringMethod(map["EventScheduleConfirmLink"]);
    EventScheduleCancelLink = ParsingHelper.parseStringMethod(map["EventScheduleCancelLink"]);
    EventScheduleReserveTime = ParsingHelper.parseStringMethod(map["EventScheduleReserveTime"]);
    EventScheduleReserveStatus = ParsingHelper.parseStringMethod(map["EventScheduleReserveStatus"]);
    ReScheduleEvent = ParsingHelper.parseStringMethod(map["ReScheduleEvent"]);
    Addorremoveattendees = ParsingHelper.parseStringMethod(map["Addorremoveattendees"]);
    CancelScheduleEvent = ParsingHelper.parseStringMethod(map["CancelScheduleEvent"]);
    SurveyLink = ParsingHelper.parseStringMethod(map["SurveyLink"]);
    RemoveLink = ParsingHelper.parseStringMethod(map["RemoveLink"]);
    RatingLink = ParsingHelper.parseStringMethod(map["RatingLink"]);
    TitleName = ParsingHelper.parseStringMethod(map["TitleName"]);
    CancelOrderData = ParsingHelper.parseStringMethod(map["CancelOrderData"]);
    ActionViewQRcode = ParsingHelper.parseStringMethod(map["ActionViewQRcode"]);
    strCatalogContentRemoved = ParsingHelper.parseStringMethod(map["strCatalogContentRemoved"]);
    Presentername = ParsingHelper.parseStringMethod(map["Presentername"]);
    PresenterLink = ParsingHelper.parseStringMethod(map["PresenterLink"]);
    DirectionURL = ParsingHelper.parseStringMethod(map["DirectionURL"]);
    LongDescription = ParsingHelper.parseStringMethod(map["LongDescription"]);
    ErrorMesage = ParsingHelper.parseStringMethod(map["ErrorMesage"]);
    AddPastLink = ParsingHelper.parseStringMethod(map["AddPastLink"]);
    ShowReadMore = ParsingHelper.parseStringMethod(map["ShowReadMore"]);
    SetCompleteAction = ParsingHelper.parseStringMethod(map["SetCompleteAction"]);
    UserProfileImagePath = ParsingHelper.parseStringMethod(map["UserProfileImagePath"]);
    TitleWithlink = ParsingHelper.parseStringMethod(map["TitleWithlink"]);
    ImageWithlink = ParsingHelper.parseStringMethod(map["ImageWithlink"]);
    ShowThumbnailImagePath = ParsingHelper.parseStringMethod(map["ShowThumbnailImagePath"]);
    SurveyLink = ParsingHelper.parseStringMethod(map["SurveyLink"]);
    NotesLink = ParsingHelper.parseStringMethod(map["NotesLink"]);
    WaitListLink = ParsingHelper.parseStringMethod(map["WaitListLink"]);
    DiscussionsLink = ParsingHelper.parseStringMethod(map["DiscussionsLink"]);
    ContentViewType = ParsingHelper.parseStringMethod(map["ContentViewType"]);
    WindowProperties = ParsingHelper.parseStringMethod(map["WindowProperties"]);
    AutolaunchViewLink = ParsingHelper.parseStringMethod(map["AutolaunchViewLink"]);
    TitleViewlink = ParsingHelper.parseStringMethod(map["TitleViewlink"]);
    NotifyMessage = ParsingHelper.parseStringMethod(map["NotifyMessage"]);
    LearningObjectives = ParsingHelper.parseStringMethod(map["LearningObjectives"]);
    TableofContent = ParsingHelper.parseStringMethod(map["TableofContent"]);
    ThumbnailVideoPath = ParsingHelper.parseStringMethod(map["ThumbnailVideoPath"]);
    SubTitleTag = ParsingHelper.parseStringMethod(map["SubTitleTag"]);
    islearningcontent = ParsingHelper.parseStringMethod(map["islearningcontent"]);
    RedirectinstanceID = ParsingHelper.parseStringMethod(map["RedirectinstanceID"]);
    ActionViewQRcode = ParsingHelper.parseStringMethod(map["ActionViewQRcode"]);
    EnrollmentLimit = ParsingHelper.parseStringMethod(map["EnrollmentLimit"]);
    NoofUsersEnrolled = ParsingHelper.parseStringMethod(map["NoofUsersEnrolled"]);
    jwstartpage = ParsingHelper.parseStringMethod(map["jwstartpage"]);
    QRImageName = ParsingHelper.parseStringMethod(map["QRImageName"]);
    SkinID = ParsingHelper.parseStringMethod(map["SkinID"]);
    SampleContentLink = ParsingHelper.parseStringMethod(map["SampleContentLink"]);
    GoogleProductId = ParsingHelper.parseStringMethod(map["GoogleProductId"]);
    ItunesProductId = ParsingHelper.parseStringMethod(map["ItunesProductId"]);
    PercentCompleted = ParsingHelper.parseDoubleMethod(map["PercentCompleted"]);
    WaitListLimit = ParsingHelper.parseIntMethod(map['WaitListLimit']);
    WaitListEnrolls = ParsingHelper.parseIntMethod(map['WaitListEnrolls']);
    FilterId = ParsingHelper.parseIntMethod(map["FilterId"]);
    SiteId = ParsingHelper.parseIntMethod(map["SiteId"]);
    UserSiteId = ParsingHelper.parseIntMethod(map["UserSiteId"]);
    ContentTypeId = ParsingHelper.parseIntMethod(map["ContentTypeId"]);
    SiteUserID = ParsingHelper.parseIntMethod(map["SiteUserID"]);
    ScoID = ParsingHelper.parseIntMethod(map["ScoID"]);
    MediaTypeID = ParsingHelper.parseIntMethod(map["MediaTypeID"], defaultValue: -1);
    EventType = ParsingHelper.parseIntMethod(map["EventType"]);
    EventScheduleType = ParsingHelper.parseIntMethod(map["EventScheduleType"]);
    ViewType = ParsingHelper.parseIntMethod(map["ViewType"]);
    CategoryID = ParsingHelper.parseIntMethod(map["CategoryID"]);
    isContentEnrolled = ParsingHelper.parseStringMethod(map['isContentEnrolled']);
    Count = ParsingHelper.parseIntMethod(map['Count']);
    isWishListContent = ParsingHelper.parseIntMethod(map['isWishListContent']);
    PresenterID = ParsingHelper.parseIntMethod(map['PresenterID']);
    Prerequisites = ParsingHelper.parseIntMethod(map['Prerequisites']);
    AttemptsLeft = ParsingHelper.parseIntMethod(map["AttemptsLeft"]);
    Required = ParsingHelper.parseIntMethod(map["Required"]);
    TypeofEvent = ParsingHelper.parseIntMethod(map["TypeofEvent"]);
    RatingID = ParsingHelper.parseDoubleMethod(map["RatingID"]);
    ShowMembershipExpiryAlert = ParsingHelper.parseBoolMethod(map["ShowMembershipExpiryAlert"]);
    bit5 = ParsingHelper.parseBoolMethod(map["bit5"]);
    OpenNewBrowserWindow = ParsingHelper.parseBoolMethod(map["OpenNewBrowserWindow"]);
    bit1 = ParsingHelper.parseBoolMethod(map["bit1"]);
    isBadCancellationEnabled = ParsingHelper.parseBoolMethod(map['isBadCancellationEnabled']);
    isBookingOpened = ParsingHelper.parseBoolMethod(map['isBookingOpened']);
    EventRecording = ParsingHelper.parseBoolMethod(map['EventRecording']);
    ShowParentPrerequisiteEventDate = ParsingHelper.parseBoolMethod(map['ShowParentPrerequisiteEventDate']);
    ShowPrerequisiteEventDate = ParsingHelper.parseBoolMethod(map['ShowPrerequisiteEventDate']);
    IsLearnerContent = ParsingHelper.parseBoolMethod(map['IsLearnerContent']);
    CombinedTransaction = ParsingHelper.parseBoolMethod(map["CombinedTransaction"]);
    IsViewReview = ParsingHelper.parseBoolMethod(map["IsViewReview"]);
    IsArchived = ParsingHelper.parseBoolMethod(map["IsArchived"]);
    SubSiteMemberShipExpiried = ParsingHelper.parseBoolMethod(map["SubSiteMemberShipExpiried"]);
    ShowLearnerActions = ParsingHelper.parseBoolMethod(map["ShowLearnerActions"]);
    isShowEventFullStatus = ParsingHelper.parseBoolMethod(map["isShowEventFullStatus"]);
    IsSuccess = ParsingHelper.parseBoolMethod(map["IsSuccess"]);
    NoRecord = ParsingHelper.parseBoolMethod(map["NoRecord"]);
    showSchedule = ParsingHelper.parseBoolMethod(map["showSchedule"]);

    RecordingDetails = null;
    Map<String, dynamic> recordingDetailsMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(map['RecordingDetails']);
    if (recordingDetailsMap.isNotEmpty) RecordingDetails = EventRecordingDetailsModel.fromMap(recordingDetailsMap);

    bit4 = map["bit4"];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "SiteName": SiteName,
      "ContentID": ContentID,
      "Title": Title,
      "ContentName": ContentName,
      "TotalRatings": TotalRatings,
      "ShortDescription": ShortDescription,
      "ThumbnailImagePath": ThumbnailImagePath,
      "InstanceParentContentID": InstanceParentContentID,
      "ImageWithLink": ImageWithLink,
      "AuthorWithLink": AuthorWithLink,
      "DurationEndDate": DurationEndDate,
      "EventStartDateTime": EventStartDateTime,
      "EventEndDateTime": EventEndDateTime,
      "EventStartDateTimeWithoutConvert": EventStartDateTimeWithoutConvert,
      "EventEndDateTimeTimeWithoutConvert": EventEndDateTimeTimeWithoutConvert,
      "expandiconpath": expandiconpath,
      "AuthorDisplayName": AuthorDisplayName,
      "ContentType": ContentType,
      "CreatedOn": CreatedOn,
      "TimeZone": TimeZone,
      "Tags": Tags,
      "SalePrice": SalePrice,
      "Currency": Currency,
      "ViewLink": ViewLink,
      "DetailsLink": DetailsLink,
      "RelatedContentLink": RelatedContentLink,
      "ViewSessionsLink": ViewSessionsLink,
      "SuggesttoConnLink": SuggesttoConnLink,
      "SuggestwithFriendLink": SuggestwithFriendLink,
      "SharetoRecommendedLink": SharetoRecommendedLink,
      "IsCoursePackage": IsCoursePackage,
      "IsRelatedcontent": IsRelatedcontent,
      "isaddtomylearninglogo": isaddtomylearninglogo,
      "LocationName": LocationName,
      "BuildingName": BuildingName,
      "JoinURL": JoinURL,
      "Categorycolor": Categorycolor,
      "InvitationURL": InvitationURL,
      "HeaderLocationName": HeaderLocationName,
      "SubSiteUserID": SubSiteUserID,
      "PresenterDisplayName": PresenterDisplayName,
      "PresenterWithLink": PresenterWithLink,
      "AuthorName": AuthorName,
      "FreePrice": FreePrice,
      "BuyNowLink": BuyNowLink,
      "ThumbnailIconPath": ThumbnailIconPath,
      "salepricestrikeoff": salepricestrikeoff,
      "Sharelink": Sharelink,
      "CreditScoreWithCreditTypes": CreditScoreWithCreditTypes,
      "CreditScoreFirstPrefix": CreditScoreFirstPrefix,
      "isEnrollFutureInstance": isEnrollFutureInstance,
      "InstanceEventReclass": InstanceEventReclass,
      "InstanceEventReclassStatus": InstanceEventReclassStatus,
      "InstanceEventReSchedule": InstanceEventReSchedule,
      "InstanceEventEnroll": InstanceEventEnroll,
      "ReEnrollmentHistory": ReEnrollmentHistory,
      "BackGroundColor": BackGroundColor,
      "FontColor": FontColor,
      "ExpiredContentExpiryDate": ExpiredContentExpiryDate,
      "ExpiredContentAvailableUntill": ExpiredContentAvailableUntill,
      "Gradient1": Gradient1,
      "Gradient2": Gradient2,
      "GradientColor": GradientColor,
      "ShareContentwithUser": ShareContentwithUser,
      "startpage": startpage,
      "jwstartpage": jwstartpage,
      "AddLinkTitle": AddLinkTitle,
      "ContentStatus": ContentStatus,
      "PercentCompletedClass": PercentCompletedClass,
      "JWVideoKey": JWVideoKey,
      "ActualStatus": ActualStatus,
      "CoreLessonStatus": CoreLessonStatus,
      "FolderPath": FolderPath,
      "ActivityId": ActivityId,
      "Titlewithlink": Titlewithlink,
      "rcaction": rcaction,
      "Categories": Categories,
      "IsSubSite": IsSubSite,
      "MembershipName": MembershipName,
      "EventAvailableSeats": EventAvailableSeats,
      "EventCompletedProgress": EventCompletedProgress,
      "EventContentProgress": EventContentProgress,
      "PreviewLink": PreviewLink,
      "ApproveLink": ApproveLink,
      "RejectLink": RejectLink,
      "ReadLink": ReadLink,
      "AddLink": AddLink,
      "EnrollNowLink": EnrollNowLink,
      "CancelEventLink": CancelEventLink,
      "WaitListLink": WaitListLink,
      "InapppurchageLink": InapppurchageLink,
      "AlredyinmylearnigLink": AlredyinmylearnigLink,
      "RecommendedLink": RecommendedLink,
      "EditMetadataLink": EditMetadataLink,
      "ReplaceLink": ReplaceLink,
      "EditLink": EditLink,
      "DeleteLink": DeleteLink,
      "SampleContentLink": SampleContentLink,
      "TitleExpired": TitleExpired,
      "PracticeAssessmentsAction": PracticeAssessmentsAction,
      "CreateAssessmentAction": CreateAssessmentAction,
      "OverallProgressReportAction": OverallProgressReportAction,
      "ContentScoID": ContentScoID,
      "ContentViewType": ContentViewType,
      "WindowProperties": WindowProperties,
      "AddtoWishList": AddtoWishList,
      "RemoveFromWishList": RemoveFromWishList,
      "Duration": Duration,
      "Credits": Credits,
      "DetailspopupTags": DetailspopupTags,
      "Modules": Modules,
      "EnrollmentLimit": EnrollmentLimit,
      "AvailableSeats": AvailableSeats,
      "NoofUsersEnrolled": NoofUsersEnrolled,
      "EventStartDateforEnroll": EventStartDateforEnroll,
      "DownLoadLink": DownLoadLink,
      "PrerequisiteDateConflictName": PrerequisiteDateConflictName,
      "PrerequisiteDateConflictDateTime": PrerequisiteDateConflictDateTime,
      "SkinID": SkinID,
      "Location": Location,
      "isContentEnrolled": isContentEnrolled,
      "strCatalogContentRemoved": strCatalogContentRemoved,
      "Presentername": Presentername,
      "PresenterLink": PresenterLink,
      "DirectionURL": DirectionURL,
      "LongDescription": LongDescription,
      "ErrorMesage": ErrorMesage,
      "CancelEventlink": CancelEventlink,
      "DownloadCalender": DownloadCalender,
      "AddPastLink": AddPastLink,
      "EventScheduleLink": EventScheduleLink,
      "EventScheduleStatus": EventScheduleStatus,
      "EventScheduleConfirmLink": EventScheduleConfirmLink,
      "EventScheduleCancelLink": EventScheduleCancelLink,
      "EventScheduleReserveTime": EventScheduleReserveTime,
      "EventScheduleReserveStatus": EventScheduleReserveStatus,
      "ReScheduleEvent": ReScheduleEvent,
      "Addorremoveattendees": Addorremoveattendees,
      "CancelScheduleEvent": CancelScheduleEvent,
      "ShowReadMore": ShowReadMore,
      "SetCompleteAction": SetCompleteAction,
      "TitleName": TitleName,
      "UserProfileImagePath": UserProfileImagePath,
      "TitleWithlink": TitleWithlink,
      "ImageWithlink": ImageWithlink,
      "ShowThumbnailImagePath": ShowThumbnailImagePath,
      "CertificateLink": CertificateLink,
      "SurveyLink": SurveyLink,
      "NotesLink": NotesLink,
      "DiscussionsLink": DiscussionsLink,
      "AutolaunchViewLink": AutolaunchViewLink,
      "TitleViewlink": TitleViewlink,
      "NotifyMessage": NotifyMessage,
      "LearningObjectives": LearningObjectives,
      "TableofContent": TableofContent,
      "ThumbnailVideoPath": ThumbnailVideoPath,
      "SubTitleTag": SubTitleTag,
      "islearningcontent": islearningcontent,
      "RedirectinstanceID": RedirectinstanceID,
      "ActionViewQRcode": ActionViewQRcode,
      "DownloadLink": DownloadLink,
      "QRImageName": QRImageName,
      "Expired": Expired,
      "ReportLink": ReportLink,
      "RepurchaseLink": RepurchaseLink,
      "SetcompleteLink": SetcompleteLink,
      "ViewRecordingLink": ViewRecordingLink,
      "InstructorCommentsLink": InstructorCommentsLink,
      "RemoveLink": RemoveLink,
      "RatingLink": RatingLink,
      "CancelOrderData": CancelOrderData,
      "GoogleProductId": GoogleProductId,
      "ItunesProductId": ItunesProductId,
      "PercentCompleted": PercentCompleted,
      "WaitListLimit": WaitListLimit,
      "WaitListEnrolls": WaitListEnrolls,
      "FilterId": FilterId,
      "SiteId": SiteId,
      "UserSiteId": UserSiteId,
      "ContentTypeId": ContentTypeId,
      "SiteUserID": SiteUserID,
      "ScoID": ScoID,
      "MediaTypeID": MediaTypeID,
      "EventType": EventType,
      "EventScheduleType": EventScheduleType,
      "ViewType": ViewType,
      "CategoryID": CategoryID,
      "Count": Count,
      "isWishListContent": isWishListContent,
      "PresenterID": PresenterID,
      "Prerequisites": Prerequisites,
      "AttemptsLeft": AttemptsLeft,
      "Required": Required,
      "TypeofEvent": TypeofEvent,
      "RatingID": RatingID,
      "ShowMembershipExpiryAlert": ShowMembershipExpiryAlert,
      "bit5": bit5,
      "OpenNewBrowserWindow": OpenNewBrowserWindow,
      "bit1": bit1,
      "isBadCancellationEnabled": isBadCancellationEnabled,
      "isBookingOpened": isBookingOpened,
      "EventRecording": EventRecording,
      "ShowParentPrerequisiteEventDate": ShowParentPrerequisiteEventDate,
      "ShowPrerequisiteEventDate": ShowPrerequisiteEventDate,
      "IsLearnerContent": IsLearnerContent,
      "CombinedTransaction": CombinedTransaction,
      "IsViewReview": IsViewReview,
      "IsArchived": IsArchived,
      "SubSiteMemberShipExpiried": SubSiteMemberShipExpiried,
      "ShowLearnerActions": ShowLearnerActions,
      "isShowEventFullStatus": isShowEventFullStatus,
      "IsSuccess": IsSuccess,
      "NoRecord": NoRecord,
      "showSchedule": showSchedule,
      "RecordingDetails": RecordingDetails?.toMap(),
      "bit4": bit4,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }

  bool hasPrerequisiteContents() {
    return AppConfigurationOperations.hasPrerequisiteContents(AddLink);
  }
}