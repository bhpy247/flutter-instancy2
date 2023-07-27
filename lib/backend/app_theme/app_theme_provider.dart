import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app_theme/app_theme.dart';
import 'package:flutter_instancy_2/backend/app_theme/style.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/instancy_theme_colors.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';

class AppThemeProvider extends ChangeNotifier {
  bool _darkThemeMode = false;

  bool get darkThemeMode => _darkThemeMode;

  void setDarkThemeMode({bool isDarkThemeEnabled = false, bool isNotify = true}) {
    _darkThemeMode = isDarkThemeEnabled;
    if(isNotify) notifyListeners();
  }

  void resetThemeMode({bool isNotify = true}) {
    _darkThemeMode = false;
    if(isNotify) notifyListeners();
  }

  InstancyThemeColors _instancyThemeColors = InstancyThemeColors();

  InstancyThemeColors getInstancyThemeColors() => _instancyThemeColors;

  void setInstancyThemeColors({required InstancyThemeColors instancyThemeColors, bool isUpdateTheme = true, bool isNotify = true}) {
    _instancyThemeColors = instancyThemeColors;
    if(isUpdateTheme) {
      _lightTheme = null;
      _darkTheme = null;
    }
    if(isNotify) notifyListeners();
  }

  //region ThemeData
  Styles getStylesFromInstancyThemeColors({required InstancyThemeColors instancyThemeColors}) {
    MyPrint.printOnConsole("getStylesFromInstancyThemeColors called");

    Styles styles = Styles();

    if(instancyThemeColors.appButtonBgColor.isNotEmpty) styles.lightPrimaryColor = HexColor.fromHex(instancyThemeColors.appButtonBgColor);
    if(instancyThemeColors.appButtonBgColor.isNotEmpty) styles.darkPrimaryColor = HexColor.fromHex(instancyThemeColors.appButtonBgColor);

    if(instancyThemeColors.appButtonBgColor.isNotEmpty) styles.lightPrimaryVariant = HexColor.fromHex(instancyThemeColors.appButtonBgColor);
    if(instancyThemeColors.appButtonBgColor.isNotEmpty) styles.darkPrimaryVariant = HexColor.fromHex(instancyThemeColors.appButtonBgColor);

    if(instancyThemeColors.appButtonBgColor.isNotEmpty) styles.lightSecondaryColor = HexColor.fromHex(instancyThemeColors.appButtonBgColor);
    if(instancyThemeColors.appButtonBgColor.isNotEmpty) styles.darkSecondaryColor = HexColor.fromHex(instancyThemeColors.appButtonBgColor);

    if(instancyThemeColors.appButtonBgColor.isNotEmpty) styles.lightSecondaryVariant = HexColor.fromHex(instancyThemeColors.appButtonBgColor);
    if(instancyThemeColors.appButtonBgColor.isNotEmpty) styles.darkSecondaryVariant = HexColor.fromHex(instancyThemeColors.appButtonBgColor);

    styles.buttonBorderRadius = instancyThemeColors.buttonBorderRadius;

    if(instancyThemeColors.appTextColor.isNotEmpty) styles.lightTextColor = HexColor.fromHex(instancyThemeColors.appTextColor);
    if(instancyThemeColors.appTextColor.isNotEmpty) styles.darkTextColor = HexColor.fromHex(instancyThemeColors.appTextColor);

    if(instancyThemeColors.appBGColor.isNotEmpty) styles.lightBackgroundColor = HexColor.fromHex(instancyThemeColors.appBGColor);
    if(instancyThemeColors.appBGColor.isNotEmpty) styles.darkBackgroundColor = HexColor.fromHex(instancyThemeColors.appBGColor);

    if(instancyThemeColors.appHeaderColor.isNotEmpty) {
      styles.lightAppBarColor = HexColor.fromHex(instancyThemeColors.appHeaderColor);
      styles.darkAppBarColor = HexColor.fromHex(instancyThemeColors.appHeaderColor);
    }
    if(instancyThemeColors.appHeaderTextColor.isNotEmpty) {
      styles.lightAppBarTextColor = HexColor.fromHex(instancyThemeColors.appHeaderTextColor);
      styles.darkAppBarTextColor = HexColor.fromHex(instancyThemeColors.appHeaderTextColor);
    }

    // styles.lightBackgroundColor = HexColor.fromHex(instancyThemeColors.appBGColor);
    // styles.darkBackgroundColor = HexColor.fromHex(instancyThemeColors.appBGColor);

    /*styles.lightAppBarTextColor = HexColor.fromHex(instancyThemeColors.appButtonTextColor);
    // styles.darkAppBarTextColor = HexColor.fromHex(instancyThemeColors.appButtonBgColor);

    styles.lightTextColor = HexColor.fromHex(instancyThemeColors.appButtonBgColor);
    styles.darkTextColor = HexColor.fromHex(instancyThemeColors.appButtonBgColor);

    styles.lightBackgroundColor = HexColor.fromHex(instancyThemeColors.appButtonBgColor);
    styles.darkBackgroundColor = HexColor.fromHex(instancyThemeColors.appButtonBgColor);

    styles.lightAppBarColor = HexColor.fromHex(instancyThemeColors.appButtonBgColor);
    styles.darkAppBarColor = HexColor.fromHex(instancyThemeColors.appButtonBgColor);

    styles.cardColor = HexColor.fromHex(instancyThemeColors.appButtonBgColor);*/

    return styles;
  }

  ThemeData? _lightTheme, _darkTheme;

  ThemeData getLightThemeData() {
    // MyPrint.printOnConsole("getLightThemeData called with _lightTheme:$_lightTheme");
    if(_lightTheme == null) {
      MyPrint.printOnConsole("_instancyThemeColors.appButtonBgColor:${_instancyThemeColors.appButtonBgColor}");

      Styles styles = getStylesFromInstancyThemeColors(instancyThemeColors: getInstancyThemeColors());
      MyPrint.printOnConsole("styles:$styles");
      _lightTheme = AppTheme(styles: styles).getLightTheme();
    }
    return _lightTheme!;
  }

  ThemeData getDarkThemeData() {
    if(_darkTheme == null) {
      Styles styles = getStylesFromInstancyThemeColors(instancyThemeColors: getInstancyThemeColors());
      MyPrint.printOnConsole("styles:$styles");
      _darkTheme = AppTheme(styles: styles).getDarkTheme();
    }
    return _darkTheme!;
  }

  ThemeData getThemeData() {
    // MyPrint.printOnConsole("getThemeData calld with darkThemeMode:$darkThemeMode");

    if(darkThemeMode) {
      return getDarkThemeData();
    }
    else {
      return getLightThemeData();
    }
  }
  //endregion
}