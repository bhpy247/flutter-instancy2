import 'package:flutter_chat_bot/utils/parsing_helper.dart';

import '../../../utils/my_utils.dart';

class GlobalSearchComponentResponseModel {
  List<SearchComponents> searchComponents = [];

  GlobalSearchComponentResponseModel({this.searchComponents = const []});

  GlobalSearchComponentResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['SearchComponents'] != null) {
      searchComponents = <SearchComponents>[];
      json['SearchComponents'].forEach((v) {
        searchComponents.add(SearchComponents.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SearchComponents'] = searchComponents.map((v) => v.toJson()).toList();
    return data;
  }
}

class SearchComponents {
  int menuID = 0;
  int siteID = 0;
  int componentInstanceID = 0;
  int nativeCompID = 0;
  String name = "";
  int componentID = 0;
  String contextTitle = "";
  String siteName = "";
  String displayName = "";
  String learnerSiteURL = "";
  bool check = false;

  SearchComponents({
    this.componentID = 0,
    this.menuID = 0,
    this.siteID = 0,
    this.componentInstanceID = 0,
    this.nativeCompID = 0,
    this.name = "",
    this.contextTitle = "",
    this.siteName = "",
    this.displayName = "",
    this.learnerSiteURL = "",
    this.check = false,
  });

  SearchComponents.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> json) {
    name = ParsingHelper.parseStringMethod(json['Name']);
    componentID = ParsingHelper.parseIntMethod(json['ComponentID']);
    menuID = ParsingHelper.parseIntMethod(json['MenuID']);
    siteID = ParsingHelper.parseIntMethod(json['SiteID']);
    componentInstanceID = ParsingHelper.parseIntMethod(json['ComponentInstanceID']);
    contextTitle = ParsingHelper.parseStringMethod(json['ContextTitle']);
    siteName = ParsingHelper.parseStringMethod(json['SiteName']);
    displayName = ParsingHelper.parseStringMethod(json['DisplayName']);
    learnerSiteURL = ParsingHelper.parseStringMethod(json['LearnerSiteURL']);
    nativeCompID = ParsingHelper.parseIntMethod(json['NativeCompID']);
    check = ParsingHelper.parseBoolMethod(json['Check']);
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'ComponentID': componentID,
      'MenuID': menuID,
      'SiteID': siteID,
      'ComponentInstanceID': componentInstanceID,
      'ContextTitle': contextTitle,
      'SiteName': siteName,
      'DisplayName': displayName,
      'LearnerSiteURL': learnerSiteURL,
      'NativeCompID': nativeCompID,
      'Check': check,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
