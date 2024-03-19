import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/my_connections/my_connections_controller.dart';
import 'package:flutter_instancy_2/backend/my_connections/my_connections_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation_arguments.dart';
import 'package:flutter_instancy_2/configs/app_configurations.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/app/data_model/dynamic_tabs_dto_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:flutter_instancy_2/views/common/components/modal_progress_hud.dart';
import 'package:flutter_instancy_2/views/my_connections/screens/connections_list_screen.dart';
import 'package:provider/provider.dart';

class MyConnectionsMainScreen extends StatefulWidget {
  static const String routeName = "/MyConnectionsMainScreen";
  final MyConnectionsMainScreenNavigationArguments arguments;

  const MyConnectionsMainScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<MyConnectionsMainScreen> createState() => _MyConnectionsMainScreenState();
}

class _MyConnectionsMainScreenState extends State<MyConnectionsMainScreen> with MySafeState, TickerProviderStateMixin {
  TabController? tabController;
  late MyConnectionsController myConnectionsController;
  late MyConnectionsProvider myConnectionsProvider;
  late AppProvider appProvider;
  String? appBarTitle;

  late int componentId;
  late int componentInsId;

  List<DynamicTabsDTOModel> tabModelsList = [];

  int selectedTabIndex = 0;

  Future<void> getTabsList({bool isRefresh = true, bool isGetFromCache = false, bool isNotify = true}) async {
    List<DynamicTabsDTOModel> tabs = await myConnectionsController.getTabsList(
      isRefresh: isRefresh,
      isGetFromCache: isGetFromCache,
      isNotify: isNotify,
    );

    if (tabs.length <= 1) {
      tabController = null;
    } else {
      tabController = TabController(length: tabs.length, vsync: this);
    }

    tabModelsList.clear();
    tabModelsList.addAll(tabs);

    MyPrint.printOnConsole("Tabs Length:${tabModelsList.length}");
    MyPrint.printOnConsole("Tab Controller Assigned");

    mySetState();
  }

  @override
  void initState() {
    super.initState();
    myConnectionsProvider = widget.arguments.myConnectionsProvider ?? MyConnectionsProvider();
    myConnectionsController = MyConnectionsController(connectionsProvider: myConnectionsProvider, apiController: widget.arguments.apiController);
    if (widget.arguments.searchString.checkNotEmpty) {
      myConnectionsProvider.peopleListSearchString.set(value: widget.arguments.searchString);
    }
    appProvider = context.read<AppProvider>();
    if (widget.arguments.isShowAppbar) {
      appBarTitle = appProvider.getMenuModelFromComponentId(componentId: InstancyComponents.PeopleList)?.displayname ?? "My Connection";
    }

    componentId = widget.arguments.componentId;
    componentInsId = InstancyComponents.PeopleListComponentInsId;

    getTabsList(
      isRefresh: false,
      isGetFromCache: true,
      isNotify: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyConnectionsProvider>.value(value: myConnectionsProvider),
      ],
      child: Consumer<MyConnectionsProvider>(
        builder: (BuildContext context, MyConnectionsProvider myConnectionsProvider, Widget? child) {
          return ModalProgressHUD(
            inAsyncCall: myConnectionsProvider.isLoading.get(),
            child: Scaffold(
              appBar: getAppBar(),
              body: getMainBody(myConnectionsProvider: myConnectionsProvider),
            ),
          );
        },
      ),
    );
  }

  AppBar? getAppBar() {
    if (appBarTitle == null) return null;
    return AppBar(
      title: Text(
        appBarTitle ?? "",
      ),
    );
  }

  Widget getMainBody({required MyConnectionsProvider myConnectionsProvider}) {
    if (myConnectionsProvider.isLoadingTabsList.get()) {
      return const CommonLoader(isCenter: true);
    } else if (tabModelsList.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          await getTabsList(
            isRefresh: true,
            isGetFromCache: false,
            isNotify: true,
          );
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            Center(
              child: AppConfigurations.commonNoDataView(),
            ),
          ],
        ),
      );
    } else if (tabModelsList.length == 1) {
      return getTabScreenWidget(tabsDTOModel: tabModelsList.first);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TabBar(
          controller: tabController,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          physics: const AlwaysScrollableScrollPhysics(),
          isScrollable: (tabController?.length ?? 0) > 3,
          tabAlignment: (tabController?.length ?? 0) > 3 ? TabAlignment.start : TabAlignment.fill,
          labelPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5).copyWith(bottom: 10),
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(width: 4, color: themeData.tabBarTheme.indicatorColor ?? themeData.primaryColor),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(100),
              topRight: Radius.circular(100),
            ),
          ),
          onTap: (int index) {
            selectedTabIndex = index;
            mySetState();
          },
          labelStyle: themeData.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          tabs: tabModelsList.map((e) {
            return getTabWidget(tabsDTOModel: e);
          }).toList(),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: tabModelsList.map((e) {
              return getTabScreenWidget(tabsDTOModel: e);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget getTabWidget({required DynamicTabsDTOModel tabsDTOModel}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(tabsDTOModel.MobileDisplayName),
    );
  }

  Widget getTabScreenWidget({required DynamicTabsDTOModel tabsDTOModel}) {
    return ConnectionsListScreen(
      myConnectionsProvider: tabsDTOModel.myConnectionsProvider,
      filterType: tabsDTOModel.MobileDisplayName.replaceAll(" ", "").replaceAll("-", ""),
      componentId: componentId,
      componentInsId: componentInsId,
      isShowSearchTextField: widget.arguments.isShowSearchTextField,
      searchString: widget.arguments.searchString,
      apiController: widget.arguments.apiController,
      onPeopleListingActionPerformed: () {
        for (DynamicTabsDTOModel model in tabModelsList) {
          if (model != tabsDTOModel) {
            model.myConnectionsProvider.isPeopleListingActionPerformed.set(value: true, isNotify: false);
          }
        }
      },
      setParentLoading: ({required bool isLoading}) {
        myConnectionsProvider.isLoading.set(value: isLoading);
      },
    );
  }
}
