import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/message/components/audio_player_widget.dart';

import '../../../configs/app_configurations.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/common_button.dart';

class PodcastEpisodeScreen extends StatefulWidget {
  static const String routeName = "/PodcastEpisodeScreen";

  const PodcastEpisodeScreen({super.key});

  @override
  State<PodcastEpisodeScreen> createState() => _PodcastEpisodeScreenState();
}

class _PodcastEpisodeScreenState extends State<PodcastEpisodeScreen> {
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
    return Scaffold(
      appBar: getAppBar(),
      body: AppUIComponents.getBackGroundBordersRounded(
        context: context,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                PlayerWidget(player: player),
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          isTranscriptExpanded = !isTranscriptExpanded;
                          setState(() {});
                        },
                        child: Icon(isTranscriptExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down_outlined)),
                    Text(
                      "Transcript",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
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
    return const AudioPlayerWidget(
      url: "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3",
      isMessageReceived: true,
    );
  }
}

// The PlayerWidget is a copy of "/lib/components/player_widget.dart".
//#region PlayerWidget

class PlayerWidget extends StatefulWidget {
  final AudioPlayer player;
  final Function()? onRetakeTap;

  const PlayerWidget({
    required this.player,
    this.onRetakeTap,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState();
  }
}

class _PlayerWidgetState extends State<PlayerWidget> with MySafeState {
  PlayerState? _playerState;
  Duration? _duration;
  Duration? _position;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  bool get _isPlaying => _playerState == PlayerState.playing;

  bool get _isPaused => _playerState == PlayerState.paused;

  String get _durationText => _duration?.toString().split('.').first ?? '';

  String get _positionText => _position?.toString().split('.').first ?? '';

  AudioPlayer get player => widget.player;

  @override
  void initState() {
    super.initState();
    // Use initial values from player
    _playerState = player.state;
    player.getDuration().then(
          (value) => setState(() {
            _duration = value;
          }),
        );
    player.getCurrentPosition().then(
          (value) => setState(() {
            _position = value;
          }),
        );
    _initStreams();
  }

  @override
  void setState(VoidCallback fn) {
    // Subscriptions only can be closed asynchronously,
    // therefore events can occur after widget has been disposed.
    if (mounted) {
      super.setState(fn);
    }
  }

  void _initStreams() {
    _durationSubscription = player.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription = player.onPositionChanged.listen(
      (p) => setState(() => _position = p),
    );

    _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero;
      });
    });

    _playerStateChangeSubscription = player.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
      });
    });
  }

  Future<void> _play() async {
    await player.resume();
    setState(() => _playerState = PlayerState.playing);
  }

  Future<void> _pause() async {
    await player.pause();
    setState(() => _playerState = PlayerState.paused);
  }

  Future<void> _stop() async {
    await player.stop();
    setState(() {
      _playerState = PlayerState.stopped;
      _position = Duration.zero;
    });
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 35),
      decoration: BoxDecoration(border: Border.all(color: Colors.black, width: .5)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: themeData.primaryColor, shape: BoxShape.circle),
              child: Image.asset(
                "assets/cocreate/Vector-4.png",
                color: Colors.white,
                height: 30,
                width: 41,
              )),
          const SizedBox(
            height: 20,
          ),
          getNewViewOfAudioPlayer(),
          const SizedBox(
            height: 20,
          ),
          if (widget.onRetakeTap != null)
            CommonButton(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
              onPressed: widget.onRetakeTap,
              text: "Retake",
              fontColor: themeData.primaryColor,
              fontWeight: FontWeight.bold,
              borderWidth: 1,
              backGroundColor: Colors.transparent,
              borderColor: themeData.primaryColor,
            ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget getNewViewOfAudioPlayer() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(color: const Color(0xffF1F3F4), borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          InkWell(onTap: !_isPlaying ? _play : _pause, child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow)),
          const SizedBox(
            width: 10,
          ),
          Text(
            _position != null
                ? '$_positionText / $_durationText'
                : _duration != null
                    ? _durationText
                    : '',
            style: const TextStyle(fontSize: 13.0),
          ),
          Expanded(child: getSlider()),
        ],
      ),
    );
  }

  Widget getSlider() {
    return Container(
      height: 20,
      padding: EdgeInsets.zero,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          // Define the size of the slider thumb
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5.0, elevation: 0),
          // Define the size of the slider track
          trackHeight: 3.0,
        ),
        child: Slider(
          onChanged: (value) {
            final duration = _duration;
            if (duration == null) {
              return;
            }
            final position = value * duration.inMilliseconds;
            player.seek(Duration(milliseconds: position.round()));
          },
          value: (_position != null && _duration != null && _position!.inMilliseconds > 0 && _position!.inMilliseconds < _duration!.inMilliseconds)
              ? _position!.inMilliseconds / _duration!.inMilliseconds
              : 0.0,
        ),
      ),
    );
  }
}
