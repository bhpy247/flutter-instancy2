import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class EnrollWaitingListEventResponseModel {
  bool IsSuccess = false;
  String Message = "";
  String AutoLaunchURL = "";
  String SelfScheduleEventID = "";
  String NotiFyMsg = "";
  dynamic CourseObject = "";
  dynamic SearchObject = "";
  dynamic DetailsObject = "";

  EnrollWaitingListEventResponseModel({
    this.IsSuccess = false,
    this.Message = "",
    this.AutoLaunchURL = "",
    this.SelfScheduleEventID = "",
    this.NotiFyMsg = "",
    this.CourseObject,
    this.SearchObject,
    this.DetailsObject,
  });

  EnrollWaitingListEventResponseModel.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> map) {
    IsSuccess = ParsingHelper.parseBoolMethod(map["IsSuccess"]);
    Message = ParsingHelper.parseStringMethod(map["Message"]);
    AutoLaunchURL = ParsingHelper.parseStringMethod(map["AutoLaunchURL"]);
    SelfScheduleEventID = ParsingHelper.parseStringMethod(map["SelfScheduleEventID"]);
    NotiFyMsg = ParsingHelper.parseStringMethod(map["NotiFyMsg"]);
    CourseObject = map["CourseObject"];
    SearchObject = map["SearchObject"];
    DetailsObject = map["DetailsObject"];
  }

  Map<String, dynamic> toJson({bool toJson = false}) {
    return <String, dynamic>{
      "IsSuccess": IsSuccess,
      "Message": Message,
      "AutoLaunchURL": AutoLaunchURL,
      "SelfScheduleEventID": SelfScheduleEventID,
      "NotiFyMsg": NotiFyMsg,
      "CourseObject": CourseObject,
      "SearchObject": SearchObject,
      "DetailsObject": DetailsObject,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson(toJson: true));
  }
}
