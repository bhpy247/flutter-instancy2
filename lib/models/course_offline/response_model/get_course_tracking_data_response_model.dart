import 'package:flutter_instancy_2/models/course_offline/data_model/cmi_model.dart';
import 'package:flutter_instancy_2/models/course_offline/data_model/learner_session_model.dart';
import 'package:flutter_instancy_2/models/course_offline/data_model/student_response_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class GetCourseTrackingDataResponseModel {
  List<CMIModel> cmi = <CMIModel>[];
  List<LearnerSessionModel> learnersession = <LearnerSessionModel>[];
  List<StudentResponseModel> studentresponse = <StudentResponseModel>[];

  GetCourseTrackingDataResponseModel({
    List<CMIModel>? cmi,
    List<LearnerSessionModel>? learnersession,
    List<StudentResponseModel>? studentresponse,
  }) {
    this.cmi = cmi ?? <CMIModel>[];
    this.learnersession = learnersession ?? <LearnerSessionModel>[];
    this.studentresponse = studentresponse ?? <StudentResponseModel>[];
  }

  GetCourseTrackingDataResponseModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    cmi.clear();
    List<Map<String, dynamic>> cmiMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(map["cmi"]);
    for (Map<String, dynamic> cmiMap in cmiMapsList) {
      if (cmiMap.isNotEmpty) {
        cmi.add(CMIModel.fromMap(cmiMap));
      }
    }

    learnersession.clear();
    List<Map<String, dynamic>> learnersessionMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(map["learnersession"]);
    for (Map<String, dynamic> learnersessionMap in learnersessionMapsList) {
      if (learnersessionMap.isNotEmpty) {
        learnersession.add(LearnerSessionModel.fromMap(learnersessionMap));
      }
    }

    studentresponse.clear();
    List<Map<String, dynamic>> studentresponseMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(map["studentresponse"]);
    for (Map<String, dynamic> studentresponseMap in studentresponseMapsList) {
      if (studentresponseMap.isNotEmpty) {
        studentresponse.add(StudentResponseModel.fromMap(studentresponseMap));
      }
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "cmi": cmi.map((e) => e.toMap()).toList(),
      "learnersession": learnersession.map((e) => e.toMap()).toList(),
      "studentresponse": studentresponse.map((e) => e.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
