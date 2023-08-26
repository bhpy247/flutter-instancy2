import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class MobileCatalogObjectsDataRecordCountModel {
  int totalrecordscount = 0;

  MobileCatalogObjectsDataRecordCountModel({
    this.totalrecordscount = 0,
  });

  MobileCatalogObjectsDataRecordCountModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    totalrecordscount = ParsingHelper.parseIntMethod(map['totalrecordscount']);
  }

  Map<String, dynamic> toMap({bool toJson = true}) {
    return <String, dynamic>{
      "totalrecordscount": totalrecordscount,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}
