import 'package:flutter_instancy_2/utils/my_utils.dart';

class GetCoCreateKnowledgebaseListRequestModel {
  int userId = 0;
  String folderId = "";
  String cmsGroupId = "";

  GetCoCreateKnowledgebaseListRequestModel({
    required this.userId,
    required this.folderId,
    required this.cmsGroupId,
  });

  Map<String, String> toMap() {
    return {
      "userId": userId.toString(),
      "folderId": folderId,
      "cmsGroupId": cmsGroupId,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
