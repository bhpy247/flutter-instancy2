import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CourseOfflineSyncingLoaderWidget extends StatelessWidget {
  final double size;
  final double boxSize;
  final bool isCenter;

  const CourseOfflineSyncingLoaderWidget({
    Key? key,
    this.size = 100,
    this.boxSize = 150,
    this.isCenter = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    Widget widget = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: boxSize,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/lottie/syncing_animation.json',
              width: size,
              // fit: BoxFit.fill,
              delegates: LottieDelegates(
                values: [
                  ValueDelegate.color(
                    // keyPath order: ['layer name', 'group name', 'shape name']
                    ['**', '33 - Sync Cloud', '**'],
                    value: Colors.transparent,
                  ),
                  ValueDelegate.color(
                    // keyPath order: ['layer name', 'group name', 'shape name']
                    ['**', 'Add_cloud Outlines', '**'],
                    value: themeData.primaryColor,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 0),
            Text(
              "Please wait while we syncing data",
              style: themeData.textTheme.labelMedium?.copyWith(),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    if (isCenter) {
      return Center(
        child: widget,
      );
    } else {
      return widget;
    }
  }
}
