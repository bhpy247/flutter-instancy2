import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class InstructorUserModel {
  String UserID = "";
  String UserName = "";

  InstructorUserModel({
    this.UserID = "",
    this.UserName = "",
  });

  InstructorUserModel.fromJson(Map<String, dynamic> json) {
    UserID = ParsingHelper.parseStringMethod(json["UserID"]);
    UserName = ParsingHelper.parseStringMethod(json["UserName"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "UserID": UserID,
      "UserName": UserName,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}