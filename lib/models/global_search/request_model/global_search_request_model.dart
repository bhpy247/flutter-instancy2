import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class GlobalSearchResultRequestModel {
  int pageIndex = 0;
  int pageSize = 0;
  int objComponentList = 0;
  int intComponentSiteID = 0;
  int componentID = 0;
  int componentInsID = 0;

  String searchStr = "";
  String source = "";
  String sortBy = "";
  String MultiLocation = "";
  String type = "";
  String fType = "";
  String fValue = "";
  String userID = "";
  String siteID = "";
  String orgUnitID = "";
  String locale = "";
  String groupBy = "";
  String sortType = "";
  String AuthorID = "";
  String keywords = "";

  GlobalSearchResultRequestModel({
    this.pageIndex = 0,
    this.pageSize = 0,
    this.objComponentList = 0,
    this.intComponentSiteID = 0,
    this.componentID = 0,
    this.componentInsID = 0,
    this.searchStr = "",
    this.source = "",
    this.sortBy = "",
    this.MultiLocation = "",
    this.type = "",
    this.fType = "",
    this.fValue = "",
    this.userID = "",
    this.siteID = "",
    this.orgUnitID = "",
    this.locale = "",
    this.groupBy = "",
    this.sortType = "",
    this.AuthorID = "",
    this.keywords = "",
  });

  GlobalSearchResultRequestModel.fromJson(Map<String, dynamic> json) {
    pageIndex = ParsingHelper.parseIntMethod(json['pageIndex']);
    pageSize = ParsingHelper.parseIntMethod(json['pageSize']);
    intComponentSiteID = ParsingHelper.parseIntMethod(json['intComponentSiteID']);
    objComponentList = ParsingHelper.parseIntMethod(json['objComponentList']);
    searchStr = ParsingHelper.parseStringMethod(json['searchStr']);
    type = ParsingHelper.parseStringMethod(json['type']);
    source = ParsingHelper.parseStringMethod(json['source']);
    sortBy = ParsingHelper.parseStringMethod(json['sortBy']);
    componentID = ParsingHelper.parseIntMethod(json['ComponentID']);
    componentInsID = ParsingHelper.parseIntMethod(json['ComponentInsID']);
    MultiLocation = ParsingHelper.parseStringMethod(json['MultiLocation']);
    fType = ParsingHelper.parseStringMethod(json['fType']);
    fValue = ParsingHelper.parseStringMethod(json['fValue']);
    userID = ParsingHelper.parseStringMethod(json['UserID']);
    siteID = ParsingHelper.parseStringMethod(json['SiteID']);
    orgUnitID = ParsingHelper.parseStringMethod(json['OrgUnitID']);
    locale = ParsingHelper.parseStringMethod(json['Locale']);
    groupBy = ParsingHelper.parseStringMethod(json['groupBy']);
    sortType = ParsingHelper.parseStringMethod(json['sortType']);
    AuthorID = ParsingHelper.parseStringMethod(json['AuthorID']);
    keywords = ParsingHelper.parseStringMethod(json['keywords']);
  }

  Map<String, String> toJson() {
    return {
      'pageIndex': pageIndex.toString(),
      'pageSize': pageSize.toString(),
      'intComponentSiteID': intComponentSiteID.toString(),
      'objComponentList': objComponentList.toString(),
      'searchStr': searchStr,
      'source': source,
      'sortBy': sortBy,
      'ComponentID': componentID.toString(),
      'ComponentInsID': componentInsID.toString(),
      'MultiLocation': MultiLocation,
      'type': type,
      'fType': fType,
      'fValue': fValue,
      'UserID': userID,
      'SiteID': siteID,
      'OrgUnitID': orgUnitID,
      'Locale': locale,
      'groupBy': groupBy,
      'sortType': sortType,
      'AuthorID': AuthorID,
      'keywords': keywords,
    };
  }
}
