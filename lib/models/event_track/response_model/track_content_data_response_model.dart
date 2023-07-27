import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';
import '../../classroom_events/data_model/event_recodting_mobile_lms_data_model.dart';
import '../data_model/event_track_content_model.dart';
import '../data_model/track_block_model.dart';

class TrackContentDataResponseModel {
  List<EventTrackContentModel> table5 = <EventTrackContentModel>[];
  List<TrackBlockModel> table8 = <TrackBlockModel>[];
    List<EventRecordingMobileLMSDataModel> eventrecording = <EventRecordingMobileLMSDataModel>[];

  TrackContentDataResponseModel({
    List<EventTrackContentModel>? table5,
    List<TrackBlockModel>? table8,
    List<EventRecordingMobileLMSDataModel>? eventrecording,
  }) {
    this.table5 = table5 ?? <EventTrackContentModel>[];
    this.table8 = table8 ?? <TrackBlockModel>[];
    this.eventrecording = eventrecording ?? <EventRecordingMobileLMSDataModel>[];
  }

  TrackContentDataResponseModel.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> contentsMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(json['table5']);
    if (contentsMapsList.isNotEmpty) table5 = contentsMapsList.map((e) => EventTrackContentModel.fromJson(e)).toList();

    List<Map<String, dynamic>> blockMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(json['table8']);
    if (blockMapsList.isNotEmpty) table8 = blockMapsList.map((e) => TrackBlockModel.fromJson(e)).toList();

    eventrecording.clear();
    List<Map<String, dynamic>> eventrecordingMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(json['eventrecording']);
    for (Map<String, dynamic> value in eventrecordingMapsList) {
      if(value.isNotEmpty) {
        EventRecordingMobileLMSDataModel eventRecordingDataModel = EventRecordingMobileLMSDataModel.fromJson(value);
        eventrecording.add(eventRecordingDataModel);
      }
    }
  }

  Map<String, dynamic> toJson({bool toJson = false}) {
    return <String, dynamic>{
      "table5": table5.map((e) => e.toJson()).toList(),
      "table8": table8.map((e) => e.toJson()).toList(),
      "eventrecording" : eventrecording.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson(toJson: true));
  }
}
