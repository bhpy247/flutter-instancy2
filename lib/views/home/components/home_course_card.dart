import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/configurations/app_configuration_operations.dart';
import 'package:flutter_instancy_2/views/common/components/common_cached_network_image.dart';
import 'package:provider/provider.dart';

import '../../../models/home/data_model/new_course_list_dto.dart';

class HomeCourseCard extends StatelessWidget {
  final NewCourseListDTOModel courseDTO;
  final void Function(NewCourseListDTOModel)? onTap;

  const HomeCourseCard({Key? key, required this.courseDTO, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    String imageUrl = AppConfigurationOperations(appProvider: context.read<AppProvider>()).getInstancyImageUrlFromImagePath(imagePath: courseDTO.strThumbUrl);
    // MyPrint.printOnConsole("HomeCourseCard imageUrl:$imageUrl");

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
                  child: CommonCachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
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