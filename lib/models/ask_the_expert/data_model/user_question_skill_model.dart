import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class UserQuestionSkillModel {
  String PreferrenceTitle = "";
  String ShortSkillName = "";
  int OrgUnitID = 0;
  int PreferrenceID = 0;

  UserQuestionSkillModel({
    this.PreferrenceTitle = "",
    this.ShortSkillName = "",
    this.OrgUnitID = 0,
    this.PreferrenceID = 0,
  });

  UserQuestionSkillModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    PreferrenceTitle = map["PreferrenceTitle"] != null ? ParsingHelper.parseStringMethod(map["PreferrenceTitle"]) : PreferrenceTitle;
    ShortSkillName = map["ShortSkillName"] != null ? ParsingHelper.parseStringMethod(map["ShortSkillName"]) : ShortSkillName;
    OrgUnitID = map["OrgUnitID"] != null ? ParsingHelper.parseIntMethod(map["OrgUnitID"]) : OrgUnitID;
    PreferrenceID = map["PreferrenceID"] != null ? ParsingHelper.parseIntMethod(map["PreferrenceID"]) : PreferrenceID;
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return <String, dynamic>{
      "PreferrenceTitle": PreferrenceTitle,
      "ShortSkillName": ShortSkillName,
      "OrgUnitID": OrgUnitID,
      "PreferrenceID": PreferrenceID,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}
