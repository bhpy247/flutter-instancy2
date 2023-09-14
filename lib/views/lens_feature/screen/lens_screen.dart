import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/lens_feature/lens_provider.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/views/lens_feature/component/bottomButton.dart';
import 'package:flutter_instancy_2/views/lens_feature/screen/lens_image_search_screen.dart';
import 'package:flutter_instancy_2/views/lens_feature/screen/lens_ocr_screen.dart';
import 'package:flutter_instancy_2/views/lens_feature/screen/surface_tracking/surface_tracking_screen.dart';

import '../../../backend/navigation/navigation_arguments.dart';
import '../../../utils/my_safe_state.dart';

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

  int selectedWidgetIndex = 0;

  LensProvider imageSearchScreenLensProvider = LensProvider();
  LensProvider surfaceTrackingScreenLensProvider = LensProvider();
  LensProvider ocrScreenLensProvider = LensProvider();

  void onTabChanged({required int index}) async {
    MyPrint.printOnConsole("onTabChanged called with index:$index");

    selectedWidgetIndex = index;
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
          ContentTypeCategoryId.threeDAvatar,
          ContentTypeCategoryId.threeDObject,
        ],
        isClear: true,
        isNotify: false,
      );
    ocrScreenLensProvider
      ..componentId.set(value: componentId, isNotify: false)
      ..componentInstanceId.set(value: componentInsId, isNotify: false)
      ..pageSize.set(value: 100, isNotify: false);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      bottomNavigationBar: bottomBar(),
      body: getWidgetBasedOnIndex(selectedWidgetIndex),
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
                onTabChanged(index: 0);
              },
            ),
          ),
          Expanded(
            child: BottomButton(
              text: "Surface Tracking",
              isSelected: selectedWidgetIndex == 1,
              onTap: () {
                onTabChanged(index: 1);
              },
            ),
          ),
          Expanded(
            child: BottomButton(
              text: "OCR",
              isSelected: selectedWidgetIndex == 2,
              onTap: () {
                onTabChanged(index: 2);
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
          lensProvider: imageSearchScreenLensProvider,
          componentId: componentId,
          componentInsId: componentInsId,
        );
      case 1:
        return SurfaceTrackingScreen(
          lensProvider: surfaceTrackingScreenLensProvider,
          componentId: componentId,
          componentInsId: componentInsId,
        );
      case 2:
        return LensOcrScreen(
          lensProvider: ocrScreenLensProvider,
          componentId: componentId,
          componentInsId: componentInsId,
        );
      default:
        return const SizedBox();
    }
  }
}
