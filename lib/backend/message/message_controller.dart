import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/mmy_toast.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/backend/message/message_provider.dart';
import 'package:flutter_instancy_2/backend/message/message_repository.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/configs/typedefs.dart';
import 'package:flutter_instancy_2/models/common/Instancy_multipart_file_upload_model.dart';
import 'package:flutter_instancy_2/models/message/data_model/chat_message_model.dart';
import 'package:flutter_instancy_2/models/message/request_model/send_chat_message_request_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';

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

  Future<List<ChatUserModel>> getChatUsersList({
    bool isRefresh = true,
    bool isClear = true,
    bool isNotify = true,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MessageController().getChatUsersList() called with", tag: tag);

    MessageProvider provider = messageProvider;

    List<ChatUserModel> chatUsers = provider.allChatUsersList.getList();

    if (isRefresh || chatUsers.isEmpty) {
      if (isClear) {
        provider.allChatUsersList.setList(list: [], isNotify: false, isClear: true);
        provider.filteredChatUserList.setList(list: [], isNotify: false, isClear: true);
      }

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

      provider.allChatUsersList.setList(list: usersList, isClear: true, isNotify: false);

      String selectedFilerRole = messageProvider.selectedFilterRole.get();

      setSelectedFilterRole(selectedFilterRole: selectedFilerRole, isNotify: false);

      provider.isChatUsersLoading.set(value: false, isNotify: true);
    }

    return provider.filteredChatUserList.getList();
  }

  Future<DataResponseModel<String>> attachmentUpload({required Uint8List bytes, String? fileName}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MessageController().attachmentUpload() called", tag: tag);

    DataResponseModel<String> response = await messageRepository.uploadGenericFiles(
      instancyMultipartFileUploadModels: [
        InstancyMultipartFileUploadModel(
          fieldName: "File",
          fileName: fileName,
          bytes: bytes,
        ),
      ],
      filePath: AppConstants.fileServerLocation,
    );
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

  Future<String> sendMessage({required BuildContext context, required SendChatMessageRequestModel requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MessageController().sendMessage() called with requestModel:'$requestModel'", tag: tag);

    ApiUrlConfigurationProvider apiUrlConfigurationProvider = messageRepository.apiController.apiDataProvider;

    MyFirestoreCollectionReference chatroomCollection = FirebaseFirestore.instance.collection(AppConstants.kAppFlavour).doc('messages').collection(requestModel.chatRoomId);

    String fileUrl = "";
    if (requestModel.fileBytes.checkNotEmpty && requestModel.fileName.checkNotEmpty) {
      MyPrint.printOnConsole("Having a file to upload named:${requestModel.fileName}", tag: tag);

      DataResponseModel<String> uploadResponseModel = await attachmentUpload(bytes: requestModel.fileBytes!, fileName: requestModel.fileName);
      if (uploadResponseModel.appErrorModel != null) {
        AppErrorModel appErrorModel = uploadResponseModel.appErrorModel!;

        MyPrint.printOnConsole("Error in Uploading File:${appErrorModel.message}", tag: tag);
        MyPrint.printOnConsole("Exception:${appErrorModel.exception}", tag: tag);
        MyPrint.printOnConsole("StackTrace:${appErrorModel.stackTrace}", tag: tag);

        if (appErrorModel.message.isNotEmpty && context.mounted) {
          MyToast.showError(context: context, msg: appErrorModel.message);
        }

        MyPrint.printOnConsole("Returning from MessageController().sendMessage() Because couldn't upload attachment", tag: tag);
        return "";
      }

      fileUrl = "${messageRepository.apiController.apiDataProvider.getCurrentSiteLearnerUrl()}${AppConstants.fileServerLocation}${requestModel.fileName}";
      MyPrint.printOnConsole("fileUrl:$fileUrl", tag: tag);
    }

    requestModel.SendDatetime ??= DateTime.now();

    ChatMessageModel chatMessageModel = ChatMessageModel(
      Message: requestModel.Message,
      msgType: requestModel.MessageType,
      FromUserID: apiUrlConfigurationProvider.getCurrentUserId(),
      ToUserID: requestModel.ToUserID,
      SendDatetime: requestModel.SendDatetime,
      MarkAsRead: requestModel.MarkAsRead,
      fileUrl: fileUrl,
    );

    chatroomCollection.add(chatMessageModel.toJson(toJson: false)).then((MyFirestoreDocumentReference documentReference) {
      MyPrint.printOnConsole("documentReference.id:${documentReference.id}", tag: tag);
    }).catchError((e, s) {
      MyPrint.printOnConsole("Error in Updating Message in Chatroom Collection:$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    });

    //region Make Api Call
    DataResponseModel<String> response = await messageRepository.sendMessage(
      requestModel: requestModel,
      isStoreDataInHive: true,
      isFromOffline: false,
    );

    MyPrint.printOnConsole("response.data: ${response.data}", tag: tag);
    //endregion

    return "";
  }

  Future<String> setMarkAsReadTrue({required BuildContext context, required SendChatMessageRequestModel requestModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("MessageController().setMarkAsReadTrue() called with requestModel:'$requestModel'", tag: tag);

    requestModel.SendDatetime ??= DateTime.now();

    //region Make Api Call
    DataResponseModel<ChatUsersListResponseModel> response = await messageRepository.getUserChatHistory(
      requestModel: requestModel,
      isStoreDataInHive: true,
      isFromOffline: false,
    );

    MyPrint.printOnConsole("response.data: ${response.data}", tag: tag);
    //endregion

    return "";
  }

  void setSelectedFilterRole({required String selectedFilterRole, bool isNotify = true}) {
    messageProvider.selectedFilterRole.set(value: selectedFilterRole, isNotify: false);

    List<ChatUserModel> chatUserList = messageProvider.allChatUsersList.getList(isNewInstance: true);

    int currentSiteId = messageRepository.apiController.apiDataProvider.getCurrentSiteId();
    int currentUserId = messageRepository.apiController.apiDataProvider.getCurrentUserId();

    List<int> pickedUserIds = <int>[];

    chatUserList = chatUserList.where((ChatUserModel chatUser) {
      bool isValidSiteUser = chatUser.SiteID == currentSiteId;
      bool isValidUserStatus = chatUser.UserStatus == 1;
      bool isValidConnectionStatus = chatUser.Myconid == currentUserId;
      bool isValidRole = [MessageRoleTypes.admin, MessageRoleTypes.manager, MessageRoleTypes.groupAdmin].contains(chatUser.RoleID);
      bool isValidFilter = selectedFilterRole == MessageRoleFilterType.all ||
          switch (selectedFilterRole) {
            MessageRoleFilterType.admin => chatUser.RoleID == MessageRoleTypes.admin,
            MessageRoleFilterType.groupAdmin => chatUser.RoleID == MessageRoleTypes.groupAdmin,
            MessageRoleFilterType.manager => chatUser.RoleID == MessageRoleTypes.manager,
            MessageRoleFilterType.learner => chatUser.RoleID == MessageRoleTypes.learner,
            _ => false,
          };

      bool isAddingUser = isValidSiteUser && isValidUserStatus && (isValidConnectionStatus || isValidRole) && isValidFilter;

      if (isAddingUser) {
        if (pickedUserIds.contains(chatUser.UserID)) {
          isAddingUser = false;
        } else {
          pickedUserIds.add(chatUser.UserID);
        }
      }

      return isAddingUser;
    }).toList();

    chatUserList.sort((a, b) {
      return a.RankNo.compareTo(b.RankNo);
    });
    MyPrint.printOnConsole("filteredChatUserList length : ${messageProvider.filteredChatUserList.getList().length}");

    messageProvider.filteredChatUserList.setList(list: chatUserList, isClear: true, isNotify: isNotify);
  }

  void updateLastMessageInChat({required int fromUserId, required int toUserId, required String lastMessage}) {
    MyPrint.printOnConsole("updateLastMessageInChat called with fromUserId:$fromUserId, toUserId:$toUserId, lastMessage:'$lastMessage'");

    int currentSiteId = messageRepository.apiController.apiDataProvider.getCurrentSiteId();
    int currentUserId = messageRepository.apiController.apiDataProvider.getCurrentUserId();

    for (ChatUserModel model in messageProvider.allChatUsersList.getList(isNewInstance: false).where((ChatUserModel chatUser) {
      bool isValidSiteUser = chatUser.SiteID == currentSiteId;
      bool isValidUserStatus = chatUser.UserStatus == 1;
      bool isValidConnectionStatus = chatUser.Myconid == currentUserId;
      bool isValidRole = [MessageRoleTypes.admin, MessageRoleTypes.manager, MessageRoleTypes.groupAdmin].contains(chatUser.RoleID);

      return isValidSiteUser && isValidUserStatus && chatUser.UserID == toUserId && (isValidConnectionStatus || isValidRole);
    })) {
      model.LatestMessage = lastMessage;
      MyPrint.printOnConsole("Updated last message for model:$model");
    }

    List<ChatUserModel> filteredChatUserList = messageProvider.filteredChatUserList.getList(isNewInstance: true);
    ChatUserModel? model = filteredChatUserList.where((ChatUserModel chatUser) {
      return chatUser.UserID == toUserId;
    }).firstOrNull;
    bool isRemoved = filteredChatUserList.remove(model);
    if (isRemoved) filteredChatUserList.insert(0, model!);
    messageProvider.filteredChatUserList.setList(list: filteredChatUserList, isClear: true, isNotify: false);
  }
}
