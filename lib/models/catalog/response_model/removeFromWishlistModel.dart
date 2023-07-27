import 'package:flutter_instancy_2/utils/parsing_helper.dart';

class RemoveFromWishlistResponseModel {
  String autoLaunchURL = "";
  String courseObject = "";
  String detailsObject = "";
  bool isSuccess = false;
  String message = "";
  String notiFyMsg = "";
  String searchObject = "";
  String selfScheduleEventID = "";

  RemoveFromWishlistResponseModel(
      {this.autoLaunchURL = "",
        this.courseObject = "",
        this.detailsObject = "",
        this.isSuccess = false,
        this.message = "",
        this.notiFyMsg = "",
        this.searchObject = "",
        this.selfScheduleEventID = ""});

  RemoveFromWishlistResponseModel.fromJson(Map<String, dynamic> json) {
    autoLaunchURL = ParsingHelper.parseStringMethod(json['AutoLaunchURL']);
    courseObject = ParsingHelper.parseStringMethod(json['CourseObject']);
    detailsObject = ParsingHelper.parseStringMethod(json['DetailsObject']);
    isSuccess = ParsingHelper.parseBoolMethod(json['IsSuccess']);
    message = ParsingHelper.parseStringMethod(json['Message']);
    notiFyMsg = ParsingHelper.parseStringMethod(json['NotiFyMsg']);
    searchObject = ParsingHelper.parseStringMethod(json['SearchObject']);
    selfScheduleEventID = ParsingHelper.parseStringMethod(json['SelfScheduleEventID']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AutoLaunchURL'] = autoLaunchURL;
    data['CourseObject'] = courseObject;
    data['DetailsObject'] = detailsObject;
    data['IsSuccess'] = isSuccess;
    data['Message'] = message;
    data['NotiFyMsg'] = notiFyMsg;
    data['SearchObject'] = searchObject;
    data['SelfScheduleEventID'] = selfScheduleEventID;
    return data;
  }
}
