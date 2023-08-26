import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/backend/message/message_provider.dart';
import 'package:flutter_instancy_2/backend/message/message_repository.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/configs/typedefs.dart';
import 'package:flutter_instancy_2/models/message/data_model/chat_message_model.dart';
import 'package:flutter_instancy_2/models/message/request_model/attachment_upload_request_model.dart';
import 'package:flutter_instancy_2/models/message/request_model/send_chat_message_request_model.dart';

import '../../api/api_url_configuration_provider.dart';
import '../../models/common/app_error_model.dart';
import '../../models/common/data_response_model.dart';
import '../../models/message/data_model/chat_user_model.dart';
import '../../models/message/response_model/chat_users_list_response_model.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';

class MessageController {
  late MessageProvider _messageProvider;
  late MessageRepository messageRepository;

  MessageController({required MessageProvider? provider, MessageRepository? repository, ApiController? apiController}) {
    _messageProvider = provider ?? MessageProvider();
    messageRepository = repository ?? MessageRepository(apiController: apiController ?? ApiController());
  }

  MessageProvider get messageProvider => _messageProvider;

  Future<List<ChatUserModel>> getChatUsersList({bool isRefresh = true, bool isNotify = true}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MessageController().getChatUsersList() called with", tag: tag);

    MessageProvider provider = messageProvider;

    List<ChatUserModel> chatUsers = provider.chatUsersList.getList();

    if (isRefresh || chatUsers.isEmpty) {
      provider.isChatUsersLoading.set(value: true, isNotify: isNotify);

      //region Make Api Call
      DateTime startTime = DateTime.now();

      DataResponseModel<ChatUsersListResponseModel> response = await messageRepository.getMessageUserList(
        isStoreDataInHive: true,
        isFromOffline: false,
      );
      MyPrint.printOnConsole("Message User List Length:${response.data?.Table.length ?? 0}", tag: tag);

      DateTime endTime = DateTime.now();
      MyPrint.printOnConsole("Message User List Data got in ${endTime.difference(startTime).inMilliseconds} Milliseconds", tag: tag);
      //endregion

      List<ChatUserModel> usersList = response.data?.Table ?? <ChatUserModel>[];
      MyPrint.printOnConsole("Message User List Length got in Api:${usersList.length}", tag: tag);

      int currentSiteId = messageRepository.apiController.apiDataProvider.getCurrentSiteId();
      int currentUserId = messageRepository.apiController.apiDataProvider.getCurrentUserId();

      List<int> pickedUserIds = <int>[];

      usersList = usersList.where((ChatUserModel chatUser) {
        bool isValidSiteUser = chatUser.SiteID == currentSiteId;
        bool isValidUserStatus = chatUser.UserStatus == 1;
        bool isValidConnectionStatus = chatUser.Myconid == currentUserId && chatUser.ConnectionStatus == 1;
        bool isValidRole = [8, 12, 16].contains(chatUser.RoleID);

        bool isAddingUser = isValidSiteUser && isValidUserStatus && (isValidConnectionStatus || isValidRole);

        if (isAddingUser) {
          if (pickedUserIds.contains(chatUser.UserID)) {
            isAddingUser = false;
          } else {
            pickedUserIds.add(chatUser.UserID);
          }
        }

        return isAddingUser;
      }).toList();

      usersList.sort((a, b) {
        return a.RankNo.compareTo(b.RankNo);
      });

      provider.chatUsersList.setList(list: usersList, isClear: true, isNotify: false);
      provider.isChatUsersLoading.set(value: false, isNotify: true);
    }

    return provider.chatUsersList.getList();
  }

  Future<DataResponseModel<String>> attachmentUpload({required AttachmentUploadRequestModel attachmentUploadRequestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MessageController().attachmentUpload() called", tag: tag);

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = messageRepository.apiController.apiDataProvider;
    attachmentUploadRequestModel.userID = apiUrlConfigurationProvider.getCurrentUserId();
    attachmentUploadRequestModel.siteID = apiUrlConfigurationProvider.getCurrentSiteId();
    attachmentUploadRequestModel.locale = apiUrlConfigurationProvider.getLocale();
    if ((attachmentUploadRequestModel.fileUploads ?? []).isNotEmpty) {
      attachmentUploadRequestModel.fileUploads!.forEach((element) async {
        String newFileUrl = '${apiUrlConfigurationProvider.getMainSiteUrl()}${AppConstants.fileServerLocation}${element.fileName}';

        MyFirestoreCollectionReference fireStore = FirebaseFirestore.instance.collection(AppConstants.kAppFlavour).doc('messages').collection(attachmentUploadRequestModel.chatRoom);

        await fireStore.add({
          'fromUserId': apiUrlConfigurationProvider.getCurrentUserId(),
          'toUserId': attachmentUploadRequestModel.toUserId,
          'date': DateTime.now().toIso8601String().toString(),
          'text': '',
          'fileUrl': newFileUrl,
          'msgType': attachmentUploadRequestModel.msgType.toString().split('.').last,
        });
      });
    }
    DataResponseModel<String> response = await messageRepository.uploadMessageFileData(attachmentUploadRequestModel: attachmentUploadRequestModel);
    MyPrint.printOnConsole("attachmentUpload Response:${response.data}", tag: tag);
    MyPrint.printOnConsole("attachmentUpload Response Type:${response.data?.runtimeType}", tag: tag);

    DataResponseModel<String> newResponse;

    String data = response.data ?? "";
    if (data.startsWith("failed") || data.startsWith("A file item already exists with this name.")) {
      // MyPrint.printOnConsole("")
      newResponse = DataResponseModel<String>(
        data: response.data,
        appErrorModel: AppErrorModel(
          message: response.data!,
        ),
      );
    } else {
      newResponse = response;
    }

    return newResponse;
  }

  Future<String> sendMessage({required SendChatMessageRequestModel requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MessageController().sendMessage() called with requestModel:'$requestModel'", tag: tag);

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = messageRepository.apiController.apiDataProvider;

    MyFirestoreCollectionReference chatroomCollection = FirebaseFirestore.instance.collection(AppConstants.kAppFlavour).doc('messages').collection(requestModel.chatRoomId);

    requestModel.SendDatetime ??= DateTime.now();

    ChatMessageModel chatMessageModel = ChatMessageModel(
      Message: requestModel.Message,
      msgType: MessageType.Text,
      FromUserID: apiUrlConfigurationProvider.getCurrentUserId(),
      ToUserID: requestModel.ToUserID,
      SendDatetime: requestModel.SendDatetime,
      MarkAsRead: requestModel.MarkAsRead,
    );

    chatroomCollection.add(chatMessageModel.toJson(toJson: false)).then((MyFirestoreDocumentReference documentReference) {
      MyPrint.printOnConsole("documentReference.id:${documentReference.id}");
    });

    //region Make Api Call
    DataResponseModel<String> response = await messageRepository.sendMessage(
      requestModel: requestModel,
      isStoreDataInHive: true,
      isFromOffline: false,
    );

    MyPrint.printOnConsole("response.data: ${response.data}");
    //endregion

    return "";
  }
}
