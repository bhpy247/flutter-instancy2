import 'package:flutter/material.dart';

class CommonIconButton extends StatelessWidget {
  final IconData iconData;
  final double iconSize;
  final Color? backgroundColor;
  final Color? iconColor;
  final GestureTapCallback? onTap;
  final double padding;

  const CommonIconButton({
    Key? key,
    required this.iconData,
    this.iconSize = 26,
    this.backgroundColor,
    this.iconColor,
    this.onTap,
    this.padding = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
        ),
        child: Icon(
          iconData,
          size: iconSize,
          color: iconColor,
        ),
      ),
    );
  }
}
