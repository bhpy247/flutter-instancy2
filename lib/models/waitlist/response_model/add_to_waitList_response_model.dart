import 'package:flutter_chat_bot/utils/parsing_helper.dart';

class AddToWaitListResponseModel {
  bool isSuccess = false;
  String message = "";
  String autoLaunchURL = "";
  String selfScheduleEventID = "";
  String courseObject = "";
  String searchObject = "";
  String detailsObject = "";
  String notiFyMsg = "";

  AddToWaitListResponseModel(
      {this.isSuccess = false,
      this.message = "",
      this.autoLaunchURL = "",
      this.selfScheduleEventID = "",
      this.courseObject = "",
      this.searchObject = "",
      this.detailsObject = "",
      this.notiFyMsg = ""});

  AddToWaitListResponseModel.fromJson(Map<String, dynamic> json) {
    isSuccess = ParsingHelper.parseBoolMethod(json['IsSuccess']);
    message = ParsingHelper.parseStringMethod(json['Message']);
    autoLaunchURL = ParsingHelper.parseStringMethod(json['AutoLaunchURL']);
    selfScheduleEventID = ParsingHelper.parseStringMethod(json['SelfScheduleEventID']);
    courseObject = ParsingHelper.parseStringMethod(json['CourseObject']);
    searchObject = ParsingHelper.parseStringMethod(json['SearchObject']);
    detailsObject = ParsingHelper.parseStringMethod(json['DetailsObject']);
    notiFyMsg = ParsingHelper.parseStringMethod(json['NotiFyMsg']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['IsSuccess'] = isSuccess;
    data['Message'] = message;
    data['AutoLaunchURL'] = autoLaunchURL;
    data['SelfScheduleEventID'] = selfScheduleEventID;
    data['CourseObject'] = courseObject;
    data['SearchObject'] = searchObject;
    data['DetailsObject'] = detailsObject;
    data['NotiFyMsg'] = notiFyMsg;
    return data;
  }
}
