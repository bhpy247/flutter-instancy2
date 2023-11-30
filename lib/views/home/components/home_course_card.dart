import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../models/home/data_model/new_course_list_dto.dart';
import '../../common/components/common_loader.dart';

class HomeCourseCard extends StatelessWidget {
  final NewCourseListDTOModel courseDTO;
  final void Function(NewCourseListDTOModel)? onTap;

  const HomeCourseCard({Key? key, required this.courseDTO, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!(courseDTO);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: double.maxFinite,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: courseDTO.strThumbUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) {
                      return const CommonLoader(size: 30,);
                    },
                  ),
                ),
              ),
              // Html(data: ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.3),
                        Colors.black.withOpacity(0.7),
                      ]),
                ),
                child: Center(
                  child: Text(
                    courseDTO.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: themeData.colorScheme.onPrimary),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}