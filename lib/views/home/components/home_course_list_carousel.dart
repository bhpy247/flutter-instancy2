import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/views/home/components/home_course_card.dart';

import '../../../models/home/data_model/new_course_list_dto.dart';

class HomeCourseListCarousel extends StatelessWidget {
  final List<NewCourseListDTOModel> list;

  const HomeCourseListCarousel({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(list.isEmpty) {
      return const Center(
        child:Text(
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
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index, int pageViewIndex) {
          return HomeCourseCard(
            courseDTO: list[index],
            onTap: (NewCourseListDTOModel courseDTO) async {

            },
          );
        },
    );
  }
}
