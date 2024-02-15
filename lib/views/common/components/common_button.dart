import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final Function()? onPressed;
  final String text;
  final IconData? iconData;
  final EdgeInsets? iconPadding, padding, margin;
  final Widget? child;
  final FontWeight fontWeight;
  final TextAlign? textAlign;
  final Color? iconColor, backGroundColor, fontColor, borderColor, highlightColor;
  final double? iconSize, fontSize, minWidth, borderRadius, borderWidth;
  final double? height;

  const CommonButton({
    Key? key,
    required this.onPressed,
    this.text = "",
    this.iconData,
    this.borderRadius = 5,
    this.minWidth,
    this.height,
    this.iconSize = 20,
    this.textAlign,
    this.iconColor,
    this.fontSize = 14,
    this.fontColor,
    this.fontWeight = FontWeight.w400,
    this.highlightColor = Colors.white12,
    this.backGroundColor,
    this.iconPadding,
    this.padding,
    this.margin,
    this.child,
    this.borderWidth = 0.5,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    /*return MaterialButton(
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
        borderRadius: borderRadius != null ? BorderRadius.circular(borderRadius!) : BorderRadius.zero,
        side: BorderSide(color: borderColor ?? Colors.grey, width: borderWidth ?? 0.5),
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
    );*/

    return Container(
      margin: margin,
      child: InkWell(
        onTap: onPressed,
        highlightColor: highlightColor,
        child: Container(
          height: height,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          constraints: BoxConstraints(
            minWidth: minWidth ?? 0,
          ),
          decoration: BoxDecoration(
            color: backGroundColor ?? themeData.primaryColor,
            borderRadius: borderRadius != null ? BorderRadius.circular(borderRadius!) : null,
            border: Border.all(
              color: borderColor ?? Colors.grey,
              width: borderWidth ?? 0.5,
            ),
          ),
          child: child ??
              Row(
                mainAxisSize: MainAxisSize.min,
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
                  Flexible(
                    child: Text(
                      text,
                      textAlign: textAlign,
                      style: TextStyle(
                        color: fontColor,
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                      ),
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
