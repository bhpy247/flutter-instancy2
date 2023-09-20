import 'dart:async';
import 'dart:io';

import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/backend/lens_feature/lens_controller.dart';
import 'package:flutter_instancy_2/backend/lens_feature/lens_provider.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/ar_vr_module/data_model/ar_scene_meshobject_model.dart';
import 'package:flutter_instancy_2/models/ar_vr_module/data_model/ar_scene_model.dart';
import 'package:flutter_instancy_2/models/ar_vr_module/response_model/ar_content_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;

import '../../../../api/api_call_model.dart';
import '../../../../api/rest_client.dart';
import '../../../../models/common/model_data_parser.dart';
import '../../../../utils/my_print.dart';
import '../../../../utils/my_utils.dart';

class SurfaceTrackingScreenAndroid extends StatefulWidget {
  final ARContentModel? arContentModel;

  const SurfaceTrackingScreenAndroid({
    super.key,
    this.arContentModel,
  });

  @override
  State<SurfaceTrackingScreenAndroid> createState() => SurfaceTrackingScreenAndroidState();
}

class SurfaceTrackingScreenAndroidState extends State<SurfaceTrackingScreenAndroid> with MySafeState {
  late AppProvider appProvider;

  late LensProvider lensProvider;
  late LensController lensController;

  late Future<bool> checkPermissionsFuture;

  ArCoreViewType arCoreViewType = ArCoreViewType.STANDARDVIEW;

  ArCoreController? arCoreController;

  bool isDetectingPlane = false;
  bool isCapturingPlanePosition = false;
  StreamController<List<ArCoreHitTestResult>> planeTapStreamController = StreamController<List<ArCoreHitTestResult>>.broadcast();
  StreamController<ArCorePlane> planeDetectionStreamController = StreamController<ArCorePlane>.broadcast();

  ARContentModel? arContentModel;
  int currentScene = -1;
  ArCoreNode? anchorNode;

  Future<bool> checkPermissions() async {
    if (!kIsWeb && Platform.isAndroid) {
      bool isARCoreAvailable = await ArCoreController.checkArCoreAvailability();
      MyPrint.printOnConsole('ARCORE IS AVAILABLE?');
      MyPrint.printOnConsole(isARCoreAvailable);

      if (!isARCoreAvailable) {
        return false;
      }

      bool isARCoreInstalled = await ArCoreController.checkIsArCoreInstalled();
      MyPrint.printOnConsole('\nAR SERVICES INSTALLED?');
      MyPrint.printOnConsole(isARCoreInstalled);

      if (!isARCoreInstalled) {
        return false;
      }

      return true;
    }

    return false;
  }

  void _onArCoreViewCreated(ArCoreController controller) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("SurfaceTrackingScreenAndroidState()._onArCoreViewCreated called", tag: tag);

    arCoreController = controller;
    controller.onPlaneTap = onPlaneTap;
    controller.onPlaneDetected = onPlaneDetected;

    initializeARViewFromARContentModel(arContentModel: arContentModel);
  }

  void onPlaneTap(List<ArCoreHitTestResult> hits) {
    planeTapStreamController.add(hits);
  }

  void onPlaneDetected(ArCorePlane plane) {
    planeDetectionStreamController.add(plane);
  }

  Future<void> initializeARViewFromARContentModel({required ARContentModel? arContentModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("SurfaceTrackingScreenAndroidState().initializeARViewFromARContentModel called with arContentModel:$arContentModel", tag: tag);

    ArCoreController? controller = arCoreController;

    if (controller == null) {
      MyPrint.printOnConsole("Returning from SurfaceTrackingScreenAndroidState().initializeARViewFromARContentModel because controller is null", tag: tag);

      return;
    }

    if (arContentModel == null) {
      MyPrint.printOnConsole("Returning from SurfaceTrackingScreenAndroidState().initializeARViewFromARContentModel because arContentModel is null", tag: tag);
      return;
    }

    ARSceneModel? arSceneModel = arContentModel.scenes.firstOrNull;

    if (arSceneModel == null) {
      MyPrint.printOnConsole("Returning from SurfaceTrackingScreenAndroidState().initializeARViewFromARContentModel because arSceneModel is null", tag: tag);
      return;
    }

    isDetectingPlane = false;
    isCapturingPlanePosition = false;

    isDetectingPlane = true;
    mySetState();

    ArCorePlane? plane = await detectPlane(controller: controller);
    MyPrint.printOnConsole("Plane detected:$plane", tag: tag);

    MyPrint.printOnConsole("Detecting Plane", tag: tag);
    isDetectingPlane = false;
    mySetState();

    if (plane == null) {
      MyPrint.printOnConsole("Returning from SurfaceTrackingScreenAndroidState().initializeARViewFromARContentModel because detected plane is null", tag: tag);
      return;
    }

    MyPrint.printOnConsole("Capturing Position", tag: tag);
    isCapturingPlanePosition = true;
    mySetState();

    vector_math.Vector3? position = await pickPlanePosition(controller: controller);
    MyPrint.printOnConsole("Position captured:$position", tag: tag);

    isCapturingPlanePosition = false;
    mySetState();

    await initializeARViewFromARSceneModel(sceneModel: arSceneModel, planePosition: position);
  }

  Future<ArCorePlane?> detectPlane({required ArCoreController controller}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("SurfaceTrackingScreenAndroidState().detectPlane() called", tag: tag);

    ArCorePlane? detectedPlane;

    try {
      detectedPlane = await planeDetectionStreamController.stream.first.then((ArCorePlane? plane) {
        return plane;
      }).catchError((e, s) {
        return null;
      });
    } catch (e, s) {
      MyPrint.printOnConsole("Error in SurfaceTrackingScreenAndroidState().detectPlane():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    MyPrint.printOnConsole("Final detectedPlane:$detectedPlane", tag: tag);

    return detectedPlane;
  }

  Future<vector_math.Vector3?> pickPlanePosition({required ArCoreController controller}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("SurfaceTrackingScreenAndroidState().pickPlanePosition called", tag: tag);

    vector_math.Vector3? planePosition;

    try {
      List<ArCoreHitTestResult> hits = await planeTapStreamController.stream.first;
      planePosition = hits.firstOrNull?.pose.translation;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in SurfaceTrackingScreenAndroidState().pickPlanePosition():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    MyPrint.printOnConsole("Final planePosition:$planePosition", tag: tag);

    return planePosition;
  }

  Future<void> initializeARViewFromARSceneModel({required ARSceneModel sceneModel, required vector_math.Vector3? planePosition}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("SurfaceTrackingScreenAndroidState().initializeARViewFromARSceneModel called with sceneModel:$sceneModel, planePosition:$planePosition", tag: tag);

    ArCoreController? controller = arCoreController;

    if (controller == null) {
      MyPrint.printOnConsole("Returning from SurfaceTrackingScreenAndroidState().initializeARViewFromARSceneModel() because controller is null", tag: tag);
      return;
    }

    await clearCurrentScene();

    currentScene = sceneModel.id;

    if (sceneModel.sceneType == ARContentSceneTypes.imageTracking) {} else if (sceneModel.sceneType == ARContentSceneTypes.groundTracking) {}

    List<Future<ArCoreNode?>> futures = sceneModel.meshObjects.map((ARSceneMeshObjectModel meshObjectModel) {
      return handleProto1ARModuleSceneMeshObjectModel(model: meshObjectModel);
    }).toList();

    if (futures.isEmpty) {
      MyPrint.printOnConsole("Returning from SurfaceTrackingScreenAndroidState().initializeARViewFromARSceneModel() because futures is empty", tag: tag);
      return;
    }

    MyPrint.printOnConsole("Getting Nodes", tag: tag);
    DateTime startTime = DateTime.now();
    List<ArCoreNode?> nodes = await Future.wait<ArCoreNode?>(futures);
    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole("Got Nodes in ${endTime.difference(startTime).inMilliseconds} Milliseconds", tag: tag);

    List<ArCoreNode> finalNodes = (nodes..removeWhere((element) => element == null)).map((e) => e!).toList();
    MyPrint.printOnConsole("finalNodes:${finalNodes.length}", tag: tag);

    MyPrint.printOnConsole("Adding anchorNode", tag: tag);
    ArCoreImage? image;
    ArCoreVideoNode? video;
    if (sceneModel.bgMediaObject) {
      AppConfigurationOperations appConfigurationOperations = AppConfigurationOperations(appProvider: appProvider);

      if (sceneModel.bgVRType == ARContentBGVRType.image_360) {
        MyPrint.printOnConsole("Scene BG Image Url Before:'${sceneModel.mediaUrl}'", tag: tag);
        String imageUrl = appConfigurationOperations.getARContentUrl(url: sceneModel.mediaUrl);
        MyPrint.printOnConsole("Scene BG Image Url After:'$imageUrl'", tag: tag);

        if (imageUrl.isNotEmpty) {
          Uint8List? bytes = await getBytesFromUrl(url: imageUrl);

          if (bytes != null) {
            image = ArCoreImage(
              bytes: bytes,
            );
          }
        }
      } else if (sceneModel.bgVRType == ARContentBGVRType.video_360) {
        MyPrint.printOnConsole("Scene BG Video Url Before:'${sceneModel.mediaUrl}'", tag: tag);
        String videoUrl = appConfigurationOperations.getARContentUrl(url: sceneModel.mediaUrl);
        MyPrint.printOnConsole("Scene BG Video Url After:'$videoUrl'", tag: tag);

        if (videoUrl.isNotEmpty) {
          video = ArCoreVideoNode(
            url: videoUrl,
          );
        }
      }
    }

    anchorNode = ArCoreNode(
      name: sceneModel.id.toString(),
      // position: anchorPose.translation,
      // rotation: anchorPose.rotation,
      image: image,
      video: video,
      position: planePosition,
      children: finalNodes,
    );
    await controller.addArCoreNodeWithAnchor(anchorNode!);
    MyPrint.printOnConsole("anchorNode added", tag: tag);
  }

  Future<ArCoreNode?> handleProto1ARModuleSceneMeshObjectModel({required ARSceneMeshObjectModel model}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("handleProto1ARModuleSceneMeshObjectModel called", tag: tag);
    MyPrint.printOnConsole("meshType:${model.meshType}", tag: tag);

    ArCoreNode? node;

    AppConfigurationOperations appConfigurationOperations = AppConfigurationOperations(appProvider: appProvider);

    if (model.meshType == ARContentMeshTypes.text) {} else if (model.meshType == ARContentMeshTypes.sphere) {
      final material = ArCoreMaterial(
        // color: const Color.fromARGB(255, 255, 0, 0),
        color: const Color.fromARGB(120, 66, 134, 244),
      );
      final sphere = ArCoreSphere(
        materials: [material],
        radius: 0.2,
      );
      node = ArCoreNode(
        shape: sphere,
        // position: Vector3(0, 0, -1.5),
        position: model.position,
        scale: model.scale,
        rotation: model.rotation,
      );
    } else if (model.meshType == ARContentMeshTypes.button) {
      MyPrint.printOnConsole("button ImageUrl Before:'${model.mediaUrl}'", tag: tag);
      String imageUrl = appConfigurationOperations.getARContentUrl(url: model.mediaUrl);
      MyPrint.printOnConsole("button ImageUrl After:'$imageUrl'", tag: tag);

      if (imageUrl.isEmpty) {
        return null;
      }

      Uint8List? bytes = await getBytesFromUrl(url: imageUrl);

      if (bytes == null) {
        MyPrint.printOnConsole("button Image bytes null", tag: tag);
        return null;
      }

      node = ArCoreNode(
        image: ArCoreImage(
          bytes: bytes,
          width: model.objectSettings?.width.toInt(),
          height: model.objectSettings?.height.toInt(),
        ),
        position: model.position,
        rotation: model.rotation,
      );
    } else if (model.meshType == ARContentMeshTypes.hotspot) {
      MyPrint.printOnConsole("hotspot ImageUrl Before:'${model.mediaUrl}'", tag: tag);
      String imageUrl = appConfigurationOperations.getARContentUrl(url: model.mediaUrl);
      MyPrint.printOnConsole("hotspot ImageUrl After:'$imageUrl'", tag: tag);

      if (imageUrl.isEmpty) {
        return null;
      }

      Uint8List? bytes = await getBytesFromUrl(url: imageUrl);

      if (bytes == null) {
        MyPrint.printOnConsole("Hotspot Image bytes null", tag: tag);
        return null;
      }

      node = ArCoreNode(
        image: ArCoreImage(
          bytes: bytes,
          width: 300,
          height: 300,
        ),
        position: model.position,
        rotation: model.rotation,
      );
    } else if (model.meshType == ARContentMeshTypes.image) {
      MyPrint.printOnConsole("ImageUrl Before:'${model.mediaUrl}'", tag: tag);
      String imageUrl = appConfigurationOperations.getARContentUrl(url: model.mediaUrl);
      MyPrint.printOnConsole("ImageUrl After:'$imageUrl'", tag: tag);

      if (imageUrl.isEmpty) {
        return null;
      }

      Uint8List? bytes = await getBytesFromUrl(url: imageUrl);

      if (bytes == null) {
        return null;
      }

      node = ArCoreNode(
        name: model.id.toString(),
        image: ArCoreImage(
          bytes: bytes,
          width: 300,
          height: 300,
        ),
        position: model.position,
        rotation: model.rotation,
      );
    } else if (model.meshType == ARContentMeshTypes.video) {
      MyPrint.printOnConsole("Video Url Before:'${model.mediaUrl}'", tag: tag);
      String videoUrl = appConfigurationOperations.getARContentUrl(url: model.mediaUrl);
      MyPrint.printOnConsole("Video Url After:'$videoUrl'", tag: tag);

      if (videoUrl.isEmpty) {
        return null;
      }

      node = ArCoreNode(
        name: model.id.toString(),
        video: ArCoreVideoNode(
          url: videoUrl,
          width: model.objectSettings?.width.toInt(),
          height: model.objectSettings?.height.toInt(),
        ),
        position: model.position,
        rotation: model.rotation,
      );
    } else if (model.meshType == ARContentMeshTypes.audio) {
      MyPrint.printOnConsole("Audio Url Before:'${model.mediaUrl}'", tag: tag);
      String audioUrl = appConfigurationOperations.getARContentUrl(url: model.mediaUrl);
      MyPrint.printOnConsole("Audio Url After:'$audioUrl'", tag: tag);

      if (audioUrl.isEmpty) {
        return null;
      }
    } else if (model.meshType == ARContentMeshTypes.glb) {
      MyPrint.printOnConsole("objectUrl Before:'${model.mediaUrl}'", tag: tag);
      String objectUrl = appConfigurationOperations.getARContentUrl(url: model.mediaUrl);
      MyPrint.printOnConsole("objectUrl After:'$objectUrl'", tag: tag);

      if (objectUrl.isEmpty) {
        return null;
      }

      node = ArCoreReferenceNode(
        name: model.id.toString(),
        objectUrl: objectUrl,
        position: model.position,
        rotation: model.rotation,
        scale: model.scale,
      );
    } else if (model.meshType == ARContentMeshTypes.gltf) {
      MyPrint.printOnConsole("gltf objectUrl Before:'${model.mediaUrl}'", tag: tag);
      String objectUrl = appConfigurationOperations.getARContentUrl(url: model.mediaUrl);
      MyPrint.printOnConsole("gltf objectUrl After:'$objectUrl'", tag: tag);

      if (objectUrl.isEmpty) {
        return null;
      }

      MyPrint.printOnConsole("model.position:${model.position}", tag: tag);
      MyPrint.printOnConsole("model.rotation:${model.rotation}", tag: tag);
      MyPrint.printOnConsole("model.scale:${model.scale}", tag: tag);

      node = ArCoreReferenceNode(
        name: model.id.toString(),
        objectUrl: objectUrl,
        position: model.position,
        rotation: model.rotation,
        scale: model.scale,
      );
    }

    return node;
  }

  Future<Uint8List?> getBytesFromUrl({required String url}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("SurfaceTrackingScreenAndroid().getBytesFromUrl() called with url:'$url'", tag: tag);

    if (url.isEmpty) {
      return null;
    }

    Uint8List? bytes;

    try {
      ApiCallModel apiCallModel = await ApiController().getApiCallModelFromData(
        restCallType: RestCallType.simpleGetCall,
        parsingType: ModelDataParsingType.dynamic,
        url: url,
        isGetDataFromHive: false,
        isStoreDataInHive: false,
      );

      http.Response? response = await RestClient.getCall(
        apiCallModel: apiCallModel,
      );

      bytes = response?.bodyBytes;
      MyPrint.printOnConsole("Bytes Length:${bytes?.length}", tag: tag);
    } catch (e, s) {
      MyPrint.printOnConsole("Error in SurfaceTrackingScreenAndroid().getBytesFromUrl():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    return bytes;
  }

  Future<void> clearCurrentScene() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("SurfaceTrackingScreenAndroidState().clearCurrentScene() called", tag: tag);

    if (isDetectingPlane || isCapturingPlanePosition) {
      isDetectingPlane = false;
      isCapturingPlanePosition = false;
      mySetState();
    }

    ArCoreController? controller = arCoreController;

    if (controller == null) {
      MyPrint.printOnConsole("Returning from SurfaceTrackingScreenAndroidState().clearCurrentScene() because controller is null", tag: tag);
      return;
    }

    if (anchorNode == null) {
      MyPrint.printOnConsole("Returning from SurfaceTrackingScreenAndroidState().clearCurrentScene() because anchorNode is null", tag: tag);
      return;
    }

    // Remove Any Existing Anchor
    MyPrint.printOnConsole("anchorNode:$anchorNode", tag: tag);
    if (anchorNode != null) {
      MyPrint.printOnConsole("Removing anchorNode from SceneView", tag: tag);
      controller.removeNode(nodeName: anchorNode!.name).then((value) {
        MyPrint.printOnConsole("Removed anchorNode with name ${anchorNode!.name} from SceneView", tag: tag);
      });
    }

    List<Future> futures = [];
    anchorNode?.children?.forEach((ArCoreNode node) {
      futures.add(controller.removeNode(nodeName: node.name).then((value) {
        MyPrint.printOnConsole("Removed node with name ${node.name} from SceneView", tag: tag);
      }));
    });
    if (futures.isNotEmpty) await Future.wait(futures);

    /*List<Future> futures = <Future>[];
    for (ARSceneModel sceneModel in arContentModel!.scenes) {
      for (ARSceneMeshObjectModel meshObjectModel in sceneModel.meshObjects) {
        futures.add(controller.removeNode(nodeName: meshObjectModel.id.toString()));
      }
    }

    MyPrint.printOnConsole("futures length:${futures.length}");
    await Future.wait(futures);*/

    anchorNode = null;
    arContentModel = null;
    currentScene = -1;
    mySetState();
  }

  Future<void> showGLTFModel({required String gltfUrl}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("SurfaceTrackingScreenAndroidState().showGLTFModel() called with gltfUrl:'$gltfUrl'", tag: tag);

    ArCoreController? controller = arCoreController;

    if (controller == null) {
      MyPrint.printOnConsole("Returning from SurfaceTrackingScreenAndroidState().initializeARViewFromARSceneModel() because controller is null", tag: tag);
      return;
    }

    bool isAdded = await controller
        .addArCoreNode(ArCoreReferenceNode(
      objectUrl: gltfUrl,
      position: vector_math.Vector3(0, 0, -2),
      scale: vector_math.Vector3(0.1, 0.1, 0.1),
    ))
        .then((value) {
      MyPrint.printOnConsole("Successfully Shown GLTF Model", tag: tag);

      return true;
    }).catchError((e, s) {
      MyPrint.printOnConsole("Error in Showing GLTF Model:$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);

      return false;
    });

    MyPrint.printOnConsole("isAdded:$isAdded", tag: tag);
  }

  @override
  void initState() {
    super.initState();

    appProvider = context.read<AppProvider>();

    lensProvider = context.read<LensProvider>();
    lensController = LensController(lensProvider: lensProvider);

    arContentModel = widget.arContentModel;

    checkPermissionsFuture = checkPermissions();
  }

  @override
  void dispose() {
    arCoreController?.dispose();
    planeTapStreamController.close();
    planeDetectionStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return Consumer<LensProvider>(
      builder: (BuildContext context, LensProvider lensProvider, Widget? child) {
        return FutureBuilder<bool>(
          future: checkPermissionsFuture,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const CommonLoader(
                isCenter: true,
              );
            } else if (snapshot.hasError || snapshot.error != null) {
              return const Center(
                child: Text("Error in Loading Screen"),
              );
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(
                child: Text("Couldn't Load Screen"),
              );
            }

            return getMainBody();
          },
        );
      },
    );
  }

  Widget getMainBody() {
    MyPrint.printOnConsole("isDetectingPlane:$isDetectingPlane");
    MyPrint.printOnConsole("isCapturingPlanePosition:$isCapturingPlanePosition");

    return Stack(
      fit: StackFit.expand,
      children: [
        ArCoreView(
          onArCoreViewCreated: _onArCoreViewCreated,
          type: arCoreViewType,
          debug: true,
          enablePlaneRenderer: true,
          enableTapRecognizer: true,
          enableUpdateListener: true,
        ),
        if (isDetectingPlane)
          Align(
            alignment: Alignment.center,
            child: getPlaneDetectionInstructionWidget(),
          ),
        if (isCapturingPlanePosition)
          Align(
            alignment: Alignment.center,
            child: getPlaneTapInstructionWidget(),
          ),
      ],
    );
  }

  Widget getPlaneDetectionInstructionWidget() {
    Size size = context.sizeData;
    return IgnorePointer(
      child: SizedBox(
        width: (size.aspectRatio > 1 ? size.height : size.width) * 0.6,
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.asset(
            AppAssets.surfaceDetection,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Widget getPlaneTapInstructionWidget() {
    Size size = context.sizeData;
    return IgnorePointer(
      child: SizedBox(
        width: (size.aspectRatio > 1 ? size.height : size.width) * 0.4,
        child: Image.asset(
          AppAssets.tapOnPlane,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
