import 'package:flutter_instancy_2/backend/common/common_provider.dart';

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

  late CommonProviderListParameter<PeopleListingItemDTOModel> peopleList;
  int get peopleListLength => peopleList.getList(isNewInstance: false).length;

  late final CommonProviderPrimitiveParameter<String> peopleListContentId;
  late final CommonProviderPrimitiveParameter<String> peopleListSearchString;
  late final CommonProviderPrimitiveParameter<int> maxPeopleListCount;
  late final CommonProviderPrimitiveParameter<PaginationModel> peopleListPaginationModel;

  final FilterProvider filterProvider = FilterProvider();

  void resetData() {
    pageSize.set(value: 10, isNotify: false);
    filterEnabled.set(value: false, isNotify: false);
    sortEnabled.set(value: false, isNotify: false);

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