import 'package:flutter_instancy_2/utils/parsing_helper.dart';

import '../../../utils/my_utils.dart';
import '../data_model/sign_up_response_dto_model.dart';

class SignUpResponseModel {
  SignUpResponseDTOModel? Response;

  SignUpResponseModel({
    this.Response,
  });

  SignUpResponseModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    Map<String, dynamic> ResponseMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(map["Response"]);
    Response = ResponseMap.isNotEmpty ? SignUpResponseDTOModel.fromMap(ResponseMap) : null;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "Response": Response?.toMap(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
