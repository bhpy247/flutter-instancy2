import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/gamification/gamification_controller.dart';
import 'package:flutter_instancy_2/backend/gamification/gamification_provider.dart';
import 'package:flutter_instancy_2/models/gamification/data_model/games_dto_model.dart';
import 'package:flutter_instancy_2/models/gamification/data_model/user_over_all_data_model.dart';
import 'package:flutter_instancy_2/models/gamification/response_model/leader_board_dto_model.dart';
import 'package:flutter_instancy_2/models/gamification/response_model/user_achievement_dto_model.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:flutter_instancy_2/views/my_achievements/components/badges_tab_screen.dart';
import 'package:flutter_instancy_2/views/my_achievements/components/level_tab_screen.dart';
import 'package:flutter_instancy_2/views/my_achievements/components/point_tab_screen.dart';
import 'package:flutter_instancy_2/views/my_achievements/components/user_overall_data_widget.dart';
import 'package:provider/provider.dart';

import '../../../backend/navigation/navigation_arguments.dart';
import '../components/leaders_tab_screen.dart';

class MyAchievementComponentWidget extends StatefulWidget {
  final MyAchievementWidgetNavigationArguments arguments;

  const MyAchievementComponentWidget({
    super.key,
    required this.arguments,
  });

  @override
  State<MyAchievementComponentWidget> createState() => _MyAchievementComponentWidgetState();
}

class _MyAchievementComponentWidgetState extends State<MyAchievementComponentWidget> with MySafeState, TickerProviderStateMixin {
  bool isLoading = false;
  TabController? tabController;

  late GamificationProvider gamificationProvider;
  late GamificationController gamificationController;

  List<Widget> tabsList = <Widget>[];
  List<Widget> tabScreensList = <Widget>[];

  Future<void> initialize({GamificationProvider? provider, bool isNotify = true}) async {
    gamificationProvider = provider ?? GamificationProvider();
    gamificationController = GamificationController(provider: gamificationProvider);

    gamificationProvider.myAchievementComponentId.set(value: widget.arguments.componentId, isNotify: false);
    gamificationProvider.myAchievementRepositoryId.set(value: widget.arguments.componentInsId, isNotify: false);

    List<GamesDTOModel> gamesList = await gamificationController.getUserGamesList(
      isRefresh: false,
      isNotify: isNotify,
    );

    GamesDTOModel? gamesDTOModel = gamesList.firstOrNull;
    await getUserAchievementsDataForGame(
      gamesDTOModel: gamesDTOModel,
      isRefresh: gamesDTOModel?.GameID != gamificationProvider.selectedGameModel.get()?.GameID,
    );
  }

  Future<void> getUserAchievementsDataForGame({required GamesDTOModel? gamesDTOModel, bool isRefresh = true}) async {
    gamificationProvider.selectedGameModel.set(value: gamesDTOModel, isNotify: true);

    if (gamesDTOModel == null) {
      return;
    }

    UserAchievementDTOModel? userAchievementDTOModel;
    LeaderBoardDTOModel? leaderBoardDTOModel;

    await Future.wait([
      gamificationController
          .getUserAchievementsData(
            isRefresh: isRefresh,
            isNotify: false,
          )
          .then((value) => userAchievementDTOModel = value),
      gamificationController
          .getLeaderBoardData(
            isRefresh: isRefresh,
            isNotify: false,
          )
          .then((value) => leaderBoardDTOModel = value),
    ]);

    tabsList = [
      Tab(
        child: Text(
          "Leaders",
          style: themeData.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      if (userAchievementDTOModel?.showPointSection ?? false)
        Tab(
          child: Text(
            "Points",
            style: themeData.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      if (userAchievementDTOModel?.showBadgeSection ?? false)
        Tab(
          child: Text(
            "Badges",
            style: themeData.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      if (userAchievementDTOModel?.showLevelSection ?? false)
        Tab(
          child: Text(
            "Levels",
            style: themeData.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
    ];

    tabScreensList = [
      LeadersTabScreen(
        isLoadingData: false,
        leaderBoardDTOModel: leaderBoardDTOModel,
      ),
      if (userAchievementDTOModel?.showPointSection ?? false) PointTabScreen(pointsData: userAchievementDTOModel!.UserPoints),
      if (userAchievementDTOModel?.showPointSection ?? false) BadgesTabScreen(badgesData: userAchievementDTOModel!.UserBadges),
      if (userAchievementDTOModel?.showPointSection ?? false) LevelTabScreen(levelData: userAchievementDTOModel!.UserLevel),
    ];

    tabController = TabController(vsync: this, length: tabScreensList.length);

    mySetState();
  }

  @override
  void initState() {
    super.initState();
    initialize(provider: widget.arguments.gamificationProvider, isNotify: true);
  }

  @override
  void didUpdateWidget(covariant MyAchievementComponentWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.arguments != widget.arguments) {
      initialize(provider: widget.arguments.gamificationProvider, isNotify: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GamificationProvider>.value(value: gamificationProvider),
      ],
      child: Consumer<GamificationProvider>(
        builder: (BuildContext context, GamificationProvider gamificationProvider, Widget? child) {
          if (gamificationProvider.isUserGamesListLoading.get()) {
            return const SizedBox(
              height: 200,
              child: CommonLoader(
                isCenter: true,
              ),
            );
          } else if (gamificationProvider.userGamesList.length == 0) {
            return SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  "No Games",
                  style: themeData.textTheme.bodyMedium,
                ),
              ),
            );
          }

          return Column(
            children: [
              const SizedBox(height: 10),
              getGamesDropdownWidget(),
              Expanded(
                child: getMainBody(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget getGamesDropdownWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.grey),
            ),
            child: DropdownButton<GamesDTOModel>(
              value: gamificationProvider.selectedGameModel.get(),
              onChanged: (GamesDTOModel? newValue) {
                if (gamificationProvider.isUserAchievementDataLoading.get()) {
                  return;
                }
                getUserAchievementsDataForGame(
                  gamesDTOModel: newValue,
                  isRefresh: true,
                );
              },
              isDense: true,
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              enableFeedback: true,
              underline: const SizedBox(),
              items: gamificationProvider.userGamesList.getList(isNewInstance: false).map<DropdownMenuItem<GamesDTOModel>>((GamesDTOModel value) {
                return DropdownMenuItem<GamesDTOModel>(
                  value: value,
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      value.GameName,
                      style: themeData.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget getMainBody() {
    if (gamificationProvider.isUserAchievementDataLoading.get()) {
      return const SizedBox(
        height: 200,
        child: CommonLoader(
          isCenter: true,
        ),
      );
    }

    UserAchievementDTOModel? userAchievementDTOModel = gamificationProvider.userAchievementData.get();
    UserOverAllDataModel? userOverAllDataModel = userAchievementDTOModel?.UserOverAllData;

    return Column(
      children: [
        if (userOverAllDataModel != null) ...[
          UserOverallDataWidget(userOverAllDataModel: userOverAllDataModel),
          const SizedBox(height: 10),
        ],
        Divider(
          height: .5,
          color: Colors.grey.withOpacity(.5),
        ),
        Expanded(
          child: getTabBarWidget(userAchievementDTOModel: userAchievementDTOModel),
        ),
      ],
    );
  }

  Widget getTabBarWidget({required UserAchievementDTOModel? userAchievementDTOModel}) {
    if (userAchievementDTOModel == null) return const SizedBox();

    userAchievementDTOModel.UserPoints;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.5), width: 0.2)),
      ),
      child: DefaultTabController(
        length: tabsList.length,
        child: Scaffold(
          appBar: tabsList.length <= 1
              ? null
              : AppBar(
                  bottom: PreferredSize(
                    preferredSize: const Size(double.infinity, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TabBar(
                          controller: tabController,
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelPadding: const EdgeInsets.only(bottom: 2, left: 8, right: 8),
                          indicatorPadding: const EdgeInsets.only(top: 46),
                          indicator: BoxDecoration(color: themeData.primaryColor, borderRadius: const BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
                          labelStyle: themeData.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                          tabs: tabsList,
                        ),
                      ],
                    ),
                  ),
                ),
          body: Container(
            color: Colors.white,
            child: TabBarView(
              controller: tabController,
              children: tabScreensList,
            ),
          ),
        ),
      ),
    );
  }
}
