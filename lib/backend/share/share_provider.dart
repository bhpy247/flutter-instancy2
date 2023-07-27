import 'package:flutter_instancy_2/backend/common/common_provider.dart';
import 'package:flutter_instancy_2/models/share/data_model/share_connection_user_model.dart';

class ShareProvider extends CommonProvider {
  ShareProvider() {
    mainConnectionsList = CommonProviderListParameter<ShareConnectionUserModel>(
      list: <ShareConnectionUserModel>[],
      notify: notify,
    );
    searchedConnectionsList = CommonProviderListParameter<ShareConnectionUserModel>(
      list: <ShareConnectionUserModel>[],
      notify: notify,
    );

    isConnectionsLoading = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    searchString = CommonProviderPrimitiveParameter<String>(
      value: "",
      notify: notify,
    );
    selectedConnectionsList = CommonProviderListParameter<int>(
      list: <int>[],
      notify: notify,
    );

    recommendedUserList = CommonProviderListParameter<ShareConnectionUserModel>(
      list: <ShareConnectionUserModel>[],
      notify: notify,
    );
    ;

    recommendedSearchedUserList = CommonProviderListParameter<ShareConnectionUserModel>(
      list: <ShareConnectionUserModel>[],
      notify: notify,
    );
    isRecommendConnectionsLoading = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    recommendSearchString = CommonProviderPrimitiveParameter<String>(
      value: "",
      notify: notify,
    );
    recommendSelectedUserList = CommonProviderListParameter<int>(
      list: <int>[],
      notify: notify,
    );
  }

  late final CommonProviderListParameter<ShareConnectionUserModel> mainConnectionsList;

  int get mainConnectionsLength => mainConnectionsList.getList(isNewInstance: false).length;

  late final CommonProviderListParameter<ShareConnectionUserModel> searchedConnectionsList;

  int get searchedConnectionsLength => searchedConnectionsList.getList(isNewInstance: false).length;

  late final CommonProviderPrimitiveParameter<bool> isConnectionsLoading;

  late final CommonProviderPrimitiveParameter<String> searchString;

  late final CommonProviderListParameter<int> selectedConnectionsList;

  int get selectedConnectionsLength => selectedConnectionsList.getList(isNewInstance: false).length;

  void addRemoveUserInSelectedUsersList({required int userId, bool isAdd = true}) {
    List<int> selectedUsersList = selectedConnectionsList.getList(isNewInstance: true);

    selectedUsersList.remove(userId);
    if (isAdd) {
      selectedUsersList.add(userId);
    }
    selectedConnectionsList.setList(list: selectedUsersList, isClear: true, isNotify: true);
  }

  late final CommonProviderListParameter<ShareConnectionUserModel> recommendedUserList;

  int get recommendedUserListLength => recommendedUserList.getList(isNewInstance: false).length;

  late final CommonProviderListParameter<ShareConnectionUserModel> recommendedSearchedUserList;
  int get recommendedSearchedUserListLength => recommendedSearchedUserList.getList(isNewInstance: false).length;

  late final CommonProviderPrimitiveParameter<bool> isRecommendConnectionsLoading;

  late final CommonProviderPrimitiveParameter<String> recommendSearchString;

  late final CommonProviderListParameter<int> recommendSelectedUserList;

  int get recommendSelectedUserListLength => recommendSelectedUserList.getList(isNewInstance: false).length;

  void addRemoveUserInRecommendSelectedUserList({required int userId, bool isAdd = true}) {
    List<int> selectedUsersList = recommendSelectedUserList.getList(isNewInstance: true);

    selectedUsersList.remove(userId);
    if (isAdd) {
      selectedUsersList.add(userId);
    }
    recommendSelectedUserList.setList(list: selectedUsersList, isClear: true, isNotify: true);
  }

  void resetData() {
    mainConnectionsList.setList(list: [], isClear: true, isNotify: false);
    recommendedUserList.setList(list: [], isClear: true, isNotify: false);
    searchedConnectionsList.setList(list: [], isClear: true, isNotify: false);
    recommendedSearchedUserList.setList(list: [], isClear: true, isNotify: false);
    isConnectionsLoading.set(value: false, isNotify: false);
    searchString.set(value: "", isNotify: false);
    isConnectionsLoading.set(value: false, isNotify: false);
    searchString.set(value: "", isNotify: false);
    selectedConnectionsList.setList(list: [], isClear: true, isNotify: true);
    recommendSelectedUserList.setList(list: [], isClear: true, isNotify: true);
  }
}
