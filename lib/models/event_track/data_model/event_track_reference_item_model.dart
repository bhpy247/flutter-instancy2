import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class EventTrackReferenceItemModel {
  String id = "";
  String type = "";
  String title = "";
  String path = "";
  String description = "";
  String cid = "";
  bool isDownloaded = false;
  bool isDownloading = false;

  EventTrackReferenceItemModel({
    this.id = "",
    this.type = "",
    this.title = "",
    this.path = "",
    this.description = "",
    this.cid = "",
    this.isDownloading = false,
    this.isDownloaded = false,
  });

  EventTrackReferenceItemModel.fromJson(Map<String, dynamic> json) {
    id = ParsingHelper.parseStringMethod(json["id"]);
    type = ParsingHelper.parseStringMethod(json["type"]);
    title = ParsingHelper.parseStringMethod(json["title"]);
    path = ParsingHelper.parseStringMethod(json["path"]);
    description = ParsingHelper.parseStringMethod(json["description"]);
    cid = ParsingHelper.parseStringMethod(json["cid"]);
    isDownloaded = ParsingHelper.parseBoolMethod(json["isDownloaded"]);
    isDownloading = ParsingHelper.parseBoolMethod(json["isDownloading"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "type": type,
      "title": title,
      "path": path,
      "description": description,
      "cid": cid,
      "isDownloading": isDownloading,
      "isDownloaded": isDownloaded,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}