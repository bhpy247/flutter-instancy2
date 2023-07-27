import 'package:flutter_instancy_2/models/classroom_events/data_model/EventRecordingDetailsModel.dart';

import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';
import '../../catalog/data_model/catalog_course_dto_model.dart';

class EventSessionCourseDTOModel extends CatalogCourseDTOModel {
  String Location = "";
  int PresenterID = 0;
  int Prerequisites = 0;
  bool IsLearnerContent = false;
  EventRecordingDetailsModel? RecordingDetails;

  EventSessionCourseDTOModel({
    this.Location = "",
    this.PresenterID = 0,
    this.Prerequisites = 0,
    this.IsLearnerContent = false,
    this.RecordingDetails,
  });

  EventSessionCourseDTOModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  @override
  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    super.updateFromMap(map);

    ContentStatus = ParsingHelper.parseStringMethod(map["Contentstatus"]);
    Location = ParsingHelper.parseStringMethod(map["Location"]);
    PresenterID = ParsingHelper.parseIntMethod(map["PresenterID"]);
    Prerequisites = ParsingHelper.parseIntMethod(map["Prerequisites"]);
    IsLearnerContent = ParsingHelper.parseBoolMethod(map['IsLearnerContent']);

    Map<String, dynamic> recordingDetailsMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(map['RecordingDetails']);
    if(recordingDetailsMap.isNotEmpty) RecordingDetails = EventRecordingDetailsModel.fromMap(recordingDetailsMap);
  }

  Map<String, dynamic> toMap() {
    return super.toMap()..addAll(<String, dynamic>{
      "Contentstatus": ContentStatus,
      "Location": Location,
      "PresenterID": PresenterID,
      "Prerequisites": Prerequisites,
      "IsLearnerContent": IsLearnerContent,
      "recordingdetails": RecordingDetails?.toMap(),
    });
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}