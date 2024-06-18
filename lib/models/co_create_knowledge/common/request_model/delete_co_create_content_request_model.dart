import 'package:flutter_instancy_2/utils/my_utils.dart';

class DeleteCoCreateContentRequestModel {
  int UserID = 0;
  String ContentID = "";
  int ActiveStatus = 0;

  DeleteCoCreateContentRequestModel({
    required this.UserID,
    required this.ContentID,
    this.ActiveStatus = 0,
  });

  Map<String, String> toMap() {
    return {
      "UserID": UserID.toString(),
      "ContentID": ContentID,
      "ActiveStatus": ActiveStatus.toString(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
