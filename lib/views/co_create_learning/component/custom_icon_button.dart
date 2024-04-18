import 'package:flutter/material.dart';

extension IconButtonStyleHelper on CustomIconButton {
  static BoxDecoration get outlineBlackTL12 => BoxDecoration(
        color: Colors.white.withOpacity(.5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset(
              0,
              0,
            ),
          )
        ],
      );
}

class CustomIconButton extends StatelessWidget {
  CustomIconButton({Key? key, this.alignment, this.height, this.width, this.padding, this.decoration, this.child, this.onTap})
      : super(
          key: key,
        );

  final Alignment? alignment;

  final double? height;

  final double? width;

  final EdgeInsetsGeometry? padding;

  final BoxDecoration? decoration;

  final Widget? child;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return alignment != null ? Align(alignment: alignment ?? Alignment.center, child: iconButtonWidget) : iconButtonWidget;
  }

  Widget get iconButtonWidget => SizedBox(
        height: height ?? 0,
        width: width ?? 0,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Container(
            height: height ?? 0,
            width: width ?? 0,
            padding: padding ?? EdgeInsets.zero,
            decoration: decoration,
            child: child,
          ),
          onPressed: onTap,
        ),
      );
}
