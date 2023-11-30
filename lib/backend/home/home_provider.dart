import 'package:flutter_instancy_2/backend/common/common_provider.dart';
import 'package:flutter_instancy_2/models/home/data_model/web_list_data_dto.dart';

import '../../models/home/data_model/new_course_list_dto.dart';
import '../../models/home/response_model/banner_web_list_model.dart';
import '../../models/home/response_model/static_web_page_podel.dart';
import '../../utils/my_print.dart';

class HomeProvider extends CommonProvider {
  HomeProvider() {
    webListDataDto = CommonProviderPrimitiveParameter<WebListDataDTO?>(
      value: WebListDataDTO(),
      notify: notify,
    );
  }

  late final CommonProviderPrimitiveParameter<WebListDataDTO?> webListDataDto;

  //region New Learning Resources List
  final List<NewCourseListDTOModel> _newLearningResourcesList = [];

  List<NewCourseListDTOModel> get newLearningResourcesList => _newLearningResourcesList;

  void setNewLearningResourcesList({required List<NewCourseListDTOModel> list, bool isNotify = true}) {
    _newLearningResourcesList.clear();
    list.forEach((element) {
      _newLearningResourcesList.add(NewCourseListDTOModel.fromJson(element.toMap()));
    });
    MyPrint.printOnConsole("HomeProvider().setListCourseDTOsetListCourseDTO(): ${_newLearningResourcesList.length}");
    if(isNotify)notifyListeners();
  }
  //endregion

  //region Popular Courses List
  final List<NewCourseListDTOModel> _popularCourses = [];

  List<NewCourseListDTOModel> get popularCourses => _popularCourses;

  void setListPopularCourseDTO ({required List<NewCourseListDTOModel> list, bool isNotify = true}) {
    _popularCourses.clear();
    list.forEach((element) {
      _popularCourses.add(NewCourseListDTOModel.fromJson(element.toMap()));
    });
    MyPrint.printOnConsole("setListCourseDTOsetListCourseDTO: ${_popularCourses.length}");
    if(isNotify)notifyListeners();
  }
  //endregion

  //region Recommended CoursesList
  final List<NewCourseListDTOModel> _recommendedCourses = [];

  List<NewCourseListDTOModel> get recommendedCourseList => _recommendedCourses;

  void setRecommendedCourseDTO({required List<NewCourseListDTOModel> list, bool isNotify = true}) {
    _recommendedCourses.clear();
    list.forEach((element) {
      _recommendedCourses.add(NewCourseListDTOModel.fromJson(element.toMap()));
    });
    MyPrint.printOnConsole("setListCourseDTOsetListCourseDTO: ${_recommendedCourses.length}");
    if (isNotify) notifyListeners();
  }

  //endregion

  //region Banner List
  final List<WebListDTO> _bannerList = [];

  List<WebListDTO> get bannerList => _bannerList;

  void setBannerList({required List<WebListDTO> list, bool isNotify = true}) {
    _bannerList.clear();
    list.forEach((element) {
      _bannerList.add(WebListDTO.fromJson(element.toJson()));
    });
    MyPrint.printOnConsole("setListCourseDTOsetListCourseDTO: ${_bannerList.length}");
    if (isNotify) notifyListeners();
  }
  //endregion

  //region StaticWebPageModel
  StaticWebPageModel _staticWebPageModel = StaticWebPageModel();

  StaticWebPageModel get staticWebPageModel => _staticWebPageModel;

  void setStaticWebPage({required StaticWebPageModel staticWebPageModel, bool isNotify = true}){
    _staticWebPageModel = staticWebPageModel;
    if(isNotify) notifyListeners();
  }
  //endregion

  void resetData() {
    setNewLearningResourcesList(list: [], isNotify: false);
    setListPopularCourseDTO(list: [], isNotify: false);
    setRecommendedCourseDTO(list: [], isNotify: false);
    setBannerList(list: [], isNotify: false);
    setStaticWebPage(staticWebPageModel: StaticWebPageModel(), isNotify: true);
  }
}