import 'package:flutter_instancy_2/utils/date_representation.dart';

import '../../../configs/app_constants.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class ChatMessageModel {
  String Message = "";
  String FromUserName = "";
  String ToUserName = "";
  String ProfPic = "";
  String fileUrl = "";
  String msgType = MessageType.Text;
  String Attachment = "";
  String FromStatus = "";
  String ToStatus = "";
  int FromUserID = 0;
  int ToUserID = 0;
  int chatId = 0;
  bool MarkAsRead = false;
  DateTime? SendDatetime;

  ChatMessageModel({
    this.Message = "",
    this.FromUserName = "",
    this.ToUserName = "",
    this.ProfPic = "",
    this.fileUrl = "",
    this.msgType = MessageType.Text,
    this.Attachment = "",
    this.FromStatus = "",
    this.ToStatus = "",
    this.FromUserID = 0,
    this.ToUserID = 0,
    this.chatId = 0,
    this.MarkAsRead = false,
    this.SendDatetime,
  });

  ChatMessageModel.fromJson(Map<String, dynamic> json) {
    Message = ParsingHelper.parseStringMethod(json["Message"]);
    FromUserName = ParsingHelper.parseStringMethod(json["FromUserName"]);
    ToUserName = ParsingHelper.parseStringMethod(json["ToUserName"]);
    ProfPic = ParsingHelper.parseStringMethod(json["ProfPic"]);
    fileUrl = ParsingHelper.parseStringMethod(json["fileUrl"]);
    msgType = ParsingHelper.parseStringMethod(json["msgType"], defaultValue: MessageType.Text);
    Attachment = ParsingHelper.parseStringMethod(json["Attachment"]);
    FromStatus = ParsingHelper.parseStringMethod(json["FromStatus"]);
    ToStatus = ParsingHelper.parseStringMethod(json["ToStatus"]);
    FromUserID = ParsingHelper.parseIntMethod(json["FromUserID"]);
    ToUserID = ParsingHelper.parseIntMethod(json["ToUserID"]);
    chatId = ParsingHelper.parseIntMethod(json["chatId"]);
    MarkAsRead = ParsingHelper.parseBoolMethod(json["MarkAsRead"]);

    SendDatetime = ParsingHelper.parseDateTimeMethod(json["SendDatetime"]);
    SendDatetime ??= ParsingHelper.parseDateTimeMethod(json["SendDatetime"], dateFormat: "yyyy-MM-dd HH:mm:ss aa");
  }

  Map<String, dynamic> toJson({bool toJson = true}) {
    return <String, dynamic>{
      "Message": Message,
      "FromUserName": FromUserName,
      "ToUserName": ToUserName,
      "ProfPic": ProfPic,
      "fileUrl": fileUrl,
      "msgType": msgType,
      "Attachment": Attachment,
      "FromStatus": FromStatus,
      "ToStatus": ToStatus,
      "FromUserID": FromUserID,
      "ToUserID": ToUserID,
      "chatId": chatId,
      "MarkAsRead": MarkAsRead,
      "SendDatetime": toJson ? DatePresentation.getFormattedDate(dateFormat: "yyyy-MM-dd HH:mm:ss aa", dateTime: SendDatetime) : ParsingHelper.parseTimestampMethod(SendDatetime),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
