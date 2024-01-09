import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as flutter_inappwebview;
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/views/common/components/common_cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';

import '../../../backend/app_theme/style.dart';
import '../../../configs/app_constants.dart';
import '../../../models/message/data_model/chat_message_model.dart';
import '../../../utils/my_print.dart';
import 'audio_player_widget.dart';

class MessageItemWidget extends StatefulWidget {
  final ChatMessageModel message;
  final int currentUserId;

  const MessageItemWidget({
    Key? key,
    required this.message,
    required this.currentUserId,
  }) : super(key: key);

  @override
  State<MessageItemWidget> createState() => _MessageItemWidgetState();
}

class _MessageItemWidgetState extends State<MessageItemWidget> {
  late ThemeData themeData;

  late ChatMessageModel message;

  @override
  void initState() {
    super.initState();
    MyPrint.printOnConsole("MessageItemWidget init called");
    message = widget.message;
  }

  @override
  void didUpdateWidget(covariant MessageItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    message = widget.message;
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    if (message.Message.checkEmpty) return SizedBox();
    // deviceData = MediaQuery.of(context).size;
    MyPrint.printOnConsole("fromUserId:${message.FromUserID}, toUser.userID:${message.ToUserID}");
    bool isMessageReceived = message.ToUserID == widget.currentUserId;

    Color messageColor = Styles.chatTextBackgroundColor;
    if (!isMessageReceived) {
      // messageColor = Color(int.parse("0xFF${appBloc.uiSettingModel.appButtonBgColor.substring(1, 7).toUpperCase()}")).withOpacity(0.35);
      messageColor = themeData.primaryColor;
    }

    // double radius = 0.045;
    return Container(
      margin: const EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: 10,
        right: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isMessageReceived ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: <Widget>[
          isMessageReceived ? const SizedBox(width: 10) : const SizedBox.shrink(),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              decoration: BoxDecoration(
                color: messageColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(isMessageReceived ? 16 : 8),
                  bottomRight: Radius.circular(isMessageReceived ? 8 : 16),
                  // topRight: Radius.circular(isMessageReceived ? 10 : 0,),
                  // topLeft: Radius.circular(isMessageReceived ? 0 : 10,),
                  topRight: Radius.circular(isMessageReceived ? 8 : 0),
                  topLeft: Radius.circular(isMessageReceived ? 0 : 8),
                ),
                // border: isMessageReceived ? Border.all(color: Colors.grey.shade300, width: 1.5) : null,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: isMessageReceived ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                children: [
                  // Text(
                  //   text,
                  //   style: TextStyle(
                  //     fontSize: deviceData.height * 0.018,
                  //     color: fromUserId == toUser.userID
                  //         ? Color(int.parse(
                  //             "0xFF${appBloc.uiSettingModel.appTextColor.substring(1, 7).toUpperCase()}"))
                  //         : Color(int.parse(
                  //             "0xFF${appBloc.uiSettingModel.appBGColor.substring(1, 7).toUpperCase()}")),
                  //   ),
                  // ),
                  messageWidget(message.msgType, isMessageReceived),
                  const SizedBox(height: 4),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (message.SendDatetime != null)
                          Text(
                            DateFormat.jm().format(message.SendDatetime!),
                            style: TextStyle(fontSize: 10, color: isMessageReceived ? Styles.lightTextColor2 : Colors.white),
                          ),
                        if (!isMessageReceived)
                          const Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Icon(
                              Icons.check,
                              size: 15,
                              color: Colors.white,
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Visibility(
          //   visible: !isMessageReceived,
          //   child: Padding(
          //     padding: const EdgeInsets.only(left: 10),
          //     child: getUserProfile(radius),
          //   ),
          // )
        ],
      ),
    );
  }

  // Widget getUserProfile(){
  Widget messageWidget(String type, bool isMessageReceived) {
    MyPrint.printOnConsole("type:'$type'");
    MyPrint.printOnConsole("text:'${message.Message}'");
    MyPrint.printOnConsole("fileUrl:'${message.fileUrl}'");

    switch (type) {
      case MessageType.Text:
        return Container(
          margin: const EdgeInsets.only(top: 5.0),
          child: Text(
            message.Message,
            style: TextStyle(
              color: isMessageReceived ? null : themeData.colorScheme.onPrimary,
              fontSize: isMessageReceived ? 15 : 15,
            ),
          ),
        );
      case MessageType.Image:
        return InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => FileViewer(fileUrl: message.fileUrl)));
          },
          child: Container(
            width: 250,
            padding: const EdgeInsets.only(bottom: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CommonCachedNetworkImage(
                imageUrl: message.fileUrl,
                // fit: BoxFit.cover,
              ),
            ),
          ),
        );
      case MessageType.Doc:
        return SizedBox(
          //margin: const EdgeInsets.only(top: 5.0),
          child: getDocumentWidget(message: message, isMessageReceived: isMessageReceived),
        );
      case MessageType.Video:
        return SizedBox(
            //margin: const EdgeInsets.only(top: 5.0),
            child: getVideoWidget(message: message, isMessageReceived: isMessageReceived));
      case MessageType.Audio:
        return SizedBox(
            //margin: const EdgeInsets.only(top: 5.0),
            child: getAudioWidget(message: message, isMessageReceived: isMessageReceived));
    }

    return const SizedBox();
  }

  final _player = AudioPlayer();

  Future<void> audioInit(String url) async {
    try {
      // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
      await _player.setAudioSource(AudioSource.uri(Uri.parse(url)));
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  Widget getDocumentWidget({required ChatMessageModel message, required bool isMessageReceived}) {
    return InkWell(
      onTap: () {
        NavigationController.navigateToPDFLaunchScreen(
          navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
          arguments: PDFLaunchScreenNavigationArguments(
            pdfUrl: message.fileUrl,
            isNetworkPDF: true,
          ),
        );
      },
      child: SizedBox(
        // width: 150,
        height: 40,
        //padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Row(
          children: [
            Center(
              child: Icon(
                FontAwesomeIcons.solidFileLines,
                color: isMessageReceived ? null : themeData.colorScheme.onPrimary,
                size: 20,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                message.fileUrl.split("Message/").lastOrNull ?? "pdf",
                style: TextStyle(color: isMessageReceived ? Colors.black : Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getStringFormSecond(int seconds) {
    String displayString = "";
    Duration duration = Duration(seconds: seconds);
    if (seconds > 60) {
      int min = duration.inMinutes - (duration.inHours * 60);
      int sec = duration.inSeconds - (duration.inMinutes * 60);
      displayString = "${min.toString().length > 1 ? "$min" : "0$min"} : ${sec.toString().length > 1 ? "$sec" : "0$sec"}";
    } else {
      displayString = "00 : ${seconds.toString().length > 1 ? "$seconds" : "0$seconds"}";
    }
    return displayString;
  }

  Widget getVideoWidget({required ChatMessageModel message, required bool isMessageReceived}) {
    if (message.thumbnailImage.isEmpty) return const SizedBox();
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => FileViewer(fileUrl: message.fileUrl)));
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Container(
                width: 250,
                // padding: const EdgeInsets.only(bottom: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: CommonCachedNetworkImage(
                    imageUrl: message.thumbnailImage,
                    fit: BoxFit.cover,
                    errorHeight: 100,
                  ),
                ),
              ),
              if (message.videoDuration != 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(FontAwesomeIcons.video, size: 15, color: Colors.white),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        getStringFormSecond(message.videoDuration),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                )
            ],
          ),
          Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.black38,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                FontAwesomeIcons.play,
                color: Colors.white,
                size: 20,
              ))
        ],
      ),
    );
  }

  Widget getAudioWidget({required ChatMessageModel message, required bool isMessageReceived}) {
    return AudioPlayerWidget(
      url: message.fileUrl,
      isMessageReceived: isMessageReceived,
    );
    // return InkWell(
    //   onTap: () {
    //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => FileViewer(fileUrl: message.fileUrl)));
    //   },
    //   child: SizedBox(
    //     width: 150,
    //     // height: 40,
    //     //padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
    //     // child: Center(
    //     //   child: Icon(
    //     //     Icons.my_library_music,
    //     //     color: isMessageReceived ? null : themeData.colorScheme.onPrimary,
    //     //   ),
    //     // ),
    //     child: Text(message.fileUrl),
    //   ),
    // );
  }
}

class FileViewer extends StatelessWidget {
  const FileViewer({
    Key? key,
    required this.fileUrl,
  }) : super(key: key);

  final String fileUrl;

  @override
  Widget build(BuildContext context) {
    MyPrint.printOnConsole("FileViewer build called with fileUrl:$fileUrl");

    String url = fileUrl;

    if (url.startsWith("www")) {
      url = 'https://$url';
    } else if (url.startsWith("http://")) {
      url = url.replaceFirst("http://", "https://");
    }

    return Scaffold(
      appBar: AppBar(
          //title: Text(Uri.parse(fileUrl).path),
          ),
      body: Column(
        children: [
          Expanded(
            child: flutter_inappwebview.InAppWebView(
              initialUrlRequest: flutter_inappwebview.URLRequest(url: flutter_inappwebview.WebUri(url)),
            ),
          ),
        ],
      ),
    );
  }
}
