import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';

class ShareCoCreateKnowledgeBaseRequestModel {
  String contentId = "";
  String folderPath = "";
  String startPage = "";
  String contentName = "";
  int objectTypeId = 0;
  int assignComponentId = InstancyComponents.CoCreateKnowledgeComponent;

  ShareCoCreateKnowledgeBaseRequestModel({
    required this.contentId,
    required this.folderPath,
    required this.startPage,
    required this.objectTypeId,
    this.contentName = "",
    this.assignComponentId = InstancyComponents.CoCreateKnowledgeComponent,
  });

  Map<String, dynamic> toMap() {
    return {
      "contentId": contentId,
      "folderPath": folderPath,
      "startPage": startPage,
      "objectTypeId": objectTypeId,
      "assignComponentId": assignComponentId,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
