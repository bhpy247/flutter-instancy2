import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class RemoveExperienceRequestModel {
  String userId = "";
  String displayNo = "";

  RemoveExperienceRequestModel({
    this.userId = "",
    this.displayNo = "",
  });

  RemoveExperienceRequestModel.fromJson(Map<String, dynamic> json) {
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