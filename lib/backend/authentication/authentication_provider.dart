import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/models/authentication/data_model/native_login_dto_model.dart';
import 'package:flutter_instancy_2/models/authentication/data_model/profile_config_data_model.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';

class AuthenticationProvider extends ChangeNotifier {
  //region EmailLoginResponseModel
  NativeLoginDTOModel? _emailLoginResponseModel;

  NativeLoginDTOModel? getEmailLoginResponseModel() => _emailLoginResponseModel;

  void setEmailLoginResponseModel({NativeLoginDTOModel? emailLoginResponseModel, bool isNotify = true}) {
    _emailLoginResponseModel = emailLoginResponseModel;
    if (isNotify) notifyListeners();
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