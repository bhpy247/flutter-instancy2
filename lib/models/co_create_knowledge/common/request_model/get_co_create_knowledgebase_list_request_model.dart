import 'package:flutter_instancy_2/utils/my_utils.dart';

class GetCoCreateKnowledgebaseListRequestModel {
  int userId = 0;
  String folderId = "";
  String cmsGroupId = "";
  int componentId = 0;

  GetCoCreateKnowledgebaseListRequestModel({
    required this.userId,
    required this.folderId,
    required this.cmsGroupId,
    this.componentId = 0,
  });

  Map<String, String> toMap() {
    return {
      "userId": userId.toString(),
      "folderId": folderId,
      "cmsGroupId": cmsGroupId,
      "componentId": componentId.toString(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
