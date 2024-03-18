import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/view/common/components/common_loader.dart';
import 'package:flutter_instancy_2/backend/event/event_controller.dart';
import 'package:flutter_instancy_2/backend/event/event_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/app/data_model/dynamic_tabs_dto_model.dart';
import 'package:flutter_instancy_2/models/app/request_model/get_dynamic_tabs_request_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:provider/provider.dart';

import '../../../backend/app/app_provider.dart';
import '../../../utils/my_print.dart';
import 'event_catalog_list_screen.dart';

class EventCatalogTabScreen extends StatefulWidget {
  static const String routeName = "/EventCatalogTabScreen";
  final EventCatalogTabScreenNavigationArguments arguments;

  const EventCatalogTabScreen({super.key, required this.arguments});

  @override
  State<EventCatalogTabScreen> createState() => _EventCatalogTabScreenState();
}

class _EventCatalogTabScreenState extends State<EventCatalogTabScreen> with MySafeState, SingleTickerProviderStateMixin {
  late EventProvider eventProvider;
  late EventController eventController;
  late AppProvider appProvider;
  String? appBarTitle;

  TabController? tabController;
  List<Widget> tabScreensList = [];

  Future<void> getTabs({bool isNotify = true}) async {
    List<DynamicTabsDTOModel> tabs = eventProvider.getTabModelsList();
    if (tabs.isEmpty) {
      tabs = await eventController.getTabs(
        requestModel: GetDynamicTabsRequestModel(
          ComponentID: widget.arguments.componentId,
          ComponentInsID: widget.arguments.componentInsId,
        ),
        isNotify: isNotify,
      );
    }

    if (tabs.length <= 1) {
      tabController = null;
    } else {
      tabController = TabController(length: tabs.length, vsync: this);
    }

    tabScreensList = tabs.map((DynamicTabsDTOModel tabDataModel) {
      return EventCatalogListScreen(
        arguments: EventCatalogListScreenNavigationArguments(
            tabId: tabDataModel.TabID,
            siteId: widget.arguments.siteId,
            tabDataModel: tabDataModel,
            enableSearching: ([EventCatalogTabTypes.calendarView].contains(tabDataModel.TabID)) ? widget.arguments.enableSearching : false,
            // searchString: widget.arguments.searchString,
            eventProvider: tabDataModel.eventProvider,
            componentId: widget.arguments.componentId,
            componentInsId: widget.arguments.componentInsId,
            isShowAppBar: false,
            isShowSearchTextField: widget.arguments.isShowSearchTextField,
            apiController: widget.arguments.apiController),
      );
    }).toList();
    MyPrint.printOnConsole("Tab Controller Assigned");
  }

  @override
  void initState() {
    super.initState();

    eventProvider = widget.arguments.eventProvider ?? context.read<EventProvider>();
    eventController = EventController(eventProvider: eventProvider, apiController: widget.arguments.apiController);
    appProvider = context.read<AppProvider>();
    if (widget.arguments.isShowAppbar) {
      appBarTitle = appProvider.getMenuModelFromComponentId(componentId: InstancyComponents.CatalogEvents)?.displayname ?? "Event Catalog";
    }
    getTabs(isNotify: false);
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EventProvider>.value(value: eventProvider),
      ],
      child: Consumer<EventProvider>(
        builder: (BuildContext context, EventProvider eventProvider, Widget? child) {
          return Scaffold(
            appBar: getAppBar(),
            body: getMainBody(eventProvider: eventProvider),
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

  Widget getMainBody({required EventProvider eventProvider}) {
    if (eventProvider.isLoadingTabsList.get()) {
      return const CommonLoader(
        isCenter: true,
      );
    }

    if (tabScreensList.isEmpty) {
      return const Center(
        child: Text(
          "No Data Available",
        ),
      );
    }

    return Column(
      children: [
        getTabBarWidget(eventProvider.getTabModelsList()),
        const SizedBox(height: 10),
        Expanded(
          child: tabController != null
              ? TabBarView(
                  controller: tabController,
                  children: tabScreensList,
                )
              : (tabScreensList.firstElement ?? const SizedBox()),
        ),
      ],
    );
  }

  Widget getTabBarWidget(List<DynamicTabsDTOModel> tabList) {
    if (tabController == null) {
      return const SizedBox();
    }

    return TabBar(
      controller: tabController,
      indicatorColor: themeData.primaryColor,
      isScrollable: tabList.length > 3,
      physics: const AlwaysScrollableScrollPhysics(),
      tabs: tabList.map((e) {
        return Tab(
          text: e.MobileDisplayName,
        );
      }).toList(),
    );
  }
}
