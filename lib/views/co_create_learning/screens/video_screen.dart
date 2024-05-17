import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/co_create_learning/component/theme_helper.dart';
import 'package:video_player/video_player.dart';

import '../../../configs/app_configurations.dart';
import '../../../utils/my_print.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/common_loader.dart';

class VideoScreen extends StatefulWidget {
  static const String routeName = "/videoScreen";

  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> with MySafeState {
  VideoPlayerController? _videoPlayerController;
  Future<void>? futureInitializeVideo;

  Future<void> getData() async {
    await _videoPlayerController!.initialize();

    MyPrint.printOnConsole("IsInitialized:${_videoPlayerController!.value.isInitialized}");

    _videoPlayerController!.play();
  }

  @override
  void initState() {
    super.initState();
    VideoPlayerOptions videoPlayerOptions = VideoPlayerOptions(
      allowBackgroundPlayback: false,
      mixWithOthers: false,
    );
    Uri? uri = Uri.tryParse(
        "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/demo%2Fvideos%2FAI%20agents%20memory%20and%20Personalize%20learning.mp4?alt=media&token=84ba039a-fc26-4868-9e3e-070197764d68");
    if (uri != null) {
      _videoPlayerController = VideoPlayerController.networkUrl(
        uri,
        videoPlayerOptions: videoPlayerOptions,
      );
    }
    if (_videoPlayerController != null) {
      futureInitializeVideo = getData();
    }
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
      body: AppUIComponents.getBackGroundBordersRounded(
        context: context,
        child: getMainBody(
          futureInitializeVideo: futureInitializeVideo,
          videoPlayerController: _videoPlayerController,
        ),
      ),
    );
  }

  PreferredSizeWidget getAppBar() {
    return AppConfigurations().commonAppBar(
      title: "AI agents memory and Personalize learning",
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

        return Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
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
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: [
                      Icon(Icons.keyboard_arrow_up),
                      Text(
                        "Transcript",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
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
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class ControlsOverlay extends StatelessWidget {
  final Function()? onPlayTap;

  const ControlsOverlay({required this.controller, this.onPlayTap});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (BuildContext context, VideoPlayerValue value, Widget? child) {
        MyPrint.printOnConsole("isBuffering:${value.isBuffering}");
        MyPrint.printOnConsole("isPlaying:${value.isPlaying}");

        return Stack(
          children: <Widget>[
            getMainWidget(value: value),
            GestureDetector(
              onTap: () {
                // controller.value.isPlaying ? controller.pause() : controller.play();
                if (onPlayTap != null) {
                  onPlayTap!();
                }
              },
            ),
            /*Align(
              alignment: Alignment.topLeft,
              child: PopupMenuButton<Duration>(
                initialValue: controller.value.captionOffset,
                tooltip: 'Caption Offset',
                onSelected: (Duration delay) {
                  controller.setCaptionOffset(delay);
                },
                itemBuilder: (BuildContext context) {
                  return <PopupMenuItem<Duration>>[
                    for (final Duration offsetDuration in _exampleCaptionOffsets)
                      PopupMenuItem<Duration>(
                        value: offsetDuration,
                        child: Text('${offsetDuration.inMilliseconds}ms'),
                      )
                  ];
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    // Using less vertical padding as the text is also longer
                    // horizontally, so it feels like it would need more spacing
                    // horizontally (matching the aspect ratio of the video).
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: Text('${controller.value.captionOffset.inMilliseconds}ms'),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: PopupMenuButton<double>(
                initialValue: controller.value.playbackSpeed,
                tooltip: 'Playback speed',
                onSelected: (double speed) {
                  controller.setPlaybackSpeed(speed);
                },
                itemBuilder: (BuildContext context) {
                  return <PopupMenuItem<double>>[
                    for (final double speed in _examplePlaybackRates)
                      PopupMenuItem<double>(
                        value: speed,
                        child: Text('${speed}x'),
                      )
                  ];
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    // Using less vertical padding as the text is also longer
                    // horizontally, so it feels like it would need more spacing
                    // horizontally (matching the aspect ratio of the video).
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: Text('${controller.value.playbackSpeed}x'),
                ),
              ),
            ),*/
          ],
        );
      },
    );
  }

  Widget getMainWidget({required VideoPlayerValue value}) {
    if (controller.value.isBuffering) {
      return Center(
        child: CircularProgressIndicator(color: theme.primaryColor),
        // child: SpinKitFadingCircle(color: Colors.white),
      );
    } else if (!controller.value.isPlaying) {
      return ColoredBox(
        color: Colors.black26,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)]),
            child: const Icon(
              Icons.play_arrow,
              color: Colors.black,
              size: 35.0,
              semanticLabel: 'Play',
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
