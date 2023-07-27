import 'package:flutter_instancy_2/backend/discussion/discussion_provider.dart';
import 'package:flutter_instancy_2/backend/discussion/discussion_repository.dart';
import 'package:flutter_instancy_2/models/discussion/data_model/forum_model.dart';
import 'package:flutter_instancy_2/models/discussion/request_model/get_discussion_forum_list_request_model.dart';
import 'package:flutter_instancy_2/models/discussion/response_model/forum_listing_dto_response_model.dart';

import '../../api/api_controller.dart';
import '../../configs/app_configurations.dart';
import '../../models/app_configuration_models/data_models/component_configurations_model.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/pagination/pagination_model.dart';
import '../../models/filter/data_model/enabled_content_filter_by_type_model.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';
import '../configurations/app_configuration_operations.dart';
import '../filter/filter_provider.dart';

class DiscussionController {
  late DiscussionProvider _discussionProvider;
  late DiscussionRepository _discussionRepository;

  DiscussionController({required DiscussionProvider? discussionProvider, DiscussionRepository? repository, ApiController? apiController}) {
    _discussionProvider = discussionProvider ?? DiscussionProvider();
    _discussionRepository = repository ?? DiscussionRepository(apiController: apiController ?? ApiController());
  }

  DiscussionProvider get discussionProvider => _discussionProvider;

  DiscussionRepository get discussionRepository => _discussionRepository;

  //region Initializations
  void initializeConfigurationsFromComponentConfigurationsModel({required ComponentConfigurationsModel componentConfigurationsModel}) {
    discussionProvider.pageSize.set(value: componentConfigurationsModel.itemsPerPage, isNotify: false);
    initializeFilterData(model: componentConfigurationsModel);
  }

  void initializeFilterData({required ComponentConfigurationsModel model}) {
    DiscussionProvider provider = discussionProvider;

    provider.filterProvider
      ..defaultSort.set(value: model.ddlSortList, isNotify: false)
      ..selectedSort.set(value: model.ddlSortList, isNotify: false);
    provider.filterEnabled.set(value: AppConfigurations.getFilterEnabledFromShowIndexes(showIndexes: model.showIndexes), isNotify: false);
    provider.sortEnabled.set(value: AppConfigurations.getSortEnabledFromContentFilterBy(contentFilterBy: model.contentFilterBy), isNotify: false);
  }
  //endregion

  //region Get Forums List with Pagination
  Future<bool> getForumsList({
    bool isRefresh = true,
    bool isGetFromCache = false,
    bool isNotify = true,
    int componentId = -1,
    int componentInstanceId = -1,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
        "DiscussionController().getForumsList() called with isRefresh:$isRefresh, isGetFromCache:$isGetFromCache, "
        "isNotify:$isNotify, componentId:$componentId, componentInstanceId:$componentInstanceId",
        tag: tag);

    DiscussionProvider provider = discussionProvider;
    DiscussionRepository repository = discussionRepository;
    PaginationModel paginationModel = provider.forumListPaginationModel.get();

    //region If Not refresh and Data available, return Cached Data
    if (!isRefresh && isGetFromCache && provider.forumsListLength > 0) {
      MyPrint.printOnConsole("Returning Cached Data", tag: tag);
      return true;
    }
    //endregion

    //region If refresh, then reset provider data
    if (isRefresh) {
      MyPrint.printOnConsole("Refresh", tag: tag);
      PaginationModel.updatePaginationData(
        paginationModel: paginationModel,
        hasMore: true,
        pageIndex: 1,
        isFirstTimeLoading: true,
        isLoading: false,
        notifier: provider.notify,
        notify: false,
      );
      provider.forumsList.setList(list: <ForumModel>[], isClear: true, isNotify: isNotify);
    }
    //endregion

    //region If Not Has More Data, then return
    if (!paginationModel.hasMore) {
      MyPrint.printOnConsole('No More Forum Contents', tag: tag);
      return false;
    }
    //endregion

    //region If Data already Loading, then return
    if (paginationModel.isLoading) return false;
    //endregion

    //region Set Loading True
    PaginationModel.updatePaginationData(
      paginationModel: paginationModel,
      isLoading: true,
      notifier: provider.notify,
      notify: isNotify,
    );
    //endregion

    DateTime startTime = DateTime.now();

    //region Get Request Model From Provider Data
    GetDiscussionForumListRequestModel requestModel = getForumListRequestModelFromProviderData(
      provider: provider,
      paginationModel: paginationModel,
      componentId: componentId,
      componentInstanceId: componentInstanceId,
    );
    //endregion

    //region Make Api Call
    DataResponseModel<ForumListingDTOResponseModel> response = await repository.getForumsList(
      requestModel: requestModel,
    );
    MyPrint.printOnConsole("Forum Response:$response", tag: tag);
    //endregion

    DateTime endTime = DateTime.now();
    MyPrint.printOnConsole("Forum Data got in ${endTime.difference(startTime).inMilliseconds} Milliseconds", tag: tag);

    List<ForumModel> forumsList = response.data?.forumList ?? <ForumModel>[];
    MyPrint.printOnConsole("Forum List Length got in Api:${forumsList.length}", tag: tag);

    //region Set Provider Data After Getting Data From Api
    provider.maxForumListCount.set(value: response.data?.TotalRecordCount ?? 0, isNotify: false);
    provider.forumsList.setList(list: forumsList, isClear: false, isNotify: false);
    PaginationModel.updatePaginationData(
      paginationModel: paginationModel,
      isFirstTimeLoading: false,
      pageIndex: paginationModel.pageIndex + 1,
      hasMore: provider.forumsListLength < provider.maxForumListCount.get(),
      isLoading: false,
      notifier: provider.notify,
      notify: true,
    );
    //endregion

    return true;
  }

  GetDiscussionForumListRequestModel getForumListRequestModelFromProviderData({
    required DiscussionProvider provider,
    required PaginationModel paginationModel,
    required int componentId,
    required int componentInstanceId,
  }) {
    FilterProvider filterProvider = provider.filterProvider;
    EnabledContentFilterByTypeModel? enabledContentFilterByTypeModel = filterProvider.getEnabledContentFilterByTypeModel(isNewInstance: false);

    return GetDiscussionForumListRequestModel(
      intCompID: componentId,
      intCompInsID: componentInstanceId,
      strSearchText: provider.forumListSearchString.get(),
      forumcontentId: provider.forumContentId.get(),
      // userID: "363",
      pageIndex: paginationModel.pageIndex,
      pageSize: provider.pageSize.get(),
      CategoryIds: enabledContentFilterByTypeModel.categories
          ? AppConfigurationOperations.getSeparatorJoinedStringFromStringList(
              list: filterProvider.selectedCategories.getList().map((e) => e.categoryId).toList(),
            )
          : "",
    );
  }
  //endregion
}
