import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_controller.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/co_create_content_authoring_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/podcast/data_model/podcast_content_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/podcast/request_model/play_audio_for_text_request_model.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/views/co_create_learning/component/audio_players.dart';
import 'package:flutter_instancy_2/views/co_create_learning/component/common_save_exit_button_row.dart';
import 'package:flutter_instancy_2/views/co_create_learning/screens/podcast_episode_screen.dart';
import 'package:flutter_instancy_2/views/common/components/modal_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../backend/app_theme/style.dart';
import '../../../configs/app_configurations.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/common_button.dart';
import '../../common/components/common_loader.dart';
import '../component/audio_recorder.dart';

class CreatePodcastSourceSelectionScreen extends StatefulWidget {
  static const String routeName = "/CreatePodcastSourceSelectionScreen";
  final CreatePodcastSourceSelectionScreenNavigationArguments arguments;

  const CreatePodcastSourceSelectionScreen({super.key, required this.arguments});

  @override
  State<CreatePodcastSourceSelectionScreen> createState() => _CreatePodcastSourceSelectionScreenState();
}

class _CreatePodcastSourceSelectionScreenState extends State<CreatePodcastSourceSelectionScreen> with MySafeState {
  Future<void> onRecordAudioTap() async {
    dynamic value = await NavigationController.navigateToRecordAndUploadPodcastScreen(
      navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
      arguments: RecordAndUploadPodcastScreenNavigationArgument(
        coCreateContentAuthoringModel: widget.arguments.coCreateContentAuthoringModel,
        isFromRecordAudio: true,
      ),
    );

    if (value == true) {
      Navigator.pop(context, true);
    }
  }

  Future<void> onGenerateWithAITap() async {
    showGenerateWithAiDialog();
  }

  Future<void> showGenerateWithAiDialog() async {
    dynamic value = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Text(
                      "Generate with AI",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Icon(
                        FontAwesomeIcons.xmark,
                        size: 15,
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
                child: Row(
                  children: [
                    Expanded(
                      child: getCommonTextContainer(
                        text: "Upload a\nDocument",
                        fontSize: 12,
                        backgroundColor: Colors.grey[100],
                        onTap: () {
                          Navigator.pop(context, 1);
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: getCommonTextContainer(
                        text: "Text to\nAudio",
                        fontSize: 12,
                        backgroundColor: Colors.grey[100],
                        onTap: () {
                          Navigator.pop(context, 2);
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );

    if (value is! int || ![1, 2].contains(value)) {
      return;
    }

    if (value == 1) {
      dynamic value = await NavigationController.navigateToRecordAndUploadPodcastScreen(
        navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
        arguments: RecordAndUploadPodcastScreenNavigationArgument(
          coCreateContentAuthoringModel: widget.arguments.coCreateContentAuthoringModel,
          isFromRecordAudio: false,
        ),
      );

      if (value == true) {
        Navigator.pop(context, true);
      }
    } else {
      dynamic value = await NavigationController.navigateToTextToAudioScreen(
        navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
        argument: TextToAudioScreenNavigationArgument(
          coCreateContentAuthoringModel: widget.arguments.coCreateContentAuthoringModel,
        ),
      );

      if (value == true) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return Scaffold(
      appBar: AppConfigurations().commonAppBar(
        title: widget.arguments.coCreateContentAuthoringModel.isEdit ? "Edit Podcast Episode" : "Podcast Episode",
      ),
      body: AppUIComponents.getBackGroundBordersRounded(
        context: context,
        child: getMainBody(),
      ),
    );
  }

  Widget getMainBody() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          getCommonTextContainer(
            text: "Record Audio",
            onTap: () {
              onRecordAudioTap();
            },
          ),
          const SizedBox(height: 20),
          getCommonTextContainer(
            text: "Generate with AI",
            onTap: () {
              onGenerateWithAITap();
            },
          )
        ],
      ),
    );
  }

  Widget getCommonTextContainer({required String text, Function()? onTap, double fontSize = 16, Color? backgroundColor}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 50),
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.2),
              offset: const Offset(1, 3),
              blurRadius: 3,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class RecordAndUploadPodcastScreen extends StatefulWidget {
  static const String routeName = "/RecordAndUploadPodcastScreen";

  final RecordAndUploadPodcastScreenNavigationArgument argument;

  const RecordAndUploadPodcastScreen({super.key, required this.argument});

  @override
  State<RecordAndUploadPodcastScreen> createState() => _RecordAndUploadPodcastScreenState();
}

class _RecordAndUploadPodcastScreenState extends State<RecordAndUploadPodcastScreen> with MySafeState {
  bool showPlayer = false;

  String fileName = "";
  Uint8List? fileBytes;
  String? filePath;

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
    fileName = MyUtils.regenerateFileName(fileName: file.name) ?? "";

    if (fileName.isEmpty) {
      return;
    }

    filePath = file.path;
    fileBytes = file.bytes;

    MyPrint.printOnConsole("Got file Name:$fileName");
    MyPrint.printOnConsole("Got file bytes:${fileBytes?.length}");

    return;
  }

  Future<void> onAudioRecorded(String path, String? fileName, Uint8List? bytes) async {
    MyPrint.printOnConsole('Recorded file path: $path, fileName:$fileName, bytes length:${bytes?.length}');

    if (path.isEmpty || fileName.checkEmpty || bytes.checkEmpty) {
      MyToast.showError(context: context, msg: "Podcast couldn't recorded");
      return;
    }

    showPlayer = true;

    filePath = path;
    this.fileName = fileName ?? "";
    fileBytes = bytes;
    mySetState();
  }

  Future<void> onNextTap() async {
    if (fileName.checkEmpty || fileBytes.checkEmpty) {
      MyToast.showError(context: context, msg: "Podcast not found");
      return;
    }

    CoCreateContentAuthoringModel coCreateContentAuthoringModel = widget.argument.coCreateContentAuthoringModel;
    PodcastContentModel podcastContentModel = coCreateContentAuthoringModel.podcastContentModel ??= PodcastContentModel();

    podcastContentModel.filePath = filePath ?? "";
    podcastContentModel.fileName = fileName;
    podcastContentModel.fileBytes = fileBytes;

    dynamic value = await NavigationController.navigateToPodcastPreviewScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      argument: PodcastPreviewScreenNavigationArgument(
        coCreateContentAuthoringModel: coCreateContentAuthoringModel,
        isRetakeRequired: widget.argument.isFromRecordAudio,
      ),
    );

    if (value == true) {
      Navigator.pop(context, true);
      return;
    }
  }

  @override
  void initState() {
    showPlayer = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Scaffold(
      appBar: AppConfigurations().commonAppBar(
        title: widget.argument.isFromRecordAudio ? "Record Audio" : "Upload a Document",
      ),
      bottomNavigationBar: getBottomButton(),
      body: AppUIComponents.getBackGroundBordersRounded(
        context: context,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              !widget.argument.isFromRecordAudio ? getUploadPodcastScreen() : getRecordPodcastWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getBottomButton() {
    return CommonButton(
      minWidth: double.infinity,
      onPressed: () {
        onNextTap();
      },
      text: "Done",
      fontColor: themeData.colorScheme.onPrimary,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
    );
  }

  Widget getRecordPodcastWidget() {
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
          SizedBox(
            height: 100,
            child: getRecorder(),
          )
        ],
      ),
    );
  }

  Widget getUploadPodcastScreen() {
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
                const SizedBox(height: 16),
                Text(
                  fileName,
                  style: const TextStyle(fontSize: 16),
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
                  filePath = null;
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
                  await openFileExplorer(FileType.audio, false);
                },
                text: "Retake",
                backGroundColor: Colors.transparent,
              ),
            ],
          )
        ],
      );
    }
    return InkWell(
      onTap: () async {
        await openFileExplorer(FileType.audio, false);
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
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: themeData.primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                FontAwesomeIcons.arrowUpFromBracket,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Browse File...",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget getRecorder() {
    return showPlayer && filePath.checkNotEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: AppAudioPlayer(
              source: filePath!,
              onDelete: () {
                showPlayer = false;
                filePath = null;
                fileName = "";
                fileBytes = null;
                mySetState();
              },
            ),
          )
        : Recorder(
            onStop: onAudioRecorded,
          );
  }
}

class PodcastViewScreen extends StatefulWidget {
  static const String routeName = "/PodcastViewScreen";
  final PodcastPreviewScreenNavigationArgument arguments;

  const PodcastViewScreen({super.key, required this.arguments});

  @override
  State<PodcastViewScreen> createState() => _PodcastViewScreenState();
}

class _PodcastViewScreenState extends State<PodcastViewScreen> with MySafeState {
  bool isLoading = false;

  late AudioPlayer player = AudioPlayer();
  bool isTranscriptExpanded = true;

  late CoCreateKnowledgeProvider coCreateKnowledgeProvider;
  late CoCreateKnowledgeController coCreateKnowledgeController;
  String dummyText =
      "You can replace this text with any text you wish. You can either write in this text box or paste your own text here. Try different languages and voices. Change the speed and the pitch of the voice. You can even tweak the SSML (Speech Synthesis Markup Language)to control how the different sections of the text sound. Click on SSML above to give it a try! Enjoy using Text to Speech! ";
  late CoCreateContentAuthoringModel coCreateContentAuthoringModel;
  late Future future;

  Future<void> getGeneratedData() async {
    // isLoading = true;
    // mySetState();
    PlayAudioForTextRequestModel playerRequestModel = PlayAudioForTextRequestModel(
      voice: widget.arguments.coCreateContentAuthoringModel.podcastContentModel?.voiceName ?? "",
      voiceStyle: widget.arguments.coCreateContentAuthoringModel.podcastContentModel?.voiceTone ?? "",
      language: widget.arguments.coCreateContentAuthoringModel.podcastContentModel?.voiceLanguage ?? "",
      text: (widget.arguments.coCreateContentAuthoringModel.podcastContentModel?.promptText.checkEmpty ?? false)
          ? dummyText
          : widget.arguments.coCreateContentAuthoringModel.podcastContentModel?.promptText ?? "",
      isOptionsChanged: true,
      speekingPitch: 1,
      speekingSpeed: widget.arguments.coCreateContentAuthoringModel.podcastContentModel?.voiceSpeed.toInt() ?? 0,
      isPlay: true,
    );
    await coCreateKnowledgeController.getAudioGenerator(requestModel: playerRequestModel);
    MyPrint.printOnConsole("Audio url : ${coCreateKnowledgeProvider.audioUrlFromApi.get()}");
    String audioUrl = coCreateKnowledgeProvider.audioUrlFromApi.get();
    if (audioUrl.checkNotEmpty) {
      // Create the audio player.
      player = AudioPlayer();

      // Set the release mode to keep the source after playback has completed.
      player.setReleaseMode(ReleaseMode.stop);

      // Start the player as soon as the app is displayed.
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // await player.setSourceAsset("audio/audio.mp3");
        await player.setSourceUrl(audioUrl);
        await player.resume();
      });
    }
    // isLoading = false;
    // mySetState();
  }

  Future<void> initializeData() async {
    coCreateKnowledgeProvider = context.read<CoCreateKnowledgeProvider>();
    coCreateKnowledgeController = CoCreateKnowledgeController(coCreateKnowledgeProvider: coCreateKnowledgeProvider);

    coCreateContentAuthoringModel = widget.arguments.coCreateContentAuthoringModel;

    PodcastContentModel? podcastContentModel = coCreateContentAuthoringModel.podcastContentModel;
    if (podcastContentModel != null) {
      if (podcastContentModel.fileBytes != null) {
        await player.setSourceBytes(podcastContentModel.fileBytes!);
        await player.resume();
      } else if (podcastContentModel.audioUrl.isNotEmpty) {
        await player.setSourceUrl(podcastContentModel.audioUrl);
        await player.resume();
      }
    }
  }

  Future<CourseDTOModel?> savePodcast() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("GenerateWithAiFlashCardScreen().saveFlashcard() called", tag: tag);

    isLoading = true;
    mySetState();

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
    CourseDTOModel? courseDTOModel = await savePodcast();

    if (courseDTOModel == null) {
      MyToast.showError(context: context, msg: "Podcast couldn't be Saved");
      return;
    }

    Navigator.pop(context, true);
  }

  Future<void> onSaveAndExitAndViewTap() async {
    player.stop();

    CourseDTOModel? courseDTOModel = await savePodcast();

    if (courseDTOModel == null) {
      MyToast.showError(context: context, msg: "Podcast couldn't be Saved");
      return;
    }

    await NavigationController.navigateToPodcastEpisodeScreen(
      navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
    );

    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();
    initializeData();
    future = getGeneratedData();
  }

  @override
  void dispose() {
    // Release all sources and dispose the player.
    player.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return PopScope(
      canPop: !isLoading,
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          appBar: getAppBar(),
          bottomNavigationBar: getBottomButtonWidget(),
          body: AppUIComponents.getBackGroundBordersRounded(
            context: context,
            child: FutureBuilder(
                future: future,
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState == ConnectionState.done) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PlayerWidget(
                              player: player,
                              onRetakeTap: widget.arguments.isRetakeRequired
                                  ? () {
                                      Navigator.pop(context);
                                    }
                                  : null,
                            ),
                            InkWell(
                              onTap: () {
                                isTranscriptExpanded = !isTranscriptExpanded;
                                mySetState();
                              },
                              child: Row(
                                children: [
                                  Icon(isTranscriptExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down_outlined),
                                  const Text(
                                    "Transcript",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            if (isTranscriptExpanded)
                              const Text(
                                """
                                  Nigel:
                                  
                                  Glad to see things are going well and business is starting to pick up. Andrea told me about your outstanding numbers on Tuesday. Keep up the good work. Now to other business, I am going to suggest a payment schedule for the outstanding monies that is due. One, can you pay the balance of the license agreement as soon as possible? Two, I suggest we setup or you suggest, what you can pay on the back royalties, would you feel comfortable with paying every two weeks? Every month, I will like to catch up and maintain current royalties. So, if we can start the current royalties and maintain them every two weeks as all stores are required to do, I would appreciate it. Let me know if this works for you.
                                  
                                  Thanks.
                                   """,
                              )
                          ],
                        ),
                      ),
                    );
                  } else {
                    return CommonLoader();
                  }
                }),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget getAppBar() {
    return AppConfigurations().commonAppBar(
      title: "Refining Communication",
    );
  }

  Widget getBottomButtonWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
      child: CommonSaveExitButtonRow(
        onSaveAndExitPressed: onSaveAndExitTap,
        onSaveAndViewPressed: onSaveAndExitAndViewTap,
      ),
    );
  }
}
