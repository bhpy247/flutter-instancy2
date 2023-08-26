import 'package:flutter/material.dart';
import 'package:flutter_chat_bot/view/common/components/common_loader.dart';
import 'package:flutter_instancy_2/backend/event/event_controller.dart';
import 'package:flutter_instancy_2/backend/event/event_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/classroom_events/data_model/tab_data_model.dart';
import 'package:flutter_instancy_2/models/classroom_events/request_model/tabs_list_request_model.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:provider/provider.dart';

import '../../../utils/my_print.dart';
import 'event_catalog_list_screen.dart';

class EventCatalogTabScreen extends StatefulWidget {
  final int componentId;
  final int componentInsId;
  final EventProvider? eventProvider;
  final bool enableSearching;

  const EventCatalogTabScreen({
    super.key,
    required this.componentId,
    this.componentInsId = InstancyComponents.EventCatalogTabsListComponentInsId,
    this.eventProvider,
    this.enableSearching = true,
  });

  @override
  State<EventCatalogTabScreen> createState() => _EventCatalogTabScreenState();
}

class _EventCatalogTabScreenState extends State<EventCatalogTabScreen> with MySafeState, SingleTickerProviderStateMixin {
  late EventProvider eventProvider;
  late EventController eventController;

  TabController? tabController;
  List<Widget> tabScreensList = [];

  Future<void> getTabs({bool isNotify = true}) async {
    List<TabDataModel> tabs = eventProvider.getTabModelsList();
    if (tabs.isEmpty) {
      tabs = await eventController.getTabs(
        requestModel: TabsListRequestModel(
          ComponentID: widget.componentId,
          ComponentInsID: widget.componentInsId,
        ),
        isNotify: isNotify,
      );
    }

    if (tabs.length <= 1) {
      tabController = null;
    } else {
      tabController = TabController(length: tabs.length, vsync: this);
    }

    tabScreensList = tabs.map((TabDataModel tabDataModel) {
      return EventCatalogListScreen(
        arguments: EventCatalogListScreenNavigationArguments(
          tabId: tabDataModel.TabID,
          tabDataModel: tabDataModel,
          enableSearching: ([EventCatalogTabTypes.calendarView].contains(tabDataModel.TabID)) ? widget.enableSearching : false,
          // searchString: widget.searchString,
          eventProvider: tabDataModel.eventProvider,
          componentId: widget.componentId,
          componentInsId: widget.componentInsId,
          isShowAppBar: false,
        ),
      );
    }).toList();
    MyPrint.printOnConsole("Tab Controller Assigned");
  }

  @override
  void initState() {
    super.initState();

    eventProvider = widget.eventProvider ?? context.read<EventProvider>();
    eventController = EventController(eventProvider: eventProvider);

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
            body: getMainBody(eventProvider: eventProvider),
          );
        },
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

  Widget getTabBarWidget(List<TabDataModel> tabList) {
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
