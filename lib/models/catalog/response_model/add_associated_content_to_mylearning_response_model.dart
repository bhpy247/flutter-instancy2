import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class AddAssociatedContentToMyLearningResponseModel {
  bool result = false;
  String Message = "";

  AddAssociatedContentToMyLearningResponseModel({
    this.result = false,
    this.Message = "",
  });

  AddAssociatedContentToMyLearningResponseModel.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> map) {
    result = ParsingHelper.parseBoolMethod(map['result']);
    Message = ParsingHelper.parseStringMethod(map['Message']);
  }

  Map<String, dynamic> toJson({bool toJson = false}) {
    return <String, dynamic>{
      "result": result,
      "Message": Message,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson(toJson: true));
  }
}

