import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/co_create_learning/component/audio_players.dart';
import 'package:flutter_instancy_2/views/co_create_learning/component/common_save_exit_button_row.dart';
import 'package:flutter_instancy_2/views/co_create_learning/screens/podcast_episode_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../backend/app_theme/style.dart';
import '../../../configs/app_configurations.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_utils.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/common_button.dart';
import '../../message/components/audio_player_widget.dart';
import '../component/audio_recorder.dart';

class CreatePodcastSourceSelectionScreen extends StatefulWidget {
  static const String routeName = "/CreatePodcastSourceSelectionScreen";
  final CreatePodcastSourceSelectionScreenNavigationArguments arguments;

  const CreatePodcastSourceSelectionScreen({super.key, required this.arguments});

  @override
  State<CreatePodcastSourceSelectionScreen> createState() => _CreatePodcastSourceSelectionScreenState();
}

class _CreatePodcastSourceSelectionScreenState extends State<CreatePodcastSourceSelectionScreen> with MySafeState {
  String fileName = "";
  Uint8List? fileBytes;
  TextEditingController websiteUrlController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<String> openFileExplorer(FileType pickingType, bool multiPick) async {
    String fileName = "";
    List<PlatformFile> paths = await MyUtils.pickFiles(
      pickingType: pickingType,
      multiPick: multiPick,
      getBytes: true,
    );

    if (paths.isNotEmpty) {
      PlatformFile file = paths.first;
      if (!kIsWeb) {
        MyPrint.printOnConsole("File Path:${file.path}");
      }
      fileName = file.name;

      // fileName = file.name.replaceAll('(', ' ').replaceAll(')', '');
      // fileName = fileName.trim();
      // fileName = Uuid().v1() + fileName.substring(fileName.indexOf("."));

      MyPrint.printOnConsole("Got file Name:${file.name}");
      MyPrint.printOnConsole("Got file bytes:${file.bytes?.length}");
      fileBytes = file.bytes;
    } else {
      fileName = "";
      fileBytes = null;
    }
    return fileName;
  }

  void showGenerateWithAiDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
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
                              Navigator.pop(context);
                              NavigationController.navigateToRecordAndUploadPodcastScreen(
                                navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
                                arguments: const RecordAndUploadPodcastScreenNavigationArgument(
                                  componentId: 0,
                                  componentInsId: 0,
                                  objectTypeId: 2,
                                  isFromRecordAudio: false,
                                ),
                              );
                            }),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: getCommonTextContainer(
                            text: "Text to\nAudio",
                            fontSize: 12,
                            backgroundColor: Colors.grey[100],
                            onTap: () {
                              Navigator.pop(context);

                              NavigationController.navigateToTextToAudioScreen(
                                  navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
                                  argument: const TextToAudioScreenNavigationArgument());
                            }),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Scaffold(
      appBar: AppConfigurations().commonAppBar(
        title: widget.arguments.isEdit ? "Edit Podcast Episode" : "Podcast Episode",
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
      child: Form(
        key: formKey,
        child: Column(
          children: [
            getCommonTextContainer(
                text: "Record Audio",
                onTap: () {
                  NavigationController.navigateToRecordAndUploadPodcastScreen(
                    navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
                    arguments: const RecordAndUploadPodcastScreenNavigationArgument(componentId: 0, componentInsId: 0, objectTypeId: 2, isFromRecordAudio: true),
                  );
                }),
            const SizedBox(
              height: 20,
            ),
            getCommonTextContainer(
              text: "Generate with AI",
              onTap: () {
                showGenerateWithAiDialog();
              },
            )
          ],
        ),
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
  String? audioPath;

  @override
  void initState() {
    showPlayer = false;
    super.initState();
  }

  Uint8List? fileBytes;

  String thumbNailName = "";
  Uint8List? thumbNailBytes;

  Future<String> openFileExplorer(
    FileType pickingType,
    bool multiPick,
  ) async {
    String fileName = "";
    List<PlatformFile> paths = await MyUtils.pickFiles(
      pickingType: pickingType,
      multiPick: multiPick,
      getBytes: true,
    );

    if (paths.isNotEmpty) {
      PlatformFile file = paths.first;
      if (!kIsWeb) {
        MyPrint.printOnConsole("File Path:${file.path}");
      }
      fileName = file.name;
      // fileName = file.name.replaceAll('(', ' ').replaceAll(')', '');
      // fileName = fileName.trim();
      // fileName = Uuid().v1() + fileName.substring(fileName.indexOf("."));

      MyPrint.printOnConsole("Got file Name:${file.name}");
      MyPrint.printOnConsole("Got file bytes:${file.bytes?.length}");
      fileBytes = file.bytes;
      thumbNailBytes = fileBytes;
    } else {
      fileName = "";
      fileBytes = null;
    }
    return fileName;
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Scaffold(
      appBar: AppConfigurations().commonAppBar(
        title: widget.argument.isFromRecordAudio ? "Record Audio" : "Upload a Document",
      ),
      body: AppUIComponents.getBackGroundBordersRounded(
        context: context,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              !widget.argument.isFromRecordAudio ? getUploadVideoScreen() : getRecordVideoWidget(),
              // Container(
              //     height: 200,
              //     child: getRecorder()),
              const Spacer(),

              CommonButton(
                minWidth: double.infinity,
                onPressed: () {
                  NavigationController.navigateToPodcastPreviewScreen(
                    navigationOperationParameters: NavigationOperationParameters(
                      context: context,
                      navigationType: NavigationType.pushNamed,
                    ),
                    argument: PodcastPreviewScreenNavigationArgument(
                      model: CourseDTOModel(),
                    ),
                  );
                },
                text: "Done",
                fontColor: themeData.colorScheme.onPrimary,
              )
            ],
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
          // Container(
          //   padding: const EdgeInsets.all(5),
          //   decoration: BoxDecoration(
          //     color: themeData.primaryColor,
          //     shape: BoxShape.circle,
          //   ),
          //   child: const Icon(
          //     Icons.mic,
          //     color: Colors.white,
          //   ),
          // ),
          // const SizedBox(
          //   height: 16,
          // ),
          // const Text(
          //   "Click the button to start recording...",
          //   style: TextStyle(fontSize: 16),
          // ),
          Container(
            height: 100,
            child: getRecorder(),
          )
        ],
      ),
    );
  }

  Widget getUploadVideoScreen() {
    if (thumbNailName.checkNotEmpty) {
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
                  thumbNailName,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonButton(
                onPressed: () {
                  thumbNailName = "";
                  fileBytes = null;
                  thumbNailBytes = null;
                  mySetState();
                },
                text: "Clear",
                backGroundColor: Colors.transparent,
              ),
              SizedBox(
                width: 20,
              ),
              CommonButton(
                onPressed: () async {
                  thumbNailName = await openFileExplorer(FileType.audio, false);
                  mySetState();
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
        thumbNailName = await openFileExplorer(FileType.audio, false);
        mySetState();
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

  Widget getRecorder() {
    return showPlayer
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: AppAudioPlayer(
              source: audioPath!,
              onDelete: () {
                setState(() => showPlayer = false);
              },
            ),
          )
        : Recorder(
            onStop: (path) {
              if (kDebugMode) print('Recorded file path: $path');
              setState(() {
                audioPath = path;
                showPlayer = true;
              });
            },
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
  late AudioPlayer player = AudioPlayer();
  bool isTranscriptExpanded = true;

  @override
  void initState() {
    super.initState();

    // Create the audio player.
    player = AudioPlayer();

    // Set the release mode to keep the source after playback has completed.
    player.setReleaseMode(ReleaseMode.stop);

    // Start the player as soon as the app is displayed.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await player.setSourceAsset("audio/audio.mp3");
      await player.resume();
    });
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
    return Scaffold(
      appBar: getAppBar(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
        child: CommonSaveExitButtonRow(
          onSaveAndExitPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
          },
          onSaveAndViewPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            NavigationController.navigateToPodcastEpisodeScreen(
              navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
            );
          },
        ),
      ),
      body: AppUIComponents.getBackGroundBordersRounded(
        context: context,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SingleChildScrollView(
            child: Column(
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
                      Text(
                        "Transcript",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                if (isTranscriptExpanded)
                  Text(
                    """
Nigel:

Glad to see things are going well and business is starting to pick up. Andrea told me about your outstanding numbers on Tuesday. Keep up the good work. Now to other business, I am going to suggest a payment schedule for the outstanding monies that is due. One, can you pay the balance of the license agreement as soon as possible? Two, I suggest we setup or you suggest, what you can pay on the back royalties, would you feel comfortable with paying every two weeks? Every month, I will like to catch up and maintain current royalties. So, if we can start the current royalties and maintain them every two weeks as all stores are required to do, I would appreciate it. Let me know if this works for you.

Thanks.
 """,
                  )
              ],
            ),
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

  Widget getMainBody() {
    return AudioPlayerWidget(
      url: "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3",
      isMessageReceived: true,
    );
  }
}
