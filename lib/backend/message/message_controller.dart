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
}
