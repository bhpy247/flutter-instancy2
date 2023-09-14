import '../../../../utils/my_utils.dart';
import '../data_model/ar_scene_model.dart';

class ARContentModel {
  List<ARSceneModel> scenes = <ARSceneModel>[];

  ARContentModel({
    List<ARSceneModel>? scenes,
  }) {
    this.scenes = scenes ?? <ARSceneModel>[];
  }

  ARContentModel.fromJson(List<Map<String, dynamic>> jsonList) {
    scenes.clear();
    for (Map<String, dynamic> json in jsonList) {
      if (json.isEmpty) continue;

      ARSceneModel proto1ARModuleSceneModel = ARSceneModel.fromJson(json);
      scenes.add(proto1ARModuleSceneModel);
    }
  }

  List<Map<String, dynamic>> toJson() {
    return scenes.map((e) => e.toJson()).toList();
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
