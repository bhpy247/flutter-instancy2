import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_instancy_2/backend/ask_the_expert/ask_the_expert_provider.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_provider.dart';
import 'package:flutter_instancy_2/backend/discussion/discussion_provider.dart';
import 'package:flutter_instancy_2/backend/gamification/gamification_provider.dart';
import 'package:flutter_instancy_2/backend/global_search/global_search_provider.dart';
import 'package:flutter_instancy_2/backend/in_app_purchase/in_app_purchase_provider.dart';
import 'package:flutter_instancy_2/backend/lens_feature/lens_provider.dart';
import 'package:flutter_instancy_2/backend/membership/membership_provider.dart';
import 'package:flutter_instancy_2/backend/my_connections/my_connections_provider.dart';
import 'package:flutter_instancy_2/backend/profile/profile_provider.dart';
import 'package:flutter_instancy_2/backend/ui_actions/primary_secondary_actions/primary_secondary_actions.dart';
import 'package:flutter_instancy_2/backend/wiki_component/wiki_provider.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/native_menu_component_model.dart';
import 'package:flutter_instancy_2/models/ask_the_expert/data_model/ask_the_expert_dto.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/co_create_content_authoring_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/flashcards/data_model/flashcard_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/micro_learning_model/data_model/micro_learning_content_model.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/models/course_launch/data_model/course_launch_model.dart';
import 'package:flutter_instancy_2/models/membership/data_model/membership_plan_details_model.dart';
import 'package:flutter_instancy_2/models/message/data_model/chat_user_model.dart';
import 'package:flutter_instancy_2/models/profile/data_model/user_experience_data_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';

import '../../api/api_controller.dart';
import '../../configs/app_constants.dart';
import '../../models/app/data_model/dynamic_tabs_dto_model.dart';
import '../../models/app_configuration_models/data_models/component_configurations_model.dart';
import '../../models/catalog/catalogCategoriesForBrowseModel.dart';
import '../../models/discussion/data_model/forum_model.dart';
import '../../models/discussion/data_model/topic_model.dart';
import '../../models/filter/data_model/content_filter_category_tree_model.dart';
import '../../models/profile/data_model/user_education_data_model.dart';
import '../Catalog/catalog_provider.dart';
import '../event/event_provider.dart';
import '../event_track/event_track_provider.dart';
import '../filter/filter_provider.dart';
import '../instabot/instabot_provider.dart';
import '../my_learning/my_learning_provider.dart';
import '../share/share_provider.dart';

class NavigationArguments extends Equatable {
  const NavigationArguments();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordNavigationArguments extends NavigationArguments {
  final String email;

  const ForgotPasswordNavigationArguments({
    required this.email,
  });
}

class AddWikiContentScreenNavigationArguments extends NavigationArguments {
  final String title;
  final int objectTypeId, mediaTypeId;

  const AddWikiContentScreenNavigationArguments({
    required this.title,
    required this.objectTypeId,
    required this.mediaTypeId,
  });
}

class FiltersScreenNavigationArguments extends NavigationArguments {
  final int componentId;
  final FilterProvider filterProvider;
  final ComponentConfigurationsModel componentConfigurationsModel;
  final String? contentFilterByTypes;

  const FiltersScreenNavigationArguments({
    required this.componentId,
    required this.filterProvider,
    required this.componentConfigurationsModel,
    this.contentFilterByTypes,
  });
}

class WishListScreenNavigationArguments extends NavigationArguments {
  final int componentId;
  final int componentInstanceId;
  final CatalogProvider? catalogProvider;

  const WishListScreenNavigationArguments({
    required this.componentId,
    required this.componentInstanceId,
    this.catalogProvider,
  });
}

class GlobalSearchScreenNavigationArguments extends NavigationArguments {
  final int componentId;
  final int componentInsId;
  final FilterProvider filterProvider;
  final ComponentConfigurationsModel componentConfigurationsModel;
  final String componentName;
  final String searchString;
  final GlobalSearchProvider? globalSearchProvider;

  const GlobalSearchScreenNavigationArguments(
      {required this.componentId,
      required this.componentInsId,
      required this.filterProvider,
      required this.componentConfigurationsModel,
      required this.componentName,
      this.searchString = "",
      this.globalSearchProvider});
}

class SortingScreenNavigationArguments extends NavigationArguments {
  final int componentId;
  final FilterProvider filterProvider;

  const SortingScreenNavigationArguments({
    required this.componentId,
    required this.filterProvider,
  });
}

class CatalogSubcategoriesListScreenNavigationArguments extends NavigationArguments {
  final int componentId, componentInstanceId;
  final CatalogProvider? provider;
  final List<CatalogCategoriesForBrowseModel> categoriesListForPath;
  final List<CatalogCategoriesForBrowseModel> subcategories;

  const CatalogSubcategoriesListScreenNavigationArguments({
    required this.componentInstanceId,
    required this.componentId,
    this.provider,
    required this.categoriesListForPath,
    required this.subcategories,
  });
}

class MyLearningWaitlistScreenNavigationArguments extends NavigationArguments {
  final int componentId, componentInstanceId;
  final MyLearningProvider? myLearningProvider;
  final NativeMenuComponentModel? componentModel;

  const MyLearningWaitlistScreenNavigationArguments({
    required this.componentId,
    required this.componentInstanceId,
    this.myLearningProvider,
    this.componentModel,
  });
}

class ViewCompletionCertificateScreenNavigationArguments extends NavigationArguments {
  final String contentId, certificateId, certificatePage;

  const ViewCompletionCertificateScreenNavigationArguments({
    required this.contentId,
    required this.certificateId,
    required this.certificatePage,
  });
}

class QRCodeImageScreenNavigationArguments extends NavigationArguments {
  final String qrCodePath;

  const QRCodeImageScreenNavigationArguments({
    required this.qrCodePath,
  });
}

class ShareWithConnectionsScreenNavigationArguments extends NavigationArguments {
  final ShareContentType shareContentType;
  final String contentId;
  final String contentName;
  final String topicId;
  final int forumId;
  final int scoId;
  final int objecttypeId;
  final int questionId;
  final int? responseId;
  final ShareProvider? shareProvider;

  const ShareWithConnectionsScreenNavigationArguments({
    required this.shareContentType,
    this.contentId = '',
    this.contentName = "",
    this.topicId = "",
    this.forumId = 0,
    this.scoId = 0,
    this.questionId = 0,
    this.responseId,
    this.objecttypeId = 0,
    this.shareProvider,
  });
}

class ShareWithPeopleScreenNavigationArguments extends NavigationArguments {
  final ShareContentType shareContentType;
  final String contentId;
  final String contentName;
  final String topicId;
  final int forumId;
  final int scoId;
  final int objecttypeId;
  final int? responseId;
  final int questionId;
  final bool isSuggestToConnections;
  final List<int>? userIds;

  const ShareWithPeopleScreenNavigationArguments({
    required this.shareContentType,
    this.contentId = "",
    this.contentName = "",
    this.topicId = "",
    this.forumId = 0,
    this.scoId = 0,
    this.questionId = 0,
    this.objecttypeId = 0,
    this.responseId,
    this.isSuggestToConnections = false,
    this.userIds,
  });
}

class RecommendToScreenNavigationArguments extends NavigationArguments {
  final ShareContentType shareContentType;
  final String contentId;
  final String contentName;
  final String topicId;
  final int forumId;
  final int componentId;
  final bool isSuggestToConnections;
  final List<int>? userIds;
  final ShareProvider? shareProvider;

  const RecommendToScreenNavigationArguments({
    required this.shareContentType,
    this.contentId = "",
    this.contentName = "",
    this.topicId = "",
    this.forumId = 0,
    this.componentId = 0,
    this.isSuggestToConnections = false,
    this.userIds,
    this.shareProvider,
  });
}

class MyLearningContentProgressScreenNavigationArguments extends NavigationArguments {
  final String contentId;
  final CourseDTOModel? courseDTOModel;
  final int userId;
  final int contentTypeId;
  final int componentId;
  final String trackId;
  final String eventId;
  final String seqId;

  const MyLearningContentProgressScreenNavigationArguments({
    required this.contentId,
    this.courseDTOModel,
    required this.userId,
    required this.contentTypeId,
    required this.componentId,
    this.trackId = "",
    this.eventId = "",
    this.seqId = "-1",
  });
}

class CourseDetailScreenNavigationArguments extends NavigationArguments {
  final String contentId;
  final String parentEventId;
  final String parentTrackId;
  final int componentId;
  final int componentInstanceId;
  final int? userId;
  final int? siteId;
  final bool isFromCatalog;
  final bool isConsolidated;
  final bool isRescheduleEvent;
  final bool isReEnroll;
  final bool isFromMyKnowledge;
  final InstancyContentScreenType screenType;
  final MyLearningProvider? myLearningProvider;
  final CatalogProvider? catalogProvider;
  final ApiController? apiController;
  final CourseDTOModel? courseDtoModel;

  const CourseDetailScreenNavigationArguments(
      {required this.contentId,
      this.parentEventId = "",
      this.parentTrackId = "",
      required this.componentId,
      required this.componentInstanceId,
      required this.userId,
      this.isFromCatalog = false,
      this.isConsolidated = false,
      this.isRescheduleEvent = false,
      this.isFromMyKnowledge = false,
      this.isReEnroll = false,
      this.screenType = InstancyContentScreenType.Catalog,
      this.myLearningProvider,
      this.catalogProvider,
      this.apiController,
      this.siteId,
      this.courseDtoModel});
}

class PreRequisiteScreenNavigationArguments extends NavigationArguments {
  final String contentId;
  final int componentId;
  final int componentInstanceId;
  final bool isFromCatalog;
  final bool isConsolidated;
  final int selectedSequencePathId;
  final List<int>? sequencePathIdsList;

  const PreRequisiteScreenNavigationArguments({
    required this.contentId,
    required this.componentId,
    required this.componentInstanceId,
    required this.selectedSequencePathId,
    this.sequencePathIdsList,
    this.isFromCatalog = false,
    this.isConsolidated = false,
  });
}

class AddEditExperienceScreenNavigationArguments extends NavigationArguments {
  final UserExperienceDataModel? userExperienceDataModel;

  const AddEditExperienceScreenNavigationArguments({
    this.userExperienceDataModel,
  });
}

class AddEducationScreenNavigationArguments extends NavigationArguments {
  final UserEducationDataModel? userEducationDataModel;
  final ProfileProvider? profileProvider;

  const AddEducationScreenNavigationArguments({
    this.userEducationDataModel,
    this.profileProvider,
  });
}

class CourseLaunchWebViewScreenNavigationArguments extends NavigationArguments {
  final String courseUrl;
  final String courseName;
  final int? contentTypeId;

  const CourseLaunchWebViewScreenNavigationArguments({
    required this.courseUrl,
    required this.courseName,
    this.contentTypeId,
  });
}

class CourseOfflineLaunchWebViewScreenNavigationArguments extends NavigationArguments {
  final String coursePath;
  final String courseDirectoryPath;
  final String courseName;
  final CourseLaunchModel courseLaunchModel;
  final int? contentTypeId;

  const CourseOfflineLaunchWebViewScreenNavigationArguments({
    required this.coursePath,
    required this.courseDirectoryPath,
    required this.courseName,
    required this.courseLaunchModel,
    this.contentTypeId,
  });
}

class VideoLaunchScreenNavigationArguments extends NavigationArguments {
  final bool isNetworkVideo;
  final String contntName;
  final String videoUrl;
  final String videoFilePath;
  final Uint8List? videoFileBytes;

  const VideoLaunchScreenNavigationArguments({
    this.isNetworkVideo = true,
    this.contntName = "",
    this.videoUrl = "",
    this.videoFilePath = "",
    this.videoFileBytes,
  });

  @override
  String toString() {
    return "VideoLaunchScreenNavigationArguments({${MyUtils.encodeJson({
          "isNetworkVideo": isNetworkVideo,
          "contntName": contntName,
          "videoUrl": videoUrl,
          "videoFilePath": videoFilePath,
          "videoFileBytes": videoFileBytes?.length,
        })})";
  }
}

class PDFLaunchScreenNavigationArguments extends NavigationArguments {
  final bool isNetworkPDF;
  final String contntName;
  final String pdfUrl;
  final String pdfFilePath;
  final Uint8List? pdfFileBytes;

  const PDFLaunchScreenNavigationArguments({
    this.isNetworkPDF = true,
    this.contntName = "",
    this.pdfUrl = "",
    this.pdfFilePath = "",
    this.pdfFileBytes,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "isNetworkPDF": isNetworkPDF,
      "contntName": contntName,
      "pdfUrl": pdfUrl,
      "pdfFilePath": pdfFilePath,
      "pdfFileBytes": pdfFileBytes?.length,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}

class RolePlayLaunchScreenNavigationArguments extends NavigationArguments {
  final CourseDTOModel? courseDTOModel;

  const RolePlayLaunchScreenNavigationArguments({
    this.courseDTOModel,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "courseDTOModel": courseDTOModel?.toMap(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}

class RolePlayPreviewScreenNavigationArguments extends NavigationArguments {
  final CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  const RolePlayPreviewScreenNavigationArguments({
    required this.coCreateContentAuthoringModel,
  });
}

class ArticleScreenNavigationArguments extends NavigationArguments {
  final CourseDTOModel? courseDTOModel;

  const ArticleScreenNavigationArguments({
    this.courseDTOModel,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "courseDTOModel": courseDTOModel?.toMap(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}

class WebViewScreenNavigationArguments extends NavigationArguments {
  final String title;
  final String url;
  final bool isFromAuthoringTool;

  const WebViewScreenNavigationArguments({
    required this.title,
    required this.url,
    this.isFromAuthoringTool = false,
  });
}

class EventTrackScreenArguments extends NavigationArguments {
  final String parentContentId;
  final int componentId;
  final int componentInstanceId;
  final int objectTypeId;
  final int scoId;
  final bool isRelatedContent;
  final bool isContentEnrolled;
  final bool isLoadDataFromOffline;
  final String? eventTrackTabType;
  final CourseDTOModel? eventTrackContentModel;
  final EventTrackProvider? eventTrackProvider;

  const EventTrackScreenArguments({
    required this.parentContentId,
    required this.componentId,
    required this.componentInstanceId,
    required this.objectTypeId,
    required this.isRelatedContent,
    required this.isContentEnrolled,
    this.isLoadDataFromOffline = false,
    required this.scoId,
    this.eventTrackTabType,
    this.eventTrackContentModel,
    this.eventTrackProvider,
  });
}

class UserProfileScreenNavigationArguments extends NavigationArguments {
  final ProfileProvider? profileProvider;
  final bool isFromProfile;
  final int userId;
  final int componentId;
  final int componentInstanceId;

  const UserProfileScreenNavigationArguments({
    required this.profileProvider,
    this.isFromProfile = false,
    required this.userId,
    this.componentId = -1,
    this.componentInstanceId = -1,
  });
}

class ConnectionProfileScreenNavigationArguments extends NavigationArguments {
  final ProfileProvider? profileProvider;
  final int userId;
  final int componentId;
  final int componentInstanceId;

  const ConnectionProfileScreenNavigationArguments({
    required this.profileProvider,
    required this.userId,
    this.componentId = -1,
    this.componentInstanceId = -1,
  });
}

class InstaBotScreen2NavigationArguments extends NavigationArguments {
  final String courseId;
  final InstaBotProvider? instaBotProvider;

  const InstaBotScreen2NavigationArguments({
    this.courseId = "",
    this.instaBotProvider,
  });
}

class EventCatalogListScreenNavigationArguments extends NavigationArguments {
  final String? tabId;
  final DynamicTabsDTOModel? tabDataModel;
  final EventProvider? eventProvider;
  final bool enableSearching;
  final bool isShowAppBar;
  final int componentId;
  final int componentInsId;
  final String searchString;
  final bool isShowSearchTextField;
  final ApiController? apiController;
  final int? siteId;

  const EventCatalogListScreenNavigationArguments(
      {this.tabId,
      this.tabDataModel,
      this.eventProvider,
      this.enableSearching = true,
      this.isShowAppBar = true,
      required this.componentId,
      required this.componentInsId,
      this.searchString = "",
      this.isShowSearchTextField = true,
      this.apiController,
      this.siteId});
}

class LensScreenNavigationArguments extends NavigationArguments {
  final int componentId;
  final int componentInsId;

  const LensScreenNavigationArguments({
    required this.componentId,
    required this.componentInsId,
  });
}

class SurfaceTrackingKeywordSearchScreenNavigationArguments extends NavigationArguments {
  final LensProvider? lensProvider;
  final int componentId;
  final int componentInsId;

  const SurfaceTrackingKeywordSearchScreenNavigationArguments({
    required this.lensProvider,
    required this.componentId,
    required this.componentInsId,
  });
}

class ReEnrollmentHistoryScreenNavigationArguments extends NavigationArguments {
  final String parentEventId;
  final String instanceEventId;
  final String ThumbnailImagePath;
  final String ContentName;
  final String AuthorDisplayName;

  const ReEnrollmentHistoryScreenNavigationArguments({
    required this.parentEventId,
    required this.instanceEventId,
    required this.ThumbnailImagePath,
    required this.ContentName,
    required this.AuthorDisplayName,
  });
}

class FilterSkillsScreenNavigationArguments extends NavigationArguments {
  final bool isMyQuestion;

  const FilterSkillsScreenNavigationArguments({this.isMyQuestion = false});
}

class CreateEditQuestionNavigationArguments extends NavigationArguments {
  final int componentId;
  final int componentInsId;
  final bool isEdit;
  final UserQuestionListDto? userQuestionListDto;

  const CreateEditQuestionNavigationArguments({
    required this.componentId,
    required this.componentInsId,
    this.userQuestionListDto,
    this.isEdit = false,
  });
}

class LearningCommunitiesScreenNavigationArguments extends NavigationArguments {
  final int componentId;
  final int componentInsId;

  const LearningCommunitiesScreenNavigationArguments({
    required this.componentId,
    required this.componentInsId,
  });
}

class QuestionAndAnswerDetailsScreenArguments extends NavigationArguments {
  final int componentId;
  final int componentInsId;
  final int questionId;
  final UserQuestionListDto? userQuestionListDto;

  const QuestionAndAnswerDetailsScreenArguments({
    required this.componentId,
    required this.componentInsId,
    required this.questionId,
    this.userQuestionListDto,
  });
}

class AddEditAnswerScreenNavigationArguments extends NavigationArguments {
  final int questionId;
  final bool isEdit;

  final UserQuestionListDto? userQuestionListDto;
  final QuestionAnswerResponse? questionAnswerResponse;

  const AddEditAnswerScreenNavigationArguments({
    required this.questionId,
    required this.isEdit,
    this.userQuestionListDto,
    this.questionAnswerResponse,
  });
}

class MyAchievementWidgetNavigationArguments extends NavigationArguments {
  final int componentId;
  final int componentInsId;
  final bool isRenderedAsScreen;
  final GamificationProvider? gamificationProvider;

  const MyAchievementWidgetNavigationArguments({
    required this.componentId,
    required this.componentInsId,
    this.isRenderedAsScreen = true,
    this.gamificationProvider,
  });

  @override
  List<Object?> get props => [
        componentId,
        componentInsId,
        gamificationProvider,
      ];
}

class ProgressReportMainScreenNavigationArguments extends NavigationArguments {
  final int componentId;
  final int componentInsId;

  const ProgressReportMainScreenNavigationArguments({
    required this.componentId,
    required this.componentInsId,
  });

  @override
  List<Object?> get props => [
        componentId,
        componentInsId,
      ];
}

class DiscussionDetailScreenNavigationArguments extends NavigationArguments {
  final int ForumId;
  final int componentId;
  final int componentInsId;
  final ForumModel? forumModel;

  const DiscussionDetailScreenNavigationArguments({
    required this.ForumId,
    required this.componentId,
    required this.componentInsId,
    this.forumModel,
  });
}

class CreateEditTopicScreenNavigationArguments extends NavigationArguments {
  final int componentId;
  final int componentInsId;
  final ForumModel forumModel;
  final TopicModel? topicModel;
  final bool isEdit;

  const CreateEditTopicScreenNavigationArguments({
    required this.componentId,
    required this.componentInsId,
    required this.forumModel,
    this.topicModel,
    this.isEdit = false,
  });
}

class CreateEditDiscussionForumScreenNavigationArguments extends NavigationArguments {
  final ForumModel? forumModel;
  final bool isEdit;
  final int componentId;
  final int componentInsId;

  const CreateEditDiscussionForumScreenNavigationArguments({
    required this.forumModel,
    required this.componentId,
    required this.componentInsId,
    this.isEdit = false,
  });
}

class CommonViewImageScreenNavigationArguments extends NavigationArguments {
  final String imageUrl;

  const CommonViewImageScreenNavigationArguments({this.imageUrl = ""});
}

class DiscussionForumCategoriesSearchScreenNavigationArguments extends NavigationArguments {
  final bool isFromMyDiscussion;

  const DiscussionForumCategoriesSearchScreenNavigationArguments({this.isFromMyDiscussion = false});
}

class MembershipSelectionScreenNavigationArguments extends NavigationArguments {
  final MembershipProvider? membershipProvider;
  final bool isUpdateMembership;

  const MembershipSelectionScreenNavigationArguments({
    this.membershipProvider,
    this.isUpdateMembership = false,
  });
}

class LoginScreenNavigationArguments extends NavigationArguments {
  final int selectedSectionIndex;
  final bool isSignInEnabled;
  final bool isSignUpEnabled;
  final MembershipPlanDetailsModel? membershipPlanDetailsModel;

  const LoginScreenNavigationArguments({
    this.selectedSectionIndex = 0,
    this.isSignInEnabled = true,
    this.isSignUpEnabled = true,
    this.membershipPlanDetailsModel,
  });
}

class PurchaseHistoryScreenNavigationArguments extends NavigationArguments {
  final InAppPurchaseProvider? inAppPurchaseProvider;

  const PurchaseHistoryScreenNavigationArguments({
    this.inAppPurchaseProvider,
  });
}

class UserMembershipDetailsScreenNavigationArguments extends NavigationArguments {
  final MembershipProvider? membershipProvider;

  const UserMembershipDetailsScreenNavigationArguments({
    this.membershipProvider,
  });
}

class MyConnectionsMainScreenNavigationArguments extends NavigationArguments {
  final int componentId;
  final int componentInsId;
  final MyConnectionsProvider? myConnectionsProvider;
  final String searchString;
  final bool isShowSearchTextField;
  final bool isShowAppbar;
  final ApiController? apiController;

  const MyConnectionsMainScreenNavigationArguments({
    required this.componentId,
    required this.componentInsId,
    this.myConnectionsProvider,
    this.searchString = "",
    this.isShowSearchTextField = true,
    this.isShowAppbar = false,
    this.apiController,
  });
}

class MyLearningScreenNavigationArguments extends NavigationArguments {
  final int componentId;
  final int componentInsId;
  final MyLearningProvider? myLearningProvider;
  final String searchString;
  final bool isShowSearchTextField;
  final bool isShowAppbar;
  final ApiController? apiController;

  const MyLearningScreenNavigationArguments({
    required this.componentId,
    required this.componentInsId,
    this.myLearningProvider,
    this.searchString = "",
    this.isShowSearchTextField = true,
    this.isShowAppbar = false,
    this.apiController,
  });
}

class EventCatalogTabScreenNavigationArguments extends NavigationArguments {
  final EventProvider? eventProvider;
  final bool enableSearching;
  final String searchString;
  final bool isShowSearchTextField;
  final bool isShowAppbar;
  final int componentId;
  final int componentInsId;
  final ApiController? apiController;
  final int? siteId;

  const EventCatalogTabScreenNavigationArguments(
      {this.eventProvider,
      this.enableSearching = true,
      required this.componentId,
      required this.componentInsId,
      this.searchString = "",
      this.isShowSearchTextField = true,
      this.isShowAppbar = false,
      this.apiController,
      this.siteId});
}

class UserMessageListScreenNavigationArguments extends NavigationArguments {
  final ChatUserModel toUser;

  const UserMessageListScreenNavigationArguments({
    required this.toUser,
  });
}

class CatalogContentsListScreenNavigationArguments extends NavigationArguments {
  final int componentId, componentInstanceId;
  final int? HomeComponentId;
  final bool isPinnedContent;
  final CatalogProvider? catalogProvider;
  final WikiProvider? wikiProvider;
  final ContentFilterCategoryTreeModel? selectedCategory;
  List<CatalogCategoriesForBrowseModel> categoriesListForPath = <CatalogCategoriesForBrowseModel>[];
  final String searchString;
  final bool isShowSearchTextField;
  final bool isShowAppbar;
  final ApiController? apiController;
  final int? subSiteId;

  CatalogContentsListScreenNavigationArguments({
    required this.componentInstanceId,
    required this.componentId,
    this.isPinnedContent = false,
    this.HomeComponentId,
    this.catalogProvider,
    this.wikiProvider,
    this.selectedCategory,
    this.searchString = "",
    this.isShowSearchTextField = true,
    this.isShowAppbar = false,
    this.apiController,
    this.subSiteId,
    List<CatalogCategoriesForBrowseModel>? categoriesListForPath,
  }) {
    this.categoriesListForPath = categoriesListForPath ?? <CatalogCategoriesForBrowseModel>[];
  }
}

class DiscussionForumScreenNavigationArguments extends NavigationArguments {
  final int componentId;
  final int componentInsId;
  final String searchString;
  final bool isShowSearchTextField;
  final bool isShowAppbar;
  final DiscussionProvider? discussionProvider;
  final ApiController? apiController;

  const DiscussionForumScreenNavigationArguments(
      {required this.componentId, required this.componentInsId, this.searchString = "", this.isShowSearchTextField = true, this.isShowAppbar = false, this.apiController, this.discussionProvider});
}

class AskTheExpertScreenNavigationArguments extends NavigationArguments {
  final int componentId;
  final int componentInsId;
  final String searchString;
  final bool isShowSearchTextField;
  final bool isShowAppbar;
  final ApiController? apiController;
  final AskTheExpertProvider? askTheExpertProvider;

  const AskTheExpertScreenNavigationArguments(
      {required this.componentId, required this.componentInsId, this.searchString = "", this.isShowSearchTextField = true, this.isShowAppbar = false, this.apiController, this.askTheExpertProvider});
}

class AddEditFlashcardScreenNavigationArguments extends NavigationArguments {
  final CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  const AddEditFlashcardScreenNavigationArguments({
    required this.coCreateContentAuthoringModel,
  });
}

class GenerateWithAiFlashCardScreenNavigationArguments extends NavigationArguments {
  final CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  const GenerateWithAiFlashCardScreenNavigationArguments({
    required this.coCreateContentAuthoringModel,
  });
}

class FlashCardScreenNavigationArguments extends NavigationArguments {
  final CourseDTOModel courseDTOModel;

  const FlashCardScreenNavigationArguments({
    required this.courseDTOModel,
  });
}

class QuizScreenNavigationArguments extends NavigationArguments {
  final CourseDTOModel courseDTOModel;

  const QuizScreenNavigationArguments({
    required this.courseDTOModel,
  });
}

class CoCreateKnowledgeScreenNavigationArguments extends NavigationArguments {
  final int componentId, componentInstanceId;
  final int? HomeComponentId;
  final CatalogProvider? catalogProvider;
  final CoCreateKnowledgeProvider? coCreateKnowledgeProvider;
  final ContentFilterCategoryTreeModel? selectedCategory;
  final List<CatalogCategoriesForBrowseModel>? categoriesListForPath;
  final String searchString;
  final bool isShowSearchTextField;
  final bool isShowAppbar;
  final ApiController? apiController;
  final int? subSiteId;

  const CoCreateKnowledgeScreenNavigationArguments({
    required this.componentInstanceId,
    required this.componentId,
    this.HomeComponentId,
    this.catalogProvider,
    this.coCreateKnowledgeProvider,
    this.selectedCategory,
    this.searchString = "",
    this.isShowSearchTextField = true,
    this.isShowAppbar = false,
    this.apiController,
    this.subSiteId,
    this.categoriesListForPath,
  });
}

class AddEditDocumentScreenArguments extends NavigationArguments {
  final CoCreateContentAuthoringModel? coCreateContentAuthoringModel;

  const AddEditDocumentScreenArguments({
    required this.coCreateContentAuthoringModel,
  });
}

class CreatePodcastSourceSelectionScreenNavigationArguments extends NavigationArguments {
  final CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  const CreatePodcastSourceSelectionScreenNavigationArguments({
    required this.coCreateContentAuthoringModel,
  });
}

class PodcastScreenNavigationArguments extends NavigationArguments {
  final CourseDTOModel courseDTOModel;
  final CoCreateContentAuthoringModel? coCreateContentAuthoringModel;
  final String audioUrl;
  final Uint8List? fileBytes;

  const PodcastScreenNavigationArguments({required this.courseDTOModel, this.audioUrl = "", this.fileBytes, this.coCreateContentAuthoringModel});
}

class CreateUrlScreenNavigationArguments extends NavigationArguments {
  final int componentId;
  final int componentInsId;
  final CoCreateContentAuthoringModel? coCreateContentAuthoringModel;

  const CreateUrlScreenNavigationArguments({
    required this.componentId,
    required this.componentInsId,
    this.coCreateContentAuthoringModel,
  });
}

class AddEditReferenceUrlScreenArguments extends NavigationArguments {
  final int componentId;
  final int componentInsId;
  final CourseDTOModel? courseDtoModel;

  const AddEditReferenceUrlScreenArguments({
    required this.componentId,
    required this.componentInsId,
    this.courseDtoModel,
  });
}

class CommonCreateAuthoringToolScreenArgument extends NavigationArguments {
  final CoCreateContentAuthoringModel? coCreateContentAuthoringModel;
  final CoCreateAuthoringType coCreateAuthoringType;
  final int componentId;
  final int componentInsId;
  final CourseDTOModel? courseDtoModel;
  final int objectTypeId;
  final int mediaTypeId;

  const CommonCreateAuthoringToolScreenArgument({
    this.coCreateContentAuthoringModel,
    required this.coCreateAuthoringType,
    required this.componentId,
    required this.componentInsId,
    this.courseDtoModel,
    required this.objectTypeId,
    required this.mediaTypeId,
  });
}

class AddEditQuizScreenArgument extends NavigationArguments {
  final CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  const AddEditQuizScreenArgument({
    required this.coCreateContentAuthoringModel,
  });
}

class AddEditVideoScreenNavigationArgument extends NavigationArguments {
  final bool isUploadScreen;
  final bool isNotGenerateWithAiScreen;
  final CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  const AddEditVideoScreenNavigationArgument({
    this.isUploadScreen = false,
    this.isNotGenerateWithAiScreen = false,
    required this.coCreateContentAuthoringModel,
  });
}

class CreateManuallyVideoScreenNavigationArgument extends NavigationArguments {
  final CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  const CreateManuallyVideoScreenNavigationArgument({
    required this.coCreateContentAuthoringModel,
  });
}

class GenerateWithAiVideoScreenNavigationArgument extends NavigationArguments {
  final CoCreateContentAuthoringModel coCreateContentAuthoringModel;
  // final String avatarId;
  // final String background;
  // final String scriptText;
  // final String voice;
  // final String horizontalAlign;
  // final String style;

  const GenerateWithAiVideoScreenNavigationArgument({
    required this.coCreateContentAuthoringModel,
  });
}

class AddEditEventScreenArgument extends NavigationArguments {
  final CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  const AddEditEventScreenArgument({required this.coCreateContentAuthoringModel});
}

class RecordAndUploadPodcastScreenNavigationArgument extends NavigationArguments {
  final CoCreateContentAuthoringModel coCreateContentAuthoringModel;
  final bool isFromRecordAudio;

  const RecordAndUploadPodcastScreenNavigationArgument({
    required this.coCreateContentAuthoringModel,
    this.isFromRecordAudio = false,
  });
}

class TextToAudioScreenNavigationArgument extends NavigationArguments {
  final CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  const TextToAudioScreenNavigationArgument({
    required this.coCreateContentAuthoringModel,
  });
}

class TextToAudioGenerateWithAIScreenNavigationArgument extends NavigationArguments {
  final CoCreateContentAuthoringModel coCreateContentAuthoringModel;
  final bool isEdit;

  const TextToAudioGenerateWithAIScreenNavigationArgument({
    required this.coCreateContentAuthoringModel, this.isEdit = false});
}

class AddEditRolePlayScreenNavigationArgument extends NavigationArguments {
  final CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  const AddEditRolePlayScreenNavigationArgument({
    required this.coCreateContentAuthoringModel,
  });
}

class GeneratedQuizScreenNavigationArgument extends NavigationArguments {
  final CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  const GeneratedQuizScreenNavigationArgument({
    required this.coCreateContentAuthoringModel,
  });
}

class EditFlashcardScreenNavigationArgument extends NavigationArguments {
  final FlashcardModel model;

  const EditFlashcardScreenNavigationArgument({
    required this.model,
  });
}

class AddEditArticleScreenNavigationArgument extends NavigationArguments {
  final CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  const AddEditArticleScreenNavigationArgument({
    required this.coCreateContentAuthoringModel,
  });
}

class ArticleEditorScreenNavigationArgument extends NavigationArguments {
  final CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  const ArticleEditorScreenNavigationArgument({
    required this.coCreateContentAuthoringModel,
  });
}

class ArticlePreviewScreenNavigationArgument extends NavigationArguments {
  final CourseDTOModel model;

  const ArticlePreviewScreenNavigationArgument({
    required this.model,
  });
}

class PodcastPreviewScreenNavigationArgument extends NavigationArguments {
  final CoCreateContentAuthoringModel coCreateContentAuthoringModel;
  final bool isRetakeRequired;
  final bool isFromTextToAudio;

  const PodcastPreviewScreenNavigationArgument({
    required this.coCreateContentAuthoringModel,
    this.isRetakeRequired = false,
    this.isFromTextToAudio = false,
  });
}

class LearningPathScreenNavigationArgument extends NavigationArguments {
  final CourseDTOModel model;
  final bool isRetakeRequired;
  final int componentId, componentInstanceId;

  const LearningPathScreenNavigationArgument({required this.model, this.isRetakeRequired = true, this.componentId = 0, this.componentInstanceId = 0});
}

class MicroLearningScreenNavigationArgument extends NavigationArguments {
  final CourseDTOModel model;
  final bool isRetakeRequired;
  final int componentId, componentInstanceId;

  const MicroLearningScreenNavigationArgument({required this.model, this.isRetakeRequired = true, this.componentId = 0, this.componentInstanceId = 0});
}

class AddEditLearningPathScreenNavigationArgument extends NavigationArguments {
  final CoCreateContentAuthoringModel coCreateContentAuthoringModel;
  final CourseDTOModel? model;
  final bool isRetakeRequired;
  final int componentId, componentInstanceId;

  const AddEditLearningPathScreenNavigationArgument({required this.coCreateContentAuthoringModel, this.model, this.isRetakeRequired = true, this.componentId = 0, this.componentInstanceId = 0});
}

class AddContentItemScreenNavigationArgument extends NavigationArguments {
  final CoCreateContentAuthoringModel coCreateContentAuthoringModel;
  final int componentId, componentInstanceId;

  const AddContentItemScreenNavigationArgument({required this.coCreateContentAuthoringModel, this.componentId = 0, this.componentInstanceId = 0});
}

class AiAgentScreenNavigationArgument extends NavigationArguments {
  final CourseDTOModel model;
  final int componentId, componentInstanceId;

  const AiAgentScreenNavigationArgument({required this.model, this.componentId = 0, this.componentInstanceId = 0});
}

class AddEditAiAgentScreenNavigationArgument extends NavigationArguments {
  final CoCreateContentAuthoringModel coCreateContentAuthoringModel;
  final CourseDTOModel? courseDtoModel;
  final bool isRetakeRequired;
  final int componentId, componentInstanceId;

  const AddEditAiAgentScreenNavigationArgument({required this.coCreateContentAuthoringModel, this.courseDtoModel, this.isRetakeRequired = true, this.componentId = 0, this.componentInstanceId = 0});
}

class AddEditMicroLearningScreenNavigationArgument extends NavigationArguments {
  final CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  const AddEditMicroLearningScreenNavigationArgument({
    required this.coCreateContentAuthoringModel,
  });
}

class MicroLearningSourceSelectionScreenNavigationArgument extends NavigationArguments {
  final CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  const MicroLearningSourceSelectionScreenNavigationArgument({
    required this.coCreateContentAuthoringModel,
  });
}

class MicroLearningTopicSelectionScreenNavigationArgument extends NavigationArguments {
  final CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  const MicroLearningTopicSelectionScreenNavigationArgument({
    required this.coCreateContentAuthoringModel,
  });
}

class MicroLearningEditorScreenNavigationArgument extends NavigationArguments {
  final CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  const MicroLearningEditorScreenNavigationArgument({
    required this.coCreateContentAuthoringModel,
  });
}

class MicroLearningViewScreenNavigationArgument extends NavigationArguments {
  final String title;
  final MicroLearningContentModel microLearningContentModel;

  const MicroLearningViewScreenNavigationArgument({
    required this.title,
    required this.microLearningContentModel,
  });
}

class VideoWithTranscriptLaunchScreenNavigationArgument extends NavigationArguments {
  final String title;
  final String transcript;
  final String videoUrl;
  final Uint8List? videoBytes;

  const VideoWithTranscriptLaunchScreenNavigationArgument({
    required this.title,
    this.transcript = "",
    this.videoUrl = "",
    this.videoBytes,
  });
}
