import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class ContentUserRatingModel {
  String userName = "";
  String title = "";
  String description = "";
  String reviewDate = "";
  String picture = "";
  String ratingSiteId = "";
  String errorMessage = "";
  int ratingId = 0;
  int ratingUserId = 0;
  int intApprovalStatus = 0;

  ContentUserRatingModel({
    this.userName = "",
    this.title = "",
    this.description = "",
    this.reviewDate = "",
    this.picture = "",
    this.ratingSiteId = "",
    this.errorMessage = "",
    this.ratingId = 0,
    this.ratingUserId = 0,
    this.intApprovalStatus = 0,
  });

  ContentUserRatingModel.fromJson(Map<String, dynamic> json) {
    userName = ParsingHelper.parseStringMethod(json["UserName"]);
    title = ParsingHelper.parseStringMethod(json["Title"]);
    description = ParsingHelper.parseStringMethod(json["Description"]);
    reviewDate = ParsingHelper.parseStringMethod(json["ReviewDate"]);
    picture = ParsingHelper.parseStringMethod(json["picture"]);
    ratingSiteId = ParsingHelper.parseStringMethod(json["RatingSiteID"]);
    errorMessage = ParsingHelper.parseStringMethod(json["ErrorMessage"]);
    ratingId = ParsingHelper.parseIntMethod(json["RatingID"]);
    ratingUserId = ParsingHelper.parseIntMethod(json["RatingUserID"]);
    intApprovalStatus = ParsingHelper.parseIntMethod(json["intApprovalStatus"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "UserName": userName,
      "Title": title,
      "Description": description,
      "ReviewDate": reviewDate,
      "picture": picture,
      "RatingSiteID": ratingSiteId,
      "ErrorMessage": errorMessage,
      "RatingID": ratingId,
      "RatingUserID": ratingUserId,
      "intApprovalStatus": intApprovalStatus,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}