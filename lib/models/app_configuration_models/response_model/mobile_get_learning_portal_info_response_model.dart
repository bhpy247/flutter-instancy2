// To parse this JSON data, do
//
//     final mobileGetLearningPortalInfoResponse = mobileGetLearningPortalInfoResponseFromJson(jsonString);
import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/external_integration_data_model.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class MobileGetLearningPortalInfoResponseModel {
  MobileGetLearningPortalInfoResponseModel({
    this.table = const [],
    this.table1 = const [],
    this.table2 = const [],
    this.table3 = const [],
    this.table4 = const [],
    this.table5 = const [],
    this.table6 = const [],
    this.table7 = const [],
    this.table8 = const [],
  });

  List<Table> table = <Table>[];
  List<Table1> table1 = <Table1>[];
  List<Table2> table2 = <Table2>[];
  List<Table3> table3 = <Table3>[];
  List<Table4> table4 = <Table4>[];
  List<Table5> table5 = <Table5>[];
  List<Table6> table6 = <Table6>[];
  List<Table7> table7 = <Table7>[];
  List<ExternalIntegrationDataModel> table8 = <ExternalIntegrationDataModel>[];

  MobileGetLearningPortalInfoResponseModel.fromJson(Map<String, dynamic> json) {
    table = ParsingHelper.parseListMethod(json["table"]).map((x) => Table.fromJson(ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(x))).toList();
    table1 = ParsingHelper.parseListMethod(json["table1"]).map((x) => Table1.fromJson(ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(x))).toList();
    table2 = ParsingHelper.parseListMethod(json["table2"]).map((x) => Table2.fromJson(ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(x))).toList();
    table3 = ParsingHelper.parseListMethod(json["table3"]).map((x) => Table3.fromJson(ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(x))).toList();
    table4 = ParsingHelper.parseListMethod(json["table4"]).map((x) => Table4.fromJson(ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(x))).toList();
    table5 = ParsingHelper.parseListMethod(json["table5"]).map((x) => Table5.fromJson(ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(x))).toList();
    table6 = ParsingHelper.parseListMethod(json["table6"]).map((x) => Table6.fromJson(ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(x))).toList();
    table7 = ParsingHelper.parseListMethod(json["table7"]).map((x) => Table7.fromJson(ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(x))).toList();
    table8 = ParsingHelper.parseListMethod(json["table8"]).map((x) => ExternalIntegrationDataModel.fromMap(ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(x))).toList();
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "table": table.map((x) => x.toJson()).toList(),
      "table1": table1.map((x) => x.toJson()).toList(),
      "table2": table2.map((x) => x.toJson()).toList(),
      "table3": table3.map((x) => x.toJson()).toList(),
      "table4": table4.map((x) => x.toJson()).toList(),
      "table5": table5.map((x) => x.toJson()).toList(),
      "table6": table6.map((x) => x.toJson()).toList(),
      "table7": table7.map((x) => x.toJson()).toList(),
      "table8": table8.map((x) => x.toMap()).toList(),
    };
  }

  List<String> getLoginScreenImages() {
    return table6.map((e) => e.splashimagepath).toList()..removeWhere((element) => element.isEmpty);
  }

  String getLoginScreenBackgroundImage() {
    return table7.firstOrNull?.onboardingurl ?? "";
  }
}

class Table {
  Table({
    this.siteid = 0,
    this.name = "",
    this.siteurl = "",
  });

  int siteid = 0;
  String name = "", siteurl = "";

  Table.fromJson(Map<String, dynamic> json) {
    siteid = ParsingHelper.parseIntMethod(json["siteid"]);
    name = ParsingHelper.parseStringMethod(json["name"]);
    siteurl = ParsingHelper.parseStringMethod(json["siteurl"]);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "siteid": siteid,
      "name": name,
      "siteurl": siteurl,
    };
  }
}

class Table1 {
  Table1({
    this.csseditingplaceholdertypeid = 0,
    this.siteid = 0,
    this.csseditingpalceholderdisplayname = "",
    this.csseditingpalceholdername = "",
    this.textcolor = "",
    this.bgcolor = "",
    this.localeid = LocaleType.english,
    this.themeid = 0,
    this.categoryid = 0,
  });

  int csseditingplaceholdertypeid = 0, siteid = 0, themeid = 0, categoryid = 0;
  String csseditingpalceholderdisplayname = "", csseditingpalceholdername = "", textcolor = "", bgcolor = "", localeid = LocaleType.english;

  Table1.fromJson(Map<String, dynamic> json) {
    csseditingplaceholdertypeid = ParsingHelper.parseIntMethod(json["csseditingplaceholdertypeid"]);
    siteid = ParsingHelper.parseIntMethod(json["siteid"]);
    themeid = ParsingHelper.parseIntMethod(json["themeid"]);
    categoryid = ParsingHelper.parseIntMethod(json["categoryid"]);
    csseditingpalceholderdisplayname = ParsingHelper.parseStringMethod(json["csseditingpalceholderdisplayname"]);
    csseditingpalceholdername = ParsingHelper.parseStringMethod(json["csseditingpalceholdername"]);
    textcolor = ParsingHelper.parseStringMethod(json["textcolor"]);
    bgcolor = ParsingHelper.parseStringMethod(json["bgcolor"]);
    localeid = ParsingHelper.parseStringMethod(json["localeid"]);

    if(localeid.isEmpty) {
      localeid = LocaleType.english;
    }
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "csseditingplaceholdertypeid": csseditingplaceholdertypeid,
      "siteid": siteid,
      "csseditingpalceholderdisplayname": csseditingpalceholderdisplayname,
      "csseditingpalceholdername": csseditingpalceholdername,
      "textcolor": textcolor,
      "bgcolor": bgcolor,
      "localeid": localeid,
      "themeid": themeid,
      "categoryid": categoryid,
    };
  }
}

class Table2 {
  String name = "", keyvalue = "";

  Table2({
    this.name = "",
    this.keyvalue = "",
  });

  Table2.fromJson(Map<String, dynamic> json) {
    name = ParsingHelper.parseStringMethod(json["name"]);
    keyvalue = ParsingHelper.parseStringMethod(json["keyvalue"]);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "name": name,
      "keyvalue": keyvalue,
    };
  }
}

class Table3 {
  int notificationid = 0, orgunitid = 0;
  String title = "";
  bool pushnotifications = false;

  Table3({
    this.notificationid = 0,
    this.title = "",
    this.pushnotifications = false,
    this.orgunitid = 0,
  });

  Table3.fromJson(Map<String, dynamic> json) {
    notificationid = ParsingHelper.parseIntMethod(json["notificationid"]);
    orgunitid = ParsingHelper.parseIntMethod(json["orgunitid"]);
    title = ParsingHelper.parseStringMethod(json["title"]);
    pushnotifications = ParsingHelper.parseBoolMethod(json["pushnotifications"]);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "notificationid": notificationid,
      "title": title,
      "pushnotifications": pushnotifications,
      "orgunitid": orgunitid,
    };
  }
}

class Table4 {
  int privilegeid = 0, objecttypeid = 0, actionid = 0, componentid = 0, parentprivilegeid = 0;
  String description = "";
  bool publicprivilege = false, ismobileprivilege = false;

  Table4({
    this.privilegeid = 0,
    this.objecttypeid = 0,
    this.actionid = 0,
    this.componentid = 0,
    this.parentprivilegeid = 0,
    this.description = "",
    this.publicprivilege = false,
    this.ismobileprivilege = false,
  });

  Table4.fromJson(Map<String, dynamic> json) {
    privilegeid = ParsingHelper.parseIntMethod(json["privilegeid"]);
    objecttypeid = ParsingHelper.parseIntMethod(json["objecttypeid"]);
    actionid = ParsingHelper.parseIntMethod(json["actionid"]);
    componentid = ParsingHelper.parseIntMethod(json["componentid"]);
    parentprivilegeid = ParsingHelper.parseIntMethod(json["parentprivilegeid"]);
    description = ParsingHelper.parseStringMethod(json["description"]);
    publicprivilege = ParsingHelper.parseBoolMethod(json["publicprivilege"]);
    ismobileprivilege = ParsingHelper.parseBoolMethod(json["ismobileprivilege"]);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "privilegeid": privilegeid,
      "objecttypeid": objecttypeid,
      "actionid": actionid,
      "description": description,
      "componentid": componentid,
      "parentprivilegeid": parentprivilegeid,
      "publicprivilege": publicprivilege,
      "ismobileprivilege": ismobileprivilege,
    };
  }
}

class Table5 {
  String languagename = "", locale = "", description = "", countryflag = "", jsonfile = "";
  bool status = false;
  int id = 0;

  Table5({
    this.languagename = "",
    this.locale = "",
    this.description = "",
    this.countryflag = "",
    this.jsonfile = "",
    this.status = false,
    this.id = 0,
  });

  Table5.fromJson(Map<String, dynamic> json) {
    languagename = ParsingHelper.parseStringMethod(json["languagename"]);
    locale = ParsingHelper.parseStringMethod(json["locale"]);
    description = ParsingHelper.parseStringMethod(json["description"]);
    countryflag = ParsingHelper.parseStringMethod(json["countryflag"]);
    jsonfile = ParsingHelper.parseStringMethod(json["jsonfile"]);
    status = ParsingHelper.parseBoolMethod(json["status"]);
    id = ParsingHelper.parseIntMethod(json["id"]);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "languagename": languagename,
      "locale": locale,
      "description": description,
      "status": status,
      "id": id,
      "countryflag": countryflag,
      "jsonfile": jsonfile,
    };
  }
}

class Table6 {
  String splashimagepath = "";

  Table6({
    this.splashimagepath = "",
  });

  Table6.fromJson(Map<String, dynamic> json) {
    splashimagepath = ParsingHelper.parseStringMethod(json["splashimagepath"]);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "splashimagepath": splashimagepath,
    };
  }
}

class Table7 {
  String onboardingurl = "";

  Table7({
    this.onboardingurl = "",
  });

  Table7.fromJson(Map<String, dynamic> json) {
    onboardingurl = ParsingHelper.parseStringMethod(json["onboardingurl"]);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "onboardingurl": onboardingurl,
    };
  }
}
