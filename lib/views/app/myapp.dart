import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/api/api_url_configuration_provider.dart';
import 'package:flutter_instancy_2/backend/app/app_controller.dart';
import 'package:flutter_instancy_2/backend/app/dependency_injection.dart';
import 'package:flutter_instancy_2/backend/app_theme/app_theme_controller.dart';
import 'package:flutter_instancy_2/backend/ask_the_expert/ask_the_expert_provider.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_provider.dart';
import 'package:flutter_instancy_2/backend/course_download/course_download_provider.dart';
import 'package:flutter_instancy_2/backend/discussion/discussion_provider.dart';
import 'package:flutter_instancy_2/backend/download/flutter_download_controller.dart';
import 'package:flutter_instancy_2/backend/feedback/feedback_provider.dart';
import 'package:flutter_instancy_2/backend/filter/filter_provider.dart';
import 'package:flutter_instancy_2/backend/gamification/gamification_provider.dart';
import 'package:flutter_instancy_2/backend/global_search/global_search_provider.dart';
import 'package:flutter_instancy_2/backend/learning_communities/learning_communities_provider.dart';
import 'package:flutter_instancy_2/backend/main_screen/main_screen_provider.dart';
import 'package:flutter_instancy_2/backend/membership/membership_provider.dart';
import 'package:flutter_instancy_2/backend/message/message_provider.dart';
import 'package:flutter_instancy_2/backend/my_connections/my_connections_provider.dart';
import 'package:flutter_instancy_2/backend/my_learning/my_learning_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/backend/network_connection/network_connection_controller.dart';
import 'package:flutter_instancy_2/backend/network_connection/network_connection_provider.dart';
import 'package:flutter_instancy_2/backend/share/share_provider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import '../../backend/Catalog/catalog_provider.dart';
import '../../backend/app/app_provider.dart';
import '../../backend/app_theme/app_theme_provider.dart';
import '../../backend/authentication/authentication_provider.dart';
import '../../backend/content_review_ratings/content_review_ratings_provider.dart';
import '../../backend/event/event_provider.dart';
import '../../backend/event_track/event_track_provider.dart';
import '../../backend/home/home_provider.dart';
import '../../backend/in_app_purchase/in_app_purchase_provider.dart';
import '../../backend/instabot/instabot_provider.dart';
import '../../backend/profile/profile_provider.dart';
import '../../backend/progress_report/progress_report_provider.dart';
import '../../backend/wiki_component/wiki_provider.dart';

class MyApp extends StatefulWidget {
  final String mainSiteUrl;
  final int clientUrlType;

  const MyApp({
    Key? key,
    required this.mainSiteUrl,
    required this.clientUrlType,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    ApiUrlConfigurationProvider apiDataProvider = ApiController().apiDataProvider;
    apiDataProvider.setMainSiteUrl(widget.mainSiteUrl);
    apiDataProvider.setMainClientUrlType(widget.clientUrlType);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppProvider>.value(value: DependencyInjection.appProvider),
        ChangeNotifierProvider<AppThemeProvider>(create: (_) => AppThemeProvider()),
        ChangeNotifierProvider<AuthenticationProvider>(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider<MainScreenProvider>(create: (_) => MainScreenProvider()),
        ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider()),
        ChangeNotifierProvider<ProfileProvider>.value(value: DependencyInjection.profileProvider),
        ChangeNotifierProvider<FilterProvider>.value(value: DependencyInjection.filterProvider),
        ChangeNotifierProvider<CatalogProvider>.value(value: DependencyInjection.catalogProvider),
        ChangeNotifierProvider<WikiProvider>.value(value: DependencyInjection.wikiProvider),
        ChangeNotifierProvider<MyLearningProvider>.value(value: DependencyInjection.myLearningProvider),
        ChangeNotifierProvider<EventProvider>.value(value: DependencyInjection.eventProvider),
        ChangeNotifierProvider<ShareProvider>.value(value: DependencyInjection.shareProvider),
        ChangeNotifierProvider<ProgressReportProvider>.value(value: DependencyInjection.progressReportProvider),
        ChangeNotifierProvider<ContentReviewRatingsProvider>.value(value: DependencyInjection.contentReviewRatingsProvider),
        ChangeNotifierProvider<EventTrackProvider>.value(value: DependencyInjection.eventTrackProvider),
        ChangeNotifierProvider<InstaBotProvider>.value(value: DependencyInjection.instaBotProvider),
        ChangeNotifierProvider<MessageProvider>.value(value: DependencyInjection.messageProvider),
        ChangeNotifierProvider<MembershipProvider>.value(value: DependencyInjection.membershipProvider),
        ChangeNotifierProvider<InAppPurchaseProvider>.value(value: DependencyInjection.inAppPurchaseProvider),
        ChangeNotifierProvider<DiscussionProvider>.value(value: DependencyInjection.discussionProvider),
        ChangeNotifierProvider<GamificationProvider>.value(value: DependencyInjection.gamificationProvider),
        ChangeNotifierProvider<FeedbackProvider>.value(value: DependencyInjection.feedbackProvider),
        ChangeNotifierProvider<AskTheExpertProvider>.value(value: DependencyInjection.askTheExpertProvider),
        ChangeNotifierProvider<MyConnectionsProvider>.value(value: DependencyInjection.myConnectionsProvider),
        ChangeNotifierProvider<LearningCommunitiesProvider>.value(value: DependencyInjection.learningCommunitiesProvider),
        ChangeNotifierProvider<GlobalSearchProvider>.value(value: DependencyInjection.globalSearchProvider),
        ChangeNotifierProvider<CoCreateKnowledgeProvider>.value(value: DependencyInjection.coCreateKnowledgeProvider),
        ChangeNotifierProvider<CourseDownloadProvider>.value(value: DependencyInjection.courseDownloadProvider),
        ChangeNotifierProvider<NetworkConnectionProvider>(create: (_) => NetworkConnectionController().networkConnectionProvider),
      ],
      child: Builder(
        builder: (BuildContext context) {
          AppController.mainAppContext = context;
          return const MainApp();
        },
      ),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppThemeController(appThemeProvider: Provider.of<AppThemeProvider>(context, listen: false)).init();
    });

    FlutterDownloadController.initializeListeners();

    NavigationController.mainNavigatorKey = GlobalKey<NavigatorState>();
  }

  @override
  void dispose() {
    NavigationController.mainNavigatorKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeProvider>(
      builder: (BuildContext context, AppThemeProvider appThemeProvider, Widget? child) {
        // MyPrint.printOnConsole("appThemeProvider:${appThemeProvider.darkThemeMode}");
        return OverlaySupport.global(
          child: MaterialApp(
            navigatorKey: NavigationController.mainNavigatorKey,
            onGenerateRoute: NavigationController.onMainGeneratedRoutes,
            debugShowCheckedModeBanner: false,
            title: 'Instancy',
            theme: appThemeProvider.getThemeData(),
            navigatorObservers: [observer],
            localizationsDelegates: const [
              /*AppTranslationsDelegate(
                  newLocale:
                  BlocProvider.of<AppBloc>(context).appLocale),
              //provides localised strings
              GlobalMaterialLocalizations.delegate,
              //provides RTL support
              GlobalWidgetsLocalizations.delegate,*/
            ],
            supportedLocales: const [
              Locale("en", ""),
              Locale("ar", ""),
              Locale("hi", ""),
            ],
            builder: (context, child) => Overlay(
              initialEntries: [
                if (child != null) ...[
                  OverlayEntry(
                    builder: (context) => child,
                  ),
                ],
              ],
            ),
            // locale: BlocProvider.of<AppBloc>(context).appLocale,
          ),
        );
      },
    );
  }
}
