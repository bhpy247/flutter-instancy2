import 'package:flutter/cupertino.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class NativeMenuModel {
  int displayorder = 0, menuid = 0, parentmenuid = 0, webmenuid = 0;
  String displayname = "", image = "", locale = "";
  bool isofflinemenu = false, isenabled = false, ismultiplecomponent = false;
  IconData? menuIconData;

  NativeMenuModel({
    this.displayorder = 0,
    this.menuid = 0,
    this.parentmenuid = 0,
    this.webmenuid = 0,
    this.displayname = "",
    this.image = "",
    this.locale = "",
    this.isofflinemenu = false,
    this.isenabled = false,
    this.ismultiplecomponent = false,
    this.menuIconData,
  });

  NativeMenuModel.fromJson(Map<String, dynamic> json) {
    _initializeFromJson(json);
  }

  void updateFromJson(Map<String, dynamic> json) {
    _initializeFromJson(json);
  }

  void _initializeFromJson(Map<String, dynamic> json) {
    displayorder = ParsingHelper.parseIntMethod(json['displayorder']);
    menuid = ParsingHelper.parseIntMethod(json['menuid']);
    parentmenuid = ParsingHelper.parseIntMethod(json['parentmenuid']);
    webmenuid = ParsingHelper.parseIntMethod(json['webmenuid']);
    displayname = ParsingHelper.parseStringMethod(json['displayname']);
    image = ParsingHelper.parseStringMethod(json['image']);
    locale = ParsingHelper.parseStringMethod(json['locale']);
    isofflinemenu = ParsingHelper.parseBoolMethod(json['isofflinemenu']);
    isenabled = ParsingHelper.parseBoolMethod(json['isenabled']);
    ismultiplecomponent = ParsingHelper.parseBoolMethod(json['ismultiplecomponent']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "displayorder": displayorder,
      "menuid": menuid,
      "parentmenuid": parentmenuid,
      "webmenuid": webmenuid,
      "displayname": displayname,
      "image": image,
      "locale": locale,
      "isofflinemenu": isofflinemenu,
      "isenabled": isenabled,
      "ismultiplecomponent": ismultiplecomponent,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
