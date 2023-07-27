import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    Key? key,
    required this.onPressed,
    this.text = "",
    this.iconData,
    this.borderRadius = 5,
    this.minWidth = 80,
    this.height,
    this.iconSize = 20,
    this.iconColor = Colors.black,
    this.fontSize = 14,
    this.fontColor = Colors.black,
    this.fontWeight = FontWeight.w400,
    this.highlightColor = Colors.white12,
    this.backGroundColor,
    this.iconPadding = const EdgeInsets.symmetric(horizontal: 5),
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    this.child,
    this.borderColor,
  }) : super(key: key);

  final Function()? onPressed;
  final String text;
  final IconData? iconData;
  final EdgeInsets? iconPadding, padding;
  final Widget? child;
  final FontWeight fontWeight;
  final Color? iconColor, backGroundColor, fontColor, borderColor, highlightColor;
  final double iconSize, fontSize, minWidth, borderRadius;
  final double? height;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return MaterialButton(
      onPressed: onPressed,
      padding: padding,
      highlightColor: highlightColor,
      minWidth: minWidth,
      elevation: 0,
      height: height,
      highlightElevation: 0,
      hoverElevation: 0,
      color: backGroundColor ?? themeData.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(color: borderColor ?? Colors.grey, width: 0.5),
      ),
      child: child ?? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if(iconData != null) Container(
            margin: iconPadding,
            child: Icon(
              iconData,
              size: iconSize,
              color: iconColor,
            ),
          ),
          Text(
            text,
            style: TextStyle(
              color: fontColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
        ],
      ),
    );
  }
}
