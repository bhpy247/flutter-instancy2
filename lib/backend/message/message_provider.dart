import 'package:flutter_instancy_2/models/message/data_model/chat_user_model.dart';

import '../common/common_provider.dart';

class MessageProvider extends CommonProvider {
  MessageProvider() {
    isChatUsersLoading = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    chatUsersList = CommonProviderListParameter<ChatUserModel>(
      list: <ChatUserModel>[],
      notify: notify,
    );
  }

  late CommonProviderPrimitiveParameter<bool> isChatUsersLoading;
  late CommonProviderListParameter<ChatUserModel> chatUsersList;

  int get chatUserListLength => chatUsersList.getList(isNewInstance: false).length;

  void resetData() {
    isChatUsersLoading.set(value: false, isNotify: false);
    chatUsersList.setList(list: [], isNotify: false);
  }
}