import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/message/message_controller.dart';
import 'package:flutter_instancy_2/models/message/request_model/send_chat_message_request_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SendIcon extends StatelessWidget {
  final TextEditingController controller;
  final int toUserId;
  final String chatRoom;
  final MessageController messageController;

  const SendIcon({
    Key? key,
    required this.messageController,
    required this.controller,
    required this.toUserId,
    required this.chatRoom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return InkResponse(
      onTap: () async {
        String message = controller.text.trim();
        controller.clear();

        if (message.isNotEmpty) {
          await messageController.sendMessage(
            requestModel: SendChatMessageRequestModel(
              FromUserID: 0,
              ToUserID: toUserId,
              Message: message,
              chatRoomId: chatRoom,
              SendDatetime: null,
              MarkAsRead: true,
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: themeData.primaryColor,
        ),
        padding: const EdgeInsets.all(10),
        child: Icon(
          FontAwesomeIcons.solidPaperPlane,
          color: themeData.colorScheme.onPrimary,
          size: 20,
        ),
      ),
    );
  }
}
