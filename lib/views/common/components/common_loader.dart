import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CommonLoader extends StatelessWidget {
  final double size, lineWidth;
  final Color? color;
  final bool isCenter;

  const CommonLoader({
    Key? key,
    this.size = 70,
    this.lineWidth = 2,
    this.color,
    this.isCenter = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    Widget widget = SpinKitDualRing(
      size: size,
      color: color ?? themeData.primaryColor,
      lineWidth: lineWidth,
      duration: const Duration(milliseconds: 500),
    );

    /*return SpinKitThreeBounce(
      size: size,
      color: themeData.primaryColor,
    );*/

    if(isCenter) {
      return Center(child: widget,);
    }
    else {
      return widget;
    }
  }
}
