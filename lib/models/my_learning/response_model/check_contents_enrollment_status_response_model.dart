import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class CheckContentsEnrollmentStatusResponseModel {
  Map<String, CheckContentsEnrollmentStatusContentDataModel> CourseData = <String, CheckContentsEnrollmentStatusContentDataModel>{};

  CheckContentsEnrollmentStatusResponseModel({
    Map<String, CheckContentsEnrollmentStatusContentDataModel>? CourseData,
  }) {
    this.CourseData = CourseData ?? <String, CheckContentsEnrollmentStatusContentDataModel>{};
  }

  CheckContentsEnrollmentStatusResponseModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    CourseData.clear();
    map.forEach((String contentId, dynamic contentDataValue) {
      Map<String, dynamic> contentDataMap = ParsingHelper.parseMapMethod<dynamic, dynamic, String, dynamic>(contentDataValue);
      if (contentDataMap.isNotEmpty) {
        CheckContentsEnrollmentStatusContentDataModel contentDataModel = CheckContentsEnrollmentStatusContentDataModel.fromMap(contentDataMap);
        CourseData[contentId] = contentDataModel;
      }
    });
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return CourseData.map((key, value) => MapEntry(key, value.toMap(toJson: toJson)));
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}

class CheckContentsEnrollmentStatusContentDataModel {
  String ModifiedDate = "";

  CheckContentsEnrollmentStatusContentDataModel({
    this.ModifiedDate = "",
  });

  CheckContentsEnrollmentStatusContentDataModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    ModifiedDate = ParsingHelper.parseStringMethod(map['ModifiedDate']);
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return <String, dynamic>{
      "ModifiedDate": ModifiedDate,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}
