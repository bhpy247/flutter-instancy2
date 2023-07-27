import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class ComponentConfigurationsModel {
  bool showArchieve = true, hideExpireCourse = false, enableGroupBy = false, showConsolidatedLearning = false, showWaitList = true, DefaultRepositoryID = false;
  int itemsPerPage = 10;
  String displayOption = "All", ddlSortList = "MC.Name asc", ddlSortType = "asc", sortBy = "", showIndexes = "", filterContentType = "";
  List<String> contentFilterBy = <String>[], ddlGroupBy = <String>[];

  ComponentConfigurationsModel({
    this.showArchieve = true,
    this.hideExpireCourse = false,
    this.enableGroupBy = false,
    this.showConsolidatedLearning = false,
    this.showWaitList = true,
    this.DefaultRepositoryID = false,
    this.itemsPerPage = 10,
    this.displayOption = "All",
    this.ddlSortList = "MC.Name asc",
    this.ddlSortType = "asc",
    this.sortBy = "",
    this.showIndexes = "",
    this.filterContentType = "",
    List<String>? contentFilterBy,
    List<String>? ddlGroupBy,
  }) {
    this.contentFilterBy = contentFilterBy ?? <String>[];
    this.ddlGroupBy = ddlGroupBy ?? <String>[];
  }

  ComponentConfigurationsModel.fromString(String conditionsString) {
    Map<String, String> map = AppConfigurationOperations.getConditionsMapFromConditionsString(conditionsString: conditionsString);

    _initializeFromMap(map);
  }

  void updateFromString(String conditionsString) {
    Map<String, String> map = AppConfigurationOperations.getConditionsMapFromConditionsString(conditionsString: conditionsString);

    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, String> map) {
    showArchieve = ParsingHelper.parseBoolMethod(map['ShowArchieve'], defaultValue: true);
    hideExpireCourse = ParsingHelper.parseBoolMethod(map['hideExpireCourse'], defaultValue: false);
    enableGroupBy = ParsingHelper.parseBoolMethod(map['EnableGroupby'], defaultValue: true);
    showConsolidatedLearning = ParsingHelper.parseBoolMethod(map['showconsolidatedlearning'], defaultValue: false);
    showWaitList = ParsingHelper.parseBoolMethod(map['ShowWaitlist'], defaultValue: true);
    DefaultRepositoryID = ParsingHelper.parseBoolMethod(map['DefaultRepositoryID'], defaultValue: false);
    itemsPerPage = ParsingHelper.parseIntMethod(map['itemsperpage'], defaultValue: 10);
    displayOption = ParsingHelper.parseStringMethod(map['displayoption'], defaultValue: "All");
    ddlSortList = ParsingHelper.parseStringMethod(map['ddlSortList'], defaultValue: "MC.Name asc");
    ddlSortType = ParsingHelper.parseStringMethod(map['ddlSortType'], defaultValue: "asc");
    sortBy = ParsingHelper.parseStringMethod(map['sortby'], defaultValue: "");
    showIndexes = ParsingHelper.parseStringMethod(map['ShowIndexes'], defaultValue: "");
    filterContentType = ParsingHelper.parseStringMethod(map['FilterContentType'], defaultValue: "");

    contentFilterBy = AppConfigurationOperations.getListFromSeparatorJoinedString(parameterString: ParsingHelper.parseStringMethod(map["ContentFilterBy"]),);
    ddlGroupBy = AppConfigurationOperations.getListFromSeparatorJoinedString(parameterString: ParsingHelper.parseStringMethod(map["ddlGroupby"]),);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "ShowArchieve" : showArchieve,
      "hideExpireCourse" : hideExpireCourse,
      "EnableGroupby" : enableGroupBy,
      "showconsolidatedlearning" : showConsolidatedLearning,
      "ShowWaitlist" : showWaitList,
      "DefaultRepositoryID" : DefaultRepositoryID,
      "itemsperpage" : itemsPerPage,
      "displayoption" : displayOption,
      "ddlSortList" : ddlSortList,
      "ddlSortType" : ddlSortType,
      "sortby" : sortBy,
      "ShowIndexes" : showIndexes,
      "FilterContentType" : filterContentType,
      "ContentFilterBy" : AppConfigurationOperations.getSeparatorJoinedStringFromStringList(list: contentFilterBy),
      "ddlGroupby" : AppConfigurationOperations.getSeparatorJoinedStringFromStringList(list: ddlGroupBy),
    };
  }

  @override
  String toString() {
    return AppConfigurationOperations.getConditionsStringFromConditionsMap(conditionsMap: toMap());
  }
}