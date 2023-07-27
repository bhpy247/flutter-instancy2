import 'package:flutter_instancy_2/utils/my_utils.dart';

class PaginationModel {
  PaginationModel({
    int pageIndex = 1,
    int pageSize = 10,
    int refreshLimit = 3,
    bool hasMore = true,
    bool isFirstTimeLoading = false,
    bool isLoading = false,
  }) {
    this.pageIndex = pageIndex;
    this.pageSize = pageSize;
    this.refreshLimit = refreshLimit;
    this.hasMore = hasMore;
    this.isFirstTimeLoading = isFirstTimeLoading;
    this.isLoading = isLoading;
  }

  static void updatePaginationData({
    required PaginationModel paginationModel,
    int? pageIndex,
    int? pageSize,
    int? refreshLimit,
    bool? hasMore,
    bool? isFirstTimeLoading,
    bool? isLoading,
    void Function({bool isNotify})? notifier,
    bool notify = true,
  }) {
    if(pageIndex != null) paginationModel.pageIndex = pageIndex;
    if(pageSize != null) paginationModel.pageSize = pageSize;
    if(refreshLimit != null) paginationModel.refreshLimit = refreshLimit;
    if(hasMore != null) paginationModel.hasMore = hasMore;
    if(isFirstTimeLoading != null) paginationModel.isFirstTimeLoading = isFirstTimeLoading;
    if(isLoading != null) paginationModel.isLoading = isLoading;
    if(notifier != null) notifier(isNotify: notify);
  }

  //region pageIndex
  int _pageIndex = 1;

  int get pageIndex => _pageIndex;

  set pageIndex(int value) {
    _pageIndex = value;
  }
  //endregion

  //region pageSize
  int _pageSize = 10;

  get pageSize => _pageSize;

  set pageSize(value) {
    _pageSize = value;
  }
  //endregion

  //region refreshLimit
  int _refreshLimit = 3;

  get refreshLimit => _refreshLimit;

  set refreshLimit(value) {
    _refreshLimit = value;
  }
  //endregion

  //region hasMore
  bool _hasMore = true;

  bool get hasMore => _hasMore;

  set hasMore(bool value) {
    _hasMore = value;
  }
  //endregion

  //region isFirstTimeLoading
  bool _isFirstTimeLoading = false;

  get isFirstTimeLoading => _isFirstTimeLoading;

  set isFirstTimeLoading(value) {
    _isFirstTimeLoading = value;
  }
  //endregion

  //region isLoading
  bool _isLoading = false;

  get isLoading => _isLoading;

  set isLoading(value) {
    _isLoading = value;
  }
  //endregion

  @override
  String toString() {
    return MyUtils.encodeJson({
      "pageIndex" : pageIndex,
      "pageSize" : pageSize,
      "refreshLimit" : refreshLimit,
      "hasMore" : hasMore,
      "isFirstTimeLoading" : isFirstTimeLoading,
      "isLoading" : isLoading,
    });
  }
}