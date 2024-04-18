import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/views/co_create_learning/component/size_utils.dart';
import 'package:flutter_instancy_2/views/co_create_learning/component/theme_helper.dart';

class AppDecoration {
  // Fill decorations
  static BoxDecoration get fillGreen => BoxDecoration(
        color: appTheme.green800,
      );

  static BoxDecoration get fillGreen200 => BoxDecoration(
        color: appTheme.green200,
      );

  static BoxDecoration get fillWhiteA => BoxDecoration(
        color: appTheme.whiteA700,
      );

// Outline decorations
  static BoxDecoration get outlineBlack => BoxDecoration(
        color: appTheme.whiteA700,
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withOpacity(0.15),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(
              0,
              -1,
            ),
          )
        ],
      );

  static BoxDecoration get outlineGray => BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: appTheme.gray400,
            width: 1.h,
          ),
        ),
      );
}

class BorderRadiusStyle {
  // Custom borders
  static BorderRadius get customBorderTL12 => BorderRadius.vertical(
        top: Radius.circular(12.h),
      );

  static BorderRadius get customBorderTL25 => BorderRadius.vertical(
        top: Radius.circular(25.h),
      );

// Rounded borders
  static BorderRadius get roundedBorder3 => BorderRadius.circular(
        3.h,
      );
}
