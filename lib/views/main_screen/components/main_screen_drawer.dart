import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/app_theme/app_theme_provider.dart';
import 'package:flutter_instancy_2/backend/main_screen/main_screen_provider.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/native_menu_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'main_screen_drawer_header.dart';

class MainScreenDrawer extends StatelessWidget {
  final AppProvider appProvider;
  final MainScreenProvider mainScreenProvider;
  final List<NativeMenuModel> menusList;

  const MainScreenDrawer({
    Key? key,
    required this.appProvider,
    required this.mainScreenProvider,
    required this.menusList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    List<NativeMenuModel> allMenusList = appProvider.getMenuModelsList();

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      // backgroundColor: themeData.primaryColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const MainScreenDrawerHeaderWidget(),
            Container(
              color: themeData.drawerTheme.backgroundColor,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 20),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: menusList.length,
                itemBuilder: (BuildContext context, int index) {
                  return getSingleMenuItem(
                    context: context,
                    themeData: themeData,
                    nativeMenuModel: menusList[index],
                    allMenusList: allMenusList,
                    index: index,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getSingleMenuItem({
    required BuildContext context,
    required ThemeData themeData,
    required NativeMenuModel nativeMenuModel,
    required List<NativeMenuModel> allMenusList,
    required int index,
  }) {
    /*if(!AppConfigurationOperations(appProvider: appProvider).checkMenuAvailable(menuId: nativeMenuModel.menuid)) {
      return const SizedBox();
    }*/
    String icon = nativeMenuModel.image;

    List<Widget> childWidgetsList = buildChildMenusList(
      context: context,
      nativeMenuModel: nativeMenuModel,
      allMenusList: allMenusList,
    );

    AppThemeProvider appThemeProvider = Provider.of<AppThemeProvider>(context, listen: false);

    bool isMenuSelected = mainScreenProvider.getAppBarTitle() == nativeMenuModel.displayname;

    return Theme(
      data: themeData.copyWith(
        iconTheme: themeData.iconTheme.copyWith(
          size: 22,
          color: appThemeProvider.getInstancyThemeColors().menuTextColor.isNotEmpty ? appThemeProvider.getInstancyThemeColors().menuTextColor.getColor() : null,
        ),
        textTheme: themeData.textTheme.copyWith(
          labelMedium: themeData.textTheme.labelMedium
              ?.copyWith(color: appThemeProvider.getInstancyThemeColors().menuTextColor.isNotEmpty ? appThemeProvider.getInstancyThemeColors().menuTextColor.getColor() : null),
        ),
      ),
      child: ExpansionTile(
        onExpansionChanged: (bool? value) {
          MyPrint.printOnConsole("onExpansionChanged called with value:$value");

          if (childWidgetsList.isEmpty) {
            mainScreenProvider.setSelectedMenu(
              menuModel: nativeMenuModel,
              appProvider: appProvider,
              appThemeProvider: Provider.of<AppThemeProvider>(context, listen: false),
            );
            Navigator.pop(context);
          }
        },
        leading: Icon(
          (icon.isNotEmpty)
              ? icon.contains("-")
                  ? IconDataSolid(int.parse('0x${"f02d"}'))
                  : IconDataSolid(int.parse('0x$icon'))
              : IconDataSolid(int.parse('0x${"f02d"}')),
          color: isMenuSelected ? themeData.primaryColor : null,
        ),
        trailing: childWidgetsList.isEmpty
            ? Icon(
                Icons.arrow_drop_down,
                color: appThemeProvider.getInstancyThemeColors().menuBGColor.getColor(),
              )
            : const Icon(Icons.keyboard_arrow_down),
        title: Text(
          nativeMenuModel.displayname,
          style: themeData.textTheme.labelMedium?.copyWith(
            color: isMenuSelected ? themeData.primaryColor : null,
          ),
        ),
        children: <Widget>[
          Column(
            children: childWidgetsList,
          )
        ],
      ),
    );
  }

  List<Widget> buildChildMenusList({
    required BuildContext context,
    required NativeMenuModel nativeMenuModel,
    required List<NativeMenuModel> allMenusList,
  }) {
    List<Widget> list = allMenusList.where((element) => element.parentmenuid == nativeMenuModel.menuid).map((e) {
      MyPrint.printOnConsole("Module: ${e.displayname} : ${e.menuid}");
      return InkWell(
        onTap: () {
          mainScreenProvider.setSelectedMenu(
            menuModel: nativeMenuModel,
            appProvider: appProvider,
            appThemeProvider: Provider.of<AppThemeProvider>(context, listen: false),
          );
          Navigator.pop(context);
        },
        child: ListTile(
          title: Text(
            e.displayname,
          ),
          leading: const Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
          ),
        ),
      );
    }).toList();

    return list;
  }
}
