import 'package:flutter/foundation.dart';
import 'package:flutter_instancy_2/backend/common/common_provider.dart';

import '../../models/common/pagination/pagination_model.dart';
import '../../models/course/data_model/CourseDTOModel.dart';

class LensProvider extends CommonProvider {
  LensProvider() {
    labels = CommonProviderListParameter<String>(
      list: <String>[],
      notify: notify,
    );
    pageSize = CommonProviderPrimitiveParameter<int>(
      value: 10,
      notify: notify,
    );
    componentId = CommonProviderPrimitiveParameter<int>(
      value: -1,
      notify: notify,
    );
    componentInstanceId = CommonProviderPrimitiveParameter<int>(
      value: -1,
      notify: notify,
    );
    contentsList = CommonProviderListParameter<CourseDTOModel>(
      list: <CourseDTOModel>[],
      notify: notify,
    );
    isLoadingContents = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    contentsPaginationModel = CommonProviderPrimitiveParameter<PaginationModel>(
      value: PaginationModel(
        pageIndex: 1,
        pageSize: 10,
        refreshLimit: 3,
      ),
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
    selectedContentTypes = CommonProviderListParameter<String>(
      list: <String>[],
      notify: notify,
    );

    isShowRetakeButton = ValueNotifier<bool>(true);
  }

  late final CommonProviderListParameter<String> labels;

  //region Configurations
  late CommonProviderPrimitiveParameter<int> pageSize;

  //endregion

  late final CommonProviderPrimitiveParameter<int> componentId;
  late final CommonProviderPrimitiveParameter<int> componentInstanceId;

  late final CommonProviderListParameter<CourseDTOModel> contentsList;
  late final CommonProviderPrimitiveParameter<bool> isLoadingContents;
  late final CommonProviderPrimitiveParameter<PaginationModel> contentsPaginationModel;
  late final CommonProviderPrimitiveParameter<String> currentSearchId;
  late final CommonProviderPrimitiveParameter<String> searchString;
  late CommonProviderListParameter<String> selectedContentTypes;

  late ValueNotifier<bool> isShowRetakeButton;

  void resetContentsData({bool isNotify = true}) {
    labels.setList(list: [], isClear: true, isNotify: false);
    contentsList.setList(list: [], isClear: true, isNotify: false);
    isLoadingContents.set(value: false, isNotify: false);
    contentsPaginationModel.set(
      value: PaginationModel(
        pageIndex: 1,
        pageSize: 10,
        refreshLimit: 3,
      ),
      isNotify: false,
    );
    currentSearchId.set(value: "", isNotify: false);
    searchString.set(value: "", isNotify: isNotify);
  }

  void resetData({bool isNotify = true}) {
    pageSize.set(value: 10, isNotify: false);

    componentId.set(value: -1, isNotify: false);
    componentInstanceId.set(value: -1, isNotify: false);

    resetContentsData(isNotify: false);

    selectedContentTypes.setList(list: [], isClear: true, isNotify: isNotify);
  }
}
