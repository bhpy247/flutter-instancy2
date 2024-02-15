import 'package:flutter_instancy_2/backend/common/common_provider.dart';
import 'package:flutter_instancy_2/models/app/data_model/dynamic_tabs_dto_model.dart';

import '../../models/common/pagination/pagination_model.dart';
import '../../models/my_connections/data_model/people_listing_item_dto_model.dart';
import '../filter/filter_provider.dart';

class MyConnectionsProvider extends CommonProvider {
  MyConnectionsProvider() {
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

    isLoading = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );

    isShowListView = CommonProviderPrimitiveParameter<bool>(
      value: true,
      notify: notify,
    );
    isPeopleListingActionPerformed = CommonProviderPrimitiveParameter<bool>(
      value: true,
      notify: notify,
    );
    isLoadingTabsList = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    tabsList = CommonProviderListParameter<DynamicTabsDTOModel>(
      list: <DynamicTabsDTOModel>[],
      notify: notify,
    );

    peopleList = CommonProviderListParameter<PeopleListingItemDTOModel>(
      list: <PeopleListingItemDTOModel>[],
      notify: notify,
    );

    peopleListContentId = CommonProviderPrimitiveParameter<String>(
      value: "",
      notify: notify,
    );
    peopleListSearchString = CommonProviderPrimitiveParameter<String>(
      value: "",
      notify: notify,
    );
    maxPeopleListCount = CommonProviderPrimitiveParameter<int>(
      value: 0,
      notify: notify,
    );
    peopleListPaginationModel = CommonProviderPrimitiveParameter<PaginationModel>(
      value: PaginationModel(
        pageIndex: 1,
        pageSize: 10,
        refreshLimit: 3,
      ),
      notify: notify,
    );
  }

  //region Configurations
  late CommonProviderPrimitiveParameter<int> pageSize;
  late CommonProviderPrimitiveParameter<bool> filterEnabled;
  late CommonProviderPrimitiveParameter<bool> sortEnabled;

  //endregion

  late final CommonProviderPrimitiveParameter<bool> isLoading;

  late final CommonProviderPrimitiveParameter<bool> isShowListView;
  late final CommonProviderPrimitiveParameter<bool> isPeopleListingActionPerformed;
  late final CommonProviderPrimitiveParameter<bool> isLoadingTabsList;
  late final CommonProviderListParameter<DynamicTabsDTOModel> tabsList;

  int get tabsLength => tabsList.getList(isNewInstance: false).length;

  late CommonProviderListParameter<PeopleListingItemDTOModel> peopleList;

  int get peopleListLength => peopleList.length;

  late final CommonProviderPrimitiveParameter<String> peopleListContentId;
  late final CommonProviderPrimitiveParameter<String> peopleListSearchString;
  late final CommonProviderPrimitiveParameter<int> maxPeopleListCount;
  late final CommonProviderPrimitiveParameter<PaginationModel> peopleListPaginationModel;

  final FilterProvider filterProvider = FilterProvider();

  void resetData() {
    pageSize.set(value: 10, isNotify: false);
    filterEnabled.set(value: false, isNotify: false);
    sortEnabled.set(value: false, isNotify: false);

    isLoading.set(value: false, isNotify: false);

    isShowListView.set(value: true, isNotify: false);
    isPeopleListingActionPerformed.set(value: false, isNotify: false);
    isLoadingTabsList.set(value: false, isNotify: false);
    tabsList.setList(list: [], isNotify: false);

    peopleList.setList(list: [], isNotify: false);

    peopleListContentId.set(value: "", isNotify: false);
    peopleListSearchString.set(value: "", isNotify: false);
    maxPeopleListCount.set(value: 0, isNotify: false);
    peopleListPaginationModel.set(
      value: PaginationModel(
        pageIndex: 1,
        pageSize: 10,
        refreshLimit: 3,
      ),
      isNotify: false,
    );
    filterProvider.resetData();
  }
}
