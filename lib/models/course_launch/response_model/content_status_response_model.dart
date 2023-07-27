import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';
import '../data_model/content_status_model.dart';

class ContentStatusResponseModel {
  List<ContentStatusModel> contentstatus = <ContentStatusModel>[];

  ContentStatusResponseModel({
    List<ContentStatusModel>? contentstatus,
  }) {
    this.contentstatus = contentstatus ?? <ContentStatusModel>[];
  }

  ContentStatusResponseModel.fromJson(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    List<Map<String, dynamic>> courseMapsList = ParsingHelper.parseMapsListMethod(map['contentstatus']);
    contentstatus = courseMapsList.map((e) {
      return ContentStatusModel.fromMap(e);
    }).toList();
  }

  Map<String, dynamic> toJson({bool toJson = false}) {
    return <String, dynamic>{
      "contentstatus" : contentstatus.map((e) => e.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson(toJson: true));
  }
}