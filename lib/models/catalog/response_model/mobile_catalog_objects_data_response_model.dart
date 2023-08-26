import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';
import '../../course/data_model/mobile_lms_course_model.dart';
import '../data_model/mobile_catalog_objects_data_record_count_model.dart';

class MobileCatalogObjectsDataResponseModel {
  List<MobileCatalogObjectsDataRecordCountModel> table = [];
  List<MobileLmsCourseModel> table2 = <MobileLmsCourseModel>[];

  MobileCatalogObjectsDataResponseModel({
    List<MobileCatalogObjectsDataRecordCountModel>? table,
    List<MobileLmsCourseModel>? table2,
  }) {
    this.table = table ?? <MobileCatalogObjectsDataRecordCountModel>[];
    this.table2 = table2 ?? <MobileLmsCourseModel>[];
  }

  MobileCatalogObjectsDataResponseModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    List<Map<String, dynamic>> tableMapsList = ParsingHelper.parseMapsListMethod(map['table']);
    table = tableMapsList.map((e) {
      return MobileCatalogObjectsDataRecordCountModel.fromMap(e);
    }).toList();

    List<Map<String, dynamic>> courseMapsList = ParsingHelper.parseMapsListMethod(map['table2']);
    table2 = courseMapsList.map((e) {
      return MobileLmsCourseModel.fromMap(e);
    }).toList();
  }

  Map<String, dynamic> toMap({bool toJson = true}) {
    return <String, dynamic>{
      "table": table.map((e) => e.toMap(toJson: toJson)).toList(),
      "table2": table2.map((e) => e.toMap(toJson: toJson)).toList(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}
