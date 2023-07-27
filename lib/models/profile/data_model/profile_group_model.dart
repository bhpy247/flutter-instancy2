import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';
import 'data_field_model.dart';

class ProfileGroupModel {
  int groupid = 0, objecttypeid = 0, siteid = 0, showinprofile = 0, displayorder = 0;
  String groupname = "", localeid = "";
  List<DataFieldModel> datafilelist = <DataFieldModel>[];

  ProfileGroupModel({
    this.groupid = 0,
    this.objecttypeid = 0,
    this.siteid = 0,
    this.showinprofile = 0,
    this.displayorder = 0,
    this.groupname = "",
    this.localeid = "",
    this.datafilelist = const [],
  });

  ProfileGroupModel.fromJson(Map<String, dynamic> json){
    groupid = ParsingHelper.parseIntMethod(json["groupid"]);
    objecttypeid = ParsingHelper.parseIntMethod(json["objecttypeid"]);
    siteid = ParsingHelper.parseIntMethod(json["siteid"]);
    showinprofile = ParsingHelper.parseIntMethod(json["showinprofile"]);
    displayorder = ParsingHelper.parseIntMethod(json["displayorder"]);
    groupname = ParsingHelper.parseStringMethod(json["groupname"]);
    localeid = ParsingHelper.parseStringMethod(json["localeid"]);
    datafilelist = ParsingHelper.parseMapsListMethod<String, dynamic>(json["datafilelist"]).map((x) => DataFieldModel.fromJson(x)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      "groupid": groupid,
      "objecttypeid": objecttypeid,
      "siteid": siteid,
      "showinprofile": showinprofile,
      "displayorder": displayorder,
      "groupname": groupname,
      "localeid": localeid,
      "datafilelist": datafilelist.map((x) => x.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}