import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/Catalog/catalog_controller.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:provider/provider.dart';

import '../../../api/api_url_configuration_provider.dart';
import '../../../backend/app/app_provider.dart';
import '../../../backend/authentication/authentication_provider.dart';
import '../../../backend/course_launch/course_launch_controller.dart';
import '../../../backend/event/event_controller.dart';
import '../../../backend/lens_feature/lens_controller.dart';
import '../../../backend/lens_feature/lens_provider.dart';
import '../../../backend/navigation/navigation.dart';
import '../../../backend/share/share_provider.dart';
import '../../../backend/ui_actions/catalog/catalog_ui_action_callback_model.dart';
import '../../../backend/ui_actions/catalog/catalog_ui_actions_controller.dart';
import '../../../backend/ui_actions/primary_secondary_actions/primary_secondary_actions_constants.dart';
import '../../../configs/app_constants.dart';
import '../../../models/app_configuration_models/data_models/local_str.dart';
import '../../../models/catalog/request_model/add_content_to_my_learning_request_model.dart';
import '../../../models/catalog/response_model/removeFromWishlistModel.dart';
import '../../../models/course/data_model/CourseDTOModel.dart';
import '../../../models/course_launch/data_model/course_launch_model.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_safe_state.dart';
import '../../../utils/my_toast.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';
import '../../common/components/comment_dialog.dart';
import '../../common/components/common_loader.dart';
import '../../common/components/instancy_ui_actions/instancy_ui_actions.dart';
import '../../common/components/modal_progress_hud.dart';
import '../component/lens_courses_bottomsheet_widget.dart';
import '../component/lens_screen_capture_control_widget.dart';
import '../component/lens_screen_content_card.dart';
import '../component/lens_screen_flash_button.dart';

class LensOcrScreen extends StatefulWidget {
  final LensProvider? lensProvider;
  final int componentId;
  final int componentInsId;

  const LensOcrScreen({
    super.key,
    required this.lensProvider,
    required this.componentId,
    required this.componentInsId,
  });

  @override
  State<LensOcrScreen> createState() => _LensOcrScreenState();
}

class _LensOcrScreenState extends State<LensOcrScreen> with WidgetsBindingObserver, TickerProviderStateMixin, MySafeState {
  bool isLoading = false;

  int componentId = -1;
  int componentInstanceId = -1;

  late AppProvider appProvider;
  late LensProvider lensProvider;
  late LensController lensController;
  late CatalogController catalogController;

  late Future<bool> initializeCameraFuture;

  late CameraController controller;

  XFile? imageFile;

  DraggableScrollableController scrollController = DraggableScrollableController();

  Future<bool> initializeCamera() async {
    try {
      List<CameraDescription> cameras = await availableCameras();
      controller = CameraController(cameras[0], ResolutionPreset.max);
      await controller.initialize();
      return true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in LensOcrScreen().initializeCamera():$e");
      MyPrint.printOnConsole(s);
      return false;
    }
  }

  Future<void> onTakePictureButtonPressed() async {
    XFile? file = await takePicture();

    if (file == null) {
      return;
    }

    controller.setFlashMode(FlashMode.off);
    controller.pausePreview();

    imageFile = file;
    isLoading = true;
    mySetState();

    await lensController.performOCRSearch(filePath: file.path, isNotify: true);

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

  CatalogUIActionCallbackModel getCatalogUIActionCallbackModel({
    required CourseDTOModel model,
    InstancyContentActionsEnum? primaryAction,
    bool isSecondaryAction = true,
  }) {
    bool isArContent = AppConfigurationOperations.isARContent(contentTypeId: model.ContentTypeId, mediaTypeId: model.MediaTypeID);
    // MyPrint.printOnConsole("isArContent:$isArContent");

    return CatalogUIActionCallbackModel(
      onViewTap: isArContent || primaryAction == InstancyContentActionsEnum.View
          ? null
          : () async {
              MyPrint.printOnConsole("on view tap");
              if (isSecondaryAction) Navigator.pop(context);
              onContentLaunchTap(model: model);
              if (model.ViewType == ViewTypesForContent.ViewAndAddToMyLearning && !ParsingHelper.parseBoolMethod(model.isContentEnrolled)) {
                addContentToMyLearning(model: model, isShowToast: false);
              }
            },
      onAddToMyLearningTap: primaryAction == InstancyContentActionsEnum.AddToMyLearning
          ? null
          : () async {
              if (isSecondaryAction) Navigator.pop(context);
              addContentToMyLearning(model: model);
            },
      onBuyTap: primaryAction == InstancyContentActionsEnum.Buy
          ? null
          : () async {
              if (isSecondaryAction) Navigator.pop(context);

              isLoading = true;
              mySetState();

              bool isBuySuccess = await catalogController.buyCourse(
                context: context,
                model: model,
                ComponentID: componentId,
                ComponentInsID: componentInstanceId,
                isWaitForPostPurchaseProcesses: true,
              );

              isLoading = false;
              mySetState();

              if (isBuySuccess) {
                model.AddLink = "";
                model.BuyNowLink = "";
                model.ViewLink = "Y";
                model.isContentEnrolled = "true";
              }
            },
      onEnrollTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        addContentToMyLearning(model: model);
      },
      onDetailsTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        await onDetailsTap(model: model);
      },
      onIAmInterestedTap: () async {
        if (isSecondaryAction) Navigator.pop(context);
        isLoading = true;
        mySetState();
        await onIAmInterestedTap(model.ContentID);
        isLoading = false;
        mySetState();
      },
      onContactTap: () async {
        if (model.startpage.isNotEmpty) {
          MyUtils.launchUrl(url: MyUtils.getSecureUrl(model.startpage));
        }
      },
      onAddToWishlist: () async {
        if (isSecondaryAction) Navigator.pop(context);

        isLoading = true;
        mySetState();
        bool isSuccess = await catalogController.addContentToWishlist(
          contentId: model.ContentID,
          componentId: componentId,
          componentInstanceId: componentInstanceId,
        );
        MyPrint.printOnConsole("isSuccess: $isSuccess");
        isLoading = false;
        mySetState();

        if (isSuccess) {
          model.AddtoWishList = "";
          model.RemoveFromWishList = "Y";
        }

        if (pageMounted && context.mounted) {
          if (isSuccess) {
            MyToast.showSuccess(context: context, msg: appProvider.localStr.catalogAlertsubtitleItemaddedtowishlistsuccesfully);
          } else {
            MyToast.showError(context: context, msg: 'Failed');
          }
        }
      },
      onRemoveWishlist: () async {
        if (isSecondaryAction) Navigator.pop(context);
        isLoading = true;
        mySetState();
        MyPrint.printOnConsole("Component instance id: $componentInstanceId");
        RemoveFromWishlistResponseModel removeFromWishlistResponseModel = await catalogController.removeContentFromWishlist(
          contentId: model.ContentID,
          componentId: componentId,
          componentInstanceId: componentInstanceId,
        );
        isLoading = false;
        mySetState();
        MyPrint.printOnConsole("valueeee: ${removeFromWishlistResponseModel.isSuccess}");
        if (removeFromWishlistResponseModel.isSuccess) {
          model.AddtoWishList = "Y";
          model.RemoveFromWishList = "";
        }

        if (pageMounted && context.mounted) {
          if (removeFromWishlistResponseModel.isSuccess) {
            MyToast.showSuccess(context: context, msg: appProvider.localStr.catalogAlertsubtitleItemremovedtowishlistsuccesfully);
          } else {
            MyToast.showError(context: context, msg: 'Failed');
          }
        }
      },
      onAddToWaitListTap: () async {
        if (isSecondaryAction) Navigator.pop(context);
        MyPrint.printOnConsole("Content id: ${model.ContentID}");
        // isLoading = true;
        // mySetState();
        // AddToWaitListResponseModel addToWaitListResponseModel = await catalogController.addContentToWaitList(
        //   contentId: model.ContentID,
        //   componentId: componentId,
        //   componentInstanceId: componentInstanceId,
        // );
        // MyPrint.printOnConsole("isSuccess: ${addToWaitListResponseModel.isSuccess}");
        // isLoading = false;
        // mySetState();
        //
        // if (addToWaitListResponseModel.isSuccess) {
        //   getCatalogContentsList(
        //     isRefresh: true,
        //     isGetFromCache: false,
        //     isNotify: true,
        //   );
        // }
        //
        // if (pageMounted && context.mounted) {
        //   if (addToWaitListResponseModel.isSuccess) {
        //     MyToast.showSuccess(context: context, msg: addToWaitListResponseModel.message);
        //   } else {
        //     MyToast.showError(context: context, msg: 'Failed');
        //   }
        // }
        //TODO: Implement onAddToWaitListTap
      },
      onCancelEnrollmentTap: () async {
        if (isSecondaryAction) Navigator.pop(context);

        isLoading = true;
        mySetState();

        bool isCancelled = await EventController(eventProvider: null).cancelEventEnrollment(
          context: context,
          eventId: model.ContentID,
          isBadCancellationEnabled: model.isBadCancellationEnabled == true,
        );
        MyPrint.printOnConsole("isCancelled:$isCancelled");

        isLoading = false;
        mySetState();

        if (isCancelled) {
          if (pageMounted && context.mounted) MyToast.showSuccess(context: context, msg: "Your enrollment for the course has been successfully canceled");
        }
      },
      onViewResources: () {
        if (isSecondaryAction) Navigator.pop(context);

        NavigationController.navigateToEventTrackScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: EventTrackScreenArguments(
            eventTrackTabType: model.ContentTypeId == InstancyObjectTypes.track ? EventTrackTabs.trackContents : EventTrackTabs.eventContents,
            objectTypeId: model.ContentTypeId,
            isRelatedContent: true,
            parentContentId: model.ContentID,
            componentId: componentId,
            scoId: model.ScoID,
            componentInstanceId: componentInstanceId,
            isContentEnrolled: model.isCourseEnrolled(),
          ),
        );
      },
      onRescheduleTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        //TODO: Implement onRescheduleTap
      },
      onReEnrollmentHistoryTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        //TODO: Implement onViewResources
      },
      onRecommendToTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        NavigationController.navigateToRecommendToScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: RecommendToScreenNavigationArguments(
            shareContentType: ShareContentType.catalogCourse,
            contentId: model.ContentID,
            contentName: model.Title,
            componentId: componentId,
          ),
        );
      },
      onShareWithConnectionTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        NavigationController.navigateToShareWithConnectionsScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: ShareWithConnectionsScreenNavigationArguments(
            shareContentType: ShareContentType.catalogCourse,
            contentId: model.ContentID,
            contentName: model.Title,
            shareProvider: context.read<ShareProvider>(),
            scoId: model.ScoID,
            objecttypeId: model.ContentTypeId,
          ),
        );
      },
      onShareWithPeopleTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        NavigationController.navigateToShareWithPeopleScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: ShareWithPeopleScreenNavigationArguments(
            shareContentType: ShareContentType.catalogCourse,
            contentId: model.ContentID,
            contentName: model.Title,
            scoId: model.ScoID,
            objecttypeId: model.ContentTypeId,
          ),
        );
      },
      onShareTap: () {
        if (isSecondaryAction) Navigator.pop(context);

        MyUtils.shareContent(content: model.Sharelink);
      },
      onDownloadTap: () {},
    );
  }

  Future<void> showMoreAction({
    required CourseDTOModel model,
    InstancyContentActionsEnum? primaryAction,
  }) async {
    LocalStr localStr = appProvider.localStr;

    CatalogUIActionsController catalogUIActionsController = CatalogUIActionsController(appProvider: appProvider);
    // MyPrint.printOnConsole("isWIshlishContent: ${model.isWishListContent}");
    List<InstancyUIActionModel> options = catalogUIActionsController
        .getCatalogScreenSecondaryActions(
          catalogCourseDTOModel: model,
          localStr: localStr,
          catalogUIActionCallbackModel: getCatalogUIActionCallbackModel(
            model: model,
            primaryAction: primaryAction,
          ),
          isWishlistMode: false,
        )
        .toList();

    if (options.isEmpty) {
      return;
    }

    InstancyUIActions().showAction(
      context: context,
      actions: options,
    );
  }

  Future<void> onIAmInterestedTap(String contentId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CommentDialog(
          contentId: contentId,
          catalogController: catalogController,
        );
      },
    );
  }

  Future<void> onDetailsTap({required CourseDTOModel model}) async {
    dynamic value = await NavigationController.navigateToCourseDetailScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      arguments: CourseDetailScreenNavigationArguments(
        contentId: model.ContentID,
        componentId: componentId,
        componentInstanceId: componentInstanceId,
        userId: model.SiteUserID,
        screenType: InstancyContentScreenType.Catalog,
      ),
    );
    MyPrint.printOnConsole("CourseDetailScreen return value:$value");

    if (value == true) {}
  }

  Future<void> addContentToMyLearning({required CourseDTOModel model, bool isShowToast = true}) async {
    if (model.AddLink == ContentAddLinkOperations.redirecttodetails) {
      onDetailsTap(model: model);
      return;
    }

    isLoading = true;
    mySetState();

    String contentId = model.ContentID;

    bool isSuccess = await catalogController.addContentToMyLearning(
      requestModel: AddContentToMyLearningRequestModel(
        SelectedContent: contentId,
        multiInstanceParentId: model.InstanceParentContentID,
        ERitems: "",
        HideAdd: "",
        AdditionalParams: "",
        TargetDate: "",
        MultiInstanceEventEnroll: "",
        ComponentID: componentId,
        ComponentInsID: componentInstanceId,
        objecttypeId: model.ContentTypeId,
        scoId: model.ScoID,
      ),
      context: context,
      onPrerequisiteDialogShowEnd: () {
        MyPrint.printOnConsole("onPrerequisiteDialogShowEnd called");

        isLoading = true;
        mySetState();
      },
      onPrerequisiteDialogShowStarted: () {
        MyPrint.printOnConsole("onPrerequisiteDialogShowStarted called");
        isLoading = false;
        mySetState();
      },
      hasPrerequisites: model.hasPrerequisiteContents(),
      isShowToast: isShowToast,
      isWaitForOtherProcesses: true,
    );
    MyPrint.printOnConsole("isSuccess $isSuccess");

    isLoading = false;
    mySetState();

    if (isSuccess) {
      model.AddLink = "";
      model.ViewLink = "Y";
      model.isContentEnrolled = "true";
    }
  }

  Future<void> onContentLaunchTap({required CourseDTOModel model, String arVrContentLaunchTypes = ARVRContentLaunchTypes.launchInAR}) async {
    ApiUrlConfigurationProvider apiUrlConfigurationProvider = catalogController.catalogRepository.apiController.apiDataProvider;

    isLoading = true;
    mySetState();

    bool isLaunched = await CourseLaunchController(
      appProvider: appProvider,
      authenticationProvider: context.read<AuthenticationProvider>(),
      componentId: componentId,
      componentInstanceId: componentInstanceId,
    ).viewCourse(
      context: context,
      model: CourseLaunchModel(
        ContentTypeId: model.ContentTypeId,
        MediaTypeId: model.MediaTypeID,
        ScoID: model.ScoID,
        SiteUserID: apiUrlConfigurationProvider.getCurrentUserId(),
        SiteId: apiUrlConfigurationProvider.getCurrentSiteId(),
        ContentID: model.ContentID,
        locale: apiUrlConfigurationProvider.getLocale(),
        ActivityId: model.ActivityId,
        ActualStatus: model.ActualStatus,
        ContentName: model.ContentName,
        FolderPath: model.FolderPath,
        JWVideoKey: model.JWVideoKey,
        jwstartpage: model.jwstartpage,
        startPage: model.startpage,
        arVrContentLaunchTypes: arVrContentLaunchTypes,
        bit5: model.bit5,
      ),
    );

    isLoading = false;
    mySetState();

    if (isLaunched) {}
  }

  @override
  void initState() {
    super.initState();

    componentId = widget.componentId;
    componentInstanceId = widget.componentInsId;

    appProvider = context.read<AppProvider>();
    lensProvider = widget.lensProvider ?? LensProvider();
    lensController = LensController(lensProvider: lensProvider);
    catalogController = CatalogController(provider: null);

    initializeCameraFuture = initializeCamera();

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
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    themeData = Theme.of(context);

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
              child: FutureBuilder(
                future: initializeCameraFuture,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const CommonLoader();
                  }

                  if (!controller.value.isInitialized) {
                    return const CommonLoader();
                  }

                  return imageFile == null ? getCameraView() : getImagePickedWidget();
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget getCameraView() {
    return SizedBox(
      height: double.maxFinite,
      child: InkWell(
        onTap: () {
          controller.setFocusPoint(null);
        },
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
      ),
    );
  }

  Widget getCaptureControlRowWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)),
            child: InkWell(
              onTap: controller.value.isInitialized && !controller.value.isRecordingVideo ? onTakePictureButtonPressed : null,
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

  Widget getImagePickedWidget() {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: const CommonLoader(),
      child: Stack(
        children: [
          getClickedImageWidget(),
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                getReloadButton(),
                if (!isLoading)
                  Flexible(
                    child: LensCoursesBottomsheetWidget(
                      contents: lensProvider.contentsList.getList(isNewInstance: false),
                      isLoadingContents: lensProvider.isLoadingContents.get(),
                      scrollController: scrollController,
                      contentBuilder: (CourseDTOModel model) {
                        return getContentCardWidget(model: model);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
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

        return Container(
          margin: const EdgeInsets.all(20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: InkWell(
              onTap: () async {
                MyPrint.printOnConsole("Called");
                imageFile = null;
                mySetState();
                lensProvider.resetContentsData(isNotify: false);
                await controller.resumePreview();
              },
              borderRadius: BorderRadius.circular(100),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white38,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white),
                ),
                child: Image.asset(
                  "assets/images/camera_retake.png",
                  height: 30,
                  width: 30,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getContentCardWidget({required CourseDTOModel model}) {
    LocalStr localStr = appProvider.localStr;

    CatalogUIActionsController catalogUIActionsController = CatalogUIActionsController(
      appProvider: appProvider,
    );

    List<InstancyUIActionModel> options = catalogUIActionsController
        .getCatalogScreenPrimaryActions(
          catalogCourseDTOModel: model,
          localStr: localStr,
          catalogUIActionCallbackModel: getCatalogUIActionCallbackModel(
            model: model,
            isSecondaryAction: false,
          ),
          isWishlistMode: false,
        )
        .toList();

    // MyPrint.printOnConsole("${model.Title} : options:$options");

    InstancyUIActionModel? primaryAction = options.firstOrNull;
    // MyPrint.printOnConsole("primaryAction in Page:$primaryAction");
    // MyPrint.printOnConsole("primaryAction in Page:${primaryAction?.actionsEnum}");
    InstancyContentActionsEnum? primaryActionEnum = primaryAction?.actionsEnum;

    return LensScreenContentCard(
      model: model,
      primaryAction: primaryAction,
      onMoreButtonTap: (CourseDTOModel model) {
        showMoreAction(model: model);
      },
      onLaunchARTap: (CourseDTOModel model) {
        onContentLaunchTap(model: model, arVrContentLaunchTypes: ARVRContentLaunchTypes.launchInAR);
      },
      onLaunchVRTap: (CourseDTOModel model) {
        onContentLaunchTap(model: model, arVrContentLaunchTypes: ARVRContentLaunchTypes.launchInVR);
      },
      onPrimaryActionTap: () async {
        MyPrint.printOnConsole("primaryAction:$primaryActionEnum");

        bool isArContent = AppConfigurationOperations.isARContent(contentTypeId: model.ContentTypeId, mediaTypeId: model.MediaTypeID);

        if (isArContent) {
          onContentLaunchTap(model: model, arVrContentLaunchTypes: ARVRContentLaunchTypes.launchInAR);
        } else {
          if (primaryAction?.onTap != null) {
            primaryAction!.onTap!();
          }
        }
      },
      isShowARVRLaunch: true,
    );
  }
}
