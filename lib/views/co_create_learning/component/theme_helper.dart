import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/views/co_create_learning/component/size_utils.dart';

String _appTheme = "primary";

PrimaryColors get appTheme => ThemeHelper().themeColor();

ThemeData get theme => ThemeHelper().themeData();

/// Helper class for managing themes and colors.
// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class ThemeHelper {
  // A map of custom color themes supported by the app
  Map<String, PrimaryColors> _supportedCustomColor = {'primary': PrimaryColors()};

// A map of color schemes supported by the app
  Map<String, ColorScheme> _supportedColorScheme = {'primary': ColorSchemes.primaryColorScheme};

  /// Changes the app theme to [_newTheme].
  void changeTheme(String _newTheme) {
    _appTheme = _newTheme;
  }

  /// Returns the primary colors for the current theme.
  PrimaryColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? PrimaryColors();
  }

  /// Returns the current theme data.
  ThemeData _getThemeData() {
    var colorScheme = _supportedColorScheme[_appTheme] ?? ColorSchemes.primaryColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(colorScheme),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: appTheme.green800,
      ),
    );
  }

  /// Returns the primary colors for the current theme.
  PrimaryColors themeColor() => _getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}

/// Class containing the supported text theme styles.
class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
        bodyMedium: TextStyle(
          color: appTheme.gray60003,
          fontSize: 14.fSize,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: appTheme.gray500,
          fontSize: 11.fSize,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
        ),
        labelMedium: TextStyle(
          color: appTheme.gray60001,
          fontSize: 10.fSize,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: appTheme.whiteA700,
          fontSize: 9.fSize,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: appTheme.whiteA700,
          fontSize: 22.fSize,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: appTheme.black900,
          fontSize: 16.fSize,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: appTheme.gray800,
          fontSize: 14.fSize,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w600,
        ),
      );
}

/// Class containing the supported color schemes.
class ColorSchemes {
  static final primaryColorScheme = ColorScheme.light();
}

/// Class containing custom colors for a primary theme.
class PrimaryColors {
  // Black
  Color get black900 => Color(0XFF000000);

// Gray
  Color get gray300 => Color(0XFFDCDCDC);

  Color get gray400 => Color(0XFFBEBCBC);

  Color get gray500 => Color(0XFF9AA0A6);

  Color get gray600 => Color(0XFF757575);

  Color get gray60001 => Color(0XFF746967);

  Color get gray60003 => Color(0XFF848484);

  Color get gray800 => Color(0XFF444641);

  Color get gray900 => Color(0XFF242424);

// Green
  Color get green200 => Color(0XFFADE79A);

  Color get green500 => Color(0XFF3AB25A);

  Color get green800 => Color(0XFF2BA700);

// Red
  Color get red500 => Color(0XFFF43C3C);

// White
  Color get whiteA700 => Color(0XFFFFFFFF);

// Yellow
  Color get yellow700 => Color(0XFFF0C019);
}
