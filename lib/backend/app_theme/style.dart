import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';

class Styles {
  Color lightPrimaryColor = Colors.black;
  Color darkPrimaryColor = Colors.white;

  Color lightPrimaryVariant = Colors.black;
  Color darkPrimaryVariant = Colors.white;

  Color lightSecondaryColor = Colors.black54;
  Color darkSecondaryColor = Colors.white60;

  Color lightSecondaryVariant = Colors.black54;
  Color darkSecondaryVariant = Colors.white60;

  Color lightAppBarTextColor = const Color(0xff495057);
  Color darkAppBarTextColor = const Color(0xffffffff);

  Color lightTextColor = const Color(0xff4a4c4f);
  Color darkTextColor = Colors.white;

  Color lightBackgroundColor = Colors.grey.shade100;
  Color darkBackgroundColor = Colors.black;

  Color lightAppBarColor = const Color(0xffffffff);
  Color darkAppBarColor = const Color(0xff2e343b);

  Color cardColor = const Color(0xfff0f0f0);

  double buttonBorderRadius = 5;

  static const Color textColor = Colors.white;
  static const Color actionIconColor = Colors.white;
  static const Color leadingBack = Colors.white;
  static const Color backgroundColor = Colors.white;
  static const Color progressbarCompletedColor = Color(0xff013FCC);
  static const Color textFieldBorderColor = Color(0xffDCDCDC);

  static const Color chipBackgroundColor = Color(0xffE9E9E9);
  static const Color borderColor = Color(0xffDFDFDF);

  static const Color starYellowColor = Color(0xffF0C119);
  static const Color lightTextColor2 = Color(0xff757575);
  static const Color bottomSheetIconColor = Color(0xff212429);
  static const Color discussionTileIconColor = Color(0xff808080);
  static const Color expansionTileBackground = Color(0xffF8F8F8);
  static const Color indicatorIconColor = Color(0xff444641);
  static const Color notificationIconColor = Colors.white;
  static const Color chipTextColor = Color(0xff3A3A3A);
  static const Color textFieldBackgroundColor = Color(0xffF6F6F6);

  static const Color chatTextBackgroundColor = Color(0xffEBEBEB);
  static const Color iconColor = Color(0xff808080);
  static const Color lightGreyTextColor = Color(0xff757575);
  static const Color linearProgressBarBackgroundColor = Color(0xffC7D3EB);

  // static const Color  = Color(0xffF0C119);

  //Shimmer Color
  static Color shimmerHighlightColor = const Color(0xfff2f2f2);
  static const Color shimmerBaseColor = Color(0xffb6b6b6);
  static Color shimmerContainerColor = const Color(0xffc2c2c2);

  @override
  String toString() {
    return MyUtils.encodeJson({
      "lightPrimaryColor" : lightPrimaryColor.toHex(),
      "darkPrimaryColor" : darkPrimaryColor.toHex(),
      "lightPrimaryVariant" : lightPrimaryVariant.toHex(),
      "darkPrimaryVariant" : darkPrimaryVariant.toHex(),
      "lightSecondaryColor" : lightSecondaryColor.toHex(),
      "darkSecondaryColor" : darkSecondaryColor.toHex(),
      "lightSecondaryVariant" : lightSecondaryVariant.toHex(),
      "darkSecondaryVariant" : darkSecondaryVariant.toHex(),
      "lightAppBarTextColor" : lightAppBarTextColor.toHex(),
      "darkAppBarTextColor" : darkAppBarTextColor.toHex(),
      "lightTextColor" : lightTextColor.toHex(),
      "darkTextColor" : darkTextColor.toHex(),
      "lightBackgroundColor" : lightBackgroundColor.toHex(),
      "darkBackgroundColor" : darkBackgroundColor.toHex(),
      "lightAppBarColor" : lightAppBarColor.toHex(),
      "darkAppBarColor" : darkAppBarColor.toHex(),
    });
  }
}