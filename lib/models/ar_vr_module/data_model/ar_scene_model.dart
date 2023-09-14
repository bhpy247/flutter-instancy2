import '../../../../utils/my_utils.dart';
import '../../../../utils/parsing_helper.dart';
import 'ar_scene_meshobject_model.dart';

class ARSceneModel {
  int id = 0;
  int sceneType = 0;
  String name = "";
  String mediaName = "";
  String mediaUrl = "";
  String bgVRType = "";
  bool bgMediaObject = false;
  bool isLoop = false;
  List<ARSceneMeshObjectModel> meshObjects = [];

  ARSceneModel({
    this.id = 0,
    this.sceneType = 0,
    this.name = "",
    this.mediaName = "",
    this.mediaUrl = "",
    this.bgVRType = "",
    this.bgMediaObject = false,
    this.isLoop = false,
    List<ARSceneMeshObjectModel>? meshObjects,
  }) {
    this.meshObjects = meshObjects ?? <ARSceneMeshObjectModel>[];
  }

  ARSceneModel.fromJson(Map<String, dynamic> json) {
    id = ParsingHelper.parseIntMethod(json["id"]);
    sceneType = ParsingHelper.parseIntMethod(json["sceneType"]);
    name = ParsingHelper.parseStringMethod(json["name"]);
    mediaName = ParsingHelper.parseStringMethod(json["mediaName"]);
    mediaUrl = ParsingHelper.parseStringMethod(json["mediaUrl"]);
    bgVRType = ParsingHelper.parseStringMethod(json["bgVRType"]);
    bgMediaObject = ParsingHelper.parseBoolMethod(json["bgMediaObject"]);
    isLoop = ParsingHelper.parseBoolMethod(json["isLoop"]);

    meshObjects.clear();
    List<Map<String, dynamic>> meshObjectsMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(json['meshObjects']);
    for (Map<String, dynamic> meshObjectsMap in meshObjectsMapsList) {
      if (meshObjectsMap.isNotEmpty) meshObjects.add(ARSceneMeshObjectModel.fromJson(meshObjectsMap));
    }
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id,
      "sceneType": sceneType,
      "name": name,
      "mediaName": mediaName,
      "mediaUrl": mediaUrl,
      "bgVRType": bgVRType,
      "bgMediaObject": bgMediaObject,
      "isLoop": isLoop,
      "meshObjects": meshObjects.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
