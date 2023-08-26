import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

// import '../../../backend/app_theme/style.dart';
import '../../../backend/app_theme/style.dart';
import '../../../configs/app_constants.dart';
import '../../../models/message/data_model/chat_user_model.dart';
import '../../../utils/my_print.dart';

class MessageItemModel extends StatefulWidget {
  final bool showFriendImage;
  final ChatUserModel toUser;
  final int fromUserId;
  final DateTime date;

  final String text;
  final String fileUrl;
  final String msgType;
  final BuildContext context;

  const MessageItemModel({
    Key? key,
    required this.showFriendImage,
    required this.toUser,
    required this.fromUserId,
    this.text = "",
    this.fileUrl = "",
    this.msgType = MessageType.Text,
    required this.context,
    required this.date,
  }) : super(key: key);

  @override
  State<MessageItemModel> createState() => _MessageItemModelState();
}

class _MessageItemModelState extends State<MessageItemModel> {
  late ThemeData themeData;

  // late Size deviceData;

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    // deviceData = MediaQuery.of(context).size;
    MyPrint.printOnConsole("fromUserId:${widget.fromUserId}, toUser.userID:${widget.toUser.UserID}");
    bool isMessageReceived = widget.fromUserId == widget.toUser.UserID;

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
                crossAxisAlignment: isMessageReceived ? CrossAxisAlignment.start : CrossAxisAlignment.start,
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
                  messageWidget(widget.msgType, isMessageReceived),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat.jm().format(widget.date),
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
    MyPrint.printOnConsole("widget.text:'${widget.text}'");

    switch (type) {
      case MessageType.Text:
        return Container(
          margin: const EdgeInsets.only(top: 5.0),
          child: Text(
            widget.text,
            style: TextStyle(color: isMessageReceived ? Colors.black : Colors.white, fontSize: isMessageReceived ? 15 : 15),
          ),
        );
      case MessageType.Image:
        return InkWell(
          onTap: () {
            Navigator.of(widget.context).push(MaterialPageRoute(builder: (context) => FileViewer(fileUrl: widget.fileUrl)));
          },
          child: Container(
            width: 150,
            height: 150,
            padding: const EdgeInsets.only(bottom: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                widget.fileUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      case MessageType.Doc:
        return InkWell(
          onTap: () async {
            Navigator.of(widget.context).push(MaterialPageRoute(builder: (context) => FileViewer(fileUrl: widget.fileUrl)));
            //PDFDocument doc = await PDFDocument.fromURL(fileUrl);

            // final result = await Navigator.push(
            //   context,
            //   // Create the SelectionScreen in the next step.
            //   MaterialPageRoute(
            //       builder: (context) => Scaffold(
            //             appBar: AppBar(
            //               title: Text('Example'),
            //             ),
            //             body: Center(child: PDFViewer(document: doc)),
            //           )),
            // );
            //PDFViewer(document: doc);
          },
          child: SizedBox(
            width: 150,
            height: 150,
            //padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: AbsorbPointer(child: InAppWebView(initialUrlRequest: URLRequest(url: WebUri(widget.fileUrl)))),
                ),
                const Center(
                  child: Icon(Icons.picture_as_pdf_sharp),
                )
              ],
            ),
          ),
        );
      case MessageType.Video:
        Uri? uri = Uri.tryParse(widget.fileUrl);

        if (uri == null) return const SizedBox();
        final videoPlayerController = VideoPlayerController.networkUrl(uri);

        videoPlayerController.initialize();

        return InkWell(
          onTap: () {
            Navigator.of(widget.context).push(MaterialPageRoute(builder: (context) => FileViewer(fileUrl: widget.fileUrl)));
          },
          child: SizedBox(
            width: 150,
            height: 150,
            //padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: VideoPlayer(videoPlayerController),
            ),
          ),
        );
      case MessageType.Audio:
        return SizedBox(
          //margin: const EdgeInsets.only(top: 5.0),
          child: InkWell(
            onTap: () {
              Navigator.of(widget.context).push(MaterialPageRoute(builder: (context) => FileViewer(fileUrl: widget.fileUrl)));
            },
            child: const SizedBox(
              width: 150,
              height: 40,
              //padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Center(
                child: Icon(Icons.my_library_music),
              ),
            ),
          ),
        );
    }

    return const SizedBox();
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
    return Scaffold(
      appBar: AppBar(
          //title: Text(Uri.parse(fileUrl).path),
          ),
      body: Column(
        children: [
          Expanded(
              child: InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(fileUrl)),
          )),
        ],
      ),
    );
  }
}
