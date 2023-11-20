import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:hive/hive.dart';

import '../../configs/hive_keys.dart';
import '../../hive/hive_call_model.dart';
import '../../hive/hive_operation_controller.dart';
import '../../models/authentication/response_model/email_login_response_model.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/model_data_parser.dart';
import '../../utils/my_print.dart';
import '../common/main_hive_controller.dart';

class AuthenticationHiveRepository {
  final HiveOperationController hiveOperationController;
  AuthenticationHiveRepository({required this.hiveOperationController});

  Future<Box?> getBox() => MainHiveController().initializeAppConfigurationBox();

  Future<EmailLoginResponseModel?> getLoggedInUserData() async {
    Box? box = await getBox();

    EmailLoginResponseModel? successFullUserLoginModel;

    try {
      String hiveKey = HiveKeys.getSuccessfulUserLoginModelHiveKey();

      DataResponseModel<EmailLoginResponseModel> hiveResponseModel = await hiveOperationController.makeCall<EmailLoginResponseModel>(
        hiveCallModel: HiveCallModel(
          box: box,
          key: hiveKey,
          parsingType: ModelDataParsingType.emailLoginResponseModel,
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

  Future<bool> setLoggedInUserData({required EmailLoginResponseModel? responseModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("AuthenticationHiveRepository().setLoggedInUserData() called with responseModel:$responseModel", tag: tag);

    bool isSuccess = false;

    Box? box = await getBox();

    try {
      String hiveKey = HiveKeys.getSuccessfulUserLoginModelHiveKey();

      await hiveOperationController.makeCall<void>(
        hiveCallModel: HiveCallModel(
          box: box,
          key: hiveKey,
          parsingType: ModelDataParsingType.emailLoginResponseModel,
          operationType: HiveOperationType.set,
          value: MyUtils.encodeJson(responseModel?.toJson()),
        ),
      );

      MyPrint.printOnConsole("EmailLoginResponseModel Data Saved in Hive", tag: tag);

      isSuccess = true;
    }
    catch (e, s) {
      MyPrint.printOnConsole("Error in AuthenticationHiveRepository.setLoggedInUserData():$e");
      MyPrint.printOnConsole(s);
    }

    return isSuccess;
  }
}