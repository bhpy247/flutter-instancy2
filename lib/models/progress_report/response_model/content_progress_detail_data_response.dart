import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';
import '../data_model/content_progress_details_content_data_model.dart.dart';
import '../data_model/content_progress_details_question_data_model.dart';
import '../data_model/content_progress_details_status_data_model.dart.dart';
import '../data_model/content_progress_details_user_data_model.dart';

class ContentProgressDetailDataResponseModel {
  List<ContentProgressDetailsQuestionDataModel> progressDetail = [];
  List<ContentProgressDetailsUserDataModel> table1 = [];
  List<ContentProgressDetailsContentDataModel> table3 = [];
  List<ContentProgressDetailsStatusDataModel> table6 = [];

  ContentProgressDetailDataResponseModel({
    required this.progressDetail,
    required this.table1,
    required this.table3,
    required this.table6,
  });

  ContentProgressDetailDataResponseModel.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> TableListMap = ParsingHelper.parseMapsListMethod<String, dynamic>(json['Table']);
    progressDetail = TableListMap.map((Map<String, dynamic> map) {
      return ContentProgressDetailsQuestionDataModel.fromJson(map);
    }).toList();

    List<Map<String, dynamic>> Table1ListMap = ParsingHelper.parseMapsListMethod<String, dynamic>(json['Table1']);
    table1 = Table1ListMap.map((Map<String, dynamic> map) {
      return ContentProgressDetailsUserDataModel.fromJson(map);
    }).toList();

    List<Map<String, dynamic>> Table3ListMap = ParsingHelper.parseMapsListMethod<String, dynamic>(json['Table3']);
    table3 = Table3ListMap.map((Map<String, dynamic> map) {
      return ContentProgressDetailsContentDataModel.fromJson(map);
    }).toList();

    List<Map<String, dynamic>> Table6ListMap = ParsingHelper.parseMapsListMethod<String, dynamic>(json['Table6']);
    table6 = Table6ListMap.map((Map<String, dynamic> map) {
      return ContentProgressDetailsStatusDataModel.fromJson(map);
    }).toList();
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "Table" : progressDetail.map((e) => e.toJson()).toList(),
      "table1" : table1.map((e) => e.toJson()).toList(),
      "Table3" : table3.map((e) => e.toJson()).toList(),
      "Table6" : table6.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}
