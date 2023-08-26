import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:video_player/video_player.dart';

import '../../../../backend/navigation/navigation.dart';
import '../../common/components/common_loader.dart';

class VideoLaunchScreen extends StatefulWidget {
  static const String routeName = "/VideoLaunchScreen";

  final VideoLaunchScreenNavigationArguments arguments;

  const VideoLaunchScreen({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  State<VideoLaunchScreen> createState() => _VideoLaunchScreenState();
}

class _VideoLaunchScreenState extends State<VideoLaunchScreen> {
  VideoPlayerController? videoPlayerController;
  Future<void>? futureInitializeVideo;

  Future<void> getData() async {
    await videoPlayerController!.initialize();

    MyPrint.printOnConsole("IsInitialized:${videoPlayerController!.value.isInitialized}");

    videoPlayerController!.play();
  }

  @override
  void initState() {
    super.initState();

    VideoPlayerOptions videoPlayerOptions = VideoPlayerOptions(
      allowBackgroundPlayback: false,
      mixWithOthers: false,
    );
    if (widget.arguments.isNetworkVideo) {
      if (widget.arguments.videoUrl.isNotEmpty) {
        Uri? uri = Uri.tryParse(widget.arguments.videoUrl);
        if (uri != null) {
          videoPlayerController = VideoPlayerController.networkUrl(
            uri,
            videoPlayerOptions: videoPlayerOptions,
          );
        }
      }
    } else {
      if (!kIsWeb) {
        if (widget.arguments.videoFileBytes.checkNotEmpty) {
          videoPlayerController = VideoPlayerController.contentUri(
            Uri.dataFromBytes(widget.arguments.videoFileBytes!),
            videoPlayerOptions: videoPlayerOptions,
          );
        } else if (widget.arguments.videoFilePath.isNotEmpty) {
          videoPlayerController = VideoPlayerController.contentUri(
            Uri.parse(widget.arguments.videoFilePath),
            videoPlayerOptions: videoPlayerOptions,
          );
        }
      }
    }

    if (videoPlayerController != null) {
      futureInitializeVideo = getData();
    }
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: getMainBody(
        futureInitializeVideo: futureInitializeVideo,
        videoPlayerController: videoPlayerController,
      ),
    );
  }

  PreferredSizeWidget getAppBar() {
    return AppBar(
      title: Text(
        widget.arguments.contntName.isNotEmpty ? widget.arguments.contntName : "Video",
      ),
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
          child: AspectRatio(
            aspectRatio: videoPlayerController.value.aspectRatio,
            child: VideoPlayer(videoPlayerController),
          ),
        );
      },
    );
  }
}
