import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class LearningProviderModel {
  int SiteID = 0;
  int LearningPortalID = 0;
  String LearningProviderName = "";

  LearningProviderModel({
    this.SiteID = 0,
    this.LearningPortalID = 0,
    this.LearningProviderName = "",
  });

  LearningProviderModel.fromJson(Map<String, dynamic> json) {
    SiteID = ParsingHelper.parseIntMethod(json["SiteID"]);
    LearningPortalID = ParsingHelper.parseIntMethod(json["LearningPortalID"]);
    LearningProviderName = ParsingHelper.parseStringMethod(json["LearningProviderName"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "SiteID": SiteID,
      "LearningPortalID": LearningPortalID,
      "LearningProviderName": LearningProviderName,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}