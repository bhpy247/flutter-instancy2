import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_instancy_2/backend/gamification/gamification_provider.dart';
import 'package:flutter_instancy_2/backend/in_app_purchase/in_app_purchase_provider.dart';
import 'package:flutter_instancy_2/backend/lens_feature/lens_provider.dart';
import 'package:flutter_instancy_2/backend/membership/membership_provider.dart';
import 'package:flutter_instancy_2/backend/profile/profile_provider.dart';
import 'package:flutter_instancy_2/backend/ui_actions/primary_secondary_actions/primary_secondary_actions.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/native_menu_component_model.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/event_track_content_model.dart';
import 'package:flutter_instancy_2/models/membership/data_model/membership_plan_details_model.dart';
import 'package:flutter_instancy_2/models/profile/data_model/user_experience_data_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';

import '../../configs/app_constants.dart';
import '../../models/app_configuration_models/data_models/component_configurations_model.dart';
import '../../models/catalog/catalogCategoriesForBrowseModel.dart';
import '../../models/classroom_events/data_model/tab_data_model.dart';
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
  final FilterProvider filterProvider;
  final ComponentConfigurationsModel componentConfigurationsModel;

  const GlobalSearchScreenNavigationArguments({
    required this.componentId,
    required this.filterProvider,
    required this.componentConfigurationsModel,
  });
}

class SortingScreenNavigationArguments extends NavigationArguments {
  final int componentId;
  final FilterProvider filterProvider;

  const SortingScreenNavigationArguments({
    required this.componentId,
    required this.filterProvider,
  });
}

class CatalogContentsListScreenNavigationArguments extends NavigationArguments {
  final int componentId, componentInstanceId, HomeComponentId;
  final bool isPinnedContent;
  final CatalogProvider? provider;
  final ContentFilterCategoryTreeModel? selectedCategory;
  List<CatalogCategoriesForBrowseModel> categoriesListForPath = [];

  CatalogContentsListScreenNavigationArguments({
    required this.componentInstanceId,
    required this.componentId,
    this.isPinnedContent = false,
    this.HomeComponentId = 0,
    this.provider,
    this.selectedCategory,
    List<CatalogCategoriesForBrowseModel>? categoriesListForPath,
  }) {
    this.categoriesListForPath = categoriesListForPath ?? [];
  }
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
  final ShareProvider? shareProvider;

  const ShareWithConnectionsScreenNavigationArguments({
    required this.shareContentType,
    this.contentId = '',
    this.contentName = "",
    this.topicId = "",
    this.forumId = 0,
    this.shareProvider,
  });
}

class ShareWithPeopleScreenNavigationArguments extends NavigationArguments {
  final ShareContentType shareContentType;
  final String contentId;
  final String contentName;
  final String topicId;
  final int forumId;
  final bool isSuggestToConnections;
  final List<int>? userIds;

  const ShareWithPeopleScreenNavigationArguments({
    required this.shareContentType,
    this.contentId = "",
    this.contentName = "",
    this.topicId = "",
    this.forumId = 0,
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
  final EventTrackContentModel? eventTrackContentModel;
  final int userId;
  final int contentTypeId;
  final int componentId;
  final String trackId;
  final String eventId;
  final String seqId;

  const MyLearningContentProgressScreenNavigationArguments({
    required this.contentId,
    this.courseDTOModel,
    this.eventTrackContentModel,
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
  final int componentId;
  final int componentInstanceId;
  final int? userId;
  final bool isFromCatalog;
  final bool isConsolidated;
  final bool isRescheduleEvent;
  final InstancyContentScreenType screenType;
  final MyLearningProvider? myLearningProvider;
  final CatalogProvider? catalogProvider;

  const CourseDetailScreenNavigationArguments({
    required this.contentId,
    required this.componentId,
    required this.componentInstanceId,
    required this.userId,
    this.isFromCatalog = false,
    this.isConsolidated = false,
    this.isRescheduleEvent = false,
    this.screenType = InstancyContentScreenType.Catalog,
    this.myLearningProvider,
    this.catalogProvider,
  });
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
}

class WebViewScreenNavigationArguments extends NavigationArguments {
  final String title;
  final String url;

  const WebViewScreenNavigationArguments({
    required this.title,
    required this.url,
  });
}

class EventTrackScreenArguments extends NavigationArguments {
  final String parentContentId;
  final int componentId;
  final int componentInstanceId;
  final int objectTypeId;
  final int scoId;
  final bool isRelatedContent, isContentEnrolled;
  final String? eventTrackTabType;
  final EventTrackProvider? eventTrackProvider;

  const EventTrackScreenArguments(
      {required this.parentContentId,
      required this.componentId,
      required this.componentInstanceId,
      required this.objectTypeId,
      required this.isRelatedContent,
      required this.isContentEnrolled,
      required this.scoId,
      this.eventTrackProvider,
      this.eventTrackTabType});
}

class UserProfileScreenNavigationArguments extends NavigationArguments {
  final ProfileProvider? profileProvider;
  final bool isFromProfile, isMyProfile;
  final int userId;

  const UserProfileScreenNavigationArguments({
    required this.profileProvider,
    this.isFromProfile = false,
    this.isMyProfile = false,
    required this.userId,
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
  final TabDataModel? tabDataModel;
  final EventProvider? eventProvider;
  final bool enableSearching;
  final bool isShowAppBar;
  final int componentId;
  final int componentInsId;

  const EventCatalogListScreenNavigationArguments({
    this.tabId,
    this.tabDataModel,
    this.eventProvider,
    this.enableSearching = true,
    this.isShowAppBar = true,
    required this.componentId,
    required this.componentInsId,
  });
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
  final CourseDTOModel? model;

  const ReEnrollmentHistoryScreenNavigationArguments({
    required this.model,
  });
}

class DiscussionForumScreenNavigationArguments extends NavigationArguments {
  final int componentId;
  final int componentInsId;

  const DiscussionForumScreenNavigationArguments({
    required this.componentId,
    required this.componentInsId,
  });
}

class MyAchievementWidgetNavigationArguments extends NavigationArguments {
  final int componentId;
  final int componentInsId;
  final GamificationProvider? gamificationProvider;

  const MyAchievementWidgetNavigationArguments({
    required this.componentId,
    required this.componentInsId,
    this.gamificationProvider,
  });

  @override
  List<Object?> get props => [
        componentId,
        componentInsId,
        gamificationProvider,
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

  const CreateEditDiscussionForumScreenNavigationArguments({
    required this.forumModel,
    this.isEdit = false,
  });
}

class CommonViewImageScreenNavigationArguments extends NavigationArguments {
  final String imageUrl;

  const CommonViewImageScreenNavigationArguments({this.imageUrl = ""});
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
