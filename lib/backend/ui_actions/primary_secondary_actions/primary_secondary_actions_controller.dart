import 'package:flutter_chat_bot/utils/my_print.dart';
import 'package:flutter_instancy_2/configs/app_constants.dart';

import 'primary_secondary_actions_configs.dart';
import 'primary_secondary_actions_constants.dart';
import 'primary_secondary_actions_data_model.dart';

class PrimarySecondaryActionsController {
  static List<InstancyContentActionsEnum> getPrimaryActionForMyLearningContent({
    required int viewType,
    required int objectTypeId,
    required int mediaTypeId,
  }) {
    PrimarySecondaryActionsDataModel? primarySecondaryActionsDataModel = getPrimarySecondaryActionDataForContent(
      viewType: viewType,
      objectTypeId: objectTypeId,
      mediaTypeId: mediaTypeId,
      screenType: InstancyContentScreenType.MyLearning,
    );

    return List.from(primarySecondaryActionsDataModel?.primaryActions ?? <InstancyContentActionsEnum>[]);
  }

  static List<InstancyContentActionsEnum> getSecondaryActionForMyLearningContent({
    required int viewType,
    required int objectTypeId,
    required int mediaTypeId,
  }) {
    PrimarySecondaryActionsDataModel? primarySecondaryActionsDataModel = getPrimarySecondaryActionDataForContent(
      viewType: viewType,
      objectTypeId: objectTypeId,
      mediaTypeId: mediaTypeId,
      screenType: InstancyContentScreenType.MyLearning,
    );

    return List.from(primarySecondaryActionsDataModel?.secondaryActions ?? <InstancyContentActionsEnum>[]);
  }

  static List<InstancyContentActionsEnum> getPrimaryActionForCatalogContent({
    required int viewType,
    required int objectTypeId,
    required int mediaTypeId,
  }) {
    PrimarySecondaryActionsDataModel? primarySecondaryActionsDataModel = getPrimarySecondaryActionDataForContent(
      viewType: viewType,
      objectTypeId: objectTypeId,
      mediaTypeId: mediaTypeId,
      screenType: InstancyContentScreenType.Catalog,
    );
    // MyPrint.printOnConsole("primarySecondaryActionsDataModel:$primarySecondaryActionsDataModel");

    return List.from(primarySecondaryActionsDataModel?.primaryActions ?? <InstancyContentActionsEnum>[]);
  }

  static List<InstancyContentActionsEnum> getSecondaryActionForCatalogContent({
    required int viewType,
    required int objectTypeId,
    required int mediaTypeId,
  }) {
    PrimarySecondaryActionsDataModel? primarySecondaryActionsDataModel = getPrimarySecondaryActionDataForContent(
      viewType: viewType,
      objectTypeId: objectTypeId,
      mediaTypeId: mediaTypeId,
      screenType: InstancyContentScreenType.Catalog,
    );

    return List.from(primarySecondaryActionsDataModel?.secondaryActions ?? <InstancyContentActionsEnum>[]);
  }

  static PrimarySecondaryActionsDataModel? getPrimarySecondaryActionDataForContent({
    required int objectTypeId,
    required int mediaTypeId,
    required int viewType,
    required InstancyContentScreenType screenType,
  }) {
    /*if(viewType == ViewTypesForContent.ViewAndAddToMyLearning) {
      viewType = ViewTypesForContent.View;
    }*/

    PrimarySecondaryActionsDataModel? model;

    Map<int, Map<int, Map<int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>>> primarySecondaryActions = PrimarySecondaryActionsConfigs.primarySecondaryActions;
    if(primarySecondaryActions.isEmpty) return model;

    Map<int, Map<int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>>> map1 = primarySecondaryActions[objectTypeId] ?? {};
    if(primarySecondaryActions.isEmpty) return model;

    Map<int, Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel>> map2 = map1[mediaTypeId] ?? {};
    if(mediaTypeId != 0 && map2.isEmpty) {
      map2 = map1[InstancyMediaTypes.none] ?? {};
    }
    if(map2.isEmpty) return model;

    Map<InstancyContentScreenType, PrimarySecondaryActionsDataModel> map3 = map2[viewType] ?? {};
    if(map3.isEmpty) return model;

    model = map3[screenType];
    MyPrint.printOnConsole("objectTypeId : ${objectTypeId}, model  : ${model?.primaryActions}");

    return model;
  }
}