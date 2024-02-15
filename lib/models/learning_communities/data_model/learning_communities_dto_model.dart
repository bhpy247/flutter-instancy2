import 'package:flutter_chat_bot/utils/parsing_helper.dart';

class LearningCommunitiesDtoModel {
  List<PortalListing>? portallisting;

  LearningCommunitiesDtoModel({this.portallisting});

  LearningCommunitiesDtoModel.fromJson(Map<String, dynamic> json) {
    if (json['portallisting'] != null) {
      portallisting = <PortalListing>[];
      json['portallisting'].forEach((v) {
        portallisting!.add(PortalListing.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (portallisting != null) {
      data['portallisting'] = portallisting!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PortalListing {
  String learningProviderName = "";
  String learningProviderNameONEnlightus = "";
  String description = "";
  String keywords = "";
  String contactFirstName = "";
  String contactMiddleName = "";
  String contactLastName = "";
  String contactAddress1 = "";
  String contactAddress2 = "";
  String contactCity = "";
  String contactState = "";
  String contactCountry = "";
  String contactPhoneNo = "";
  String contactEmail = "";
  String siteURL = "";
  String learnerSiteURL = "";
  String name = "";
  String picture = "";
  String titleWithLink = "";
  String imageWithLink = "";
  String actionGOTO = "";
  String labelAlreadyaMember = "";
  String actionJoinCommunity = "";
  String labelPendingRequest = "";

  int siteID = 0;
  int learningPortalID = 0;
  int parentID = 0;
  int orgUnitID = 0;
  int objectID = 0;
  int categoryID = 0;
  int createdUserID = 0;

  PortalListing({
    this.learningProviderName = "",
    this.learningProviderNameONEnlightus = "",
    this.description = "",
    this.keywords = "",
    this.contactFirstName = "",
    this.contactMiddleName = "",
    this.contactLastName = "",
    this.contactAddress1 = "",
    this.contactAddress2 = "",
    this.contactCity = "",
    this.contactState = "",
    this.contactCountry = "",
    this.contactPhoneNo = "",
    this.contactEmail = "",
    this.name = "",
    this.picture = "",
    this.siteURL = "",
    this.learnerSiteURL = "",
    this.titleWithLink = "",
    this.imageWithLink = "",
    this.actionGOTO = "",
    this.labelAlreadyaMember = "",
    this.actionJoinCommunity = "",
    this.labelPendingRequest = "",
    this.siteID = 0,
    this.learningPortalID = 0,
    this.parentID = 0,
    this.orgUnitID = 0,
    this.objectID = 0,
    this.categoryID = 0,
    this.createdUserID = 0,
  });

  PortalListing.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> json) {
    learningProviderName = ParsingHelper.parseStringMethod(json['LearningProviderName']);
    learningProviderNameONEnlightus = ParsingHelper.parseStringMethod(json['LearningProviderName_ON_Enlightus']);
    description = ParsingHelper.parseStringMethod(json['Description']);
    keywords = ParsingHelper.parseStringMethod(json['Keywords']);
    contactFirstName = ParsingHelper.parseStringMethod(json['Contact_FirstName']);
    contactMiddleName = ParsingHelper.parseStringMethod(json['Contact_MiddleName']);
    contactLastName = ParsingHelper.parseStringMethod(json['Contact_LastName']);
    contactAddress1 = ParsingHelper.parseStringMethod(json['Contact_Address1']);
    contactAddress2 = ParsingHelper.parseStringMethod(json['Contact_Address2']);
    contactCity = ParsingHelper.parseStringMethod(json['Contact_City']);
    contactState = ParsingHelper.parseStringMethod(json['Contact_State']);
    contactCountry = ParsingHelper.parseStringMethod(json['Contact_Country']);
    contactPhoneNo = ParsingHelper.parseStringMethod(json['Contact_PhoneNo']);
    contactEmail = ParsingHelper.parseStringMethod(json['Contact_Email']);
    siteURL = ParsingHelper.parseStringMethod(json['SiteURL']);
    name = ParsingHelper.parseStringMethod(json['name']);
    picture = ParsingHelper.parseStringMethod(json['picture']);
    titleWithLink = ParsingHelper.parseStringMethod(json['TitleWithLink']);
    imageWithLink = ParsingHelper.parseStringMethod(json['ImageWithLink']);
    actionGOTO = ParsingHelper.parseStringMethod(json['actionGOTO']);
    labelAlreadyaMember = ParsingHelper.parseStringMethod(json['labelAlreadyaMember']);
    actionJoinCommunity = ParsingHelper.parseStringMethod(json['actionJoinCommunity']);
    labelPendingRequest = ParsingHelper.parseStringMethod(json['labelPendingRequest']);
    learnerSiteURL = ParsingHelper.parseStringMethod(json['LearnerSiteURL']);
    learningPortalID = ParsingHelper.parseIntMethod(json['LearningPortalID']);
    siteID = ParsingHelper.parseIntMethod(json['SiteID']);
    parentID = ParsingHelper.parseIntMethod(json['ParentID']);
    orgUnitID = ParsingHelper.parseIntMethod(json['OrgUnitID']);
    objectID = ParsingHelper.parseIntMethod(json['ObjectID']);
    categoryID = ParsingHelper.parseIntMethod(json['CategoryID']);
    createdUserID = ParsingHelper.parseIntMethod(json['CreatedUserID']);
  }

  Map<String, dynamic> toJson() {
    return {
      'LearningProviderName': learningProviderName,
      'LearningProviderName_ON_Enlightus': learningProviderNameONEnlightus,
      'Description': description,
      'Keywords': keywords,
      'Contact_FirstName': contactFirstName,
      'Contact_MiddleName': contactMiddleName,
      'Contact_LastName': contactLastName,
      'Contact_Address1': contactAddress1,
      'Contact_Address2': contactAddress2,
      'Contact_City': contactCity,
      'Contact_State': contactState,
      'Contact_Country': contactCountry,
      'Contact_PhoneNo': contactPhoneNo,
      'Contact_Email': contactEmail,
      'SiteURL': siteURL,
      'LearnerSiteURL': learnerSiteURL,
      'name': name,
      'picture': picture,
      'TitleWithLink': titleWithLink,
      'ImageWithLink': imageWithLink,
      'actionGOTO': actionGOTO,
      'labelAlreadyaMember': labelAlreadyaMember,
      'actionJoinCommunity': actionJoinCommunity,
      'labelPendingRequest': labelPendingRequest,
      'LearningPortalID': learningPortalID,
      'SiteID': siteID,
      'ParentID': parentID,
      'OrgUnitID': orgUnitID,
      'ObjectID': objectID,
      'CategoryID': categoryID,
      'CreatedUserID': createdUserID,
    };
  }
}
