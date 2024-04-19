import 'package:flutter_instancy_2/backend/common/common_provider.dart';
import 'package:flutter_instancy_2/backend/filter/filter_provider.dart';
import 'package:flutter_instancy_2/models/common/pagination/pagination_model.dart';

import '../../models/course/data_model/CourseDTOModel.dart';

class MyLearningProvider extends CommonProvider {
  MyLearningProvider() {
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
    consolidationType = CommonProviderPrimitiveParameter<String>(
      value: "all",
      notify: notify,
    );
    archieveEnabled = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );

    myLearningWaitlistContents = CommonProviderListParameter<CourseDTOModel>(
      list: [],
      notify: notify,
    );
    myLearningWaitlistPaginationModel = CommonProviderPrimitiveParameter<PaginationModel>(
      value: PaginationModel(
        pageIndex: 1,
        pageSize: 10,
        refreshLimit: 3,
      ),
      notify: notify,
    );

    myLearningExternalContents = CommonProviderListParameter<CourseDTOModel>(
      list: [],
      notify: notify,
    );
    myLearningExternalPaginationModel = CommonProviderPrimitiveParameter<PaginationModel>(
      value: PaginationModel(
        pageIndex: 1,
        pageSize: 10,
        refreshLimit: 3,
      ),
      notify: notify,
    );
  }

  //region My Learning Content Models map
  final Map<String, CourseDTOModel> _contentsModelMap = <String, CourseDTOModel>{};

  Map<String, CourseDTOModel> get contentsModelMap => _contentsModelMap;

  CourseDTOModel? getMyLearningContentModelFromId({required String contentId}) => contentsModelMap[contentId];

  void setMyLearningContentModelsMap({required Map<String, CourseDTOModel> contents, bool isClear = true, bool isNotify = true}) {
    if (isClear) _contentsModelMap.clear();
    _contentsModelMap.addAll(contents);
    if (isNotify) {
      notifyListeners();
    }
  }

  void updateMyLearningContentModelData({required String contentId, required CourseDTOModel contentModel, bool isNotify = true}) {
    if (contentId.isEmpty) return;

    Map<String, CourseDTOModel> modelsMap = contentsModelMap;

    CourseDTOModel? model = modelsMap[contentId];
    if (model != null) {
      model.updateFromMap(contentModel.toMap());
      if (isNotify) {
        notifyListeners();
      }
    } else {
      setMyLearningContentModelsMap(contents: {contentId: contentModel}, isNotify: isNotify, isClear: false);
    }
  }

  //endregion

  //region My Learning Contents
  void addMyLearningContentsInList({required List<CourseDTOModel> myLearningContentModels, bool isClear = false, bool isNotify = true}) {
    for (CourseDTOModel model in myLearningContentModels) {
      addMyLearningContentIdInIdsList(contentId: model.ContentID, isClear: isClear, isNotify: false);
      updateMyLearningContentModelData(contentId: model.ContentID, contentModel: model, isNotify: false);
    }
    if (isNotify) {
      notifyListeners();
    }
  }

  List<CourseDTOModel> getMyLearningContentsList() {
    List<CourseDTOModel> contents = <CourseDTOModel>[];

    Map<String, CourseDTOModel> map = contentsModelMap;
    for (String element in myLearningContentIds) {
      CourseDTOModel? model = map[element];
      if (model != null) {
        contents.add(model);
      }
    }

    return contents;
  }

  //region My Learning Content Ids List
  final List<String> _myLearningContentIds = <String>[];

  int get myLearningContentsLength => _myLearningContentIds.length;

  List<String> get myLearningContentIds => List.from(_myLearningContentIds);

  void setMyLearningContentIdsList({required List<String> contentIds, bool isClear = true, bool isNotify = true}) {
    if (isClear) _myLearningContentIds.clear();
    _myLearningContentIds.addAll(contentIds);
    if (isNotify) {
      notifyListeners();
    }
  }

  void addMyLearningContentIdInIdsList({required String contentId, bool isClear = false, bool isNotify = true}) {
    if (contentId.isEmpty) return;

    setMyLearningContentIdsList(contentIds: [contentId], isClear: isClear, isNotify: isNotify);
  }

  //endregion

  //region My Learning Search String
  String _myLearningSearchString = "";

  String get myLearningSearchString => _myLearningSearchString;

  void setMyLearningSearchString({required String value, bool isNotify = true}) {
    _myLearningSearchString = value;
    if (isNotify) notifyListeners();
  }

  //endregion

  //region My Learning PaginationModel
  final PaginationModel _myLearningPaginationModel = PaginationModel(
    pageIndex: 1,
    pageSize: 10,
    refreshLimit: 3,
  );

  PaginationModel get myLearningPaginationModel => _myLearningPaginationModel;

  void updateMyLearningPaginationData({
    int? pageIndex,
    int? pageSize,
    int? refreshLimit,
    bool? hasMore,
    bool? isFirstTimeLoading,
    bool? isLoading,
    bool isNotify = true,
  }) {
    PaginationModel paginationModel = myLearningPaginationModel;

    if (pageIndex != null) paginationModel.pageIndex = pageIndex;
    if (pageSize != null) paginationModel.pageSize = pageSize;
    if (refreshLimit != null) paginationModel.refreshLimit = refreshLimit;
    if (hasMore != null) paginationModel.hasMore = hasMore;
    if (isFirstTimeLoading != null) paginationModel.isFirstTimeLoading = isFirstTimeLoading;
    if (isLoading != null) paginationModel.isLoading = isLoading;
    if (isNotify) notifyListeners();
  }

  //endregion
  //endregion

  //region My Learning Archived Contents
  void addMyLearningArchivedContentsInList({required List<CourseDTOModel> myLearningContentModels, bool isClear = false, bool isNotify = true}) {
    for (CourseDTOModel model in myLearningContentModels) {
      addMyLearningArchivedContentIdInIdsList(contentId: model.ContentID, isClear: isClear, isNotify: false);
      updateMyLearningContentModelData(contentId: model.ContentID, contentModel: model, isNotify: false);
    }
    if (isNotify) {
      notifyListeners();
    }
  }

  List<CourseDTOModel> getMyLearningArchivedContentsList() {
    List<CourseDTOModel> contents = <CourseDTOModel>[];

    Map<String, CourseDTOModel> map = contentsModelMap;
    for (String element in myLearningArchivedContentIds) {
      CourseDTOModel? model = map[element];
      if (model != null) {
        contents.add(model);
      }
    }

    return contents;
  }

  //region My Learning Archived Content Ids List
  final List<String> _myLearningArchivedContentIds = <String>[];

  int get myLearningArchivedContentsLength => _myLearningArchivedContentIds.length;

  List<String> get myLearningArchivedContentIds => List.from(_myLearningArchivedContentIds);

  void setMyLearningArchivedContentIdsList({required List<String> contentIds, bool isClear = true, bool isNotify = true}) {
    if (isClear) _myLearningArchivedContentIds.clear();
    _myLearningArchivedContentIds.addAll(contentIds);
    if (isNotify) {
      notifyListeners();
    }
  }

  void addMyLearningArchivedContentIdInIdsList({required String contentId, bool isClear = false, bool isNotify = true}) {
    if (contentId.isEmpty) return;

    setMyLearningArchivedContentIdsList(contentIds: [contentId], isClear: isClear, isNotify: isNotify);
  }

  //endregion

  //region My Learning Archived Search String
  String _myLearningArchivedSearchString = "";

  String get myLearningArchivedSearchString => _myLearningArchivedSearchString;

  void setMyLearningArchivedSearchString({required String value, bool isNotify = true}) {
    _myLearningArchivedSearchString = value;
    if (isNotify) notifyListeners();
  }

  //endregion

  //region My Learning Archived PaginationModel
  final PaginationModel _myLearningArchivedPaginationModel = PaginationModel(
    pageIndex: 1,
    pageSize: 10,
    refreshLimit: 3,
  );

  PaginationModel get myLearningArchivedPaginationModel => _myLearningArchivedPaginationModel;

  void updateMyLearningArchivedPaginationData({
    int? pageIndex,
    int? pageSize,
    int? refreshLimit,
    bool? hasMore,
    bool? isFirstTimeLoading,
    bool? isLoading,
    bool isNotify = true,
  }) {
    PaginationModel paginationModel = myLearningArchivedPaginationModel;

    if (pageIndex != null) paginationModel.pageIndex = pageIndex;
    if (pageSize != null) paginationModel.pageSize = pageSize;
    if (refreshLimit != null) paginationModel.refreshLimit = refreshLimit;
    if (hasMore != null) paginationModel.hasMore = hasMore;
    if (isFirstTimeLoading != null) paginationModel.isFirstTimeLoading = isFirstTimeLoading;
    if (isLoading != null) paginationModel.isLoading = isLoading;
    if (isNotify) notifyListeners();
  }

  //endregion
  //endregion

  //region My Learning Waitlist Contents
  late final CommonProviderListParameter<CourseDTOModel> myLearningWaitlistContents;

  int get myLearningWaitlistContentsLength => myLearningWaitlistContents.getList(isNewInstance: false).length;

  late final CommonProviderPrimitiveParameter<PaginationModel> myLearningWaitlistPaginationModel;

  //endregion

  //region My Learning External Contents
  late final CommonProviderListParameter<CourseDTOModel> myLearningExternalContents;

  int get myLearningExternalContentsLength => myLearningExternalContents.getList(isNewInstance: false).length;

  late final CommonProviderPrimitiveParameter<PaginationModel> myLearningExternalPaginationModel;

  //endregion

  //region Configurations
  late final CommonProviderPrimitiveParameter<int> pageSize;
  late final CommonProviderPrimitiveParameter<bool> filterEnabled;
  late final CommonProviderPrimitiveParameter<bool> sortEnabled;
  late final CommonProviderPrimitiveParameter<String> consolidationType;
  late final CommonProviderPrimitiveParameter<bool> archieveEnabled;

  //endregion

  final FilterProvider filterProvider = FilterProvider();

  void resetData() {
    setMyLearningContentModelsMap(contents: {}, isClear: true, isNotify: false);
    setMyLearningContentIdsList(contentIds: [], isClear: true, isNotify: false);
    setMyLearningSearchString(value: "", isNotify: false);
    updateMyLearningPaginationData(
      pageIndex: 0,
      pageSize: 10,
      refreshLimit: 3,
      hasMore: true,
      isFirstTimeLoading: false,
      isLoading: false,
      isNotify: false,
    );

    setMyLearningArchivedContentIdsList(contentIds: [], isClear: true, isNotify: false);
    setMyLearningArchivedSearchString(value: "", isNotify: false);
    updateMyLearningArchivedPaginationData(
      pageIndex: 0,
      pageSize: 10,
      refreshLimit: 3,
      hasMore: true,
      isFirstTimeLoading: false,
      isLoading: false,
      isNotify: false,
    );

    myLearningWaitlistContents.setList(list: [], isNotify: false);
    myLearningWaitlistPaginationModel.set(
      value: PaginationModel(
        pageIndex: 1,
        pageSize: 10,
        refreshLimit: 3,
      ),
      isNotify: false,
    );

    myLearningExternalContents.setList(list: [], isNotify: false);
    myLearningExternalPaginationModel.set(
      value: PaginationModel(
        pageIndex: 1,
        pageSize: 10,
        refreshLimit: 3,
      ),
      isNotify: false,
    );

    pageSize.set(value: 0, isNotify: false);
    filterEnabled.set(value: false, isNotify: false);
    sortEnabled.set(value: false, isNotify: false);
    consolidationType.set(value: "", isNotify: false);
    archieveEnabled.set(value: false, isNotify: true);
    filterProvider.resetData();
  }
}
