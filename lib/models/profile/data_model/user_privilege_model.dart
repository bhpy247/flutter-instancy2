import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class UserPrivilegeModel {
  int userid = 0, privilegeid = 0, componentid = 0, parentprivilegeid = 0, objecttypeid = 0, roleid = 0;

  UserPrivilegeModel({
    this.userid = 0,
    this.privilegeid = 0,
    this.componentid = 0,
    this.parentprivilegeid = 0,
    this.objecttypeid = 0,
    this.roleid = 0,
  });

  UserPrivilegeModel.fromJson(Map<String, dynamic> json) {
    userid = ParsingHelper.parseIntMethod(json["userid"]);
    privilegeid = ParsingHelper.parseIntMethod(json["privilegeid"]);
    componentid = ParsingHelper.parseIntMethod(json["componentid"]);
    parentprivilegeid = ParsingHelper.parseIntMethod(json["parentprivilegeid"]);
    objecttypeid = ParsingHelper.parseIntMethod(json["objecttypeid"]);
    roleid = ParsingHelper.parseIntMethod(json["roleid"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "userid": userid,
      "privilegeid": privilegeid,
      "componentid": componentid,
      "parentprivilegeid": parentprivilegeid,
      "objecttypeid": objecttypeid,
      "roleid": roleid,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}