import 'package:flutter_instancy_2/api/api_call_model.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/api/api_endpoints.dart';
import 'package:flutter_instancy_2/api/api_url_configuration_provider.dart';
import 'package:flutter_instancy_2/api/rest_client.dart';
import 'package:flutter_instancy_2/models/common/model_data_parser.dart';
import 'package:flutter_instancy_2/models/gamification/request_model/update_content_gamification_request_model.dart';
import 'package:flutter_instancy_2/models/gamification/response_model/content_game_activity_response_model.dart';
import 'package:flutter_instancy_2/models/gamification/response_model/leader_board_dto_model.dart';
import 'package:flutter_instancy_2/models/gamification/response_model/user_achievement_dto_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';

import '../../models/common/data_response_model.dart';
import '../../models/gamification/data_model/games_dto_model.dart';
import '../../models/gamification/request_model/leaderboard_request_model.dart';
import '../../models/gamification/request_model/user_achievements_request_model.dart';

class GamificationRepository {
  final ApiController apiController;

  const GamificationRepository({required this.apiController});

  Future<DataResponseModel<List<GamesDTOModel>>> GetGameList({
    required LeaderboardRequestModel requestModel,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.UserID = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.SiteID = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.Locale = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      url: apiEndpoints.GetGameList(),
      restCallType: RestCallType.simplePostCall,
      requestBody: MyUtils.encodeJson(requestModel.toMap()),
      parsingType: ModelDataParsingType.GamesDTOModelList,
    );

    DataResponseModel<List<GamesDTOModel>> apiResponseModel = await apiController.callApi<List<GamesDTOModel>>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<UserAchievementDTOModel>> GetUserAchievementData({
    required UserAchievementsRequestModel requestModel,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.UserID = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.SiteID = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.Locale = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      url: apiEndpoints.GetUserAchievementData(),
      restCallType: RestCallType.simplePostCall,
      requestBody: MyUtils.encodeJson(requestModel.toMap()),
      parsingType: ModelDataParsingType.UserAchievementDTOModel,
    );

    DataResponseModel<UserAchievementDTOModel> apiResponseModel = await apiController.callApi<UserAchievementDTOModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<LeaderBoardDTOModel>> GetLeaderboardData({
    required LeaderboardRequestModel requestModel,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.UserID = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.SiteID = apiUrlConfigurationProvider.getCurrentSiteId();
    requestModel.Locale = apiUrlConfigurationProvider.getLocale();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      url: apiEndpoints.GetLeaderboardData(),
      restCallType: RestCallType.simplePostCall,
      requestBody: MyUtils.encodeJson(requestModel.toMap()),
      parsingType: ModelDataParsingType.LeaderBoardDTOModel,
    );

    DataResponseModel<LeaderBoardDTOModel> apiResponseModel = await apiController.callApi<LeaderBoardDTOModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }

  Future<DataResponseModel<ContentGameActivityResponseModel>> UpdateContentGamification({
    required UpdateContentGamificationRequestModel requestModel,
  }) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = apiController.apiDataProvider;

    requestModel.userId = apiUrlConfigurationProvider.getCurrentUserId();
    requestModel.siteId = apiUrlConfigurationProvider.getCurrentSiteId();

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      url: apiEndpoints.UpdateContentGamification(),
      restCallType: RestCallType.simpleGetCall,
      queryParameters: requestModel.toMap(),
      parsingType: ModelDataParsingType.ContentGameActivityResponseModel,
    );

    DataResponseModel<ContentGameActivityResponseModel> apiResponseModel = await apiController.callApi<ContentGameActivityResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }
}
