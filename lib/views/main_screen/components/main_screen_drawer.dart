import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/app_theme/app_theme_provider.dart';
import 'package:flutter_instancy_2/backend/authentication/authentication_controller.dart';
import 'package:flutter_instancy_2/backend/authentication/authentication_provider.dart';
import 'package:flutter_instancy_2/backend/main_screen/main_screen_provider.dart';
import 'package:flutter_instancy_2/backend/network_connection/network_connection_provider.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
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
  final void Function()? onSubSiteBackButtonTap;

  const MainScreenDrawer({
    Key? key,
    required this.appProvider,
    required this.mainScreenProvider,
    required this.menusList,
    this.onSubSiteBackButtonTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      // backgroundColor: themeData.primaryColor,
      child: Container(
        color: themeData.drawerTheme.backgroundColor,
        child: Consumer2<AppProvider, NetworkConnectionProvider>(
          builder: (BuildContext context, AppProvider appProvider, NetworkConnectionProvider networkConnectionProvider, Widget? child) {
            List<NativeMenuModel> allMenusList = appProvider.getMenuModelsList();

            bool isNetworkConnected = networkConnectionProvider.isNetworkConnected.get();

            List<NativeMenuModel> finalMenusList = menusList.where((NativeMenuModel menuModel) {
              if (["transfer to human agent"].contains(menuModel.displayname.toLowerCase())) {
                return false;
              }
              return true;
              /*// return true;
              return [
                "home",
                "my learning",
                "catalog",
                "learning catalog",
                "classroom events",
                "event catalog",
                "profile",
                "my profile",
                "discussions",
                "discussion forum",
                "discussion forums",
                "my dashboard",
                "settings",
                "messages",
                "my progress report"
                // "transfer to human agent",
              ].contains(menuModel.displayname.toLowerCase());*/
            }).toList();

            if (!isNetworkConnected) {
              finalMenusList.clear();
              NativeMenuModel? menuModel = appProvider.getMenuModelFromComponentId(componentId: InstancyComponents.MyCourseDownloads);
              if (menuModel != null) finalMenusList.add(menuModel);
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  const MainScreenDrawerHeaderWidget(),
                  Container(
                    // color: Colors.red,
                    color: themeData.drawerTheme.backgroundColor,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: finalMenusList.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == finalMenusList.length) {
                          return getSignOutButton(context: context, isNetworkConnected: isNetworkConnected);
                        }

                        return getSingleMenuItem(
                          context: context,
                          themeData: themeData,
                          nativeMenuModel: finalMenusList[index],
                          allMenusList: allMenusList,
                          index: index,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
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

    List<Widget> childWidgetsList = buildChildMenusList(
      context: context,
      nativeMenuModel: nativeMenuModel,
      allMenusList: allMenusList,
    );
    // MyPrint.printOnConsole("childWidgetsList length for ${nativeMenuModel.displayname}:${childWidgetsList.length}");

    AppThemeProvider appThemeProvider = Provider.of<AppThemeProvider>(context, listen: false);

    bool isMenuSelected = mainScreenProvider.getAppBarTitle() == nativeMenuModel.displayname;

    IconData iconData = IconDataSolid(int.parse('0xf02d'));
    if (nativeMenuModel.image.isNotEmpty) {
      int? codePoint = int.tryParse('0x${nativeMenuModel.image}');
      if (codePoint != null) iconData = IconDataSolid(codePoint);
    } else if (nativeMenuModel.menuIconData != null) {
      iconData = nativeMenuModel.menuIconData!;
    }

    return Theme(
      data: themeData.copyWith(
        iconTheme: themeData.iconTheme.copyWith(
          size: 22,
          color: appThemeProvider.getInstancyThemeColors().menuTextColor.isNotEmpty ? appThemeProvider.getInstancyThemeColors().menuTextColor.getColor() : null,
        ),
        textTheme: themeData.textTheme.copyWith(
          labelMedium: themeData.textTheme.labelMedium?.copyWith(
            color: appThemeProvider.getInstancyThemeColors().menuTextColor.isNotEmpty ? appThemeProvider.getInstancyThemeColors().menuTextColor.getColor() : null,
          ),
        ),
      ),
      child: ExpansionTile(
        onExpansionChanged: (bool? value) {
          MyPrint.printOnConsole("onExpansionChanged called with value:$value");

          if (childWidgetsList.isEmpty) {
            if (nativeMenuModel.menuid == -1) {
              MyPrint.printOnConsole("onSubSiteBackButtonTap Clicked");
              if (onSubSiteBackButtonTap != null) {
                onSubSiteBackButtonTap!();
              }
              return;
            }
            mainScreenProvider.setSelectedMenu(
              menuModel: nativeMenuModel,
              appProvider: appProvider,
              appThemeProvider: Provider.of<AppThemeProvider>(context, listen: false),
            );
            Navigator.pop(context);
          }
        },
        trailing: childWidgetsList.isEmpty ? const SizedBox() : const Icon(Icons.keyboard_arrow_down),
        title: Row(
          children: [
            Icon(
              iconData,
              color: isMenuSelected ? themeData.primaryColor : null,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                nativeMenuModel.displayname,
                style: themeData.textTheme.labelMedium?.copyWith(
                  color: isMenuSelected ? themeData.primaryColor : null,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        children: childWidgetsList,
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
          if (e.menuid == -1) {
            MyPrint.printOnConsole("onSubSiteBackButtonTap Clicked");
            if (onSubSiteBackButtonTap != null) {
              onSubSiteBackButtonTap!();
            }
            return;
          }

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

  Widget getSignOutButton({required BuildContext context, bool isNetworkConnected = true}) {
    if (!isNetworkConnected) {
      return const SizedBox();
    }

    ThemeData themeData = Theme.of(context);
    AppThemeProvider appThemeProvider = context.watch<AppThemeProvider>();

    return Theme(
      data: themeData.copyWith(
        iconTheme: themeData.iconTheme.copyWith(
          size: 22,
        ),
        textTheme: themeData.textTheme.copyWith(
          labelMedium: themeData.textTheme.labelMedium?.copyWith(
            color: appThemeProvider.getInstancyThemeColors().menuTextColor.isNotEmpty ? appThemeProvider.getInstancyThemeColors().menuTextColor.getColor() : null,
          ),
        ),
      ),
      child: InkWell(
        onTap: () {
          AuthenticationProvider authenticationProvider = Provider.of<AuthenticationProvider>(context, listen: false);
          AuthenticationController authenticationController = AuthenticationController(
            provider: authenticationProvider,
          );

          authenticationController.logout();
        },
        child: Container(
          // color: Colors.red,
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
          child: Row(
            children: [
              const Icon(
                Icons.logout,
              ),
              const SizedBox(width: 15),
              Text(
                appProvider.localStr.sidemenuTableSignoutlabel,
                style: themeData.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
