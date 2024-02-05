import 'package:flutter_chat_bot/utils/parsing_helper.dart';

class FilterUserSkillsDtoResponseModel {
  List<FilterSkills> table = [];
  List<UserFilterSkills> userFilterSkills = [];
  List<Table1> table1 = [];

  FilterUserSkillsDtoResponseModel({this.table = const [], this.table1 = const []});

  FilterUserSkillsDtoResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['Table'] != null) {
      userFilterSkills = <UserFilterSkills>[];
      json['Table'].forEach((v) {
        userFilterSkills.add(UserFilterSkills.fromJson(v));
      });
    }
    if (json['Table'] != null) {
      table = <FilterSkills>[];
      json['Table'].forEach((v) {
        table.add(FilterSkills.fromJson(v));
      });
    }
    if (json['Table1'] != null) {
      table1 = <Table1>[];
      json['Table1'].forEach((v) {
        table1.add(Table1.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Table'] = table.map((v) => v.toJson()).toList();
    data['Table'] = userFilterSkills.map((v) => v.toJson()).toList();
    data['Table1'] = table1.map((v) => v.toJson()).toList();
    return data;
  }
}

class FilterSkills {
  int skillID = 0;
  String preferrenceTitle = "";

  FilterSkills({this.skillID = 0, this.preferrenceTitle = ""});

  FilterSkills.fromJson(Map<String, dynamic> json) {
    skillID = ParsingHelper.parseIntMethod(json['SkillID']);
    preferrenceTitle = ParsingHelper.parseStringMethod(json['PreferrenceTitle']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SkillID'] = skillID;
    data['PreferrenceTitle'] = preferrenceTitle;
    return data;
  }
}

class UserFilterSkills {
  int OrgUnitID = 0;
  int PreferrenceID = 0;
  String preferrenceTitle = "";
  String ShortSkillName = "";

  UserFilterSkills({
    this.OrgUnitID = 0,
    this.PreferrenceID = 0,
    this.preferrenceTitle = "",
  });

  UserFilterSkills.fromJson(Map<String, dynamic> json) {
    OrgUnitID = ParsingHelper.parseIntMethod(json['SkillID']);
    PreferrenceID = ParsingHelper.parseIntMethod(json['PreferrenceID']);
    preferrenceTitle = ParsingHelper.parseStringMethod(json['PreferrenceTitle']);
    ShortSkillName = ParsingHelper.parseStringMethod(json['ShortSkillName']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SkillID'] = OrgUnitID;
    data['PreferrenceID'] = PreferrenceID;
    data['PreferrenceTitle'] = preferrenceTitle;
    data['ShortSkillName'] = ShortSkillName;
    return data;
  }
}

class Table1 {
  int questionID = 0;
  String skillID = "";

  Table1({this.questionID = 0, this.skillID = ""});

  Table1.fromJson(Map<String, dynamic> json) {
    questionID = ParsingHelper.parseIntMethod(json['QuestionID']);
    skillID = ParsingHelper.parseStringMethod(json['SkillID']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['QuestionID'] = questionID;
    data['SkillID'] = skillID;
    return data;
  }
}
