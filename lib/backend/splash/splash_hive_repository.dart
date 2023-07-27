import 'package:flutter_instancy_2/backend/common/main_hive_controller.dart';
import 'package:flutter_instancy_2/hive/hive_operation_controller.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/native_menu_component_model.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:hive/hive.dart';

import '../../configs/app_constants.dart';
import '../../configs/hive_keys.dart';
import '../../hive/hive_call_model.dart';
import '../../models/app_configuration_models/data_models/local_str.dart';
import '../../models/app_configuration_models/data_models/native_menu_model.dart';
import '../../models/app_configuration_models/data_models/tincan_data_model.dart';
import '../../models/app_configuration_models/response_model/mobile_get_learning_portal_info_response_model.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/model_data_parser.dart';

class SplashHiveRepository {
  final HiveOperationController hiveOperationController;
  SplashHiveRepository({required this.hiveOperationController});

  Future<Box?> getBox() => MainHiveController().initializeAppConfigurationBox();

  Future<DataResponseModel<MobileGetLearningPortalInfoResponseModel>> getLearningPlatformInfoData() async {
    Box? box = await getBox();

    String hiveKey = HiveKeys.getMobileGetLearningPortalInfoResponseModelHiveKey();

    DataResponseModel<MobileGetLearningPortalInfoResponseModel> hiveResponseModel = await hiveOperationController.makeCall<MobileGetLearningPortalInfoResponseModel>(
      hiveCallModel: HiveCallModel(
        box: box,
        key: hiveKey,
        parsingType: ModelDataParsingType.mobileGetLearningPortalInfoResponseModel,
        operationType: HiveOperationType.get,
      ),
    );

    return hiveResponseModel;
  }

  Future<bool> setLearningPlatformInfoData({MobileGetLearningPortalInfoResponseModel? model}) async {
    Box? box = await getBox();

    String hiveKey = HiveKeys.getMobileGetLearningPortalInfoResponseModelHiveKey();

    DataResponseModel<void> hiveResponseModel = await hiveOperationController.makeCall<void>(
      hiveCallModel: HiveCallModel(
        box: box,
        key: hiveKey,
        parsingType: ModelDataParsingType.mobileGetLearningPortalInfoResponseModel,
        operationType: HiveOperationType.set,
        value: MyUtils.encodeJson(model?.toJson()),
      ),
    );

    return hiveResponseModel.appErrorModel == null;
  }
  
  Future<DataResponseModel<LocalStr>> getLanguageJsonFile({required String langCode}) async {
    if(langCode.isEmpty) {
      langCode = LocaleType.english;
    }
    
    Box? box = await getBox();
    
    String hiveKey = HiveKeys.getLanguageJsonFileHiveKey(langCode: langCode);

    DataResponseModel<LocalStr> hiveResponseModel = await hiveOperationController.makeCall<LocalStr>(
      hiveCallModel: HiveCallModel(
        box: box,
        key: hiveKey,
        parsingType: ModelDataParsingType.localStr,
        operationType: HiveOperationType.get,
      ),
    );

    return hiveResponseModel;
  }

  Future<bool> setLanguageJsonFile({required String langCode, LocalStr? localStr}) async {
    if(langCode.isEmpty) {
      langCode = LocaleType.english;
    }

    Box? box = await getBox();

    String hiveKey = HiveKeys.getLanguageJsonFileHiveKey(langCode: langCode);

    DataResponseModel<void> hiveResponseModel = await hiveOperationController.makeCall<void>(
      hiveCallModel: HiveCallModel(
        box: box,
        key: hiveKey,
        parsingType: ModelDataParsingType.localStr,
        operationType: HiveOperationType.set,
        value: MyUtils.encodeJson(localStr?.toJson()),
      ),
    );

    return hiveResponseModel.appErrorModel == null;
  }

  Future<DataResponseModel<TinCanDataModel>> getTinCanConfigurations({required String langCode}) async {
    if(langCode.isEmpty) {
      langCode = LocaleType.english;
    }

    Box? box = await getBox();

    String hiveKey = HiveKeys.getTinCanConfigurationsHiveKey(langCode: langCode);

    DataResponseModel<TinCanDataModel> hiveResponseModel = await hiveOperationController.makeCall<TinCanDataModel>(
      hiveCallModel: HiveCallModel(
        box: box,
        key: hiveKey,
        parsingType: ModelDataParsingType.tinCanDataModel,
        operationType: HiveOperationType.get,
      ),
    );

    return hiveResponseModel;
  }

  Future<bool> setTinCanConfigurations({required String langCode, TinCanDataModel? tinCanDataModel}) async {
    if(langCode.isEmpty) {
      langCode = LocaleType.english;
    }

    Box? box = await getBox();

    String hiveKey = HiveKeys.getTinCanConfigurationsHiveKey(langCode: langCode);

    dynamic object = MyUtils.encodeJson(tinCanDataModel?.toJson());
    MyPrint.printOnConsole("object:$object");
    MyPrint.printOnConsole("object type:${object.runtimeType}");

    DataResponseModel<void> hiveResponseModel = await hiveOperationController.makeCall<void>(
      hiveCallModel: HiveCallModel(
        box: box,
        key: hiveKey,
        parsingType: ModelDataParsingType.tinCanDataModel,
        operationType: HiveOperationType.set,
        value: object,
      ),
    );

    return hiveResponseModel.appErrorModel == null;
  }


  Future<DataResponseModel<List<NativeMenuModel>>> getNativeMenuModelsList() async {
    Box? box = await getBox();

    String hiveKey = HiveKeys.getMenusListHiveKey();

    DataResponseModel<List<NativeMenuModel>> hiveResponseModel = await hiveOperationController.makeCall<List<NativeMenuModel>>(
      hiveCallModel: HiveCallModel(
        box: box,
        key: hiveKey,
        parsingType: ModelDataParsingType.nativeMenuModelsList,
        operationType: HiveOperationType.get,
      ),
    );

    return hiveResponseModel;
  }

  Future<bool> setNativeMenuModelsList({List<NativeMenuModel>? list}) async {
    Box? box = await getBox();

    String hiveKey = HiveKeys.getMenusListHiveKey();

    DataResponseModel<void> hiveResponseModel = await hiveOperationController.makeCall<void>(
      hiveCallModel: HiveCallModel(
        box: box,
        key: hiveKey,
        parsingType: ModelDataParsingType.nativeMenuModelsList,
        operationType: HiveOperationType.set,
        value: MyUtils.encodeJson(list?.map((e) => e.toJson()).toList()),
      ),
    );

    return hiveResponseModel.appErrorModel == null;
  }

  Future<DataResponseModel<List<NativeMenuComponentModel>>> getNativeMenuComponentModelsList({required int menuId}) async {
    Box? box = await getBox();

    String hiveKey = HiveKeys.getMenuComponentsListHiveKey(menuId: menuId);

    DataResponseModel<List<NativeMenuComponentModel>> hiveResponseModel = await hiveOperationController.makeCall<List<NativeMenuComponentModel>>(
      hiveCallModel: HiveCallModel(
        box: box,
        key: hiveKey,
        parsingType: ModelDataParsingType.nativeMenusComponentModelsList,
        operationType: HiveOperationType.get,
      ),
    );

    return hiveResponseModel;
  }

  Future<bool> setNativeMenuComponentModelsList({required int menuId, List<NativeMenuComponentModel>? list}) async {
    Box? box = await getBox();

    String hiveKey = HiveKeys.getMenuComponentsListHiveKey(menuId: menuId);

    DataResponseModel<void> hiveResponseModel = await hiveOperationController.makeCall<void>(
      hiveCallModel: HiveCallModel(
        box: box,
        key: hiveKey,
        parsingType: ModelDataParsingType.nativeMenusComponentModelsList,
        operationType: HiveOperationType.set,
        value: MyUtils.encodeJson(list?.map((e) => e.toJson()).toList()),
      ),
    );

    return hiveResponseModel.appErrorModel == null;
  }
}