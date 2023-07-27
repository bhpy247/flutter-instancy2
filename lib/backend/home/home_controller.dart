import 'package:flutter_instancy_2/backend/home/home_provider.dart';
import 'package:flutter_instancy_2/backend/home/home_repository.dart';
import 'package:flutter_instancy_2/utils/my_utils.dart';

import '../../api/api_controller.dart';
import '../../models/common/data_response_model.dart';
import '../../models/home/response_model/categorywise_course_dto_model.dart';
import '../../models/home/response_model/static_web_page_podel.dart';
import '../../utils/my_print.dart';

class HomeController {
  final HomeProvider homeProvider;
  late HomeRepository homeRepository;

  HomeController({required this.homeProvider, HomeRepository? repository, ApiController? apiController}) {
    homeRepository = repository ?? HomeRepository(apiController: apiController ?? ApiController());
  }

  //region NewLearningResourcesList
  Future<void> getNewLearningResourcesListMain({bool isGetFromCache = false, required int componentId, required int componentInstanceId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("HomeController().getNewLearningResourcesListMain() called with isGetFromCache:$isGetFromCache, componentId:$componentId, "
        "componentInstanceId:$componentInstanceId", tag: tag);

    if(isGetFromCache) {
      await getNewLearningResourcesList(isGetFromCache: true, componentId: componentId, componentInstanceId: componentInstanceId);

      if(homeProvider.newLearningResourcesList.isNotEmpty) {
        getNewLearningResourcesList(isGetFromCache: false, componentId: componentId, componentInstanceId: componentInstanceId);
      }
      else {
        await getNewLearningResourcesList(isGetFromCache: false, componentId: componentId, componentInstanceId: componentInstanceId);
      }
    }
    else {
      await getNewLearningResourcesList(isGetFromCache: false, componentId: componentId, componentInstanceId: componentInstanceId);
    }
  }

  Future<void> getNewLearningResourcesList({bool isGetFromCache = false, required int componentId, required int componentInstanceId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("HomeController().getNewLearningResourcesList() called with isGetFromCache:$isGetFromCache, componentId:$componentId, "
        "componentInstanceId:$componentInstanceId", tag: tag);

    DataResponseModel<CategoryWiseCourseDTOResponseModel> response = await homeRepository.getNewResourceList(
      componentId: componentId,
      componentInstanceId: componentInstanceId,
      isStoreDataInHive: !isGetFromCache,
      isFromOffline: isGetFromCache,
    );
    MyPrint.printOnConsole("New Learning Resources Length:${response.data?.courseDTO.length ?? 0}", tag: tag);

    if(response.data != null) {
      homeProvider.setNewLearningResourcesList(list: response.data!.courseDTO);
    }
  }
  //endregion

  //region PopularLearningResourcesList
  Future<void> getPopularLearningResourcesListMain({bool isGetFromCache = false, required int componentId, required int componentInstanceId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("HomeController().getPopularLearningResourcesListMain() called with isGetFromCache:$isGetFromCache, componentId:$componentId, "
        "componentInstanceId:$componentInstanceId", tag: tag);

    if(isGetFromCache) {
      await getPopularLearningResourcesList(isGetFromCache: true, componentId: componentId, componentInstanceId: componentInstanceId);

      if(homeProvider.popularCourses.isNotEmpty) {
        getPopularLearningResourcesList(isGetFromCache: false, componentId: componentId, componentInstanceId: componentInstanceId);
      }
      else {
        await getPopularLearningResourcesList(isGetFromCache: false, componentId: componentId, componentInstanceId: componentInstanceId);
      }
    }
    else {
      await getPopularLearningResourcesList(isGetFromCache: false, componentId: componentId, componentInstanceId: componentInstanceId);
    }
  }

  Future<void> getPopularLearningResourcesList({bool isGetFromCache = false, required int componentId, required int componentInstanceId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("HomeController().getPopularLearningResourcesList() called with isGetFromCache:$isGetFromCache, componentId:$componentId, "
        "componentInstanceId:$componentInstanceId", tag: tag);

    DataResponseModel<CategoryWiseCourseDTOResponseModel> response = await homeRepository.getNewResourceList(
      componentId: componentId,
      componentInstanceId: componentInstanceId,
      isStoreDataInHive: !isGetFromCache,
      isFromOffline: isGetFromCache,
    );
    MyPrint.printOnConsole("Popular Learning Resources Length:${response.data?.courseDTO.length ?? 0}", tag: tag);

    if(response.data != null) {
      homeProvider.setListPopularCourseDTO(list: response.data!.courseDTO);
    }
  }
  //endregion

  //region RecommendedCourseList
  Future<void> getRecommendedCourseListMain({bool isGetFromCache = false, required int componentId, required int componentInstanceId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("HomeController().getRecommendedCourseListMain() called with isGetFromCache:$isGetFromCache, componentId:$componentId, "
        "componentInstanceId:$componentInstanceId", tag: tag);

    if(isGetFromCache) {
      await getRecommendedCourseList(isGetFromCache: true, componentId: componentId, componentInstanceId: componentInstanceId);

      if(homeProvider.recommendedCourseList.isNotEmpty) {
        getRecommendedCourseList(isGetFromCache: false, componentId: componentId, componentInstanceId: componentInstanceId);
      }
      else {
        await getRecommendedCourseList(isGetFromCache: false, componentId: componentId, componentInstanceId: componentInstanceId);
      }
    }
    else {
      await getRecommendedCourseList(isGetFromCache: false, componentId: componentId, componentInstanceId: componentInstanceId);
    }
  }

  Future<void> getRecommendedCourseList({bool isGetFromCache = false, required int componentId, required int componentInstanceId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("HomeController().getRecommendedCourseList() called with isGetFromCache:$isGetFromCache, componentId:$componentId, "
        "componentInstanceId:$componentInstanceId", tag: tag);

    DataResponseModel<CategoryWiseCourseDTOResponseModel> response = await homeRepository.getRecommendedCourseList(
      componentId: componentId,
      componentInstanceId: componentInstanceId,
      isStoreDataInHive: !isGetFromCache,
      isFromOffline: isGetFromCache,
    );
    MyPrint.printOnConsole("Recommended Learning Resources Length:${response.data?.courseDTO.length ?? 0}", tag: tag);

    if(response.data != null) {
      homeProvider.setRecommendedCourseDTO(list: response.data!.courseDTO);
    }
  }
  //endregion

  Future<void> getStaticWebPage({bool isGetFromCache = false, int componentId = 0, int componentInstanceId = 0}) async {
    MyPrint.printOnConsole("HomeController().getStaticWebPage() called with isGetFromCache:$isGetFromCache, componentId:$componentId, "
        "componentInstanceId:$componentInstanceId");

    if(isGetFromCache) {
      return;
    }
    DataResponseModel<StaticWebPageModel> response = await homeRepository.getStaticWebPages(
      componentId: componentId,
      componentInstanceId: componentInstanceId,
    );
    if(response.data != null) {
      homeProvider.setStaticWebPage(staticWebPageModel: response.data!);
    }
  }
}