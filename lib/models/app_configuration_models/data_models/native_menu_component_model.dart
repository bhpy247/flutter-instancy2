import 'package:flutter_instancy_2/models/app_configuration_models/data_models/component_configurations_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class NativeMenuComponentModel {
  String conditions = "", parameterstrings = "", locale = "";
  int contexttitle = 0, contextmenuid = 0, repositoryid = 0, landingpagetype = 0, categorystyle = 0, componentid = 0;
  ComponentConfigurationsModel componentConfigurationsModel = ComponentConfigurationsModel();

  NativeMenuComponentModel({
    this.conditions = "",
    this.parameterstrings = "",
    this.locale = "",
    this.contexttitle = 0,
    this.contextmenuid = 0,
    this.repositoryid = 0,
    this.landingpagetype = 0,
    this.categorystyle = 0,
    this.componentid = 0,
    ComponentConfigurationsModel? componentConfigurationsModel,
  }) {
    this.componentConfigurationsModel = componentConfigurationsModel ?? ComponentConfigurationsModel();
  }

  NativeMenuComponentModel.fromJson(Map<String, dynamic> json) {
    _initializeFromJson(json);
  }

  void updateFromJson(Map<String, dynamic> json) {
    _initializeFromJson(json);
  }

  void _initializeFromJson(Map<String, dynamic> json) {
    conditions = ParsingHelper.parseStringMethod(json['conditions']);
    parameterstrings = ParsingHelper.parseStringMethod(json['parameterstrings']);
    locale = ParsingHelper.parseStringMethod(json['locale']);
    contexttitle = ParsingHelper.parseIntMethod(json['contexttitle']);
    contextmenuid = ParsingHelper.parseIntMethod(json['contextmenuid']);
    repositoryid = ParsingHelper.parseIntMethod(json['repositoryid']);
    landingpagetype = ParsingHelper.parseIntMethod(json['landingpagetype']);
    categorystyle = ParsingHelper.parseIntMethod(json['categorystyle']);
    componentid = ParsingHelper.parseIntMethod(json['componentid']);

    componentConfigurationsModel = ComponentConfigurationsModel.fromString(conditions);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "conditions": conditions,
      "parameterstrings": parameterstrings,
      "locale": locale,
      "contexttitle": contexttitle,
      "contextmenuid": contextmenuid,
      "repositoryid": repositoryid,
      "landingpagetype": landingpagetype,
      "categorystyle": categorystyle,
      "componentid": componentid,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
