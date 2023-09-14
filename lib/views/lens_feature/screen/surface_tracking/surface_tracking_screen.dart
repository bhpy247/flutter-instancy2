import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/authentication/authentication_provider.dart';
import 'package:flutter_instancy_2/backend/course_launch/course_launch_controller.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/ar_vr_module/data_model/ar_scene_meshobject_model.dart';
import 'package:flutter_instancy_2/models/ar_vr_module/data_model/ar_scene_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;

import '../../../../backend/app/app_provider.dart';
import '../../../../backend/lens_feature/lens_controller.dart';
import '../../../../backend/lens_feature/lens_provider.dart';
import '../../../../backend/navigation/navigation.dart';
import '../../../../backend/navigation/navigation_response.dart';
import '../../../../models/ar_vr_module/response_model/ar_content_model.dart';
import '../../../../models/common/data_response_model.dart';
import '../../../../models/course/data_model/CourseDTOModel.dart';
import '../../../../utils/my_print.dart';
import '../../../../utils/my_safe_state.dart';
import '../../../common/components/modal_progress_hud.dart';
import '../../component/surface_tracking_keyword_search_screen.dart';
import 'surface_tracking_screen_android.dart';
import 'surface_tracking_screen_ios.dart';

class SurfaceTrackingScreen extends StatefulWidget {
  final LensProvider? lensProvider;
  final int componentId;
  final int componentInsId;

  const SurfaceTrackingScreen({
    super.key,
    required this.lensProvider,
    required this.componentId,
    required this.componentInsId,
  });

  @override
  State<SurfaceTrackingScreen> createState() => _SurfaceTrackingScreenState();
}

class _SurfaceTrackingScreenState extends State<SurfaceTrackingScreen> with WidgetsBindingObserver, TickerProviderStateMixin, MySafeState {
  bool isLoading = false;

  int componentId = -1;
  int componentInstanceId = -1;

  late AppProvider appProvider;
  late AuthenticationProvider authenticationProvider;

  late LensProvider lensProvider;
  late LensController lensController;

  GlobalKey<SurfaceTrackingScreenAndroidState> surfaceTrackingScreenAndroidKey = GlobalKey<SurfaceTrackingScreenAndroidState>();

  ARContentModel? arContentModel;

  DraggableScrollableController scrollController = DraggableScrollableController();

  List<bool> isSelected = [true, false];

  /*Future<void> onSetFlashModeButtonPressed({required BuildContext context, required FlashMode mode}) async {
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
  }*/

  Future<void> navigateToSurfaceTrackingKeywordScreenAndGetARContent() async {
    dynamic value = await NavigationController.navigateToSurfaceTrackingKeywordSearchScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      arguments: SurfaceTrackingKeywordSearchScreenNavigationArguments(
        lensProvider: lensProvider,
        componentId: componentId,
        componentInsId: componentInstanceId,
      ),
    );
    MyPrint.printOnConsole("value:$value");

    if (value is! SurfaceTrackingKeywordSearchScreenNavigationResponse) {
      return;
    }

    SurfaceTrackingKeywordSearchScreenNavigationResponse response = value;

    CourseDTOModel courseModel = response.courseModel;
    String arVrContentLaunchTypes = response.arVrContentLaunchTypes;

    MyPrint.printOnConsole("Selected Content Id:${courseModel.ContentID}");
    MyPrint.printOnConsole("Selected Content Name:${courseModel.ContentName}");
    MyPrint.printOnConsole("arVrContentLaunchTypes:$arVrContentLaunchTypes");

    //Launch Content
    CourseLaunchController courseLaunchController = CourseLaunchController(
      apiController: lensController.lensRepository.apiController,
      apiDataProvider: lensController.lensRepository.apiController.apiDataProvider,
      appProvider: appProvider,
      authenticationProvider: authenticationProvider,
      componentId: -1,
      componentInstanceId: -1,
    );

    if (context.checkMounted() && context.mounted) {
      String courseLaunchUrl = await courseLaunchController.getARContentUrl(
        context: context,
        courseModel: courseModel,
      );

      MyPrint.printOnConsole("courseLaunchUrl:'$courseLaunchUrl'");

      if ([InstancyObjectTypes.arModule, InstancyObjectTypes.vrModule].contains(courseModel.ContentTypeId)) {
        DataResponseModel<ARContentModel> responseModel = await CourseLaunchController.getARContentModelFromUrl(contentUrl: courseLaunchUrl);
        MyPrint.printOnConsole("responseModel:${responseModel.data}");

        arContentModel = responseModel.data;
        mySetState();

        surfaceTrackingScreenAndroidKey.currentState?.initializeARViewFromARContentModel(arContentModel: arContentModel);
      } else if ([InstancyMediaTypes.threeDAvatar, InstancyMediaTypes.threeDObject].contains(courseModel.MediaTypeID)) {
        String meshType = "";
        if (courseLaunchUrl.toLowerCase().contains(".glb")) {
          meshType = ARContentMeshTypes.glb;
        } else if (courseLaunchUrl.toLowerCase().contains(".gltf")) {
          meshType = ARContentMeshTypes.gltf;
        }
        MyPrint.printOnConsole("meshType:$meshType");

        if (meshType.isNotEmpty) {
          int sceneId = DateTime.now().millisecondsSinceEpoch;

          arContentModel = ARContentModel(
            scenes: [
              ARSceneModel(
                id: sceneId,
                sceneType: ARContentSceneTypes.groundTracking,
                meshObjects: [
                  ARSceneMeshObjectModel(
                    id: sceneId + 1,
                    meshType: meshType,
                    position: vector_math.Vector3(0, 0, -2),
                    mediaUrl: courseLaunchUrl,
                    mediaName: courseModel.ContentName,
                    name: courseModel.ContentName,
                    sceneId: sceneId,
                    isLock: false,
                  ),
                ],
              ),
            ],
          );
          mySetState();

          surfaceTrackingScreenAndroidKey.currentState?.initializeARViewFromARContentModel(arContentModel: arContentModel);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();

    componentId = widget.componentId;
    componentInstanceId = widget.componentInsId;

    appProvider = context.read<AppProvider>();
    authenticationProvider = context.read<AuthenticationProvider>();

    lensProvider = widget.lensProvider ?? LensProvider();
    lensController = LensController(lensProvider: lensProvider);

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
      child: ModalProgressHUD(
        inAsyncCall: isLoading || lensProvider.isLoadingContents.get(),
        child: getMainBody(),
      ),
    );
  }

  Widget getMainBody() {
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        return Stack(
          children: [
            SurfaceTrackingScreenAndroid(
              key: surfaceTrackingScreenAndroidKey,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: getToggleButton(),
            ),
            // getContentList(),
          ],
        );
      } else if (Platform.isIOS) {
        return const SurfaceTrackingScreenIOS();
      }
    }

    return Center(
      child: Text(
        "Not Implemented",
        style: themeData.textTheme.labelMedium,
      ),
    );
  }

  Widget getToggleButton() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
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
        componentId: componentId,
        componentInsId: componentInstanceId,
      ),
    );
  }
}
