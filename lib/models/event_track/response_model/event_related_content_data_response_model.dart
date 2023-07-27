import 'package:flutter_instancy_2/models/event_track/data_model/event_track_content_model.dart';

import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class EventRelatedContentDataResponseModel {
  List<EventTrackContentModel> eventrelatedcontentdata = <EventTrackContentModel>[];

  EventRelatedContentDataResponseModel({
    List<EventTrackContentModel>? eventrelatedcontentdata,
  }) {
    this.eventrelatedcontentdata = eventrelatedcontentdata ?? <EventTrackContentModel>[];
  }

  EventRelatedContentDataResponseModel.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> eventrelatedcontentdataMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(json['eventrelatedcontentdata']);
    if (eventrelatedcontentdataMapsList.isNotEmpty) eventrelatedcontentdata = eventrelatedcontentdataMapsList.map((e) => EventTrackContentModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson({bool toJson = false}) {
    return <String, dynamic>{
      "eventrelatedcontentdata": eventrelatedcontentdata.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson(toJson: true));
  }
}


