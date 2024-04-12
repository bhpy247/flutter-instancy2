import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class ExternalIntegrationDataModel {
  String name = "";
  String iconurl = "";
  String apikeyorclientid = "";
  String apisecretorclientidsecret = "";
  String oauthorrequesttokenurl = "";
  String authorizeurl = "";
  String accesstokenurl = "";
  String userinfourl = "";
  String scope = "";
  String hiconurl = "";
  int siteid = 0;
  int privilegeid = 0;
  int sntype = 0;
  bool active = false;

  ExternalIntegrationDataModel({
    this.name = "",
    this.iconurl = "",
    this.apikeyorclientid = "",
    this.apisecretorclientidsecret = "",
    this.oauthorrequesttokenurl = "",
    this.authorizeurl = "",
    this.accesstokenurl = "",
    this.userinfourl = "",
    this.scope = "",
    this.hiconurl = "",
    this.siteid = 0,
    this.privilegeid = 0,
    this.sntype = 0,
    this.active = false,
  });

  ExternalIntegrationDataModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    name = ParsingHelper.parseStringMethod(map["name"]);
    iconurl = ParsingHelper.parseStringMethod(map["iconurl"]);
    apikeyorclientid = ParsingHelper.parseStringMethod(map["apikeyorclientid"]);
    apisecretorclientidsecret = ParsingHelper.parseStringMethod(map["apisecretorclientidsecret"]);
    oauthorrequesttokenurl = ParsingHelper.parseStringMethod(map["oauthorrequesttokenurl"]);
    authorizeurl = ParsingHelper.parseStringMethod(map["authorizeurl"]);
    accesstokenurl = ParsingHelper.parseStringMethod(map["accesstokenurl"]);
    userinfourl = ParsingHelper.parseStringMethod(map["userinfourl"]);
    scope = ParsingHelper.parseStringMethod(map["scope"]);
    hiconurl = ParsingHelper.parseStringMethod(map["hiconurl"]);
    siteid = ParsingHelper.parseIntMethod(map["siteid"]);
    privilegeid = ParsingHelper.parseIntMethod(map["privilegeid"]);
    sntype = ParsingHelper.parseIntMethod(map["sntype"]);
    active = ParsingHelper.parseBoolMethod(map["active"], defaultValue: false);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "name": name,
      "iconurl": iconurl,
      "apikeyorclientid": apikeyorclientid,
      "apisecretorclientidsecret": apisecretorclientidsecret,
      "oauthorrequesttokenurl": oauthorrequesttokenurl,
      "authorizeurl": authorizeurl,
      "accesstokenurl": accesstokenurl,
      "userinfourl": userinfourl,
      "scope": scope,
      "hiconurl": hiconurl,
      "siteid": siteid,
      "privilegeid": privilegeid,
      "sntype": sntype,
      "active": active,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
