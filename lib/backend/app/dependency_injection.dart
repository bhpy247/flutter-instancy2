import 'package:flutter_instancy_2/backend/Catalog/catalog_provider.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/app_theme/app_theme_provider.dart';
import 'package:flutter_instancy_2/backend/ask_the_expert/ask_the_expert_provider.dart';
import 'package:flutter_instancy_2/backend/authentication/authentication_provider.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_provider.dart';
import 'package:flutter_instancy_2/backend/content_review_ratings/content_review_ratings_provider.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_provider.dart';
import 'package:flutter_instancy_2/backend/discussion/discussion_provider.dart';
import 'package:flutter_instancy_2/backend/event/event_provider.dart';
import 'package:flutter_instancy_2/backend/event_track/event_track_provider.dart';
import 'package:flutter_instancy_2/backend/feedback/feedback_provider.dart';
import 'package:flutter_instancy_2/backend/filter/filter_provider.dart';
import 'package:flutter_instancy_2/backend/gamification/gamification_provider.dart';
import 'package:flutter_instancy_2/backend/global_search/global_search_provider.dart';
import 'package:flutter_instancy_2/backend/home/home_provider.dart';
import 'package:flutter_instancy_2/backend/in_app_purchase/in_app_purchase_provider.dart';
import 'package:flutter_instancy_2/backend/instabot/instabot_provider.dart';
import 'package:flutter_instancy_2/backend/learning_communities/learning_communities_provider.dart';
import 'package:flutter_instancy_2/backend/main_screen/main_screen_provider.dart';
import 'package:flutter_instancy_2/backend/membership/membership_provider.dart';
import 'package:flutter_instancy_2/backend/message/message_provider.dart';
import 'package:flutter_instancy_2/backend/my_connections/my_connections_provider.dart';
import 'package:flutter_instancy_2/backend/my_learning/my_learning_provider.dart';
import 'package:flutter_instancy_2/backend/profile/profile_provider.dart';
import 'package:flutter_instancy_2/backend/progress_report/progress_report_provider.dart';
import 'package:flutter_instancy_2/backend/share/share_provider.dart';
import 'package:flutter_instancy_2/backend/wiki_component/wiki_provider.dart';

class DependencyInjection {
  static final AppProvider appProvider = AppProvider();
  static final AppThemeProvider appThemeProvider = AppThemeProvider();
  static final AuthenticationProvider authenticationProvider = AuthenticationProvider();
  static final MainScreenProvider mainScreenProvider = MainScreenProvider();
  static final HomeProvider homeProvider = HomeProvider();
  static final ProfileProvider profileProvider = ProfileProvider();
  static final FilterProvider filterProvider = FilterProvider();
  static final CatalogProvider coCreateCatalogProvider = CatalogProvider();
  static final CatalogProvider catalogProvider = CatalogProvider();
  static final WikiProvider wikiProvider = WikiProvider();
  static final MyLearningProvider myLearningProvider = MyLearningProvider();
  static final EventProvider eventProvider = EventProvider();
  static final ShareProvider shareProvider = ShareProvider();
  static final ProgressReportProvider progressReportProvider = ProgressReportProvider();
  static final ContentReviewRatingsProvider contentReviewRatingsProvider = ContentReviewRatingsProvider();
  static final EventTrackProvider eventTrackProvider = EventTrackProvider();
  static final InstaBotProvider instaBotProvider = InstaBotProvider();
  static final MessageProvider messageProvider = MessageProvider();
  static final MembershipProvider membershipProvider = MembershipProvider();
  static final InAppPurchaseProvider inAppPurchaseProvider = InAppPurchaseProvider();
  static final DiscussionProvider discussionProvider = DiscussionProvider();
  static final GamificationProvider gamificationProvider = GamificationProvider();
  static final FeedbackProvider feedbackProvider = FeedbackProvider();
  static final AskTheExpertProvider askTheExpertProvider = AskTheExpertProvider();
  static final MyConnectionsProvider myConnectionsProvider = MyConnectionsProvider();
  static final LearningCommunitiesProvider learningCommunitiesProvider = LearningCommunitiesProvider();
  static final GlobalSearchProvider globalSearchProvider = GlobalSearchProvider();
  static final CoCreateKnowledgeProvider coCreateKnowledgeProvider = CoCreateKnowledgeProvider();
  static final CourseDownloadProvider courseDownloadProvider = CourseDownloadProvider();
}
