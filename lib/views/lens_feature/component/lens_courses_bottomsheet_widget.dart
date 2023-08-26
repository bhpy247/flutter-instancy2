import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../models/course/data_model/CourseDTOModel.dart';
import '../../common/components/instancy_ui_actions/bottomsheet_drager.dart';
import 'course_component.dart';

class LensCoursesBottomsheetWidget extends StatefulWidget {
  final List<String> labels;
  final DraggableScrollableController? scrollController;

  const LensCoursesBottomsheetWidget({
    super.key,
    required this.labels,
    this.scrollController,
  });

  @override
  State<LensCoursesBottomsheetWidget> createState() => _LensCoursesBottomsheetWidgetState();
}

class _LensCoursesBottomsheetWidgetState extends State<LensCoursesBottomsheetWidget> {
  List<String> labels = <String>[];
  late DraggableScrollableController scrollController;

  @override
  void initState() {
    super.initState();

    labels = widget.labels;
    scrollController = widget.scrollController ?? DraggableScrollableController();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    if (widget.labels.isEmpty) return const SizedBox();

    return SafeArea(
      child: DraggableScrollableSheet(
        controller: scrollController,
        expand: false,
        initialChildSize: 0.4,
        minChildSize: .32,
        builder: (BuildContext context, ScrollController controller) {
          return ClipRRect(
            borderRadius: const BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                // sigmaX: 20.0,
                // sigmaY: 20.0,
                sigmaX: 0,
                sigmaY: 0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: themeData.colorScheme.onPrimary,
                ),
                child: SingleChildScrollView(
                  controller: controller,
                  child: Column(
                    children: [
                      const BottomSheetDragger(),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        shrinkWrap: true,
                        itemCount: labels.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CourseComponent(
                            model: CourseDTOModel(Title: labels[index]),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
