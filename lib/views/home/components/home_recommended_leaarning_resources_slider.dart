import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/home/home_controller.dart';
import 'package:flutter_instancy_2/backend/home/home_provider.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:flutter_instancy_2/views/home/components/home_course_list_carousel.dart';
import 'package:provider/provider.dart';

import '../../../backend/navigation/navigation_arguments.dart';
import '../../../backend/navigation/navigation_controller.dart';
import '../../../backend/navigation/navigation_operation_parameters.dart';
import '../../../backend/navigation/navigation_type.dart';
import '../../../configs/app_constants.dart';
import '../../../models/home/data_model/new_course_list_dto.dart';
import '../../../utils/my_print.dart';
import 'header_with_seeall_widget.dart';

class HomeRecommendedLearningResourcesSlider extends StatefulWidget {
  final HomeProvider homeProvider;
  final int componentId, componentInstanceId;

  const HomeRecommendedLearningResourcesSlider({
    Key? key,
    required this.homeProvider,
    required this.componentId,
    required this.componentInstanceId,
  }) : super(key: key);

  @override
  State<HomeRecommendedLearningResourcesSlider> createState() => _HomeRecommendedLearningResourcesSliderState();
}

class _HomeRecommendedLearningResourcesSliderState extends State<HomeRecommendedLearningResourcesSlider> {
  late HomeProvider homeProvider;
  late HomeController homeController;
  int componentId = 0, componentInstanceId = 0;

  Future<void>? futureGetData;

  void initializations() {
    homeProvider = widget.homeProvider;
    homeController = HomeController(homeProvider: homeProvider);

    componentId = widget.componentId;
    componentInstanceId = widget.componentInstanceId;

    if (homeProvider.recommendedCourseList.isNotEmpty) {
      futureGetData = null;
    } else {
      futureGetData = getFutureData();
    }
  }

  Future<void> getFutureData() async {
    await homeController.getRecommendedCourseListMain(
      componentId: componentId,
      componentInstanceId: componentInstanceId,
      isGetFromCache: true,
    );
  }

  @override
  void initState() {
    super.initState();

    initializations();
  }

  @override
  void didUpdateWidget(covariant HomeRecommendedLearningResourcesSlider oldWidget) {
    if (widget.homeProvider != homeProvider || widget.componentId != componentId || widget.componentInstanceId != componentInstanceId) {
      initializations();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeProvider>.value(
      value: homeProvider,
      child: Consumer<HomeProvider>(builder: (BuildContext context, HomeProvider homeProvider, Widget? child) {
        return SizedBox(
          height: 220,
          width: double.infinity,
          child: HeaderWithSeeAllWidget(
            title: "Recommended Learning resources",
            isSeeAll: true,
            onSeeAllTap: () {
              NavigationController.navigateToCatalogContentsListScreen(
                navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
                arguments: CatalogContentsListScreenNavigationArguments(
                  componentInstanceId: InstancyComponents.CatalogComponentInsId,
                  componentId: InstancyComponents.Catalog,
                  HomeComponentId: InstancyComponents.RecommendedLearningResources,
                  isPinnedContent: false,
                ),
              );
            },
            child: SizedBox(
              height: 220,
              width: double.infinity,
              child: futureGetData != null
                  ? FutureBuilder(
                      future: futureGetData,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          MyPrint.printOnConsole("Recommended Learning length:${homeProvider.popularCourses.length}");

                          return getCoursesSlider(
                            list: homeProvider.recommendedCourseList,
                          );
                        } else {
                          return const Center(child: CommonLoader());
                        }
                      })
                  : getCoursesSlider(
                      list: homeProvider.recommendedCourseList,
                    ),
            ),
          ),
        );
      }),
    );
  }

  Widget getCoursesSlider({required List<NewCourseListDTOModel> list}) {
    return HomeCourseListCarousel(
      list: list,
      componentId: componentId,
      componentInstanceId: componentInstanceId,
      userId: homeController.homeRepository.apiController.apiDataProvider.getCurrentUserId(),
    );
  }
}
