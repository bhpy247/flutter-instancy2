import 'dart:typed_data';

import '../../../utils/date_representation.dart';
import '../../../utils/my_utils.dart';

class SendChatMessageRequestModel {
  int FromUserID = 0;
  int ToUserID = 0;
  String Message = "";
  String chatRoomId = "";
  String MessageType = "";
  DateTime? SendDatetime;
  bool MarkAsRead = false;
  String? fileName;
  Uint8List? fileBytes;

  SendChatMessageRequestModel({
    required this.FromUserID,
    required this.ToUserID,
    required this.chatRoomId,
    required this.MessageType,
    required this.SendDatetime,
    this.Message = "",
    this.MarkAsRead = false,
    this.fileName,
    this.fileBytes,
  });

  Map<String, String> toJson() {
    return {
      "FromUserID": FromUserID.toString(),
      "ToUserID": ToUserID.toString(),
      "MessageType": MessageType,
      "Message": Message,
      "SendDatetime": DatePresentation.getFormattedDate(dateFormat: "yyyy-MM-dd HH:mm:ss aa", dateTime: SendDatetime) ?? "",
      "MarkAsRead": MarkAsRead.toString(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
