import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_controller.dart';
import 'package:flutter_instancy_2/backend/co_create_knowledge/co_create_knowledge_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation_arguments.dart';
import 'package:flutter_instancy_2/configs/app_strings.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/co_create_content_authoring_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/video/data_model/video_content_model.dart';
import 'package:flutter_instancy_2/models/co_create_knowledge/video/request_model/generate_video_request_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/utils/my_toast.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/views/co_create_learning/screens/video_with_transcript_launch_screen.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../backend/app_theme/style.dart';
import '../../../backend/navigation/navigation_controller.dart';
import '../../../backend/navigation/navigation_operation_parameters.dart';
import '../../../backend/navigation/navigation_type.dart';
import '../../../backend/ui_actions/primary_secondary_actions/primary_secondary_actions_constants.dart';
import '../../../configs/app_configurations.dart';
import '../../../configs/app_constants.dart';
import '../../../models/course/data_model/CourseDTOModel.dart';
import '../../../utils/my_print.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/common_loader.dart';
import '../../common/components/instancy_ui_actions/instancy_ui_actions.dart';
import '../component/common_save_exit_button_row.dart';

class GenerateWithAiVideoScreen extends StatefulWidget {
  static const String routeName = "/GenerateWithAiVideoScreen";

  final GenerateWithAiVideoScreenNavigationArgument arguments;

  const GenerateWithAiVideoScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<GenerateWithAiVideoScreen> createState() => _GenerateWithAiVideoScreenState();
}

class _GenerateWithAiVideoScreenState extends State<GenerateWithAiVideoScreen> with MySafeState {
  bool isLoading = false;

  late CoCreateKnowledgeProvider coCreateKnowledgeProvider;
  late CoCreateKnowledgeController coCreateKnowledgeController;

  late CoCreateContentAuthoringModel coCreateContentAuthoringModel;

  VideoPlayerController? _videoPlayerController;
  Future<void>? futureInitializeVideo;
  bool isTranscriptOpen = true;
  late Future future;

  void initializeData() {
    coCreateKnowledgeProvider = context.read<CoCreateKnowledgeProvider>();
    coCreateKnowledgeController = CoCreateKnowledgeController(coCreateKnowledgeProvider: coCreateKnowledgeProvider);

    coCreateContentAuthoringModel = widget.arguments.coCreateContentAuthoringModel;
  }

  Future<void> getData() async {
    VideoPlayerOptions videoPlayerOptions = VideoPlayerOptions(
      allowBackgroundPlayback: false,
      mixWithOthers: false,
    );

    String url = coCreateKnowledgeProvider.generatedVideoUrl.get();
    MyPrint.printOnConsole("url : $url");
    Uri? uri = Uri.tryParse(url);
    // "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fvideos%2FAI%20agents%20memory%20and%20Personalize%20learning.mp4?alt=media&token=84ba039a-fc26-4868-9e3e-070197764d68");
    if (uri != null) {
      _videoPlayerController = VideoPlayerController.networkUrl(
        uri,
        videoPlayerOptions: videoPlayerOptions,
      );
    }
    if (_videoPlayerController != null) {
      await _videoPlayerController!.initialize();

      MyPrint.printOnConsole("IsInitialized:${_videoPlayerController!.value.isInitialized}");

      _videoPlayerController!.play();
    }
  }

  Future<void> getFutureData() async {
    GenerateVideoRequestModel generateVideoRequestModel = GenerateVideoRequestModel(
      videoInput: VideoInput(
        title: "Heart Attack",
        input: [
          Input(
            avatar: widget.arguments.coCreateContentAuthoringModel.videoContentModel?.avatarId ?? "",
            background: widget.arguments.coCreateContentAuthoringModel.videoContentModel?.background ?? "",
            scriptText: "Heart Attack is a major disises",
            avatarSettings: AvatarSettings(
              horizontalAlign: widget.arguments.coCreateContentAuthoringModel.videoContentModel?.background.toLowerCase() ?? "",
              voice: widget.arguments.coCreateContentAuthoringModel.videoContentModel?.voice ?? "",
              scale: 1,
              style: widget.arguments.coCreateContentAuthoringModel.videoContentModel?.style ?? "",
            ),
          )
        ],
      ),
    );
    bool isSuccess = await coCreateKnowledgeController.generateVideo(requestModel: generateVideoRequestModel);
    MyPrint.printOnConsole("IsSuccess ${isSuccess}");
    if (isSuccess) {
      futureInitializeVideo = getData();
    }
  }

  List<InstancyUIActionModel> getActionsList({required CourseDTOModel model, int index = 0}) {
    List<InstancyUIActionModel> actions = [
      if (![InstancyObjectTypes.events].contains(model.ContentTypeId))
        InstancyUIActionModel(
          text: "Delete",
          actionsEnum: InstancyContentActionsEnum.Delete,
          onTap: () {
            Navigator.pop(context);
          },
          iconData: InstancyIcons.delete,
        ),
      InstancyUIActionModel(
        text: "Regenerate",
        actionsEnum: InstancyContentActionsEnum.Regenerate,
        onTap: () {
          Navigator.pop(context);
        },
        iconData: InstancyIcons.reEnroll,
      ),
    ];

    return actions;
  }

  Future<void> showMoreActions({required CourseDTOModel model, int index = 0}) async {
    List<InstancyUIActionModel> actions = getActionsList(model: model, index: index);

    InstancyUIActions().showAction(
      context: context,
      actions: actions,
    );
  }

  Future<CourseDTOModel?> saveContent() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("GenerateWithAiVideoScreen().saveFlashcard() called", tag: tag);

    isLoading = true;
    mySetState();

    coCreateContentAuthoringModel.uploadedDocumentBytes = null;
    coCreateContentAuthoringModel.uploadedDocumentName = "";

    VideoContentModel videoContentModel = coCreateContentAuthoringModel.videoContentModel ??= VideoContentModel();
    videoContentModel.scriptText = "";

    String? contentId = await coCreateKnowledgeController.addEditContentItem(coCreateContentAuthoringModel: coCreateContentAuthoringModel);
    MyPrint.printOnConsole("contentId:'$contentId'", tag: tag);

    isLoading = false;
    mySetState();

    if (contentId.checkEmpty) {
      MyPrint.printOnConsole("Returning from GenerateWithAiVideoScreen().saveEvent() because contentId is null or empty", tag: tag);
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

  @override
  void initState() {
    super.initState();
    initializeData();
    future = getFutureData();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Scaffold(
      appBar: getAppBar(),
      bottomNavigationBar: getCommonButton(),
      body: AppUIComponents.getBackGroundBordersRounded(
        context: context,
        // child: Container(),
        child: FutureBuilder(
            future: future,
            builder: (context, snapShot) {
              if (snapShot.connectionState == ConnectionState.done) {
                return getMainBody(
                  futureInitializeVideo: futureInitializeVideo,
                  videoPlayerController: _videoPlayerController,
                );
              } else {
                return CommonLoader();
              }
            }),
      ),
    );
  }

  PreferredSizeWidget getAppBar() {
    return AppConfigurations().commonAppBar(
      title: AppStrings.generateWithAI,
    );
  }

  Widget getMainBody({
    required Future<void>? futureInitializeVideo,
    required VideoPlayerController? videoPlayerController,
  }) {
    if (futureInitializeVideo == null || videoPlayerController == null) {
      return const Center(
        child: Text("Video Couldn't loaded"),
      );
    }

    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: videoPlayerController,
      builder: (BuildContext context, VideoPlayerValue videoPlayerValue, Widget? child) {
        if (!videoPlayerController.value.isInitialized) {
          return const CommonLoader();
        }

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          decoration: BoxDecoration(border: Border.all(color: Styles.borderColor), borderRadius: BorderRadius.circular(5)),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                  child: Row(
                    children: [
                      const Expanded(child: Text("AI Agents Memory and Personalize Learning")),
                      InkWell(
                        onTap: () {
                          showMoreActions(model: CourseDTOModel());
                        },
                        child: const Icon(
                          Icons.more_vert,
                          size: 20,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 250,
                    child: Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(10)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            VideoPlayer(_videoPlayerController!),
                            ControlsOverlay(
                              controller: _videoPlayerController!,
                              onPlayTap: () {
                                (_videoPlayerController!.value.isPlaying) ? _videoPlayerController!.pause() : _videoPlayerController!.play();
                                // _videoPlayerController?.value.
                                setState(() {});
                              },
                            ),
                            VideoProgressIndicator(
                              _videoPlayerController!,
                              allowScrubbing: true,
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          isTranscriptOpen = !isTranscriptOpen;
                          setState(() {});
                        },
                        child: Icon(
                          isTranscriptOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down_outlined,
                        ),
                      ),
                      Text(
                        "Transcript",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                if (isTranscriptOpen)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      """
          0:00
          Enhancing corporate Learning with AI Agents and LLM featuring large memory, AI agents and large language model applications are revolutionizing learning and skill development by leveraging advanced AI capabilities.
          
          0:14
          These technologies enhance personalized learning experiences by remembering and processing vast amounts of information over extended periods.
          
          0:22
          Here are the top five benefits of long memory in AI agents and LL, and applications for learning and skill development.
          
          0:30
          Number one, personalized learning experiences.
          
          0:33
          Long memory allows AI systems to remember individual learners, progress, preferences, and past interactions.
          
          0:41
          This capability enables AI to tailor educational content to match each user's learning pace and style, providing a highly customized learning journey that addresses specific needs and accelerates skill acquisition #2 Consistent learning support.
          
          0:58
          AI with long term memory can be a consistent learning companion.
          
          1:02
          It retains information about a learner's long term development path, including past achievements and areas of difficulty, ensuring that the learning process is continuous and builds on previous knowledge without unnecessary repetition #3 Adaptive learning paths.
          
          1:19
          With access to historical learning data, AI can adapt the learning path dynamically.
          
          1:24
          It assesses the effectiveness of past learning activities and modifies upcoming sessions to meet the learner's goals better.
          
          1:31
          This adaptive approach helps in closing skill gaps more efficiently and effectively #4 proactive performance support.
          
          1:39
          AI agents can proactively offer assistance by predicting when a learner might struggle or need reinforcement based on past performance patterns.
          
          1:48
          This timely intervention helps reinforce learning at critical moments, potentially improving the retention and application of knowledge #5 enhanced assessment and feedback.
          
          1:59
          Long memory enables AI to provide more accurate assessments and constructive feedback by analyzing A learner's progress trajectory over time.
          
          2:09
          This long term perspective allows for a more nuanced understanding of a learner's development, enabling better alignment of feedback and recommendations with the learner specific context and history.
          
          2:21
          These benefits demonstrate how AI with long memory significantly enhances the learning and skill development process, making it more personalized, supportive, and responsive to individual learner needs.
          
          2:34
          Instancy offers a comprehensive learning ecosystem featuring a generative AI and AI agents platform seamlessly integrated with a learning management system, content management, web and mobile learning experiences, and robust data analytics.
          
          2:50
          Connect with us to elevate your learning journey.""",
                      textAlign: TextAlign.justify,
                    ),
                  ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget getCommonButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
      child: CommonSaveExitButtonRow(
        onSaveAndExitPressed: () {
          onSaveAndExitTap();
        },
        onSaveAndViewPressed: () {
          onSaveAndViewTap();
        },
      ),
    );
  }
}

// class GenerateWithAiVideoScreen extends StatefulWidget {
//   static const String routeName = "/GenerateWithAiVideoScreen";
//
//   const GenerateWithAiVideoScreen({super.key});
//
//   @override
//   State<GenerateWithAiVideoScreen> createState() => _GenerateWithAiVideoScreenState();
// }
//
// class _GenerateWithAiVideoScreenState extends State<GenerateWithAiVideoScreen> with MySafeState {
//   TextEditingController promptController = TextEditingController();
//   TextEditingController lengthController = TextEditingController();
//   TextEditingController avatarController = TextEditingController();
//   TextEditingController musicController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     super.pageBuild();
//     return Scaffold(
//       appBar: AppConfigurations().commonAppBar(
//         title: "Generate With AI",
//       ),
//       body: AppUIComponents.getBackGroundBordersRounded(
//         context: context,
//         child: getMainBody(),
//       ),
//     );
//   }
//
//   Widget getMainBody() {
//     return Container(
//       child: Column(
//         children: [
//           getPromptTextFormField(),
//           SizedBox(
//             height: 10,
//           ),
//           getLengthTextFormField(),
//           SizedBox(
//             height: 10,
//           ),
//           getAvatarTextFormField(),
//           SizedBox(
//             height: 10,
//           ),
//           getMusicTextFormField(),
//           SizedBox(
//             height: 10,
//           ),
//           CommonButton(
//             minWidth: double.infinity,
//             onPressed: () {},
//             text: "Generate With AI",
//             fontColor: themeData.colorScheme.onPrimary,
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget getPromptTextFormField() {
//     return getTexFormField(
//       isMandatory: false,
//       showPrefixIcon: false,
//       controller: promptController,
//       labelText: "Write Prompt...",
//       keyBoardType: TextInputType.text,
//       iconUrl: "assets/catalog/imageDescription.png",
//       maxLines: 7,
//       minLines: 7,
//     );
//   }
//
//   Widget getLengthTextFormField() {
//     return getTexFormField(
//       isMandatory: false,
//       showPrefixIcon: false,
//       controller: lengthController,
//       labelText: "Length",
//       keyBoardType: TextInputType.text,
//       iconUrl: "assets/catalog/imageDescription.png",
//     );
//   }
//
//   Widget getAvatarTextFormField() {
//     return getTexFormField(
//       isMandatory: false,
//       showPrefixIcon: false,
//       controller: avatarController,
//       labelText: "Avatar",
//       keyBoardType: TextInputType.text,
//       iconUrl: "assets/catalog/imageDescription.png",
//     );
//   }
//
//   Widget getMusicTextFormField() {
//     return getTexFormField(
//       isMandatory: false,
//       showPrefixIcon: false,
//       controller: musicController,
//       labelText: "Music",
//       keyBoardType: TextInputType.text,
//       iconUrl: "assets/catalog/imageDescription.png",
//     );
//   }
//
//   //region textFieldView
//   Widget getTexFormField(
//       {TextEditingController? controller,
//       String iconUrl = "",
//       String? Function(String?)? validator,
//       String labelText = "Label",
//       Widget? suffixWidget,
//       required bool isMandatory,
//       int? minLines,
//       int? maxLines,
//       bool showPrefixIcon = false,
//       TextInputType? keyBoardType,
//       double iconHeight = 15,
//       double iconWidth = 15}) {
//     return CommonTextFormFieldWithLabel(
//       controller: controller,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       label: isMandatory ? labelWithStar(labelText) : null,
//       labelText: isMandatory ? null : labelText,
//       validator: validator,
//       floatingLabelColor: Colors.black.withOpacity(.6),
//       minLines: minLines,
//       maxLines: maxLines,
//       borderColor: Styles.textFieldBorderColor,
//       enabledBorderColor: Styles.textFieldBorderColor,
//       borderWidth: 1,
//       isOutlineInputBorder: true,
//       keyboardType: keyBoardType,
//       prefixWidget: showPrefixIcon
//           ? iconUrl.isNotEmpty
//               ? getImageView(url: iconUrl, height: iconHeight, width: iconWidth)
//               : const Icon(
//                   FontAwesomeIcons.globe,
//                   size: 15,
//                   color: Colors.grey,
//                 )
//           : null,
//       suffixWidget: suffixWidget,
//     );
//   }
//
//   Widget labelWithStar(String labelText, {TextStyle? style}) {
//     return RichText(
//       text: TextSpan(
//         text: labelText,
//         style: style ?? const TextStyle(color: Colors.grey),
//         children: const [
//           TextSpan(
//             text: ' *',
//             style: TextStyle(
//               color: Colors.red,
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget getImageView({String url = "assets/addContentLogo.png", double height = 159, double width = 135}) {
//     return Image.asset(
//       url,
//       height: height,
//       width: width,
//     );
//   }
//
// //endregion
// }
