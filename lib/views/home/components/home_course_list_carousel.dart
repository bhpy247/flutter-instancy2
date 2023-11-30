import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation.dart';
import 'package:flutter_instancy_2/views/home/components/home_course_card.dart';

import '../../../models/home/data_model/new_course_list_dto.dart';
import '../../../utils/my_print.dart';

class HomeCourseListCarousel extends StatefulWidget {
  final List<NewCourseListDTOModel> list;
  final int componentId, componentInstanceId, userId;

  const HomeCourseListCarousel({Key? key, required this.list, required this.componentId, required this.componentInstanceId, required this.userId}) : super(key: key);

  @override
  State<HomeCourseListCarousel> createState() => _HomeCourseListCarouselState();
}

class _HomeCourseListCarouselState extends State<HomeCourseListCarousel> {
  @override
  Widget build(BuildContext context) {
    if (widget.list.isEmpty) {
      return const Center(
        child: Text(
          "No Data",
          style: TextStyle(color: Colors.black),
        ),
      );
    }

    return CarouselSlider.builder(
      options: CarouselOptions(
        autoPlay: false,
        enableInfiniteScroll: false,
        enlargeCenterPage: false,
        initialPage: 0,
        viewportFraction: 0.5,
        aspectRatio: 1.2,
        padEnds: false,
        // initialPage: 2,
      ),
      itemCount: widget.list.length,
      itemBuilder: (BuildContext context2, int index, int pageViewIndex) {
        return HomeCourseCard(
          courseDTO: widget.list[index],
          onTap: (NewCourseListDTOModel model) async {
            MyPrint.printOnConsole("componentId: ${widget.componentId} componentInstanceId: ${widget.componentInstanceId} apiUrlConfigurationProvider.getCurrentUserId(): ${widget.userId}");
            NavigationController.navigateToCourseDetailScreen(
                navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
                arguments: CourseDetailScreenNavigationArguments(
                  contentId: model.contentID,
                  componentId: widget.componentId,
                  componentInstanceId: widget.componentInstanceId,
                  userId: widget.userId,
                ));
          },
        );
      },
    );
  }
}
