import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/models/common/data_response_model.dart';
import 'package:flutter_instancy_2/models/gamification/data_model/game_activity_badge_data_model.dart';
import 'package:flutter_instancy_2/models/gamification/data_model/game_activity_data_model.dart';
import 'package:flutter_instancy_2/models/gamification/data_model/game_activity_level_data_model.dart';
import 'package:flutter_instancy_2/models/gamification/data_model/game_activity_points_data_model.dart';
import 'package:flutter_instancy_2/models/gamification/data_model/games_dto_model.dart';
import 'package:flutter_instancy_2/models/gamification/request_model/leaderboard_request_model.dart';
import 'package:flutter_instancy_2/models/gamification/request_model/update_content_gamification_request_model.dart';
import 'package:flutter_instancy_2/models/gamification/request_model/user_achievements_request_model.dart';
import 'package:flutter_instancy_2/models/gamification/response_model/content_game_activity_response_model.dart';
import 'package:flutter_instancy_2/models/gamification/response_model/leader_board_dto_model.dart';
import 'package:flutter_instancy_2/models/gamification/response_model/user_achievement_dto_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';

import '../../views/my_achievements/components/badge_earned_dialog.dart';
import '../../views/my_achievements/components/level_up_dialog.dart';
import '../../views/my_achievements/components/point_earned_dialog.dart';
import 'gamification_provider.dart';
import 'gamification_repository.dart';

class GamificationController {
  late GamificationProvider _gamificationProvider;
  late GamificationRepository _gamificationRepository;

  GamificationController({required GamificationProvider? provider, GamificationRepository? repository, ApiController? apiController}) {
    _gamificationProvider = provider ?? GamificationProvider();
    _gamificationRepository = repository ?? GamificationRepository(apiController: apiController ?? ApiController());
  }

  GamificationProvider get gamificationProvider => _gamificationProvider;

  GamificationRepository get gamificationRepository => _gamificationRepository;

  //region MyAchievements Screen
  Future<List<GamesDTOModel>> getUserGamesList({
    bool isRefresh = true,
    bool isNotify = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("GamificationController().getUserGamesList() called with isRefresh:$isRefresh, isNotify:$isNotify", tag: tag);

    GamificationProvider provider = gamificationProvider;

    List<GamesDTOModel> userGamesList = provider.userGamesList.getList();

    MyPrint.printOnConsole("userGamesList length:${userGamesList.length}", tag: tag);

    if (!isRefresh && userGamesList.isNotEmpty) {
      MyPrint.printOnConsole("Returning from GamificationController().getUserGamesList() Having Prefetched Data", tag: tag);
      return userGamesList;
    }

    provider.isUserGamesListLoading.set(value: true, isNotify: isNotify);

    LeaderboardRequestModel requestModel = LeaderboardRequestModel(
      ComponentID: provider.myAchievementComponentId.get(),
      ComponentInsID: provider.myAchievementRepositoryId.get(),
    );

    //region Make Api Call
    DateTime startTime = DateTime.now();

    DataResponseModel<List<GamesDTOModel>> response = await gamificationRepository.GetGameList(requestModel: requestModel);
    MyPrint.printOnConsole("User Games List Length:${response.data?.length ?? 0}", tag: tag);

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole("User Games List Data got in ${endTime.difference(startTime).inMilliseconds} Milliseconds", tag: tag);
    //endregion

    userGamesList = response.data ?? <GamesDTOModel>[];
    MyPrint.printOnConsole("User Games List Length got in Api:${userGamesList.length}", tag: tag);

    //TODO: Remove this line when Implementing Other Achievements Section
    userGamesList.removeWhere((element) => element.GameID == -1);

    provider.userGamesList.setList(list: userGamesList, isClear: true, isNotify: false);
    provider.isUserGamesListLoading.set(value: false, isNotify: true);

    MyPrint.printOnConsole("Final User Games List Length:${userGamesList.length}", tag: tag);

    return userGamesList;
  }

  Future<UserAchievementDTOModel?> getUserAchievementsData({
    bool isRefresh = true,
    bool isNotify = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("GamificationController().getUserAchievementsData() called with isRefresh:$isRefresh, isNotify:$isNotify", tag: tag);

    GamificationProvider provider = gamificationProvider;
    UserAchievementDTOModel? userAchievementDTOModel = provider.userAchievementData.get();

    if (!isRefresh && userAchievementDTOModel != null) {
      MyPrint.printOnConsole("Returning from GamificationController().getUserAchievementsData() Having Prefetched Data", tag: tag);
      return userAchievementDTOModel;
    }

    provider.isUserAchievementDataLoading.set(value: true, isNotify: isNotify);

    int selectedGameId = provider.selectedGameModel.get()?.GameID ?? -1;

    UserAchievementsRequestModel requestModel = UserAchievementsRequestModel(
      ComponentID: provider.myAchievementComponentId.get(),
      ComponentInsID: provider.myAchievementRepositoryId.get(),
      GameID: selectedGameId,
    );

    //region Make Api Call
    DateTime startTime = DateTime.now();

    DataResponseModel<UserAchievementDTOModel> response = await gamificationRepository.GetUserAchievementData(requestModel: requestModel);
    MyPrint.printOnConsole("UserAchievementData:\n${response.data}", tag: tag);

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole("UserAchievementData got in ${endTime.difference(startTime).inMilliseconds} Milliseconds", tag: tag);
    //endregion

    userAchievementDTOModel = response.data;
    provider.userAchievementData.set(value: userAchievementDTOModel, isNotify: false);
    provider.isUserAchievementDataLoading.set(value: false, isNotify: true);

    if (selectedGameId == provider.selectedGameModel.get()?.GameID) {
      provider.userAchievementDataForDrawer.set(value: userAchievementDTOModel, isNotify: false);
      provider.isUserAchievementDataForDrawerLoading.set(value: false, isNotify: true);
    }

    return userAchievementDTOModel;
  }

  Future<LeaderBoardDTOModel?> getLeaderBoardData({
    bool isRefresh = true,
    bool isNotify = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("GamificationController().getLeaderBoardData() called with isRefresh:$isRefresh, isNotify:$isNotify", tag: tag);

    GamificationProvider provider = gamificationProvider;
    LeaderBoardDTOModel? leaderBoardDTOModel = provider.leaderBoardData.get();

    if (!isRefresh && (leaderBoardDTOModel?.LeaderBoardList).checkNotEmpty) {
      MyPrint.printOnConsole("Returning from GamificationController().getLeaderBoardData() Having Prefetched Data", tag: tag);
      return leaderBoardDTOModel;
    }

    provider.isLeaderBoardDataLoading.set(value: true, isNotify: isNotify);

    LeaderboardRequestModel requestModel = LeaderboardRequestModel(
      ComponentID: provider.myAchievementComponentId.get(),
      ComponentInsID: provider.myAchievementRepositoryId.get(),
      GameID: provider.selectedGameModel.get()?.GameID ?? -1,
    );

    //region Make Api Call
    DateTime startTime = DateTime.now();

    DataResponseModel<LeaderBoardDTOModel> response = await gamificationRepository.GetLeaderboardData(requestModel: requestModel);
    MyPrint.printOnConsole("LeaderboardData:\n${response.data}", tag: tag);

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole("LeaderboardData got in ${endTime.difference(startTime).inMilliseconds} Milliseconds", tag: tag);
    //endregion

    leaderBoardDTOModel = response.data;
    provider.leaderBoardData.set(value: leaderBoardDTOModel, isNotify: false);
    provider.isLeaderBoardDataLoading.set(value: false, isNotify: true);

    return leaderBoardDTOModel;
  }

  //endregion

  //region For Home Screen Drawer
  Future<void> getUserAchievementDataForDrawer({bool isNotify = false}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("GamificationController().getUserAchievementDataForDrawer() called", tag: tag);

    GamificationProvider provider = gamificationProvider;

    if (provider.userGamesList.length == 0) {
      await getUserGamesList(
        isRefresh: true,
        isNotify: isNotify,
      );
    }

    GamesDTOModel? gameModel = provider.userGamesList.getList(isNewInstance: false).firstOrNull;

    if (gameModel == null) {
      provider.userAchievementDataForDrawer.set(value: null, isNotify: true);
      return;
    }

    provider.gameIdForDrawer.set(value: gameModel.GameID, isNotify: false);
    await getUserAchievementsDataForDrawer(
      gameId: gameModel.GameID,
      isRefresh: true,
      isNotify: true,
    );
  }

  Future<UserAchievementDTOModel?> getUserAchievementsDataForDrawer({
    required int gameId,
    bool isRefresh = true,
    bool isNotify = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("GamificationController().getUserAchievementsDataForDrawer() called with gameId:$gameId, isRefresh:$isRefresh, isNotify:$isNotify", tag: tag);

    GamificationProvider provider = gamificationProvider;
    UserAchievementDTOModel? userAchievementDTOModel = provider.userAchievementDataForDrawer.get();

    if (!isRefresh && userAchievementDTOModel != null) {
      MyPrint.printOnConsole("Returning from GamificationController().getUserAchievementsDataForDrawer() Having Prefetched Data", tag: tag);
      return userAchievementDTOModel;
    }

    provider.isUserAchievementDataForDrawerLoading.set(value: true, isNotify: isNotify);

    UserAchievementsRequestModel requestModel = UserAchievementsRequestModel(
      ComponentID: provider.myAchievementComponentId.get(),
      ComponentInsID: provider.myAchievementRepositoryId.get(),
      GameID: gameId,
    );

    //region Make Api Call
    DateTime startTime = DateTime.now();

    DataResponseModel<UserAchievementDTOModel> response = await gamificationRepository.GetUserAchievementData(requestModel: requestModel);
    MyPrint.printOnConsole("UserAchievementData:\n${response.data}", tag: tag);

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole("UserAchievementData got in ${endTime.difference(startTime).inMilliseconds} Milliseconds", tag: tag);
    //endregion

    userAchievementDTOModel = response.data;
    provider.userAchievementDataForDrawer.set(value: userAchievementDTOModel, isNotify: false);
    provider.isUserAchievementDataForDrawerLoading.set(value: false, isNotify: true);

    return userAchievementDTOModel;
  }

//endregion

  Future<void> showGamificationEarnedPopup({required List<GameActivityDataModel> GameActivities}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("GamificationController().showGamificationEarnedPopup() called with GameActivities length:${GameActivities.length}", tag: tag);

    for (GameActivityDataModel activity in GameActivities) {
      for (GameActivityPointsDataModel pointModel in activity.pointsData) {
        await _showGamificationPopupOverlay(
          widget: PointEarnDialog(
            pointDataList: pointModel,
            gameName: activity.gameName,
          ),
        );
      }

      for (GameActivityBadgeDataModel badgeModel in activity.badgeData) {
        await _showGamificationPopupOverlay(
          widget: BadgeEarnDialog(
            badgeDataModel: badgeModel,
            gameName: activity.gameName,
          ),
        );
      }

      for (GameActivityLevelDataModel levelModel in activity.levelData) {
        await _showGamificationPopupOverlay(
          widget: LevelUpDialog(
            gameActivityLevelDataModel: levelModel,
            gameName: activity.gameName,
          ),
        );
      }
    }
  }

  Future<void> _showGamificationPopupOverlay({
    required Widget widget,
    Duration showTime = const Duration(seconds: 4),
  }) async {
    OverlayState? overlayState = NavigationController.mainNavigatorKey.currentState?.overlay;
    if (overlayState == null) {
      return;
    }

    OverlayEntry overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Dialog(
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            foregroundDecoration: const BoxDecoration(),
            child: widget,
          ),
        );
      },
    );
    overlayState.insert(overlayEntry);
    await Future.delayed(showTime);
    overlayEntry.remove();
    await Future.delayed(const Duration(milliseconds: 400));
  }

  Future<void> UpdateContentGamification({required UpdateContentGamificationRequestModel requestModel, bool isShowGamificationActivity = true, bool isCheckForGamificationUpdates = true}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("GamificationController().UpdateContentGamification() called with requestModel:$requestModel", tag: tag);

    DataResponseModel<ContentGameActivityResponseModel> responseModel = await gamificationRepository.UpdateContentGamification(requestModel: requestModel);
    MyPrint.printOnConsole("UpdateContentGamification:\n${responseModel.data}", tag: tag);

    if (responseModel.statusCode != 200 || responseModel.appErrorModel != null || responseModel.data == null) {
      MyPrint.printOnConsole("Returning from GamificationController().UpdateContentGamification() because couldn't get data", tag: tag);
      return;
    }

    ContentGameActivityResponseModel model = responseModel.data!;
    MyPrint.printOnConsole("Activities Length:${model.GameActivities.length}", tag: tag);

    if (isCheckForGamificationUpdates) {
      List<int> gameIds = model.GameActivities.map((e) => e.gameId).toList();
      checkGamificationUpdateForGameIds(gameIds: gameIds);
    }

    if (isShowGamificationActivity) await showGamificationEarnedPopup(GameActivities: model.GameActivities);
  }

  Future<void> checkGamificationUpdateForGameIds({required List<int> gameIds}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("GamificationController().checkGamificationUpdateForGameIds() called with gameIds:$gameIds", tag: tag);

    if (gameIds.isEmpty) {
      MyPrint.printOnConsole("Returning from GamificationController().checkGamificationUpdateForGameIds() because gameIds empty", tag: tag);
    }

    GamificationProvider provider = gamificationProvider;

    int? selectedGameIdForDrawer = provider.gameIdForDrawer.get();
    int? selectedGameIdForMyAchievements = provider.selectedGameModel.get()?.GameID;
    List<int> userGameIdsList = provider.userGamesList.getList(isNewInstance: false).map((e) => e.GameID).toList();

    if (gameIds.toSet().intersection(userGameIdsList.toSet()).length < gameIds.toSet().length) {
      MyPrint.printOnConsole("Game not Exist in User Games List", tag: tag);

      await getUserGamesList(
        isRefresh: true,
        isNotify: false,
      );
      getUserAchievementDataForDrawer();
    }

    if (selectedGameIdForDrawer != null && gameIds.contains(selectedGameIdForDrawer)) {
      MyPrint.printOnConsole("Updating Drawer Data", tag: tag);
      getUserAchievementsDataForDrawer(gameId: selectedGameIdForDrawer);
    }

    if (selectedGameIdForMyAchievements != null && gameIds.contains(selectedGameIdForMyAchievements)) {
      MyPrint.printOnConsole("Updating MyAchievements Data", tag: tag);
      getUserAchievementsData(
        isRefresh: true,
        isNotify: false,
      );
      getLeaderBoardData(
        isRefresh: true,
        isNotify: false,
      );
    }
  }
}
