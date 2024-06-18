import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';

class ShareCoCreateKnowledgeBaseRequestModel {
  String contentId = "";
  String folderPath = "";
  int assignComponentId = InstancyComponents.CoCreateKnowledgeComponent;

  ShareCoCreateKnowledgeBaseRequestModel({
    required this.contentId,
    required this.folderPath,
    this.assignComponentId = InstancyComponents.CoCreateKnowledgeComponent,
  });

  Map<String, dynamic> toMap() {
    return {
      "folderPath": folderPath,
      "contentId": contentId,
      "assignComponentId": assignComponentId,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
