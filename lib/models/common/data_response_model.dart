import 'package:flutter/foundation.dart';

import 'app_error_model.dart';

@immutable
class DataResponseModel<T> {
  final T? data;
  final AppErrorModel? appErrorModel;
  final int statusCode;
  final String? printLogMessage;

  const DataResponseModel({
    this.data,
    this.appErrorModel,
    this.statusCode = -1,
    this.printLogMessage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "data" : data,
      "appErrorModel" : appErrorModel,
      "statusCode" : statusCode,
      "printLogMessage": printLogMessage,
    };
  }

  @override
  String toString() {
    return "DataResponseModel(${toMap()})";
  }
}