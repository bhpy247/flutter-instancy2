import 'package:flutter_chat_bot/utils/parsing_helper.dart';

class CommonResponseModel {
  String message = "";
  bool issuccess = false;

  CommonResponseModel({this.message = "", this.issuccess = false});

  CommonResponseModel.fromJson(Map<String, dynamic> json) {
    message = ParsingHelper.parseStringMethod(json['message']);
    issuccess = ParsingHelper.parseBoolMethod(json['issuccess']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['issuccess'] = issuccess;
    return data;
  }
}
