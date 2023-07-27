import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class LikeUserIDModel {
  int UserID = 0;
  String ObjectID = "";

  LikeUserIDModel({
    this.UserID = 0,
    this.ObjectID = "",
  });

  LikeUserIDModel.fromJson(Map<String, dynamic> json) {
    UserID = ParsingHelper.parseIntMethod(json["UserID"]);
    ObjectID = ParsingHelper.parseStringMethod(json["ObjectID"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "UserID": UserID,
      "ObjectID": ObjectID,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}