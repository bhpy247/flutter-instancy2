import 'package:flutter_instancy_2/backend/gamification/gamification_controller.dart';
import 'package:flutter_instancy_2/backend/gamification/gamification_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/backend/share/share_repository.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/gamification/request_model/update_content_gamification_request_model.dart';
import 'package:flutter_instancy_2/models/gamification/response_model/content_game_activity_response_model.dart';
import 'package:flutter_instancy_2/models/share/data_model/share_connection_user_model.dart';
import 'package:flutter_instancy_2/models/share/request_model/share_with_people_request_model.dart';
import 'package:flutter_instancy_2/models/share/response_model/share_connection_list_response_model.dart';
import 'package:provider/provider.dart';

import '../../api/api_controller.dart';
import '../../models/common/data_response_model.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';
import 'share_provider.dart';

class ShareController {
  late ShareProvider _shareProvider;
  late ShareRepository _shareRepository;

  ShareController({required ShareProvider? shareProvider, ShareRepository? repository, ApiController? apiController}) {
    _shareProvider = shareProvider ?? ShareProvider();
    _shareRepository = repository ?? ShareRepository(apiController: apiController ?? ApiController());
  }

  ShareProvider get shareProvider => _shareProvider;

  ShareRepository get shareRepository => _shareRepository;

  Future<bool> shareWithPeople({
    required List<String> userMails,
    required String subject,
    required String message,
    String contentId = "",
    String forumId = "",
    String questionId = "",
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("ShareController().shareWithPeople() called with contentId:'$contentId'", tag: tag);

    DataResponseModel<ContentGameActivityResponseModel> response = await shareRepository.shareWithPeople(
      peopleRequestModel: ShareWithPeopleRequestModel(
        userMails: userMails,
        subject: subject,
        message: message,
        contentId: contentId,
        forumID: forumId,
        discussionForumLink: forumId.isNotEmpty,
        quesID: questionId,
        askQuestionLink: questionId.isNotEmpty,
        isSuggestToConnections: false,
      ),
    );
    MyPrint.printOnConsole("ShareWithPeople Response Data:$response", tag: tag);

    return response.statusCode == 200;
  }

  Future<bool> shareWithConnections({
    required List<int> userIDList,
    required String subject,
    required String message,
    String contentId = "",
    String forumId = "",
    String questionId = "",
    int scoId = 0,
    int objecttypeId = 0,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("ShareController().shareWithConnections() called with contentId:'$contentId'", tag: tag);

    DataResponseModel<ContentGameActivityResponseModel> response = await shareRepository.shareWithPeople(
      peopleRequestModel: ShareWithPeopleRequestModel(
        userIDList: userIDList,
        subject: subject,
        message: message,
        contentId: contentId,
        forumID: forumId,
        discussionForumLink: forumId.isNotEmpty,
        quesID: questionId,
        askQuestionLink: questionId.isNotEmpty,
        isSuggestToConnections: true,
      ),
    );
    MyPrint.printOnConsole("ShareWithConnections Response Data:${response.data}", tag: tag);

    bool isSuccess = response.statusCode == 200;

    if (isSuccess) {
      GamificationController(provider: NavigationController.mainNavigatorKey.currentContext?.read<GamificationProvider>()).UpdateContentGamification(
        requestModel: UpdateContentGamificationRequestModel(
          contentId: contentId,
          scoId: scoId,
          objecttypeId: objecttypeId,
          GameAction: GamificationActionType.ShareContentWithConnection,
        ),
      );
    }

    return isSuccess;
  }

  Future<List<ShareConnectionUserModel>> getConnectionsList({
    bool isRefresh = true,
    bool isGetFromCache = false,
    bool isNotify = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("ShareController().getConnectionsList() called with isRefresh:'$isRefresh', isGetFromCache:$isGetFromCache", tag: tag);

    ShareProvider provider = shareProvider;

    List<ShareConnectionUserModel> connections = [];

    MyPrint.printOnConsole("provider.connectionsLength:${provider.mainConnectionsLength}", tag: tag);

    if (isRefresh || (isGetFromCache && provider.mainConnectionsLength == 0)) {
      provider.isConnectionsLoading.set(value: true, isNotify: isNotify);

      DataResponseModel<ShareConnectionListResponseModel> response = await shareRepository.getConnectionsListForShare();
      MyPrint.printOnConsole("getConnectionsListForShare response:$response", tag: tag);

      List<ShareConnectionUserModel> allConnections = response.data?.connectionsList ?? <ShareConnectionUserModel>[];
      provider.mainConnectionsList.setList(list: allConnections, isClear: true, isNotify: false);
      initializeSearchedConnectionsFromString();

      provider.isConnectionsLoading.set(value: false, isNotify: true);
    }

    connections = provider.searchedConnectionsList.getList();

    MyPrint.printOnConsole("Final Connections Length:${provider.mainConnectionsLength}", tag: tag);

    return connections;
  }

  Future<List<ShareConnectionUserModel>> getRecommendToUserList({bool isRefresh = true, bool isGetFromCache = false, bool isNotify = true, String contentId = ""}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("ShareController().getConnectionsList() called with isRefresh:'$isRefresh', isGetFromCache:$isGetFromCache", tag: tag);

    ShareProvider provider = shareProvider;

    List<ShareConnectionUserModel> connections = [];

    MyPrint.printOnConsole("provider.connectionsLength:${provider.recommendedUserList}", tag: tag);

    if (isRefresh || (isGetFromCache && provider.recommendedUserListLength == 0)) {
      provider.isRecommendConnectionsLoading.set(value: true, isNotify: isNotify);

      DataResponseModel<ShareConnectionListResponseModel> response = await shareRepository.getRecommendToUserList(contentId: contentId);
      MyPrint.printOnConsole("getConnectionsListForShare response:$response", tag: tag);

      List<ShareConnectionUserModel> allConnections = response.data?.connectionsList ?? <ShareConnectionUserModel>[];
      provider.recommendedUserList.setList(list: allConnections, isClear: true, isNotify: false);
      initializeRecommendSearchedUserFromString();

      provider.isRecommendConnectionsLoading.set(value: false, isNotify: true);
    }

    connections = provider.recommendedSearchedUserList.getList();

    MyPrint.printOnConsole("Final Connections Length:${provider.recommendedUserList}", tag: tag);

    return connections;
  }

  void initializeSearchedConnectionsFromString({bool isNotify = true}) {
    ShareProvider provider = shareProvider;

    if (provider.searchString.get().isNotEmpty) {
      provider.searchedConnectionsList.setList(
        list: provider.mainConnectionsList.getList(isNewInstance: false).where((ShareConnectionUserModel userModel) {
          return userModel.userName.toLowerCase().contains(provider.searchString.get().toLowerCase());
        }).toList(),
        isNotify: isNotify,
      );
    } else {
      provider.searchedConnectionsList.setList(
        list: provider.mainConnectionsList.getList(isNewInstance: false),
        isNotify: isNotify,
      );
    }
  }

  void initializeRecommendSearchedUserFromString({bool isNotify = true}) {
    ShareProvider provider = shareProvider;

    if (provider.recommendSearchString.get().isNotEmpty) {
      provider.recommendedSearchedUserList.setList(
        list: provider.recommendedUserList.getList(isNewInstance: false).where((ShareConnectionUserModel userModel) {
          return userModel.userName.toLowerCase().contains(provider.recommendSearchString.get().toLowerCase());
        }).toList(),
        isNotify: isNotify,
      );
    } else {
      provider.recommendedSearchedUserList.setList(
        list: provider.recommendedUserList.getList(isNewInstance: false),
        isNotify: isNotify,
      );
    }
  }

  Future<bool> insertRecommendedContent({
    int componentId = 0,
    String contentId = "",
    String addtoMyLearning = "",
    String recommendedTo = "",
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("ShareController().insertRecommendedContent() called with contentId:'$contentId'", tag: tag);
    // ShareProvider provider = shareProvider;
    DataResponseModel response = await shareRepository.insertRecommendedContent(contentId: contentId, componentId: componentId, addToMyLearning: addtoMyLearning, recommendedTo: recommendedTo);
    MyPrint.printOnConsole("ShareWithConnections Response Data:${response.data}", tag: tag);

    return response.statusCode == 200;
  }

  Future<bool> insertRecommendedContentNotification({
    int componentId = 0,
    String contentId = "",
    String addtoMyLearning = "",
    String recommendedTo = "",
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("ShareController().insertRecommendedContentNotification() called with contentId:'$contentId'", tag: tag);

    DataResponseModel response = await shareRepository.insertRecommendedContentNotification(
      contentId: contentId,
      componentId: componentId,
      addToMyLearning: addtoMyLearning,
      recommendedTo: recommendedTo,
    );
    MyPrint.printOnConsole("ShareWithConnections Response Data:${response.data}", tag: tag);

    return response.statusCode == 200;
  }

  Future<bool> sendMailToRecommendedUsers({
    required String contentId,
    String selectedUser = "",
    int componentId = 0,
    String contentName = "",
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("ShareController().sendMailToRecommendedUsers() called with contentId:'$contentId'", tag: tag);

    DataResponseModel response = await shareRepository.sendRecommendedUserMail(contentId: contentId, selectedUser: selectedUser, componentId: componentId, contentName: contentName);
    MyPrint.printOnConsole("ShareWithConnections Response Data:${response.data}", tag: tag);

    return response.statusCode == 200;
  }
}
