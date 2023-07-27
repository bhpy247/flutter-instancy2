import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class AddDeleteContentUserRatingsRequestModel {
  AddDeleteContentUserRatingsRequestModel({
    this.contentId = "",
    this.userId = "",
    this.title = "",
    this.description = "",
    this.reviewDate = "",
    this.rating = 0,
  });

  String contentId = "";
  String userId = "";
  String title = "";
  String description = "";
  String reviewDate = "";
  int rating = 0;

  AddDeleteContentUserRatingsRequestModel.fromJson(Map<String, dynamic> json) {
    contentId = ParsingHelper.parseStringMethod(json["ContentID"]);
    userId = ParsingHelper.parseStringMethod(json["UserID"]);
    title = ParsingHelper.parseStringMethod(json["Title"]);
    description = ParsingHelper.parseStringMethod(json["Description"]);
    reviewDate = ParsingHelper.parseStringMethod(json["ReviewDate"]);
    rating = ParsingHelper.parseIntMethod(json["Rating"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "ContentID": contentId,
      "UserID": userId,
      "Title": title,
      "Description": description,
      "ReviewDate": reviewDate,
      "Rating": rating,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}