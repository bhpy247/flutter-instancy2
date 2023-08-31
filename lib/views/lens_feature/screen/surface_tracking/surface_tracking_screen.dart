import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/views/lens_feature/component/surface_tracking_keyword_search_screen.dart';
import 'package:provider/provider.dart';

import '../../../../backend/lens_feature/lens_controller.dart';
import '../../../../backend/lens_feature/lens_provider.dart';
import '../../../../backend/navigation/navigation_response.dart';
import '../../../../models/course/data_model/mobile_lms_course_model.dart';
import '../../../../utils/my_print.dart';
import '../../../../utils/my_safe_state.dart';
import '../../../../utils/my_toast.dart';
import '../../../../utils/my_utils.dart';
import '../../../common/components/common_loader.dart';
import '../../../common/components/modal_progress_hud.dart';
import '../../component/lens_screen_capture_control_widget.dart';
import '../../component/lens_screen_flash_button.dart';

class SurfaceTrackingScreen extends StatefulWidget {
  final CameraController cameraController;
  final LensProvider? lensProvider;

  const SurfaceTrackingScreen({
    super.key,
    required this.cameraController,
    required this.lensProvider,
  });

  @override
  State<SurfaceTrackingScreen> createState() => _SurfaceTrackingScreenState();
}

class _SurfaceTrackingScreenState extends State<SurfaceTrackingScreen> with WidgetsBindingObserver, TickerProviderStateMixin, MySafeState {
  bool isLoading = false;

  late LensProvider lensProvider;
  late LensController lensController;

  late CameraController controller;

  XFile? imageFile;

  DraggableScrollableController scrollController = DraggableScrollableController();

  List<bool> isSelected = [false, false];

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
      if (context.mounted) MyToast.showSuccess(msg: 'Error: ${e.code}\n${e.description}', context: context);
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

  Future<void> navigateToSurfaceTrackingKeywordScreenAndGetARContent() async {
    dynamic value = await NavigationController.navigateToSurfaceTrackingKeywordSearchScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      arguments: SurfaceTrackingKeywordSearchScreenNavigationArguments(
        lensProvider: lensProvider,
      ),
    );
    MyPrint.printOnConsole("value:$value");

    if (value is! SurfaceTrackingKeywordSearchScreenNavigationResponse) {
      return;
    }

    SurfaceTrackingKeywordSearchScreenNavigationResponse response = value;

    MobileLmsCourseModel courseModel = response.courseModel;
    String arVrContentLaunchTypes = response.arVrContentLaunchTypes;

    MyPrint.printOnConsole("Selected Content Id:${courseModel.contentid}");
    MyPrint.printOnConsole("Selected Content Name:${courseModel.name}");
    MyPrint.printOnConsole("arVrContentLaunchTypes:$arVrContentLaunchTypes");
    //Launch Content
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
                Column(
                  children: [
                    LensScreenFlashCloseButton(
                      isFlashOn: cameraValue.flashMode == FlashMode.torch,
                      onFlashTap: () {
                        onSetFlashModeButtonPressed(
                          context: context,
                          mode: cameraValue.flashMode == FlashMode.torch ? FlashMode.off : FlashMode.torch,
                        );
                      },
                    ),
                    getToggleButton(),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget getImagePickedWidget() {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: const CommonLoader(),
      child: Stack(
        children: [
          _thumbnailWidget(),
          const SizedBox(),
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
        color: const Color(0xffceceb2),
        borderRadius: BorderRadius.circular(15),
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
              fillColor: const Color(0xffEDEDED),
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

                if (newIndex == 1) {
                  navigateToSurfaceTrackingKeywordScreenAndGetARContent();
                }
              },
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
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
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getContentList() {
    return SurfaceTrackingKeywordSearchScreen(
      arguments: SurfaceTrackingKeywordSearchScreenNavigationArguments(
        lensProvider: lensProvider,
      ),
    );
  }
}
