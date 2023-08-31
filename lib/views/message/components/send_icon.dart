import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/view/common/components/common_loader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SendIcon extends StatelessWidget {
  final TextEditingController controller;
  final bool isSendingMessage;
  final void Function({required String message})? onSendMessageTapped;

  const SendIcon({
    Key? key,
    required this.controller,
    this.isSendingMessage = false,
    this.onSendMessageTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return InkResponse(
      onTap: () async {
        if (isSendingMessage) return;

        String message = controller.text.trim();
        controller.clear();

        if (onSendMessageTapped != null) onSendMessageTapped!(message: message);
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: themeData.primaryColor,
        ),
        padding: const EdgeInsets.all(10),
        child: isSendingMessage
            ? CommonLoader(
                size: 20,
                color: themeData.colorScheme.onPrimary,
              )
            : Icon(
                FontAwesomeIcons.solidPaperPlane,
                color: themeData.colorScheme.onPrimary,
                size: 20,
              ),
      ),
    );
  }
}
