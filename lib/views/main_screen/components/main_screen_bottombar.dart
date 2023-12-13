import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app_theme/style.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/native_menu_model.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainScreenBottomBar extends StatefulWidget {
  final NativeMenuModel? selectedMenuModel;
  final List<NativeMenuModel> menusList;
  final bool hasMoreMenus;
  final bool isCenterDocked;
  final void Function({required NativeMenuModel nativeMenuModel})? onMenuTap;
  final void Function()? onMoreMenuTap;

  const MainScreenBottomBar({
    Key? key,
    required this.selectedMenuModel,
    required this.menusList,
    required this.hasMoreMenus,
    this.isCenterDocked = false,
    this.onMenuTap,
    this.onMoreMenuTap,
  }) : super(key: key);

  @override
  State<MainScreenBottomBar> createState() => _MainScreenBottomBarState();
}

class _MainScreenBottomBarState extends State<MainScreenBottomBar> with MySafeState {
  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    int currentIndex = widget.selectedMenuModel != null ? widget.menusList.indexOf(widget.selectedMenuModel!) : 0;
    if (currentIndex < 0 || currentIndex >= widget.menusList.length) {
      currentIndex = 0;
    }
    // return newBottomBar(context);

    return BottomAppBar(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black,
      notchMargin: 6,
      elevation: 10,
      height: 70,
      shape: const CircularNotchedRectangle(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...getButtonsList(menus: widget.menusList),
            if (widget.hasMoreMenus)
              Expanded(
                child: getBottomBarButton(
                  text: "More",
                  icon: Icons.apps,
                  iconSize: 22,
                  onTap: () {
                    if (widget.onMoreMenuTap != null) widget.onMoreMenuTap!();
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Iterable<Widget> getButtonsList({required List<NativeMenuModel> menus}) sync* {
    for (int index = 0; index < menus.length; index++) {
      NativeMenuModel model = widget.menusList[index];

      String icon = model.image;

      yield Expanded(
        child: Container(
          // color: Colors.red,
          /*margin: EdgeInsets.only(
            right: index == 1 ? 20 : 0,
            left: index == 2 ? 20 : 0,
          ),*/
          child: getBottomBarButton(
            text: model.displayname,
            icon: (icon.isNotEmpty)
                ? icon.contains("-")
                    ? IconDataSolid(int.parse('0x${"f02d"}'))
                    : IconDataSolid(int.parse('0x$icon'))
                : IconDataSolid(int.parse('0x${"f02d"}')),
            onTap: () {
              if (widget.onMenuTap != null) widget.onMenuTap!(nativeMenuModel: model);
            },
          ),
        ),
      );

      if (widget.isCenterDocked && index == 1 && menus.length >= 3) {
        yield const Expanded(child: SizedBox());
      }
    }
  }

  Widget getBottomBarButton({
    required String text,
    required IconData icon,
    double? fontSize,
    double? iconSize,
    void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) onTap();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: iconSize != null ? (iconSize ?? 18) - 3 : null,
            child: Icon(
              icon,
              color: Styles.chipTextColor,
              size: iconSize ?? 18,
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: Text(
              // "",
              text,
              style: themeData.textTheme.labelSmall?.copyWith(
                color: Styles.chipTextColor,
                fontSize: fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget newBottomBar(context) {
    int currentIndex = widget.selectedMenuModel != null ? widget.menusList.indexOf(widget.selectedMenuModel!) : 0;
    if (currentIndex < 0 || currentIndex >= widget.menusList.length) {
      currentIndex = 0;
    }
    return BottomBarCreative(
      items: [
        ...widget.menusList.map((e) {
          String icon = e.image;
          return TabItem(
            title: e.displayname,

            icon: (icon.isNotEmpty)
                ? icon.contains("-")
                    ? IconDataSolid(int.parse('0x${"f02d"}'))
                    : IconDataSolid(int.parse('0x$icon'))
                : IconDataSolid(int.parse('0x${"f02d"}')),
            // color: selectedMenuModel == e ? themeData.primaryColor : null,
          );
        }).toList(),
        if (widget.hasMoreMenus)
          const TabItem(
            title: "More",
            icon: Icons.apps,
          ),
      ],
      backgroundColor: Colors.green.withOpacity(0.21),
      color: const Color(0XFF7AC0FF),
      colorSelected: const Color(0XFF0686F8),
      indexSelected: currentIndex,
      // highlightStyle: widget.highlightStyle,
      // isFloating: widget.isFloating ?? false,
      onTap: (int index) {
        if (index < widget.menusList.length) {
          if (widget.onMenuTap != null) widget.onMenuTap!(nativeMenuModel: widget.menusList[index]);
        } else {
          if (widget.onMoreMenuTap != null) widget.onMoreMenuTap!();
        }
      },
    );
  }
}
