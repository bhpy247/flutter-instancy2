import '../../../utils/my_utils.dart';

class ContentProgressSummaryDataModel {
  String assignedDate = "";
  String dateStarted = "";
  String dateCompleted = "";
  String totalTimeSpent = "";
  String numberOfAttemptsInThisPeriod = "";
  String lastAccessedInThisPeriod = "";
  String status = "";
  String result = "";
  String percentageCompleted = "";
  String score = "";
  String targetDate = "";
  String contentName = "";
  String contentType = "";
  String jwVideo = "";
  int numberOfTimesAccessedInThisPeriod = 0;
  int mediaTypeId = 0;

  ContentProgressSummaryDataModel({
    this.assignedDate = "",
    this.dateStarted = "",
    this.dateCompleted = "",
    this.totalTimeSpent = "",
    this.numberOfAttemptsInThisPeriod = "",
    this.lastAccessedInThisPeriod = "",
    this.status = "",
    this.result = "",
    this.percentageCompleted = "",
    this.score = "",
    this.targetDate = "",
    this.contentName = "",
    this.contentType = "",
    this.jwVideo = "",
    this.numberOfTimesAccessedInThisPeriod = 0,
    this.mediaTypeId = 0,
  });

  ContentProgressSummaryDataModel.fromJson(Map<String, dynamic> json) {
    assignedDate = json["AssignedDate"] ?? "";
    dateStarted = json["DateStarted"] ?? "";
    dateCompleted = json["DateCompleted"] ?? "";
    totalTimeSpent = json["TotalTimeSpent"] ?? "";
    numberOfAttemptsInThisPeriod =json["Numberofattemptsinthisperiod"] ?? "";
    lastAccessedInThisPeriod = json["LastAccessedInThisPeriod"] ?? "";
    status = json["Status"] ?? "";
    result = json["Result"] ?? "";
    percentageCompleted = json["PercentageCompleted"] ?? "";
    score = json["Score"] ?? "";
    targetDate = json["TargetDate"] ?? "";
    contentName = json["ContentName"] ?? "";
    contentType = json["ContentType"] ?? "";
    jwVideo = json["JwVideo"] ?? "";
    numberOfTimesAccessedInThisPeriod =json["NumberofTimesAccessedinthisperiod"] ?? 0;
    mediaTypeId = json["MediaTypeID"] ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      "AssignedDate": assignedDate,
      "DateStarted": dateStarted,
      "DateCompleted": dateCompleted,
      "TotalTimeSpent": totalTimeSpent,
      "Numberofattemptsinthisperiod": numberOfAttemptsInThisPeriod,
      "LastAccessedInThisPeriod": lastAccessedInThisPeriod,
      "Status": status,
      "Result": result,
      "PercentageCompleted": percentageCompleted,
      "Score": score,
      "TargetDate": targetDate,
      "ContentName": contentName,
      "ContentType": contentType,
      "JwVideo": jwVideo,
      "NumberofTimesAccessedinthisperiod": numberOfTimesAccessedInThisPeriod,
      "MediaTypeID": mediaTypeId,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
