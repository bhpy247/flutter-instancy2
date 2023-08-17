import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/models/authorization/response_model/bot_details_model.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/backend/Catalog/catalog_provider.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/app_theme/app_theme_provider.dart';
import 'package:flutter_instancy_2/backend/authentication/authentication_provider.dart';
import 'package:flutter_instancy_2/backend/home/home_provider.dart';
import 'package:flutter_instancy_2/backend/instabot/instabot_controller.dart';
import 'package:flutter_instancy_2/backend/instabot/instabot_provider.dart';
import 'package:flutter_instancy_2/backend/main_screen/main_screen_provider.dart';
import 'package:flutter_instancy_2/backend/my_learning/my_learning_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/backend/profile/profile_controller.dart';
import 'package:flutter_instancy_2/backend/profile/profile_provider.dart';
import 'package:flutter_instancy_2/backend/wiki_component/wiki_provider.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/configs/ui_configurations.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/native_menu_model.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/views/catalog/screens/catalog_categories_list_screen.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:flutter_instancy_2/views/my_learning_plus/screens/my_learning_plus.dart';
import 'package:provider/provider.dart';

import '../../../models/app_configuration_models/data_models/native_menu_component_model.dart';
import '../../catalog/screens/catalog_contents_list_screen.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/common_cached_network_image.dart';
import '../../home/components/home_new_leaarning_resources_slider.dart';
import '../../home/components/home_popular_leaarning_resources_slider.dart';
import '../../home/components/home_recommended_leaarning_resources_slider.dart';
import '../../home/components/static_webpage_widget.dart';
import '../../my_learning/screens/my_learning_screen.dart';
import '../../profile/screens/user_profile_screen.dart';
import '../components/main_screen_bottombar.dart';
import '../components/main_screen_drawer.dart';

class MainScreen extends StatefulWidget {
  static const String routeName = "/MainScreen";

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late ThemeData themeData;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late AppProvider appProvider;
  late MainScreenProvider mainScreenProvider;
  late HomeProvider homeProvider;
  late ProfileProvider profileProvider;
  late InstaBotProvider instaBotProvider;
  late AppThemeProvider appThemeProvider;

  @override
  void initState() {
    super.initState();

    appProvider = Provider.of<AppProvider>(context, listen: false);
    mainScreenProvider = Provider.of<MainScreenProvider>(context, listen: false);
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    instaBotProvider = Provider.of<InstaBotProvider>(context, listen: false);
    appThemeProvider = Provider.of<AppThemeProvider>(context, listen: false);

    List<NativeMenuModel> menusList = appProvider.getMenuModelsList().toList();
    if (menusList.isNotEmpty) {
      mainScreenProvider.setSelectedMenu(
        menuModel: menusList.first,
        appProvider: appProvider,
        appThemeProvider: Provider.of<AppThemeProvider>(context, listen: false),
        isNotify: false,
      );
    }

    ProfileController(profileProvider: profileProvider).getProfileInfoMain(
      userId: ApiController().apiDataProvider.getCurrentUserId(),
      authenticationProvider: Provider.of<AuthenticationProvider>(context, listen: false),
      isGetFromCache: false,
    );

    InstabotController(provider: instaBotProvider).getSiteBotDetails(appThemeProvider: appThemeProvider, isNotify: false);
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppProvider>.value(value: appProvider),
        ChangeNotifierProvider<MainScreenProvider>.value(value: mainScreenProvider),
      ],
      child: Consumer3<AppProvider, MainScreenProvider, InstaBotProvider>(
        builder: (BuildContext context, AppProvider appProvider, MainScreenProvider mainScreenProvider, InstaBotProvider instaBotProvider, Widget? child) {
          Future<void>? future = mainScreenProvider.futureGetMenuComponentData;

          NativeMenuModel? menuModel = mainScreenProvider.selectedMenuModel;

          List<NativeMenuComponentModel> components = <NativeMenuComponentModel>[];
          if (menuModel != null) {
            components = appProvider.getMenuComponentModelsListFromMenuId(menuId: menuModel.menuid);
          }
          MyPrint.printOnConsole("components.length:${components.length}");

          List<NativeMenuModel> allMenusList = appProvider.getMenuModelsList();
          List<NativeMenuModel> mainMenusList = allMenusList.where((element) => element.parentmenuid == 0).toList();

          List<NativeMenuModel> drawerMenusList = allMenusList.toList();
          List<NativeMenuModel> bottomBarMenusList = [];
          bool hasMoreMenus = false;

          if (appProvider.appSystemConfigurationModel.mobileAppMenuPosition == "bottom") {
            hasMoreMenus = mainMenusList.length >= InstancyUIConfigurations.maxBottomBarItemsCount;
            int bottomMenusLength = hasMoreMenus ? InstancyUIConfigurations.maxBottomBarItemsCount : mainMenusList.length;

            for (int i = 0; i < bottomMenusLength; i++) {
              bottomBarMenusList.add(mainMenusList[i]);
            }
            drawerMenusList.removeWhere((element) => bottomBarMenusList.contains(element));
          }

          return Scaffold(
            key: _scaffoldKey,
            appBar: getAppBar(
              menuModel: menuModel,
              components: components,
            ),
            drawer: getDrawerWidget(drawerMenusList: drawerMenusList),
            floatingActionButtonLocation: bottomBarMenusList.isEmpty ? null : FloatingActionButtonLocation.centerDocked,
            floatingActionButton: getChatBotButton(instaBotProvider: instaBotProvider),
            bottomNavigationBar: getBottomBarWidget(bottomBarMenusList: bottomBarMenusList, hasMoreMenus: hasMoreMenus),
            body: future != null
                ? FutureBuilder(
                    future: future,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return getRoundedCornerWidget(
                          menuModel: menuModel,
                          components: components,
                        );
                      } else {
                        return const CommonLoader();
                      }
                    },
                  )
                : getRoundedCornerWidget(
                    menuModel: menuModel,
                    components: components,
                  ),
          );
        },
      ),
    );
  }

  AppBar getAppBar({
    NativeMenuModel? menuModel,
    required List<NativeMenuComponentModel> components,
  }) {
    return AppBar(
      title: Text(
        mainScreenProvider.getAppBarTitle(),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(
            right: 10,
          ),
          child: Row(
            children: getAppbarActions(components: components).toList(),
          ),
        ),
      ],
    );
  }

  Iterable<Widget> getAppbarActions({
    required List<NativeMenuComponentModel> components,
  }) sync* {
    /*MainScreenAppBarActions mainScreenAppBarActions = MainScreenAppBarActions(
      iconColor: themeData.appBarTheme.titleTextStyle?.color ?? Colors.black,
    );*/

    /*yield mainScreenAppBarActions.getTempButton(
      context: context,
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return ProfileMainPage(
            profileProvider: profileProvider,
            connectionUserId: 363,
            isMyProfile: true,
          );
        }));
      },
    );*/

    for (NativeMenuComponentModel componentModel in components) {
      if (componentModel.componentid == 3) {
        // yield mainScreenAppBarActions.getWaitlistButton(
        //   context: context,
        //   componentId: componentModel.componentid,
        //   componentInstanceId: componentModel.repositoryid,
        //   componentModel: componentModel,
        //   myLearningProvider: context.read<MyLearningProvider>(),
        // );
      }
    }
  }

  Widget getDrawerWidget({required List<NativeMenuModel> drawerMenusList}) {
    return MainScreenDrawer(
      appProvider: appProvider,
      mainScreenProvider: mainScreenProvider,
      menusList: drawerMenusList,
    );
  }

  Widget? getChatBotButton({required InstaBotProvider instaBotProvider}) {
    if (!appProvider.appSystemConfigurationModel.enableChatBot) {
      return null;
    }

    if (instaBotProvider.isSiteBotDetailsLoading.get()) return null;

    BotDetailsModel? botDetailsModel = instaBotProvider.botDetailsModel.get();
    if (botDetailsModel == null) return null;

    Widget botIconWidget;
    if (botDetailsModel.BotSettings.botIconBytes != null) {
      botIconWidget = Image.memory(
        // width: 40,
        // height: 40,
        fit: BoxFit.fill,
        botDetailsModel.BotSettings.botIconBytes!,
        errorBuilder: (_, __, ___) {
          return Container(
            width: 20,
            height: 20,
            color: Colors.grey[200],
            child: Icon(
              Icons.image_outlined,
              color: Colors.grey[400],
              size: 20,
            ),
          );
        },
      );
    } else if (botDetailsModel.BotSettings.botIconUrl.isNotEmpty) {
      botIconWidget = CommonCachedNetworkImage(
        imageUrl: botDetailsModel.BotSettings.botIconUrl,
        fit: BoxFit.fill,
        // width: 40,
        // height: 40,
        shimmerIconSize: 20,
        errorIconSize: 20,
        placeholder: (_, __) {
          return const SizedBox();
        },
      );
    } else {
      botIconWidget = Image.asset(
        "assets/images/chatbot-chat-Icon.png",
      );
    }

    return FloatingActionButton(
      onPressed: () {
        NavigationController.navigateToInstaBotScreen2(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamed,
          ),
          arguments: InstaBotScreen2NavigationArguments(instaBotProvider: instaBotProvider),
        );
      },
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ClipRRect(
        // borderRadius: BorderRadius.circular(100),
        child: botIconWidget,
      ),
    );
  }

  Widget? getBottomBarWidget({required List<NativeMenuModel> bottomBarMenusList, required bool hasMoreMenus}) {
    if (bottomBarMenusList.isEmpty) {
      return null;
    }

    return MainScreenBottomBar(
      selectedMenuModel: mainScreenProvider.selectedMenuModel,
      menusList: bottomBarMenusList,
      hasMoreMenus: hasMoreMenus,
      onMenuTap: ({required NativeMenuModel nativeMenuModel}) {
        mainScreenProvider.setSelectedMenu(
          menuModel: nativeMenuModel,
          appProvider: appProvider,
          appThemeProvider: Provider.of<AppThemeProvider>(context, listen: false),
        );
      },
      onMoreMenuTap: () {
        MyPrint.printOnConsole("onMoreMenuTap called");

        _scaffoldKey.currentState?.openDrawer();
      },
    );
  }

  Widget getRoundedCornerWidget({
    NativeMenuModel? menuModel,
    required List<NativeMenuComponentModel> components,
  }) {
    return AppUIComponents.getBackGroundBordersRounded(
      context: context,
      child: getMainBody(
        menuModel: menuModel,
        components: components,
      ),
    );
  }

  Widget getMainBody({
    NativeMenuModel? menuModel,
    required List<NativeMenuComponentModel> components,
  }) {
    if (menuModel == null) {
      return const Center(
        child: Text("No Menu Selected"),
      );
    }

    if (components.length > 1) {
      return ListView(
        children: components.map((e) {
          return getUIComponentFromMenuComponentModel(model: e, isExpanded: false);
        }).toList(),
      );
    } else if (components.length == 1) {
      return getUIComponentFromMenuComponentModel(model: components.first, isExpanded: true);
    } else {
      return const Center(
        child: Text("No Components Found"),
      );
    }
  }

  Widget getUIComponentFromMenuComponentModel({required NativeMenuComponentModel model, bool isExpanded = false}) {
    // MyPrint.printOnConsole("Component iddddd: ${model.componentid}");
    if (model.componentid == InstancyComponents.NewLearningResources) {
      return HomeNewLearningResourcesSlider(
        homeProvider: homeProvider,
        componentId: model.componentid,
        componentInstanceId: model.repositoryid,
      );
    } else if (model.componentid == InstancyComponents.PopularLearningResources) {
      return HomePopularLearningResourcesSlider(
        homeProvider: homeProvider,
        componentId: model.componentid,
        componentInstanceId: model.repositoryid,
      );
    } else if (model.componentid == InstancyComponents.RecommendedLearningResources) {
      return HomeRecommendedLearningResourcesSlider(
        homeProvider: homeProvider,
        componentId: model.componentid,
        componentInstanceId: model.repositoryid,
      );
    } else if (model.componentid == InstancyComponents.StaticHTMLContent) {
      return StaticWebpageWidget(
        nativeMenuComponentModel: model,
        homeProvider: Provider.of<HomeProvider>(context, listen: false),
      );
    } else if (model.componentid == InstancyComponents.MyProfile) {
      return UserProfileScreen(
        arguments: UserProfileScreenNavigationArguments(
          userId: ApiController().apiDataProvider.getCurrentUserId(),
          profileProvider: profileProvider,
          isFromProfile: true,
          isMyProfile: true,
        ),
      );
    } else if (model.componentid == InstancyComponents.MyLearning) {
      if (isExpanded) {
        return MyLearningScreen(
          componentId: model.componentid,
          componentInstanceId: model.repositoryid,
          provider: context.read<MyLearningProvider>(),
        );
      } else {
        return const Text("My Learning");
      }
    } else if (model.componentid == InstancyComponents.Catalog) {
      if (model.landingpagetype == 2 || model.landingpagetype == 0) {
        return CatalogContentsListScreen(
          isShowAppBar: false,
          arguments: CatalogContentsListScreenNavigationArguments(
            componentInstanceId: model.repositoryid,
            componentId: model.componentid,
          ),
        );
      } else {
        return CatalogCategoriesListScreen(
          componentId: model.componentid,
          componentInstanceId: model.repositoryid,
          catalogProvider: context.read<CatalogProvider>(),
          wikiProvider: context.read<WikiProvider>(),
        );
      }
    } else if (model.componentid == InstancyComponents.Events) {
      return const Text("Classroom Events");
    } else if (model.componentid == InstancyComponents.MyLearningPlus) {
      return const MyLearningPlus();
    } else {
      return const SizedBox();
    }
  }
}