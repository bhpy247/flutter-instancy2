import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../../utils/my_utils.dart';

class ContentProgressDetailsUserDataModel {
  String userName = "";
  int userStatus = 0;

  ContentProgressDetailsUserDataModel({this.userName = "", this.userStatus = 0});

  ContentProgressDetailsUserDataModel.fromJson(Map<String, dynamic> json) {
    userName = ParsingHelper.parseStringMethod(json['UserName']);
    userStatus = ParsingHelper.parseIntMethod(json['UserStatus']);
  }

  Map<String, dynamic> toJson() {
    return {
      "UserName" : userName,
      "UserStatus" : userStatus,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}