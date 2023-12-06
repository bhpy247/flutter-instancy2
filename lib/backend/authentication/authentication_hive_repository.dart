import 'package:flutter_instancy_2/models/authentication/data_model/native_login_dto_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:hive/hive.dart';

import '../../configs/hive_keys.dart';
import '../../hive/hive_call_model.dart';
import '../../hive/hive_operation_controller.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/model_data_parser.dart';
import '../../utils/my_print.dart';
import '../common/main_hive_controller.dart';

class AuthenticationHiveRepository {
  final HiveOperationController hiveOperationController;

  AuthenticationHiveRepository({required this.hiveOperationController});

  Future<Box?> getBox() => MainHiveController().initializeAppConfigurationBox();

  Future<NativeLoginDTOModel?> getLoggedInUserData() async {
    Box? box = await getBox();

    NativeLoginDTOModel? successFullUserLoginModel;

    try {
      String hiveKey = HiveKeys.getSuccessfulUserLoginModelHiveKey();

      DataResponseModel<NativeLoginDTOModel> hiveResponseModel = await hiveOperationController.makeCall<NativeLoginDTOModel>(
        hiveCallModel: HiveCallModel(
          box: box,
          key: hiveKey,
          parsingType: ModelDataParsingType.NativeLoginDTOModel,
          operationType: HiveOperationType.get,
        ),
      );

      successFullUserLoginModel = hiveResponseModel.data;
    }
    catch (e, s) {
      MyPrint.printOnConsole("Error in AuthenticationHiveRepository.getLoggedInUserData():$e");
      MyPrint.printOnConsole(s);
    }

    return successFullUserLoginModel;
  }

  Future<bool> saveLoggedInUserDataInHive({required NativeLoginDTOModel? responseModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("AuthenticationHiveRepository().saveLoggedInUserDataInHive() called with responseModel:$responseModel", tag: tag);

    bool isSuccess = false;

    Box? box = await getBox();

    try {
      String hiveKey = HiveKeys.getSuccessfulUserLoginModelHiveKey();

      await hiveOperationController.makeCall<void>(
        hiveCallModel: HiveCallModel(
          box: box,
          key: hiveKey,
          parsingType: ModelDataParsingType.NativeLoginDTOModel,
          operationType: HiveOperationType.set,
          value: MyUtils.encodeJson(responseModel?.toMap()),
        ),
      );

      MyPrint.printOnConsole("EmailLoginResponseModel Data Saved in Hive", tag: tag);

      isSuccess = true;
    }
    catch (e, s) {
      MyPrint.printOnConsole("Error in AuthenticationHiveRepository.saveLoggedInUserDataInHive():$e");
      MyPrint.printOnConsole(s);
    }

    return isSuccess;
  }
}