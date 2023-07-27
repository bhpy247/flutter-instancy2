import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';
import '../data_model/people_listing_item_dto_model.dart';

class PeopleListingDTOResponseModel {
  List<PeopleListingItemDTOModel> PeopleList = [];
  int PeopleCount = 0;
  int MainSiteUserID = 0;

  PeopleListingDTOResponseModel({
    List<PeopleListingItemDTOModel>? PeopleList,
    this.PeopleCount = 0,
    this.MainSiteUserID = 0,
  }) {
    this.PeopleList = PeopleList ?? <PeopleListingItemDTOModel>[];
  }

  PeopleListingDTOResponseModel.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> PeopleListMapsList = ParsingHelper.parseMapsListMethod(json["PeopleList"]);
    PeopleList.addAll(PeopleListMapsList.map((e) => PeopleListingItemDTOModel.fromJson(e)).toList());

    PeopleCount = ParsingHelper.parseIntMethod(json["PeopleCount"]);
    MainSiteUserID = ParsingHelper.parseIntMethod(json["MainSiteUserID"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "PeopleList" : PeopleList.map((e) => e.toJson()).toList(),
      "PeopleCount" : PeopleCount,
      "MainSiteUserID" : MainSiteUserID,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}