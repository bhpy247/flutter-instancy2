import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/extensions.dart';
import 'package:flutter_chat_bot/utils/my_safe_state.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:googleapis/vision/v1.dart' as vision_api;
import 'package:provider/provider.dart';

import '../../../backend/Catalog/catalog_controller.dart';
import '../../../backend/Catalog/catalog_provider.dart';
import '../../../models/course/data_model/CourseDTOModel.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_toast.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/common_loader.dart';
import '../../common/components/instancy_ui_actions/bottomsheet_drager.dart';
import '../../common/components/modal_progress_hud.dart';
import '../component/course_component.dart';

class OcrScreen extends StatefulWidget {
  final CameraController cameraController;

  const OcrScreen({super.key, required this.cameraController});

  @override
  State<OcrScreen> createState() => _OcrScreenState();
}

class _OcrScreenState extends State<OcrScreen> with WidgetsBindingObserver, TickerProviderStateMixin, MySafeState{
  late CameraController controller;
  late ThemeData themeData;
  XFile? imageFile;
  bool isLoading = false;
  List<String> labels = [];
  late CatalogController catalogController;
  late CatalogProvider catalogProvider;
  late AnimationController _flashModeControlRowAnimationController;
  DraggableScrollableController scrollController = DraggableScrollableController();
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);


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
       controller.setFlashMode(FlashMode.off);
       controller.pausePreview();
     await getRecognizedText();
      // await detectObjectVisionApi();
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

  Future<void> getRecognizedText() async {
    MyPrint.printOnConsole("inside  the getRecognizedText: ${imageFile!.path}");
    if(imageFile == null) return;
    isLoading = true;
    mySetState();
    final RecognizedText recognizedText = await textRecognizer.processImage(InputImage.fromFile(File(imageFile!.path)));
    MyPrint.printOnConsole("Text: ${recognizedText.text} TextBlock : ${recognizedText.blocks.length} ");

    if(recognizedText.blocks.isNotEmpty){
      labels = recognizedText.blocks.map((e) => e.text).toSet().toList()..removeWhere((element) => element.isEmpty);
      mySetState();
    }
    isLoading = false;
    mySetState();
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
    scrollController.addListener(() {
      if (scrollController.size == 1.0) {
        isVisible = false;
      } else {
        isVisible = true;
      }
      mySetState();
      MyPrint.printOnConsole("isVisible $isVisible");
    });
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
        ],
      )
          : getImagePickedWidget(),
    );
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
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (isVisible) getReloadButton(),
                Flexible(
                  child: courseList(),
                ),
              ],
            ),
          ),
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

  // Widget getToggleButton() {
  //   return ClipRRect(
  //     borderRadius: BorderRadius.circular(15),
  //     child: BackdropFilter(
  //       filter: ImageFilter.blur(
  //         sigmaX: 20.0,
  //         sigmaY: 20.0,
  //       ),
  //       child: ToggleButtons(
  //         borderRadius: BorderRadius.circular(15),
  //         color: Colors.white,
  //         borderColor: Colors.transparent,
  //         selectedBorderColor: Colors.transparent,
  //
  //         // fillColor: Colors.white,
  //         selectedColor: Colors.red,
  //
  //         isSelected: isSelected,
  //         // fillColor: Colors.white,
  //         onPressed: (int newIndex) {
  //           // looping through the list of booleans values
  //           for (int index = 0; index < isSelected.length; index++) {
  //             // checking for the index value
  //             if (index == newIndex) {
  //               // one button is always set to true
  //               isSelected[index] = true;
  //             } else {
  //               // other two will be set to false and not selected
  //               isSelected[index] = false;
  //             }
  //           }
  //           mySetState();
  //         },
  //         children: [
  //           Container(
  //             margin: EdgeInsets.all(3),
  //             padding: EdgeInsets.symmetric(horizontal: 12),
  //             child: Row(
  //               children: [
  //                 Icon(Icons.search, color: isSelected.contains(true) ? themeData.primaryColor : Colors.white, size: 18),
  //                 Text('Surface', style: TextStyle(fontSize: 15, color: themeData.primaryColor, fontWeight: FontWeight.w600)),
  //               ],
  //             ),
  //           ),
  //           Container(
  //             margin: EdgeInsets.all(3),
  //             padding: EdgeInsets.symmetric(horizontal: 12),
  //             child: Row(
  //               children: [
  //                 Icon(Icons.search, color: isSelected.contains(true) ? themeData.primaryColor : Colors.white, size: 18),
  //                 Text('Keyword', style: TextStyle(fontSize: 15, color: themeData.primaryColor, fontWeight: FontWeight.w600)),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget courseList() {
    if (labels.isEmpty) return const SizedBox();
    return DraggableScrollableSheet(
        controller: scrollController,
        expand: false,
        initialChildSize: 0.4,
        minChildSize: .32,
        builder: (BuildContext context, ScrollController controller) {
          // MyPrint.printOnConsole("hello $isVisible");
          // if(!isFirst){
          //   isFirst = true;
          //   controller.addListener(() {
          //     if(controller.position.userScrollDirection == ScrollDirection.reverse){
          //       isVisible = !isVisible;
          //       mySetState();
          //     }
          //   });
          // }

          return ClipRRect(
            borderRadius: const BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 20.0,
                sigmaY: 20.0,
              ),
              child: SingleChildScrollView(
                controller: controller,
                child: Column(
                  children: [
                    const BottomSheetDragger(color: Colors.white),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      shrinkWrap: true,
                      itemCount: labels.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CourseComponent(model: CourseDTOModel(Title: labels[index]));
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
    // if (catalogCourseList.isEmpty) return const SizedBox();
  }
}
