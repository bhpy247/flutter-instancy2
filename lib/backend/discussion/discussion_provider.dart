import 'package:flutter_instancy_2/models/discussion/data_model/forum_model.dart';

import '../../models/common/pagination/pagination_model.dart';
import '../common/common_provider.dart';
import '../filter/filter_provider.dart';

class DiscussionProvider extends CommonProvider {
  DiscussionProvider() {
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

    forumsList = CommonProviderListParameter<ForumModel>(
      list: <ForumModel>[],
      notify: notify,
    );

    forumContentId = CommonProviderPrimitiveParameter<String>(
      value: "",
      notify: notify,
    );
    forumListSearchString = CommonProviderPrimitiveParameter<String>(
      value: "",
      notify: notify,
    );
    maxForumListCount = CommonProviderPrimitiveParameter<int>(
      value: 0,
      notify: notify,
    );
    forumListPaginationModel = CommonProviderPrimitiveParameter<PaginationModel>(
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

  late CommonProviderListParameter<ForumModel> forumsList;
  int get forumsListLength => forumsList.getList(isNewInstance: false).length;

  late final CommonProviderPrimitiveParameter<String> forumContentId;
  late final CommonProviderPrimitiveParameter<String> forumListSearchString;
  late final CommonProviderPrimitiveParameter<int> maxForumListCount;
  late final CommonProviderPrimitiveParameter<PaginationModel> forumListPaginationModel;

  final FilterProvider filterProvider = FilterProvider();

  void resetData() {
    pageSize.set(value: 10, isNotify: false);
    filterEnabled.set(value: false, isNotify: false);
    sortEnabled.set(value: false, isNotify: false);

    forumsList.setList(list: [], isNotify: false);

    forumContentId.set(value: "", isNotify: false);
    forumListSearchString.set(value: "", isNotify: false);
    maxForumListCount.set(value: 0, isNotify: false);
    forumListPaginationModel.set(
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