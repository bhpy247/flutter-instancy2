import '../../../utils/parsing_helper.dart';

class ParentDataDto {
  String orgname = "";
  String contenttitle = "";
  String contenttype = "";
  String AssignedOn = "";
  String TargetDate = "";
  String DueDatesAcheived = "";
  String Status = "";
  String CertificateAction = "";
  String datestarted = "";
  String ParentID = "";
  String datecompleted = "";
  String seqid = "";
  String ObjectID = "";
  String DetailsLink = "";
  String GradedColor = "";
  String overallscore = "";
  String skillname = "";
  String categoryname = "";
  String jobrolename = "";
  String Credit = "";
  String Maxvalue = "";
  String certificateid = "";
  String contentcount = "";
  String content = "";
  String PAOrDAReportLink = "";
  String CertificateTitle = "";
  int MediaTypeID = 0;
  int skillID = 0;
  int SCOID = 0;
  int DueDatesAcheivedcolour = 0;
  int userid = 0;
  int ObjectTypeID = 0;
  int categoryID = 0;
  int jobrolID = 0;
  List<ParentDataDto> childData = [];
  bool isChildrenWidgetVisible = false;

  ParentDataDto(
      {this.orgname = "",
      this.contenttitle = "",
      this.contenttype = "",
      this.AssignedOn = "",
      this.TargetDate = "",
      this.DueDatesAcheived = "",
      this.Status = "",
      this.CertificateAction = "",
      this.datestarted = "",
      this.ParentID = "",
      this.datecompleted = "",
      this.seqid = "",
      this.ObjectID = "",
      this.DetailsLink = "",
      this.GradedColor = "",
      this.overallscore = "",
      this.skillname = "",
      this.categoryname = "",
      this.jobrolename = "",
      this.Credit = "",
      this.Maxvalue = "",
      this.certificateid = "",
      this.contentcount = "",
      this.content = "",
      this.PAOrDAReportLink = "",
      this.CertificateTitle = "",
      this.MediaTypeID = 0,
      this.skillID = 0,
      this.SCOID = 0,
      this.DueDatesAcheivedcolour = 0,
      this.userid = 0,
      this.ObjectTypeID = 0,
      this.categoryID = 0,
      this.jobrolID = 0,
      this.childData = const [],
      this.isChildrenWidgetVisible = false});

  ParentDataDto.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> json) {
    orgname = ParsingHelper.parseStringMethod(json["orgname"]);
    contenttitle = ParsingHelper.parseStringMethod(json["contenttitle"]);
    contenttype = ParsingHelper.parseStringMethod(json["contenttype"]);
    AssignedOn = ParsingHelper.parseStringMethod(json["AssignedOn"]);
    TargetDate = ParsingHelper.parseStringMethod(json["TargetDate"]);
    DueDatesAcheived = ParsingHelper.parseStringMethod(json["DueDatesAcheived"]);
    Status = ParsingHelper.parseStringMethod(json["Status"]);
    CertificateAction = ParsingHelper.parseStringMethod(json["CertificateAction"]);
    datestarted = ParsingHelper.parseStringMethod(json["datestarted"]);
    ParentID = ParsingHelper.parseStringMethod(json["ParentID"]);
    datecompleted = ParsingHelper.parseStringMethod(json["datecompleted"]);
    seqid = ParsingHelper.parseStringMethod(json["seqid"]);
    ObjectID = ParsingHelper.parseStringMethod(json["ObjectID"]);
    DetailsLink = ParsingHelper.parseStringMethod(json["DetailsLink"]);
    GradedColor = ParsingHelper.parseStringMethod(json["GradedColor"]);
    overallscore = ParsingHelper.parseStringMethod(json["overallscore"]);
    skillname = ParsingHelper.parseStringMethod(json["skillname"]);
    categoryname = ParsingHelper.parseStringMethod(json["categoryname"]);
    jobrolename = ParsingHelper.parseStringMethod(json["jobrolename"]);
    Credit = ParsingHelper.parseStringMethod(json["Credit"]);
    Maxvalue = ParsingHelper.parseStringMethod(json["Maxvalue"]);
    certificateid = ParsingHelper.parseStringMethod(json["certificateid"]);
    contentcount = ParsingHelper.parseStringMethod(json["contentcount"]);
    content = ParsingHelper.parseStringMethod(json["content"]);
    PAOrDAReportLink = ParsingHelper.parseStringMethod(json["PAOrDAReportLink"]);
    CertificateTitle = ParsingHelper.parseStringMethod(json["CertificateTitle"]);
    MediaTypeID = ParsingHelper.parseIntMethod(json["MediaTypeID"]);
    skillID = ParsingHelper.parseIntMethod(json["skillID"]);
    SCOID = ParsingHelper.parseIntMethod(json["SCOID"]);
    DueDatesAcheivedcolour = ParsingHelper.parseIntMethod(json["DueDatesAcheivedcolour"]);
    userid = ParsingHelper.parseIntMethod(json["userid"]);
    ObjectTypeID = ParsingHelper.parseIntMethod(json["ObjectTypeID"]);
    categoryID = ParsingHelper.parseIntMethod(json["categoryID"]);
    jobrolID = ParsingHelper.parseIntMethod(json["jobrolID"]);

    childData.clear();
    List<Map<String, dynamic>> childDataMapList = ParsingHelper.parseMapsListMethod<String, dynamic>(json["ChildData"]);
    childData.addAll(childDataMapList.map((e) => ParentDataDto.fromJson(e)).toList());
  }

  Map<String, dynamic> toJson() {
    return {
      "orgname": orgname,
      "contenttitle": contenttitle,
      "contenttype": contenttype,
      "AssignedOn": AssignedOn,
      "TargetDate": TargetDate,
      "DueDatesAcheived": DueDatesAcheived,
      "Status": Status,
      "CertificateAction": CertificateAction,
      "datestarted": datestarted,
      "ParentID": ParentID,
      "datecompleted": datecompleted,
      "seqid": seqid,
      "ObjectID": ObjectID,
      "DetailsLink": DetailsLink,
      "GradedColor": GradedColor,
      "overallscore": overallscore,
      "skillname": skillname,
      "categoryname": categoryname,
      "jobrolename": jobrolename,
      "Credit": Credit,
      "Maxvalue": Maxvalue,
      "certificateid": certificateid,
      "contentcount": contentcount,
      "content": content,
      "PAOrDAReportLink": PAOrDAReportLink,
      "CertificateTitle": CertificateTitle,
      "MediaTypeID": MediaTypeID,
      "skillID": skillID,
      "SCOID": SCOID,
      "DueDatesAcheivedcolour": DueDatesAcheivedcolour,
      "userid": userid,
      "ObjectTypeID": ObjectTypeID,
      "categoryID": categoryID,
      "jobrolID": jobrolID,
      "ChildData": childData.map((e) => e.toJson()).toList(),
    };
  }
}
