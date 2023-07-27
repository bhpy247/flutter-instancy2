import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';
import '../data_model/event_track_reference_item_model.dart';

class EventTrackResourceResponseModel {
  References? references;

  EventTrackResourceResponseModel({
    this.references,
  });

  EventTrackResourceResponseModel.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> json) {
    Map<String, dynamic> referencesMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(json['references']);
    if (referencesMap.isNotEmpty) references = References.fromJson(referencesMap);
  }

  Map<String, dynamic> toJson({bool toJson = false}) {
    return <String, dynamic>{
      "references": references?.toJson(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson(toJson: true));
  }
}

class References {
  String title = "";
  List<EventTrackReferenceItemModel> referenceItem = [];

  References({
    this.title = "",
    required this.referenceItem,
  });

  References.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> json) {
    title = ParsingHelper.parseStringMethod(json["title"]);

    List<Map<String, dynamic>> referenceItemsMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(json["referenceItem"]);
    referenceItem = referenceItemsMapsList.map((e) => EventTrackReferenceItemModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson({bool toJson = false}) {
    return <String, dynamic>{
      "title": title,
      "referenceItem": referenceItem.map((x) => x.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson(toJson: true));
  }
}


