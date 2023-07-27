import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class RemoveEducationRequestModel {
  String userId = "";
  String displayNo = "";

  RemoveEducationRequestModel({
    this.userId = "",
    this.displayNo = "",
  });

  RemoveEducationRequestModel.fromJson(Map<String, dynamic> json) {
    userId = ParsingHelper.parseStringMethod(json["UserID"]);
    displayNo = ParsingHelper.parseStringMethod(json["DisplayNo"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "UserID": userId,
      "DisplayNo": displayNo,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}