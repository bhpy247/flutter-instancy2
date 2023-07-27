import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class PrerequisiteDetailResponseModel {
  PrerequisiteDetailResponseModel();

  PreRequisiteData prerequisteData = PreRequisiteData.fromJson({});
  bool isShowPopUp = false;

  PrerequisiteDetailResponseModel.fromJson(Map<String, dynamic> json) {
    prerequisteData = PreRequisiteData.fromJson(json['PrerequisteData'] ?? {});
    isShowPopUp = json['IsShowPopUp'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PrerequisteData'] = prerequisteData.toJson();
    data['IsShowPopUp'] = isShowPopUp;
    return data;
  }
}

class PreRequisiteData {
  List<PreRequisiteContentModel> table = [];
  List<PreRequisitePathModel> table1 = [];

  PreRequisiteData.fromJson(Map<String, dynamic> json) {
    if (json['Table'] != null) {
      json['Table'].forEach((v) {
        table.add(PreRequisiteContentModel.fromJson(v));
      });
    }
    if (json['Table1'] != null) {
      json['Table1'].forEach((v) {
        table1.add(PreRequisitePathModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Table'] = table.map((v) => v.toJson()).toList();
    data['Table1'] = table1.map((v) => v.toJson()).toList();
    return data;
  }
}

class PreRequisiteContentModel {
  dynamic excludeContent;
  String contentID = "";
  String name = "";
  int prerequisites = 0;
  String prerequisiteContentID = "";
  int preRequisiteSequnceID = 0;
  int preRequisiteSequncePathID = 0;
  int nodeIndex = 0;
  String pathName = "";

  PreRequisiteContentModel(
      {this.contentID = "",
      this.name = "",
      this.prerequisites = 0,
      this.prerequisiteContentID = "",
      this.preRequisiteSequnceID = 0,
      this.preRequisiteSequncePathID = 0,
      this.nodeIndex = 0,
      this.pathName = ""});

  PreRequisiteContentModel.fromJson(Map<String, dynamic> json) {
    excludeContent = ParsingHelper.parseStringMethod(json['ExcludeContent']);
    contentID = ParsingHelper.parseStringMethod(json['ContentID']);
    name = ParsingHelper.parseStringMethod(json['Name']);
    prerequisites = ParsingHelper.parseIntMethod(json['Prerequisites']);
    prerequisiteContentID = ParsingHelper.parseStringMethod(json['PrerequisiteContentID']);
    preRequisiteSequnceID = ParsingHelper.parseIntMethod(json['PreRequisiteSequnceID']);
    preRequisiteSequncePathID = ParsingHelper.parseIntMethod(json['PreRequisiteSequncePathID']);
    nodeIndex = ParsingHelper.parseIntMethod(json['NodeIndex']);
    pathName = ParsingHelper.parseStringMethod(json['PathName']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ExcludeContent'] = excludeContent;
    data['ContentID'] = contentID;
    data['Name'] = name;
    data['Prerequisites'] = prerequisites;
    data['PrerequisiteContentID'] = prerequisiteContentID;
    data['PreRequisiteSequnceID'] = preRequisiteSequnceID;
    data['PreRequisiteSequncePathID'] = preRequisiteSequncePathID;
    data['NodeIndex'] = nodeIndex;
    data['PathName'] = pathName;
    return data;
  }
}

class PreRequisitePathModel {
  String contentID = "";
  int preRequisiteSequnceID = 0;
  int preRequisiteSequncePathID = 0;
  String pathName = "";
  List<PreRequisiteContentModel> contents = <PreRequisiteContentModel>[];

  PreRequisitePathModel.fromJson(Map<String, dynamic> json) {
    contentID = json['ContentID'];
    preRequisiteSequnceID = json['PreRequisiteSequnceID'];
    preRequisiteSequncePathID = json['PreRequisiteSequncePathID'];
    pathName = json['PathName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ContentID'] = contentID;
    data['PreRequisiteSequnceID'] = preRequisiteSequnceID;
    data['PreRequisiteSequncePathID'] = preRequisiteSequncePathID;
    data['PathName'] = pathName;
    return data;
  }
}
