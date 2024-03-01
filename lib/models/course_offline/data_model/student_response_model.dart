import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class StudentResponseModel {
  String attemptdate = "";
  String studentresponses = "";
  String result = "";
  String attachfilename = "";
  String attachfileid = "";
  String attachedfilepath = "";
  String optionalnotes = "";
  String capturedvidfilename = "";
  String capturedvidid = "";
  String capturedVidFilepath = "";
  String capturedimgfilename = "";
  String capturedimgid = "";
  String capturedImgFilepath = "";
  String starredquestions = "";
  int responseid = 0;
  int siteid = 0;
  int scoid = 0;
  int userid = 0;
  int questionid = 0;
  int assessmentattempt = 0;
  int questionattempt = 0;
  int index = 0;

  StudentResponseModel({
    this.attemptdate = "",
    this.studentresponses = "",
    this.result = "",
    this.attachfilename = "",
    this.attachfileid = "",
    this.attachedfilepath = "",
    this.optionalnotes = "",
    this.capturedvidfilename = "",
    this.capturedvidid = "",
    this.capturedVidFilepath = "",
    this.capturedimgfilename = "",
    this.capturedimgid = "",
    this.capturedImgFilepath = "",
    this.starredquestions = "",
    this.responseid = 0,
    this.siteid = 0,
    this.scoid = 0,
    this.userid = 0,
    this.questionid = 0,
    this.assessmentattempt = 0,
    this.questionattempt = 0,
    this.index = 0,
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
    optionalnotes = ParsingHelper.parseStringMethod(map["optionalnotes"]);
    capturedvidfilename = ParsingHelper.parseStringMethod(map["capturedvidfilename"]);
    capturedvidid = ParsingHelper.parseStringMethod(map["capturedvidid"]);
    capturedVidFilepath = ParsingHelper.parseStringMethod(map["capturedVidFilepath"]);
    capturedimgfilename = ParsingHelper.parseStringMethod(map["capturedimgfilename"]);
    capturedimgid = ParsingHelper.parseStringMethod(map["capturedimgid"]);
    capturedImgFilepath = ParsingHelper.parseStringMethod(map["capturedImgFilepath"]);
    starredquestions = ParsingHelper.parseStringMethod(map["starredquestions"]);
    responseid = ParsingHelper.parseIntMethod(map["responseid"]);
    siteid = ParsingHelper.parseIntMethod(map["siteid"]);
    scoid = ParsingHelper.parseIntMethod(map["scoid"]);
    userid = ParsingHelper.parseIntMethod(map["userid"]);
    questionid = ParsingHelper.parseIntMethod(map["questionid"]);
    assessmentattempt = ParsingHelper.parseIntMethod(map["assessmentattempt"]);
    questionattempt = ParsingHelper.parseIntMethod(map["questionattempt"]);
    index = ParsingHelper.parseIntMethod(map["index"]);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "attemptdate": attemptdate,
      "studentresponses": studentresponses,
      "result": result,
      "attachfilename": attachfilename,
      "attachfileid": attachfileid,
      "attachedfilepath": attachedfilepath,
      "optionalnotes": optionalnotes,
      "capturedvidfilename": capturedvidfilename,
      "capturedvidid": capturedvidid,
      "capturedVidFilepath": capturedVidFilepath,
      "capturedimgfilename": capturedimgfilename,
      "capturedimgid": capturedimgid,
      "capturedImgFilepath": capturedImgFilepath,
      "starredquestions": starredquestions,
      "responseid": responseid,
      "siteid": siteid,
      "scoid": scoid,
      "userid": userid,
      "questionid": questionid,
      "assessmentattempt": assessmentattempt,
      "questionattempt": questionattempt,
      "index": index,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
