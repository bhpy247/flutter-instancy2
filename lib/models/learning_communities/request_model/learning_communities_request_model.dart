import '../../../utils/parsing_helper.dart';

class GetLearningCommunitiesRequestModel {
  String FilterCondition = "";
  String SortCondition = "";
  String SearchText = "";
  int RecordCount = 0;
  int ComponentID = 0;
  int ComponentInstanceID = 0;
  int SiteID = 0;
  int UserID = 0;

  GetLearningCommunitiesRequestModel({
    this.FilterCondition = "",
    this.SortCondition = "",
    this.SearchText = "",
    this.RecordCount = 0,
    this.ComponentID = 0,
    this.ComponentInstanceID = 0,
    this.SiteID = 0,
    this.UserID = 0,
  });

  GetLearningCommunitiesRequestModel.fromJson(Map<String, dynamic> json) {
    FilterCondition = ParsingHelper.parseStringMethod(json['FilterCondition']);
    SortCondition = ParsingHelper.parseStringMethod(json['SortCondition']);
    SearchText = ParsingHelper.parseStringMethod(json['SearchText']);
    RecordCount = ParsingHelper.parseIntMethod(json['RecordCount']);
    ComponentID = ParsingHelper.parseIntMethod(json['ComponentID']);
    ComponentInstanceID = ParsingHelper.parseIntMethod(json['ComponentInstanceID']);
    SiteID = ParsingHelper.parseIntMethod(json['SiteID']);
    UserID = ParsingHelper.parseIntMethod(json[' UserID']);
  }

  Map<String, String> toJson() {
    return {
      'FilterCondition': FilterCondition,
      'SortCondition': '"$SortCondition"',
      'SearchText': SearchText,
      'RecordCount': ParsingHelper.parseStringMethod(RecordCount),
      'ComponentID': ParsingHelper.parseStringMethod(ComponentID),
      'ComponentInstanceID': ParsingHelper.parseStringMethod(ComponentInstanceID),
      'UserID': ParsingHelper.parseStringMethod(UserID),
      'SiteID': ParsingHelper.parseStringMethod(SiteID),
    };
  }
}
