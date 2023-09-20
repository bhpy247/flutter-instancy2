import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/message/data_model/chat_user_model.dart';

import '../common/common_provider.dart';

class MessageProvider extends CommonProvider {
  MessageProvider() {
    isChatUsersLoading = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    allChatUsersList = CommonProviderListParameter<ChatUserModel>(
      list: <ChatUserModel>[],
      notify: notify,
    );
    filteredChatUserList = CommonProviderListParameter<ChatUserModel>(
      list: <ChatUserModel>[],
      notify: notify,
    );
    selectedFilterRole = CommonProviderPrimitiveParameter<String>(
      value: RoleFilterType.all,
      notify: notify,
    );
    selectedMessageFilter = CommonProviderPrimitiveParameter<String>(
      value: MessageFilterType.all,
      notify: notify,
    );
  }

  late CommonProviderPrimitiveParameter<bool> isChatUsersLoading;
  late CommonProviderListParameter<ChatUserModel> allChatUsersList;
  late CommonProviderListParameter<ChatUserModel> filteredChatUserList;
  late CommonProviderPrimitiveParameter<String> selectedFilterRole;
  late CommonProviderPrimitiveParameter<String> selectedMessageFilter;

  int get chatUserListLength => allChatUsersList.getList(isNewInstance: false).length;

  void resetData() {
    isChatUsersLoading.set(value: false, isNotify: false);
    allChatUsersList.setList(list: [], isNotify: false);
    filteredChatUserList.setList(list: [], isNotify: false);
    selectedFilterRole.set(value: RoleFilterType.all, isNotify: false);
    selectedMessageFilter.set(value: RoleFilterType.all, isNotify: false);
  }
}
