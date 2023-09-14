import 'package:vector_math/vector_math_64.dart';

import '../../../../utils/my_utils.dart';
import '../../../../utils/parsing_helper.dart';
import '../../../utils/extensions.dart';
import 'ar_scene_meshobject_setting_model.dart';

class ARSceneMeshObjectModel {
  int id = 0;
  int sceneId = 0;
  String name = "";
  String meshType = "";
  String mediaName = "";
  String mediaUrl = "";
  bool isLock = false;
  Vector3? position;
  Vector3? scale;
  Vector4? rotation;
  ARSceneMeshObjectSettingModel? objectSettings;

  ARSceneMeshObjectModel({
    this.id = 0,
    this.sceneId = 0,
    this.name = "",
    this.meshType = "",
    this.mediaName = "",
    this.mediaUrl = "",
    this.isLock = false,
    this.position,
    this.scale,
    this.rotation,
    this.objectSettings,
  });

  ARSceneMeshObjectModel.fromJson(Map<String, dynamic> json) {
    id = ParsingHelper.parseIntMethod(json["id"]);
    sceneId = ParsingHelper.parseIntMethod(json["sceneId"]);
    name = ParsingHelper.parseStringMethod(json["name"]);
    meshType = ParsingHelper.parseStringMethod(json["meshType"]);
    mediaName = ParsingHelper.parseStringMethod(json["mediaName"]);
    mediaUrl = ParsingHelper.parseStringMethod(json["mediaUrl"]);
    isLock = ParsingHelper.parseBoolMethod(json["isLock"]);

    position = null;
    Map<String, dynamic> positionMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(json['position']);
    if (positionMap.isNotEmpty) position = Vector3Extension.fromJson(positionMap);

    scale = null;
    Map<String, dynamic> scaleMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(json['scale']);
    if (scaleMap.isNotEmpty) scale = Vector3Extension.fromJson(scaleMap);

    rotation = null;
    Map<String, dynamic> rotationMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(json['rotation']);
    if (rotationMap.isNotEmpty) rotation = Vector4Extension.fromJson(rotationMap);

    objectSettings = null;
    Map<String, dynamic> objectSettingsMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(json['objectSettings']);
    if (objectSettingsMap.isNotEmpty) objectSettings = ARSceneMeshObjectSettingModel.fromJson(objectSettingsMap);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id,
      "sceneId": sceneId,
      "name": name,
      "meshType": meshType,
      "mediaName": mediaName,
      "mediaUrl": mediaUrl,
      "isLock": isLock,
      "position": position?.toJson(),
      "scale": scale?.toJson(),
      "rotation": rotation?.toJson(),
      "objectSettings": objectSettings?.toJson(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
