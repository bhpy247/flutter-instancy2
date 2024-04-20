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
    Uri? uri = Uri.tryParse("https://qalearning.instancy.com//Content/PublishFiles/B536A875-3C10-43F4-BAFB-4526A0054D20/en-us/60ec988e-0106-442b-9bb8-98e68d0180f7.mp4");
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
      title: "Mastering Communication",
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
                            _ControlsOverlay(
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    """
               
Host: "Hello and welcome to today's video! In the next three minutes, we'll be discussing how to transcribe a video to text. Let's get started.

(00:04-00:12)
Host: "Transcribing a video to text can be a time-consuming process, but with the right tools and services, it can be done efficiently and accurately."

00:13-00:25)
Host: "Whether you're using a human-powered transcription service like Rev1
or an AI-powered tool, it's essential to choose the right service for your needs."

(00:26-00:40)
Host: "Additional features like timestamping, verbatim transcription, and instant first draft can help you customize the transcript to your needs.""",
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

class _ControlsOverlay extends StatelessWidget {
  final Function()? onPlayTap;

  const _ControlsOverlay({required this.controller, this.onPlayTap});

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
