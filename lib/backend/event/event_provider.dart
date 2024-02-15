import '../../models/app/data_model/dynamic_tabs_dto_model.dart';
import '../../models/common/pagination/pagination_model.dart';
import '../../models/course/data_model/CourseDTOModel.dart';
import '../common/common_provider.dart';
import '../filter/filter_provider.dart';

class EventProvider extends CommonProvider {
  EventProvider() {
    eventSessionData = CommonProviderListParameter<CourseDTOModel>(
      list: <CourseDTOModel>[],
      notify: notify,
    );
    isLoadingEventSessionData = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );

    tabsMap = CommonProviderMapParameter<String, DynamicTabsDTOModel>(
      map: <String, DynamicTabsDTOModel>{},
      notify: notify,
    );
    calenderDatesHavingEventMap = CommonProviderMapParameter<String, int>(
      map: <String, int>{},
      notify: notify,
    );
    tabsList = CommonProviderListParameter<String>(
      list: <String>[],
      notify: notify,
    );
    isLoadingTabsList = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );

    pageSize = CommonProviderPrimitiveParameter<int>(
      value: 10,
      notify: notify,
    );
    filterEnabled = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    sortEnabled = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    currentSearchId = CommonProviderPrimitiveParameter<String>(
      value: "",
      notify: notify,
    );
    searchString = CommonProviderPrimitiveParameter<String>(
      value: "",
      notify: notify,
    );
    eventsList = CommonProviderListParameter<CourseDTOModel>(
      list: [],
      notify: notify,
    );
    selectedCalendarDateEventList = CommonProviderListParameter<CourseDTOModel>(
      list: [],
      notify: notify,
    );
    eventsPaginationModel = CommonProviderPrimitiveParameter<PaginationModel>(
      value: PaginationModel(
        pageIndex: 1,
        pageSize: 10,
        refreshLimit: 3,
      ),
      notify: notify,
    );
    calenderDate = CommonProviderPrimitiveParameter<DateTime?>(
      value: null,
      notify: notify,
    );
    selectedCalenderDate = CommonProviderPrimitiveParameter<DateTime>(
      value: DateTime.now(),
      notify: notify,
    );
    scheduleDate = CommonProviderPrimitiveParameter<DateTime?>(
      value: null,
      notify: notify,
    );
  }

  late final CommonProviderListParameter<CourseDTOModel> eventSessionData;

  int get eventSessionDataLength => eventSessionData.getList(isNewInstance: false).length;
  late final CommonProviderPrimitiveParameter<bool> isLoadingEventSessionData;

  //region Tabs
  //region Tabs Map
  late final CommonProviderMapParameter<String, DynamicTabsDTOModel> tabsMap;

  DynamicTabsDTOModel? getTabModel({required String tabId}) {
    return tabId.isEmpty ? null : tabsMap.getMap(isNewInstance: false)[tabId];
  }

  void setTabModel({required String tabId, DynamicTabsDTOModel? tabDataModel, bool isNotify = true}) {
    if (tabId.isEmpty) return;

    if (tabDataModel != null) {
      tabsMap.setMap(map: {tabId: tabDataModel}, isClear: false, isNotify: isNotify);
    } else {
      tabsMap.clearKey(key: tabId);
    }
  }

  //endregion

  //region Tabs List
  late final CommonProviderListParameter<String> tabsList;

  int get tabsLength => tabsList.getList(isNewInstance: false).length;

  List<DynamicTabsDTOModel> getTabModelsList() {
    Map<String, DynamicTabsDTOModel> map = tabsMap.getMap(isNewInstance: false);

    List<DynamicTabsDTOModel> list = [];
    for (String tabId in tabsList.getList(isNewInstance: false)) {
      DynamicTabsDTOModel? model = map[tabId];
      if (model != null) {
        list.add(model);
      }
    }

    return list;
  }

  //endregion

  late final CommonProviderPrimitiveParameter<bool> isLoadingTabsList;

  //endregion

  //region Configurations
  late CommonProviderPrimitiveParameter<int> pageSize;
  late CommonProviderPrimitiveParameter<bool> filterEnabled;
  late CommonProviderPrimitiveParameter<bool> sortEnabled;

  //endregion

  late final CommonProviderPrimitiveParameter<String> currentSearchId;
  late final CommonProviderPrimitiveParameter<String> searchString;

  late final CommonProviderListParameter<CourseDTOModel> eventsList;
  late final CommonProviderListParameter<CourseDTOModel> selectedCalendarDateEventList;
  late final CommonProviderMapParameter<String, int> calenderDatesHavingEventMap;

  int get eventsListLength => eventsList.getList(isNewInstance: false).length;

  late final CommonProviderPrimitiveParameter<PaginationModel> eventsPaginationModel;
  late final CommonProviderPrimitiveParameter<DateTime?> calenderDate;
  late final CommonProviderPrimitiveParameter<DateTime> selectedCalenderDate;
  late final CommonProviderPrimitiveParameter<DateTime?> scheduleDate;

  final FilterProvider filterProvider = FilterProvider();

  void resetData() {
    eventSessionData.setList(list: [], isClear: true, isNotify: false);
    isLoadingEventSessionData.set(value: false, isNotify: true);

    tabsMap.setMap(map: {}, isClear: true, isNotify: false);
    calenderDatesHavingEventMap.setMap(map: {}, isClear: true, isNotify: false);
    tabsList.setList(list: [], isClear: true, isNotify: false);
    isLoadingTabsList.set(value: false, isNotify: true);

    pageSize.set(value: 10, isNotify: false);
    filterEnabled.set(value: false, isNotify: false);
    sortEnabled.set(value: false, isNotify: false);

    currentSearchId.set(value: "", isNotify: false);
    searchString.set(value: "", isNotify: false);
    eventsList.setList(list: [], isNotify: false);
    selectedCalendarDateEventList.setList(list: [], isNotify: false);
    eventsPaginationModel.set(
      value: PaginationModel(
        pageIndex: 1,
        pageSize: 10,
        refreshLimit: 3,
      ),
      isNotify: false,
    );
    calenderDate.set(value: null, isNotify: false);
    scheduleDate.set(value: null, isNotify: false);
    selectedCalenderDate.set(value: DateTime.now(), isNotify: false);
    filterProvider.resetData();
  }
}
