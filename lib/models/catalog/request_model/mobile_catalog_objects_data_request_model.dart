import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class MobileCatalogObjectsDataRequestModel {
  int pageIndex = 0;
  int pageSize = 0;
  String searchText = "";
  String contentID = "";
  String sortBy = "";
  String componentID = "";
  String componentInsID = "";
  String additionalParams = "";
  String selectedTab = "";
  String addtionalFilter = "";
  String locationFilter = "";
  String userID = "";
  String siteID = "";
  String orgUnitID = "";
  String locale = "";
  String groupBy = "";
  String categories = "";
  String objecttypes = "";
  String skillcats = "";
  String skills = "";
  String jobroles = "";
  String solutions = "";
  String keywords = "";
  String ratings = "";
  String pricerange = "";
  String eventdate = "";
  String certification = "";
  String filtercredits = "";
  String duration = "";
  String instructors = "";
  int iswishlistcontent = 0;

  MobileCatalogObjectsDataRequestModel({
    this.pageIndex = 0,
    this.pageSize = 0,
    this.searchText = "",
    this.contentID = "",
    this.sortBy = "",
    this.componentID = "",
    this.componentInsID = "",
    this.additionalParams = "",
    this.selectedTab = "",
    this.addtionalFilter = "",
    this.locationFilter = "",
    this.userID = "",
    this.siteID = "",
    this.orgUnitID = "",
    this.locale = "",
    this.groupBy = "",
    this.categories = "",
    this.objecttypes = "",
    this.skillcats = "",
    this.skills = "",
    this.jobroles = "",
    this.solutions = "",
    this.keywords = "",
    this.ratings = "",
    this.pricerange = "",
    this.eventdate = "",
    this.certification = "",
    this.filtercredits = "",
    this.duration = "",
    this.instructors = "",
    this.iswishlistcontent = 0,
  });

  MobileCatalogObjectsDataRequestModel.fromJson(Map<String, dynamic> json) {
    pageIndex = ParsingHelper.parseIntMethod(json['pageIndex']);
    pageSize = ParsingHelper.parseIntMethod(json['pageSize']);
    searchText = ParsingHelper.parseStringMethod(json['SearchText']);
    contentID = ParsingHelper.parseStringMethod(json['ContentID']);
    sortBy = ParsingHelper.parseStringMethod(json['sortBy']);
    componentID = ParsingHelper.parseStringMethod(json['ComponentID']);
    componentInsID = ParsingHelper.parseStringMethod(json['ComponentInsID']);
    additionalParams = ParsingHelper.parseStringMethod(json['AdditionalParams']);
    selectedTab = ParsingHelper.parseStringMethod(json['SelectedTab']);
    addtionalFilter = ParsingHelper.parseStringMethod(json['AddtionalFilter']);
    locationFilter = ParsingHelper.parseStringMethod(json['LocationFilter']);
    userID = ParsingHelper.parseStringMethod(json['UserID']);
    siteID = ParsingHelper.parseStringMethod(json['SiteID']);
    orgUnitID = ParsingHelper.parseStringMethod(json['OrgUnitID']);
    locale = ParsingHelper.parseStringMethod(json['Locale']);
    groupBy = ParsingHelper.parseStringMethod(json['groupBy']);
    categories = ParsingHelper.parseStringMethod(json['categories']);
    objecttypes = ParsingHelper.parseStringMethod(json['objecttypes']);
    skillcats = ParsingHelper.parseStringMethod(json['skillcats']);
    skills = ParsingHelper.parseStringMethod(json['skills']);
    jobroles = ParsingHelper.parseStringMethod(json['jobroles']);
    solutions = ParsingHelper.parseStringMethod(json['solutions']);
    keywords = ParsingHelper.parseStringMethod(json['keywords']);
    ratings = ParsingHelper.parseStringMethod(json['ratings']);
    pricerange = ParsingHelper.parseStringMethod(json['pricerange']);
    eventdate = ParsingHelper.parseStringMethod(json['eventdate']);
    certification = ParsingHelper.parseStringMethod(json['certification']);
    filtercredits = ParsingHelper.parseStringMethod(json['filtercredits']);
    duration = ParsingHelper.parseStringMethod(json['duration']);
    instructors = ParsingHelper.parseStringMethod(json['instructors']);
    iswishlistcontent = ParsingHelper.parseIntMethod(json['iswishlistcontent']);
  }

  Map<String, dynamic> toJson() {
    return {
      'pageIndex': pageIndex,
      'pageSize': pageSize,
      'SearchText': searchText,
      'ContentID': contentID,
      'sortBy': sortBy,
      'ComponentID': componentID,
      'ComponentInsID': componentInsID,
      'AdditionalParams': additionalParams,
      'SelectedTab': selectedTab,
      'AddtionalFilter': addtionalFilter,
      'LocationFilter': locationFilter,
      'UserID': userID,
      'SiteID': siteID,
      'OrgUnitID': orgUnitID,
      'Locale': locale,
      'groupBy': groupBy,
      'categories': categories,
      'objecttypes': objecttypes,
      'skillcats': skillcats,
      'skills': skills,
      'jobroles': jobroles,
      'solutions': solutions,
      'keywords': keywords,
      'ratings': ratings,
      'pricerange': pricerange,
      'eventdate': eventdate,
      'certification': certification,
      'filtercredits': filtercredits,
      'duration': duration,
      'instructors': instructors,
      'iswishlistcontent': iswishlistcontent,
    };
  }
}
