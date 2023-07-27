import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';
import 'package:flutter_instancy_2/views/authentication/screens/forgot_password_screen.dart';
import 'package:flutter_instancy_2/views/authentication/screens/login_screen.dart';
import 'package:flutter_instancy_2/views/authentication/screens/sign_up_screen.dart';
import 'package:flutter_instancy_2/views/catalog/screens/PrerequisiteScreen.dart';
import 'package:flutter_instancy_2/views/course_details/screens/course_details_screen.dart';
import 'package:flutter_instancy_2/views/event_track/screens/event_track_screen.dart';
import 'package:flutter_instancy_2/views/main_screen/screens/main_screen.dart';
import 'package:flutter_instancy_2/views/my_learning_plus/screens/my_learning_plus.dart';
import 'package:flutter_instancy_2/views/profile/component/add_education_screen.dart';
import 'package:flutter_instancy_2/views/share/recommend_to_screen.dart';
import 'package:flutter_instancy_2/views/wiki_component/screens/add_wiki_content_screen.dart';
import 'package:flutter_instancy_2/views/wishlist/screen/wishlist_screen.dart';

import '../../utils/my_print.dart';
import '../../views/app/splashscreen.dart';
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
import '../../views/my_learning/screens/mylearning_waitlist_screen.dart';
import '../../views/my_learning/screens/qr_code_image_screen.dart';
import '../../views/my_learning/screens/view_completion_certificate_screen.dart';
import '../../views/profile/screens/add_edit_experience_screen.dart';
import '../../views/profile/screens/user_profile_screen.dart';
import '../../views/progress_report/screens/my_learning_content_progress_screen.dart';
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
          Map<String, dynamic> argument = ParsingHelper.parseMapMethod(settings.arguments);

          int selectedSectionIndex = ParsingHelper.parseIntMethod(argument['selectedSectionIndex'], defaultValue: 0);

          page = LoginScreen(
            selectedSectionIndex: selectedSectionIndex,
          );
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
    }

    if (page != null) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => page!,
        //transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
        transitionsBuilder: (c, anim, a2, child) => SizeTransition(sizeFactor: anim, child: child),
        transitionDuration: const Duration(milliseconds: 0),
        settings: settings,
      );
    } else {
      return null;
    }
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

  //endregion
  //endregion

  //region Navigation Methods
  //region Authentication
  static Future<dynamic> navigateToLoginScreen({BuildContext? context, int selectedSectionIndex = 0}) async {
    return await Navigator.pushNamed(context ?? mainNavigatorKey.currentContext!, LoginScreen.routeName, arguments: {
      "selectedSectionIndex": selectedSectionIndex,
    });
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
//endregion
}
