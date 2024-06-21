import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/extensions.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_controller.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_provider.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/co_create_content_authoring_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/video/data_model/video_content_model.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/views/co_create_learning/component/common_save_exit_button_row.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:flutter_instancy_2/views/common/components/modal_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../backend/app_theme/style.dart';
import '../../../backend/configurations/app_configuration_operations.dart';
import '../../../backend/navigation/navigation_arguments.dart';
import '../../../backend/navigation/navigation_controller.dart';
import '../../../backend/navigation/navigation_operation_parameters.dart';
import '../../../backend/navigation/navigation_type.dart';
import '../../../configs/app_configurations.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_safe_state.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/app_ui_components.dart';

class RecordVideoScreen extends StatefulWidget {
  static const String routeName = "/recordVideoScreen";
  final AddEditVideoScreenNavigationArgument arguments;

  const RecordVideoScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<RecordVideoScreen> createState() => _RecordVideoScreenState();
}

class _RecordVideoScreenState extends State<RecordVideoScreen> with MySafeState {
  bool isLoading = false;

  late CoCreateKnowledgeProvider coCreateKnowledgeProvider;
  late CoCreateKnowledgeController coCreateKnowledgeController;

  late CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  String fileName = "";
  Uint8List? fileBytes;

  CameraController? controller;
  XFile? videoFile;
  bool isRecordingStarted = false;
  VideoPlayerController? videoController;
  VoidCallback? videoPlayerListener;

  final double _minAvailableZoom = 1.0;
  final double _maxAvailableZoom = 1.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;
  final double _currentExposureOffset = 0.0;

  int _pointers = 0;

  void initializeData() {
    coCreateKnowledgeProvider = context.read<CoCreateKnowledgeProvider>();
    coCreateKnowledgeController = CoCreateKnowledgeController(coCreateKnowledgeProvider: coCreateKnowledgeProvider);

    coCreateContentAuthoringModel = widget.arguments.coCreateContentAuthoringModel;

    if (coCreateContentAuthoringModel.isEdit) {
      MyPrint.printOnConsole("coCreateContentAuthoringModel.courseDTOModel.ViewLink :${coCreateContentAuthoringModel.courseDTOModel!.ViewLink}");
      String videoUrl = AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(imagePath: coCreateContentAuthoringModel.courseDTOModel!.ViewLink);

      if (coCreateContentAuthoringModel.courseDTOModel != null) {
        videoController = VideoPlayerController.contentUri(Uri.parse(videoUrl));
        String docfileName = videoUrl.split("/").last;
        fileName = docfileName;
      }
    }
  }

  Future<void> openFileExplorer(
    FileType pickingType,
    bool multiPick,
  ) async {
    List<PlatformFile> paths = await MyUtils.pickFiles(
      pickingType: pickingType,
      multiPick: multiPick,
      getBytes: true,
    );

    if (paths.isEmpty) {
      return;
    }

    PlatformFile file = paths.first;
    if (!kIsWeb) {
      MyPrint.printOnConsole("File Path:${file.path}");
    }

    if (file.bytes.checkEmpty) {
      return;
    }

    String name = MyUtils.regenerateFileName(fileName: file.name) ?? "";

    if (name.isEmpty) {
      return;
    }

    fileName = name;
    fileBytes = file.bytes!;
    MyPrint.printOnConsole("Got file Name:$fileName");
    MyPrint.printOnConsole("Got file bytes:${fileBytes!.length}");

    mySetState();
  }

  Future<CourseDTOModel?> saveContent() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("RecordVideoScreen().saveFlashcard() called", tag: tag);

    isLoading = true;
    mySetState();
    if (videoFile != null) {
      fileBytes = await videoFile?.readAsBytes();
      fileName = videoFile?.name ?? "";
    }

    coCreateContentAuthoringModel.uploadedDocumentBytes = fileBytes;
    coCreateContentAuthoringModel.uploadedDocumentName = fileName;

    VideoContentModel videoContentModel = coCreateContentAuthoringModel.videoContentModel ??= VideoContentModel();
    videoContentModel.scriptText = "";

    String? contentId = await coCreateKnowledgeController.addEditContentItem(coCreateContentAuthoringModel: coCreateContentAuthoringModel);
    MyPrint.printOnConsole("contentId:'$contentId'", tag: tag);

    isLoading = false;
    mySetState();

    if (contentId.checkEmpty) {
      MyPrint.printOnConsole("Returning from AddEditEventScreen().saveEvent() because contentId is null or empty", tag: tag);
      MyToast.showError(context: context, msg: coCreateContentAuthoringModel.isEdit ? "Couldn't Update Content" : "Couldn't Create Content");
      return null;
    }

    CourseDTOModel? courseDTOModel = coCreateContentAuthoringModel.courseDTOModel ?? coCreateContentAuthoringModel.newCurrentCourseDTOModel;

    return courseDTOModel;
  }

  Future<void> onSaveAndExitTap() async {
    CourseDTOModel? courseDTOModel = await saveContent();

    if (courseDTOModel == null) {
      return;
    }

    Navigator.pop(context, true);
  }

  Future<void> onSaveAndViewTap() async {
    CourseDTOModel? courseDTOModel = await saveContent();

    if (courseDTOModel == null) {
      return;
    }

    VideoContentModel? videoContentModel = courseDTOModel.videoContentModel;

    await NavigationController.navigateToVideoWithTranscriptLaunchScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      argument: VideoWithTranscriptLaunchScreenNavigationArgument(
        title: courseDTOModel.ContentName,
        transcript: videoContentModel?.scriptText ?? "",
        videoBytes: courseDTOModel.uploadedDocumentBytes,
      ),
    );

    Navigator.pop(context, true);
  }

  void _showCameraException(CameraException e) {
    MyPrint.logOnConsole(e.code);
    MyPrint.logOnConsole(e.description ?? "");
    MyToast.showError(msg: 'Error: select a camera first.', context: context);
  }

  Future<XFile?> stopVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      XFile? file = await cameraController.stopVideoRecording();
      videoController = VideoPlayerController.file(File(file.path));
      mySetState();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (controller == null || _pointers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale).clamp(_minAvailableZoom, _maxAvailableZoom);

    await controller!.setZoomLevel(_currentScale);
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final CameraController cameraController = controller!;

    final Offset offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  Future<void> startVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      MyToast.showError(msg: 'Error: select a camera first.', context: context);
      return;
    }

    if (cameraController.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }

    try {
      await cameraController.startVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return;
    }
  }

  List<CameraDescription> _cameras = <CameraDescription>[];

  Future<void> getCamera() async {
    try {
      _cameras = await availableCameras();
    } on CameraException catch (e) {
      MyPrint.printOnConsole(e.code);
      MyPrint.printOnConsole(e.description ?? "");
    }
  }

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _initializeCameraController(CameraDescription cameraDescription) async {
    final CameraController cameraController = CameraController(
      cameraDescription,
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      enableAudio: true,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        showInSnackBar('Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          showInSnackBar('You have denied camera access.');
        case 'CameraAccessDeniedWithoutPrompt':
          // iOS only
          showInSnackBar('Please go to Settings app to enable camera access.');
        case 'CameraAccessRestricted':
          // iOS only
          showInSnackBar('Camera access is restricted.');
        case 'AudioAccessDenied':
          showInSnackBar('You have denied audio access.');
        case 'AudioAccessDeniedWithoutPrompt':
          // iOS only
          showInSnackBar('Please go to Settings app to enable audio access.');
        case 'AudioAccessRestricted':
          // iOS only
          showInSnackBar('Audio access is restricted.');
        default:
          _showCameraException(e);
          break;
      }
    }

    MyPrint.printOnConsole("cameraController.value.isInitialized : ${cameraController.value.isInitialized}");
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _playRecordedVideo(File recordedFile) async {
    videoController?.dispose();
    videoController = VideoPlayerController.file(recordedFile);
    await videoController!.initialize();
    await videoController!.play();
    setState(() {});
  }

  Future<void> _initCamera() async {
    // Request camera permissions
    final cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);

    await controller!.initialize();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initCamera();
    initializeData();
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return PopScope(
      canPop: !isLoading,
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          appBar: AppConfigurations().commonAppBar(
            title: widget.arguments.isUploadScreen ? "Upload Video" : "Record Video",
          ),
          body: AppUIComponents.getBackGroundBordersRounded(
            context: context,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  widget.arguments.isUploadScreen ? getUploadVideoScreen() : getRecordVideoWidget(),
                  const Spacer(),
                  CommonSaveExitButtonRow(
                    onSaveAndExitPressed: () {
                      onSaveAndExitTap();
                    },
                    onSaveAndViewPressed: () {
                      onSaveAndViewTap();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getRecordVideoWidget() {
    MyPrint.printOnConsole("cameraController. isVideoRecording : ${controller?.value.isRecordingVideo}");
    if (videoController != null) {
      return _thumbnailWidget();
    }
    return InkWell(
      onTap: () async {
        await startVideoRecording();
        isRecordingStarted = true;
        mySetState();
      },
      child: isRecordingStarted
          ? _cameraPreviewWidget()
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  decoration: BoxDecoration(
                    border: Border.all(color: Styles.borderColor),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: themeData.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.videocam_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                        "Record Video...",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _cameraPreviewWidget() {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Listener(
        onPointerDown: (_) => _pointers++,
        onPointerUp: (_) => _pointers--,
        child: Column(
          children: [
            CameraPreview(
              controller!,
              child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onScaleStart: _handleScaleStart,
                  onScaleUpdate: _handleScaleUpdate,
                  onTapDown: (TapDownDetails details) => onViewFinderTap(details, constraints),
                );
              }),
            ),
            SizedBox(
              height: 10,
            ),
            CommonButton(
              onPressed: () async {
                videoFile = await stopVideoRecording();
                MyPrint.printOnConsole("videoFiles : ${videoFile?.path}");
                isRecordingStarted = false;
                mySetState();
              },
              text: "Stop Recording",
              fontColor: themeData.colorScheme.onPrimary,
            )
          ],
        ),
      );
    }
  }

  Widget _thumbnailWidget() {
    final VideoPlayerController? localVideoController = videoController;
    MyPrint.printOnConsole("localVideoController${localVideoController?.dataSource}");
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (localVideoController == null)
                Container()
              else
                Expanded(
                  child: SizedBox(
                    // width: 64.0,
                    // height: 300.0,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: localVideoController.value.aspectRatio,
                          child: VideoPlayer(
                            localVideoController,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: CommonButton(
                  onPressed: () {
                    videoController = null;
                    mySetState();
                  },
                  text: "Retake",
                  fontColor: themeData.colorScheme.onPrimary,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: CommonButton(
                  onPressed: () {
                    _playRecordedVideo(File(videoFile?.path ?? ""));
                  },
                  text: "Play",
                  fontColor: themeData.colorScheme.onPrimary,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: CommonButton(
                  onPressed: () async {
                    await videoController!.pause();
                    mySetState();
                  },
                  text: "Stop",
                  fontColor: themeData.colorScheme.onPrimary,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget getUploadVideoScreen() {
    if (fileName.checkNotEmpty) {
      return Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 60),
            decoration: BoxDecoration(
              border: Border.all(color: Styles.borderColor),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: themeData.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    FontAwesomeIcons.arrowUpFromBracket,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  fileName,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonButton(
                onPressed: () {
                  fileName = "";
                  fileBytes = null;
                  mySetState();
                },
                text: "Clear",
                backGroundColor: Colors.transparent,
              ),
              const SizedBox(width: 20),
              CommonButton(
                onPressed: () async {
                  await openFileExplorer(FileType.video, false);
                },
                text: "ReTake",
                backGroundColor: Colors.transparent,
              ),
            ],
          )
        ],
      );
    }
    return InkWell(
      onTap: () async {
        await openFileExplorer(FileType.video, false);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 60),
        decoration: BoxDecoration(
          border: Border.all(color: Styles.borderColor),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: themeData.primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                FontAwesomeIcons.arrowUpFromBracket,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Browse File...",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoRecorder extends StatefulWidget {
  @override
  _VideoRecorderState createState() => _VideoRecorderState();
}

class _VideoRecorderState extends State<VideoRecorder> {
  CameraController? controller;
  VideoPlayerController? videoPlayerController;
  bool _isRecording = false;
  final _recorderDuration = Stopwatch();
  Directory? _tempDir;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    // Request camera permissions
    final cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    await controller!.initialize();
    _tempDir = await getTemporaryDirectory();
    setState(() {});
  }

  void _startRecording() async {
    if (!_isRecording) {
      final filePath = '${_tempDir!.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';
      await controller!.startVideoRecording();
      _isRecording = true;
      _recorderDuration.start();
      setState(() {});
    }
  }

  void _stopRecording() async {
    if (_isRecording) {
      await controller!.stopVideoRecording();
      _isRecording = false;
      _recorderDuration.stop();
      _recorderDuration.reset();
      XFile? fille = await controller!.stopVideoRecording();
      final recordedFile = File(fille.path);
      _playRecordedVideo(recordedFile);
      setState(() {});
    }
  }

  Future<void> _playRecordedVideo(File recordedFile) async {
    videoPlayerController?.dispose();
    videoPlayerController = VideoPlayerController.file(recordedFile);
    await videoPlayerController!.initialize();
    await videoPlayerController!.play();
    setState(() {});
  }

  @override
  void dispose() {
    controller?.dispose();
    videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (controller!.value.isInitialized) controller!.value.isRecordingVideo ? Container(color: Colors.white70) : CameraPreview(controller!),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: FloatingActionButton(
              onPressed: _isRecording ? _stopRecording : _startRecording,
              child: Icon(_isRecording ? Icons.stop : Icons.record_voice_over),
            ),
          ),
          if (_isRecording)
            Positioned(
              top: 20.0,
              left: 20.0,
              child: Text(
                _recorderDuration.elapsed.toString().substring(0, 2) + ':' + _recorderDuration.elapsed.toString().substring(3, 5),
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
            ),
          if (videoPlayerController?.value.isInitialized ?? false)
            AspectRatio(
              aspectRatio: videoPlayerController!.value.aspectRatio,
              child: VideoPlayer(videoPlayerController!),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: videoPlayerController?.value.isPlaying ?? false ? () => videoPlayerController!.pause() : null,
        child: Icon(
          videoPlayerController?.value.isPlaying ?? false ? Icons.pause : null,
        ),
      ),
    );
  }
}
