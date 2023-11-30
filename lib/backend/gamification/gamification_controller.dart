import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation_controller.dart';
import 'package:flutter_instancy_2/models/common/data_response_model.dart';
import 'package:flutter_instancy_2/models/gamification/data_model/games_dto_model.dart';
import 'package:flutter_instancy_2/models/gamification/request_model/leaderboard_request_model.dart';
import 'package:flutter_instancy_2/models/gamification/request_model/user_achievements_request_model.dart';
import 'package:flutter_instancy_2/models/gamification/response_model/leader_board_dto_model.dart';
import 'package:flutter_instancy_2/models/gamification/response_model/user_achievement_dto_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';

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

    UserAchievementsRequestModel requestModel = UserAchievementsRequestModel(
      ComponentID: provider.myAchievementComponentId.get(),
      ComponentInsID: provider.myAchievementRepositoryId.get(),
      GameID: provider.selectedGameModel.get()?.GameID ?? -1,
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
  Future<void> getUserAchievementDataForDrawer() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("GamificationController().getUserAchievementDataForDrawer() called", tag: tag);

    GamificationProvider provider = gamificationProvider;

    if (provider.userGamesList.length == 0) {
      await getUserGamesList(
        isRefresh: true,
        isNotify: false,
      );
    }

    GamesDTOModel? gameModel = provider.userGamesList.getList(isNewInstance: false).firstOrNull;

    if (gameModel == null) {
      provider.userAchievementDataForDrawer.set(value: null, isNotify: true);
      return;
    }

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

  Future<void> showGamificationEarnedPopup({required String notifyMessage}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("GamificationController().showGamificationEarnedPopup() called with notifyMessage:'$notifyMessage'", tag: tag);

    int indexOfSeparator = notifyMessage.indexOf("~~");
    MyPrint.printOnConsole("indexOfSeparator:$indexOfSeparator", tag: tag);

    if (indexOfSeparator > -1) notifyMessage = notifyMessage.substring(indexOfSeparator + 2);
    MyPrint.printOnConsole("notifyMessage:'$notifyMessage'", tag: tag);

    List<String> messages = notifyMessage.split("###");
    MyPrint.printOnConsole("messages:'$messages'", tag: tag);

    for (String message in messages) {
      BuildContext? context = NavigationController.mainNavigatorKey.currentContext;
      if (context != null && context.mounted) MyToast.showSuccess(context: context, msg: message);
      await Future.delayed(const Duration(seconds: 2));
    }
  }
}
