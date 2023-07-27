import 'package:flutter_instancy_2/hive/hive_call_model.dart';
import 'package:flutter_instancy_2/utils/hive_manager.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';

import '../configs/app_strings.dart';
import '../models/common/app_error_model.dart';
import '../models/common/data_response_model.dart';
import '../models/common/model_data_parser.dart';
import '../utils/my_utils.dart';

class HiveOperationController {
  Future<DataResponseModel<T>> makeCall<T>({required HiveCallModel hiveCallModel}) async {
    MyPrint.printOnConsole("HiveOperationController().makeCall() called with key:'${hiveCallModel.key}', "
        "operationType:'${hiveCallModel.operationType}', Box:'${hiveCallModel.box?.name}', value:${hiveCallModel.value}");

    try {
      dynamic value;
      if(hiveCallModel.operationType == HiveOperationType.get) {
        value = await HiveManager().get(key: hiveCallModel.key, box: hiveCallModel.box);
      }
      else {
        if(hiveCallModel.value == null) {
          await HiveManager().delete(key: hiveCallModel.key, box: hiveCallModel.box);
        }
        else {
          await HiveManager().set(key: hiveCallModel.key, value: hiveCallModel.value, box: hiveCallModel.box);
        }
      }

      if(hiveCallModel.operationType == HiveOperationType.set || (hiveCallModel.operationType == HiveOperationType.get && value != null)) {
        T? data;
        if(hiveCallModel.operationType == HiveOperationType.get) {
          data = ModelDataParser.parseDataFromDecodedValue<T>(parsingType: hiveCallModel.parsingType, decodedValue: MyUtils.decodeJson(value));
        }

        return DataResponseModel<T>(
          data: data,
        );
      }
      else {
        return DataResponseModel<T>(
          appErrorModel: AppErrorModel(
            message: AppStrings.errorInHiveCall,
          ),
        );
      }
    }
    catch(e, s) {
      MyPrint.printOnConsole("Error in HiveOperationController().makeHiveCallAndParseData():$e");
      MyPrint.printOnConsole(s);
      return DataResponseModel<T>(
        appErrorModel: AppErrorModel(
          message: AppStrings.errorInHiveCall,
        ),
      );
    }
  }
}