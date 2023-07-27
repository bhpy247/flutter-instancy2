import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';
import 'event_track_content_model.dart';

class TrackBlockModel {
  String blockid = "";
  String blockname = "";
  List<EventTrackContentModel> contents = <EventTrackContentModel>[];

  TrackBlockModel({
    this.blockid = "",
    this.blockname = "",
  });

  TrackBlockModel.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> json) {
    blockid = ParsingHelper.parseStringMethod(json["blockid"]);
    blockname = ParsingHelper.parseStringMethod(json["blockname"]);
  }

  Map<String, dynamic> toJson({bool toJson = false}) {
    return <String, dynamic>{
      "blockid": blockid,
      "blockname": blockname,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson(toJson: true));
  }
}

