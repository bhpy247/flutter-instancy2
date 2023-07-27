import 'package:flutter_instancy_2/configs/app_constants.dart';

import '../../../utils/my_utils.dart';

class InsertCourseDataByTokenRequestModel {
  InsertCourseDataCourseDetailsModel CourseDetails;
  InsertCourseAPIDataModel APIData;

  InsertCourseDataByTokenRequestModel({
    required this.CourseDetails,
    required this.APIData,
  });

  Map<String, String> toJson() {
    return {
      "CourseDetails": CourseDetails.toString(),
      "APIData": APIData.toString(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}

class InsertCourseDataCourseDetailsModel {
  String Course_URL;
  String courseName;
  String ContentID;
  String learnerSessionID;
  String UserSessionID;
  String usermailid;
  String locale;
  String SaltKey;
  int Obj_Type_ID;
  int learnerSCOID;
  int UserID;
  int siteid;
  int LoginUserId;

  InsertCourseDataCourseDetailsModel({
    this.Course_URL = "",
    this.courseName = "",
    this.ContentID = "",
    this.learnerSessionID = "",
    this.UserSessionID = "",
    this.usermailid = "",
    this.locale = "",
    this.SaltKey = AppConstants.saltKey,
    this.Obj_Type_ID = 0,
    this.learnerSCOID = 0,
    this.UserID = 0,
    this.siteid = AppConstants.defaultSiteId,
    this.LoginUserId = 0,
  });

  Map<String, String> toJson() {
    return {
      'Course_URL': Course_URL,
      'courseName': courseName,
      'ContentID': ContentID,
      'learnerSessionID': learnerSessionID.replaceAll('"', ""),
      'UserSessionID': UserSessionID,
      'usermailid': usermailid,
      'locale': locale,
      'SaltKey': SaltKey,
      'Obj_Type_ID': Obj_Type_ID.toString(),
      'learnerSCOID': learnerSCOID.toString(),
      'UserID': UserID.toString(),
      'siteid': siteid.toString(),
      'LoginUserId' : LoginUserId.toString(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}

class InsertCourseAPIDataModel {
  String WebAPIUrl;
  String LMSUrl;
  String LearnerURL;
  String UniqueID;
  String currentOrigin;

  InsertCourseAPIDataModel({
    this.WebAPIUrl = "",
    this.LMSUrl = "",
    this.LearnerURL = "",
    this.UniqueID = "",
    this.currentOrigin = "frommobile",
  });

  Map<String, String> toJson() {
    return {
      'WebAPIUrl': WebAPIUrl,
      'LMSUrl': LMSUrl,
      'LearnerURL': LearnerURL,
      'UniqueID': UniqueID,
      'currentOrigin': currentOrigin,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}