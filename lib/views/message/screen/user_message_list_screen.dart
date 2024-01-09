import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/backend/message/message_controller.dart';
import 'package:flutter_instancy_2/backend/message/message_provider.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/configs/typedefs.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:video_player/video_player.dart';

import '../../../backend/app_theme/style.dart';
import '../../../backend/authentication/authentication_provider.dart';
import '../../../models/message/data_model/chat_message_model.dart';
import '../../../models/message/data_model/chat_user_model.dart';
import '../../../models/message/request_model/send_chat_message_request_model.dart';
import '../../../utils/my_print.dart';
import '../../../utils/parsing_helper.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/common_cached_network_image.dart';
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
  Map<String, dynamic> messageStatus = {};

  List<ChatMessageModel> messages = [];
  ScrollController _scrollController = ScrollController();
  bool noMoreMessages = false;
  String chatRoom = '';
  int fromUserID = -1;
  int toUserId = -1;
  Stream<MyFirestoreQuerySnapshot> _usersStream = FirebaseFirestore.instance.collection(AppConstants.kAppFlavour).snapshots();

  bool isSendingMessage = false;
  String userImageUrl = "";

  String lastMessage = "";

  late Size deviceData;

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

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

    MyPrint.printOnConsole("chatRoom idddD:  $chatRoom");
    messageStatus[fromUserID.toString()] = "";
    messageStatus["SendDatetime"] = Timestamp.now();
    try {
      FirebaseFirestore.instance.collection(AppConstants.kAppFlavour).doc('messages').collection(chatRoom).doc("messageStatus").update(ParsingHelper.parseMapMethod(messageStatus)).catchError((e) {
        FirebaseFirestore.instance.collection(AppConstants.kAppFlavour).doc('messages').collection(chatRoom).doc("messageStatus").set(ParsingHelper.parseMapMethod(messageStatus));
        MyPrint.printOnConsole('Error thrown in the message Feature. : $e');
        return e;
      });
    } catch (e) {
      MyPrint.printOnConsole("Error thrown in the message Feature. $e");
    }

    MyPrint.printOnConsole('chatRoom $chatRoom');

    messageController.setMarkAsReadTrue(
      context: context,
      requestModel: SendChatMessageRequestModel(
        FromUserID: fromUserID,
        ToUserID: toUserId,
        chatRoomId: chatRoom,
        MessageType: MessageType.Text,
        SendDatetime: DateTime.now(),
        MarkAsRead: true,
      ),
    );
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange && !noMoreMessages) {
      // messagesBloc.add(MoreMessagesFetched(
      //     _scrollController.position.pixels, messages.length));
    }
  }

  Future<bool> onAttachmentPicked({required String messageType, required Uint8List fileBytes, String? fileName, required String filePath}) async {
    MyPrint.printOnConsole('onAttachmentPicked called with messageType:$messageType');
    MyPrint.printOnConsole("Length: ${fileBytes.length}  fileBytes:$fileName");

    if (fileBytes.isEmpty || fileName.checkEmpty) {
      return false;
    }

    isSendingMessage = true;
    mySetState();
    int duration = 0;
    if (messageType == MessageType.Video) {
      VideoPlayerController controller;
      controller = VideoPlayerController.file(File(filePath));
      await controller.initialize();
      duration = controller.value.duration.inSeconds;
      MyPrint.printOnConsole("controller.value.duration : ${controller.value.duration.inSeconds}");
    }

    if (context.mounted) {
      String response = await messageController.sendMessage(
        context: context,
        requestModel: SendChatMessageRequestModel(
            FromUserID: fromUserID,
            ToUserID: widget.toUser.UserID,
            chatRoomId: chatRoom,
            MessageType: messageType,
            SendDatetime: null,
            MarkAsRead: false,
            fileName: fileName,
            fileBytes: fileBytes,
            videoFileDuration: duration
            // videoFileDuratin
            ),
      );
      MyPrint.printOnConsole("response:'$response'");

      isSendingMessage = false;
      mySetState();
    }
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
        FromUserID: fromUserID,
        ToUserID: widget.toUser.UserID,
        chatRoomId: chatRoom,
        Message: message,
        MessageType: MessageType.Text,
        SendDatetime: null,
        MarkAsRead: false,
      ),
    );
    MyPrint.printOnConsole("response:'$response'");

    isSendingMessage = false;
    mySetState();

    return true;
  }

  void getLoggedInUserData() {
    AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();

    String imageurl = authenticationProvider.getEmailLoginResponseModel()?.image ?? "";
    MyPrint.printOnConsole("imageurl:$imageurl");

    userImageUrl = imageurl;
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    mySetState();
  }

  Future<void> _startListening() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole('_onSpeechResult called', tag: tag);

    try {
      await _speechToText.listen(
        onResult: _onSpeechResult,
        onSoundLevelChange: (double level) {
          MyPrint.printOnConsole('onSoundLevelChange called with level:$level', tag: tag);
          // if(level == -2.0){
          //   _speechToText.stop();
          //   mySetState();
          // }
        },
        listenMode: ListenMode.search,
      );
    } catch (e, s) {
      MyPrint.printOnConsole("Error in UserMessageListScreen()._startListening();$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }
    MyPrint.printOnConsole("is _startListening called", tag: tag);
    mySetState();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole('_onSpeechResult called', tag: tag);

    _lastWords = result.recognizedWords;
    _textController.text = _lastWords;
    _textController.selection = TextSelection.fromPosition(TextPosition(offset: _textController.text.length));

    MyPrint.printOnConsole("result: ${result.recognizedWords}", tag: tag);
    mySetState();
  }

  void _stopListening() async {
    await _speechToText.stop();
    MyPrint.printOnConsole("is _stopListening called");
    mySetState();
  }

  @override
  void initState() {
    super.initState();
    _initSpeech();
    messageProvider = context.read<MessageProvider>();
    messageController = MessageController(provider: messageProvider);
    _textController = TextEditingController();
    _scrollController = ScrollController();
    _scrollController.addListener(() => _scrollListener());
    getLoggedInUserData();
    _getFireStoreStreams();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    // messageProvider.chatUsersList.setList(list: list)
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    deviceData = MediaQuery.of(context).size;
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) {
        MyPrint.printOnConsole("onPopInvoked called with didPop:$didPop");

        FirebaseFirestore.instance.collection(AppConstants.kAppFlavour).doc('messages').collection(chatRoom).doc("messageStatus").update({fromUserID.toString(): ""});
        if (widget.toUser.LatestMessage != lastMessage) {
          messageController.updateLastMessageInChat(fromUserId: fromUserID, toUserId: toUserId, lastMessage: lastMessage);
        }
      },
      child: StreamBuilder<MyFirestoreQuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<MyFirestoreQuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            messages = snapshot.data?.docs.map((i) {
                  MyPrint.printOnConsole("i.id ${i.id}");
                  if (i.id == MessageStatusDocument.docId) {
                    MyPrint.printOnConsole("i.id : ${i.data()}");
                    messageStatus = i.data();
                  }
                  ChatMessageModel chatMessageModel = ChatMessageModel.fromJson(i.data());
                  return chatMessageModel;
                }).toList() ??
                [];
            ChatMessageModel? lastMessageModel = messages.firstOrNull;
            lastMessage = lastMessageModel?.Message ?? "";

            MyPrint.printOnConsole("lastMessage: $chatRoom ${toUserId.toString()} ${messageStatus[toUserId.toString()]}");

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
            return Scaffold(
              appBar: getAppBar(messageStatus),
              body: AppUIComponents.getBackGroundBordersRounded(
                context: context,
                child: Container(
                  // color: Colors.transparent,
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
                ),
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
    );
  }

  AppBar getAppBar(Map<String, dynamic> messageStatus) {
    MyPrint.printOnConsole("messageStatus[toUserId] $messageStatus $toUserId ${messageStatus[toUserId.toString()]}");

    String imageUrl = AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(imagePath: widget.toUser.ProfPic);

    return AppBar(
      automaticallyImplyLeading: true,
      // leading: ,
      leadingWidth: 30,
      centerTitle: false,
      title: Row(
        children: [
          if (imageUrl.isNotEmpty)
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(150),
                  child: CommonCachedNetworkImage(
                    imageUrl: imageUrl,
                    height: 40,
                    width: 40,
                    errorIconSize: 30,
                  ),
                ),
                if (widget.toUser.ConnectionStatus == 1)
                  Container(
                    height: 10,
                    width: 10,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                  )
              ],
            ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.toUser.FullName,
                style: themeData.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: .3,
                  color: themeData.appBarTheme.titleTextStyle?.color,
                ),
              ),
              Row(
                children: [
                  if (messageStatus[toUserId.toString()] == MessageStatusTypes.typing)
                    Text(
                      MessageStatusTypes.typing,
                      style: themeData.textTheme.bodyMedium?.copyWith(
                        fontSize: 13,
                        color: themeData.appBarTheme.titleTextStyle?.color,
                      ),
                    ),
                  if (widget.toUser.JobTitle.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        widget.toUser.JobTitle,
                        style: themeData.textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          fontSize: 13,
                          color: themeData.appBarTheme.titleTextStyle?.color,
                        ),
                      ),
                    ),
                ],
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
    MyPrint.printOnConsole("_speechToText.isNotListening: ${_speechToText.isNotListening}");
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
                  const SizedBox(
                    width: 10,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CommonCachedNetworkImage(
                      imageUrl: userImageUrl,
                      height: 30,
                      width: 30,
                      fit: BoxFit.cover,
                      errorIconSize: 30,
                    ),
                  ),
                  Expanded(
                    child: MessageInput(
                      controller: _textController,
                      onChanged: (String s) {
                        messageStatus[fromUserID.toString()] = MessageStatusTypes.typing;
                        FirebaseFirestore.instance.collection(AppConstants.kAppFlavour).doc('messages').collection(chatRoom).doc("messageStatus").update(ParsingHelper.parseMapMethod(messageStatus));
                      },
                    ),
                  ),
                  AttachmentIcon(
                    isSendingMessage: isSendingMessage,
                    onAttachmentPicked: onAttachmentPicked,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  if (_speechEnabled)
                    _speechToText.isNotListening
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: SpinKitWave(color: themeData.primaryColor, size: 15, type: SpinKitWaveType.center),
                          ),
                  InkWell(
                    onTap: isSendingMessage
                        ? null
                        : _speechToText.isNotListening
                            ? _startListening
                            : _stopListening,
                    child: Icon(
                      Icons.mic,
                      color: Styles.lightTextColor2.withOpacity(0.5),
                      size: 20,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
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
