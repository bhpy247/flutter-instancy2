import 'dart:math';
import 'dart:ui';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../models/gamification/data_model/game_activity_points_data_model.dart';
import '../../../utils/parsing_helper.dart';

class PointEarnDialog extends StatefulWidget {
  final GameActivityPointsDataModel pointDataList;
  final String gameName;

  const PointEarnDialog({
    super.key,
    required this.pointDataList,
    required this.gameName,
  });

  @override
  State<PointEarnDialog> createState() => _PointEarnDialogState();
}

class _PointEarnDialogState extends State<PointEarnDialog> {
  late ConfettiController _controllerCenter;

  @override
  void initState() {
    super.initState();
    _controllerCenter = ConfettiController(duration: const Duration(seconds: 1));
    _controllerCenter.play();
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step), halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep), halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.transparent,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controllerCenter,
              blastDirectionality: BlastDirectionality.explosive,

              // don't specify a direction, blast randomly
              shouldLoop: false,
              maxBlastForce: 20,
              minBlastForce: 10,

              numberOfParticles: 50,
              displayTarget: false,

              // start again as soon as the animation is finished
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
              // manually specify the colors to be used
              // createParticlePath: drawStar,

              // blastDirection: 30,
              // child: efine a custom shape/path.
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              // color: const Color(0xff00C1A2).withOpacity(.15),
              color: const Color(0xff00C1A2).withOpacity(.1),
              // color: Colors.grey.withOpacity(.25),
              // color: Color(0xff00C1A2).withOpacity(.1),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.gameName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff007D7C),
                          letterSpacing: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Center(
                            child: Lottie.asset(
                              'assets/lottie/point1.json',
                              fit: BoxFit.cover,
                              animate: true,
                            ),
                          ),
                          Center(
                            child: Text(
                              ParsingHelper.parseStringMethod(widget.pointDataList.pointCount),
                              style: const TextStyle(
                                fontSize: 30,
                                color: Color(0xff2DA44E),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget.pointDataList.pointMessage,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff007D7C),
                          letterSpacing: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
