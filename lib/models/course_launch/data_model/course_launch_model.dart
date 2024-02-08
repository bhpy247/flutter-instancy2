import 'package:flutter_instancy_2/configs/app_constants.dart';
import 'package:flutter_instancy_2/models/course/data_model/CourseDTOModel.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/related_track_data_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/track_course_dto_model.dart';

class CourseLaunchModel {
  int ContentTypeId;
  int MediaTypeId;
  int ScoID;
  int SiteUserID;
  int SiteId;
  int ParentContentTypeId;
  int ParentContentScoId;
  String ContentID;
  String ParentEventTrackContentID;
  String locale;
  String ContentName;
  String FolderPath;
  String startPage;
  String jwstartpage;
  String JWVideoKey;
  String ActivityId;
  String ActualStatus;
  String arVrContentLaunchTypes;
  bool isLaunchEventTrackScreenFromOffline;
  CourseDTOModel? courseDTOModel;
  TrackCourseDTOModel? trackCourseDTOModel;
  RelatedTrackDataDTOModel? relatedTrackDataDTOModel;

  CourseLaunchModel({
    required this.ContentTypeId,
    required this.MediaTypeId,
    required this.ScoID,
    required this.SiteUserID,
    required this.SiteId,
    this.ParentContentTypeId = 0,
    this.ParentContentScoId = 0,
    required this.ContentID,
    this.ParentEventTrackContentID = "",
    required this.locale,
    this.ContentName = "",
    this.FolderPath = "",
    this.startPage = "",
    this.jwstartpage = "",
    this.JWVideoKey = "",
    this.ActivityId = "",
    this.ActualStatus = "",
    this.arVrContentLaunchTypes = ARVRContentLaunchTypes.launchInAR,
    this.isLaunchEventTrackScreenFromOffline = false,
    this.courseDTOModel,
    this.trackCourseDTOModel,
    this.relatedTrackDataDTOModel,
  });
}