import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class ProfileDataFieldNameModel {
  String datafieldname = "", aliasname = "", attributedisplaytext = "", name = "", valueName = '';
  int groupid = 0, displayorder = 0, attributeconfigid = 0, uicontroltypeid = 0, minlength = 0, maxlength = 0;
  bool isrequired = false, iseditable = false, enduservisibility = false;

  ProfileDataFieldNameModel({
    this.datafieldname = "",
    this.aliasname = "",
    this.attributedisplaytext = "",
    this.name = "",
    this.valueName = "",
    this.groupid = 0,
    this.displayorder = 0,
    this.attributeconfigid = 0,
    this.uicontroltypeid = 0,
    this.minlength = 0,
    this.maxlength = 0,
    this.isrequired = false,
    this.iseditable = false,
    this.enduservisibility = false,
  });

  ProfileDataFieldNameModel.fromJson(Map<String, dynamic> json) {
    datafieldname = ParsingHelper.parseStringMethod(json["datafieldname"]);
    aliasname = ParsingHelper.parseStringMethod(json["aliasname"]);
    attributedisplaytext = ParsingHelper.parseStringMethod(json["attributedisplaytext"]);
    name = ParsingHelper.parseStringMethod(json["name"]);
    valueName = ParsingHelper.parseStringMethod(json["valueName"]);
    groupid = ParsingHelper.parseIntMethod(json["groupid"]);
    displayorder = ParsingHelper.parseIntMethod(json["displayorder"]);
    attributeconfigid = ParsingHelper.parseIntMethod(json["attributeconfigid"]);
    uicontroltypeid = ParsingHelper.parseIntMethod(json["uicontroltypeid"]);
    minlength = ParsingHelper.parseIntMethod(json["minlength"]);
    maxlength = ParsingHelper.parseIntMethod(json["maxlength"]);
    isrequired = ParsingHelper.parseBoolMethod(json["isrequired"]);
    iseditable = ParsingHelper.parseBoolMethod(json["iseditable"]);
    enduservisibility = ParsingHelper.parseBoolMethod(json["enduservisibility"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "datafieldname": datafieldname,
      "aliasname": aliasname,
      "attributedisplaytext": attributedisplaytext,
      "name": name,
      "valueName": valueName,
      "groupid": groupid,
      "displayorder": displayorder,
      "attributeconfigid": attributeconfigid,
      "uicontroltypeid": uicontroltypeid,
      "minlength": minlength,
      "maxlength": maxlength,
      "isrequired": isrequired,
      "iseditable": iseditable,
      "enduservisibility": enduservisibility,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}