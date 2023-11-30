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
    this.iconPadding,
    this.padding,
    this.child,
    this.borderWidth = 0.5,
    this.borderColor,
  }) : super(key: key);

  final Function()? onPressed;
  final String text;
  final IconData? iconData;
  final EdgeInsets? iconPadding, padding;
  final Widget? child;
  final FontWeight fontWeight;
  final Color? iconColor, backGroundColor, fontColor, borderColor, highlightColor;
  final double iconSize, fontSize, minWidth, borderRadius, borderWidth;
  final double? height;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return InkWell(
      onTap: onPressed,
      highlightColor: highlightColor,
      child: Container(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        constraints: BoxConstraints(
          minWidth: minWidth,
        ),
        decoration: BoxDecoration(
          color: backGroundColor ?? themeData.primaryColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: borderColor ?? Colors.grey,
            width: borderWidth,
          ),
        ),
        child: Center(
          child: child ??
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (iconData != null)
                    Container(
                      margin: iconPadding ?? const EdgeInsets.symmetric(horizontal: 5),
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
        ),
      ),
    );
  }
}
