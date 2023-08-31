import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/view/common/components/common_cached_network_image.dart';
import 'package:flutter_instancy_2/backend/message/message_controller.dart';
import 'package:flutter_instancy_2/backend/message/message_provider.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/configs/typedefs.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:provider/provider.dart';

import '../../../models/message/data_model/chat_message_model.dart';
import '../../../models/message/data_model/chat_user_model.dart';
import '../../../models/message/request_model/send_chat_message_request_model.dart';
import '../../../utils/my_print.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/common_loader.dart';
import '../components/attachment_icon.dart';
import '../components/message_input.dart';
import '../components/message_item.dart';
import '../components/send_icon.dart';

class UserMessageListScreen extends StatefulWidget {
  final ChatUserModel toUser;

  const UserMessageListScreen({super.key, required this.toUser});

  @override
  State<UserMessageListScreen> createState() => _UserMessageListScreenState();
}

class _UserMessageListScreenState extends State<UserMessageListScreen> with MySafeState {
  late TextEditingController _textController;
  late MessageController messageController;
  late MessageProvider messageProvider;

  List<ChatMessageModel> messages = [];
  ScrollController _scrollController = ScrollController();
  bool noMoreMessages = false;
  String chatRoom = '';
  int fromUserID = -1;
  int toUserId = -1;
  Stream<MyFirestoreQuerySnapshot> _usersStream = FirebaseFirestore.instance.collection(AppConstants.kAppFlavour).snapshots();

  bool isSendingMessage = false;

  late Size deviceData;

  _getFireStoreStreams() async {
    fromUserID = messageController.messageRepository.apiController.apiDataProvider.getCurrentUserId();
    toUserId = widget.toUser.UserID;

    if (fromUserID > toUserId) {
      chatRoom = '$toUserId-$fromUserID';
    } else {
      chatRoom = '$fromUserID-$toUserId';
    }

    _usersStream = FirebaseFirestore.instance.collection(AppConstants.kAppFlavour).doc('messages').collection(chatRoom).orderBy("SendDatetime", descending: true).snapshots();
    mySetState();

    MyPrint.printOnConsole('chatRoom $chatRoom');
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange && !noMoreMessages) {
      // messagesBloc.add(MoreMessagesFetched(
      //     _scrollController.position.pixels, messages.length));
    }
  }

  Future<bool> onAttachmentPicked({required String messageType, required Uint8List fileBytes, String? fileName}) async {
    MyPrint.printOnConsole('onAttachmentPicked called with messageType:$messageType');
    MyPrint.printOnConsole("Length: ${fileBytes.length}  fileBytes:$fileName");

    if (fileBytes.isEmpty || fileName.checkEmpty) {
      return false;
    }

    isSendingMessage = true;
    mySetState();

    String response = await messageController.sendMessage(
      context: context,
      requestModel: SendChatMessageRequestModel(
        FromUserID: 0,
        ToUserID: widget.toUser.UserID,
        chatRoomId: chatRoom,
        MessageType: messageType,
        SendDatetime: null,
        MarkAsRead: true,
        fileName: fileName,
        fileBytes: fileBytes,
      ),
    );
    MyPrint.printOnConsole("response:'$response'");

    isSendingMessage = false;
    mySetState();

    return true;
  }

  Future<bool> onSendMessageTapped({required String message}) async {
    MyPrint.printOnConsole('onSendMessageTapped called with message:$message');
    if (message.isEmpty) {
      return false;
    }

    isSendingMessage = true;
    mySetState();

    String response = await messageController.sendMessage(
      context: context,
      requestModel: SendChatMessageRequestModel(
        FromUserID: 0,
        ToUserID: widget.toUser.UserID,
        chatRoomId: chatRoom,
        Message: message,
        MessageType: MessageType.Text,
        SendDatetime: null,
        MarkAsRead: true,
      ),
    );
    MyPrint.printOnConsole("response:'$response'");

    isSendingMessage = false;
    mySetState();

    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    messageProvider = context.read<MessageProvider>();
    messageController = MessageController(provider: messageProvider);
    _textController = TextEditingController();
    _scrollController = ScrollController();
    _scrollController.addListener(() => _scrollListener());
    _getFireStoreStreams();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    deviceData = MediaQuery.of(context).size;
    return Scaffold(
      appBar: getAppBar(),
      body: AppUIComponents.getBackGroundBordersRounded(
        context: context,
        child: StreamBuilder<MyFirestoreQuerySnapshot>(
          stream: _usersStream,
          builder: (BuildContext context, AsyncSnapshot<MyFirestoreQuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              messages = snapshot.data?.docs.map((i) {
                ChatMessageModel chatMessageModel = ChatMessageModel.fromJson(i.data());
                return chatMessageModel;
              }).toList() ??
                  [];

              /*messages.sort((a, b) {
                if (a.SendDatetime != null && b.SendDatetime != null) {
                  return b.SendDatetime!.compareTo(a.SendDatetime!);
                } else {
                  return 0;
                }
              });*/

              //Code To Update Last Message in Chat
              /*if(messages.isNotEmpty && messages.first.date != null && widget.toUser.sendDateTime != null && !(widget.toUser.sendDateTime!.isAtSameMomentAs(messages.first.date!))) {
                          Message lastMessage = messages.first;
                          MyPrint.logOnConsole("Last message:${lastMessage.message}");
                          widget.toUser.latestMessage = lastMessage.message;
                        }*/

              //print(messages.map((e) => e.message));
              return Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Expanded(
                      child: getMessagesListVIew(
                        messages,
                      ),
                    ),
                    getMessageTextField(),
                  ],
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const CommonLoader();
            } else {
              return const Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.warning),
                  ),
                  Text('Error in loading data')
                ],
              );
            }
          },
        ),
      ),
    );
  }

  AppBar getAppBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      // leading: ,
      leadingWidth: 30,
      centerTitle: false,
      title: Row(
        children: [
          Visibility(
            visible: widget.toUser.ProfPic.isNotEmpty,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(150),
              child: CommonCachedNetworkImage(
                imageUrl: widget.toUser.ProfPic,
                height: 30,
                width: 30,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.toUser.FullName,
                style: themeData.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, letterSpacing: .3),
              ),
              if (widget.toUser.JobTitle.isNotEmpty)
                Text(
                  widget.toUser.JobTitle,
                  style: themeData.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic, fontSize: 13),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getMessagesListVIew(List<ChatMessageModel> messages) {
    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      padding: EdgeInsets.only(bottom: deviceData.height * 0.01),
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int index) {
        ChatMessageModel message = messages[index];
        MyPrint.printOnConsole("Messagessssss : ${message.ProfPic}");
        return MessageItemWidget(
          message: message,
          currentUserId: fromUserID,
        );
      },
    );
  }

  Widget getMessageTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          offset: const Offset(0, -1),
          color: Colors.grey.shade300,
          blurRadius: 4,
          spreadRadius: 0.5,
        ),
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: const Color(0xffF5F5F5), borderRadius: BorderRadius.circular(50)),
              child: Row(
                children: [
                  Expanded(
                    child: MessageInput(
                      controller: _textController,
                    ),
                  ),
                  AttachmentIcon(
                    isSendingMessage: isSendingMessage,
                    onAttachmentPicked: onAttachmentPicked,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          SendIcon(
            controller: _textController,
            isSendingMessage: isSendingMessage,
            onSendMessageTapped: onSendMessageTapped,
          ),
        ],
      ),
    );
  }
}
