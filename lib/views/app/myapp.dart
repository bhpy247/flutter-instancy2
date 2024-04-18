import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/api/api_url_configuration_provider.dart';
import 'package:flutter_instancy_2/backend/app/app_controller.dart';
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
        ChangeNotifierProvider<AppProvider>(create: (_) => AppProvider()),
        ChangeNotifierProvider<AppThemeProvider>(create: (_) => AppThemeProvider()),
        ChangeNotifierProvider<AuthenticationProvider>(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider<MainScreenProvider>(create: (_) => MainScreenProvider()),
        ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider()),
        ChangeNotifierProvider<ProfileProvider>(create: (_) => ProfileProvider()),
        ChangeNotifierProvider<FilterProvider>(create: (_) => FilterProvider()),
        ChangeNotifierProvider<CatalogProvider>(create: (_) => CatalogProvider()),
        ChangeNotifierProvider<WikiProvider>(create: (_) => WikiProvider()),
        ChangeNotifierProvider<MyLearningProvider>(create: (_) => MyLearningProvider()),
        ChangeNotifierProvider<EventProvider>(create: (_) => EventProvider()),
        ChangeNotifierProvider<ShareProvider>(create: (_) => ShareProvider()),
        ChangeNotifierProvider<ProgressReportProvider>(create: (_) => ProgressReportProvider()),
        ChangeNotifierProvider<ContentReviewRatingsProvider>(create: (_) => ContentReviewRatingsProvider()),
        ChangeNotifierProvider<EventTrackProvider>(create: (_) => EventTrackProvider()),
        ChangeNotifierProvider<InstaBotProvider>(create: (_) => InstaBotProvider()),
        ChangeNotifierProvider<MessageProvider>(create: (_) => MessageProvider()),
        ChangeNotifierProvider<MembershipProvider>(create: (_) => MembershipProvider()),
        ChangeNotifierProvider<InAppPurchaseProvider>(create: (_) => InAppPurchaseProvider()),
        ChangeNotifierProvider<DiscussionProvider>(create: (_) => DiscussionProvider()),
        ChangeNotifierProvider<GamificationProvider>(create: (_) => GamificationProvider()),
        ChangeNotifierProvider<CourseDownloadProvider>.value(value: CourseDownloadProvider()),
        ChangeNotifierProvider<FeedbackProvider>(create: (_) => FeedbackProvider()),
        ChangeNotifierProvider<AskTheExpertProvider>(create: (_) => AskTheExpertProvider()),
        ChangeNotifierProvider<MyConnectionsProvider>(create: (_) => MyConnectionsProvider()),
        ChangeNotifierProvider<NetworkConnectionProvider>(create: (_) => NetworkConnectionController().networkConnectionProvider),
        ChangeNotifierProvider<LearningCommunitiesProvider>(create: (_) => LearningCommunitiesProvider()),
        ChangeNotifierProvider<GlobalSearchProvider>(create: (_) => GlobalSearchProvider()),
        ChangeNotifierProvider<CoCreateKnowledgeProvider>(create: (_) => CoCreateKnowledgeProvider()),
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
