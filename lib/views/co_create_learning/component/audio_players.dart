import 'dart:async';

import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppAudioPlayer extends StatefulWidget {
  /// Path from where to play recorded audio
  final String sourceFilePath;
  final String sourceAssetPath;
  final String sourceNetworkUrl;
  final Uint8List? sourceBytes;
  final MainAxisAlignment verticalAlignment;

  /// Callback when audio file should be removed
  /// Setting this to null hides the delete button
  final VoidCallback? onDelete;

  const AppAudioPlayer({
    super.key,
    this.sourceFilePath = "",
    this.sourceAssetPath = "",
    this.sourceNetworkUrl = "",
    this.sourceBytes,
    this.verticalAlignment = MainAxisAlignment.center,
    this.onDelete,
  });

  @override
  AppAudioPlayerState createState() => AppAudioPlayerState();
}

class AppAudioPlayerState extends State<AppAudioPlayer> {
  static const double _controlSize = 56;
  double _deleteBtnSize = 24;

  final _audioPlayer = ap.AudioPlayer()..setReleaseMode(ReleaseMode.stop);
  late StreamSubscription<void> _playerStateChangedSubscription;
  late StreamSubscription<Duration?> _durationChangedSubscription;
  late StreamSubscription<Duration> _positionChangedSubscription;
  Duration? _position;
  Duration? _duration;
  late Source source;

  // String getDurationString({required Duration duration, required Duration position }){
  //   String positionString = '';
  //   String durationString = '';
  //
  //   if((position.inMinutes ) <= 10){
  //     positionString = "0$positionString";
  //   }
  //   if((position.inSeconds) <= 10){
  //
  //   }
  //
  //   return generatedString;
  // }

  @override
  void initState() {
    _playerStateChangedSubscription = _audioPlayer.onPlayerComplete.listen((state) async {
      await stop();
    });
    _positionChangedSubscription = _audioPlayer.onPositionChanged.listen(
      (position) => setState(() {
        _position = position;
      }),
    );
    _durationChangedSubscription = _audioPlayer.onDurationChanged.listen(
      (duration) => setState(() {
        _duration = duration;
      }),
    );

    if (widget.sourceFilePath.isNotEmpty) {
      source = kIsWeb ? ap.UrlSource(widget.sourceFilePath) : ap.DeviceFileSource(widget.sourceFilePath);
    } else if (widget.sourceNetworkUrl.isNotEmpty) {
      source = ap.UrlSource(widget.sourceNetworkUrl);
    } else if (widget.sourceAssetPath.isNotEmpty) {
      source = ap.AssetSource(widget.sourceAssetPath);
    } else if (widget.sourceBytes != null) {
      source = ap.BytesSource(widget.sourceBytes!);
    } else {
      source = kIsWeb ? ap.UrlSource(widget.sourceFilePath) : ap.DeviceFileSource(widget.sourceFilePath);
    }

    _audioPlayer.setSource(source);

    super.initState();
  }

  @override
  void dispose() {
    _playerStateChangedSubscription.cancel();
    _positionChangedSubscription.cancel();
    _durationChangedSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _deleteBtnSize = widget.onDelete != null ? 24 : 0;

        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: widget.verticalAlignment,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildControl(),
                _buildSlider(constraints.maxWidth),
                if (widget.onDelete != null)
                  IconButton(
                    icon: Icon(Icons.delete, color: const Color(0xFF73748D), size: _deleteBtnSize),
                    onPressed: () {
                    if (_audioPlayer.state == ap.PlayerState.playing) {
                        stop().then((value) => widget.onDelete!());
                      } else {
                        widget.onDelete!();
                      }
                  },
                ),
              ],
            ),
            Text(
              '${_position?.inMinutes ?? 0.0}:${_position?.inSeconds ?? 0.0} / ${_duration?.inMinutes ?? 0.0}:${_duration?.inSeconds ?? 0.0} ',
            ),
          ],
        );
      },
    );
  }

  Widget _buildControl() {
    Icon icon;
    Color color;

    if (_audioPlayer.state == ap.PlayerState.playing) {
      icon = const Icon(Icons.pause, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.play_arrow, color: theme.primaryColor, size: 30);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: _controlSize, height: _controlSize, child: icon),
          onTap: () {
            if (_audioPlayer.state == ap.PlayerState.playing) {
              pause();
            } else {
              play();
            }
          },
        ),
      ),
    );
  }

  Widget _buildSlider(double widgetWidth) {
    bool canSetValue = false;
    final duration = _duration;
    final position = _position;

    if (duration != null && position != null) {
      canSetValue = position.inMilliseconds > 0;
      canSetValue &= position.inMilliseconds < duration.inMilliseconds;
    }

    double width = widgetWidth - _controlSize - _deleteBtnSize;
    width -= _deleteBtnSize;

    return SizedBox(
      width: width,
      child: Slider(
        activeColor: Theme.of(context).primaryColor,
        inactiveColor: Theme.of(context).colorScheme.secondary,
        onChanged: (v) {
          if (duration != null) {
            final position = v * duration.inMilliseconds;
            _audioPlayer.seek(Duration(milliseconds: position.round()));
          }
        },
        value: canSetValue && duration != null && position != null ? position.inMilliseconds / duration.inMilliseconds : 0.0,
      ),
    );
  }

  Future<void> play() => _audioPlayer.play(source);

  Future<void> pause() async {
    await _audioPlayer.pause();
    setState(() {});
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    setState(() {});
  }
}
