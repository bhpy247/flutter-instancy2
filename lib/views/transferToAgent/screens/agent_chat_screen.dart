import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/view/common/components/bottom_sheet_dragger.dart';
import 'package:flutter_instancy_2/models/message/data_model/chat_message_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../configs/app_constants.dart';
import '../../../utils/my_print.dart';
import '../../common/components/common_cached_network_image.dart';
import '../../message/components/attachment_icon.dart';
import '../../message/components/message_item.dart';
import '../component/messageItemTransferAgent.dart';

class AgentChatScreen extends StatefulWidget {
  static const String routeName = "/AgentChatScreen";

  const AgentChatScreen({super.key});

  @override
  State<AgentChatScreen> createState() => _AgentChatScreenState();
}

class _AgentChatScreenState extends State<AgentChatScreen> {
  late ThemeData themeData;

  void showMoreModalBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BottomSheetDragger(color: Colors.grey),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Transfer To Bot"),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Scaffold(
      appBar: getAppBar(),
      body: getChatList(),
    );
  }

  PreferredSize? getAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.5), width: 0.2)),
          ),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.0),
                  child: Icon(Icons.arrow_back_outlined),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: const CommonCachedNetworkImage(
                  imageUrl: "https://picsum.photos/id/237/200/300",
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  "Manoj Kumar",
                  style: themeData.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, letterSpacing: .3),
                ),
              ),
              InkWell(
                onTap: () {
                  showMoreModalBottomSheet();
                },
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    FontAwesomeIcons.ellipsisVertical,
                    size: 20,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getChatList() {
    return ListView.builder(itemBuilder: (BuildContext context, int index) {
      return TansferToAgentMessageItemWidget(
        message: ChatMessageModel(Message: "Hi", SendDatetime: DateTime.now()),
        isMessageReceived: index % 2 == 0 ? true : false,
        currentUserId: 0,
      );
    });
  }

  Widget messageWidget(String type, bool isMessageReceived) {
    MyPrint.printOnConsole("type:'$type'");
    // MyPrint.printOnConsole("fileUrl:'${message.fileUrl}'");

    switch (type) {
      case MessageType.Text:
        return Container(
          margin: const EdgeInsets.only(top: 5.0),
          child: Text(
            "Hi",
            style: TextStyle(
              color: isMessageReceived ? null : themeData.colorScheme.onPrimary,
              fontSize: isMessageReceived ? 15 : 15,
            ),
          ),
        );
      // case MessageType.Image:
      //   return InkWell(
      //     onTap: () {
      //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => FileViewer(fileUrl: message.fileUrl)));
      //     },
      //     child: Container(
      //       width: 250,
      //       padding: const EdgeInsets.only(bottom: 8),
      //       child: ClipRRect(
      //         borderRadius: BorderRadius.circular(5),
      //         child: CommonCachedNetworkImage(
      //           imageUrl: message.fileUrl,
      //           // fit: BoxFit.cover,
      //         ),
      //       ),
      //     ),
      //   );
      // case MessageType.Doc:
      //   return SizedBox(
      //     //margin: const EdgeInsets.only(top: 5.0),
      //     child: getDocumentWidget(message: message, isMessageReceived: isMessageReceived),
      //   );
      // case MessageType.Video:
      //   return SizedBox(
      //     //margin: const EdgeInsets.only(top: 5.0),
      //       child: getVideoWidget(message: message, isMessageReceived: isMessageReceived));
      // case MessageType.Audio:
      //   return SizedBox(
      //     //margin: const EdgeInsets.only(top: 5.0),
      //       child: getAudioWidget(message: message, isMessageReceived: isMessageReceived));
    }

    return const SizedBox();
  }

// Widget getMessageTextField() {
//   // MyPrint.printOnConsole("_speechToText.isNotListening: ${_speechToText.isNotListening}");
//   return Container(
//     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//     decoration: BoxDecoration(color: Colors.white, boxShadow: [
//       BoxShadow(
//         offset: const Offset(0, -1),
//         color: Colors.grey.shade300,
//         blurRadius: 4,
//         spreadRadius: 0.5,
//       ),
//     ]),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         Expanded(
//           child: Container(
//             decoration: BoxDecoration(color: const Color(0xffF5F5F5), borderRadius: BorderRadius.circular(50)),
//             child: Row(
//               children: [
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(100),
//                   child: CommonCachedNetworkImage(
//                     imageUrl: userImageUrl,
//                     height: 30,
//                     width: 30,
//                     fit: BoxFit.cover,
//                     errorIconSize: 30,
//                   ),
//                 ),
//                 Expanded(
//                   child: MessageInput(
//                     controller: _textController,
//                     onChanged: (String s) {
//                       messageStatus[fromUserID.toString()] = MessageStatusTypes.typing;
//                       FirebaseFirestore.instance.collection(AppConstants.kAppFlavour).doc('messages').collection(chatRoom).doc("messageStatus").update(ParsingHelper.parseMapMethod(messageStatus));
//                     },
//                   ),
//                 ),
//                 AttachmentIcon(
//                   isSendingMessage: isSendingMessage,
//                   onAttachmentPicked: onAttachmentPicked,
//                 ),
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 if (_speechEnabled)
//                   _speechToText.isNotListening
//                       ? const SizedBox()
//                       : Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: SpinKitWave(color: themeData.primaryColor, size: 15, type: SpinKitWaveType.center),
//                   ),
//                 InkWell(
//                   onTap: isSendingMessage
//                       ? null
//                       : _speechToText.isNotListening
//                       ? _startListening
//                       : _stopListening,
//                   child: Icon(
//                     Icons.mic,
//                     color: Styles.lightTextColor2.withOpacity(0.5),
//                     size: 20,
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 15,
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(width: 8),
//         SendIcon(
//           controller: _textController,
//           isSendingMessage: isSendingMessage,
//           onSendMessageTapped: onSendMessageTapped,
//         ),
//       ],
//     ),
//   );
// }
}
