import 'dart:math';

import 'package:flutter/material.dart';

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final bool isMessageReceived;

  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  const SeekBar({
    Key? key,
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
    this.isMessageReceived = false,
  }) : super(key: key);

  @override
  SeekBarState createState() => SeekBarState();
}

class SeekBarState extends State<SeekBar> {
  double? _dragValue;
  late SliderThemeData _sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 2.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SliderTheme(
              data: _sliderThemeData.copyWith(
                thumbShape: HiddenThumbComponentShape(),
                activeTrackColor: widget.isMessageReceived ? Colors.black.withOpacity(.1) : Colors.white30,
                inactiveTrackColor: widget.isMessageReceived ? Colors.black : Colors.grey.shade300,
              ),
              child: ExcludeSemantics(
                child: Slider(
                  min: 0.0,
                  max: widget.duration.inMilliseconds.toDouble(),
                  value: (widget.position.inMilliseconds.toDouble() >= widget.duration.inMilliseconds.toDouble())
                      ? 0.0
                      : min(widget.bufferedPosition.inMilliseconds.toDouble(), widget.duration.inMilliseconds.toDouble()),
                  onChanged: (value) {
                    setState(() {
                      _dragValue = value;
                    });
                    if (widget.onChanged != null) {
                      widget.onChanged!(Duration(milliseconds: value.round()));
                    }
                  },
                  onChangeEnd: (value) {
                    if (widget.onChangeEnd != null) {
                      widget.onChangeEnd!(Duration(milliseconds: value.round()));
                    }
                    _dragValue = null;
                  },
                ),
              ),
            ),
          ],
        ),
        SliderTheme(
          data: _sliderThemeData.copyWith(
            inactiveTrackColor: widget.isMessageReceived ? Colors.black12 : Colors.white30,
            activeTrackColor: widget.isMessageReceived ? Colors.black : Colors.white,
            thumbColor: widget.isMessageReceived ? Colors.black87 : Colors.white,
          ),
          child: Slider(
            min: 0.0,
            max: widget.duration.inMilliseconds.toDouble(),
            // value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(), widget.duration.inMilliseconds.toDouble()),
            value: (widget.position.inMilliseconds.toDouble() >= widget.duration.inMilliseconds.toDouble())
                ? 0.0
                : min(_dragValue ?? widget.position.inMilliseconds.toDouble(), widget.duration.inMilliseconds.toDouble()),
            onChanged: (value) {
              setState(() {
                _dragValue = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(Duration(milliseconds: value.round()));
              }
            },
            onChangeEnd: (value) {
              if (widget.onChangeEnd != null) {
                widget.onChangeEnd!(Duration(milliseconds: value.round()));
              }
              _dragValue = null;
            },
          ),
        ),
        Positioned(
          right: 16.0,
          bottom: -2,
          left: 25,
          // top: 0,
          child: Text(
              (widget.position.inMilliseconds.toDouble() >= widget.duration.inMilliseconds.toDouble())
                  ? "${(widget.position - widget.duration).toString().substring(0, 7)} / ${widget.duration.toString().substring(0, 7)}"
                  : " ${widget.position.toString().substring(0, 7)} / ${widget.duration.toString().substring(0, 7)}",
              //   RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
              //       .firstMatch("${_remaining}")
              //       ?.group(1) ??
              //       '${widget.duration} / ${widget.position}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: widget.isMessageReceived ? null : Colors.white)),
        ),
      ],
    );
  }

}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {}
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

void showSliderDialog({
  required BuildContext context,
  required String title,
  required int divisions,
  required double min,
  required double max,
  String valueSuffix = '',
  // TODO: Replace these two by ValueStream.
  required double value,
  required Stream<double> stream,
  required ValueChanged<double> onChanged,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => SizedBox(
          height: 100.0,
          child: Column(
            children: [
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix', style: const TextStyle(fontFamily: 'Fixed', fontWeight: FontWeight.bold, fontSize: 24.0)),
              Slider(
                divisions: divisions,
                min: min,
                max: max,
                value: snapshot.data ?? value,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

T? ambiguate<T>(T? value) => value;
