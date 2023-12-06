import 'dart:math';
import 'dart:ui';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:provider/provider.dart';

import '../../../backend/app/app_provider.dart';
import '../../../backend/configurations/app_configuration_operations.dart';
import '../../../models/gamification/data_model/game_activity_badge_data_model.dart';
import '../../common/components/common_cached_network_image.dart';

class BadgeEarnDialog extends StatefulWidget {
  final GameActivityBadgeDataModel badgeDataModel;
  final String gameName;

  const BadgeEarnDialog({
    super.key,
    required this.badgeDataModel,
    required this.gameName,
  });

  @override
  State<BadgeEarnDialog> createState() => BadgeEarnDialogState();
}

class BadgeEarnDialogState extends State<BadgeEarnDialog> with TickerProviderStateMixin, MySafeState {
  late ConfettiController _controllerCenter;

  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    _controllerCenter = ConfettiController(duration: const Duration(seconds: 1));
    _controllerCenter.play();

    animationController = AnimationController(
      vsync: this,
      upperBound: 150,
      lowerBound: 120,
      value: 120,
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 400),
      animationBehavior: AnimationBehavior.preserve,
    );
    animationController.forward().then((value) {
      animationController.reverse().then((value) {
        animationController.forward();
      });
    });
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
    super.pageBuild();

    String badgeUrl = AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(
      imagePath: widget.badgeDataModel.badgeImageUrl,
    );

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
              // color: Colors.grey.withOpacity(.25),
              color: Color(0xff00C1A2).withOpacity(.1),
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
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 150,
                        child: Center(
                          child: AnimatedBuilder(
                            animation: animationController,
                            builder: (BuildContext context, Widget? child) {
                              return SizedBox(
                                height: animationController.value,
                                child: CommonCachedNetworkImage(
                                  imageUrl: badgeUrl,
                                  // imageUrl: "https://t4.ftcdn.net/jpg/03/50/11/83/360_F_350118359_fs2GIXzHjBhStQtRXq4yI927EcSxfS9A.jpg",
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      /*Text(
                        widget.badgeDataModel.badgeName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff007D7C),
                          letterSpacing: 1.3,
                        ),
                      ),*/
                      Text(
                        widget.badgeDataModel.badgeMessage,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff007D7C),
                          letterSpacing: 1.1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      // const SizedBox(
                      //   height: 5,
                      // ),
                      // const Text(
                      //   "Congratulations! You've reached new heights—keep soaring!",
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 1.3),
                      // )
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
