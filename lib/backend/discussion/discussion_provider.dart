import 'package:flutter_instancy_2/models/discussion/data_model/forum_info_user_model.dart';
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

    forumsMap = CommonProviderMapParameter<int, ForumModel>(
      map: <int, ForumModel>{},
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

    myDiscussionForumsList = CommonProviderListParameter<ForumModel>(
      list: <ForumModel>[],
      notify: notify,
    );
    myDiscussionForumContentId = CommonProviderPrimitiveParameter<String>(
      value: "",
      notify: notify,
    );
    myDiscussionForumListSearchString = CommonProviderPrimitiveParameter<String>(
      value: "",
      notify: notify,
    );
    maxMyDiscussionForumListCount = CommonProviderPrimitiveParameter<int>(
      value: 0,
      notify: notify,
    );
    myDiscussionForumListPaginationModel = CommonProviderPrimitiveParameter<PaginationModel>(
      value: PaginationModel(
        pageIndex: 1,
        pageSize: 10,
        refreshLimit: 3,
      ),
      notify: notify,
    );

    isCreateForum = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    isEditForum = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    isDeleteForum = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    isLoading = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );

    moderatorsList = CommonProviderListParameter<ForumUserInfoModel>(
      list: [],
      notify: notify,
    );
  }

  //region Configurations
  late CommonProviderPrimitiveParameter<int> pageSize;
  late CommonProviderPrimitiveParameter<bool> filterEnabled;
  late CommonProviderPrimitiveParameter<bool> sortEnabled;

  //endregion

  late CommonProviderMapParameter<int, ForumModel> forumsMap;

  late CommonProviderListParameter<ForumModel> forumsList;
  late final CommonProviderPrimitiveParameter<String> forumContentId;
  late final CommonProviderPrimitiveParameter<String> forumListSearchString;
  late final CommonProviderPrimitiveParameter<int> maxForumListCount;
  late final CommonProviderPrimitiveParameter<PaginationModel> forumListPaginationModel;

  late CommonProviderListParameter<ForumModel> myDiscussionForumsList;
  late final CommonProviderPrimitiveParameter<String> myDiscussionForumContentId;
  late final CommonProviderPrimitiveParameter<String> myDiscussionForumListSearchString;
  late final CommonProviderPrimitiveParameter<int> maxMyDiscussionForumListCount;
  late final CommonProviderPrimitiveParameter<PaginationModel> myDiscussionForumListPaginationModel;

  late final CommonProviderPrimitiveParameter<bool> isCreateForum;
  late final CommonProviderPrimitiveParameter<bool> isEditForum;
  late final CommonProviderPrimitiveParameter<bool> isDeleteForum;
  late final CommonProviderPrimitiveParameter<bool> isLoading;

  late final CommonProviderListParameter<ForumUserInfoModel> moderatorsList;

  final FilterProvider filterProvider = FilterProvider();

  void resetData() {
    pageSize.set(value: 10, isNotify: false);
    filterEnabled.set(value: false, isNotify: false);
    sortEnabled.set(value: false, isNotify: false);

    forumsMap.setMap(map: {}, isClear: true, isNotify: false);

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

    myDiscussionForumsList.setList(list: [], isNotify: false);
    myDiscussionForumContentId.set(value: "", isNotify: false);
    myDiscussionForumListSearchString.set(value: "", isNotify: false);
    maxMyDiscussionForumListCount.set(value: 0, isNotify: false);
    myDiscussionForumListPaginationModel.set(
      value: PaginationModel(
        pageIndex: 1,
        pageSize: 10,
        refreshLimit: 3,
      ),
      isNotify: false,
    );

    isCreateForum.set(value: false, isNotify: false);
    isEditForum.set(value: false, isNotify: false);
    isDeleteForum.set(value: false, isNotify: false);
    isLoading.set(value: false, isNotify: false);

    moderatorsList.setList(list: [], isClear: true, isNotify: true);

    filterProvider.resetData();
  }
}
