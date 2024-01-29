import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_instancy_2/views/ask_the_expert/screen/add_edit_answer_screen.dart';
import 'package:flutter_instancy_2/views/ask_the_expert/screen/question_and_answer_detail_screen.dart';
import 'package:flutter_instancy_2/views/authentication/screens/forgot_password_screen.dart';
import 'package:flutter_instancy_2/views/authentication/screens/login_screen.dart';
import 'package:flutter_instancy_2/views/authentication/screens/sign_up_screen.dart';
import 'package:flutter_instancy_2/views/catalog/screens/PrerequisiteScreen.dart';
import 'package:flutter_instancy_2/views/common/screen/common_view_image_screen.dart';
import 'package:flutter_instancy_2/views/course_details/screens/course_details_screen.dart';
import 'package:flutter_instancy_2/views/discussion_forum/component/categories_search_screen.dart';
import 'package:flutter_instancy_2/views/discussion_forum/screens/create_edit_discussion_forum_screen.dart';
import 'package:flutter_instancy_2/views/discussion_forum/screens/create_edit_topic_screen.dart';
import 'package:flutter_instancy_2/views/discussion_forum/screens/discussion_detail.dart';
import 'package:flutter_instancy_2/views/event/components/re_enrollment_history.dart';
import 'package:flutter_instancy_2/views/event_track/screens/event_track_screen.dart';
import 'package:flutter_instancy_2/views/feedBack/screens/add_feedback_screen.dart';
import 'package:flutter_instancy_2/views/lens_feature/screen/lens_screen.dart';
import 'package:flutter_instancy_2/views/main_screen/screens/main_screen.dart';
import 'package:flutter_instancy_2/views/membership/screens/membership_selection_screen.dart';
import 'package:flutter_instancy_2/views/my_learning_plus/screens/my_learning_plus.dart';
import 'package:flutter_instancy_2/views/profile/component/add_education_screen.dart';
import 'package:flutter_instancy_2/views/progress_report/screens/progress_report_detail_screen.dart';
import 'package:flutter_instancy_2/views/share/recommend_to_screen.dart';
import 'package:flutter_instancy_2/views/wiki_component/screens/add_wiki_content_screen.dart';
import 'package:flutter_instancy_2/views/wishlist/screen/wishlist_screen.dart';

import '../../utils/my_print.dart';
import '../../views/app/splashscreen.dart';
import '../../views/ask_the_expert/screen/add_question_screen.dart';
import '../../views/ask_the_expert/screen/skills_filter_screen.dart';
import '../../views/authentication/screens/login_signup_selection_screen.dart';
import '../../views/catalog/screens/catalog_contents_list_screen.dart';
import '../../views/catalog/screens/catalog_subcategories_list_screen.dart';
import '../../views/course_launch/screens/course_launch_webview_screen.dart';
import '../../views/course_launch/screens/pdf_launch_screen.dart';
import '../../views/course_launch/screens/video_launch_screen.dart';
import '../../views/course_launch/screens/webview_screen.dart';
import '../../views/filter/screens/filters_screen.dart';
import '../../views/filter/screens/global_search_screen.dart';
import '../../views/filter/screens/sort_screen.dart';
import '../../views/home/screens/home_screen_view.dart';
import '../../views/instabot/instabot_screen2.dart';
import '../../views/lens_feature/component/surface_tracking_keyword_search_screen.dart';
import '../../views/my_learning/screens/mylearning_waitlist_screen.dart';
import '../../views/my_learning/screens/qr_code_image_screen.dart';
import '../../views/my_learning/screens/view_completion_certificate_screen.dart';
import '../../views/profile/screens/add_edit_experience_screen.dart';
import '../../views/profile/screens/user_profile_screen.dart';
import '../../views/progress_report/screens/my_learning_content_progress_screen.dart';
import '../../views/settings/screens/purchase_history_screen.dart';
import '../../views/settings/screens/user_membership_details_screen.dart';
import '../../views/share/share_with_connections_screen.dart';
import '../../views/share/share_with_people_screen.dart';
import 'navigation.dart';

class NavigationController {
  static GlobalKey<NavigatorState> mainNavigatorKey = GlobalKey<NavigatorState>();
  static bool isFirst = true;

  static bool checkDataAndNavigateToSplashScreen() {
    MyPrint.printOnConsole("checkDataAndNavigateToSplashScreen called, isFirst:$isFirst");

    if (isFirst) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        isFirst = false;
        Navigator.pushNamedAndRemoveUntil(mainNavigatorKey.currentContext!, SplashScreen.routeName, (route) => false);
      });
    }

    return isFirst;
  }

  static Route? onMainGeneratedRoutes(RouteSettings settings) {
    MyPrint.printOnConsole("OnMainGeneratedRoutes called for ${settings.name} with arguments:${settings.arguments}");

    // if(navigationCount == 2 && Uri.base.hasFragment && Uri.base.fragment != "/") {
    //   return null;
    // }

    if (kIsWeb) {
      if (!["/", SplashScreen.routeName].contains(settings.name) && NavigationController.checkDataAndNavigateToSplashScreen()) {
        return null;
      }
    }
    if (!["/", SplashScreen.routeName].contains(settings.name)) {
      if (NavigationController.checkDataAndNavigateToSplashScreen()) {
        return null;
      }
    } else {
      if (!kIsWeb) {
        if (isFirst) {
          isFirst = false;
        }
      }
    }

    MyPrint.printOnConsole("First Page:$isFirst");
    Widget? page;

    switch (settings.name) {
      case "/":
        {
          page = const SplashScreen();
          break;
        }
      case SplashScreen.routeName:
        {
          page = const SplashScreen();
          break;
        }
      case LoginScreen.routeName:
        {
          page = parseLoginScreen(settings: settings);
          break;
        }
      case LoginSignUpSelectionScreen.routeName:
        {
          page = const LoginSignUpSelectionScreen();
          break;
        }
      case SignUpScreen.routeName:
        {
          page = const SignUpScreen();
          break;
        }
      case ForgotPassword.routeName:
        {
          page = parseForgotPassword(settings: settings);
          break;
        }
      case MainScreen.routeName:
        {
          page = const MainScreen();
          break;
        }
      case HomeScreenView.routeName:
        {
          page = const HomeScreenView();
          break;
        }
      case WishListScreen.routeName:
        {
          page = parseWishListScreen(settings: settings);
          break;
        }
      case EventTrackScreen.routeName:
        {
          page = parseEventTrackScreen(settings: settings);
          break;
        }
      case MyLearningPlus.routeName:
        {
          page = const MyLearningPlus();
          break;
        }
      case AddWikiContentScreen.routeName:
        {
          page = parseAddCatalogContentScreen(settings: settings);
          break;
        }
      case GlobalSearchScreen.routeName:
        {
          page = parseGlobalSearchScreen(settings: settings);
          break;
        }

      //region Filter Module
      case FiltersScreen.routeName:
        {
          page = parseFiltersScreen(settings: settings);
          break;
        }
      case SortingScreen.routeName:
        {
          page = parseSortingScreen(settings: settings);
          break;
        }
      //endregion

      case CatalogContentsListScreen.routeName:
        {
          page = parseCatalogContentsListScreen(settings: settings);
          break;
        }
      case CatalogSubcategoriesListScreen.routeName:
        {
          page = parseCatalogSubcategoriesListScreen(settings: settings);
          break;
        }
      case MyLearningWaitlistScreen.routeName:
        {
          page = parseMyLearningWaitlistScreen(settings: settings);
          break;
        }
      case ViewCompletionCertificateScreen.routeName:
        {
          page = parseViewCompletionCertificateScreen(settings: settings);
          break;
        }
      case QRCodeImageScreen.routeName:
        {
          page = parseQRCodeImageScreen(settings: settings);
          break;
        }

    //region Share Module
      case ShareWithConnectionsScreen.routeName:
        {
          page = parseShareWithConnectionsScreen(settings: settings);
          break;
        }
      case ShareWithPeopleScreen.routeName:
        {
          page = parseShareWithPeopleScreen(settings: settings);
          break;
        }
      case RecommendToScreen.routeName:
        {
          page = parseRecommendToScreen(settings: settings);
          break;
        }
    //endregion

      // region Course Details Module
      case CourseDetailScreen.routeName:
        {
          page = parseCourseDetailScreen(settings: settings);
          break;
        }
      //endregion

      // region Progress Report Module
      case MyLearningContentProgressScreen.routeName:
        {
          page = parseMyLearningContentProgressScreen(settings: settings);
          break;
        }
      case ProgressReportDetailScreen.routeName:
        {
          page = parseProgressReportDetailScreen(settings: settings);
          break;
        }
      //endregion

      // region Profile Module
      case UserProfileScreen.routeName:
        {
          page = parseUserProfileScreen(settings: settings);
          break;
        }
      case AddEditExperienceScreen.routeName:
        {
          page = parseAddEditExperienceScreen(settings: settings);
          break;
        }
      case AddEducationScreen.routeName:
        {
          page = parseAddEducationScreen(settings: settings);
          break;
        }
    //endregion

      //region PreRequisiteScreen
      case PrerequisiteScreen.routeName:
        {
          page = parsePreRequisiteScreen(settings: settings);
          break;
        }
    //endregion

      //region Instabot
      case InstaBotScreen2.routeName:
        {
          page = parseInstaBotScreen2(settings: settings);
          break;
        }
    //endregion

      // region Course Launch
      case CourseLaunchWebViewScreen.routeName:
        {
          page = parseCourseLaunchWebViewScreen(settings: settings);
          break;
        }
      case VideoLaunchScreen.routeName:
        {
          page = parseVideoLaunchScreen(settings: settings);
          break;
        }
      case PDFLaunchScreen.routeName:
        {
          page = parsePDFLaunchScreen(settings: settings);
          break;
        }
      case WebViewScreen.routeName:
        {
          page = parseWebViewScreen(settings: settings);
          break;
        }
    //endregion

      //region Lens Feature Module
      case LensScreen.routeName:
        {
          page = parseLensScreen(settings: settings);
          break;
        }
      case SurfaceTrackingKeywordSearchScreen.routeName:
        {
          page = parseSurfaceTrackingKeywordSearchScreen(settings: settings);
          break;
        }
      //endregion

      //region reEnrollmentHistory
      case ReEnrollmentHistory.routeName:
        {
          page = parseReEnrollmentHistoryScreen(settings: settings);
          break;
        }
      //endregion
      //
      // region Discussion Forum
      case DiscussionDetailScreen.routeName:
        {
          page = parseDiscussionDetailScreen(settings: settings);
          break;
        }
      case CreateEditTopicScreen.routeName:
        {
          page = parseCreateEditTopicScreen(settings: settings);
          break;
        }
      case CreateEditDiscussionForumScreen.routeName:
        {
          page = parseCreateEditDiscussionForumScreen(settings: settings);
          break;
        }
      case CommonViewImageScreen.routeName:
        {
          page = parseCommonViewImageScreen(settings: settings);
          break;
        }

      case CategoriesSearchScreen.routeName:
        {
          page = parseCategoriesSearchScreen(settings: settings);
          break;
        }

      //endregion

      //region Membership
      case MembershipSelectionScreen.routeName:
        {
          page = parseMembershipSelectionScreen(settings: settings);
          break;
        }
      case UserMembershipDetailsScreen.routeName:
        {
          page = parseUserMembershipDetailsScreen(settings: settings);
          break;
        }
      //endregion

      // region Membership
      case PurchaseHistoryScreen.routeName:
        {
          page = parsePurchaseHistoryScreen(settings: settings);
          break;
        }
      //endregion
      //
      // region Webview screen
      case WebViewScreen.routeName:
        {
          page = parsePurchaseHistoryScreen(settings: settings);
          break;
        }
      //endregion
      //
      // region Feedback screen
      case AddFeedbackScreen.routeName:
        {
          page = parseAddFeedbackScreen(settings: settings);
          break;
        }
      case CreateEditQuestionScreen.routeName:
        {
          page = parseCreateEditAddQuestionScreen(settings: settings);
          break;
        }

      case QuestionAndAnswerDetailsScreen.routeName:
        {
          page = parseQuestionAndAnswerDetailsScreen(settings: settings);
          break;
        }

      case AddEditAnswerScreen.routeName:
        {
          page = parseAddEditAnswerScreen(settings: settings);
        }

      case FilterSkillsScreen.routeName:
        {
          page = parseFilterSkillScreen(settings: settings);
        }

      //endregion
    }

    if (page == null) {
      return null;
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoPageRoute(
        builder: (BuildContext context) {
          return page!;
        },
      );
    }

    return PageRouteBuilder(
      pageBuilder: (c, a1, a2) => page!,
      //transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
      transitionsBuilder: (c, anim, a2, child) => SizeTransition(sizeFactor: anim, child: child),
      transitionDuration: const Duration(milliseconds: 0),
      settings: settings,
    );
  }

  //region Parse Page From RouteSettings
  //region Authentication
  static Widget? parseForgotPassword({required RouteSettings settings}) {
    if (settings.arguments is ForgotPasswordNavigationArguments) {
      ForgotPasswordNavigationArguments arguments = settings.arguments as ForgotPasswordNavigationArguments;

      return ForgotPassword(
        arguments: arguments,
      );
    } else {
      return null;
    }
  }

  static Widget? parseLoginScreen({required RouteSettings settings}) {
    dynamic argument = settings.arguments;
    if (argument is! LoginScreenNavigationArguments) {
      return null;
    }

    return LoginScreen(arguments: argument);
  }

  //endregion

  //region Wiki Component
  static Widget? parseAddCatalogContentScreen({required RouteSettings settings}) {
    if (settings.arguments is AddWikiContentScreenNavigationArguments) {
      AddWikiContentScreenNavigationArguments arguments = settings.arguments as AddWikiContentScreenNavigationArguments;

      return AddWikiContentScreen(
        addWikiContentScreenNavigationArguments: arguments,
      );
    } else {
      return null;
    }
  }

  //endregion

  //region Wishlist
  static Widget? parseWishListScreen({required RouteSettings settings}) {
    if (settings.arguments is WishListScreenNavigationArguments) {
      WishListScreenNavigationArguments arguments = settings.arguments as WishListScreenNavigationArguments;

      return WishListScreen(
        arguments: arguments,
      );
    } else {
      return null;
    }
  }

  //endregion

  //region Filter Module
  static Widget? parseGlobalSearchScreen({required RouteSettings settings}) {
    if (settings.arguments is GlobalSearchScreenNavigationArguments) {
      GlobalSearchScreenNavigationArguments arguments = settings.arguments as GlobalSearchScreenNavigationArguments;

      return GlobalSearchScreen(
        arguments: arguments,
      );
    } else {
      return null;
    }
  }

  static Widget? parseFiltersScreen({required RouteSettings settings}) {
    if (settings.arguments is FiltersScreenNavigationArguments) {
      FiltersScreenNavigationArguments arguments = settings.arguments as FiltersScreenNavigationArguments;

      return FiltersScreen(
        arguments: arguments,
      );
    } else {
      return null;
    }
  }

  static Widget? parseSortingScreen({required RouteSettings settings}) {
    if (settings.arguments is SortingScreenNavigationArguments) {
      SortingScreenNavigationArguments arguments = settings.arguments as SortingScreenNavigationArguments;

      return SortingScreen(
        arguments: arguments,
      );
    } else {
      return null;
    }
  }

  //endregion

  //region Catalog Module
  static Widget? parseCatalogContentsListScreen({required RouteSettings settings}) {
    if (settings.arguments is CatalogContentsListScreenNavigationArguments) {
      CatalogContentsListScreenNavigationArguments arguments = settings.arguments as CatalogContentsListScreenNavigationArguments;

      return CatalogContentsListScreen(
        arguments: arguments,
      );
    } else {
      return null;
    }
  }

  static Widget? parseCatalogSubcategoriesListScreen({required RouteSettings settings}) {
    if (settings.arguments is CatalogSubcategoriesListScreenNavigationArguments) {
      CatalogSubcategoriesListScreenNavigationArguments arguments = settings.arguments as CatalogSubcategoriesListScreenNavigationArguments;

      return CatalogSubcategoriesListScreen(
        arguments: arguments,
      );
    } else {
      return null;
    }
  }

  //endregion

  //region My Learning Module
  static Widget? parseMyLearningWaitlistScreen({required RouteSettings settings}) {
    if (settings.arguments is MyLearningWaitlistScreenNavigationArguments) {
      MyLearningWaitlistScreenNavigationArguments arguments = settings.arguments as MyLearningWaitlistScreenNavigationArguments;

      return MyLearningWaitlistScreen(
        arguments: arguments,
      );
    } else {
      return null;
    }
  }

  static Widget? parseViewCompletionCertificateScreen({required RouteSettings settings}) {
    if (settings.arguments is ViewCompletionCertificateScreenNavigationArguments) {
      ViewCompletionCertificateScreenNavigationArguments arguments = settings.arguments as ViewCompletionCertificateScreenNavigationArguments;

      return ViewCompletionCertificateScreen(
        arguments: arguments,
      );
    } else {
      return null;
    }
  }

  static Widget? parseQRCodeImageScreen({required RouteSettings settings}) {
    if (settings.arguments is QRCodeImageScreenNavigationArguments) {
      QRCodeImageScreenNavigationArguments arguments = settings.arguments as QRCodeImageScreenNavigationArguments;

      return QRCodeImageScreen(
        arguments: arguments,
      );
    } else {
      return null;
    }
  }

  //endregion

  //region Share Module
  static Widget? parseShareWithConnectionsScreen({required RouteSettings settings}) {
    if (settings.arguments is ShareWithConnectionsScreenNavigationArguments) {
      ShareWithConnectionsScreenNavigationArguments arguments = settings.arguments as ShareWithConnectionsScreenNavigationArguments;

      return ShareWithConnectionsScreen(
        arguments: arguments,
      );
    } else {
      return null;
    }
  }

  static Widget? parseShareWithPeopleScreen({required RouteSettings settings}) {
    if (settings.arguments is ShareWithPeopleScreenNavigationArguments) {
      ShareWithPeopleScreenNavigationArguments arguments = settings.arguments as ShareWithPeopleScreenNavigationArguments;

      return ShareWithPeopleScreen(
        arguments: arguments,
      );
    } else {
      return null;
    }
  }

  static Widget? parseRecommendToScreen({required RouteSettings settings}) {
    if (settings.arguments is RecommendToScreenNavigationArguments) {
      RecommendToScreenNavigationArguments arguments = settings.arguments as RecommendToScreenNavigationArguments;

      return RecommendToScreen(
        arguments: arguments,
      );
    } else {
      return null;
    }
  }

  //endregion

  // region Progress Report Module
  static Widget? parseMyLearningContentProgressScreen({required RouteSettings settings}) {
    if (settings.arguments is MyLearningContentProgressScreenNavigationArguments) {
      MyLearningContentProgressScreenNavigationArguments arguments = settings.arguments as MyLearningContentProgressScreenNavigationArguments;

      return MyLearningContentProgressScreen(
        arguments: arguments,
      );
    } else {
      return null;
    }
  }

  static Widget? parseProgressReportDetailScreen({required RouteSettings settings}) {
    if (settings.arguments is MyLearningContentProgressScreenNavigationArguments) {
      MyLearningContentProgressScreenNavigationArguments arguments = settings.arguments as MyLearningContentProgressScreenNavigationArguments;

      return ProgressReportDetailScreen(
        arguments: arguments,
      );
    } else {
      return null;
    }
  }

  //endregion

  // region Course Detail Module
  static Widget? parseCourseDetailScreen({required RouteSettings settings}) {
    if (settings.arguments is CourseDetailScreenNavigationArguments) {
      CourseDetailScreenNavigationArguments arguments = settings.arguments as CourseDetailScreenNavigationArguments;

      return CourseDetailScreen(
        arguments: arguments,
      );
    } else {
      return null;
    }
  }

  //endregion

  // region Profile Module
  static Widget? parseUserProfileScreen({required RouteSettings settings}) {
    if (settings.arguments is UserProfileScreenNavigationArguments) {
      UserProfileScreenNavigationArguments arguments = settings.arguments as UserProfileScreenNavigationArguments;

      return UserProfileScreen(
        arguments: arguments,
      );
    } else {
      return null;
    }
  }

  static Widget? parseAddEditExperienceScreen({required RouteSettings settings}) {
    if (settings.arguments is AddEditExperienceScreenNavigationArguments) {
      AddEditExperienceScreenNavigationArguments arguments = settings.arguments as AddEditExperienceScreenNavigationArguments;

      return AddEditExperienceScreen(
        arguments: arguments,
      );
    } else {
      return null;
    }
  }

  static Widget? parseAddEducationScreen({required RouteSettings settings}) {
    if (settings.arguments is AddEducationScreenNavigationArguments) {
      AddEducationScreenNavigationArguments arguments = settings.arguments as AddEducationScreenNavigationArguments;

      return AddEducationScreen(
        arguments: arguments,
      );
    } else {
      return null;
    }
  }

  //endregion

  static Widget? parsePreRequisiteScreen({required RouteSettings settings}) {
    if (settings.arguments is PreRequisiteScreenNavigationArguments) {
      PreRequisiteScreenNavigationArguments arguments = settings.arguments as PreRequisiteScreenNavigationArguments;

      return PrerequisiteScreen(
        arguments: arguments,
      );
    } else {
      return null;
    }
  }

  static Widget? parseEventTrackScreen({required RouteSettings settings}) {
    if (settings.arguments is EventTrackScreenArguments) {
      EventTrackScreenArguments arguments = settings.arguments as EventTrackScreenArguments;

      return EventTrackScreen(
        arguments: arguments,
      );
    } else {
      return null;
    }
  }

  //region Instabot
  static Widget? parseInstaBotScreen2({required RouteSettings settings}) {
    dynamic argument = settings.arguments;
    if (argument is! InstaBotScreen2NavigationArguments) {
      return null;
    }

    return InstaBotScreen2(arguments: argument);
  }

  //endregion

  // region Course Launch
  static Widget? parseCourseLaunchWebViewScreen({required RouteSettings settings}) {
    dynamic argument = settings.arguments;
    if (argument is CourseLaunchWebViewScreenNavigationArguments) {
      return CourseLaunchWebViewScreen(
        arguments: argument,
      );
    } else {
      return null;
    }
  }

  static Widget? parseVideoLaunchScreen({required RouteSettings settings}) {
    dynamic argument = settings.arguments;
    if (argument is VideoLaunchScreenNavigationArguments) {
      return VideoLaunchScreen(
        arguments: argument,
      );
    } else {
      return null;
    }
  }

  static Widget? parsePDFLaunchScreen({required RouteSettings settings}) {
    dynamic argument = settings.arguments;
    if (argument is PDFLaunchScreenNavigationArguments) {
      return PDFLaunchScreen(
        arguments: argument,
      );
    } else {
      return null;
    }
  }

  static Widget? parseWebViewScreen({required RouteSettings settings}) {
    dynamic argument = settings.arguments;
    if (argument is WebViewScreenNavigationArguments) {
      return WebViewScreen(
        arguments: argument,
      );
    } else {
      return null;
    }
  }

  //endregion Lens Feature Module

  static Widget? parseLensScreen({required RouteSettings settings}) {
    dynamic argument = settings.arguments;
    if (argument is! LensScreenNavigationArguments) {
      return null;
    }

    return LensScreen(arguments: argument);
  }

  static Widget? parseSurfaceTrackingKeywordSearchScreen({required RouteSettings settings}) {
    dynamic argument = settings.arguments;
    if (argument is! SurfaceTrackingKeywordSearchScreenNavigationArguments) {
      return null;
    }

    return SurfaceTrackingKeywordSearchScreen(arguments: argument);
  }

  //region Membership
  static Widget? parseMembershipSelectionScreen({required RouteSettings settings}) {
    dynamic argument = settings.arguments;
    if (argument is! MembershipSelectionScreenNavigationArguments) {
      return null;
    }

    return MembershipSelectionScreen(arguments: argument);
  }

  static Widget? parseUserMembershipDetailsScreen({required RouteSettings settings}) {
    dynamic argument = settings.arguments;
    if (argument is! UserMembershipDetailsScreenNavigationArguments) {
      return null;
    }

    return UserMembershipDetailsScreen(arguments: argument);
  }

  //endregion

  // region Settings
  static Widget? parsePurchaseHistoryScreen({required RouteSettings settings}) {
    dynamic argument = settings.arguments;
    if (argument is! PurchaseHistoryScreenNavigationArguments) {
      return null;
    }

    return PurchaseHistoryScreen(arguments: argument);
  }

  static Widget? parseReEnrollmentHistoryScreen({required RouteSettings settings}) {
    dynamic argument = settings.arguments;
    if (argument is! ReEnrollmentHistoryScreenNavigationArguments) {
      return null;
    }

    return ReEnrollmentHistory(arguments: argument);
  }

  static Widget? parseCreateEditTopicScreen({required RouteSettings settings}) {
    dynamic argument = settings.arguments;
    if (argument is! CreateEditTopicScreenNavigationArguments) {
      return null;
    }
    return CreateEditTopicScreen(
      arguments: argument,
    );
  }

  static Widget? parseCreateEditDiscussionForumScreen({required RouteSettings settings}) {
    dynamic argument = settings.arguments;
    if (argument is! CreateEditDiscussionForumScreenNavigationArguments) {
      return null;
    }
    return CreateEditDiscussionForumScreen(
      arguments: argument,
    );
  }

  static Widget? parseDiscussionDetailScreen({required RouteSettings settings}) {
    dynamic argument = settings.arguments;
    if (argument is! DiscussionDetailScreenNavigationArguments) {
      return null;
    }
    return DiscussionDetailScreen(arguments: argument);
  }

  static Widget? parseCommonViewImageScreen({required RouteSettings settings}) {
    dynamic argument = settings.arguments;
    if (argument is! CommonViewImageScreenNavigationArguments) {
      return null;
    }
    return CommonViewImageScreen(arguments: argument);
  }

  static Widget? parseCategoriesSearchScreen({required RouteSettings settings}) {
    dynamic argument = settings.arguments;
    if (argument is! DiscussionForumCategoriesSearchScreenNavigationArguments) {
      return null;
    }
    return CategoriesSearchScreen(
      arguments: argument,
    );
  }

  //region Camera

  //endregion

  //endregion

  //region Feedback
  static Widget? parseAddFeedbackScreen({required RouteSettings settings}) {
    dynamic argument = settings.arguments;
    // if (argument is! PurchaseHistoryScreenNavigationArguments) {
    //   return null;
    // }

    return const AddFeedbackScreen();
  }

  static Widget? parseQuestionAndAnswerDetailsScreen({required RouteSettings settings}) {
    dynamic argument = settings.arguments;
    if (argument is! QuestionAndAnswerDetailsScreenArguments) {
      return null;
    }

    return QuestionAndAnswerDetailsScreen(
      arguments: argument,
    );
  }

  static Widget? parseAddEditAnswerScreen({required RouteSettings settings}) {
    dynamic argument = settings.arguments;
    if (argument is! AddEditAnswerScreenNavigationArguments) {
      return null;
    }

    return AddEditAnswerScreen(
      arguments: argument,
    );
  }

  static Widget? parseCreateEditAddQuestionScreen({required RouteSettings settings}) {
    dynamic argument = settings.arguments;
    if (argument is! CreateEditQuestionNavigationArguments) {
      return null;
    }

    return CreateEditQuestionScreen(arguments: argument);
  }

  static Widget? parseFilterSkillScreen({required RouteSettings settings}) {
    dynamic argument = settings.arguments;
    if (argument is! FilterSkillsScreenNavigationArguments) {
      return null;
    }

    return FilterSkillsScreen(arguments: argument);
  }

  //endregion
  //endregion

  //region Navigation Methods
  //region Common
  static Future<dynamic> navigateToSplashScreen({required NavigationOperationParameters navigationOperationParameters}) async {
    return NavigationOperation.navigate(
      navigationOperationParameters: navigationOperationParameters.copyWith(
        routeName: SplashScreen.routeName,
      ),
    );
  }

  //endregion

  //region Authentication
  static Future<dynamic> navigateToLoginScreen({
    required NavigationOperationParameters navigationOperationParameters,
    required LoginScreenNavigationArguments arguments,
  }) async {
    return NavigationOperation.navigate(
      navigationOperationParameters: navigationOperationParameters.copyWith(
        routeName: LoginScreen.routeName,
        arguments: arguments,
      ),
    );
  }

  static Future<dynamic> navigateToForgotPassword({
    required NavigationOperationParameters navigationOperationParameters,
    required ForgotPasswordNavigationArguments arguments,
  }) async {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: ForgotPassword.routeName,
      arguments: arguments,
    ));
  }

  //endregion

  //region Wiki Component
  static Future<dynamic> navigateToAddWikiContentScreen({
    required NavigationOperationParameters navigationOperationParameters,
    required AddWikiContentScreenNavigationArguments arguments,
  }) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: AddWikiContentScreen.routeName,
      arguments: arguments,
    ));
  }

  //endregion

  //region Filter Module
  static Future<dynamic> navigateToGlobalSearchScreen({
    required NavigationOperationParameters navigationOperationParameters,
    required GlobalSearchScreenNavigationArguments arguments,
  }) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: GlobalSearchScreen.routeName,
      arguments: arguments,
    ));
  }

  static Future<dynamic> navigateToFiltersScreen({
    required NavigationOperationParameters navigationOperationParameters,
    required FiltersScreenNavigationArguments arguments,
  }) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: FiltersScreen.routeName,
      arguments: arguments,
    ));
  }

  static Future<dynamic> navigateToSortingScreen({
    required NavigationOperationParameters navigationOperationParameters,
    required SortingScreenNavigationArguments arguments,
  }) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: SortingScreen.routeName,
      arguments: arguments,
    ));
  }

  //endregion

  //region Wishlist
  static Future<dynamic> navigateToWishlist({
    required NavigationOperationParameters navigationOperationParameters,
    required WishListScreenNavigationArguments arguments,
  }) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: WishListScreen.routeName,
      arguments: arguments,
    ));
  }

  //endregion

  //region Catalog Module
  static Future<dynamic> navigateToCatalogContentsListScreen({
    required NavigationOperationParameters navigationOperationParameters,
    required CatalogContentsListScreenNavigationArguments arguments,
  }) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: CatalogContentsListScreen.routeName,
      arguments: arguments,
    ));
  }

  static Future<dynamic> navigateToCatalogSubcategoriesListScreen({
    required NavigationOperationParameters navigationOperationParameters,
    required CatalogSubcategoriesListScreenNavigationArguments arguments,
  }) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: CatalogSubcategoriesListScreen.routeName,
      arguments: arguments,
    ));
  }

  //endregion

  //region My Learning Module
  static Future<dynamic> navigateToMyLearningWaitlistScreen({
    required NavigationOperationParameters navigationOperationParameters,
    required MyLearningWaitlistScreenNavigationArguments arguments,
  }) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: MyLearningWaitlistScreen.routeName,
      arguments: arguments,
    ));
  }

  static Future<dynamic> navigateToViewCompletionCertificateScreen({
    required NavigationOperationParameters navigationOperationParameters,
    required ViewCompletionCertificateScreenNavigationArguments arguments,
  }) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: ViewCompletionCertificateScreen.routeName,
      arguments: arguments,
    ));
  }

  static Future<dynamic> navigateToQRCodeImageScreen({
    required NavigationOperationParameters navigationOperationParameters,
    required QRCodeImageScreenNavigationArguments arguments,
  }) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: QRCodeImageScreen.routeName,
      arguments: arguments,
    ));
  }

  //endregion

  //region Share Module
  static Future<dynamic> navigateToShareWithConnectionsScreen({
    required NavigationOperationParameters navigationOperationParameters,
    required ShareWithConnectionsScreenNavigationArguments arguments,
  }) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: ShareWithConnectionsScreen.routeName,
      arguments: arguments,
    ));
  }

  static Future<dynamic> navigateToShareWithPeopleScreen({
    required NavigationOperationParameters navigationOperationParameters,
    required ShareWithPeopleScreenNavigationArguments arguments,
  }) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: ShareWithPeopleScreen.routeName,
      arguments: arguments,
    ));
  }

  static Future<dynamic> navigateToRecommendToScreen({
    required NavigationOperationParameters navigationOperationParameters,
    required RecommendToScreenNavigationArguments arguments,
  }) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: RecommendToScreen.routeName,
      arguments: arguments,
    ));
  }

  //endregion

  // region Progress Report Module
  static Future<dynamic> navigateToMyLearningContentProgressScreen({
    required NavigationOperationParameters navigationOperationParameters,
    required MyLearningContentProgressScreenNavigationArguments arguments,
  }) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: MyLearningContentProgressScreen.routeName,
      arguments: arguments,
    ));
  }

  static Future<dynamic> navigateToProgressReportDetailScreen({
    required NavigationOperationParameters navigationOperationParameters,
    required MyLearningContentProgressScreenNavigationArguments arguments,
  }) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: ProgressReportDetailScreen.routeName,
      arguments: arguments,
    ));
  }

  //endregion

  // region Course Detail Module
  static Future<dynamic> navigateToCourseDetailScreen({
    required NavigationOperationParameters navigationOperationParameters,
    required CourseDetailScreenNavigationArguments arguments,
  }) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: CourseDetailScreen.routeName,
      arguments: arguments,
    ));
  }

  //endregion

  // region Profile Module
  static Future<dynamic> navigateToUserProfileScreen({
    required NavigationOperationParameters navigationOperationParameters,
    required UserProfileScreenNavigationArguments arguments,
  }) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: UserProfileScreen.routeName,
      arguments: arguments,
    ));
  }

  static Future<dynamic> navigateToAddEditExperienceScreen({
    required NavigationOperationParameters navigationOperationParameters,
    required AddEditExperienceScreenNavigationArguments arguments,
  }) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: AddEditExperienceScreen.routeName,
      arguments: arguments,
    ));
  }

  static Future<dynamic> navigateToAddEducationScreen({
    required NavigationOperationParameters navigationOperationParameters,
    required AddEducationScreenNavigationArguments arguments,
  }) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: AddEducationScreen.routeName,
      arguments: arguments,
    ));
  }

  //endregion

  //region PreRequisite  Module
  static Future<dynamic> navigateToPreRequisiteScreen({
    required NavigationOperationParameters navigationOperationParameters,
    required PreRequisiteScreenNavigationArguments arguments,
  }) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: PrerequisiteScreen.routeName,
      arguments: arguments,
    ));
  }

  //endregion

  //region Instabot
  static Future<dynamic> navigateToInstaBotScreen2({
    required NavigationOperationParameters navigationOperationParameters,
    required InstaBotScreen2NavigationArguments arguments,
  }) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: InstaBotScreen2.routeName,
      arguments: arguments,
    ));
  }

  //endregion

  //region Course Launch
  static Future<dynamic> navigateToCourseLaunchWebViewScreen({
    required NavigationOperationParameters navigationOperationParameters,
    required CourseLaunchWebViewScreenNavigationArguments arguments,
  }) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: CourseLaunchWebViewScreen.routeName,
      arguments: arguments,
    ));
  }

  static Future<dynamic> navigateToVideoLaunchScreen({
    required NavigationOperationParameters navigationOperationParameters,
    required VideoLaunchScreenNavigationArguments arguments,
  }) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: VideoLaunchScreen.routeName,
      arguments: arguments,
    ));
  }

  static Future<dynamic> navigateToPDFLaunchScreen({
    required NavigationOperationParameters navigationOperationParameters,
    required PDFLaunchScreenNavigationArguments arguments,
  }) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: PDFLaunchScreen.routeName,
      arguments: arguments,
    ));
  }

  static Future<dynamic> navigateToWebViewScreen({
    required NavigationOperationParameters navigationOperationParameters,
    required WebViewScreenNavigationArguments arguments,
  }) {
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: WebViewScreen.routeName,
      arguments: arguments,
    ));
  }

  //endregion

  //region Learning Path Module
  static Future<dynamic> navigateToEventTrackScreen({
    required NavigationOperationParameters navigationOperationParameters,
    required EventTrackScreenArguments arguments,
  }) {
    MyPrint.printOnConsole("navigateToEventTrackScreen called with navigationType:${navigationOperationParameters.navigationType}");
    return NavigationOperation.navigate(
        navigationOperationParameters: navigationOperationParameters.copyWith(
      routeName: EventTrackScreen.routeName,
      arguments: arguments,
    ));
  }

//endregion

  // region Lens Module
  static Future<dynamic> navigateToLensScreen({required NavigationOperationParameters navigationOperationParameters, required LensScreenNavigationArguments arguments}) {
    MyPrint.printOnConsole("navigateToLensScreen called with navigationType:${navigationOperationParameters.navigationType}");
    return NavigationOperation.navigate(
      navigationOperationParameters: navigationOperationParameters.copyWith(
        routeName: LensScreen.routeName,
        arguments: arguments,
      ),
    );
  }

  static Future<dynamic> navigateToSurfaceTrackingKeywordSearchScreen({
    required NavigationOperationParameters navigationOperationParameters,
    required SurfaceTrackingKeywordSearchScreenNavigationArguments arguments,
  }) {
    MyPrint.printOnConsole("SurfaceTrackingKeywordSearchScreen called with navigationType:${navigationOperationParameters.navigationType}");
    return NavigationOperation.navigate(
      navigationOperationParameters: navigationOperationParameters.copyWith(
        routeName: SurfaceTrackingKeywordSearchScreen.routeName,
        arguments: arguments,
      ),
    );
  }

//endregion

  //region Membership
  static Future<dynamic> navigateToMembershipSelectionScreen({
    required NavigationOperationParameters navigationOperationParameters,
    required MembershipSelectionScreenNavigationArguments arguments,
  }) {
    return NavigationOperation.navigate(
      navigationOperationParameters: navigationOperationParameters.copyWith(
        routeName: MembershipSelectionScreen.routeName,
        arguments: arguments,
      ),
    );
  }

  static Future<dynamic> navigateToUserMembershipDetailsScreen({
    required NavigationOperationParameters navigationOperationParameters,
    required UserMembershipDetailsScreenNavigationArguments arguments,
  }) {
    return NavigationOperation.navigate(
      navigationOperationParameters: navigationOperationParameters.copyWith(
        routeName: UserMembershipDetailsScreen.routeName,
        arguments: arguments,
      ),
    );
  }

//endregion

// region Settings
  static Future<dynamic> navigateToPurchaseHistoryScreen({
    required NavigationOperationParameters navigationOperationParameters,
    required PurchaseHistoryScreenNavigationArguments arguments,
  }) {
    return NavigationOperation.navigate(
      navigationOperationParameters: navigationOperationParameters.copyWith(
        routeName: PurchaseHistoryScreen.routeName,
        arguments: arguments,
      ),
    );
  }

//endregion

//region ReEnrollmentHistory Module
  static Future<dynamic> navigateToReEnrollmentHistoryScreen({required NavigationOperationParameters navigationOperationParameters, required ReEnrollmentHistoryScreenNavigationArguments arguments}) {
    MyPrint.printOnConsole("navigateToLensScreen called with navigationType:${navigationOperationParameters.navigationType}");
    return NavigationOperation.navigate(
      navigationOperationParameters: navigationOperationParameters.copyWith(
        routeName: ReEnrollmentHistory.routeName,
        arguments: arguments,
      ),
    );
  }

//endregion
// region Discussion Forum Module
  static Future<dynamic> navigateToDiscussionDetailScreen({required NavigationOperationParameters navigationOperationParameters, required DiscussionDetailScreenNavigationArguments arguments}) {
    MyPrint.printOnConsole("navigateToDiscussionDetail called with navigationType:${navigationOperationParameters.navigationType}");
    return NavigationOperation.navigate(
      navigationOperationParameters: navigationOperationParameters.copyWith(
        routeName: DiscussionDetailScreen.routeName,
        arguments: arguments,
      ),
    );
  }

  static Future<dynamic> navigateToCreateEditDiscussionForumScreen({
    required NavigationOperationParameters navigationOperationParameters,
    required CreateEditDiscussionForumScreenNavigationArguments arguments,
  }) {
    MyPrint.printOnConsole("v called with navigationType:${navigationOperationParameters.navigationType}");
    return NavigationOperation.navigate(
      navigationOperationParameters: navigationOperationParameters.copyWith(
        routeName: CreateEditDiscussionForumScreen.routeName,
        arguments: arguments,
      ),
    );
  }

  static Future<dynamic> navigateToCreateEditTopicScreen({required NavigationOperationParameters navigationOperationParameters, required CreateEditTopicScreenNavigationArguments arguments}) {
    MyPrint.printOnConsole("navigateToAddTopicScreen called with navigationType:${navigationOperationParameters.navigationType}");
    return NavigationOperation.navigate(
      navigationOperationParameters: navigationOperationParameters.copyWith(
        routeName: CreateEditTopicScreen.routeName,
        arguments: arguments,
      ),
    );
  }

  static Future<dynamic> navigateToCommonViewImageScreen({required NavigationOperationParameters navigationOperationParameters, required CommonViewImageScreenNavigationArguments arguments}) {
    MyPrint.printOnConsole("navigateToAddTopicScreen called with navigationType:${navigationOperationParameters.navigationType}");
    return NavigationOperation.navigate(
      navigationOperationParameters: navigationOperationParameters.copyWith(
        routeName: CommonViewImageScreen.routeName,
        arguments: arguments,
      ),
    );
  }

  static Future<dynamic> navigateToCategoriesSearchScreen({required NavigationOperationParameters navigationOperationParameters}) {
    MyPrint.printOnConsole("navigateToCategoriesSearchScreen called with navigationType:${navigationOperationParameters.navigationType}");
    return NavigationOperation.navigate(
      navigationOperationParameters: navigationOperationParameters.copyWith(
        routeName: CategoriesSearchScreen.routeName,
      ),
    );
  }

//endregion

//region Feedback
  static Future<dynamic> navigateToAddFeedbackScreen({required NavigationOperationParameters navigationOperationParameters}) {
    MyPrint.printOnConsole("navigateToCategoriesSearchScreen called with navigationType:${navigationOperationParameters.navigationType}");
    return NavigationOperation.navigate(
      navigationOperationParameters: navigationOperationParameters.copyWith(
        routeName: AddFeedbackScreen.routeName,
      ),
    );
  }

//endregion
//endregion

  static Future<dynamic> navigateToCreateAddEditQuestionScreen({required NavigationOperationParameters navigationOperationParameters, required CreateEditQuestionNavigationArguments arguments}) {
    MyPrint.printOnConsole("navigateToAddTopicScreen called with navigationType:${navigationOperationParameters.navigationType}");
    return NavigationOperation.navigate(
      navigationOperationParameters: navigationOperationParameters.copyWith(
        routeName: CreateEditQuestionScreen.routeName,
        arguments: arguments,
      ),
    );
  }

  static Future<dynamic> navigateToQuestionAndAnswerDetailScreen({required NavigationOperationParameters navigationOperationParameters, required QuestionAndAnswerDetailsScreenArguments arguments}) {
    MyPrint.printOnConsole("navigateToCategoriesSearchScreen called with navigationType:${navigationOperationParameters.navigationType}");
    return NavigationOperation.navigate(
      navigationOperationParameters: navigationOperationParameters.copyWith(routeName: QuestionAndAnswerDetailsScreen.routeName, arguments: arguments),
    );
  }

  static Future<dynamic> navigateToAddEditAnswerScreen({required NavigationOperationParameters navigationOperationParameters, required AddEditAnswerScreenNavigationArguments arguments}) {
    MyPrint.printOnConsole("navigateToCategoriesSearchScreen called with navigationType:${navigationOperationParameters.navigationType}");
    return NavigationOperation.navigate(
      navigationOperationParameters: navigationOperationParameters.copyWith(routeName: AddEditAnswerScreen.routeName, arguments: arguments),
    );
  }

  static Future<dynamic> navigateToFilterSkillsScreen({required NavigationOperationParameters navigationOperationParameters, required FilterSkillsScreenNavigationArguments arguments}) {
    MyPrint.printOnConsole("navigateToCategoriesSearchScreen called with navigationType:${navigationOperationParameters.navigationType}");
    return NavigationOperation.navigate(
      navigationOperationParameters: navigationOperationParameters.copyWith(routeName: FilterSkillsScreen.routeName, arguments: arguments),
    );
  }
}
