import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/Catalog/catalog_controller.dart';
import 'package:flutter_instancy_2/backend/Catalog/catalog_provider.dart';
import 'package:flutter_instancy_2/backend/lens_feature/lensController.dart';
import 'package:flutter_instancy_2/models/catalog/data_model/catalog_course_dto_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/views/lens_feature/component/lens_courses_bottomsheet_widget.dart';
import 'package:googleapis/vision/v1.dart' as vision_api;
import 'package:provider/provider.dart';

import '../../../backend/lens_feature/lens_provider.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_safe_state.dart';
import '../../../utils/my_toast.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/modal_progress_hud.dart';

class ImageFeatureScreen extends StatefulWidget {
  final CameraController cameraController;
  final LensProvider? lensProvider;

  const ImageFeatureScreen({
    super.key,
    required this.cameraController,
    required this.lensProvider,
  });

  @override
  State<ImageFeatureScreen> createState() => _ImageFeatureScreenState();
}

class _ImageFeatureScreenState extends State<ImageFeatureScreen> with WidgetsBindingObserver, TickerProviderStateMixin, MySafeState {
  late LensProvider lensProvider;
  late LensController lensController;

  late CameraController controller;
  XFile? imageFile;
  List<CatalogCourseDTOModel> catalogCourseList = [];
  bool isLoading = false;
  late CatalogController catalogController;
  late CatalogProvider catalogProvider;
  List<String> labels = [];
  late AnimationController _flashModeControlRowAnimationController;
  bool isShowRetakeButton = true;
  DraggableScrollableController scrollController = DraggableScrollableController();

  void _showCameraException(CameraException e) {
    MyToast.showSuccess(msg: 'Error: ${e.code}\n${e.description}', context: context);
  }

  Future<void> onTakePictureButtonPressed() async {
    XFile? file = await takePicture();

    imageFile = file;
    mySetState();

    controller.setFlashMode(FlashMode.off);
    controller.pausePreview();
    await detectObjectVisionApi();
  }

  Future<XFile?> takePicture() async {
    final CameraController cameraController = controller;
    if (!cameraController.value.isInitialized) {
      MyToast.showSuccess(msg: 'Error: select a camera first.', context: context);

      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      final XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  Future<void> detectObjectVisionApi() async {
    isLoading = true;
    mySetState();
    Uint8List? imageBytes = await clickImageAndGiveBytes(imageFile);

    if (imageBytes == null) {
      if (context.mounted && context.checkMounted()) {
        MyToast.showError(context: context, msg: "Error in converting image to bytes");
      }
      return;
    }

    List<vision_api.LocalizedObjectAnnotation>? detectionResponse = await catalogController.detectImage(imageBytes);

    if (detectionResponse == null) {
      MyPrint.printOnConsole("Returning from ImageDetectionScreen().clickPhotoAndDetectObject() because detectionResponse is Null");

      isLoading = false;
      mySetState();

      return;
    }

    List<String> labels = detectionResponse.map((e) => e.name ?? "").toSet().toList()..removeWhere((element) => element.isEmpty);
    MyPrint.printOnConsole("labels:$labels");

    this.labels = labels;
    await getCourseList();

    isLoading = false;
    mySetState();
  }

  Future<Uint8List?> clickImageAndGiveBytes(XFile? imageFile) async {
    String tag = MyUtils.getNewId(isFromUUuid: true);
    MyPrint.printOnConsole("ImageDetectionScreen().clickImageAndGiveBytes() called with file", tag: tag);

    if (imageFile == null) {
      MyPrint.printOnConsole("Returning from ImageDetectionScreen().clickImageAndGiveBytes() because Picked image is Null", tag: tag);
      return null;
    }

    Uint8List? bytes;
    try {
      bytes = await imageFile.readAsBytes();
    } catch (e, s) {
      MyPrint.printOnConsole("Error in Reading Bytes from Picked Image in DataController.clickImageAndGiveBytes():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    MyPrint.printOnConsole("Final Bytes Length in ImageDetectionScreen().clickImageAndGiveBytes():${bytes?.length}", tag: tag);
    return bytes;
  }

  Future getCourseList() async {
    await Future.delayed(
      const Duration(seconds: 2),
      () {
        // CatalogCourseDTOModel catalogCourseDTOModel = CatalogCourseDTOModel(Categories: "3D Heart");
        // List<CatalogCourseDTOModel> list = [catalogCourseDTOModel, catalogCourseDTOModel, catalogCourseDTOModel];
        // catalogCourseList.addAll(list);
      },
    );
    setState(() {});
  }

  void onFlashModeButtonPressed() {
    if (_flashModeControlRowAnimationController.value == 1) {
      _flashModeControlRowAnimationController.reverse();
    } else {
      _flashModeControlRowAnimationController.forward();
    }
  }

  Future<void> onSetFlashModeButtonPressed(FlashMode mode) async {
    try {
      await controller.setFlashMode(mode);
    } on CameraException catch (e, s) {
      MyPrint.printOnConsole("CameraException in ImageFeatureScreen().onSetFlashModeButtonPressed():$e");
      MyPrint.printOnConsole(s);

      _showCameraException(e);
    } catch (e, s) {
      MyPrint.printOnConsole("Error in ImageFeatureScreen().onSetFlashModeButtonPressed():$e");
      MyPrint.printOnConsole(s);
    }
  }

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    super.initState();

    lensProvider = widget.lensProvider ?? LensProvider();
    lensController = LensController(lensProvider: lensProvider);

    controller = widget.cameraController;
    catalogProvider = context.read<CatalogProvider>();
    catalogController = CatalogController(provider: catalogProvider);
    _flashModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    scrollController.addListener(() {
      if (scrollController.size == 1.0) {
        isShowRetakeButton = false;
      } else {
        isShowRetakeButton = true;
      }
      mySetState();
      MyPrint.printOnConsole("isShowRetakeButton $isShowRetakeButton");
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dispose();
    _flashModeControlRowAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    // MyPrint.printOnConsole("ImageFeatureScreen build called");

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LensProvider>.value(value: lensProvider),
      ],
      child: Consumer<LensProvider>(
        builder: (BuildContext context, LensProvider lensProvider, Widget? child) {
          return ModalProgressHUD(
            inAsyncCall: isLoading,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: imageFile == null ? getCameraView() : getImagePickedWidget(),
            ),
          );
        },
      ),
    );
  }

  Widget getCameraView() {
    return SizedBox(
      height: double.maxFinite,
      child: CameraPreview(
        controller,
        child: ValueListenableBuilder<CameraValue>(
          valueListenable: controller,
          builder: (BuildContext context, CameraValue cameraValue, Widget? child) {
            // MyPrint.printOnConsole("CameraValue builder build called");

            return Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: getCaptureControlRowWidget(),
                ),
                getFlashButton(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget getCaptureControlRowWidget() {
    final CameraController cameraController = controller;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)),
            child: InkWell(
              onTap: cameraController.value.isInitialized && !cameraController.value.isRecordingVideo ? onTakePictureButtonPressed : null,
              child: const Icon(
                Icons.circle,
                color: Colors.white,
                size: 80,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getFlashButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              if (controller.value.flashMode == FlashMode.torch) {
                onSetFlashModeButtonPressed(FlashMode.off);
              } else {
                onSetFlashModeButtonPressed(FlashMode.torch);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white38, shape: BoxShape.circle, border: Border.all(color: Colors.white)),
              child: Icon(
                controller.value.flashMode == FlashMode.torch ? Icons.flash_off : Icons.flash_on,
                color: Colors.white,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white38, shape: BoxShape.circle, border: Border.all(color: Colors.white)),
              child: const Icon(
                Icons.clear,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getImagePickedWidget() {
    return Stack(
      children: [
        _thumbnailWidget(),
        Align(
          alignment: Alignment.bottomRight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isShowRetakeButton) getReloadButton(),
              Flexible(
                child: LensCoursesBottomsheetWidget(
                  labels: labels,
                  scrollController: scrollController,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _thumbnailWidget() {
    return (kIsWeb
        ? Image.network(imageFile!.path)
        : Image.file(
      File(imageFile!.path),
      fit: BoxFit.cover,
      height: MediaQuery.of(context).size.height,
    ));
  }

  Widget getReloadButton() {
    return InkWell(
      onTap: () async {
        imageFile = null;

        await controller.resumePreview();
        labels.clear();
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white38, shape: BoxShape.circle, border: Border.all(color: Colors.white)),
        child: Image.asset(
          "assets/images/camera_retake.png",
          height: 30,
          width: 30,
        ),
      ),
    );
  }
}
