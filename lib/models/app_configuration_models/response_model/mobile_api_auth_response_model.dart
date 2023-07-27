import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class MobileApiAuthResponseModel {
  String basicAuth = "", uniqueId = "", webApiUrl = "", lmsUrl = "", learnerUrl = "";

  MobileApiAuthResponseModel({
    this.basicAuth = "",
    this.uniqueId = "",
    this.webApiUrl = "",
    this.lmsUrl = "",
    this.learnerUrl = "",
  });

  MobileApiAuthResponseModel.fromJson(Map<String, dynamic> json) {
    basicAuth = ParsingHelper.parseStringMethod(json["basicAuth"]);
    uniqueId = ParsingHelper.parseStringMethod(json["UniqueID"]);
    webApiUrl = ParsingHelper.parseStringMethod(json["WebAPIUrl"]);
    lmsUrl = ParsingHelper.parseStringMethod(json["LMSUrl"]);
    learnerUrl = ParsingHelper.parseStringMethod(json["LearnerURL"]);
  }

  bool get havingRequiredData => webApiUrl.isNotEmpty && lmsUrl.isNotEmpty && learnerUrl.isNotEmpty;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "basicAuth": basicAuth,
      "UniqueID": uniqueId,
      "WebAPIUrl": webApiUrl,
      "LMSUrl": lmsUrl,
      "LearnerURL": learnerUrl,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
