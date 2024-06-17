import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/extensions.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_controller.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_provider.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/co_create_content_authoring_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/video/data_model/video_content_model.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/views/co_create_learning/component/common_save_exit_button_row.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:flutter_instancy_2/views/common/components/modal_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../backend/app_theme/style.dart';
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

  void initializeData() {
    coCreateKnowledgeProvider = context.read<CoCreateKnowledgeProvider>();
    coCreateKnowledgeController = CoCreateKnowledgeController(coCreateKnowledgeProvider: coCreateKnowledgeProvider);

    coCreateContentAuthoringModel = widget.arguments.coCreateContentAuthoringModel;
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

    fileBytes = file.bytes!;

    fileName = MyUtils.regenerateFileName(fileName: file.name) ?? "";

    if (fileName.isEmpty) {
      return;
    }

    MyPrint.printOnConsole("Got file Name:$fileName");
    MyPrint.printOnConsole("Got file bytes:${fileBytes!.length}");

    mySetState();
  }

  Future<CourseDTOModel?> saveContent() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("RecordVideoScreen().saveFlashcard() called", tag: tag);

    isLoading = true;
    mySetState();

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

  @override
  void initState() {
    super.initState();

    initializeData();
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
    return Container(
      width: double.infinity,
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
