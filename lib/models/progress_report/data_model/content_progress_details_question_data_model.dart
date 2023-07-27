import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class ContentProgressDetailsQuestionDataModel {
  int pageID = 0;
  int scoid = 0;
  int objectTypeId = 0;
  int mediaTypeId = 0;
  int isTrackable = 0;
  int sequenceNumber = 0;
  int accessedInThisPeriod = 0;
  int attemptsInThisPeriod = 0;
  String trackId = "";
  String pageQuestionTitle = "";
  String type = "";
  String contentID = "";
  String contentItemTitle = "";
  String tableContentItemTitle = "";
  String questionNo = "";
  String folderPath = "";
  String questionTitle = "";
  String questionNumber = "";
  String status = "";
  String optionLevelNotes = "";
  String actions = "";
  String coreLessonStatus = "";
  String score = "";
  String scoreRaw = "";
  String percentCompleted = "";
  String progress = "";
  String result = "";
  bool isAdministrativelySet = false;
  DateTime? startedOn;
  DateTime? completedOn;
  DateTime? lastAccessedInThisPeriod;
  dynamic paReportLink;
  dynamic daReportLink;

  ContentProgressDetailsQuestionDataModel({
    this.pageID = 0,
    this.scoid = 0,
    this.objectTypeId = 0,
    this.mediaTypeId = 0,
    this.isTrackable = 0,
    this.sequenceNumber = 0,
    this.accessedInThisPeriod = 0,
    this.attemptsInThisPeriod = 0,
    this.trackId = "",
    this.pageQuestionTitle = "",
    this.type = "",
    this.contentID = "",
    this.contentItemTitle = "",
    this.tableContentItemTitle = "",
    this.questionNo = "",
    this.folderPath = "",
    this.questionTitle = "",
    this.questionNumber = "",
    this.status = "",
    this.optionLevelNotes = "",
    this.actions = "",
    this.coreLessonStatus = "",
    this.score = "",
    this.scoreRaw = "",
    this.percentCompleted = "",
    this.progress = "",
    this.result = "",
    this.isAdministrativelySet = false,
    this.startedOn,
    this.completedOn,
    this.lastAccessedInThisPeriod,
    dynamic paReportLink,
    dynamic daReportLink,
  });

  ContentProgressDetailsQuestionDataModel.fromJson(Map<String, dynamic> json) {
    pageID = ParsingHelper.parseIntMethod(json['PageID']);
    scoid = ParsingHelper.parseIntMethod(json["SCOID"]);
    objectTypeId = ParsingHelper.parseIntMethod(json["ObjectTypeID"]);
    mediaTypeId = ParsingHelper.parseIntMethod(json["MediaTypeID"]);
    isTrackable = ParsingHelper.parseIntMethod(json["IsTrackable"]);
    sequenceNumber =ParsingHelper.parseIntMethod(json["SequenceNumber"]);
    accessedInThisPeriod = ParsingHelper.parseIntMethod(json["# Accessed in this period"]);
    attemptsInThisPeriod = ParsingHelper.parseIntMethod(json["# Attempts In This Period"]);
    trackId = ParsingHelper.parseStringMethod(json["TrackID"]);
    pageQuestionTitle = ParsingHelper.parseStringMethod(json['Page/Question Title']);
    type = ParsingHelper.parseStringMethod(json['Type']);
    contentID = ParsingHelper.parseStringMethod(json['ContentID']);
    contentItemTitle = ParsingHelper.parseStringMethod(json['Content Item Title']);
    tableContentItemTitle = ParsingHelper.parseStringMethod(json['ContentItemTitle']);
    questionNo = ParsingHelper.parseStringMethod(json['Question No.']);
    folderPath = ParsingHelper.parseStringMethod(json['FolderPath']);
    questionTitle = ParsingHelper.parseStringMethod(json['QuestionTitle']);
    questionNumber = ParsingHelper.parseStringMethod(json['QuestionNumber']);
    status = ParsingHelper.parseStringMethod(json['Status']);
    optionLevelNotes = ParsingHelper.parseStringMethod(json['OptionLevelNotes']);
    actions = ParsingHelper.parseStringMethod(json['Actions']);
    coreLessonStatus = ParsingHelper.parseStringMethod(json["CoreLessonStatus"]);
    score = ParsingHelper.parseStringMethod(json["Score"]);
    scoreRaw = ParsingHelper.parseStringMethod(json["ScoreRaw"]);
    percentCompleted =ParsingHelper.parseStringMethod(json["PercentCompleted"]);
    progress = ParsingHelper.parseStringMethod(json["Progress"]);
    result = ParsingHelper.parseStringMethod(json["Result"]);
    isAdministrativelySet = ParsingHelper.parseBoolMethod(json["isAdministrativelySet"]);
    startedOn = ParsingHelper.parseDateTimeMethod(json["Started On"]);
    completedOn = ParsingHelper.parseDateTimeMethod(json["Completed On"]);
    lastAccessedInThisPeriod = ParsingHelper.parseDateTimeMethod(json["Last Accessed in this period"]);
    paReportLink = json["PAReportLink"];
    daReportLink = json["DAReportLink"];
  }

  Map<String, dynamic> toJson() {
    return {
      "pageID": pageID,
      "SCOID": scoid,
      "ObjectTypeID": objectTypeId,
      "mediaTypeId": mediaTypeId,
      "IsTrackable": isTrackable,
      "SequenceNumber": sequenceNumber,
      "# Accessed in this period": accessedInThisPeriod,
      "# Attempts In This Period": attemptsInThisPeriod,
      "TrackID": trackId,
      "pageQuestionTitle": pageQuestionTitle,
      "Type": type,
      "ContentID": contentID,
      "Content Item Title": contentItemTitle,
      "ContentItemTitle": tableContentItemTitle,
      "questionNo": questionNo,
      "folderPath": folderPath,
      "questionTitle": questionTitle,
      "questionNumber": questionNumber,
      "Status": status,
      "optionLevelNotes": optionLevelNotes,
      "Actions": actions,
      "CoreLessonStatus": coreLessonStatus,
      "Score": score,
      "ScoreRaw": scoreRaw,
      "PercentCompleted": percentCompleted,
      "Progress": progress,
      "Result": result,
      "isAdministrativelySet": isAdministrativelySet,
      "Started On": startedOn?.toString(),
      "Completed On": completedOn?.toString(),
      "Last Accessed in this period": lastAccessedInThisPeriod?.toString(),
      "PAReportLink": paReportLink,
      "DAReportLink": daReportLink,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}