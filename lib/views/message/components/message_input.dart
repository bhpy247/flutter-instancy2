import 'package:flutter/material.dart';

import '../../../backend/app_theme/style.dart';

class MessageInput extends StatelessWidget {
  const MessageInput({
    Key? key,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  final TextEditingController controller;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final deviceData = MediaQuery.of(context).size;
    return Container(
      width: deviceData.width * 0.75,
      decoration: BoxDecoration(
          // borderRadius: BorderRadius.all(
          //   Radius.circular(deviceData.width * 0.05),
          // ),
          ),
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        controller: controller,
        keyboardType: TextInputType.multiline,
        maxLines: 5,
        minLines: 1,
        textInputAction: TextInputAction.newline,
        style: TextStyle(
          color: Colors.black,
          fontSize: deviceData.height * 0.018,
        ),
        onChanged: onChanged,
        decoration: InputDecoration(
          isDense: true,
          filled: false,
          fillColor: Styles.backgroundColor,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(deviceData.width * 0.05)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(deviceData.width * 0.05)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(
                Radius.circular(deviceData.width * 0.05)),
          ),
          hintText: "Write your message..",
          hintStyle: TextStyle(color: Colors.black45),
        ),
      ),
    );
  }
}
