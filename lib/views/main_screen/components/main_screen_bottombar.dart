import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/native_menu_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainScreenBottomBar extends StatelessWidget {
  final NativeMenuModel? selectedMenuModel;
  final List<NativeMenuModel> menusList;
  final bool hasMoreMenus;
  final void Function({required NativeMenuModel nativeMenuModel})? onMenuTap;
  final void Function()? onMoreMenuTap;

  const MainScreenBottomBar({
    Key? key,
    required this.selectedMenuModel,
    required this.menusList,
    required this.hasMoreMenus,
    this.onMenuTap,
    this.onMoreMenuTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    int currentIndex = selectedMenuModel != null ? menusList.indexOf(selectedMenuModel!) : 0;
    if(currentIndex < 0 || currentIndex >= menusList.length) {
      currentIndex = 0;
    }

    return BottomNavigationBar(
      showSelectedLabels: true,
      showUnselectedLabels: true,
      backgroundColor: themeData.appBarTheme.backgroundColor,
      elevation: 20,
      onTap: (int index) {
        if(index < menusList.length) {
          if(onMenuTap != null) onMenuTap!(nativeMenuModel: menusList[index]);
        }
        else {
          if(onMoreMenuTap != null) onMoreMenuTap!();
        }
      },
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
      items: [
        ...menusList.map((e) {
          String icon = e.image;

          return BottomNavigationBarItem(
            label: e.displayname,
            icon: Icon(
              (icon.isNotEmpty)
                  ? icon.contains("-")
                  ? IconDataSolid(int.parse('0x${"f02d"}'))
                  : IconDataSolid(int.parse('0x$icon'))
                  : IconDataSolid(int.parse('0x${"f02d"}')),
              color: selectedMenuModel == e ? themeData.primaryColor : null,
            ),
          );
        }).toList(),
        if(hasMoreMenus) const BottomNavigationBarItem(
          label: "More",
          icon: Icon(
            Icons.apps,
            color: null,
          ),
        ),
      ],
    );
  }
}
