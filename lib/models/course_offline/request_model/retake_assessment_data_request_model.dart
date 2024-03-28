import 'package:flutter_instancy_2/utils/my_utils.dart';

class RetakeAssessmentDataRequestModel {
  int? userId;
  int? scoId;

  RetakeAssessmentDataRequestModel({
    this.userId,
    this.scoId,
  });

  Map<String, String> toMap() {
    return <String, String>{
      "userId": "${userId ?? ""}",
      "scoId": "${scoId ?? ""}",
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
