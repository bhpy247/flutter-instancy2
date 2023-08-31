import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/lens_feature/lens_controller.dart';
import 'package:flutter_instancy_2/views/lens_feature/component/lens_courses_bottomsheet_widget.dart';
import 'package:flutter_instancy_2/views/lens_feature/component/lens_screen_capture_control_widget.dart';
import 'package:provider/provider.dart';

import '../../../backend/lens_feature/lens_provider.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_safe_state.dart';
import '../../../utils/my_toast.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/modal_progress_hud.dart';
import '../component/lens_screen_flash_button.dart';

class LensImageSearchScreen extends StatefulWidget {
  final CameraController cameraController;
  final LensProvider? lensProvider;

  const LensImageSearchScreen({
    super.key,
    required this.cameraController,
    required this.lensProvider,
  });

  @override
  State<LensImageSearchScreen> createState() => _LensImageSearchScreenState();
}

class _LensImageSearchScreenState extends State<LensImageSearchScreen> with WidgetsBindingObserver, TickerProviderStateMixin, MySafeState {
  bool isLoading = false;

  late LensProvider lensProvider;
  late LensController lensController;

  late CameraController controller;

  XFile? imageFile;

  DraggableScrollableController scrollController = DraggableScrollableController();

  Future<void> onTakePictureButtonPressed() async {
    XFile? file = await takePicture();

    imageFile = file;
    mySetState();

    controller.setFlashMode(FlashMode.off);
    controller.pausePreview();

    if (imageFile == null) {
      return;
    }

    isLoading = true;
    mySetState();
    Uint8List? imageBytes = await getBytesFromImage(imageFile);

    if (imageBytes == null) {
      if (context.mounted) {
        MyToast.showError(context: context, msg: "Error in converting image to bytes");
      }
      isLoading = false;
      mySetState();
      return;
    }

    await lensController.performImageSearch(imageBytes: imageBytes);

    isLoading = false;
    mySetState();
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
      (e);
      return null;
    }
  }

  Future<Uint8List?> getBytesFromImage(XFile? imageFile) async {
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

  Future<void> onSetFlashModeButtonPressed({required BuildContext context, required FlashMode mode}) async {
    try {
      await controller.setFlashMode(mode);
    } on CameraException catch (e, s) {
      MyPrint.printOnConsole("CameraException in ImageFeatureScreen().onSetFlashModeButtonPressed():$e");
      MyPrint.printOnConsole(s);

      if (context.mounted) MyToast.showSuccess(msg: 'Error: ${e.code}\n${e.description}', context: context);
    } catch (e, s) {
      MyPrint.printOnConsole("Error in ImageFeatureScreen().onSetFlashModeButtonPressed():$e");
      MyPrint.printOnConsole(s);
    }
  }

  @override
  void initState() {
    super.initState();

    lensProvider = widget.lensProvider ?? LensProvider();
    lensController = LensController(lensProvider: lensProvider);

    controller = widget.cameraController;

    scrollController.addListener(() {
      if (scrollController.size == 1.0) {
        if (lensProvider.isShowRetakeButton.value != false) {
          lensProvider.isShowRetakeButton.value = false;
          // lensProvider.isShowRetakeButton.notifyListeners();
        }
      } else {
        if (lensProvider.isShowRetakeButton.value != true) {
          lensProvider.isShowRetakeButton.value = true;
          // lensProvider.isShowRetakeButton.notifyListeners();
        }
      }
      MyPrint.printOnConsole("isShowRetakeButton ${lensProvider.isShowRetakeButton.value}");
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    MyPrint.printOnConsole("ImageFeatureScreen build called");

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LensProvider>.value(value: lensProvider),
      ],
      child: Consumer<LensProvider>(
        builder: (BuildContext context, LensProvider lensProvider, Widget? child) {
          return ModalProgressHUD(
            inAsyncCall: isLoading || lensProvider.isLoadingContents.get(),
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
                  child: LensScreenCaptureControlWidget(
                    isTakingPicture: cameraValue.isTakingPicture,
                    onClickImage: cameraValue.isInitialized && !cameraValue.isRecordingVideo && !cameraValue.isTakingPicture ? onTakePictureButtonPressed : null,
                  ),
                ),
                LensScreenFlashCloseButton(
                  isFlashOn: cameraValue.flashMode == FlashMode.torch,
                  onFlashTap: () {
                    onSetFlashModeButtonPressed(context: context, mode: cameraValue.flashMode == FlashMode.torch ? FlashMode.off : FlashMode.torch);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget getImagePickedWidget() {
    return Stack(
      children: [
        getClickedImageWidget(),
        Align(
          alignment: Alignment.bottomRight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              getReloadButton(),
              Flexible(
                child: LensCoursesBottomsheetWidget(
                  contents: lensProvider.contentsList.getList(isNewInstance: false),
                  isLoadingContents: lensProvider.isLoadingContents.get(),
                  scrollController: scrollController,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getClickedImageWidget() {
    return (kIsWeb
        ? Image.network(imageFile!.path)
        : Image.file(
            File(imageFile!.path),
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
          ));
  }

  Widget getReloadButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: lensProvider.isShowRetakeButton,
      builder: (BuildContext context, bool isShowRetakeButton, Widget? child) {
        if (!isShowRetakeButton) return const SizedBox();

        return InkWell(
          onTap: () async {
            MyPrint.printOnConsole("Called");
            imageFile = null;
            mySetState();
            lensProvider.resetContentsData(isNotify: false);
            await controller.resumePreview();
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
      },
    );
  }
}
