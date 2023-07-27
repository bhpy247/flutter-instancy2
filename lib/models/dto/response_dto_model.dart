import '../../utils/my_utils.dart';
import '../../utils/parsing_helper.dart';
import '../catalog/data_model/catalog_course_dto_model.dart';
import '../content_details/data_model/content_details_dto_model.dart';
import 'global_search_course_dto_model.dart';

class ResponseDTOModel {
  String Message = "";
  String AutoLaunchURL = "";
  String SelfScheduleEventID = "";
  String NotiFyMsg = "";
  bool IsSuccess = false;
  CatalogCourseDTOModel? CourseObject;
  GlobalSearchCourseDTOModel? SearchObject;
  ContentDetailsDTOModel? DetailsObject;

  ResponseDTOModel({
    this.Message = "",
    this.AutoLaunchURL = "",
    this.SelfScheduleEventID = "",
    this.NotiFyMsg = "",
    this.IsSuccess = false,
    this.CourseObject,
    this.SearchObject,
    this.DetailsObject,
  });

  ResponseDTOModel.fromJson(Map<String, dynamic> json) {
    _initializeFromJson(json);
  }

  void updateFromJson(Map<String, dynamic> json) {
    _initializeFromJson(json);
  }

  void _initializeFromJson(Map<String, dynamic> json) {
    Message = ParsingHelper.parseStringMethod(json["Message"]);
    AutoLaunchURL = ParsingHelper.parseStringMethod(json["AutoLaunchURL"]);
    SelfScheduleEventID = ParsingHelper.parseStringMethod(json["SelfScheduleEventID"]);
    NotiFyMsg = ParsingHelper.parseStringMethod(json["NotiFyMsg"]);
    IsSuccess = ParsingHelper.parseBoolMethod(json['IsSuccess']);

    Map<String, dynamic> CourseObjectMap = ParsingHelper.parseMapMethod(json['CourseObject']);
    if(CourseObjectMap.isNotEmpty) {
      CourseObject = CatalogCourseDTOModel.fromMap(CourseObjectMap);
    }

    Map<String, dynamic> SearchObjectMap = ParsingHelper.parseMapMethod(json['SearchObject']);
    if(SearchObjectMap.isNotEmpty) {
      SearchObject = GlobalSearchCourseDTOModel.fromMap(SearchObjectMap);
    }

    Map<String, dynamic> DetailsObjectMap = ParsingHelper.parseMapMethod(json['DetailsObject']);
    if(DetailsObjectMap.isNotEmpty) {
      DetailsObject = ContentDetailsDTOModel.fromJson(DetailsObjectMap);
    }
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "Message" : Message,
      "AutoLaunchURL" : AutoLaunchURL,
      "SelfScheduleEventID" : SelfScheduleEventID,
      "NotiFyMsg" : NotiFyMsg,
      "IsSuccess": IsSuccess,
      "CourseObject": CourseObject?.toMap(),
      "SearchObject": SearchObject?.toMap(),
      "DetailsObject": DetailsObject?.toMap(),
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson());
  }
}