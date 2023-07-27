import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/home/home_controller.dart';
import 'package:flutter_instancy_2/backend/home/home_provider.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
import 'package:flutter_instancy_2/views/home/components/home_course_list_carousel.dart';
import 'package:provider/provider.dart';

import '../../../models/home/data_model/new_course_list_dto.dart';
import '../../../utils/my_print.dart';
import 'header_with_seeall_widget.dart';

class HomePopularLearningResourcesSlider extends StatefulWidget {
  final HomeProvider homeProvider;
  final int componentId, componentInstanceId;

  const HomePopularLearningResourcesSlider({
    Key? key,
    required this.homeProvider,
    required this.componentId,
    required this.componentInstanceId,
  }) : super(key: key);

  @override
  State<HomePopularLearningResourcesSlider> createState() => _HomePopularLearningResourcesSliderState();
}

class _HomePopularLearningResourcesSliderState extends State<HomePopularLearningResourcesSlider> {
  late HomeProvider homeProvider;
  late HomeController homeController;
  int componentId = 0, componentInstanceId = 0;

  Future<void>? futureGetData;

  void initializations() {
    homeProvider = widget.homeProvider;
    homeController = HomeController(homeProvider: homeProvider);

    componentId = widget.componentId;
    componentInstanceId = widget.componentInstanceId;

    if(homeProvider.newLearningResourcesList.isNotEmpty) {
      futureGetData = null;
    }
    else {
      futureGetData = getFutureData();
    }
  }

  Future<void> getFutureData() async {
    await homeController.getPopularLearningResourcesListMain(
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
  void didUpdateWidget(covariant HomePopularLearningResourcesSlider oldWidget) {
    if(widget.homeProvider != homeProvider || widget.componentId != componentId  || widget.componentInstanceId != componentInstanceId) {
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
      child: Consumer<HomeProvider>(
        builder: (BuildContext context, HomeProvider homeProvider, Widget? child) {
          return SizedBox(
            height: 220,
            width: double.infinity,
            child: HeaderWithSeeAllWidget(
              title: "Popular Learning resources",
              isSeeAll: true,
              child: SizedBox(
                height: 220,
                width: double.infinity,
                child: futureGetData != null ? FutureBuilder(
                  future: futureGetData,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if(snapshot.connectionState == ConnectionState.done) {
                      MyPrint.printOnConsole("Popular Learning length:${homeProvider.popularCourses.length}");

                      return getCoursesSlider(list: homeProvider.popularCourses,);
                    }
                    else {
                      return const Center(child: CommonLoader());
                    }
                  }
                ) : getCoursesSlider(list: homeProvider.popularCourses,),
              ),
            ),
          );
        }
      ),
    );
  }

  Widget getCoursesSlider({required List<NewCourseListDTOModel> list}) {
    return HomeCourseListCarousel(list: list);
  }
}
