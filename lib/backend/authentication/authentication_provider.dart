import 'package:flutter/material.dart';

import '../../models/authentication/data_model/profile_config_data_model.dart';
import '../../models/authentication/data_model/successful_user_login_model.dart';
import '../../utils/my_print.dart';

class AuthenticationProvider extends ChangeNotifier {
  //region SuccessfulUserLoginModel
  SuccessfulUserLoginModel? _successfulUserLoginModel;

  SuccessfulUserLoginModel? getSuccessfulUserLoginModel() => _successfulUserLoginModel;

  void setSuccessfulUserLoginModel({SuccessfulUserLoginModel? successfulUserLoginModel, bool isNotify = true}) {
    _successfulUserLoginModel = successfulUserLoginModel;
    if(isNotify) notifyListeners();
  }
  //endregion

  //region ProfileConfigDataList
  List<ProfileConfigDataModel> _profileConfigDataList = [];

  List<ProfileConfigDataModel> get profileConfigDataList => _profileConfigDataList;

  void setProfileConfigDataList({List<ProfileConfigDataModel> profileConfigDataList = const [], bool isNotify = true}) {
    _profileConfigDataList = profileConfigDataList;
    MyPrint.printOnConsole(" AuthenticationProvider ProfileConfigDataList: ${profileConfigDataList.length}");

    if(isNotify) notifyListeners();
  }
  //endregion
}