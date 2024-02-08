import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class StudentResponseModel {
  String attemptdate = "";
  String studentresponses = "";
  String result = "";
  String attachfilename = "";
  String attachfileid = "";
  String attachedfilepath = "";
  String optionalNotes = "";
  String capturedVidFileName = "";
  String capturedVidId = "";
  String capturedVidFilepath = "";
  String capturedImgFileName = "";
  String capturedImgId = "";
  String capturedImgFilepath = "";
  int siteid = 0;
  int scoid = 0;
  int userid = 0;
  int questionid = 0;
  int assessmentattempt = 0;
  int questionattempt = 0;
  int rindex = 0;

  StudentResponseModel({
    this.attemptdate = "",
    this.studentresponses = "",
    this.result = "",
    this.attachfilename = "",
    this.attachfileid = "",
    this.attachedfilepath = "",
    this.optionalNotes = "",
    this.capturedVidFileName = "",
    this.capturedVidId = "",
    this.capturedVidFilepath = "",
    this.capturedImgFileName = "",
    this.capturedImgId = "",
    this.capturedImgFilepath = "",
    this.siteid = 0,
    this.scoid = 0,
    this.userid = 0,
    this.questionid = 0,
    this.assessmentattempt = 0,
    this.questionattempt = 0,
    this.rindex = 0,
  });

  StudentResponseModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    attemptdate = ParsingHelper.parseStringMethod(map["attemptdate"]);
    studentresponses = ParsingHelper.parseStringMethod(map["studentresponses"]);
    result = ParsingHelper.parseStringMethod(map["result"]);
    attachfilename = ParsingHelper.parseStringMethod(map["attachfilename"]);
    attachfileid = ParsingHelper.parseStringMethod(map["attachfileid"]);
    attachedfilepath = ParsingHelper.parseStringMethod(map["attachedfilepath"]);
    optionalNotes = ParsingHelper.parseStringMethod(map["optionalNotes"]);
    capturedVidFileName = ParsingHelper.parseStringMethod(map["capturedVidFileName"]);
    capturedVidId = ParsingHelper.parseStringMethod(map["capturedVidId"]);
    capturedVidFilepath = ParsingHelper.parseStringMethod(map["capturedVidFilepath"]);
    capturedImgFileName = ParsingHelper.parseStringMethod(map["capturedImgFileName"]);
    capturedImgId = ParsingHelper.parseStringMethod(map["capturedImgId"]);
    capturedImgFilepath = ParsingHelper.parseStringMethod(map["capturedImgFilepath"]);
    siteid = ParsingHelper.parseIntMethod(map["siteid"]);
    scoid = ParsingHelper.parseIntMethod(map["scoid"]);
    userid = ParsingHelper.parseIntMethod(map["userid"]);
    questionid = ParsingHelper.parseIntMethod(map["questionid"]);
    assessmentattempt = ParsingHelper.parseIntMethod(map["assessmentattempt"]);
    questionattempt = ParsingHelper.parseIntMethod(map["questionattempt"]);
    rindex = ParsingHelper.parseIntMethod(map["rindex"]);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "attemptdate": attemptdate,
      "studentresponses": studentresponses,
      "result": result,
      "attachfilename": attachfilename,
      "attachfileid": attachfileid,
      "attachedfilepath": attachedfilepath,
      "optionalNotes": optionalNotes,
      "capturedVidFileName": capturedVidFileName,
      "capturedVidId": capturedVidId,
      "capturedVidFilepath": capturedVidFilepath,
      "capturedImgFileName": capturedImgFileName,
      "capturedImgId": capturedImgId,
      "capturedImgFilepath": capturedImgFilepath,
      "siteid": siteid,
      "scoid": scoid,
      "userid": userid,
      "questionid": questionid,
      "assessmentattempt": assessmentattempt,
      "questionattempt": questionattempt,
      "rindex": rindex,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
