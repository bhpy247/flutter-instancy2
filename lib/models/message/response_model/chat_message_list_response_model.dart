import 'package:flutter_chat_bot/utils/parsing_helper.dart';

import '../../../utils/my_utils.dart';
import '../data_model/chat_message_model.dart';

class ChatMessageListResponseModel {
  List<ChatMessageModel> Table1 = <ChatMessageModel>[];

  ChatMessageListResponseModel({
    List<ChatMessageModel>? Table1,
  }) {
    this.Table1 = Table1 ?? <ChatMessageModel>[];
  }

  ChatMessageListResponseModel.fromJson(Map<String, dynamic> json) {
    Table1 = ParsingHelper.parseMapsListMethod<String, dynamic>(json["Table1"]).map((x) => ChatMessageModel.fromJson(x)).toList();
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "Table1": Table1.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
