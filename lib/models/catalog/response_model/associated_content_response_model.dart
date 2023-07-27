import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';
import '../data_model/associated_content_course_dto_model.dart';

class AssociatedContentResponseModel {
  List<AssociatedContentCourseDTOModel> CourseList = <AssociatedContentCourseDTOModel>[];
  AssociatedContentCourseDTOModel Parentcontent = AssociatedContentCourseDTOModel();
  String title = "";
  String CurrencySign = "";
  String Eventdateisnotavailablemsg = "";
  bool EnableEcommerce = false;

  AssociatedContentResponseModel({
    List<AssociatedContentCourseDTOModel>? CourseList,
    AssociatedContentCourseDTOModel? Parentcontent,
    this.title = "",
    this.CurrencySign = "",
    this.Eventdateisnotavailablemsg = "",
    this.EnableEcommerce = false,
  }) {
    this.CourseList = CourseList ?? <AssociatedContentCourseDTOModel>[];
    this.Parentcontent = Parentcontent ?? AssociatedContentCourseDTOModel();
  }

  AssociatedContentResponseModel.fromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void updateFromJson(Map<String, dynamic> map) {
    _initializeFromJson(map);
  }

  void _initializeFromJson(Map<String, dynamic> map) {
    List<Map<String, dynamic>> courseMapsList = ParsingHelper.parseMapsListMethod(map['CourseList']);
    CourseList = courseMapsList.map((e) {
      return AssociatedContentCourseDTOModel.fromJson(e);
    }).toList();

    Map<String, dynamic> ParentcontentMap = ParsingHelper.parseMapMethod(map['Parentcontent']);
    Parentcontent = AssociatedContentCourseDTOModel.fromJson(ParentcontentMap);

    title = ParsingHelper.parseStringMethod(map['title']);
    CurrencySign = ParsingHelper.parseStringMethod(map['CurrencySign']);
    Eventdateisnotavailablemsg = ParsingHelper.parseStringMethod(map['Eventdateisnotavailablemsg']);
    EnableEcommerce = ParsingHelper.parseBoolMethod(map['EnableEcommerce']);
  }

  Map<String, dynamic> toJson({bool toJson = false}) {
    return <String, dynamic>{
      "CourseList": CourseList.map((e) => e.toJson()).toList(),
      "Parentcontent": Parentcontent.toJson(),
      "title": title,
      "CurrencySign": CurrencySign,
      "Eventdateisnotavailablemsg": Eventdateisnotavailablemsg,
      "EnableEcommerce": EnableEcommerce,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toJson(toJson: true));
  }
}

