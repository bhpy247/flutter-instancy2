import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/views/message/components/seekBar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import '../../../utils/my_safe_state.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String url;

  const AudioPlayerWidget({Key? key, required this.url}) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> with MySafeState {
  final AudioPlayer _player = AudioPlayer();
  Future? getData;

  Future<void> getFutureData() async {
    await _player.setUrl(widget.url);
  }

  @override
  void initState() {
    super.initState();
    getData = getFutureData();
  }

  @override
  void dispose() {
    _player.dispose();

    super.dispose();
  }

  Stream<PositionData> get _positionDataStream => Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
      _player.positionStream, _player.bufferedPositionStream, _player.durationStream, (position, bufferedPosition, duration) => PositionData(position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData,
      builder: (context, AsyncSnapshot asyncSnapshot) {
        if (asyncSnapshot.connectionState != ConnectionState.done) {
          return const SpinKitCircle(
            color: Colors.white,
          );
        }

        return StreamBuilder(
          stream: _player.playerStateStream,
          builder: (BuildContext context, AsyncSnapshot<PlayerState> playerStateSnapshot) {
            PlayerState? playerState = playerStateSnapshot.data;

            return Row(
              children: [
                InkWell(
                  onTap: () async {
                    if (playerState == null) return;

                    if (playerState.playing) {
                      await _player.pause();
                    } else {
                      await _player.play();
                    }
                    if (playerState.processingState == ProcessingState.completed) {
                      await _player.load();
                    }
                    mySetState();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(color: Colors.white30, shape: BoxShape.circle),
                    child: Icon(
                      (playerState?.playing ?? false) ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<PositionData>(
                    stream: _positionDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;
                      return SeekBar(
                        duration: positionData?.duration ?? Duration.zero,
                        position: positionData?.position ?? Duration.zero,
                        bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
                        onChangeEnd: _player.seek,
                      );
                    },
                  ),
                )
                // Text(_player.duration.toString()),
              ],
            );
          },
        );
      },
    );
  }
}
