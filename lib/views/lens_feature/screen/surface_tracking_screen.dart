import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/extensions.dart';
import 'package:flutter_chat_bot/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/lens_feature/component/keyWordSearchScreen.dart';
import 'package:googleapis/vision/v1.dart' as vision_api;
import 'package:provider/provider.dart';

import '../../../backend/Catalog/catalog_controller.dart';
import '../../../backend/Catalog/catalog_provider.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_toast.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/common_loader.dart';
import '../../common/components/modal_progress_hud.dart';

class SurfaceTrackingScreen extends StatefulWidget {
  final CameraController cameraController;

  const SurfaceTrackingScreen({super.key, required this.cameraController});

  @override
  State<SurfaceTrackingScreen> createState() => _SurfaceTrackingScreenState();
}

class _SurfaceTrackingScreenState extends State<SurfaceTrackingScreen> with WidgetsBindingObserver, TickerProviderStateMixin, MySafeState {
  late CameraController controller;
  late ThemeData themeData;
  XFile? imageFile;
  bool isLoading = false;
  List<String> labels = [];
  late CatalogController catalogController;
  late CatalogProvider catalogProvider;
  late AnimationController _flashModeControlRowAnimationController;

  bool isFirst = false;
  bool isVisible = true;
  List<bool> isSelected = [false, false];

  void _showCameraException(CameraException e) {
    MyToast.showSuccess(msg: 'Error: ${e.code}\n${e.description}', context: context);
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

  Future<void> onTakePictureButtonPressed() async {
    takePicture().then((XFile? file) async {
      if (mounted) {
        setState(() {
          imageFile = file;
        });
        if (file != null) {}
      }
      await controller.setFlashMode(FlashMode.off);
      await controller.pausePreview();
      await detectObjectVisionApi();
    });
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
      return null;
    }

    if (bytes.isEmpty) {
      MyPrint.printOnConsole("Returning from ImageDetectionScreen().clickImageAndGiveBytes() because Picked image Bytes are empty", tag: tag);
      return null;
    }

    MyPrint.printOnConsole("Final Bytes Length in ImageDetectionScreen().clickImageAndGiveBytes():${bytes.length}", tag: tag);
    return bytes;
  }

  void onFlashModeButtonPressed() {
    if (_flashModeControlRowAnimationController.value == 1) {
      _flashModeControlRowAnimationController.reverse();
    } else {
      _flashModeControlRowAnimationController.forward();
    }
  }

  Future<void> onSetFlashModeButtonPressed(FlashMode mode) async {
    await setFlashMode(mode).then((_) {
      if (mounted) {
        setState(() {});
      }
      // showInSnackBar('Flash mode set to ${mode.toString().split('.').last}');
    });
  }

  Future<void> setFlashMode(FlashMode mode) async {
    try {
      await controller.setFlashMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    catalogProvider = context.read<CatalogProvider>();
    catalogController = CatalogController(provider: catalogProvider);
    controller = widget.cameraController;
    _flashModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _flashModeControlRowAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    themeData = Theme.of(context);

    return SizedBox(
      // height: MediaQuery.of(context).size.height,
      child: imageFile == null
          ? Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: CameraPreview(
                    controller,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _captureControlRowWidget(),
                ),
                flashButton(),
                if (isSelected[1]) Align(alignment: Alignment.bottomCenter, child: getContentList())
              ],
            )
          : getImagePickedWidget(),
    );
  }

  Widget _captureControlRowWidget() {
    final CameraController? cameraController = controller;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)),
            child: InkWell(
              onTap: cameraController != null && cameraController.value.isInitialized && !cameraController.value.isRecordingVideo ? onTakePictureButtonPressed : null,
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

  Widget flashButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: Column(
        children: [
          Row(
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
          getToggleButton()
        ],
      ),
    );
  }

  /// Display the thumbnail of the captured image or video.

  Widget getImagePickedWidget() {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: const CommonLoader(),
      child: Stack(
        children: [
          _thumbnailWidget(),
          SizedBox(),
        ],
      ),
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

  Widget getToggleButton() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffCECECEB2),
        borderRadius: BorderRadius.circular(15)
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 20.0,
            sigmaY: 20.0,
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: ToggleButtons(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              borderColor: Colors.transparent,
              selectedBorderColor: Colors.transparent,
              selectedColor: themeData.primaryColor,
              splashColor: Colors.transparent,
              fillColor: Color(0xffEDEDED),
              isSelected: isSelected,
              onPressed: (int newIndex) {
                // looping through the list of booleans values
                for (int index = 0; index < isSelected.length; index++) {
                  // checking for the index value
                  if (index == newIndex) {
                    // one button is always set to true
                    isSelected[index] = true;
                  } else {
                    // other two will be set to false and not selected
                    isSelected[index] = false;
                  }
                }
                mySetState();
              },
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Icon(Icons.search, size: 18),
                      Text(
                        'Surface',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Icon(Icons.search, size: 18),
                      Text(
                        'Keyword',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.all(3),
                //   padding: EdgeInsets.symmetric(horizontal: 12),
                //   child: Row(
                //     children: [
                //       Icon(Icons.search, color: isSelected.contains(true) ? themeData.primaryColor : Colors.white, size: 18),
                //       Text('Surface', style: TextStyle(fontSize: 15, color: themeData.primaryColor, fontWeight: FontWeight.w600)),
                //     ],
                //   ),
                // ),
                // Container(
                //   margin: EdgeInsets.all(3),
                //   padding: EdgeInsets.symmetric(horizontal: 12),
                //   child: Row(
                //     children: [
                //       Icon(Icons.search, color: isSelected.contains(true) ? themeData.primaryColor : Colors.white, size: 18),
                //       Text('Keyword', style: TextStyle(fontSize: 15, color: themeData.primaryColor, fontWeight: FontWeight.w600)),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getContentList() {
    // if (labels.isEmpty) return const SizedBox();
    return KeyWordSearchScreen(
      onBackButtonTap: () {
        isSelected = [true, false];
        mySetState();
      },
    );
    // if (catalogCourseList.isEmpty) return const SizedBox();
  }
}
