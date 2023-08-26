import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/event/event_controller.dart';
import 'package:flutter_instancy_2/backend/event/event_provider.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/classroom_events/data_model/tab_data_model.dart';
import 'package:flutter_instancy_2/models/course/data_model/mobile_lms_course_model.dart';
import 'package:flutter_instancy_2/utils/date_representation.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../backend/app/app_provider.dart';
import '../../../backend/filter/filter_controller.dart';
import '../../../backend/filter/filter_provider.dart';
import '../../../backend/navigation/navigation.dart';
import '../../../configs/app_configurations.dart';
import '../../../models/app_configuration_models/data_models/native_menu_component_model.dart';
import '../../../models/common/pagination/pagination_model.dart';
import '../../../utils/my_print.dart';
import '../../common/components/app_ui_components.dart';
import '../../common/components/common_loader.dart';
import '../../common/components/common_text_form_field.dart';
import '../../common/components/modal_progress_hud.dart';
import '../../filter/components/selected_filters_listview_component.dart';
import '../components/event_list_card.dart';

class EventCatalogListScreen extends StatefulWidget {
  final EventCatalogListScreenNavigationArguments arguments;

  const EventCatalogListScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<EventCatalogListScreen> createState() => _EventCatalogListScreenState();
}

class _EventCatalogListScreenState extends State<EventCatalogListScreen> with MySafeState {
  late AppProvider appProvider;

  late String? tabId;
  late TabDataModel? tabDataModel;

  late EventProvider eventProvider;
  late EventController eventController;

  late int componentId;
  late int componentInsId;

  bool isLoading = false;

  late TextEditingController searchController;
  bool enableSearching = true;

  final ItemScrollController catalogContentScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController = ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener = ScrollOffsetListener.create();

  Future<void> getEventCatalogContentsList({bool isRefresh = true, bool isGetFromCache = true, bool isNotify = true}) async {
    await Future.wait([
      eventController.getEventCatalogContentsListFromApi(
        isRefresh: isRefresh,
        isGetFromCache: isGetFromCache,
        isNotify: isNotify,
        tabId: tabId ?? "",
        componentId: componentId,
        componentInstanceId: componentInsId,
      ),
      /*if (isRefresh)
        eventController.getWishListContentsListFromApi(
          isRefresh: true,
          componentId: componentId,
          componentInstanceId: componentInsId,
          isGetFromCache: false,
          isNotify: true,
        ),*/
    ]);
  }

  Future<void> navigateToFilterScreen({String? contentFilterByTypes}) async {
    MyPrint.printOnConsole("navigateToFilterScreen called with contentFilterByTypes:$contentFilterByTypes");

    NativeMenuComponentModel? componentModel = appProvider.getMenuComponentModelFromComponentId(componentId: componentId);

    if (componentModel == null) {
      return;
    }

    dynamic value = await NavigationController.navigateToFiltersScreen(
      navigationOperationParameters: NavigationOperationParameters(
        context: context,
        navigationType: NavigationType.pushNamed,
      ),
      arguments: FiltersScreenNavigationArguments(
        componentId: componentId,
        filterProvider: eventProvider.filterProvider,
        componentConfigurationsModel: componentModel.componentConfigurationsModel,
        contentFilterByTypes: contentFilterByTypes,
      ),
    );
    MyPrint.printOnConsole("Filter Value:$value");

    if (value == true) {
      getEventCatalogContentsList(
        isRefresh: true,
        isGetFromCache: false,
        isNotify: true,
      );
    }
  }

  Future<void> onCalenderDateChanged({required DateTime? newDate}) async {
    MyPrint.printOnConsole("onCalenderDateChanged called with newDate:$newDate");

    if (newDate == null) return;

    DateTime? existingDate = eventProvider.calenderDate.get();
    MyPrint.printOnConsole("existingDate:$existingDate");

    if (existingDate == null || (newDate.month != existingDate.month || newDate.year != existingDate.year)) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        eventProvider.calenderDate.set(value: newDate, isNotify: false);
        getEventCatalogContentsList(
          isRefresh: true,
          isGetFromCache: false,
          isNotify: true,
        );
      });
    }
  }

  Future<void> onScheduleBackTapped() async {
    MyPrint.printOnConsole("onScheduleBackTapped called");

    DateTime existingDate = eventProvider.scheduleDate.get() ?? DateTime.now();
    MyPrint.printOnConsole("existingDate:$existingDate");

    DateTime newDate = Jiffy.parseFromDateTime(existingDate).subtract(months: 1).dateTime;
    MyPrint.printOnConsole("newDate:$newDate");

    eventProvider.scheduleDate.set(value: newDate, isNotify: false);
    getEventCatalogContentsList(
      isRefresh: true,
      isGetFromCache: false,
      isNotify: true,
    );
  }

  Future<void> onScheduleNextTapped() async {
    MyPrint.printOnConsole("onScheduleNextTapped called");

    DateTime existingDate = eventProvider.scheduleDate.get() ?? DateTime.now();
    MyPrint.printOnConsole("existingDate:$existingDate");

    DateTime newDate = Jiffy.parseFromDateTime(existingDate).add(months: 1).dateTime;
    MyPrint.printOnConsole("newDate:$newDate");

    eventProvider.scheduleDate.set(value: newDate, isNotify: false);
    getEventCatalogContentsList(
      isRefresh: true,
      isGetFromCache: false,
      isNotify: true,
    );
  }

  Future<void> onScheduleDateTapped() async {
    MyPrint.printOnConsole("onScheduleDateTapped called");

    DateTime existingDate = eventProvider.scheduleDate.get() ?? DateTime.now();
    MyPrint.printOnConsole("existingDate:$existingDate");

    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: existingDate,
      firstDate: DateTime(existingDate.year - 100),
      lastDate: DateTime(existingDate.year + 100),
    );

    if (newDate == null) {
      return;
    }

    eventProvider.scheduleDate.set(value: newDate, isNotify: false);
    getEventCatalogContentsList(
      isRefresh: true,
      isGetFromCache: false,
      isNotify: true,
    );
  }

  @override
  void initState() {
    super.initState();

    appProvider = context.read<AppProvider>();
    eventProvider = widget.arguments.eventProvider ?? EventProvider();
    eventController = EventController(eventProvider: eventProvider);

    componentId = widget.arguments.componentId;
    componentInsId = widget.arguments.componentInsId;

    tabId = widget.arguments.tabId;
    tabDataModel = widget.arguments.tabDataModel;

    searchController = TextEditingController(text: "");
    enableSearching = widget.arguments.enableSearching;

    NativeMenuComponentModel? componentModel = appProvider.getMenuComponentModelFromComponentId(componentId: componentId);
    if (componentModel != null) {
      eventController.initializeCatalogConfigurationsFromComponentConfigurationsModel(
        componentConfigurationsModel: componentModel.componentConfigurationsModel,
      );
    }

    if (tabId == EventCatalogTabTypes.calendarView) {
      if (eventProvider.calenderDate.get() == null) {
        eventProvider.calenderDate.set(value: DateTime.now(), isNotify: false);
      }
    } else if (tabId == EventCatalogTabTypes.calendarSchedule) {
      if (eventProvider.scheduleDate.get() == null) {
        eventProvider.scheduleDate.set(value: DateTime.now(), isNotify: false);
      }
    } else {
      eventProvider.calenderDate.set(value: null, isNotify: false);
      eventProvider.scheduleDate.set(value: null, isNotify: false);
    }

    if (eventProvider.eventsListLength == 0 && eventProvider.eventsPaginationModel.get().hasMore) {
      getEventCatalogContentsList(
        isRefresh: true,
        isGetFromCache: false,
        isNotify: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<EventProvider>.value(value: eventProvider),
        ],
        child: Consumer<EventProvider>(
          builder: (BuildContext context, EventProvider eventProvider, Widget? child) {
            return ModalProgressHUD(
              inAsyncCall: isLoading,
              child: Scaffold(
                appBar: widget.arguments.isShowAppBar ? getAppBar() : null,
                body: AppUIComponents.getBackGroundBordersRounded(
                  context: context,
                  child: getMainWidget(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget getAppBar() {
    return AppConfigurations().commonAppBar(
      title: "Classroom Events",
      actions: [
        /*Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              InkWell(
                onTap: () async {
                  await NavigationController.navigateToWishlist(
                    navigationOperationParameters: NavigationOperationParameters(
                      context: context,
                      navigationType: NavigationType.pushNamed,
                    ),
                    arguments: WishListScreenNavigationArguments(
                      componentId: widget.arguments.componentId,
                      componentInstanceId: widget.arguments.componentInsId,
                      // eventProvider: eventProvider,
                    ),
                  );
                  getEventCatalogContentsList(
                    isRefresh: true,
                    isGetFromCache: false,
                    isNotify: true,
                  );
                },
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: const Icon(FontAwesomeIcons.heart),
                    ),
                    if (eventProvider.maxWishlistContentsCount.get() > 0)
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: themeData.primaryColor,
                          ),
                          child: Text(
                            "${eventProvider.maxWishlistContentsCount.get()}",
                            style: themeData.textTheme.labelSmall?.copyWith(
                              color: themeData.colorScheme.onPrimary,
                              fontSize: 8,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),*/
      ],
    );
  }

  Widget getMainWidget() {
    Widget? scheduleWidget = getScheduleDateWidget();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (scheduleWidget != null) ...[
          scheduleWidget,
          const SizedBox(height: 10),
        ],
        getSearchTextFormField(),
        const SizedBox(height: 10),
        getSelectedFiltersListviewWidget(),
        Expanded(
          child: getCatalogContentsListView(),
        ),
      ],
    );
  }

  Widget getSearchTextFormField() {
    onSubmitted(String text) {
      bool isSearch = false;
      if (text.isEmpty) {
        if (eventProvider.searchString.get().isNotEmpty) {
          isSearch = true;
        }
      } else {
        if (text != eventProvider.searchString.get()) {
          isSearch = true;
        }
      }
      if (isSearch) {
        eventProvider.searchString.set(value: text);
        getEventCatalogContentsList(
          isRefresh: true,
          isGetFromCache: false,
          isNotify: true,
        );
      }
    }

    Widget? filterSuffixIcon;

    if (eventProvider.filterEnabled.get()) {
      int selectedFiltersCount = eventProvider.filterProvider.selectedFiltersCount();

      filterSuffixIcon = Stack(
        children: [
          Container(
            margin: selectedFiltersCount > 0 ? const EdgeInsets.only(top: 5, right: 5) : null,
            child: InkWell(
              onTap: () async {
                navigateToFilterScreen();
              },
              child: const Icon(
                Icons.tune,
              ),
            ),
          ),
          if (selectedFiltersCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: themeData.primaryColor,
                ),
                child: Text(
                  selectedFiltersCount.toString(),
                  style: themeData.textTheme.labelSmall?.copyWith(
                    color: themeData.colorScheme.onPrimary,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      );
    }

    Widget? sortSuffixIcon;

    if (eventProvider.sortEnabled.get()) {
      bool isSortingSelected = false;
      // MyPrint.printOnConsole("selected sort : ${eventProvider.filterProvider.selectedSort.get()}");
      // if(eventProvider.filterProvider.selectedSort.get().isNotEmpty){
      //   isSortingSelected = true;
      // }

      sortSuffixIcon = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Stack(
          children: [
            InkWell(
              onTap: () async {
                dynamic value = await NavigationController.navigateToSortingScreen(
                  navigationOperationParameters: NavigationOperationParameters(
                    context: context,
                    navigationType: NavigationType.pushNamed,
                  ),
                  arguments: SortingScreenNavigationArguments(
                    componentId: componentId,
                    filterProvider: eventProvider.filterProvider,
                  ),
                );
                MyPrint.printOnConsole("Sort Value:$value");

                if (value == true) {
                  getEventCatalogContentsList(
                    isRefresh: true,
                    isGetFromCache: false,
                    isNotify: true,
                  );
                }
              },
              child: const Icon(Icons.sort),
            ),
            Positioned(
              right: 0,
              child: Visibility(
                visible: isSortingSelected,
                child: Container(
                  height: 7,
                  width: 7,
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget? clearSearchSuffixIcon;
    if (searchController.text.isNotEmpty || (eventProvider.searchString.get().isNotEmpty && eventProvider.searchString.get() == searchController.text)) {
      clearSearchSuffixIcon = IconButton(
        onPressed: () async {
          searchController.clear();
          onSubmitted("");
        },
        icon: const Icon(
          Icons.close,
        ),
      );
    }

    List<Widget> actions = <Widget>[];
    if (clearSearchSuffixIcon != null) actions.add(clearSearchSuffixIcon);
    if (filterSuffixIcon != null) actions.add(filterSuffixIcon);
    if (sortSuffixIcon != null) actions.add(sortSuffixIcon);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        height: 40,
        child: CommonTextFormField(
          borderRadius: 50,
          boxConstraints: const BoxConstraints(minWidth: 55),
          prefixWidget: const Icon(Icons.search),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          hintText: "Search",
          isOutlineInputBorder: true,
          controller: searchController,
          onSubmitted: onSubmitted,
          onChanged: (String text) {
            mySetState();
          },
          suffixWidget: actions.isNotEmpty
              ? Row(
            mainAxisSize: MainAxisSize.min,
            children: actions,
          )
              : null,
        ),
      ),
    );
  }

  Widget getSelectedFiltersListviewWidget() {
    FilterProvider filterProvider = eventProvider.filterProvider;

    return SelectedFiltersListviewComponent(
      filterProvider: filterProvider,
      onResetFilter: () {
        FilterController(filterProvider: filterProvider).resetFilterData();
        getEventCatalogContentsList(
          isRefresh: true,
          isGetFromCache: false,
          isNotify: true,
        );
      },
      onFilterChipTap: ({required String contentFilterByTypes}) {
        if (contentFilterByTypes.isEmpty) return;

        navigateToFilterScreen(contentFilterByTypes: contentFilterByTypes);
      },
    );
  }

  Widget getCatalogContentsListView() {
    return getContentsListViewWidget(
      scrollController: catalogContentScrollController,
      contentsLength: eventProvider.eventsListLength,
      paginationModel: eventProvider.eventsPaginationModel.get(),
      onRefresh: () async {
        getEventCatalogContentsList(
          isRefresh: true,
          isGetFromCache: false,
          isNotify: true,
        );
      },
      onPagination: () async {
        getEventCatalogContentsList(
          isRefresh: false,
          isGetFromCache: false,
          isNotify: false,
        );
      },
    );
  }

  Widget getContentsListViewWidget({
    required PaginationModel paginationModel,
    required int contentsLength,
    required ItemScrollController scrollController,
    required Future<void> Function() onRefresh,
    required Future<void> Function() onPagination,
  }) {
    Widget? calendarWidget = getCalenderWidget();

    if (paginationModel.isFirstTimeLoading) {
      if (calendarWidget != null) {
        return ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 00),
          children: [
            calendarWidget,
            const SizedBox(height: 30),
            const CommonLoader(
              isCenter: true,
            ),
          ],
        );
      } else {
        return const CommonLoader(
          isCenter: true,
        );
      }
    } else if (!paginationModel.isLoading && contentsLength == 0) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                if (calendarWidget != null) calendarWidget,
                SizedBox(height: calendarWidget != null ? 30 : constraints.maxHeight / 5),
                AppConfigurations.commonNoDataView(),
              ],
            ),
          );
        },
      );
    }

    List<MobileLmsCourseModel> list = eventProvider.eventsList.getList(isNewInstance: false);

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ScrollablePositionedList.builder(
        itemScrollController: scrollController,
        scrollOffsetController: scrollOffsetController,
        itemPositionsListener: itemPositionsListener,
        scrollOffsetListener: scrollOffsetListener,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 0),
        itemCount: 1 + list.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return calendarWidget ?? const SizedBox();
          }
          index--;

          if ((index == 0 && list.isEmpty) || index == list.length) {
            if (paginationModel.isLoading) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: const Center(
                  child: CommonLoader(
                    size: 70,
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          }

          if (index > (contentsLength - paginationModel.refreshLimit) && paginationModel.hasMore && !paginationModel.isLoading) {
            onPagination();
          }

          MobileLmsCourseModel model = list[index];

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            child: EventListCard(model: model),
          );
        },
      ),
    );
  }

  Widget? getCalenderWidget() {
    if (tabId != EventCatalogTabTypes.calendarView) {
      return null;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: SfCalendar(
        initialDisplayDate: eventProvider.calenderDate.get(),
        cellEndPadding: 1,
        view: CalendarView.month,
        showNavigationArrow: true,
        headerStyle: const CalendarHeaderStyle(
          textAlign: TextAlign.center,
        ),
        showDatePickerButton: true,
        cellBorderColor: Colors.transparent,
        /*monthCellBuilder: (BuildContext context, MonthCellDetails monthCellDetails) {
            return Text(DatePresentation.getFormattedDate(dateFormat: "d", dateTime: monthCellDetails.date) ?? "");
          },*/
        monthViewSettings: MonthViewSettings(
          monthCellStyle: MonthCellStyle(
            textStyle: themeData.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        onViewChanged: (ViewChangedDetails ee) {
          MyPrint.printOnConsole("onViewChanged called:${ee.visibleDates}");

          onCalenderDateChanged(newDate: ee.visibleDates.elementAtOrNull(10));
        },
      ),
    );
  }

  Widget? getScheduleDateWidget() {
    if (tabId != EventCatalogTabTypes.calendarSchedule) {
      return null;
    }

    DateTime scheduleDate = eventProvider.scheduleDate.get() ?? DateTime.now();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: () {
                onScheduleBackTapped();
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: themeData.colorScheme.onBackground.withAlpha(50)),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_sharp,
                  size: 18,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              onScheduleDateTapped();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DatePresentation.ddMMMMyyyyTimeStamp(Timestamp.fromDate(scheduleDate)),
                    ),
                    const Icon(
                      Icons.arrow_drop_down_sharp,
                    ),
                  ],
                ),
                SizedBox(
                  width: 150,
                  child: Divider(
                    thickness: 1,
                    height: 0,
                    color: themeData.textTheme.labelMedium?.color,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: InkWell(
              onTap: () {
                onScheduleNextTapped();
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: themeData.colorScheme.onBackground.withAlpha(50)),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_sharp,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
