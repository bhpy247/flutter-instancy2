import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../../utils/my_utils.dart';

class SaveSocialNetworkUsersResponseDtoModel {
  int UserID = 0;
  int FromSiteID = 0;
  int ToSiteID = 0;
  String tokeyKey = "";

  SaveSocialNetworkUsersResponseDtoModel({
    this.UserID = 0,
    this.FromSiteID = 0,
    this.ToSiteID = 0,
    this.tokeyKey = "",
  });

  SaveSocialNetworkUsersResponseDtoModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    UserID = ParsingHelper.parseIntMethod(map["UserID"]);
    FromSiteID = ParsingHelper.parseIntMethod(map["FromSiteID"]);
    ToSiteID = ParsingHelper.parseIntMethod(map["ToSiteID"]);
    tokeyKey = ParsingHelper.parseStringMethod(map["tokeyKey"]);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "UserID": UserID,
      "FromSiteID": FromSiteID,
      "ToSiteID": ToSiteID,
      "tokeyKey": tokeyKey,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
