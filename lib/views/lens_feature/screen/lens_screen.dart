import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/lens_feature/lens_provider.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/views/lens_feature/component/bottomButton.dart';
import 'package:flutter_instancy_2/views/lens_feature/screen/lens_image_search_screen.dart';
import 'package:flutter_instancy_2/views/lens_feature/screen/lens_ocr_screen.dart';
import 'package:flutter_instancy_2/views/lens_feature/screen/surface_tracking/surface_tracking_screen.dart';

import '../../../backend/navigation/navigation_arguments.dart';
import '../../../utils/my_safe_state.dart';
import '../../common/components/common_loader.dart';

class LensScreen extends StatefulWidget {
  static const String routeName = "/LensScreen";

  final LensScreenNavigationArguments arguments;

  const LensScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<LensScreen> createState() => _LensScreenState();
}

class _LensScreenState extends State<LensScreen> with WidgetsBindingObserver, TickerProviderStateMixin, MySafeState {
  int componentId = -1;
  int componentInsId = -1;

  late CameraController cameraController;
  late Future futureData;

  int selectedWidgetIndex = 0;

  LensProvider imageSearchScreenLensProvider = LensProvider();
  LensProvider surfaceTrackingScreenLensProvider = LensProvider();
  LensProvider ocrScreenLensProvider = LensProvider();

  Future<void> getFuture() async {
    List<CameraDescription> cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.max);
    await cameraController.initialize();
    mySetState();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    componentId = widget.arguments.componentId;
    componentInsId = widget.arguments.componentInsId;

    imageSearchScreenLensProvider
      ..componentId.set(value: componentId, isNotify: false)
      ..componentInstanceId.set(value: componentInsId, isNotify: false)
      ..pageSize.set(value: 100, isNotify: false);
    surfaceTrackingScreenLensProvider
      ..componentId.set(value: componentId, isNotify: false)
      ..componentInstanceId.set(value: componentInsId, isNotify: false)
      ..selectedContentTypes.setList(
        list: [
          ContentTypeCategoryId.image,
          ContentTypeCategoryId.video,
          ContentTypeCategoryId.arModule,
          ContentTypeCategoryId.vrModule,
          ContentTypeCategoryId.arObject,
        ],
        isClear: true,
        isNotify: false,
      );
    ocrScreenLensProvider
      ..componentId.set(value: componentId, isNotify: false)
      ..componentInstanceId.set(value: componentInsId, isNotify: false)
      ..pageSize.set(value: 100, isNotify: false);

    futureData = getFuture();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      bottomNavigationBar: bottomBar(),
      body: FutureBuilder(
        future: futureData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const CommonLoader();
          }

          if (!cameraController.value.isInitialized) {
            return const CommonLoader();
          }

          return getWidgetBasedOnIndex(selectedWidgetIndex);
        },
      ),
    );
  }

  Widget bottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: Colors.black87,
      height: kToolbarHeight,
      child: Row(
        children: [
          Expanded(
            child: BottomButton(
              text: "Image Search",
              isSelected: selectedWidgetIndex == 0,
              onTap: () {
                selectedWidgetIndex = 0;
                cameraController.resumePreview();
                mySetState();
              },
            ),
          ),
          Expanded(
            child: BottomButton(
              text: "Surface Tracking",
              isSelected: selectedWidgetIndex == 1,
              onTap: () {
                selectedWidgetIndex = 1;
                cameraController.resumePreview();

                mySetState();
              },
            ),
          ),
          Expanded(
            child: BottomButton(
              text: "OCR",
              isSelected: selectedWidgetIndex == 2,
              onTap: () {
                selectedWidgetIndex = 2;
                cameraController.resumePreview();
                mySetState();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget getWidgetBasedOnIndex(int index) {
    switch (index) {
      case 0:
        return LensImageSearchScreen(
          cameraController: cameraController,
          lensProvider: imageSearchScreenLensProvider,
        );
      case 1:
        return SurfaceTrackingScreen(
          cameraController: cameraController,
          lensProvider: surfaceTrackingScreenLensProvider,
        );
      case 2:
        return LensOcrScreen(
          cameraController: cameraController,
          lensProvider: ocrScreenLensProvider,
        );
      default:
        return const SizedBox();
    }
  }
}
