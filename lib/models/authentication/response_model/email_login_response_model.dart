import 'package:flutter_instancy_2/models/authentication/data_model/failed_user_login_model.dart';
import 'package:flutter_instancy_2/models/authentication/data_model/successful_user_login_model.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../../utils/my_utils.dart';

class EmailLoginResponseModel {
  EmailLoginResponseModel({
    required this.successFullUserLogin,
  });

  List<SuccessfulUserLoginModel> successFullUserLogin = [];
  List<FailedUserLoginModel> faileduserlogin = [];

  EmailLoginResponseModel.fromJson(Map<String, dynamic> json) {
    successFullUserLogin = ParsingHelper.parseMapsListMethod<String, dynamic>(json["successfulluserlogin"]).map((x) => SuccessfulUserLoginModel.fromJson(x)).toList();
    faileduserlogin = ParsingHelper.parseMapsListMethod<String, dynamic>(json["faileduserlogin"]).map((x) => FailedUserLoginModel.fromJson(x)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      "successfulluserlogin": successFullUserLogin.map((x) => x.toJson()).toList(),
      "faileduserlogin": faileduserlogin.map((x) => x.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}