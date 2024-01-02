import 'package:flutter_instancy_2/models/event_track/data_model/bookmark_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/track_dto_model.dart';
import 'package:flutter_instancy_2/models/event_track/data_model/workflow_rules_dto_model.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';
import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class TrackListViewDataResponseModel {
  List<TrackDTOModel> TrackListData = <TrackDTOModel>[];
  List<WorkflowRulesDTOModel> WorkflowData = <WorkflowRulesDTOModel>[];
  List<BookmarkDTOModel> BookMarkData = <BookmarkDTOModel>[];
  bool ShowHideViewResume = false;

  TrackListViewDataResponseModel({
    List<TrackDTOModel>? TrackListData,
    List<WorkflowRulesDTOModel>? WorkflowData,
    List<BookmarkDTOModel>? BookMarkData,
    this.ShowHideViewResume = false,
  }) {
    this.TrackListData = TrackListData ?? <TrackDTOModel>[];
    this.WorkflowData = WorkflowData ?? <WorkflowRulesDTOModel>[];
    this.BookMarkData = BookMarkData ?? <BookmarkDTOModel>[];
  }

  TrackListViewDataResponseModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    TrackListData.clear();
    List<Map<String, dynamic>> TrackListDataMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(map["TrackListData"]);
    TrackListData.addAll(TrackListDataMapsList.map((e) => TrackDTOModel.fromMap(e)));

    WorkflowData.clear();
    List<Map<String, dynamic>> WorkflowDataMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(map["WorkflowData"]);
    WorkflowData.addAll(WorkflowDataMapsList.map((e) => WorkflowRulesDTOModel.fromMap(e)));

    BookMarkData.clear();
    List<Map<String, dynamic>> BookMarkDataMapsList = ParsingHelper.parseMapsListMethod<String, dynamic>(map["BookMarkData"]);
    BookMarkData.addAll(BookMarkDataMapsList.map((e) => BookmarkDTOModel.fromMap(e)));

    ShowHideViewResume = ParsingHelper.parseBoolMethod(map["ShowHideViewResume"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "TrackListData": TrackListData.map((e) => e.toMap()).toList(),
      "WorkflowData": WorkflowData.map((e) => e.toMap()).toList(),
      "BookMarkData": BookMarkData.map((e) => e.toMap()).toList(),
      "ShowHideViewResume": ShowHideViewResume,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap());
  }
}
