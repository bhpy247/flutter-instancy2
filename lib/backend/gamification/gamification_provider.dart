import 'package:flutter_instancy_2/models/gamification/data_model/games_dto_model.dart';
import 'package:flutter_instancy_2/models/gamification/response_model/leader_board_dto_model.dart';
import 'package:flutter_instancy_2/models/gamification/response_model/user_achievement_dto_model.dart';

import '../common/common_provider.dart';

class GamificationProvider extends CommonProvider {
  GamificationProvider() {
    myAchievementComponentId = CommonProviderPrimitiveParameter<int>(
      value: -1,
      notify: notify,
    );
    myAchievementRepositoryId = CommonProviderPrimitiveParameter<int>(
      value: -1,
      notify: notify,
    );

    isUserGamesListLoading = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    userGamesList = CommonProviderListParameter<GamesDTOModel>(
      list: <GamesDTOModel>[],
      notify: notify,
    );

    selectedGameModel = CommonProviderPrimitiveParameter<GamesDTOModel?>(
      value: null,
      notify: notify,
    );

    isUserAchievementDataLoading = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    userAchievementData = CommonProviderPrimitiveParameter<UserAchievementDTOModel?>(
      value: null,
      notify: notify,
    );

    isLeaderBoardDataLoading = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    leaderBoardData = CommonProviderPrimitiveParameter<LeaderBoardDTOModel?>(
      value: null,
      notify: notify,
    );

    gameIdForDrawer = CommonProviderPrimitiveParameter<int?>(
      value: null,
      notify: notify,
    );
    isUserAchievementDataForDrawerLoading = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    userAchievementDataForDrawer = CommonProviderPrimitiveParameter<UserAchievementDTOModel?>(
      value: null,
      notify: notify,
    );
  }

  late CommonProviderPrimitiveParameter<int> myAchievementComponentId;
  late CommonProviderPrimitiveParameter<int> myAchievementRepositoryId;

  late CommonProviderPrimitiveParameter<bool> isUserGamesListLoading;
  late CommonProviderListParameter<GamesDTOModel> userGamesList;

  late CommonProviderPrimitiveParameter<GamesDTOModel?> selectedGameModel;

  late CommonProviderPrimitiveParameter<bool> isUserAchievementDataLoading;
  late CommonProviderPrimitiveParameter<UserAchievementDTOModel?> userAchievementData;

  late CommonProviderPrimitiveParameter<bool> isLeaderBoardDataLoading;
  late CommonProviderPrimitiveParameter<LeaderBoardDTOModel?> leaderBoardData;

  late CommonProviderPrimitiveParameter<int?> gameIdForDrawer;
  late CommonProviderPrimitiveParameter<bool> isUserAchievementDataForDrawerLoading;
  late CommonProviderPrimitiveParameter<UserAchievementDTOModel?> userAchievementDataForDrawer;

  void resetData({bool isNotify = false}) {
    myAchievementComponentId.set(value: -1, isNotify: false);
    myAchievementRepositoryId.set(value: -1, isNotify: false);

    isUserGamesListLoading.set(value: false, isNotify: false);
    userGamesList.setList(list: <GamesDTOModel>[], isNotify: false);

    selectedGameModel.set(value: null, isNotify: false);

    isUserAchievementDataLoading.set(value: false, isNotify: false);
    userAchievementData.set(value: null, isNotify: false);

    isLeaderBoardDataLoading.set(value: false, isNotify: false);
    leaderBoardData.set(value: null, isNotify: false);

    gameIdForDrawer.set(value: null, isNotify: false);
    isUserAchievementDataForDrawerLoading.set(value: false, isNotify: false);
    userAchievementDataForDrawer.set(value: null, isNotify: false);

    notify(isNotify: isNotify);
  }
}
