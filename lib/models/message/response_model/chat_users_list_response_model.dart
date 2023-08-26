import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';
import '../data_model/chat_user_model.dart';

class ChatUsersListResponseModel {
  List<ChatUserModel> Table = [];

  ChatUsersListResponseModel({this.Table = const []});

  ChatUsersListResponseModel.fromJson(Map<String, dynamic> json) {
    Table = ParsingHelper.parseMapsListMethod<String, dynamic>(json["Table"]).map((x) => ChatUserModel.fromJson(x)).toList();
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "Table": Table.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
